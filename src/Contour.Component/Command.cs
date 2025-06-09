namespace SevenSeals.Tss.Contour;


internal class Command
{
    private readonly Contour _contour;
    private readonly byte _op;
    private readonly byte _osize;
    private readonly byte _isize;
    private readonly byte[] _buf;

    public Command(Contour contour, byte op, byte osize, byte isize)
    {
        _contour = contour;
        _op = op;
        _osize = osize;
        _isize = isize;
        _buf = new byte[Math.Max(osize, isize) + 7];
    }

    public byte this[byte index]
    {
        get => _buf[6 + index];
        set => _buf[6 + index] = value;
    }

    public int Execute(bool checkOp = true)
    {
        // Implement command execution logic
        return 0;
    }
}

