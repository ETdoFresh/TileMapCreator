using TMPro;
using UnityEngine;

[RequireComponent(typeof(TMP_Dropdown))]
public class DropDownValueChangeListener : MonoBehaviour
{
    public TMP_Dropdown tmpDropdown;

    private void OnValidate()
    {
        tmpDropdown = GetComponent<TMP_Dropdown>();
    }

    private void OnEnable()
    {
        tmpDropdown.onValueChanged.AddEditorListener(CreateValueChangeEvent);
    }

    private void OnDisable()
    {
        tmpDropdown.onValueChanged.RemoveEditorListener(CreateValueChangeEvent);
    }

    private void CreateValueChangeEvent(int value)
    {
        var ev = gameObject.AddComponent<DropDownValueChangedEvent>();
        ev.value = value;
        EcsEventManager.Add(ev);
    }
}
