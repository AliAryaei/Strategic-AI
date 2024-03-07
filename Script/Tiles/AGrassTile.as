class AGrassTile : ATile
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    { 
        MovementSpeed = 1;
    }

}