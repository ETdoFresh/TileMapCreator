using UnityEngine.UI;

public class SyncLayerNameToGameObjectName : ECSSystem
{
    private void Update()
    {
        foreach (var layer in GetEntitiesItem1<Layer>())
        {
            layer.GetComponentInChildren<Text>().text = layer.name;
        }
    }
}
