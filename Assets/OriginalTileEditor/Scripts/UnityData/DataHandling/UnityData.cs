using System;
using UnityEngine;

public abstract class UnityData : MonoBehaviour
{
    private static int id = 0;

    public static UnityData Create(Type type)
    {
        var gameObject = new GameObject(type.Name + id++);
        gameObject.transform.SetParent(Data.singleton.transform);
        var unityData = gameObject.AddComponent(type) as UnityData;
        unityData.Awake();
        return unityData;
    }

    public static T Create<T>() where T : UnityData
    {
        return (T) Create(typeof(T));
    }

    protected virtual void Awake() { }
    protected virtual void OnDestroy() { }

    public void Destroy()
    {
        OnDestroy();
        Destroy(gameObject);
    }
}