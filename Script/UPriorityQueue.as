
class UPriorityQueue
{
    TArray<UTask> PriorityQueue; 

    UPriorityQueue() {}

    void Add(UTask NewTask)
    {
        for(int i = 0; i<PriorityQueue.Num(); i++)
        {
            if(PriorityQueue[i].Priority == NewTask.Priority )
                PriorityQueue.Insert(NewTask, i);
            break;
        }
        PriorityQueue.Add(NewTask);
    }

    void RemoveFromQueue(UTask TaskToRemove)
    {
        PriorityQueue.Remove(TaskToRemove);
    }
}