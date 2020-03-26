using System.Collections.Generic;
    
// TODO: OnClick layer, set active layer
// TODO: Export layers to CSV

public class LayerList : ECSComponent
{
    public Layer active;
    public List<Layer> layers = new List<Layer>();
}