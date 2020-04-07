using TMPro;
using UnityEngine;

[RequireComponent(typeof(TMP_InputField))]
public class InputFieldValueChangeListener : MonoBehaviour
{
    public TMP_InputField tmpInputField;

    private void OnValidate()
    {
        tmpInputField = GetComponent<TMP_InputField>();
    }

    private void OnEnable()
    {
        tmpInputField.onValueChanged.AddEditorListener(CreateValueChangeEvent);
    }

    private void OnDisable()
    {
        tmpInputField.onValueChanged.RemoveEditorListener(CreateValueChangeEvent);
    }

    private void CreateValueChangeEvent(string value)
    {
        var ev = gameObject.AddComponent<InputFieldValueChangedEvent>();
        ev.value = value;
        EcsEventManager.Add(ev);
    }
}