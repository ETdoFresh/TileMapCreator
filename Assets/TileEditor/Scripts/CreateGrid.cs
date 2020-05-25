using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

namespace TileEditor
{
    class CreateGrid : MonoBehaviour
    {
        public Tilemap tilemap;
        public Tile gridBackgroundTile;
        public GridSettings gridSettings;

        private void OnEnable()
        {
            var size = gridSettings.size;
            tilemap.ClearAllTiles();
            for (var y = 0; y < size.y; y++)
            for (var x = 0; x < size.x; x++)
                tilemap.SetTile(new Vector3Int(x, y, 0), gridBackgroundTile);
        }
    }
}