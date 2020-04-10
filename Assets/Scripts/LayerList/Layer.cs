// TODO: Add type to Layer
// TODO: Add Layer Options (and show in some context area)
// TODO: Perlin Noise Options (Mask, Seed, Tiles, filterLevels)

public class Layer : ECSComponent
{
    public int depth;
    public GridData grid;
    public LayerType active;
    public PaintLayer paintLayer;
    public RandomNoiseLayer randomNoiseLayer;
    public TileGrid tileGrid;

    protected override void Awake()
    {
        grid = UnityData.Create<GridData>();
        grid.name = $"Grid {name}";
        base.Awake();
    }
}