using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public abstract class ECSSystem : MonoBehaviour
{
    private static List<Behaviour> allExisting = new List<Behaviour>();
    private static List<Behaviour> allEnabled = new List<Behaviour>();

    public static void RegisterEnabled(Behaviour component) => allEnabled.Add(component);
    public static void DeregisterEnabled(Behaviour component) => allEnabled.Remove(component);
    public static void RegisterExisting(Behaviour component) => allExisting.Add(component);
    public static void DeregisterExisting(Behaviour component) => allExisting.Remove(component);

    protected IEnumerable<Tuple<T>> GetEntities<T>(bool includeInactive = false) where T : Behaviour
    {
        var entities = new List<Tuple<T>>();
        var collection = includeInactive ? allExisting : allEnabled;
        entities.AddRange(collection
            .OfType<T>()
            .Select(e => new Tuple<T>(e)));
        return entities;
    }

    protected IEnumerable<Tuple<T0, T1>> GetEntities<T0, T1>(bool includeInactive = false)
        where T0 : Behaviour
        where T1 : Behaviour
    {
        var entities = new List<Tuple<T0, T1>>();
        var collection = includeInactive ? allExisting : allEnabled;
        entities.AddRange(collection
            .OfType<T0>()
            .SelectMany(e0 => collection
                .OfType<T1>()
                .Where(e1 => e0.gameObject == e1.gameObject)
                .Select(e1 => new Tuple<T0, T1>(e0, e1))));
        return entities;
    }

    protected IEnumerable<Tuple<T0, T1, T2>> GetEntities<T0, T1, T2>(bool includeInactive = false)
        where T0 : Behaviour
        where T1 : Behaviour
        where T2 : Behaviour
    {
        var entities = new List<Tuple<T0, T1, T2>>();
        var collection = includeInactive ? allExisting : allEnabled;
        entities.AddRange(collection
            .OfType<T0>()
            .SelectMany(e0 => collection
                .OfType<T1>()
                .Where(e1 => e0.gameObject == e1.gameObject)
                .SelectMany(e1 => collection
                    .OfType<T2>()
                    .Where(e2 => e1.gameObject == e2.gameObject)
                    .Select(e2 => new Tuple<T0, T1, T2>(e0, e1, e2)))));
        return entities;
    }

    protected Tuple<T> GetEntity<T>(bool includeInactive = false) where T : ECSComponent
        => GetEntities<T>(includeInactive).FirstOrDefault();

    protected T GetEntityItem1<T>(bool includeInactive = false) where T : ECSComponent
        => GetEntities<T>(includeInactive).Select(e => e.Item1).FirstOrDefault();

    protected Tuple<T0, T1> GetEntity<T0, T1>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        => GetEntities<T0, T1>(includeInactive).FirstOrDefault();

    protected T0 GetEntityItem1<T0, T1>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        => GetEntities<T0, T1>(includeInactive).Select(e => e.Item1).FirstOrDefault();

    protected T1 GetEntityItem2<T0, T1>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        => GetEntities<T0, T1>(includeInactive).Select(e => e.Item2).FirstOrDefault();

    protected Tuple<T0, T1, T2> GetEntity<T0, T1, T2>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        where T2 : ECSComponent
        => GetEntities<T0, T1, T2>(includeInactive).FirstOrDefault();

    protected T0 GetEntityItem1<T0, T1, T2>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        where T2 : ECSComponent
        => GetEntities<T0, T1, T2>(includeInactive).Select(e => e.Item1).FirstOrDefault();

    protected T1 GetEntityItem2<T0, T1, T2>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        where T2 : ECSComponent
        => GetEntities<T0, T1, T2>(includeInactive).Select(e => e.Item2).FirstOrDefault();

    protected T2 GetEntityItem3<T0, T1, T2>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        where T2 : ECSComponent
        => GetEntities<T0, T1, T2>(includeInactive).Select(e => e.Item3).FirstOrDefault();

    protected IEnumerable<T> GetEntitiesItem1<T>(bool includeInactive = false) where T : ECSComponent
        => GetEntities<T>(includeInactive).Select(e => e.Item1);

    protected IEnumerable<T0> GetEntitiesItem1<T0, T1>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        => GetEntities<T0, T1>(includeInactive).Select(e => e.Item1);

    protected IEnumerable<T1> GetEntitiesItem2<T0, T1>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        => GetEntities<T0, T1>(includeInactive).Select(e => e.Item2);

    protected IEnumerable<T0> GetEntitiesItem1<T0, T1, T2>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        where T2 : ECSComponent
        => GetEntities<T0, T1, T2>(includeInactive).Select(e => e.Item1);

    protected IEnumerable<T1> GetEntitiesItem2<T0, T1, T2>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        where T2 : ECSComponent
        => GetEntities<T0, T1, T2>(includeInactive).Select(e => e.Item2);

    protected IEnumerable<T2> GetEntitiesItem3<T0, T1, T2>(bool includeInactive = false)
        where T0 : ECSComponent
        where T1 : ECSComponent
        where T2 : ECSComponent
        => GetEntities<T0, T1, T2>(includeInactive).Select(e => e.Item3);
}