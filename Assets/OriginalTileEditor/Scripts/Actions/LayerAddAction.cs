using System.Collections.Generic;

public class LayerAddAction : Action
{
    public ActiveLayer activeLayer;
    public Layer layer;

    public override void Perform()
    {
        var prefabs = FindObjectOfType<Prefabs>();
        var newGameObject = Instantiate(
            prefabs.Get("Layer"),
            activeLayer.transform);

        layer = newGameObject.GetComponent<Layer>();
        activeLayer.active = layer;

        var layers = FindObjectsOfType<Layer>();
        var count = layers.Length;
        for (int i = 1; i <= count; i++)
        {
            var newName = $"Layer {i}";
            if (NameNotTake(newName, layers))
            {
                layer.name = newName;
                break;
            }
        }
    }

    public override void Revert()
    {
        foreach (var cell in layer.grid.cells)
                cell.Destroy();
        Destroy(layer.gameObject);
    }

    private bool NameNotTake(string newName, IEnumerable<Layer> layers)
    {
        foreach (var layer in layers)
            if (layer.name == newName)
                return false;
        return true;
    }
}