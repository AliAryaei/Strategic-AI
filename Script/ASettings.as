
class ASettings : AActor
{
    UPROPERTY()
    int MovementSpeed = 20000;
    UPROPERTY()
    int NumTreeForCharcoal = 2;
    UPROPERTY()
    int NumTreeForCoalMile = 10;
    UPROPERTY()
    float TimeToUpgradeToBuilder = 30;
    UPROPERTY()
    float TimeToUpgradeToExplorer = 30;
    UPROPERTY()
    float TimeToUpgradeToCoalMiler = 30;
    UPROPERTY()
    float TimeToBuildCoalMile = 30;
    UPROPERTY()
    float TimeToChopTree = 30;
    UPROPERTY()
    float TimeToCreateCharcoal = 30;
    UPROPERTY()
    int CharcoalToCreate = 200;

    UPROPERTY()
    int SimulationSpeed = 200;

    UAiSystemManager AiSystemManager;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        AiSystemManager = UAiSystemManager::Get();

        AiSystemManager.NumTreeForCharcoal = NumTreeForCharcoal;
        AiSystemManager.NumTreeForCoalMile = NumTreeForCoalMile;
        AiSystemManager.TimeToBuildCoalMile = TimeToBuildCoalMile;
        AiSystemManager.TimeToChopTree = TimeToChopTree;
        AiSystemManager.TimeToUpgradeToBuilder = TimeToUpgradeToBuilder;
        AiSystemManager.TimeToUpgradeToCoalMiler= TimeToUpgradeToCoalMiler;
        AiSystemManager.TimeToUpgradeToExplorer = TimeToUpgradeToExplorer;
        AiSystemManager.TimeToCreateCharcoal = TimeToCreateCharcoal;
        AiSystemManager.MovementSpeed = MovementSpeed; 
        AiSystemManager.SimulationSpeed = SimulationSpeed;

        for(int i = 0; i < CharcoalToCreate; i++)
            AiSystemManager.TaskQueue.Add(UTaskCreateCharcoal());

        Print(f"{AiSystemManager.NumWood}");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if(AiSystemManager!=nullptr)
        {
            
            // Update AI
            if(AiSystemManager.NumCharcoal<CharcoalToCreate)
                AiSystemManager.UpdateAI(DeltaSeconds);
            
            else
            {
                PrintToScreen("Simulation ended: "+CharcoalToCreate+" Charcoal was created! in time : "+AiSystemManager.TotalSimulationTimeInSeconds);
            }

            // Simulation speed

            if(Gameplay::GetPlayerController(0).IsInputKeyDown(EKeys::P))
            {
                if(AiSystemManager.SimulationSpeed<110)
                    AiSystemManager.SimulationSpeed++;
                PrintToScreen("Simulation speed"+AiSystemManager.SimulationSpeed,5.0f);
            }

            if(Gameplay::GetPlayerController(0).IsInputKeyDown(EKeys::L))
            {
                if(AiSystemManager.SimulationSpeed>1)
                {
                    AiSystemManager.SimulationSpeed--;
                    PrintToScreen("Simulation speed"+AiSystemManager.SimulationSpeed,5.0f);
                }
            }
            

        }
    }

    
}