datatype State = ClosedLoopML | Manual 

class BioInvar { 
  var state: State

	// Insulin
  var insulinDosed: real

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
		initInsulinDosed: real, initCgmInitial: real, initCgmFinal: real, initSensitivity: real,
		initDeltaIOB: real, initBasal: real)
    //Glucose perconditions
    requires 0.91 * initGlucoseInitial <= initCgmInitial <= 1.1 * initGlucoseInitial
    requires 0.91 * initGlucoseFinal <= initCgmFinal <= 1.1 * initGlucoseFinal

    // Physiological parameters preconditions
    requires initSensitivity >= 0.0
    requires initBasal >= 0.0

    // Insulin preconditions
    requires initDeltaIOB >= 0.0
    requires initInsulinDosed > 0.0

		// divide by 0 condition
		requires initBasal * 30.0 * 60.0 - (initDeltaIOB + initInsulinDosed) > 0.0
    // Post conditions
    ensures insulinDosed == initInsulinDosed
    ensures cgmInitial  == initCgmInitial
    ensures cgmFinal == initCgmFinal
    ensures sensitivity == initSensitivity
    ensures basal == initBasal
    ensures deltaIOB == initDeltaIOB
  {
    insulinDosed := initInsulinDosed;
		
    cgmInitial := initCgmInitial;
    cgmFinal := initCgmFinal;
		
    glucoseInitial := initGlucoseInitial;
    glucoseFinal := initGlucoseFinal;
		
    sensitivity := initSensitivity;
    basal := initBasal;
		
    deltaIOB := initDeltaIOB;
		
    new;

		var deltaT := 30.0 * 60.0;
    //var deltaCalculated := basal - (sensitivity * (deltaIOB + insulinDosed));
		var deltaCalculated := sensitivity * (basal * deltaT - (deltaIOB + insulinDosed));
		
    var deltaMeasured := cgmFinal - cgmInitial;
		
    var deltaReal := glucoseFinal - glucoseInitial;
		
    var threshold := 30.0;
		
    //if (sensitivity >= ((basal - threshold - (0.9 * cgmFinal) + (1.1 * cgmInitial)) / (deltaIOB +
		//	insulinDosed))) {
		if (sensitivity <= (0.9 * cgmFinal - 1.1 * cgmInitial + threshold) / (basal * deltaT -(deltaIOB + insulinDosed))) {
				state := ClosedLoopML;
    } else {
      state := Manual;
    }
		
    if (state == ClosedLoopML) {
			//assert glucoseInitial <= 1.1 * cgmInitial;
			//assert sensitivity <= (0.9 * cgmFinal - 1.1 * cgmInitial + threshold) / (basal * deltaT -(deltaIOB + insulinDosed));
			assert sensitivity * (basal * deltaT -(deltaIOB + insulinDosed)) <= (0.9 * cgmFinal - 1.1 * cgmInitial + threshold);
      assert (deltaCalculated - deltaReal) <= threshold;
    }
  }
}
