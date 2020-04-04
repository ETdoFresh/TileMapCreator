using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

// TODO: Consider adding fill function
// TODO: Consider adding selection box/drag to move

public class PaintTileGridWithTileSelection : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<MouseDownEvent, TileGridCell>())
        foreach (var pencil in GetEntitiesItem1<PencilButton>())
            if (pencil.isSelected)
                pencil.isPainting = true;

        foreach (var entity in GetEntities<GlobalMouseLeftUpEvent>())
        foreach (var pencil in GetEntitiesItem1<PencilButton>())
            pencil.isPainting = false;

        foreach (var pencil in GetEntitiesItem1<PencilButton>())
        foreach (var tileGrid in GetEntitiesItem2<MouseDownEvent, TileGridCell>())
            if (pencil.isPainting)
                PaintCell(tileGrid);

        foreach (var pencil in GetEntitiesItem1<PencilButton>())
        foreach (var tileGrid in GetEntitiesItem2<MouseEnterEvent, TileGridCell>())
            if (pencil.isPainting)
                PaintCell(tileGrid);

        foreach (var entity in GetEntities<MouseDownEvent, TileGridCell>())
        foreach (var eraser in GetEntitiesItem1<EraserButton>())
            if (eraser.isSelected)
                eraser.isErasing = true;

        foreach (var entity in GetEntities<GlobalMouseLeftUpEvent>())
        foreach (var eraser in GetEntitiesItem1<EraserButton>())
            eraser.isErasing = false;

        foreach (var eraser in GetEntitiesItem1<EraserButton>())
        foreach (var tileGrid in GetEntitiesItem2<MouseDownEvent, TileGridCell>())
            if (eraser.isErasing)
                PaintCell(tileGrid, true);

        foreach (var eraser in GetEntitiesItem1<EraserButton>())
        foreach (var tileGrid in GetEntitiesItem2<MouseEnterEvent, TileGridCell>())
            if (eraser.isErasing)
                PaintCell(tileGrid, true);
    }

    private void PaintCell(TileGridCell tileGrid, bool isErasing = false)
    {
        var clickedCell = tileGrid.cell;
        var tileSelection = GetEntityItem1<TileSelection>();
        if (tileSelection)
        {
            if (tileSelection.spriteRenderer.sprite.name == "GridSquare")
                return;

            foreach (var layerList in GetEntitiesItem1<ActiveLayer>())
            {
                var activeLayer = layerList.active;
                if (!activeLayer || !activeLayer.enabled) continue;

                var cells = activeLayer.GetComponent<GridData>().cells;
                var cell = cells.FirstOrDefault(c =>
                    c.position == clickedCell.position && c.layer == activeLayer);

                var actionHistory = GetEntityItem1<ActionHistory>();
                if (isErasing)
                    actionHistory.Perform<PaintTileAction>(cell, null);
                else
                    actionHistory.Perform<PaintTileAction>(cell, tileSelection.spriteRenderer.sprite);
            }
        }
    }
}