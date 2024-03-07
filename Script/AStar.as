// //utilizes the A* algorithm to find the shortest route between two places
// UFUNCTION()
// TArray<UNode> FindPathAStar(UNode StartNode, UNode TargetNode, TArray<FEncapsule> Map)
// {
//     TArray<UNode> NodesToSearch;
//     TArray<UNode> VisitedNodes;
//     NodesToSearch.Add(StartNode); 
//     VisitedNodes.Add(StartNode);
//     while(NodesToSearch.Num() != 0)
//     {
//         UNode CurrentBestNode = NodesToSearch[0];
//         for(UNode CurrentNode : NodesToSearch)
//         {
//             if(CurrentNode.FCost < CurrentBestNode.FCost || (CurrentNode.FCost == CurrentBestNode.FCost && CurrentNode.HCost < CurrentBestNode.HCost))
//                 CurrentBestNode = CurrentNode;
//         }

//         if(CurrentBestNode == TargetNode)
//         {
//             UNode CurrentPathTile = TargetNode;
//             TArray<UNode> Path;
//             while(CurrentPathTile != nullptr)
//             {
//                 Path.Add(CurrentPathTile);
//                 CurrentPathTile = CurrentPathTile.Connection;
//             }
//             return Path;
//         }

//         NodesToSearch.Remove(CurrentBestNode);
//         VisitedNodes.Add(CurrentBestNode);

//         for(UNode Neighbor : CurrentBestNode.Neighbors)
//         {
//             if(Neighbor.bWalkable && !VisitedNodes.Contains(Neighbor))
//             {

//                 // One should not be able to shortcut through corners
//                     int DeltaX = Neighbor.PosX - CurrentBestNode.PosX;
//                     int DeltaY = Neighbor.PosY - CurrentBestNode.PosY;
//                     if(DeltaX == 1 && DeltaY == 1) {
//                         if(!Map[Neighbor.PosY-1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX-1].bWalkable)
//                         continue;
//                     }
//                     if(DeltaX == -1 && DeltaY == 1) {
//                         if(!Map[Neighbor.PosY-1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX+1].bWalkable)
//                         continue;
//                     }
//                     if(DeltaX == -1 && DeltaY == -1) {
//                         if(!Map[Neighbor.PosY+1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX+1].bWalkable)
//                         continue;
//                     }
//                     if(DeltaX == 1 && DeltaY == -1) {
//                         if(!Map[Neighbor.PosY+1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX-1].bWalkable)
//                         continue;
//                     }
//                 //
//                 bool bInSearch = NodesToSearch.Contains(Neighbor);
//                 float CostToNeighbor = CurrentBestNode.GCost + CurrentBestNode.GetDistance(Neighbor);
//                 if(!bInSearch || CostToNeighbor < Neighbor.GCost)
//                 {
//                     Neighbor.GCost = CostToNeighbor;
//                     Neighbor.Connection = CurrentBestNode;
//                     if(!bInSearch)
//                     {
//                         Neighbor.HCost = Neighbor.GetDistance(TargetNode);
//                         Neighbor.FCost = Neighbor.GCost + Neighbor.HCost;
//                         NodesToSearch.Add(Neighbor);
//                     }
//                 }
//             }
//         }
//     }
//     // In case no path is found we return an empty array
//     TArray<UNode> Empty;
//     return Empty;
// }

    

//     UFUNCTION()
//     TArray<UNode> BreadthFirstPathFind(UNode StartNode, UNode TargetNode,TArray<FEncapsule> Map) 
//     {
//         TArray<UNode> CurrentList;
//         TArray<UNode> Visited;
        
//         Visited.Add(StartNode);
//         CurrentList.Add(StartNode);
//         while(CurrentList.Num() != 0)
//         {
//             TArray<UNode> NextList;
//             for(UNode CurrentNode : CurrentList)
//             {

//                 if(CurrentNode == TargetNode)
//                 {
//                     UNode CurrentPathTile = TargetNode;
//                     TArray<UNode> Path;
//                     while(CurrentPathTile != StartNode)
//                     {
//                         Path.Add(CurrentPathTile);
//                         CurrentPathTile = CurrentPathTile.Connection;
//                     }
//                     while(Visited.Num() != 0)
//                     {
//                         Visited[0].bVisited = false;
//                         Visited[0].bVisitedByStart = false;
//                         Visited[0].bVisitedByTarget = false;
//                         Visited.RemoveAt(0);
//                     }
//                         return Path;
//                 }

//                 for(UNode Neighbor : CurrentNode.Neighbors)
//                 {
//                     if(!Neighbor.bVisited && Neighbor.bWalkable)
//                     {
//                         // One should not be able to shortcut through corners
//                         int DeltaX = Neighbor.PosX - CurrentNode.PosX;
//                         int DeltaY = Neighbor.PosY - CurrentNode.PosY;
//                         if(DeltaX == 1 && DeltaY == 1) {
//                             if(!Map[Neighbor.PosY-1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX-1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == -1 && DeltaY == 1) {
//                             if(!Map[Neighbor.PosY-1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX+1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == -1 && DeltaY == -1) {
//                             if(!Map[Neighbor.PosY+1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX+1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == 1 && DeltaY == -1) {
//                             if(!Map[Neighbor.PosY+1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX-1].bWalkable)
//                             continue;
//                         }
//                         Neighbor.bVisited = true;
//                         Visited.Add(Neighbor);
//                         NextList.Add(Neighbor);
//                         Neighbor.SetConnection(CurrentNode);
//                     }
//                 }
//             }
//             CurrentList = NextList;
//         }
//         TArray<UNode> EmptyArray;
//         return EmptyArray;
//     }


//     // //uses a depth-first search to identify a route between points A and B
//     UFUNCTION()
//     TArray<UNode> DepthFirstPathFind(UNode StartNode, UNode CurrentNode, UNode TargetNode) 
//     {
//         TArray<UNode> Stack;
//         TArray<UNode> VisitedNodes;

//         VisitedNodes.Add(CurrentNode);
//         Stack.Add(CurrentNode);

//         if(CurrentNode == TargetNode)
//         {
//             UNode CurrentPathTile = TargetNode;
//             TArray<UNode> Path;
//             while(CurrentPathTile != StartNode)
//             {
//                 Path.Add(CurrentPathTile);
//                 CurrentPathTile = CurrentPathTile.Connection;
//             }
            
//             while(VisitedNodes.Num() != 0)
//             {
//                 VisitedNodes[0].bVisited = false;
//                 VisitedNodes[0].bVisitedByStart = false;
//                 VisitedNodes[0].bVisitedByTarget = false;
//                 VisitedNodes.RemoveAt(0);
//             }
//                 return Path;
//         }
//         CurrentNode.bVisited = true;
//         VisitedNodes.Add(CurrentNode);
//         CurrentNode.Neighbors.Shuffle();

//         for(UNode Neighbor : CurrentNode.Neighbors)
//         {
//             if(!Neighbor.bVisited && Neighbor.bWalkable)
//             {
//                 Neighbor.SetConnection(CurrentNode);
//                 Stack = DepthFirstPathFind(StartNode, Neighbor, TargetNode);
//                 if(Stack.Num() != 0)
//                 return Stack;
//             }
//         }
//         TArray<UNode> EmptyArray;
//         return EmptyArray;
//     }

//     //locate a path from A to B by using a bidirectional breadth-first search 
//     UFUNCTION()
//     TArray<UNode> MyPathFinder(UNode StartNode, UNode TargetNode,TArray<FEncapsule> Map)
//     {
//         TArray<UNode> Queue1;
//         TArray<UNode> Queue2;
//         TArray<UNode> Visited;
//         Visited.Add(StartNode);
//         Visited.Add(TargetNode);

//         Queue1.Add(StartNode);
//         Queue2.Add(TargetNode);

//         while(Queue1.Num() != 0 && Queue2.Num() != 0)
//         {
//             TArray<UNode> NextQueue;
//             for(UNode CurrentNode : Queue1)
//             {
//                 for(UNode Neighbor : CurrentNode.Neighbors)
//                 {
//                     if(!Neighbor.bVisitedByStart && Neighbor.bWalkable)
//                     {
//                         // One should not be able to shortcut through corners
//                         int DeltaX = Neighbor.PosX - CurrentNode.PosX;
//                         int DeltaY = Neighbor.PosY - CurrentNode.PosY;
//                         if(DeltaX == 1 && DeltaY == 1) {
//                             if(!Map[Neighbor.PosY-1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX-1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == -1 && DeltaY == 1) {
//                             if(!Map[Neighbor.PosY-1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX+1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == -1 && DeltaY == -1) {
//                             if(!Map[Neighbor.PosY+1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX+1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == 1 && DeltaY == -1) {
//                             if(!Map[Neighbor.PosY+1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX-1].bWalkable)
//                             continue;
//                         }
//                         Neighbor.bVisitedByStart = true;
//                         Visited.Add(Neighbor);
//                         NextQueue.Add(Neighbor);
//                         Neighbor.SetConnection(CurrentNode);
//                     }
//                 }
//             }
//             Queue1 = NextQueue;
//             NextQueue.Empty();
        
//             for(UNode CurrentNode : Queue2)
//             {
//                 for(UNode Neighbor : CurrentNode.Neighbors)
//                 {
//                     if(Neighbor.bVisitedByStart )
//                     {
//                         TArray<UNode> Path;
//                         UNode CurrentPathTile = CurrentNode;
//                         while(CurrentPathTile != TargetNode)
//                         {
//                             Path.Add(CurrentPathTile);
//                             CurrentPathTile = CurrentPathTile.PreviousConnection;
//                         }
//                         CurrentPathTile = Neighbor;
//                         while(CurrentPathTile != StartNode)
//                         {
//                             Path.Add(CurrentPathTile);
//                             CurrentPathTile = CurrentPathTile.Connection;
//                         }

//                         while(Visited.Num() != 0)
//                         {
//                             Visited[0].bVisited = false;
//                             Visited[0].bVisitedByStart = false;
//                             Visited[0].bVisitedByTarget = false;
//                             Visited.RemoveAt(0);
//                         }
//                         return Path;

//                     }
//                     if(!Neighbor.bVisitedByTarget && Neighbor.bWalkable)
//                     {
                        
//                         // One should not be able to shortcut through corners
//                         int DeltaX = Neighbor.PosX - CurrentNode.PosX;
//                         int DeltaY = Neighbor.PosY - CurrentNode.PosY;
//                         if(DeltaX == 1 && DeltaY == 1) {
//                             if(!Map[Neighbor.PosY-1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX-1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == -1 && DeltaY == 1) {
//                             if(!Map[Neighbor.PosY-1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX+1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == -1 && DeltaY == -1) {
//                             if(!Map[Neighbor.PosY+1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX+1].bWalkable)
//                             continue;
//                         }
//                         if(DeltaX == 1 && DeltaY == -1) {
//                             if(!Map[Neighbor.PosY+1].Columns[Neighbor.PosX].bWalkable || !Map[Neighbor.PosY].Columns[Neighbor.PosX-1].bWalkable)
//                             continue;
//                         }
//                         Visited.Add(Neighbor);
//                         Neighbor.bVisitedByTarget = true;
//                         Neighbor.SetPreviousConnection(CurrentNode);
//                         NextQueue.Add(Neighbor);
//                     }
//                 }
//             }
//             Queue2 = NextQueue;
//         }
//         TArray<UNode> EmptyArray;
//         return EmptyArray;
//     }


  
