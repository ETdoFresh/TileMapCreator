public class SetActiveLayerOnMouseClick : ECSSystem
{
    private void Update()
    {
        foreach (var layer in GetEntitiesItem1<Layer, MouseDownEvent>())
        {
            var activeLayer = GetEntityItem1<ActiveLayer>();
            activeLayer.active = layer;
        }
    }
}