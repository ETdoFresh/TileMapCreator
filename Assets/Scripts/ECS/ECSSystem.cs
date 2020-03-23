using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public abstract class ECSSystem : MonoBehaviour
{
    private static List<Behaviour> components = new List<Behaviour>();

    public static void Register(Behaviour component) => components.Add(component);
    public static void Deregister(Behaviour component) => components.Remove(component);

    protected IEnumerable<Tuple<T>> GetEntities<T>() where T : Behaviour
    {
        var entities = new List<Tuple<T>>();
        entities.AddRange(components
            .OfType<T>()
            .Where(e => e.enabled)
            .Select(e => new Tuple<T>(e)));
        return entities;
    }

    protected IEnumerable<Tuple<T0, T1>> GetEntities<T0, T1>()
        where T0 : Behaviour
        where T1 : Behaviour
    {
        var entities = new List<Tuple<T0, T1>>();
        entities.AddRange(components
            .OfType<T0>()
            .Where(e0 => e0.enabled)
            .SelectMany(e0 => components
                .OfType<T1>()
                .Where(e1 => e1.enabled)
                .Select(e1 => new Tuple<T0, T1>(e0, e1))));
        return entities;
    }
}