
class ACoalMiler : AEntity
{
    FVector Direction;
    FVector Displacement;
    ACoalMile CoalMile;
    UMapManager Map;
    TArray<UTaskCreateCharcoal> CharcoalQueue;
    UFiniteStateMachine FSM = UFiniteStateMachine(UStateCoalMilerMoveToMile());
    UAiSystemManager AiManager = UAiSystemManager::Get();
    ACoalMiler()
    {
        FSM.FSMOwner = this;
        if(AiManager != nullptr)
            AiManager.FiniteStateMachineArray.Add(FSM);
    }
}