using Actor.Client;
using Gui.ControlPanel.WinForms.Forms;
using SevenSeals.Tss.Actor;

namespace Gui.ControlPanel.WinForms;

public partial class MainForm : Form
{
    private readonly TabControl _tabControl;
    private readonly MemberClient _memberClient;
    private readonly PassClient _passClient;

    public MainForm(MemberClient memberClient, PassClient passClient)
    {
        InitializeComponent();
        
        _memberClient = memberClient;
        _passClient = passClient;

        Text = "Control Panel";
        WindowState = FormWindowState.Maximized;

        // Initialize tab control
        _tabControl = new TabControl
        {
            Dock = DockStyle.Fill
        };

        Controls.Add(_tabControl);

        InitializeTabs();
    }

    private void InitializeTabs()
    {
        // Add Member tab
        var memberTab = new TabPage("Member Management");
        var memberForm = new MemberClientForm(_memberClient);
        memberTab.Controls.Add(memberForm);
        _tabControl.TabPages.Add(memberTab);

        // Add Pass tab
        var passTab = new TabPage("Pass Management");
        var passForm = new PassClientForm(_passClient);
        passTab.Controls.Add(passForm);
        _tabControl.TabPages.Add(passTab);

        // Add Atlas tab
        var atlasTab = new TabPage("Atlas Management");
        var atlasForm = new AtlasClientForm();
        atlasTab.Controls.Add(atlasForm);
        _tabControl.TabPages.Add(atlasTab);

        // Add Spot tab
        var spotTab = new TabPage("Spot Management");
        var spotForm = new SpotClientForm();
        spotTab.Controls.Add(spotForm);
        _tabControl.TabPages.Add(spotTab);

        // Add TimeZone tab
        var timeZoneTab = new TabPage("TimeZone Management");
        var timeZoneForm = new TimeZoneClientForm();
        timeZoneTab.Controls.Add(timeZoneForm);
        _tabControl.TabPages.Add(timeZoneTab);

        // Add Zone tab
        var zoneTab = new TabPage("Zone Management");
        var zoneForm = new ZoneClientForm();
        zoneTab.Controls.Add(zoneForm);
        _tabControl.TabPages.Add(zoneTab);

        // Add Route tab
        var routeTab = new TabPage("Route Management");
        var routeForm = new RouteClientForm();
        routeTab.Controls.Add(routeForm);
        _tabControl.TabPages.Add(routeTab);

        // Add Transit tab
        var transitTab = new TabPage("Transit Management");
        var transitForm = new TransitClientForm();
        transitTab.Controls.Add(transitForm);
        _tabControl.TabPages.Add(transitTab);
    }
} 