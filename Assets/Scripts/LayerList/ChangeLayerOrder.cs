public class ChangeLayerOrder : ECSSystem
{
    private void Update()
    {
        var actionHistory = GetEntityItem1<ActionHistory>();
        foreach (var mouseEvent in GetEntitiesItem1<MouseDownEvent, MoveActiveLayerUpButton>())
        {
            var layerList = GetEntityItem1<ActiveLayer>();
            var activeLayer = layerList.active;

            var siblingIndex = activeLayer.transform.GetSiblingIndex();
            if (activeLayer &&  siblingIndex > 0)
                actionHistory.Perform<LayerDepthChangeAction>(activeLayer, siblingIndex - 1);
        }
        
        foreach (var mouseEvent in GetEntitiesItem1<MouseDownEvent, MoveActiveLayerDownButton>())
        {
            var layerList = GetEntityItem1<ActiveLayer>();
            var activeLayer = layerList.active;

            var siblingIndex = activeLayer.transform.GetSiblingIndex();
            if (activeLayer &&  siblingIndex < layerList.transform.childCount)
                actionHistory.Perform<LayerDepthChangeAction>(activeLayer, siblingIndex + 1);
        }
    }
}
