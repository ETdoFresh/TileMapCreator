using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Prefabs : ECSComponent
{
    public List<GameObject> list = new List<GameObject>();

    public GameObject Get(string name)
    {
        return list.FirstOrDefault(i => i.name == name);
    }
}
