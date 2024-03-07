
class UStateExplorer : UStateBase
{
    UStateExplorer()
    {

    }

    void Enter(AEntity Entity) override
    {

    }

    void Execute(AEntity Entity, float DeltaSeconds) override
    {
        AExplorer EntityAsExplorer = Cast<AExplorer>(Entity);
        EntityAsExplorer.ExplorerUpdate(DeltaSeconds);
    }
}