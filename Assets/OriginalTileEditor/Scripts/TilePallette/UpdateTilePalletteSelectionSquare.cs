using System.Linq;
using UnityEngine;

public class UpdateTilePalletteSelectionSquare : ECSSystem
{
    private void Update()
    {
        foreach (var cell in GetEntitiesItem2<MouseExitEvent, TilePalletteCell>())
        foreach (var selectionSquare in GetEntitiesItem1<SelectionSquare, TilePalletteSelection>())
            selectionSquare.image.enabled = false;

        foreach (var cell in GetEntitiesItem2<MouseEnterEvent, TilePalletteCell>())
        foreach (var selectionSquare in GetEntitiesItem1<SelectionSquare, TilePalletteSelection>())
        {
            selectionSquare.image.enabled = true;
            selectionSquare.transform.position = cell.transform.position;
        }
    }
}