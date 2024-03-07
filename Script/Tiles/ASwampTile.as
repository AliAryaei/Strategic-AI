class ASwampTile : ATile
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    { 
        MovementSpeed = 0.5;
    }
}