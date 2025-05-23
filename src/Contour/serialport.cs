namespace SevenSeals.Tss.Contour;

using System;
using System.IO.Ports;

public enum BaudRateEnum
{
    br1200 = 1200,
    br2400 = 2400,
    br4800 = 4800,
    br9600 = 9600,
    br19200 = 19200,
    br38400 = 38400,
    br57600 = 57600,
    br115200 = 115200
}

public enum ControlSignalEnum
{
    DTR,
    RTS
}

public class SerialPortX
{


    private System.IO.Ports.SerialPort _serialPort;

    public SerialPortX(string portName)
    {
        _serialPort = new SerialPort(portName);
    }

    public void Setup(BaudRateEnum baudRate
#if WINDOWS
        , int inputBufferSize, int outputBufferSize
#endif
        )
    {
        _serialPort.BaudRate = (int)baudRate;
        _serialPort.DataBits = 8;
        _serialPort.Parity = Parity.None;
        _serialPort.StopBits = StopBits.One;
        _serialPort.Handshake = Handshake.None;
        _serialPort.ReadTimeout = -1;
        _serialPort.WriteTimeout = -1;

#if WINDOWS
        _serialPort.ReadBufferSize = inputBufferSize;
        _serialPort.WriteBufferSize = outputBufferSize;
#endif

        if (!_serialPort.IsOpen)
            _serialPort.Open();
    }

#if LINUX
    public bool WaitInput(int timeoutMilliseconds)
    {
        // C# equivalent for select() is not direct; can use BaseStream.BeginRead with a timeout
        return _serialPort.BytesToRead > 0;
    }
#endif

#if WINDOWS
    public void ReadTimeout(int timeout)
    {
        _serialPort.ReadTimeout = timeout;
    }
#endif

    public int Read(byte[] buffer, int size)
    {
        return _serialPort.Read(buffer, 0, size);
    }

    public int Write(byte[] buffer, int size)
    {
        _serialPort.Write(buffer, 0, size);
        return size;
    }

    public void ControlSignal(ControlSignalEnum signal, bool isSet)
    {
        switch (signal)
        {
            case ControlSignalEnum.DTR:
                _serialPort.DtrEnable = isSet;
                break;
            case ControlSignalEnum.RTS:
                _serialPort.RtsEnable = isSet;
                break;
        }
    }

    public static uint Value(BaudRateEnum rate)
    {
        return (uint)rate;
    }

    public static BaudRateEnum FromInt(uint speed)
    {
        if (Enum.IsDefined(typeof(BaudRateEnum), (int)speed))
            return (BaudRateEnum)speed;
        throw new ArgumentException("Unsupported baudrate.");
    }

    public void Close()
    {
        if (_serialPort.IsOpen)
            _serialPort.Close();
    }

    public bool IsOpen => _serialPort.IsOpen;

    public string PortName => _serialPort.PortName;
}
