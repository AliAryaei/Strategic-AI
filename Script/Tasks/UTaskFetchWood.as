
class UTaskFetchWood : UTask
{
    UTaskFetchWood()
    {
        AiManager = UAiSystemManager::Get();
        Priority = 4;
    }
    void Execute() override
    {
        if(ExecutionSucceded())
        {
            AiManager.FetchWood();
        }
        
    }

    bool ExecutionSucceded() override
    {
         if(AiManager.IdleWorkers.Num() > 0 && AiManager.TileWithWood.Num() > 0)
         {
            AiManager.TaskQueue.RemoveFromQueue(this);
            return true;
         }
         return false;
    }

    void CreateSubtasks() override
    {
        AiManager.TaskQueue.Add(UTaskFetchWood());
    }
}