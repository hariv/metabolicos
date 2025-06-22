datatype State = ClosedLoopML | Manual 
	
function sumDoses(insulinDoses: seq<real>): real
  requires |insulinDoses| == 6
{
	insulinDoses[0] + insulinDoses[1] + insulinDoses[2] + insulinDoses[3] + insulinDoses[4] + insulinDoses[5]
}

class BioInvar { 
  var state: State
		
  // Insulin
	ghost var insulinDoses: array<real>
	var measuredInsulinDoses: array<real>

  // CGM, ie measured glucose
  var cgmInitial: real
  var cgmFinal: real

  // Real glucose
  ghost var glucoseInitial: real
  ghost var glucoseFinal: real

  var sensitivity: real
  var deltaIOB: real
  var basal: real
	
  constructor(ghost initGlucoseInitial: real, ghost initGlucoseFinal: real,
		ghost initInsulinDoses: array<real>, initMeasuredInsulinDoses: array<real>,
		initCgmInitial: real, initCgmFinal: real, initSensitivity: real, initDeltaIOB: real,
		initBasal: real)
    //Glucose preconditions
    requires 0.91 * initGlucoseInitial <= initCgmInitial <= 1.1 * initGlucoseInitial
    requires 0.91 * initGlucoseFinal <= initCgmFinal <= 1.1 * initGlucoseFinal

    // Insulin preconditions
    requires initDeltaIOB >= 0.0
		requires initMeasuredInsulinDoses.Length == 6
		requires initInsulinDoses.Length == 6
		requires forall i :: 0 <= i < 6 ==> 0.99*initInsulinDoses[i] <= initMeasuredInsulinDoses[i] <= 1.01*initInsulinDoses[i]
		requires sumDoses(initMeasuredInsulinDoses[..]) > 0.0
		
    // Physiological parameters preconditions
    requires initSensitivity > 0.0
    requires initBasal > 0.0


		// Divide by 0 condition
		requires initBasal * 30.0 * 60.0 - (initDeltaIOB + 0.99 * sumDoses(initMeasuredInsulinDoses[..])) > 0.0
    // Post conditions
    ensures insulinDoses == initInsulinDoses
    ensures cgmInitial  == initCgmInitial
    ensures cgmFinal == initCgmFinal
    ensures sensitivity == initSensitivity
    ensures basal == initBasal
    ensures deltaIOB == initDeltaIOB
  {

    insulinDoses := initInsulinDoses;
    measuredInsulinDoses := initMeasuredInsulinDoses;
		
    cgmInitial := initCgmInitial;
    cgmFinal := initCgmFinal;
		
    glucoseInitial := initGlucoseInitial;
    glucoseFinal := initGlucoseFinal;
		
    sensitivity := initSensitivity;
    basal := initBasal;
		
    deltaIOB := initDeltaIOB;

    new;

		var totalInsulinDoses := sumDoses(insulinDoses[..]);
		var totalMeasuredInsulinDoses := sumDoses(measuredInsulinDoses[..]);

		var deltaT := 30.0 * 60.0;
		var deltaCalculated := sensitivity * (basal * deltaT - (deltaIOB + totalInsulinDoses));
		//var deltaCalculated := basal - (sensitivity * (deltaIOB + totalInsulinDoses));

    var deltaMeasured := cgmFinal - cgmInitial;

    var deltaReal := glucoseFinal - glucoseInitial;

    var threshold := 30.0;
   
    //if (sensitivity >= ((basal - threshold - (0.9 * cgmFinal) + (1.1 * cgmInitial)) / (deltaIOB +
    //0.99 * totalMeasuredInsulinDoses))) {
		if (sensitivity <= (0.9 * cgmFinal - 1.1 * cgmInitial + threshold) / (basal * deltaT -(deltaIOB + 0.99 * totalMeasuredInsulinDoses))) {
       state := ClosedLoopML;
    } else {
      state := Manual;
    }

    if (state == ClosedLoopML) {
			//assert sensitivity * (deltaIOB + 0.99 * totalMeasuredInsulinDoses) >= basal - threshold - (0.9 * cgmFinal) + (1.1 * cgmInitial);
			//assert 0.99 * totalMeasuredInsulinDoses >= ((basal - threshold - (0.9 * cgmFinal) + (1.1  *cgmInitial)) / sensitivity) - deltaIOB;
			assert 0.99 * totalMeasuredInsulinDoses <= totalInsulinDoses;
			assert sensitivity <= (0.9 * cgmFinal - 1.1 * cgmInitial + threshold) / (basal * deltaT - (deltaIOB + 0.99 * totalMeasuredInsulinDoses));
			assert sensitivity * (basal * deltaT - (deltaIOB + 0.99 * totalMeasuredInsulinDoses)) <= (0.9 * cgmFinal - 1.1 * cgmInitial + threshold);
			assert (deltaCalculated - deltaReal) <= threshold;
    }
  }
}
