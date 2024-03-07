class ATree : AEntity
{
    UFiniteStateMachine FSM = UFiniteStateMachine(UStandingTree());
    UAiSystemManager AiManager;
    AWorker TreeOwner;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        FSM.FSMOwner = this;
    }
    
}