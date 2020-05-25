using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;
using Random = UnityEngine.Random;

public class RandomLayer : MonoBehaviour
{
    public GridSettings gridSettings;
    public List<Tile> tiles = new List<Tile>();
    public int seed;
    public Tilemap tilemap;

    private void OnEnable()
    {
        Random.InitState(seed);
        tilemap.ClearAllTiles();
        for (var y = 0; y < gridSettings.size.y; y++)
        for (var x = 0; x < gridSettings.size.x; x++)
        {
            var position = new Vector3Int(x,y,0);
            var randomTile = tiles[Random.Range(0, tiles.Count)];
            tilemap.SetTile(position, randomTile);
        }
    }
}