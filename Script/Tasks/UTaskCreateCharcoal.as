

class UTaskCreateCharcoal : UTask
{
    int WoodRequired;

    UTaskCreateCharcoal()
    {
        AiManager = UAiSystemManager::Get();
        Priority = 1;       
    }
    
    void Execute() override
    {
        if(!bCreatedSubtasks)
        {
            CreateSubtasks();
            bCreatedSubtasks = true;
        }
        if(ExecutionSucceded())
        {
            AiManager.TaskQueue.RemoveFromQueue(this);
            ACoalMile CoalMile = AiManager.AllCoalMiles[0];
            AiManager.IdleWorkers[0].FSM.ChangeState(UStateWorkerDeliverWoodToCoalMile(CoalMile));
            AiManager.AllCoalMiles.Remove(CoalMile);
            AiManager.AllCoalMiles.Add(CoalMile);
            AiManager.NumWood -= AiManager.NumTreeForCharcoal; 
        }
        
    }

    bool ExecutionSucceded() override
    {
        if(AiManager.NumWood >= AiManager.NumTreeForCharcoal && AiManager.IdleWorkers.Num() > 0 && AiManager.AllCoalMiles.Num() > 0)
        {
            if(AiManager.AllCoalMiles[0].CoalMileOwner == nullptr)
            {
                return false;
            }
            return true;

        }
        return false;
    }

    void CreateSubtasks() override
    {
        if(AiManager.MaxCoalMiles == 0) 
            WoodRequired = AiManager.NumTreeForCharcoal;
        else 
            WoodRequired = AiManager.NumTreeForCharcoal + AiManager.NumTreeForCoalMile;

        if(AiManager.MaxCoalMiles != 0)
        {
            AiManager.TaskQueue.Add(UTaskBuildCoalMile());
            AiManager.MaxCoalMiles--;
        }
        if(AiManager.MaxBuilder != 0)
        {
            AiManager.TaskQueue.Add(UTaskWorkerToBuilder());
            AiManager.MaxBuilder--;
        }
        for(int i = 0; i < WoodRequired; i++)
        {
            AiManager.TaskQueue.Add(UTaskFetchWood());
        }
    }

}