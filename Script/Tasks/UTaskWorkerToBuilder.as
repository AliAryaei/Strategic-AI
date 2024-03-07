
class UTaskWorkerToBuilder : UTask
{
    UTaskWorkerToBuilder()
    {
        AiManager = UAiSystemManager::Get();
        Priority = 4;       
    }

    void Execute() override
    {
        if(ExecutionSucceded())
        {
            AiManager.StartUpgradeWorkerToBuilder();
        }
    }
  
    bool ExecutionSucceded() override
    {
        if(AiManager.IdleWorkers.Num() > 0)
        {
            AiManager.TaskQueue.RemoveFromQueue(this);
            return true;   
        }
        return false;
    }
}