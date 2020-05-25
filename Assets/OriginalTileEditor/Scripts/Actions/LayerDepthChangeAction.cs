public class LayerDepthChangeAction : Action
{
    public Layer layer;
    public int newSiblingIndex;
    
    public int oldSiblingIndex;
    
    public override void Perform()
    {
        oldSiblingIndex = layer.transform.GetSiblingIndex();
        layer.transform.SetSiblingIndex(newSiblingIndex);
    }

    public override void Revert()
    {
        layer.transform.SetSiblingIndex(oldSiblingIndex);
    }
}