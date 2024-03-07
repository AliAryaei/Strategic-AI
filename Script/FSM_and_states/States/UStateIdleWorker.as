
class UStateIdleWorker : UStateBase
{

    UAiSystemManager AiManager = UAiSystemManager::Get();;
    UStateIdleWorker()
    {
    }

    TArray<ATile> Path;

    void Enter(AEntity Entity) override
    {
        AWorker EntityAsWorker = Cast<AWorker>(Entity);

        if(EntityAsWorker.StartTile != nullptr)
            Path = AiManager.FindPath(UMapManager::Get().GetMapTileFromPosition(Entity.GetActorLocation()), EntityAsWorker.StartTile);

    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
            AWorker EntityAsWorker = Cast<AWorker>(Entity); 
        if (Path.Num() != 0)
        {
            ATile NextTile = Path[0];
            FVector NextTilePos = FVector(NextTile.PosX*1000,NextTile.PosY*1000,0);
            EntityAsWorker.Direction = NextTilePos - EntityAsWorker.GetActorLocation();
            EntityAsWorker.Direction = EntityAsWorker.Direction.GetSafeNormal();
            EntityAsWorker.SetActorLocation(EntityAsWorker.GetActorLocation() + (EntityAsWorker.Direction *DeltaSeconds * UAiSystemManager::Get().MovementSpeed));
            if(NextTilePos.X + UAiSystemManager::Get().Offset > EntityAsWorker.GetActorLocation().X && NextTilePos.Y + UAiSystemManager::Get().Offset > EntityAsWorker.GetActorLocation().Y &&
            NextTilePos.X - UAiSystemManager::Get().Offset < EntityAsWorker.GetActorLocation().X &&  NextTilePos.Y - UAiSystemManager::Get().Offset < EntityAsWorker.GetActorLocation().Y)
            {
                Path.Remove(Path[0]);
                EntityAsWorker.SetActorLocation(NextTilePos);
            }
        }
        if(Path.Num() == 0 && !AiManager.IdleWorkers.Contains(EntityAsWorker))
            AiManager.IdleWorkers.Add(EntityAsWorker);
    }

    void Exit(AEntity Entity) override
    {
        AWorker EntityAsWorker = Cast<AWorker>(Entity);
        if(AiManager!=nullptr)
            AiManager.IdleWorkers.Remove(EntityAsWorker);
        
    }
}