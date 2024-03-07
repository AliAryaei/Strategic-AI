class AWaterTile : ATile
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    { 
        MovementSpeed = 1;
    }
}