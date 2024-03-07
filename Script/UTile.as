
class ATile : AActor
{
    UPROPERTY(DefaultComponent)
    USceneComponent SceneRoot;
    UPROPERTY(DefaultComponent, Attach = SceneRoot)
    UStaticMeshComponent StaticMesh;

    AFogTile Fog;
    ATile Connection;
    ATile BackwardConnection;

    TArray<ATile> Neighbors;
    TArray<AEntity> Entities;
    TArray<ATree> Trees;

    int PosX, PosY;
    
    float GCost;
    float HCost;
    float FCost;
    float MovementSpeed;

    bool bVisited = false;
    bool bWalkable;
    bool bHasBuilding = false;
    bool bFogOfWar = true;

    //Set connection between two nodes
    void SetConnection(ATile Node) 
    { 
        Connection = Node; 
    }
    //Set backward connection between two nodes.
    void SetBackwardConnection(ATile Node) 
    { 
        BackwardConnection = Node; 
    }

    void UpdateFCost() 
    { 
        FCost = GCost + HCost;
    }

    //Gets estimated distance from node A to node B
    float GetDistance(ATile OtherNode)
    {
        float XX = PosX/10-OtherNode.PosX/10;
        float YY = PosY/10-OtherNode.PosY/10;
        float Result = Math::Sqrt(Math::Abs(XX*XX+YY*YY));
        return Result;
    }

    // Sets the variable GCost
    void SetG(float _GCost)
    {
        GCost = _GCost;
        UpdateFCost();
    }
    //Sets the variable HCost
    void SetH(float _HCost)
    {
        HCost = _HCost;
        UpdateFCost();
    }

    ATile(int _PosX, int _PosY)
    {
        PosX = 0;
        PosY = 0;
        GCost = 0;
        HCost = 0;
        FCost = 0;

        bVisited = false;
        bWalkable = true;
        bFogOfWar = true;
    }
}