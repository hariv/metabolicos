class CodableSettings {
    var learnedInsulinSensitivity: real
    var addedGlucoseDigestionThresholdMgDlPerHour: real
    var learnedBasalRate: real
    var dynamicBasalRateEnabled: bool
    var dynamicInsulinSensitivityEnabled: bool
    var useMachineLearningClosedLoop: bool
    var isMicroBolusEnabled: bool
    var maxBasalRateUnitsPerHour: real
    var shutOffGlucoseInMgDl: real

    constructor () {
        learnedInsulinSensitivity := 10.0;
        addedGlucoseDigestionThresholdMgDlPerHour := 5.0;
        learnedBasalRate := 1.0;
        dynamicBasalRateEnabled := true;
        dynamicInsulinSensitivityEnabled := true;
        useMachineLearningClosedLoop := false;
        isMicroBolusEnabled := false;
        maxBasalRateUnitsPerHour := 1.0;
        shutOffGlucoseInMgDl := 70.0;
    }
}

// const supportedBasalRates: seq<real> := [0.0, 0.025, 0.05, 0.075, 0.1, 0.125, 0.15, 0.175, 0.2];

// method roundToSupportedBasalRate(unitsPerHour: real) returns (roundedRate: real)
//     requires unitsPerHour >= 0.0
//     requires |supportedBasalRates| > 0
//     requires supportedBasalRates[0] == 0.0
//     ensures roundedRate in supportedBasalRates
//     ensures roundedRate <= unitsPerHour
// {
//     var maxSupportedRateSoFar := 0.0;
//     var i := 0;
//     while i < |supportedBasalRates| {
//         if supportedBasalRates[i] <= unitsPerHour {
//             maxSupportedRateSoFar := supportedBasalRates[i];
//         }
//         i := i + 1;
//     }
//     roundedRate := maxSupportedRateSoFar;
    
 
// }


method applyGuardrails(glucoseInMgDl: real, predictedGlucoseInMgDl: real, newBasalRateRaw: real, settings: CodableSettings) returns (newBasalRate: real)
    requires glucoseInMgDl >= 0.0 && predictedGlucoseInMgDl >= 0.0 && newBasalRateRaw >= 0.0
    requires settings.maxBasalRateUnitsPerHour >= 0.0
    ensures newBasalRate >= 0.0 && newBasalRate <= settings.maxBasalRateUnitsPerHour
    ensures (glucoseInMgDl > settings.shutOffGlucoseInMgDl && predictedGlucoseInMgDl > settings.shutOffGlucoseInMgDl)||newBasalRate==0.0

{
    // First, apply the rounding function to the raw basal rate
    var adjustedRate := newBasalRateRaw;


    // Ensure the rate does not exceed the maximum allowed by settings
    if adjustedRate > settings.maxBasalRateUnitsPerHour {
        adjustedRate := settings.maxBasalRateUnitsPerHour;
    }

    // Check against the shut off glucose levels and set rate to zero if glucose is below the threshold
    if glucoseInMgDl <= settings.shutOffGlucoseInMgDl || predictedGlucoseInMgDl <= settings.shutOffGlucoseInMgDl {
        adjustedRate := 0.0;
    }

    // Ensure the rate does not drop below zero
    if adjustedRate < 0.0 {
        adjustedRate := 0.0;
    }

    newBasalRate := adjustedRate;
    return newBasalRate;
}
