datatype State = CloseLoopML | CloseLoopPhysio | Manual

class StateMachine {
    var currentState: State

    constructor() {
        currentState := CloseLoopML;
    }

    predicate ValidTransition(newState: State)
        reads this
    {
        (currentState == CloseLoopML && (newState == Manual || newState == CloseLoopML)) ||
        (currentState == CloseLoopPhysio && (newState == Manual || newState == CloseLoopPhysio)) ||
        (currentState == Manual && newState == CloseLoopML)
    }

    method TransitionToState(newState: State)
        requires ValidTransition(newState)
        modifies this
        ensures currentState == newState
    {
        currentState := newState;
    }

    method HandleInsulinSensitivity(moreSensitive: bool, lessSensitive: bool)
        requires !moreSensitive || !lessSensitive
        requires moreSensitive ==> currentState != Manual
        modifies this
        ensures moreSensitive ==> currentState == Manual
        ensures !moreSensitive && lessSensitive ==> currentState == old(currentState)
    {
        if moreSensitive {
            TransitionToState(Manual);
        } else if lessSensitive {
            // Alert user, but do not change state
        }
    }
}