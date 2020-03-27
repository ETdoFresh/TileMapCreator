using UnityEngine.UI;

public class ColorActiveLayerUI : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<LayerList>())
        {
            var layerList = entity.Item1;
            foreach (var layer in layerList.layers)
            {
                if (layer.isActive)
                    layer.GetComponent<Image>().color = layerList.activeColor;
                else
                    layer.GetComponent<Image>().color = layerList.inactiveColor;
            }
        }
    }
}
