
class UStateBuild : UStateBase
{
    UMapManager MapManager;
    UActorMesh Meshes;

    ATile TileToBuildOn;
    TArray<ATile> Path;

    float TimeElapsed = 0;
    float TargetSeconds;

    UStateBuild()
    {
    }
    
    void Enter(AEntity Entity) override
    {
        TargetSeconds = UAiSystemManager::Get().TimeToBuildCoalMile;
        TileToBuildOn = UMapManager::Get().GetNextBuildableTile();
        TileToBuildOn.bHasBuilding = true;
        ABuilder EntityAsBuilder = Cast<ABuilder>(Entity);
        EntityAsBuilder.CurrentTileToBuild = TileToBuildOn;
        Path =  UAiSystemManager::Get().FindPath(UMapManager::Get().GetMapTileFromPosition(EntityAsBuilder.GetActorLocation()), TileToBuildOn);
    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
        if (Path.Num() != 0)
        {
            ABuilder EntityAsBuilder = Cast<ABuilder>(Entity); 
            ATile NextTile = Path[0];
            FVector NextTilePos = FVector(NextTile.PosX*1000,NextTile.PosY*1000,0);
            EntityAsBuilder.Direction = NextTilePos - EntityAsBuilder.GetActorLocation() ;
            EntityAsBuilder.Direction = EntityAsBuilder.Direction.GetSafeNormal();
            EntityAsBuilder.SetActorLocation(EntityAsBuilder.GetActorLocation() + (EntityAsBuilder.Direction * DeltaSeconds * UAiSystemManager::Get().MovementSpeed));
            if(NextTilePos.X+UAiSystemManager::Get().Offset > EntityAsBuilder.GetActorLocation().X && NextTilePos.Y+UAiSystemManager::Get().Offset > EntityAsBuilder.GetActorLocation().Y && NextTilePos.X-UAiSystemManager::Get().Offset < EntityAsBuilder.GetActorLocation().X &&  NextTilePos.Y-UAiSystemManager::Get().Offset < EntityAsBuilder.GetActorLocation().Y)
            {
                Path.Remove(Path[0]);
                EntityAsBuilder.SetActorLocation(NextTilePos);
            }
        }
        if (Path.Num() == 0)
        {
            TimeElapsed += DeltaSeconds;
            if(TimeElapsed > TargetSeconds)
            {
                ACoalMile CoalMile =  Cast<ACoalMile>(SpawnActor(UActorMesh::Get().CoalMile));
                CoalMile.SetActorLocation(TileToBuildOn.GetActorLocation());
                CoalMile.HomeTile = TileToBuildOn;
                UAiSystemManager::Get().TaskQueue.Add(UTaskWorkerToCoalMiler(CoalMile));
                //UAiSystemManager::Get().CoalMiles.Add(CoalMile);
                UAiSystemManager::Get().AllCoalMiles.Add(CoalMile);

                TileToBuildOn.Entities.Add(CoalMile);

                ABuilder EntityAsBuilder = Cast<ABuilder>(Entity);
                EntityAsBuilder.FSM.ChangeState(UStateIdleBuilder());
            }
        }
    }


}