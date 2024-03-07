
class UTaskWorkerToExplorer : UTask
{
    UTaskWorkerToExplorer()
    {
        AiManager = UAiSystemManager::Get();
        Priority = 5;
    }

    void Execute() override
    {
        if(ExecutionSucceded())
        {
            AiManager.StartUpgradeWorkerToExplorer();
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