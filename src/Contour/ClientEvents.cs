namespace SevenSeals.Tss.Contour;

public class ClientEvents :  IDisposable
{
    public void Dispose()
    {
        // Trace or clean-up if needed
        // Console.WriteLine("~ClientEvents()");
    }

    public void OnConnect(object client)
    {
        // Connection handling logic
    }

    public void OnDisconnect(object client)
    {
        // Disconnection logic
    }

    public bool OnProc(object client, object proc, ref object parameters)
    {
        // Procedure handling logic
        return false;
    }

    public void OnExec(object client, bool flag, object parameters, string command)
    {
        // Execution logic
    }
}
