class ATileManager : AActor
{
    UPROPERTY(DefaultComponent)
    USceneComponent SceneRoot;
    //The actor to represent your walkable tile.
    UPROPERTY()
    TSubclassOf<AActor> GrassTile;
    //The actor to represent your blocked tile.
    UPROPERTY()
    TSubclassOf<AActor> MountainTile;
    //The actor to represent your start tile.
    UPROPERTY()
    TSubclassOf<AActor> SwampTile;
    //The actor to represent your goal tile.
    UPROPERTY()
    TSubclassOf<AActor> TreeTile;
    //The actor to represent your path tile.
    UPROPERTY()
    TSubclassOf<AActor> WaterTile;
    UPROPERTY()
    TSubclassOf<AActor> FogTile;


    //The actor to represent your tree.
    UPROPERTY()
    TSubclassOf<AEntity> Tree;
    //The actor to represent your Worker.
    UPROPERTY()
    TSubclassOf<AEntity> Worker;
    //The actor to represent your iron ore vein.
    UPROPERTY()
    TSubclassOf<AEntity> IronOre;

    FString MapName = "Maps/Map1.txt";


    //Determines if the AI is find a path diagonally in a square tile map.
    UPROPERTY()
    bool bAllowDiagonalWalk;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        UMapManager MapManager = UMapManager::Get();
        MapManager.LoadFile(MapName);
        int OreRemaining = 60;
        
        for(int j = 0; j < MapManager.Height ; j++)
        {
            for(int i = 0; i < MapManager.Width; i++)
            {
                FVector Location = FVector(i*10000, j*10000, 0);
                FVector FogLocation = Location;
                FogLocation.Z = 60000;
                int Index = MapManager.LinearIndex(i,j);
                int Index10 = MapManager.LinearIndex(i*10,j*10);
                int TileType = MapManager.Tiles[Index];
                AFogTile Fog = Cast<AFogTile>(SpawnActor(FogTile));
                Fog.SetActorLocation(FogLocation);
                
                switch(TileType)
                {
                    
                    case ETypeOfTile::Grass:
                    {
                        AGrassTile ActorToSpawn = Cast<AGrassTile>(SpawnActor(GrassTile));
                        ActorToSpawn.PosX = i*10;
                        ActorToSpawn.PosY = j*10;
                        ActorToSpawn.SetActorLocation(Location);
                        ActorToSpawn.bWalkable = true;
                        ActorToSpawn.Fog = Fog;

                        if(Math::RandRange(0,60) == 1 && OreRemaining != 0)
                        {
                            AIronOreVein IronOreVein = Cast<AIronOreVein>(SpawnActor(IronOre));
                            IronOreVein.SetActorLocation(Location);
                            ActorToSpawn.Entities.Add(IronOreVein);
                        }   

                        MapManager.NodeArray.Add(ActorToSpawn);
                        MapManager.TileMap.Add(Index10, ActorToSpawn);
                        break;
                    }
                    case ETypeOfTile::Mountain:
                    {
                        AMountainTile ActorToSpawn = Cast<AMountainTile>(SpawnActor(MountainTile));
                        Location.Z = 4000;
                        ActorToSpawn.SetActorLocation(Location);
                        ActorToSpawn.PosX = i*10;
                        ActorToSpawn.PosY = j*10;
                        ActorToSpawn.bWalkable = false;
                        MapManager.NodeArray.Add(ActorToSpawn);
                        MapManager.TileMap.Add(Index10, ActorToSpawn);
                        // ActorToSpawn.Fog = Fog; 
                        if(Fog != nullptr) // Ensure the Fog actor was successfully spawned
                        {
                            Fog.DestroyActor();
                        }
                        break;
                    }
                    case ETypeOfTile::Swamp:
                    {
                        ASwampTile ActorToSpawn = Cast<ASwampTile>(SpawnActor(SwampTile));
                        ActorToSpawn.SetActorLocation(Location);
                        ActorToSpawn.PosX = i*10;
                        ActorToSpawn.PosY = j*10;
                        ActorToSpawn.bWalkable = true;
                        MapManager.NodeArray.Add(ActorToSpawn);
                        MapManager.TileMap.Add(Index10, ActorToSpawn);
                        ActorToSpawn.Fog = Fog; 
                        break;
                    }
                    case ETypeOfTile::Water:
                    {
                        AWaterTile ActorToSpawn = Cast<AWaterTile>(SpawnActor(WaterTile));
                        ActorToSpawn.SetActorLocation(Location);
                        ActorToSpawn.PosX = i*10;
                        ActorToSpawn.PosY = j*10;
                        MapManager.NodeArray.Add(ActorToSpawn);
                        MapManager.TileMap.Add(Index10, ActorToSpawn);
                        ActorToSpawn.Fog = Fog; 
                        break;
                    }
                    case ETypeOfTile::Tree:
                    {
                        ATreeTile ActorToSpawn = Cast<ATreeTile>(SpawnActor(TreeTile));
                        ActorToSpawn.SetActorLocation(Location);
                        ActorToSpawn.PosX = i*10;
                        ActorToSpawn.PosY = j*10;
                        ActorToSpawn.bWalkable = true;
                        for(int k = 0; k < 5; k++)
                        {
                            FVector TreeLocation = Location;
                            TreeLocation.Z = TreeLocation.Z + 5000;
                            TreeLocation.X = (Math::RandRange(0,1) == 0 ? Math::RandRange(0,5000) : Math::RandRange(-5000,0)) + TreeLocation.X;
                            TreeLocation.Y = (Math::RandRange(0,1) == 0 ? Math::RandRange(0,5000) : Math::RandRange(-5000,0)) + TreeLocation.Y ;
                            ATree TreeActor = Cast<ATree>(SpawnActor(Tree));
                            TreeActor.CurrentTile = ActorToSpawn;
                            TreeActor.SetActorLocation(TreeLocation);
                            ActorToSpawn.Trees.Add(TreeActor);
                        }
                        MapManager.NodeArray.Add(ActorToSpawn);
                        MapManager.TileMap.Add(Index10, ActorToSpawn);
                        ActorToSpawn.Fog = Fog; 
                        break;
                    }
                }
            }
        }


        for(int k = 5; k < 8; k++)
        {
            for(int l = 5; l < 8; l++)
            {
                ATile Tile = MapManager.TileMap[MapManager.LinearIndex(k*10,l*10)];
                Tile.Fog.DestroyActor();
                Tile.bFogOfWar = false;
            }
        }
        

        for(int i = 0; i < 5; i++)
        {
            for(int j = 0; j < 10; j++)
            {
                AWorker InstantiatedWorker = Cast<AWorker>(SpawnActor(Worker));
                InstantiatedWorker.SetActorLocation(FVector(46000 + 6500*i, 46000 + 3000*j, 0));
                MapManager.AvailibleWorkers.Add(InstantiatedWorker);
            }
        }

        for(int j = 0; j < MapManager.Height; j++)
        {
            for(int i = 0; i < MapManager.Width; i++)
            {
                int Index;
                int LinearI = MapManager.LinearIndex(j,i);

                if(MapManager.TileMap.Contains(MapManager.LinearIndex((j-1)*10,i*10)))
                {
                    Index = MapManager.LinearIndex((j-1)*10,i*10);
                    MapManager.NodeArray[LinearI].Neighbors.Add(MapManager.TileMap[Index]);
                }

                if(MapManager.TileMap.Contains(MapManager.LinearIndex((j+1)*10,i*10)))
                {
                    Index = MapManager.LinearIndex((j+1)*10,i*10);
                    MapManager.NodeArray[LinearI].Neighbors.Add(MapManager.TileMap[Index]);
                }

                if(MapManager.TileMap.Contains(MapManager.LinearIndex(j*10,(i-1)*10)))
                {
                    Index = MapManager.LinearIndex(j*10,(i-1)*10);
                    MapManager.NodeArray[LinearI].Neighbors.Add(MapManager.TileMap[Index]);
                }

                if(MapManager.TileMap.Contains(MapManager.LinearIndex(j*10,(i+1)*10)))
                {
                    Index = MapManager.LinearIndex(j*10,(i+1)*10);
                    MapManager.NodeArray[LinearI].Neighbors.Add(MapManager.TileMap[Index]);
                }

                //Diagonal
                if(bAllowDiagonalWalk)
                {
                    if(MapManager.TileMap.Contains(MapManager.LinearIndex((j-1)*10,(i-1)*10)) &&
                    MapManager.TileMap.Contains(MapManager.LinearIndex((j-1)*10, i*10)) && MapManager.TileMap[MapManager.LinearIndex((j-1)*10, i*10)].bWalkable &&
                    MapManager.TileMap.Contains(MapManager.LinearIndex(j*10,(i-1)*10)) && MapManager.TileMap[MapManager.LinearIndex(j*10,(i-1)*10)].bWalkable)
                    {
                        Index = MapManager.LinearIndex((j-1)*10,(i-1)*10);
                        MapManager.NodeArray[LinearI].Neighbors.Add(MapManager.TileMap[Index]);
                    }

                    if(MapManager.TileMap.Contains(MapManager.LinearIndex((j+1)*10,(i-1)*10)) &&
                    MapManager.TileMap.Contains(MapManager.LinearIndex((j+1)*10, i*10)) && MapManager.TileMap[MapManager.LinearIndex((j+1)*10, i*10)].bWalkable &&
                    MapManager.TileMap.Contains(MapManager.LinearIndex(j*10,(i-1)*10)) && MapManager.TileMap[MapManager.LinearIndex(j*10,(i-1)*10)].bWalkable)
                    {
                        Index = MapManager.LinearIndex((j+1)*10,(i-1)*10);
                        MapManager.NodeArray[LinearI].Neighbors.Add(MapManager.TileMap[Index]);
                    }

                    if(MapManager.TileMap.Contains(MapManager.LinearIndex((j-1)*10,(i+1)*10)) && 
                    MapManager.TileMap.Contains(MapManager.LinearIndex((j-1)*10, i*10)) && MapManager.TileMap[MapManager.LinearIndex((j-1)*10, i*10)].bWalkable &&
                    MapManager.TileMap.Contains(MapManager.LinearIndex(j*10,(i+1)*10)) && MapManager.TileMap[MapManager.LinearIndex(j*10,(i+1)*10)].bWalkable)
                    {
                        Index = MapManager.LinearIndex((j-1)*10,(i+1)*10);
                        MapManager.NodeArray[LinearI].Neighbors.Add(MapManager.TileMap[Index]);
                    }

                    if(MapManager.TileMap.Contains(MapManager.LinearIndex((j+1)*10,(i+1)*10))
                    && MapManager.TileMap.Contains(MapManager.LinearIndex((j+1)*10, i*10)) && MapManager.TileMap[MapManager.LinearIndex((j+1)*10, i*10)].bWalkable
                    && MapManager.TileMap.Contains(MapManager.LinearIndex(j*10,(i+1)*10)) && MapManager.TileMap[MapManager.LinearIndex(j*10,(i+1)*10)].bWalkable)
                    {
                        Index = MapManager.LinearIndex((j+1)*10,(i+1)*10);
                        MapManager.NodeArray[LinearI].Neighbors.Add(MapManager.TileMap[Index]);

                    }
                }
            }
        }
    }
}