
class UStateUpgradeToBuilder : UStateBase
{
    float TimeElapsed = 0;
    float TargetTime; 

    UStateUpgradeToBuilder() {}

    void Enter(AEntity Entity) override
    {
        TargetTime = UAiSystemManager::Get().TimeToUpgradeToBuilder;
    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
        TimeElapsed += DeltaSeconds;
        if(TimeElapsed >= TargetTime)
        {
            FVector LastLocation = Entity.GetActorLocation();
            UAiSystemManager AiManager = UAiSystemManager::Get();
            auto Meshes = UActorMesh::Get();
            AiManager.FiniteStateMachineArray.Remove(Cast<AWorker>(Entity).FSM);
            Entity.DestroyActor();
            ABuilder ActorToSpawn = Cast<ABuilder>(SpawnActor(Meshes.Builder));
            ActorToSpawn.FSM.FSMOwner = ActorToSpawn;
            ActorToSpawn.SetActorLocation(LastLocation);
            ActorToSpawn.FSM.CurrentState = UStateIdleBuilder();
            ActorToSpawn.FSM.CurrentState.Enter(ActorToSpawn);
            AiManager.FiniteStateMachineArray.Add(ActorToSpawn.FSM);
        }
    }
}