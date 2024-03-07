
class AMeshProvider : AActor
{

    UPROPERTY()
    UClass Worker;
    UPROPERTY()
    UClass ExplorerMesh;
    UPROPERTY()
    UClass BuilderMesh;
    UPROPERTY()
    UClass CoalMileMesh;
    UPROPERTY()
    UClass CoalMilerMesh;
    

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        UActorMesh Meshes = UActorMesh::Get();
        Meshes.Explorer = ExplorerMesh;
        Meshes.Builder = BuilderMesh;
        Meshes.CoalMile = CoalMileMesh;
        Meshes.CoalMiler = CoalMilerMesh;
    }


}