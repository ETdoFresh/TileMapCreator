using System;

public class UpdateLayerGridSize : ECSSystem
{
    private void Update()
    {
        foreach (var layer in GetEntitiesItem1<Layer>())
        {
            foreach (var gridSizeX in GetEntitiesItem1<GridSizeX>())
            {
                var text = gridSizeX.inputField.text;
                if (int.TryParse(text, out var value))
                    layer.grid.size.x = value;
            }
            
            foreach (var gridSizeY in GetEntitiesItem1<GridSizeY>())
            {
                var text = gridSizeY.inputField.text;
                if (int.TryParse(text, out var value))
                    layer.grid.size.y = value;
            }
        }
    }
}