using UnityEngine.UI;

public class ColorActiveLayerUI : ECSSystem
{
    private void Update()
    {
        foreach(var activeLayer in GetEntitiesItem1<ActiveLayer>())
        foreach (var layer in GetEntitiesItem1<Layer>(true))
        {
            if (layer == activeLayer.active)
                layer.GetComponent<Image>().color = activeLayer.activeColor;
            else
                layer.GetComponent<Image>().color = activeLayer.inactiveColor;
        }
    }
}