
class UFiniteStateMachine 
{
    UFiniteStateMachine(UStateBase State)
    {
        FSMOwner = nullptr;
        CurrentState = State;
        PreviousState = nullptr;
        GlobalState = nullptr;
    }
    
    AEntity FSMOwner;

	UStateBase CurrentState;
	UStateBase PreviousState;
	UStateBase GlobalState;

	//Changes the current state and sets the previous state. Returns void.
	void ChangeState(UStateBase NewState)
    {
        CurrentState.Exit(FSMOwner);

        PreviousState = CurrentState;

        CurrentState = NewState;

        CurrentState.Enter(FSMOwner);
    }
	//Sets the current state. Returns void.
	void SetCurretState(UStateBase NewState)
    {
        CurrentState = NewState;
    }
	//Sets the global state. Returns void.
	void SetGlobalState(UStateBase NewGlobalState)
    {
        GlobalState = NewGlobalState;
    }
	//Sets the previous state. Returns void.
	void SetPreviousState()
    {
        CurrentState = PreviousState;
    }


    void Update(float DeltaSeconds)
    {
        if (GlobalState != nullptr)
            GlobalState.Execute(FSMOwner, DeltaSeconds);
        if (CurrentState != nullptr)
            CurrentState.Execute(FSMOwner, DeltaSeconds); 
    }

	//Returns a pointer to the owner of the FSM. 
	AEntity GetOwner() { return FSMOwner; }
	//Gets a pointer type to the current state.
	UStateBase GetCurrentState() { return CurrentState; };
}