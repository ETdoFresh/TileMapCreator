﻿using System;
using UnityEngine;

public abstract class ECSComponent : MonoBehaviour
{
    protected virtual void OnEnable()
    {
        ECSSystem.RegisterEnabled(this);
    }
    
    protected virtual void OnDisable()
    {
        ECSSystem.DeregisterEnabled(this);
    }

    protected virtual void Awake()
    {
        ECSSystem.RegisterExisting(this);
    }
    
    protected virtual void OnDestroy()
    {
        ECSSystem.DeregisterExisting(this);
    }
}