public class SetActiveLayerOnMouseClick : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<Layer, MouseDownEvent>())
        {
            var layer = entity.Item1;

            var layerList = GetEntityItem1<LayerList>();
            if (layerList)
            {
                if (layerList.active) 
                    layerList.active.isActive = false;
                
                layerList.active = layer;
                layerList.active.isActive = true;
            }
        }
    }
}