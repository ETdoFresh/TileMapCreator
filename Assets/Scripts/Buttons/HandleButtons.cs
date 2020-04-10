﻿using System;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class HandleButtons : ECSSystem
{
    private void Update()
    {
        HandleNewDocumentButton();
        HandleOpenDocumentButton();
        HandleSaveDocumentButton();
        HandlePaintSelection();
    }

    private void HandleNewDocumentButton()
    {
        foreach (var mouseDownEvent in GetEntities<MouseDownEvent, NewDocumentButton>())
        {
            foreach (var layer in GetEntitiesItem1<Layer>())
            foreach (var cell in layer.grid.cells)
            {
                cell.sprite = null;
            }
        }
    }

    private void HandleOpenDocumentButton()
    {
        foreach (var mouseDownEvent in GetEntities<MouseDownEvent, OpenDocumentButton>())
        {
            var input =
                "SaveData,Layer1,3,3,0,0,,1,0,,2,0,,0,1,0,1,1,0,2,1,0,0,2,,1,2,,2,2,,Layer2,3,3,0,0,,1,0,,2,0,,0,1,,1,1,,2,1,,0,2,,1,2,,2,2,";
            var inputs = input.Split(',');
            foreach (var layer in GetEntitiesItem1<Layer>())
            {
                var grid = layer.grid;
                for (var i = 0; i < inputs.Length; i++)
                {
                    if (inputs[i] != grid.name) continue;

                    grid.size.x = Convert.ToInt32(inputs[i + 1]);
                    grid.size.y = Convert.ToInt32(inputs[i + 2]);

                    GetEntityItem1<GridSizeX>().GetComponent<InputField>().text = grid.size.x.ToString();
                    GetEntityItem1<GridSizeY>().GetComponent<InputField>().text = grid.size.x.ToString();

                    for (var j = i + 3; j < grid.size.x * grid.size.y * 3 + i + 3; j += 3)
                        foreach (var cell in grid.cells)
                        {
                            var x = Convert.ToInt32(inputs[j + 0]);
                            var y = Convert.ToInt32(inputs[j + 1]);
                            var spriteIndex = inputs[j + 2] == "" ? -1 : Convert.ToInt32(inputs[j + 2]);
                            if (cell.position.x == x && cell.position.y == y)
                                cell.sprite = spriteIndex == -1 ? null : AllSprites.Sprites.ElementAt(spriteIndex);
                        }
                }
            }
        }
    }

    private void HandleSaveDocumentButton()
    {
        foreach (var mouseDownEvent in GetEntities<MouseDownEvent, SaveDocumentButton>())
        {
            var output = "SaveData";
            foreach (var layer in GetEntitiesItem1<Layer>())
            {
                var grid = layer.grid;
                output += $",{grid.name}";
                output += $",{grid.size.x}";
                output += $",{grid.size.y}";
                foreach (var cell in grid.cells)
                {
                    output += $",{cell.position.x}";
                    output += $",{cell.position.y}";
                    output += cell.sprite
                        ? $",{AllSprites.Sprites.TakeWhile(x => x.name != cell.sprite.name).Count()}"
                        : ",";
                }
            }

            Debug.Log(output);
        }
    }

    private void HandlePaintSelection()
    {
        foreach (var pencil in GetEntitiesItem1<PencilButton>())
            pencil.isSelected = pencil.GetComponent<Toggle>().isOn;

        foreach (var eraserButton in GetEntitiesItem1<EraserButton>())
            eraserButton.isSelected = eraserButton.GetComponent<Toggle>().isOn;
    }
}