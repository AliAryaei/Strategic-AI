
class UStateChopTree : UStateBase
{
    UStateChopTree(){}
    UAiSystemManager AiManager = UAiSystemManager::Get();

    float TargetSeconds;
    float ElapsedSeconds = 0;

    void Enter(AEntity Entity) override
    {
        TargetSeconds = UAiSystemManager::Get().TimeToChopTree;

        AiManager = UAiSystemManager::Get();
        ATree EntityAsTree = Cast<ATree>(Entity);
        AiManager.FiniteStateMachineArray.Add(EntityAsTree.FSM);        
    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
        ElapsedSeconds += DeltaSeconds;
        if(ElapsedSeconds >= TargetSeconds)
        {
            ATree EntityAsTree = Cast<ATree>(Entity);
            EntityAsTree.TreeOwner.WoodToBase = EntityAsTree;
            EntityAsTree.TreeOwner.FSM.ChangeState(UStateGetWoodToBase());
            EntityAsTree.DestroyActor();
            AiManager.FiniteStateMachineArray.Remove(EntityAsTree.FSM);
        }
    }

    void Exit(AEntity Entity) override
    {
        ATree EntityAsTree = Cast<ATree>(Entity);
        AiManager.FiniteStateMachineArray.Remove(EntityAsTree.FSM);
        
    }
}