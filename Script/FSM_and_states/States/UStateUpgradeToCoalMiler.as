
class UStateUpgradeToCoalMiler : UStateBase
{
    float TimeElapsed = 0;
    float TargetSeconds;

    UAiSystemManager AiManager;
    TArray<ATile> Path;

    UStateUpgradeToCoalMiler(){}

    void Enter(AEntity Entity) override
    {
        TargetSeconds = UAiSystemManager::Get().TimeToUpgradeToCoalMiler;
    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {        
        TimeElapsed += DeltaSeconds;
        if(TimeElapsed >= TargetSeconds)
        {
            auto Meshes = UActorMesh::Get();
            ACoalMiler ActorToSpawn;
            ActorToSpawn = Cast<ACoalMiler>(SpawnActor(Meshes.CoalMiler));
            ActorToSpawn.CoalMile = Cast<AWorker>(Entity).CoalMile;

            ActorToSpawn.CoalMile.CoalMileOwner = ActorToSpawn;
            FVector LastLocation = Entity.GetActorLocation();
            AiManager = UAiSystemManager::Get();
            AiManager.FiniteStateMachineArray.Remove(Cast<AWorker>(Entity).FSM);
            Entity.DestroyActor();
            ActorToSpawn.SetActorLocation(LastLocation);
            ActorToSpawn.FSM.CurrentState.Enter(ActorToSpawn);
            AiManager.FiniteStateMachineArray.Add(ActorToSpawn.FSM);
        }
    }
}