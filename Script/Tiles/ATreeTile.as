class ATreeTile : ATile
{
    bool bEmpty = false;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    { 
        MovementSpeed = 1;
    }
}