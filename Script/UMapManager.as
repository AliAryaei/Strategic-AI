
enum ETypeOfTile
{
    Invalid,
    Grass,
    Mountain,
    Tree,
    Swamp,
    Water
}  

class UMapManager : UScriptWorldSubsystem
{
    UPROPERTY(DefaultComponent)
    USceneComponent SceneRoot;

    int Height = 0;
    int Width = 0;

    //Converts a 1 dimensional array to a 2 dimentional given with X and Y values.
    int LinearIndex(int X, int Y) { return X + Y*Width; }

    TArray<AEntity> AvailibleWorkers;

    TArray<ETypeOfTile> Tiles;
    TMap<int, ATile> TileMap;
    TArray<ATile> NodeArray;


    //Loads a specified file from an absolute path.
    void LoadFile(FString FilePath)
    {
        FString LoadedMapFile;
        FString AbsoluteFilePath = FPaths::ProjectContentDir() + "/"+ FilePath;
        if(FFileHelper::LoadFileToString(LoadedMapFile, AbsoluteFilePath))
        {
            for(int i = 0; i < LoadedMapFile.Len(); i++)
            {
                if(i==0)
                    Height++;

                if(LoadedMapFile[i] == 'T')
                    Tiles.Add(ETypeOfTile::Tree);
                else if(LoadedMapFile[i] == 'V')
                    Tiles.Add(ETypeOfTile::Water);
                else if (LoadedMapFile[i] == 'G')
                    Tiles.Add(ETypeOfTile::Swamp);
                else if(LoadedMapFile[i] == 'B')
                    Tiles.Add(ETypeOfTile::Mountain);
                else if(LoadedMapFile[i] == 'M')
                    Tiles.Add(ETypeOfTile::Grass);

                if(LoadedMapFile[i] == '\n')
                {
                    Height++;
                    if(Width == 0)
                        Width=i;
                }
            }
        }
    }

//     switch(LoadedMapFile[i])
            // {
            //     case 66: //B
            //     {
            //         Tiles.Add(ETypeOfTile::Mountain);
            //         break;
            //     }
            //     case 77: //M
            //     {
            //         Tiles.Add(ETypeOfTile::Grass);
            //         break;
            //     }
            //     case 86: //V
            //     {
            //         Tiles.Add(ETypeOfTile::Water);
            //         break;
            //     }
            //     case 84: //T
            //     {
            //         Tiles.Add(ETypeOfTile::Tree);                    
            //         break;   
            //     }
            //     case 71: //G
            //     {
            //         Tiles.Add(ETypeOfTile::Swamp);
            //         break;   
            //     }
            //     case 10: //New Line
            //     {
            //         Height++;
            //         if(Width == 0)
            //             Width=i;
            //         break; 
            //     }  
            //}      
    ATile GetMapTileFromPosition(FVector Position)
    {
        int PosX = Position.X / 10000;
        int PosY = Position.Y / 10000;
        // if(PosX < 0)
        //     PosX = 0;
        // if(PosY < 0)
        //     PosY = 0;
        // if(PosX > 100)
        //     PosX = 100;
        // if(PosY > 100)
        //     PosY = 100;

        PosX = Math::Clamp(PosX,0,Width-1);
        PosY = Math::Clamp(PosY,0,Height-1);


        ATile tile = NodeArray[LinearIndex(PosX, PosY)];
        if(tile!=nullptr)
            return tile;
        else
        {
            PrintToScreen("I was a little nuller 2",5.0f);
            return nullptr;
        }
    }
    
    ATile GetNextBuildableTile()
    {
        // Start the search from a predefined tile at position (12, 12).
    ATile CurrentTile = NodeArray[LinearIndex(12,12)];
    
    // List of tiles to search.
    TArray<ATile> ToSearch;
    ToSearch.Add(CurrentTile); // Initialize the search list with the starting tile.
    
    // Continue searching as long as there are tiles in the ToSearch list.
    while(ToSearch.Num() != 0)
    {
        for(ATile CurrentSuitable : ToSearch)
        {
            if(CurrentSuitable.bWalkable && !CurrentSuitable.bHasBuilding && !CurrentSuitable.bFogOfWar)
            {
                return CurrentSuitable;
            }
        }
        
        // Temporary list to hold neighbors of the current search list, for the next iteration.
        TArray<ATile> ToAddToToSearch;
        
        // Add all neighbors of each tile in ToSearch to the temporary list.
        for(ATile T : ToSearch)
        {
            for(ATile Neighbor : T.Neighbors)
            {
                ToAddToToSearch.Add(Neighbor);
            }
        } 

        //adding all newly found neighbors to the search list.
        for(ATile Tile : ToAddToToSearch)
        {
            ToSearch.Add(Tile);
        }
    }
    
    return nullptr;
    }
    //Finds the shortest path between two points via the A* algorithm
    TArray<ATile> FindPathAStar(ATile StartNode, ATile TargetNode)
    {
        
        TArray<ATile> ToSearch;
        TArray<ATile> Visited;
        ToSearch.Add(StartNode);  
        Visited.Add(StartNode);

        while(ToSearch.Num() != 0)
        {
            ATile CurrentBestNode = ToSearch[0];
            for(ATile CurrentNode : ToSearch)
            {
                if(CurrentNode.FCost < CurrentBestNode.FCost || CurrentNode.FCost == CurrentBestNode.FCost && CurrentNode.HCost < CurrentBestNode.HCost)
                    CurrentBestNode = CurrentNode;
            }
            CurrentBestNode.bVisited = true;
            Visited.Add(CurrentBestNode);
            ToSearch.Remove(CurrentBestNode);

            if(CurrentBestNode == TargetNode)
            {
                ATile CurrentPathTile = TargetNode;
                TArray<ATile> Path;
                while(CurrentPathTile != StartNode)
                {
                    Path.Add(CurrentPathTile);
                    CurrentPathTile = CurrentPathTile.Connection;
                }

                TArray<ATile> RevPath;
                for(int i = Path.Num()-1; i >= 0; i--)
                {
                    RevPath.Add(Path[i]);
                }

                while(Visited.Num() != 0)
                {
                    Visited[0].bVisited = false;
                    Visited[0].GCost = 0;
                    Visited[0].HCost = 0;
                    Visited[0].FCost = 0;
                    Visited.RemoveAt(0);
                }
                    return RevPath;
            }

            for(ATile Neighbor : CurrentBestNode.Neighbors)
            {
                if(Neighbor.bWalkable && !Neighbor.bVisited && !Neighbor.bFogOfWar)
                {
                    bool bInSearch = ToSearch.Contains(Neighbor);
                    float CostToNeighbor = CurrentBestNode.GCost + CurrentBestNode.GetDistance(Neighbor);
                    if(!bInSearch || CostToNeighbor < Neighbor.GCost)
                    {
                        Neighbor.SetG(CostToNeighbor);
                        Neighbor.SetConnection(CurrentBestNode);
                        if(!bInSearch)
                        {
                            Neighbor.SetH(Neighbor.GetDistance(TargetNode));
                            ToSearch.Add(Neighbor);
                        }
                    }
                }
            }
        }
        TArray<ATile> EmptyArray;
        return EmptyArray;
    }


    ATile GetBaseTile()
    {
        return NodeArray[LinearIndex(5, 5)];
    }
}