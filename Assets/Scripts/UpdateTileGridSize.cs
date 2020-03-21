using System;

public class UpdateTileGridSize : ECSSystem
{
    private void Update()
    {
        foreach (var entity1 in GetEntities<TileGrid>())
        {
            var tileGrid = entity1.Item1;
            foreach (var entity2 in GetEntities<GridSizeX>())
            {
                var inputField = entity2.Item1.inputField;
                if (int.TryParse(inputField.text, out var value))
                    tileGrid.size.x = value;
            }
            
            foreach (var entity2 in GetEntities<GridSizeY>())
            {
                var inputField = entity2.Item1.inputField;
                if (int.TryParse(inputField.text, out var value))
                    tileGrid.size.y = value;
            }
        }
    }
}