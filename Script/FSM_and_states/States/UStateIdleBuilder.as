
class UStateIdleBuilder : UStateBase
{

    UAiSystemManager AiManager;
    UStateIdleBuilder()
    {
        AiManager = UAiSystemManager::Get();
    }

    TArray<ATile> Path;

    void Enter(AEntity Entity) override
    {
        ABuilder EntityAsBuilder = Cast<ABuilder>(Entity);
        if(EntityAsBuilder.CurrentTileToBuild != nullptr)
            Path = AiManager.FindPath(EntityAsBuilder.CurrentTileToBuild, EntityAsBuilder.StartTile);
        if(Path.Num() == 0)
            AiManager.IdleBuilders.Add(EntityAsBuilder);
    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
            ABuilder EntityAsBuilder = Cast<ABuilder>(Entity); 
        if (Path.Num() != 0)
        {
            ATile NextTile = Path[0];
            FVector NextTilePos = FVector(NextTile.PosX*1000,NextTile.PosY*1000,0);
            EntityAsBuilder.Direction = NextTilePos - EntityAsBuilder.GetActorLocation();
            EntityAsBuilder.Direction = EntityAsBuilder.Direction.GetSafeNormal();
            EntityAsBuilder.SetActorLocation(EntityAsBuilder.GetActorLocation() + (EntityAsBuilder.Direction *DeltaSeconds * UAiSystemManager::Get().MovementSpeed));
            if(NextTilePos.X + UAiSystemManager::Get().Offset > EntityAsBuilder.GetActorLocation().X && NextTilePos.Y + UAiSystemManager::Get().Offset > EntityAsBuilder.GetActorLocation().Y && 
            NextTilePos.X - UAiSystemManager::Get().Offset < EntityAsBuilder.GetActorLocation().X &&  NextTilePos.Y - UAiSystemManager::Get().Offset < EntityAsBuilder.GetActorLocation().Y)
            {
                Path.Remove(Path[0]);
                EntityAsBuilder.SetActorLocation(NextTilePos);
            }
        }
            if (Path.Num() == 0)
            {
                AiManager.IdleBuilders.Add(EntityAsBuilder);
            }
    }

    void Exit(AEntity Entity) override
    {
        ABuilder EntityAsBuilder = Cast<ABuilder>(Entity);
        AiManager.IdleBuilders.Remove(EntityAsBuilder);      
    }

}