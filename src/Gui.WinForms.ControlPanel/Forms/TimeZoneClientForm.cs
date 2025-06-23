using SevenSeals.Tss.Codex;

namespace Gui.WinForms.Forms;

public partial class TimeZoneClientForm : StorageForm<TimeZoneRule, Guid, ITimeZoneClient>
{
    public TimeZoneClientForm(ITimeZoneClient client, string? title = null) : base(client, title ?? "TimeZone Management") { }

    public TimeZoneClientForm() {
        InitializeComponent();
    }
} 