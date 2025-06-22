function max(a: int, b: int): int {
    if a >= b then a else b
}

function min(a: int, b: int): int {
    if a >= b then b else a
}

function max_real(a: real, b: real): real {
    if a >= b then a else b
}

function min_real(a: real, b: real): real {
    if a >= b then b else a
}

class InsulinDelivery {
    var deliveredUnits: real;
    var programmedUnits: real;
    var startDate: int;
    var endDate: int;

    method insulinDeliveredForSegment(startDate: int, endDate: int) returns (result: real)
    requires startDate <= endDate;
    requires programmedUnits >= 0.0 && deliveredUnits >= 0.0;
    requires this.startDate < this.endDate; // Ensuring startDate is strictly less than endDate

    ensures result >= 0.0;
    ensures (this.endDate - this.startDate) as real > 0.0 || result == 0.0;
    ensures result <= (if deliveredUnits != (0 as real) then deliveredUnits else programmedUnits);
    ensures max_real((this.startDate as real), (startDate as real)) >= min_real((this.endDate as real), (endDate as real)) ==> result == 0.0;
    ensures startDate <= this.startDate && endDate >= this.endDate ==> result == (if deliveredUnits != (0 as real) then deliveredUnits else programmedUnits);
    ensures this.startDate <= startDate && endDate <= this.endDate ==> result == (if deliveredUnits != (0 as real) then deliveredUnits else programmedUnits) * (endDate - startDate) as real / (this.endDate - this.startDate) as real;
    {
        var intersectionStart := max_real((this.startDate as real), (startDate as real));
        var intersectionEnd := min_real((this.endDate as real), (endDate as real));
        var doseDuration := (this.endDate - this.startDate) as real;
        var intersectionDuration := max_real((intersectionEnd - intersectionStart) as real, 0.0);
        var units: real;
        if deliveredUnits != (0 as real) {
            units := deliveredUnits;
        } else {
            units := programmedUnits;
        }

        if doseDuration == 0.0 {
            // Handle the case where doseDuration is zero
            return 0.0;
        }

        return units * intersectionDuration / doseDuration;
    }
}
