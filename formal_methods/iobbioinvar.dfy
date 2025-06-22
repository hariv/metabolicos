datatype State = ClosedLoopML | Manual 

const iobCoeffs := [
	0.00008888576671417514, 0.0002082938061054307, 0.00038570381569513756, 0.0006277831450745008,
	0.0009417604232239141, 0.0013354629687257757, 0.0018173558917852217, 0.002396582868895547,
	0.003083008553472988, 0.003887262565352656, 0.004820784978285975, 0.005895873197104051,
	0.007125730084534987, 0.008524513161283886, 0.010107384661311003, 0.011890562176642971,
	0.01389136957182635, 0.016128287786475903, 0.01862100507442843, 0.021390466148810794,
	0.02445891961280089, 0.02784996295481923, 0.03158858427303457, 0.035701199765927116,
	0.0402156858816618, 0.04516140485737852, 0.0505692221982742, 0.05647151444336218,
	0.06290216533767412, 0.06989654827678504, 0.07749149260599597, 0.08572523104010454,
	0.09463732511691347, 0.10426856520457517, 0.11466084114529196, 0.12585697913105653,
	0.13790053986585427, 0.15083557246734924, 0.16470631789325885, 0.1795568549364881,
	0.19543068101103545, 0.21237021903937248, 0.23041624074222744, 0.24960719551341515,
	0.26997843282444856, 0.29156130473397357, 0.3143821335622309, 0.3384610281160698,
	0.36381052999942953, 0.39043406949996307, 0.41832420828521577, 0.44746064365018945,
	0.477807946308893, 0.5093130006899644, 0.5419021133526135, 0.5754777514531602,
	0.6099148691306314, 0.6450567752052287, 0.680710490655502, 0.716641538914379,
	0.7525681060521794, 0.7881545013431775, 0.8230038414828375, 0.8566498737717378,
	0.8885478448395224, 0.9180643118715126, 0.9444657827381869, 0.9669060598219761,
	0.9844121495865791, 0.9958685859316113, 1.0, 1.0
	]
	
function sumDoses(insulinDoses: seq<real>): real
  requires |insulinDoses| == 6
{
	insulinDoses[0] + insulinDoses[1] + insulinDoses[2] + insulinDoses[3] + insulinDoses[4] + insulinDoses[5]
}

function computeIOB(insulinDoses: seq<real>): real
	requires |insulinDoses| == 72
{
	insulinDoses[0] * iobCoeffs[0] + insulinDoses[1] * iobCoeffs[1] + insulinDoses[2] * iobCoeffs[2] +
		insulinDoses[3] * iobCoeffs[3] + insulinDoses[4] * iobCoeffs[4] + insulinDoses[5] *
		iobCoeffs[5] + insulinDoses[6] * iobCoeffs[6] + insulinDoses[7] * iobCoeffs[7] +
		insulinDoses[8] * iobCoeffs[8] + insulinDoses[9] * iobCoeffs[9] + insulinDoses[10] *
		iobCoeffs[10] + insulinDoses[11] * iobCoeffs[11] + insulinDoses[12] * iobCoeffs[12] +
		insulinDoses[13] * iobCoeffs[13] + insulinDoses[14] * iobCoeffs[14] + insulinDoses[15] *
		iobCoeffs[15] + insulinDoses[16] * iobCoeffs[16] + insulinDoses[17] * iobCoeffs[17] +
		insulinDoses[18] * iobCoeffs[18] + insulinDoses[19] * iobCoeffs[19] + insulinDoses[20] *
		iobCoeffs[20] + insulinDoses[21] * iobCoeffs[21] + insulinDoses[22] * iobCoeffs[22] +
		insulinDoses[23] * iobCoeffs[23] + insulinDoses[24] * iobCoeffs[24] + insulinDoses[25] *
		iobCoeffs[25] + insulinDoses[26] * iobCoeffs[26] + insulinDoses[27] * iobCoeffs[27] +
		insulinDoses[28] * iobCoeffs[28] + insulinDoses[29] * iobCoeffs[29] + insulinDoses[30] *
		iobCoeffs[30] + insulinDoses[31] * iobCoeffs[31] + insulinDoses[32] * iobCoeffs[32] +
		insulinDoses[33] * iobCoeffs[33] + insulinDoses[34] * iobCoeffs[34] + insulinDoses[35] *
		iobCoeffs[35] + insulinDoses[36] * iobCoeffs[36] + insulinDoses[37] * iobCoeffs[37] +
		insulinDoses[38] * iobCoeffs[38] + insulinDoses[39] * iobCoeffs[39] + insulinDoses[40] *
		iobCoeffs[40] + insulinDoses[41] * iobCoeffs[41] + insulinDoses[42] * iobCoeffs[42] +
		insulinDoses[43] * iobCoeffs[43] + insulinDoses[44] * iobCoeffs[44] + insulinDoses[45] *
		iobCoeffs[45] + insulinDoses[46] * iobCoeffs[46] + insulinDoses[47] * iobCoeffs[47] +
		insulinDoses[48] * iobCoeffs[48] + insulinDoses[49] * iobCoeffs[49] + insulinDoses[50] *
		iobCoeffs[50] + insulinDoses[51] * iobCoeffs[51] + insulinDoses[52] * iobCoeffs[52] +
		insulinDoses[53] * iobCoeffs[53] + insulinDoses[54] * iobCoeffs[54] + insulinDoses[55] *
		iobCoeffs[55] + insulinDoses[56] * iobCoeffs[56] + insulinDoses[57] * iobCoeffs[57] +
		insulinDoses[58] * iobCoeffs[58] + insulinDoses[59] * iobCoeffs[59] + insulinDoses[60] *
		iobCoeffs[60] + insulinDoses[61] * iobCoeffs[61] + insulinDoses[62] * iobCoeffs[62] +
		insulinDoses[63] * iobCoeffs[64] + insulinDoses[64] * iobCoeffs[64] + insulinDoses[65] *
		iobCoeffs[65] + insulinDoses[66] * iobCoeffs[66] + insulinDoses[67] * iobCoeffs[67] +
		insulinDoses[68] * iobCoeffs[68] + insulinDoses[69] * iobCoeffs[69] + insulinDoses[70] *
		iobCoeffs[70] + insulinDoses[71] * iobCoeffs[71]
}

class BioInvar { 
  var state: State
		
  // Insulin
	ghost var insulinDoses: array<real>
	var measuredInsulinDoses: array<real>

	// Past insulin
	ghost var priorInsulinDoses: array<real>
	var measuredPriorInsulinDoses: array<real>
	
  // CGM, ie measured glucose
  var cgmInitial: real
  var cgmFinal: real

  // Real glucose
  ghost var glucoseInitial: real
  ghost var glucoseFinal: real

  var sensitivity: real
  var basal: real
	
  constructor(ghost initGlucoseInitial: real, ghost initGlucoseFinal: real,
		ghost initInsulinDoses: array<real>, initMeasuredInsulinDoses: array<real>,
		ghost initPriorInsulinDoses: array<real>, initMeasuredPriorInsulinDoses: array<real>,
		initCgmInitial: real, initCgmFinal: real, initSensitivity: real, initBasal: real)
    //Glucose preconditions
    requires 0.91 * initGlucoseInitial <= initCgmInitial <= 1.1 * initGlucoseInitial
    requires 0.91 * initGlucoseFinal <= initCgmFinal <= 1.1 * initGlucoseFinal

    // Insulin preconditions
		requires initMeasuredInsulinDoses.Length == 6
		requires initInsulinDoses.Length == 6
		requires forall i :: 0 <= i < 6 ==> 0.99*initInsulinDoses[i] <= initMeasuredInsulinDoses[i] <= 1.01*initInsulinDoses[i]
		requires initMeasuredPriorInsulinDoses.Length == 72
		requires initPriorInsulinDoses.Length == 72
		requires forall i ::0 <= i < 72 ==> 0.99*initPriorInsulinDoses[i] <= initMeasuredPriorInsulinDoses[i] <= 1.01*initPriorInsulinDoses[i]

		//requires forall i :: 0 <= i < 6 ==> initMeasuredInsulinDoses[i] > 0.0
		//requires forall i:: 0 <= i < 72 ==> initPriorInsulinDoses[i] > 0.0
		
    // Physiological parameters preconditions
    requires initSensitivity > 0.0
    requires initBasal > 0.0

    // Post conditions
    ensures insulinDoses == initInsulinDoses
    ensures cgmInitial  == initCgmInitial
    ensures cgmFinal == initCgmFinal
    ensures sensitivity == initSensitivity
    ensures basal == initBasal
  {

    insulinDoses := initInsulinDoses;
    measuredInsulinDoses := initMeasuredInsulinDoses;

		priorInsulinDoses := initPriorInsulinDoses;
		measuredPriorInsulinDoses := initMeasuredPriorInsulinDoses;
		
    cgmInitial := initCgmInitial;
    cgmFinal := initCgmFinal;
		
    glucoseInitial := initGlucoseInitial;
    glucoseFinal := initGlucoseFinal;
		
    sensitivity := initSensitivity;
    basal := initBasal;

    new;

		var totalInsulinDoses := sumDoses(insulinDoses[..]);
		var totalMeasuredInsulinDoses := sumDoses(measuredInsulinDoses[..]);

		assert totalInsulinDoses == sumDoses(insulinDoses[..]);
		assert totalMeasuredInsulinDoses == sumDoses(measuredInsulinDoses[..]);
		
		var measuredIobStart := computeIOB(measuredPriorInsulinDoses[..]);
		var measuredIobEnd := computeIOB(measuredPriorInsulinDoses[measuredPriorInsulinDoses.Length - 66 ..] + measuredInsulinDoses[..6]);

		var measuredDeltaIOB := measuredIobStart - measuredIobEnd;
		assert measuredDeltaIOB == measuredIobStart - measuredIobEnd;
		
		var iobStart := computeIOB(priorInsulinDoses[..]);
		var iobEnd := computeIOB(priorInsulinDoses[priorInsulinDoses.Length - 66 ..] + insulinDoses[..6]);

		var deltaIOB := iobStart - iobEnd;
		assert deltaIOB == iobStart - iobEnd;

		
		//var deltaCalculated := basal - (sensitivity * (deltaIOB + totalInsulinDoses));
		var deltaCalculated := basal -(sensitivity * (deltaIOB + totalInsulinDoses));
		assert deltaCalculated == basal -(sensitivity * (deltaIOB + totalInsulinDoses));
		
    var deltaMeasured := cgmFinal - cgmInitial;
		assert deltaMeasured == cgmFinal - cgmInitial;
		
    var deltaReal := glucoseFinal - glucoseInitial;
		assert deltaReal == glucoseFinal - glucoseInitial;
    var threshold := 30.0;
   
		// Divide by 0 condition:
		assume{:axiom} (0.99 * measuredDeltaIOB) - (0.01 * totalMeasuredInsulinDoses) > 0.0;
		
		if (sensitivity >= (basal - threshold - (0.9 * cgmFinal) + (1.1 * cgmInitial)) /
			((0.99 * measuredDeltaIOB) - (0.01 * totalMeasuredInsulinDoses))) {
				state := ClosedLoopML;
    } else {
      state := Manual;
    }
		
		if (state == ClosedLoopML) {
			//assert sensitivity >= (basal - threshold - (0.9 *cgmFinal) + (1.1 * cgmInitial)) /
			//((0.99 * measuredDeltaIOB) - (0.01 * totalMeasuredInsulinDoses));
			assert measuredDeltaIOB == measuredIobStart - measuredIobEnd;
			assert totalMeasuredInsulinDoses == sumDoses(measuredInsulinDoses[..]);
			assert measuredDeltaIOB > (0.99 * deltaIOB) - totalMeasuredInsulinDoses;
			//assert sensitivity * ((0.99 * measuredDeltaIOB) - (0.01 * totalMeasuredInsulinDoses)) >= (basal - threshold - (0.9 *cgmFinal) + (1.1 * cgmInitial));
			//assert (deltaCalculated - deltaReal) <= threshold;
		}
    /*if (state == ClosedLoopML) {
			assert sensitivity * (deltaIOB + 0.99 * totalMeasuredInsulinDoses) >= basal - threshold - (0.9 * cgmFinal) + (1.1 * cgmInitial);
			assert 0.99 * totalMeasuredInsulinDoses >= ((basal - threshold - (0.9 * cgmFinal) + (1.1  *cgmInitial)) / sensitivity) - deltaIOB;
			assert 0.99 * totalMeasuredInsulinDoses <= totalInsulinDoses;
			assert (deltaCalculated - deltaReal) <= threshold;
    }*/
  }
}
