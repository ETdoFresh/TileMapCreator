using System.Collections.Generic;

public class ActionHistory : ECSComponent
{
    public int currentStateIndex = 0;
    public List<Action> actions = new List<Action>();

    public void Perform<T>(params object[] args) where T : Action
    {
        var action = UnityData.Create<T>();
        for (var i = 0; i < args.Length; i++)
        {
            var field = typeof(T).GetFields()[i];
            field.SetValue(action, args[i]);
        }
        action.Perform();

        for (var i = actions.Count - 1; i >= currentStateIndex; i--)
        {
            Destroy(actions[i]);
            actions.RemoveAt(i);
        }

        actions.Add(action);
        currentStateIndex++;
    }
}
