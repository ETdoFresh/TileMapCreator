using System;
using UnityEngine;

public abstract class ECSComponent : MonoBehaviour
{
    protected  virtual void OnEnable()
    {
        ECSSystem.Register(this);
    }
    
    protected  virtual void OnDisable()
    {
        ECSSystem.Deregister(this);
    }
}