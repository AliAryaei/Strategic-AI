//     USTRUCT()
//     struct FEncapsule
//     {
//         TArray<UNode> Columns;
//     } 
// class UMapGeneratorSubsystem : UScriptWorldSubsystem
// {
//     UNode Start;
//     UNode Target;

//     TArray<FEncapsule> LevelMap;
//     AMapManager2 Manager;

//     UFUNCTION(BlueprintOverride)
//     void Initialize()
//     {
//         Print("Subsystem initialized");
        
//     }

//     UFUNCTION(BlueprintOverride)
//     void OnWorldBeginPlay()
//     {
//         TArray<AMapManager2> foundActors;
//         PrintToScreen("I am here",5.0f);
//         GetAllActorsOfClass(foundActors);
//         if (foundActors.Num() > 0)  //chech if there are any actors 
//         {
//             Manager = foundActors[0];
//             LoadMap();
//         }
//         else
//         {
//             Print("No AMapManager actors found in the world!");
//         }
//     }

//     FString GetPath()
//     {
//         FString Content;
//         FString ContentDir = FPaths::ProjectContentDir();
//         FString Extention = ".txt";
//         FString MapName = "MapAI";
//         FString FinalPath = ContentDir + "Maps/" + MapName + Extention;

//         if(Paths::FileExists(FinalPath))
//         {
//             FFileHelper::LoadFileToString(Content, FinalPath);
//             PrintToScreen("Map Found",5.0f);
//             return Content;
//         }
//         else
//         {
//             Print("Map not found!");
//             return FString();
//         }
//     }

//     UFUNCTION()
//     void LoadMap( )
//     {
//         FString Content;
//         Content = GetPath();
//         LevelMap.Add(FEncapsule()); // Adding the first row
//         // Print("Map Layout:  \n" + Content);

//         int Row = 0;
//         int Column = 0;
//         // Create the grid based on the file contents
//         for (int i = 0; i < Content.Len(); i++)
//         {
//             FVector Location = FVector(Column * Manager.Scale, Row * Manager.Scale, 0);
//             // PrintToScreen(""+Manager.Scale,5.0f);
            
//             switch(Content[i])
//             {
//                 case 66: //B
//                 {
//                     SpawnBlocks(Location, Manager.Mountain);
//                     LevelMap[Row].Columns.Add(UNode(Column,Row,false)); // Adding new node in the current row
//                     Column++;
//                     break;
//                 }
//                 case 77: //M
//                 {
//                     SpawnBlocks(Location, Manager.Ground);
//                     LevelMap[Row].Columns.Add(UNode(Column,Row,true));  // Adding new node in the current row
//                     Column++;
//                     break;
//                 }
//                 case 86: //V
//                 {
//                     SpawnBlocks(Location, Manager.Water);
//                     LevelMap[Row].Columns.Add(UNode(Column,Row,true));  // Adding new node in the current row
//                     Start = LevelMap[Row].Columns[Column];
//                     Column++;
//                     break;
//                 }
//                 case 84: //T
//                 {
//                     SpawnBlocks(Location, Manager.Trees);
//                     SpawnBlocks(Location, Manager.TreeTile);

//                     LevelMap[Row].Columns.Add(UNode(Column,Row,true));  // Adding new node in the current row
//                     Target = LevelMap[Row].Columns[Column];
//                     Column++;
//                     break;   
//                 }
//                 case 71: //G
//                 {
//                     SpawnBlocks(Location, Manager.Swammp);
//                     LevelMap[Row].Columns.Add(UNode(Column,Row,true));  // Adding new node in the current row
//                     Target = LevelMap[Row].Columns[Column];
//                     Column++;
//                     break;   
//                 }
//                 case 10: //New Line
//                 {
//                     LevelMap.Add(FEncapsule()); // Adding a next row
//                     Row++;
//                     Column = 0;
//                     break; 
//                 }        
//             }
//         }
//         Row++;

//         // Adds the neigbors to each node
//         // for(int y = 0; y < Row; y++) {
//         //     for(int x = 0; x < Column; x++) {
//         //         GetNeigbors(LevelMap[y].Columns[x], LevelMap, Row, Column);
//         //     }
//         // }

//         // // calculate path
//         // TArray<UNode> Temp;
//         // FDateTime StartT =FDateTime::UtcNow();
//         // int32 StartMs = StartT.GetMillisecond();
//         // int64 UnixStart = StartT.ToUnixTimestamp() * 1000 + StartMs;
//         // for(int i = 0; i < 1000; i++)
//         // {
//         //     Temp = FindPathAStar(Start,Target,LevelMap);
//         //     //TArray<UNode> Temp = BreadthFirstPathFind(Start,Target,LevelMap);
//         //     //TArray<UNode> Temp = DepthFirstPathFind(Start,Start,Target);
//         //     // TArray<UNode> Temp = MyPathFinder(Start,Target,LevelMap);
//         // }
//         // FDateTime EndT = FDateTime::UtcNow();
//         // int32 EndMs = EndT.GetMillisecond();
//         // int64 UnixEnd = EndT.ToUnixTimestamp() * 1000 + EndMs;
//         // int64 DeltaUnix = (UnixEnd-UnixStart);
//         // Print("DeltaUnix: " + DeltaUnix + " ms");

//         // // plot the path
//         // for(UNode Node : Temp) {
//         //     FVector Location = FVector(Node.PosX, Node.PosY, 0) * Manager.Scale;
//         //         SpawnBlocks(Location,Manager.Path);
//         // }
//     }   

//     UFUNCTION()
//     void SpawnBlocks(FVector Location, TSubclassOf<AActor> Mesh)
//     {
//         AActor Object = SpawnActor(Mesh,Location,FRotator::ZeroRotator);
//         if (Object == nullptr)
//         {
//             Print("Failed to spawn block actor because of null pointer!");
//         }
//     }
// }

// UFUNCTION()
// void GetNeigbors(UNode Node, TArray<FEncapsule> Array, int NumRows, int NumColumns) {
//     TArray<UNode> Temp;
    
//     for (int y = -1; y <= 1; y++) {
//         for(int x = -1; x <= 1; x++) {
//             if(x == 0 && y == 0) continue;
//             int Neighbor_row = Node.PosY + y;
//             int Neighbor_col = Node.PosX + x;

//             // Verify that the neighbor is contained inside the grid's boundaries
//             if (Neighbor_row >= 0 && Neighbor_row < NumRows && Neighbor_col >= 0 && Neighbor_col < NumColumns) {
//                 Temp.Add(Array[Neighbor_row].Columns[Neighbor_col]);
//             }
//         }
//     }
//     Node.Neighbors = Temp;
// }

//   // // Spawns a floor
//     //     AActor Floor = SpawnBlocks(Manager.Floor, FVector(0,0,0));
//     //     Floor.SetActorScale3D(FVector(Column,Row,1));
//     //     bMapRenderd = true;


