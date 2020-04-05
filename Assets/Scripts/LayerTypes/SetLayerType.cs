public class SetLayerType : ECSSystem
{
    private void Update()
    {
        var activeLayer = GetEntityItem1<ActiveLayer>();
        foreach (var layer in GetEntitiesItem1<Layer>())
        {
            if (!layer.paintLayer)
                layer.paintLayer = UnityData.Create<PaintLayer>();

            if (!layer.randomNoiseLayer)
                layer.randomNoiseLayer = UnityData.Create<RandomNoiseLayer>();

            if (!layer.active)
                layer.active = layer.paintLayer;

            if (activeLayer && activeLayer.active == layer)
                foreach (var selectionChanged in GetEntitiesItem1<DropDownValueChangedEvent>())
                {
                    var paintLayerSelection = 0;
                    var randomNoiseLayerSelection = 1;

                    if (selectionChanged.value == paintLayerSelection)
                        layer.active = layer.paintLayer;
                    else if (selectionChanged.value == randomNoiseLayerSelection)
                    {
                        layer.active = layer.randomNoiseLayer;
                        if (layer.active is RandomNoiseLayer)
                            GetEntityItem1<SeedTextBox>(true).gameObject.SetActive(true);
                        else
                            GetEntityItem1<SeedTextBox>(true).gameObject.SetActive(false);
                    }
                }
        }
    }
}