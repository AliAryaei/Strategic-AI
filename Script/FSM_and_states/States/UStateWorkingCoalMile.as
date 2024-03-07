
class UStateWorkingCoalMile : UStateBase
{
    UStateWorkingCoalMile(){}

    ACoalMiler EntityAsCoalMiler;

    float TimeElapsed = 0;
    float TargetTime = 10;


    void Enter(AEntity Entity) override
    {
        TargetTime = UAiSystemManager::Get().TimeToCreateCharcoal;
    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
        EntityAsCoalMiler = Cast<ACoalMiler>(Entity);
        if(EntityAsCoalMiler.CharcoalQueue.Num() != 0)
        {
            TimeElapsed += DeltaSeconds;
            if(TimeElapsed > TargetTime)
            {
                TimeElapsed = 0;

                EntityAsCoalMiler.CharcoalQueue.Remove(EntityAsCoalMiler.CharcoalQueue[0]);

                UAiSystemManager::Get().NumCharcoal++;
                Print(f"Charcoal: {UAiSystemManager::Get().NumCharcoal}     Wood: {UAiSystemManager::Get().NumWood}");
            }
        }        
    }

}