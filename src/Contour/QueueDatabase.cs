using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class QueueDatabase: Database
{
    public QueueDatabase(Settings settings) : base(settings)
    {}

    protected override string Name => "coevtcue.db";

    protected override void Initialize()
    {
        Execute("CREATE TABLE IF NOT EXISTS coevtcue (ch TEXT, t2 TEXT, evt BLOB)");
    }
}
