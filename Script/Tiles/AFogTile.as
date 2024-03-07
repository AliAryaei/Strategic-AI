
class AFogTile : ATile
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    { 
        MovementSpeed = 1;
    }

}