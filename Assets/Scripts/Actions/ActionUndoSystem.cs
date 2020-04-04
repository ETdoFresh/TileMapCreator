using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActionUndoSystem : ECSSystem
{
    private void Update()
    {
        foreach (var undo in GetEntities<UndoButton, MouseDownEvent>())
        {
            var actionHistory = GetEntityItem1<ActionHistory>();
            if (actionHistory.currentStateIndex > 0)
            {
                actionHistory.currentStateIndex--;
                actionHistory.actions[actionHistory.currentStateIndex].Revert();
            }
        }
    }
}