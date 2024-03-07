
class UTaskBuildCoalMile : UTask
{
    UTaskBuildCoalMile()
    {
        AiManager = UAiSystemManager::Get();
        Priority = 4;
    }


    void Execute() override
    {
        if(!bCreatedSubtasks)
        {
            CreateSubtasks();
            bCreatedSubtasks = true;
        }
        if(ExecutionSucceded() /*&& AiManager.CanStartBuildingCoalMile()*/ )
        {
            AiManager.StartBuildingCoalMile();
        }
    }

    bool ExecutionSucceded() override
    {
        if(AiManager.IdleBuilders.Num() > 0 && AiManager.NumWood >= AiManager.NumTreeForCoalMile )
        {
            AiManager.TaskQueue.RemoveFromQueue(this);
            return true;
        }
        return false;
    }

    void CreateSubtasks() override
    {

    }
}