using System.Collections.Generic;

public class EcsEventManager : ECSSystem
{
    public static Queue<ECSEvent> events = new Queue<ECSEvent>();

    public static void Add(ECSEvent ecsEvent)
    {
        ecsEvent.enabled = false;
        events.Enqueue(ecsEvent);
    }
    
    private void Update()
    {
        while (events.Count > 0)
        {
            var ecsEvent = events.Dequeue();
            ecsEvent.enabled = true;
        }
    }

    private void LateUpdate()
    {
        foreach(var ecsEvent in GetEntities<ECSEvent>())
            if (ecsEvent.Item1.enabled)
                Destroy(ecsEvent.Item1);
    }
}