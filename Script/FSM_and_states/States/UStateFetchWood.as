
class UStateFetchWood : UStateBase
{

    UAiSystemManager AiManager;
    UMapManager MapManager;

    TArray<ATile> Path;

    UStateFetchWood()
    {
        MapManager = UMapManager::Get();
        AiManager = UAiSystemManager::Get();
    }

    void Enter(AEntity Entity) override
    {
        AWorker EntityAsWorker = Cast<AWorker>(Entity);

        ATile Start= MapManager.GetMapTileFromPosition(Entity.GetActorLocation());
        Path = AiManager.FindPath(Start, EntityAsWorker.TreeTile); 
        if(Path.Num() == 0)
        {
            AiManager.TaskQueue.Add(UTaskFetchWood());
            return; 
        }
    }
    
    void Execute(AEntity Entity, float DeltaSeconds) override
    {
        if (Path.Num() != 0)
        {
            AWorker EntityAsWorker = Cast<AWorker>(Entity); 
            ATile NextTile = Path[0];
            FVector NextTilePos = FVector(NextTile.PosX*1000,NextTile.PosY*1000,0);
            EntityAsWorker.Direction = NextTilePos - EntityAsWorker.GetActorLocation() ;
            EntityAsWorker.Direction = EntityAsWorker.Direction.GetSafeNormal();
            EntityAsWorker.SetActorLocation(EntityAsWorker.GetActorLocation() + (EntityAsWorker.Direction *DeltaSeconds * UAiSystemManager::Get().MovementSpeed));
            if(NextTilePos.X + UAiSystemManager::Get().Offset > EntityAsWorker.GetActorLocation().X && NextTilePos.Y + UAiSystemManager::Get().Offset > EntityAsWorker.GetActorLocation().Y && 
            NextTilePos.X - UAiSystemManager::Get().Offset < EntityAsWorker.GetActorLocation().X &&  NextTilePos.Y - UAiSystemManager::Get().Offset < EntityAsWorker.GetActorLocation().Y)
            {
                Path.Remove(Path[0]);
                EntityAsWorker.SetActorLocation(NextTilePos);
            }
            if (Path.Num() == 0)
            {
                EntityAsWorker.TreeToCut.TreeOwner = EntityAsWorker;
                EntityAsWorker.TreeToCut.FSM.ChangeState(UStateChopTree());
            }
        }

        
    }

    void Exit(AEntity Entity) override
    {

    }


}