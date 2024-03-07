class AWorker : AEntity
{
    int MovementSpeed;
    UFiniteStateMachine FSM = UFiniteStateMachine(UStateIdleWorker());
    ATile TreeTile;
    ATree TreeToCut;
    FVector Direction;
    ATree WoodToBase;
    ACoalMile CoalMile;


    AWorker()
    {
        FSM.FSMOwner = this;
        FSM.CurrentState.Enter(this);
        UAiSystemManager AiManager = UAiSystemManager::Get();
        if(AiManager != nullptr)
            AiManager.FiniteStateMachineArray.Add(FSM);
    }
    
    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        auto MapManager = UMapManager::Get();
        StartTile = MapManager.GetBaseTile();
        
    }
    
}