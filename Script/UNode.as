

// enum EResourceType
// {
//     None,
//     Tree,
//     FelledTree,
//     Charcoal,
//     IronOre,
//     IronIngot,
//     Sword
// };

// struct FResource
// {

//     EResourceType ResourceType = EResourceType::None;

//     int Quantity = 0;

//     // Constructor for convenience
//     FResource() {}

//     FResource(EResourceType InType, int InQuantity)
//     {
//         ResourceType = InType;
//         Quantity = InQuantity;
//     }
// };

// class UNode : UObject
// {

//     UNode Connection;
//     UNode PreviousConnection;
//     TArray<UNode> Neighbors;

//     float GCost, HCost, FCost;
//     int PosX, PosY;

//     int32 NodeIndex;
//     int32 ConnectionIndex;

//     bool bVisitedByStart = false;
//     bool bVisitedByTarget = false;
    
//     bool bVisited = false;
//     bool bWalkable;

//     TArray<FResource> Resources;

//     UNode(int _PosX, int _PosY)
//     {
//         PosX = _PosX;
//         PosY = _PosY;
//     }
    
//     //Connect two nodes together.
//     void SetConnection(UNode Node) 
//     { Connection = Node; }

//     //Establish a reverse connection between two nodes.
//     void SetPreviousConnection(UNode Node) 
//     { PreviousConnection = Node; }

//     void UpdateFCost() 
//     { FCost = GCost + HCost;}

//      UNode(int StartX, int StartY, bool b)
//     {
//         PosX = StartX;
//         PosY = StartY;
//         bWalkable = b;
//     }

//     //Obtains the calculated distance between nodes A and B
//     float GetDistance(UNode OtherNode)
//     {
//         float XPos = PosX-OtherNode.PosX;
//         float YPos = PosY-OtherNode.PosY;
//         float Result = Math::Sqrt(Math::Abs(XPos*XPos+YPos*YPos));
//         return Result;
//     }

//     // Sets the GCost
//     void SetGCost(float _GCost)
//     {
//         GCost = _GCost;
//         UpdateFCost();
//     }
//     //Sets the HCost
//     void SetHCost(float _HCost)
//     {
//         HCost = _HCost;
//         UpdateFCost();
//     }
    
//     void AddResource(EResourceType ResourceType, int Quantity)
//     {
//         // Find if the resource type already exists in the node
//         for (FResource& Resource : Resources)
//         {
//             if (Resource.ResourceType == ResourceType)
//             {
//                 // Update quantity and return
//                 Resource.Quantity += Quantity;
//                 return;
//             }
//         }

//         // If not found, add a new resource
//         Resources.Add(FResource(ResourceType, Quantity));
//     }

//     bool RemoveResource(EResourceType ResourceType, int Quantity)
//     {
//         for (FResource& Resource : Resources)
//         {
//             if (Resource.ResourceType == ResourceType)
//             {
//                 if (Resource.Quantity >= Quantity)
//                 {
//                     Resource.Quantity -= Quantity;
//                     return true; // Successfully removed or updated
//                 }
//                 // Not enough quantity
//                 break;
//             }
//         }
//         return false; // Failed to remove, not enough resources or not found
//     }
//     // NOTE: add more methods here for specific actions, like FellingTree, MiningIronOre, etc.

// }