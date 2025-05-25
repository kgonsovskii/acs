using System.Diagnostics;

namespace SevenSeals.Tss.Contour;

public class SerialChannel : Channel
{
    public readonly string DevStr;
    public readonly uint Speed;
    protected SerialPortX _comm;
    protected string _connInfo;

    public SerialChannel(IChannelEvents events, ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string devStr, uint speed)
        : base(events, responseTimeout, aliveTimeout, deadTimeout)
    {
        DevStr = devStr;
        Speed = speed;
        _connInfo = $"{devStr}@{speed}";
    }

    public override string Id => DevStr;
    public override string ConnInfo()
    {
        throw new NotImplementedException();
    }


    protected override void _init()
    {
        throw new NotImplementedException();
    }

    protected override void _fini()
    {
        throw new NotImplementedException();
    }

    protected override int _read(byte[] buf, int size)
    {
        throw new NotImplementedException();
    }

    protected override void _write(byte[] buf, int size)
    {
        throw new NotImplementedException();
    }


    protected void Init()
    {
      //  _comm = new SerialPortX(DevStr, (int)Speed);

#if WINDOWS
        _comm.ReadBufferSize = 512;
        _comm.WriteBufferSize = 512;
        _comm.ReadTimeout = ResponseTimeout; // Assuming ResponseTimeout is available
#endif

        //_comm.DtrEnable = false;
      //  _comm.RtsEnable = true;
      //  _comm.Open();

        SetReady(true);
    }

    protected void Fini()
    {
        SetReady(false);
        if (_comm != null)
        {
            _comm.Close();
           // _comm.Dispose();
            _comm = null;
        }
    }

    protected int Read(byte[] buffer, int size)
    {
        Debug.Assert(size > 0);

#if LINUX
        // Implement waitInput functionality equivalent if needed
#endif
       // return _comm.Read(buffer, 0, size);

        return 0;
    }

    protected void Write(byte[] buffer, int size)
    {
        Debug.Assert(size > 0);
        CheckReady();


        if (_error)
            FlushInput();

     //   _comm.Write(buffer, 0, size);
    }

    protected bool _error = false;

    protected int ResponseTimeout => 1000; // Example fallback
    protected void SetReady(bool ready) { /* Implementation */ }
    protected void CheckReady() { /* Implementation */ }
    protected void FlushInput() { /* Implementation */ }
}

