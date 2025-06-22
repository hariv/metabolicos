datatype State = ClosedLoopML | Manual 

class BioInvar { 
  var state: State
		
  // Insulin
  ghost var insulinDosed: real
  var measuredInsulinDosed: real

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
		ghost initInsulinDosed: real, initMeasuredInsulinDosed: real, initCgmInitial: real,
	  initCgmFinal: real, initSensitivity: real, initDeltaIOB: real, initBasal: real)
    //Glucose preconditions
		requires initCgmInitial <= 1.1 * initGlucoseInitial
		requires initCgmFinal <= 1.1 * initGlucoseFinal
    requires initCgmFinal >= 40.0
		requires initGlucoseInitial <= 250.0
		
    // Insulin preconditions
    requires initDeltaIOB >= 0.0
    requires initMeasuredInsulinDosed > 0.0
		requires 0.0 <= initMeasuredInsulinDosed <= 1.01 * initInsulinDosed

    // Physiological parameters preconditions
    requires initSensitivity >= 0.0
		//requires initSensitivity > 0.0
    requires initBasal >= 0.0
    
    // Post conditions
    ensures insulinDosed == initInsulinDosed
    ensures cgmInitial  == initCgmInitial
    ensures cgmFinal == initCgmFinal
    ensures sensitivity == initSensitivity
    ensures basal == initBasal
    ensures deltaIOB == initDeltaIOB
  {

    insulinDosed := initInsulinDosed;
    measuredInsulinDosed := initMeasuredInsulinDosed;
		
    cgmInitial := initCgmInitial;
    cgmFinal := initCgmFinal;
		
    glucoseInitial := initGlucoseInitial;
    glucoseFinal := initGlucoseFinal;
		
    sensitivity := initSensitivity;
    basal := initBasal;
		
    deltaIOB := initDeltaIOB;

    new;

    var deltaCalculated := basal - (sensitivity * (deltaIOB + insulinDosed)); 

    var deltaMeasured := cgmFinal - cgmInitial;

    var deltaReal := glucoseFinal - glucoseInitial;

    var threshold := 30.0;

		var glucoseBound := 250.0;
		
    if (sensitivity >= ((basal - threshold - (0.9* cgmFinal) + glucoseBound) / (deltaIOB +
			0.99 * measuredInsulinDosed))) {
				state := ClosedLoopML;
    } else {
      state := Manual;
    }
		
    if (state == ClosedLoopML) {
			assert (deltaCalculated - deltaReal) <= threshold;
    }
  }
}
