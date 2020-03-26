using System;
using UnityEngine;

public abstract class UnityData : MonoBehaviour
{
    private static int id = 0;
    
    public static UnityData Create(Type type)
    {
        var gameObject = new GameObject(type.Name + id++);
        gameObject.transform.SetParent(Data.singleton.transform);
        return gameObject.AddComponent(type) as UnityData;
    }
    
    public static T Create<T>() where T : UnityData
    {
        return (T) Create(typeof(T));
    }
}