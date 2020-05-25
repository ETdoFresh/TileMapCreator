using System.Collections.Generic;
using UnityEngine;

public class AllSprites : MonoBehaviour
{
    public List<Sprite> sprites = new List<Sprite>();
    private static AllSprites instance;

    public static IEnumerable<Sprite> Sprites => instance.sprites;

    private void OnEnable() => instance = this;

    private void OnDisable() => instance = null;
}
