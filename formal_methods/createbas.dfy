datatype InsulinType = Humalog | Luminev

class DoseEntry {
    var insulinType: InsulinType;
    var units: int;
    var unitsPerHour: int;
    var mutable: bool;

    constructor (insulinType: InsulinType, units: int, unitsPerHour: int, mutable: bool)
        ensures this.insulinType == insulinType && this.units == units && this.unitsPerHour == unitsPerHour && this.mutable == mutable
    {
        this.insulinType := insulinType;
        this.units := units;
        this.unitsPerHour := unitsPerHour;
        this.mutable := mutable;
    }
}


function getCurrentBasalRate(insulinType: InsulinType): int
    ensures 0 <= getCurrentBasalRate(insulinType) <= 1
{
    // Placeholder implementation
    1
}

method createBasalDose(insulinType: InsulinType, start: int, end: int) returns (doseEntry: DoseEntry?)
    requires end > start
    ensures (end - start > 1) || doseEntry == null
    ensures doseEntry != null ==>
            doseEntry.insulinType == insulinType &&
            doseEntry.unitsPerHour == getCurrentBasalRate(insulinType) &&
            !doseEntry.mutable &&
            doseEntry.units >= 0 &&
            doseEntry.units == (getCurrentBasalRate(insulinType) / 3600) * (end - start)
{
    var timeDiff := end - start;

    // Ensure time difference is greater than 1 second
    if timeDiff <= 1 {
        return null;
    }

    // Fetch current basal rate in units per hour
    var basalRatePerHour := getCurrentBasalRate(insulinType);

    // Convert basal rate from units per hour to units per second
    var basalRatePerSecond := basalRatePerHour / 3600; // 3600 seconds in an hour

    // Calculate total units of insulin delivered over the duration
    var unitsDelivered := basalRatePerSecond * timeDiff;

    // Construct the DoseEntry object
    doseEntry := new DoseEntry(insulinType, unitsDelivered, basalRatePerHour, false);
}