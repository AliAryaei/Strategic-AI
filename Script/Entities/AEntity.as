class AEntity : AActor
{
    UPROPERTY(DefaultComponent)
    USceneComponent SceneRoot;
    UPROPERTY(DefaultComponent, Attach = SceneRoot)
    UStaticMeshComponent StaticMesh;
    ATile StartTile;
    float Offset = 500;

    bool bIsCarrying = false;

    ATile CurrentTile;
}


