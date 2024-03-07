
class UAiSystemManager : UScriptWorldSubsystem
{
    int NumWood = 0;
    int MaxExplorers = 7;
    int MaxCoalMilers = 7;
    int MaxCoalMiles = 3;
    int MaxBuilder = 4;
    int NumCharcoal = 0;
    int NumOfCoalMilesCreated = 0;

    int NumTreeForCharcoal;
    int NumTreeForCoalMile;
    float MovementSpeed;
    float TimeToUpgradeToBuilder;
    float TimeToUpgradeToExplorer;
    float TimeToUpgradeToCoalMiler;
    float TimeToBuildCoalMile;
    float TimeToChopTree;
    float TimeToCreateCharcoal;
    float Offset;

    UPriorityQueue TaskQueue = UPriorityQueue(); 
    TArray<UFiniteStateMachine> FiniteStateMachineArray;
    TArray<AWorker> IdleWorkers;
    TArray<ABuilder> IdleBuilders;
    TArray<ATile> TileWithWood;
    TArray<ACoalMile> AllCoalMiles;
    UInputComponent ScriptableInputComponent;

    int SimulationSpeed = 1;

    float TotalSimulationTimeInSeconds=0.0f;


    TArray<ATile> FindPath(ATile StartTile, ATile TargetTile)
    {
        UMapManager MapManager = UMapManager::Get();
        TArray<ATile> Path = MapManager.FindPathAStar(StartTile, TargetTile);
        
        return Path;
    }

    bool RequestTree()
    {
        IdleWorkers[0].FSM.ChangeState(UStateFetchWood());
        return true;
    }

    bool StartUpgradeWorkerToBuilder()
    {
        IdleWorkers[0].FSM.ChangeState(UStateUpgradeToBuilder());
        return true;
    }

    bool StartUpgradeWorkerToExplorer()
    {
        IdleWorkers[0].FSM.ChangeState(UStateUpgradeToExplorer());
        return true;
    }

    bool StartBuildingCoalMile()
    {
        IdleBuilders[0].FSM.ChangeState(UStateBuild());
        NumWood -= NumTreeForCoalMile;
        // NumOfCoalMilesCreated++;;
        return true;
    }

    bool StartUpgradeWorkerToCoalMiler(ACoalMile _CoalMile) 
    {
        IdleWorkers[0].CoalMile = _CoalMile;
        IdleWorkers[0].FSM.ChangeState(UStateUpgradeToCoalMiler());
        return true;
    }

    void BuildCoalMile()
    {
        NumWood -= NumTreeForCoalMile;
        TaskQueue.Add(UTaskWorkerToCoalMiler());
    }

    void MakeCharcoal(ACoalMile _CoalMile)
    {
        NumWood -= NumTreeForCharcoal;
        IdleWorkers[0].CoalMile = _CoalMile;
        IdleWorkers[0].FSM.ChangeState(UStateWorkerDeliverWoodToCoalMile());
    }

    void FetchWood()
    {
        IdleWorkers[0].TreeTile = TileWithWood[0];
        IdleWorkers[0].TreeToCut = TileWithWood[0].Trees[0];
        TileWithWood[0].Trees.Remove(TileWithWood[0].Trees[0]);

        if(TileWithWood[0].Trees.Num() == 0)
        {
            Cast<ATreeTile>(TileWithWood[0]).bEmpty = true;
            TileWithWood.Remove(TileWithWood[0]);
        }
        IdleWorkers[0].FSM.ChangeState(UStateFetchWood());
    }

    void CreateCharcoal()
    {
        ACoalMile CoalMile = AllCoalMiles[0];
        IdleWorkers[0].FSM.ChangeState(UStateWorkerDeliverWoodToCoalMile(CoalMile));
        AllCoalMiles.Remove(CoalMile);
        AllCoalMiles.Add(CoalMile);
        NumWood -= NumTreeForCharcoal;     
    }
    
    void UpdateAI(float DeltaSeconds)
    {
        float SimulationUpdateTime = (SimulationSpeed*DeltaSeconds);

        TotalSimulationTimeInSeconds+=SimulationUpdateTime;

        Offset = 500 * (MovementSpeed/200.f);
        PrintToScreen("Current Wood Count:"+NumWood);
        PrintToScreen("Current Charcoal Count:"+NumCharcoal);

        // Making the explorers
        if(MaxExplorers != 0)
        {
            for(int i = 0; i < 7; i++)
            {
                TaskQueue.Add(UTaskWorkerToExplorer());
                MaxExplorers--;
            }
        }
        // Tasks
        for(int i = 0; i < TaskQueue.PriorityQueue.Num(); i++)
        {

            UTaskWorkerToExplorer WorkerToExplorer = Cast<UTaskWorkerToExplorer>(TaskQueue.PriorityQueue[i]);
            if(WorkerToExplorer != nullptr)
            {
                WorkerToExplorer.Execute();
                continue;
            }

            UTaskWorkerToBuilder WorkerToBuilder =  Cast<UTaskWorkerToBuilder>(TaskQueue.PriorityQueue[i]);
            if(WorkerToBuilder != nullptr)
            {
                WorkerToBuilder.Execute();
                continue;
            }

            UTaskWorkerToCoalMiler WorkerToCoalMiler =  Cast<UTaskWorkerToCoalMiler>(TaskQueue.PriorityQueue[i]);
            if(WorkerToCoalMiler != nullptr)
            {
                WorkerToCoalMiler.Execute();
                continue;
             }

            UTaskCreateCharcoal CreateCharcoal = Cast<UTaskCreateCharcoal>(TaskQueue.PriorityQueue[i]);
            if(CreateCharcoal != nullptr)
            {
                CreateCharcoal.Execute();
                continue;
            }

            UTaskFetchWood FetchWood = Cast<UTaskFetchWood>(TaskQueue.PriorityQueue[i]);
            if(FetchWood != nullptr)
            {
                FetchWood.Execute();
                continue;
            }

            UTaskBuildCoalMile BuildCoalMile = Cast<UTaskBuildCoalMile>(TaskQueue.PriorityQueue[i]);
            if(BuildCoalMile != nullptr)
            {
                BuildCoalMile.Execute();
                continue;
            }

        }
        for(int i = 0; i < FiniteStateMachineArray.Num(); i++)
        {
            FiniteStateMachineArray[i].Update(SimulationUpdateTime);
        }
    }

    

}