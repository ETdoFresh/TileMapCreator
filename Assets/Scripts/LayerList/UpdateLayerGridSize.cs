using System;

public class UpdateLayerGridSize : ECSSystem
{
    private void Update()
    {
        foreach (var entity1 in GetEntities<Layer, GridData>())
        {
            var layerGrid = entity1.Item2;
            foreach (var entity2 in GetEntities<GridSizeX>())
            {
                var inputField = entity2.Item1.inputField;
                if (int.TryParse(inputField.text, out var value))
                    layerGrid.size.x = value;
            }
            
            foreach (var entity2 in GetEntities<GridSizeY>())
            {
                var inputField = entity2.Item1.inputField;
                if (int.TryParse(inputField.text, out var value))
                    layerGrid.size.y = value;
            }
        }
    }
}