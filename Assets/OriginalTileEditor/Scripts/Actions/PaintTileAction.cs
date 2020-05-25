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
    }

    public override void Revert()
    {
        cell.sprite = previousSprite;
    }
}