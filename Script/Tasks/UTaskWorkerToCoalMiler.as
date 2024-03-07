
class UTaskWorkerToCoalMiler : UTask
{
    ACoalMile CoalMile;
    UTaskWorkerToCoalMiler(ACoalMile _CoalMile)
    {
        AiManager = UAiSystemManager::Get();
        Priority = 5;
        CoalMile = _CoalMile;
    }

    void Execute() override
    {
        if(ExecutionSucceded())
        {
            UAiSystemManager::Get().StartUpgradeWorkerToCoalMiler(CoalMile);
        }
    }

    bool ExecutionSucceded() override
    {
        if(UAiSystemManager::Get().IdleWorkers.Num() > 0)
        {
            UAiSystemManager::Get().TaskQueue.RemoveFromQueue(this);
            return true;
        }
        return false;
    }
}