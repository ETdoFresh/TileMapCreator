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
                .Where(e1 => e0.gameObject == e1.gameObject)
                .Select(e1 => new Tuple<T0, T1>(e0, e1))));
        return entities;
    }
    
    protected IEnumerable<Tuple<T0, T1, T2>> GetEntities<T0, T1, T2>()
        where T0 : Behaviour
        where T1 : Behaviour
        where T2 : Behaviour
    {
        var entities = new List<Tuple<T0, T1, T2>>();
        entities.AddRange(components
            .OfType<T0>()
            .Where(e0 => e0.enabled)
            .SelectMany(e0 => components
                .OfType<T1>()
                .Where(e1 => e1.enabled)
                .Where(e1 => e0.gameObject == e1.gameObject)
                .SelectMany(e1 => components
                    .OfType<T2>()
                    .Where(e2 => e2.enabled)
                    .Where(e2 => e1.gameObject == e2.gameObject)
                    .Select(e2 => new Tuple<T0, T1, T2>(e0, e1, e2)))));
        return entities;
    }
}