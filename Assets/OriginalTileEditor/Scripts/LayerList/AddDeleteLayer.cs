// TODO: Only allow remove layers if > 1 exists.

public class AddDeleteLayer : ECSSystem
{
    private void Update()
    {
        var activeLayer = GetEntityItem1<ActiveLayer>();
        var actionHistory = GetEntityItem1<ActionHistory>();

        foreach (var entity in GetEntities<MouseDownEvent, RemoveActiveLayerButton>())
            if (activeLayer && activeLayer.active)
                actionHistory.Perform<LayerRemoveAction>(activeLayer);

        foreach (var entity in GetEntities<MouseDownEvent, AddLayerButton>())
            if (activeLayer && actionHistory)
                actionHistory.Perform<LayerAddAction>(activeLayer);
    }
}