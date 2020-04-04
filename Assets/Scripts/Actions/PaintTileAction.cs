using UnityEngine;

// TODO: Add glowing/particle effect on tiles
// TODO: Painting lots of tiles at once should count as one action

public class PaintTileAction : Action
{
    public Cell cell;
    public Sprite sprite;
    public Sprite previousSprite;
    
    public override void Perform()
    {
        previousSprite = cell.sprite;
        cell.sprite = sprite;
        UpdateSpriteRenderers();
    }

    public override void Revert()
    {
        cell.sprite = previousSprite;
        UpdateSpriteRenderers();
    }

    private void UpdateSpriteRenderers()
    {
        foreach (var instance in cell.instances)
        {
            var spriteRenderer = instance.GetComponent<SpriteRenderer>();
            if (spriteRenderer) spriteRenderer.sprite = cell.sprite;
        }
    }
}