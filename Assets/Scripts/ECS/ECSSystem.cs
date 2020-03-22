using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public abstract class ECSSystem : MonoBehaviour
{
    private static List<Component> components = new List<Component>();

    public static void Register(Component component) => components.Add(component);
    public static void Deregister(Component component) => components.Remove(component);

    protected IEnumerable<Tuple<T>> GetEntities<T>() where T : Component
    {
        foreach (var component in components.Where(c => c is T))
            yield return new Tuple<T>((T)component);
    }
}