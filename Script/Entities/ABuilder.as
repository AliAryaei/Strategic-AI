
class ABuilder : AEntity
{
    FVector Direction;
    FVector Displacement;
    UMapManager Map = UMapManager::Get();
    UFiniteStateMachine FSM = UFiniteStateMachine(UStateUpgradeToBuilder());
    UAiSystemManager AiManager = UAiSystemManager::Get();
    ATile CurrentTileToBuild;

    ABuilder()
    {
        FSM.FSMOwner = this;
        if(AiManager!=nullptr)
            AiManager.FiniteStateMachineArray.Add(FSM);
        if(Map!=nullptr)
            StartTile = Map.GetBaseTile();
    }
}