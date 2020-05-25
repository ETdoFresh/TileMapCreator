public class ActionRedoSystem : ECSSystem
{
    private void Update()
    {
        foreach (var undo in GetEntities<RedoButton, MouseDownEvent>())
        {
            var actionHistory = GetEntityItem1<ActionHistory>();
            if (actionHistory.currentStateIndex < actionHistory.actions.Count)
            {
                actionHistory.actions[actionHistory.currentStateIndex].Perform();
                actionHistory.currentStateIndex++;
            }
        }
    }
}