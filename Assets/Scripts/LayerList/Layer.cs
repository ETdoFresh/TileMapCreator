// TODO: Remove Tilegrid place holder on layers > min Layer
// so placeholder doesn't render over tiles
// or put placeholders on inaccesible layer below.

// TODO: Add Layer Option
// TODO: Reorganize Layers
// TODO: Delete Layer

// TODO: Add type to Layer
// TODO: Add Layer Options (and show in some context area)
// TODO: Perlin Noise Options (Mask, Seed, Tiles, filterLevels)

public class Layer : ECSComponent
{
    public bool isActive;
    public int depth;
}