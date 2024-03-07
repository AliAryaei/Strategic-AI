class AMountainTile : ATile
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    { 
        MovementSpeed = 1;
    }
}