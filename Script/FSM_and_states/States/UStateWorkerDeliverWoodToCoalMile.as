
class UStateWorkerDeliverWoodToCoalMile : UStateBase
{
    TArray<ATile> Path;

    ACoalMile CoalMile;
    
    UStateWorkerDeliverWoodToCoalMile(ACoalMile _CoalMile) { CoalMile = _CoalMile; }

    void Enter(AEntity Entity) override
    {
        ATile Start= UMapManager::Get().GetMapTileFromPosition(Entity.GetActorLocation());
        Path = UAiSystemManager::Get().FindPath(Start, CoalMile.HomeTile); 
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
            EntityAsWorker.SetActorLocation(EntityAsWorker.GetActorLocation() + (EntityAsWorker.Direction * DeltaSeconds * UAiSystemManager::Get().MovementSpeed));
            if(NextTilePos.X + UAiSystemManager::Get().Offset > EntityAsWorker.GetActorLocation().X && NextTilePos.Y + UAiSystemManager::Get().Offset > EntityAsWorker.GetActorLocation().Y && 
            NextTilePos.X - UAiSystemManager::Get().Offset < EntityAsWorker.GetActorLocation().X &&  NextTilePos.Y - UAiSystemManager::Get().Offset < EntityAsWorker.GetActorLocation().Y)
            {
                Path.Remove(Path[0]);
                EntityAsWorker.SetActorLocation(NextTilePos);
            }
            if (Path.Num() == 0)
            {
                CoalMile.CoalMileOwner.CharcoalQueue.Add(UTaskCreateCharcoal());
                EntityAsWorker.FSM.ChangeState(UStateIdleWorker());
            }
        }
    }

}