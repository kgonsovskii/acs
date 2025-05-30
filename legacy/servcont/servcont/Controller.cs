using System;

public class Controller
{
    private readonly IChannel channel;
    private readonly byte addr;

    public Controller(IChannel channel, byte addr)
    {
        this.channel = channel;
        this.addr = addr;
    }

    private byte ReadRPD(byte offset)
    {
        byte[] cmd = new byte[] { 0x16, 0x63, addr, offset };
        channel.Write(cmd);
        byte ret;
        int r = channel.Read(out ret);
        CheckInput(r);
        return ret;
    }

    private int GetVarValue(byte[] data, int idx)
    {
        int ret;
        switch (data[0])
        {
            case 2:
                ret = data[idx] | (data[1 + idx] << 8);
                break;
            case 3:
                ret = data[idx] | (data[1 + idx] << 8) | (data[2 + idx] << 16);
                break;
            default:
                throw new UnexpectedResponseException();
        }
        return ret;
    }
}

// Interface for channel communication
public interface IChannel
{
    void Write(byte[] data);
    int Read(out byte data);
}

// Custom exception for unexpected responses
public class UnexpectedResponseException : Exception
{
    public UnexpectedResponseException() : base("Unexpected response received") { }
} 