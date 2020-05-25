using System;
using TMPro;

public class ContextUpdate : ECSSystem
{
    private void Update()
    {
        foreach(var selectionChange in GetEntitiesItem1<SelectionChangeEvent>())
        foreach (var contextSelection in GetEntitiesItem1<ContextSelection>())
        {
            if (!contextSelection.textMesh)
                contextSelection.textMesh = contextSelection.GetComponentInChildren<TextMeshProUGUI>();

            if (!contextSelection.textMesh)
                continue;

            contextSelection.selection = selectionChange.selection;
            
            if (contextSelection.selection)
                contextSelection.textMesh.text = contextSelection.selection.name;
            else
                contextSelection.textMesh.text = "Nothing Selected";
            
            // TODO: Figure out how not check types in Update Loop
            if (contextSelection.selection is Layer layer)
            {
                var dropDownBox = contextSelection.GetComponentInChildren<TMP_Dropdown>();
                if (layer.active is PaintLayer) dropDownBox.value = 0;
                else if (layer.active is RandomNoiseLayer) dropDownBox.value = 1;
                
                if (layer.active is RandomNoiseLayer)
                    GetEntityItem1<SeedTextBox>(true).gameObject.SetActive(true);
                else
                    GetEntityItem1<SeedTextBox>(true).gameObject.SetActive(false);
            }
        }
    }
}
