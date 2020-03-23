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
            yield return new Tuple<T>((T) component);
    }

    protected IEnumerable<Tuple<T0, T1>> GetEntities<T0, T1>() where T0 : Component where T1 : Component
    {
        foreach (var component1 in components.Where(c => c is T0))
        foreach (var component2 in components.Where(c => c is T1))
            yield return new Tuple<T0, T1>((T0) component1, (T1) component2);
    }
}