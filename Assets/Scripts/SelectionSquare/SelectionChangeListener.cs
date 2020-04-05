using UnityEngine;

public class SelectionChangeListener : MonoBehaviour
{
    private static SelectionChangeListener singleton;

    private void OnEnable()
    {
        if (singleton == null)
            singleton = this;
        else
            Destroy(this);
    }

    private void OnDisable()
    {
        singleton = null;
    }

    public static void CreateEvent(ECSComponent newSelection)
    {
        var ev = singleton.gameObject.AddComponent<SelectionChangeEvent>();
        ev.selection = newSelection;
        EcsEventManager.Add(ev);
    }
}
