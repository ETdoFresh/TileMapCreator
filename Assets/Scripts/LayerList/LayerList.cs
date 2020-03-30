using System.Collections.Generic;
using UnityEngine;

// TODO: Show layer list from top to bottom instead of bottom to topet
// TODO: Export layers to CSV

public class LayerList : ECSComponent
{
    public Color inactiveColor = Color.white;
    public Color activeColor = Color.yellow;
    public Layer active;
    public List<Layer> layers = new List<Layer>();
}