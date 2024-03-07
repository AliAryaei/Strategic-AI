
class UStateUpgradeToExplorer : UStateBase
{
    float TimeElapsed = 0;
    float TargetSeconds; 

    UStateUpgradeToExplorer() {}

    void Enter(AEntity Entity) override
    {
        TargetSeconds = UAiSystemManager::Get().TimeToUpgradeToExplorer;
    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
        TimeElapsed += DeltaSeconds;
        if(TimeElapsed >= TargetSeconds)
        {
            FVector LastLocation = Entity.GetActorLocation();
            UAiSystemManager AiManager = UAiSystemManager::Get();
            auto Meshes = UActorMesh::Get();
            AiManager.FiniteStateMachineArray.Remove(Cast<AWorker>(Entity).FSM);
            Entity.DestroyActor();
            AExplorer ActorToSpawn = Cast<AExplorer>(SpawnActor(Meshes.Explorer));
            ActorToSpawn.FSM.FSMOwner = ActorToSpawn;
            ActorToSpawn.SetActorLocation(LastLocation);
            ActorToSpawn.FSM.CurrentState = UStateExplorer();
            AiManager.FiniteStateMachineArray.Add(ActorToSpawn.FSM);
        }
    }
}