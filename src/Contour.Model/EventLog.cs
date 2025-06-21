using Infra.Db;
using Infra.Db.Attributes;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

[DbTable]
public class EventLog: IItem<int>
{
    public byte[] Ch { get; set; }
    public byte[] ControllerTimestamp { get; set; }
    public byte[] Timestamp { get; set; }
    public byte Addr { get; set; }
    public byte[] Data { get; set; }

    public EventLog(byte[] ch, byte[] data, byte[] timestamp)
    {
        Ch = ch;
        Data = data;
        Timestamp = timestamp;
        Addr = 0;
        ControllerTimestamp = new byte[6];
    }

    [DbPrimaryKey]
    public int Id { get; set; }
}
