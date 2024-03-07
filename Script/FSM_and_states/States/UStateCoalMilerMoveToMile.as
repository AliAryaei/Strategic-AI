
class UStateCoalMilerMoveToMile : UStateBase
{
    UStateCoalMilerMoveToMile(){}

    TArray<ATile> Path;

    ACoalMiler ActorToSpawn;
    void Enter(AEntity Entity) override
    {
        ActorToSpawn = Cast<ACoalMiler>(Entity);

        Path = UAiSystemManager::Get().FindPath(UMapManager::Get().GetMapTileFromPosition(ActorToSpawn.GetActorLocation()), ActorToSpawn.CoalMile.HomeTile);
    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
        if (Path.Num() != 0)
        {
            ATile NextTile = Path[0];
            FVector NextTilePos = FVector(NextTile.PosX*1000,NextTile.PosY*1000,0);
            ActorToSpawn.Direction = NextTilePos - ActorToSpawn.GetActorLocation();
            ActorToSpawn.Direction = ActorToSpawn.Direction.GetSafeNormal();
            ActorToSpawn.SetActorLocation(ActorToSpawn.GetActorLocation() + (ActorToSpawn.Direction *DeltaSeconds * UAiSystemManager::Get().MovementSpeed));
            if(NextTilePos.X + UAiSystemManager::Get().Offset > ActorToSpawn.GetActorLocation().X && NextTilePos.Y+UAiSystemManager::Get().Offset > ActorToSpawn.GetActorLocation().Y && 
            NextTilePos.X-UAiSystemManager::Get().Offset < ActorToSpawn.GetActorLocation().X &&  NextTilePos.Y-UAiSystemManager::Get().Offset < ActorToSpawn.GetActorLocation().Y)
            {
                Path.Remove(Path[0]);
                ActorToSpawn.SetActorLocation(NextTilePos);
            }
            if (Path.Num() == 0)
            {
                ActorToSpawn.FSM.ChangeState(UStateWorkingCoalMile());
            }
        }
    }
}