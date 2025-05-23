namespace SevenSeals.Tss.Contour;

public enum TaskEnum
{
    CleanupClients,
    StopEventCue
}

public class ContourState
{


    public void DoTask(TaskEnum task)
    {
        switch (task)
        {
            case TaskEnum.CleanupClients:
                _cleanupClients = true;
                break;
            case TaskEnum.StopEventCue:
                _stopEventQueue = true;
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(task), task, null);
        }
    }
}
