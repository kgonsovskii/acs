using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class EventDatabase: Database
{
    public EventDatabase(Settings settings) : base(settings)
    {}

    protected override string Name => "coevtlog.db";

    protected override void Initialize()
    {
        Execute("CREATE TABLE IF NOT EXISTS coevtlog(ch BLOB, t1 BLOB, t2 BLOB, addr BLOB, evt BLOB)");
    }
}
