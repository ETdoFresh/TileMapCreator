using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DebugMouseClickEvent : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<MouseClickEvent>())
        {
            Debug.Log(entity.Item1.mouseWorldPosition);
            Debug.Log(entity.Item1.clickedGameObject.name);
        }
    }
}
