using System;
using System.Linq;
using TMPro;

public class SetLayerType : ECSSystem
{
    private void Update()
    {
        var activeLayer = GetEntityItem1<ActiveLayer>();
        foreach (var layer in GetEntitiesItem1<Layer>())
        {
            if (!layer.paintLayer)
            {
                layer.paintLayer = UnityData.Create<PaintLayer>();
                layer.paintLayer.layer = layer;
                layer.paintLayer.grid = layer.grid;
                layer.paintLayer.name = $"PaintLayer {layer.name}";
            }

            if (!layer.randomNoiseLayer)
            {
                layer.randomNoiseLayer = UnityData.Create<RandomNoiseLayer>();
                layer.randomNoiseLayer.layer = layer;
                layer.randomNoiseLayer.grid = layer.grid;
                layer.randomNoiseLayer.name = $"RandomNoiseLayer {layer.name}";
            }

            if (!layer.active)
                layer.active = layer.paintLayer;

            if (activeLayer && activeLayer.active == layer)
            {
                foreach (var dropDownChanged in GetEntitiesItem1<DropDownValueChangedEvent>())
                {
                    var paintLayerSelection = 0;
                    var randomNoiseLayerSelection = 1;

                    if (dropDownChanged.value == paintLayerSelection)
                        layer.active = layer.paintLayer;
                    else if (dropDownChanged.value == randomNoiseLayerSelection)
                    {
                        layer.active = layer.randomNoiseLayer;
                        if (layer.active is RandomNoiseLayer randomNoiseLayer)
                            SwitchToRandomNoiseLayerType(randomNoiseLayer);
                        else
                            SwitchToPaintLayerType();
                    }
                }

                foreach (var seedChange in GetEntitiesItem1<InputFieldValueChangedEvent>())
                {
                    if (layer.active is RandomNoiseLayer randomNoiseLayer)
                    {
                        randomNoiseLayer.seed = seedChange.value == "" ? 0 : Convert.ToInt32(seedChange.value);
                        SwitchToRandomNoiseLayerType(randomNoiseLayer);
                    }
                }

                foreach (var selectionChange in GetEntitiesItem1<SelectionChangeEvent>())
                {
                    if (selectionChange.selection is Layer selectedLayer)
                        if (selectedLayer.active is RandomNoiseLayer randomNoiseLayer)
                        {
                            var seedTextBox = GetEntityItem1<SeedTextBox>(true);
                            seedTextBox.gameObject.SetActive(true);
                            seedTextBox.GetComponentInChildren<TMP_InputField>().text = randomNoiseLayer.seed.ToString();
                        }
                }
            }
        }
    }

    private void SwitchToRandomNoiseLayerType(RandomNoiseLayer layer)
    {
        var seedTextBox = GetEntityItem1<SeedTextBox>(true);
        seedTextBox.gameObject.SetActive(true);
        seedTextBox.GetComponentInChildren<TMP_InputField>().text = layer.seed.ToString();
        var actionHistory = GetEntityItem1<ActionHistory>();
        UnityEngine.Random.InitState(layer.seed);
        var tilePalletteCells = GetEntityItem1<TilePallette>().cells;
        var count = tilePalletteCells.Count;
        foreach (var cell in layer.grid.cells)
        {
            var randomIndex = UnityEngine.Random.Range(0, count);
            actionHistory.Perform<PaintTileAction>(cell, tilePalletteCells[randomIndex].sprite);
        }
    }

    private void SwitchToPaintLayerType()
    {
        GetEntityItem1<SeedTextBox>(true).gameObject.SetActive(false);
    }
}