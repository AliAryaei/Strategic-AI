
class AExplorer : AEntity
{
    FVector Direction;
    FVector Displacement;
    UMapManager Map;
    UFiniteStateMachine FSM = UFiniteStateMachine(UStateExplorer());
    float ArmModifier = 0.25;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Map = UMapManager::Get();
        Direction = FVector(50000,0,0);
        FRotator InitialRotation = FRotator(0, Math::RandRange(0,360), 0);
        Direction = InitialRotation.RotateVector(Direction);
        Displacement = FVector(1000,1000, 0);
    }
    UAiSystemManager AiManager = UAiSystemManager::Get();

    AExplorer()
    {
        FSM.FSMOwner = this;
        if(AiManager != nullptr)
            AiManager.FiniteStateMachineArray.Add(FSM);
    }

    void ExplorerUpdate(float DeltaSeconds)
    {
        FVector CurrentLocation = GetActorLocation();
        ATile ExplorerCurrentTile = Map.GetMapTileFromPosition(CurrentLocation);

        
        if(ExplorerCurrentTile==nullptr)
            PrintToScreen("Current tile is nullpointer",5.0f);
        // else
        //     PrintToScreen("I was a little nuller", 0.5f);
        float TileSpeed = ExplorerCurrentTile.MovementSpeed;

        FRotator Wander = FRotator(0, Math::RandRange(0,360), 0);
        FRotator ArmRotator1 = FRotator(0, 45, 0);
        FRotator ArmRotator2 = FRotator(0, -45, 0);
        Displacement = Wander.RotateVector(Displacement);
        Direction = Direction + Displacement;
        FVector Arm1 = ArmRotator1.RotateVector(Direction).GetSafeNormal();
        FVector Arm2 = -ArmRotator2.RotateVector(Direction).GetSafeNormal();
        FVector NormalizedDirection = Direction.GetSafeNormal();

        FVector PotentialNewLocation = CurrentLocation + (NormalizedDirection * UAiSystemManager::Get().MovementSpeed * DeltaSeconds);
        ATile PotentialNewTile = Map.GetMapTileFromPosition(PotentialNewLocation);

        if(PotentialNewTile != nullptr && PotentialNewTile.bWalkable)
        {
            SetActorLocation(PotentialNewLocation);
        }

        if(!Map.GetMapTileFromPosition(CurrentLocation+(NormalizedDirection * UAiSystemManager::Get().MovementSpeed * DeltaSeconds )).bWalkable &&
        !Map.GetMapTileFromPosition(CurrentLocation+(Arm1 * UAiSystemManager::Get().MovementSpeed * DeltaSeconds * ArmModifier * TileSpeed)).bWalkable && 
        !Map.GetMapTileFromPosition(CurrentLocation+(Arm2 * UAiSystemManager::Get().MovementSpeed * DeltaSeconds * ArmModifier * TileSpeed)).bWalkable)
        {
            int RotateDirection = Math::RandRange(0,1) == 0 ? 90 : -90;
            FRotator Rotate = FRotator(0, 180+ RotateDirection, 0);
            Direction = Rotate.RotateVector(Direction);
            NormalizedDirection = Direction.GetSafeNormal();
            SetActorLocation(CurrentLocation+(NormalizedDirection * DeltaSeconds * UAiSystemManager::Get().MovementSpeed * TileSpeed));
        }
        else
        {
            SetActorLocation(CurrentLocation+(NormalizedDirection * DeltaSeconds * UAiSystemManager::Get().MovementSpeed * TileSpeed));
        }

        for(ATile Neighbor : ExplorerCurrentTile.Neighbors)
        {
            if(Neighbor.bFogOfWar)
            {
                Neighbor.bFogOfWar = false;
                if(Neighbor.Fog != nullptr)
                    Neighbor.Fog.DestroyActor();
            }
            
            ATreeTile NeighborAsTreeTile = Cast<ATreeTile>(Neighbor);
            if(NeighborAsTreeTile != nullptr && !AiManager.TileWithWood.Contains(NeighborAsTreeTile) && !NeighborAsTreeTile.bEmpty)
            {
                AiManager.TileWithWood.Add(NeighborAsTreeTile);
            }
        }
 
    }


}