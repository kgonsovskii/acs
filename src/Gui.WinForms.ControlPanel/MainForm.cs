using Gui.WinForms.Forms;
using SevenSeals.Tss.Actor;
using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Codex;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Logic;

namespace Gui.WinForms;

public partial class MainForm : Form
{
    private readonly IMemberClient _memberClient;
    private readonly IPassClient _passClient;
    private readonly IAtlasClient _atlasClient;
    private readonly IZoneClient _zoneClient;
    private readonly ITransitClient _transitClient;
    private readonly ISpotClient _spotClient;
    private readonly IRouteClient _routeClient;
    private readonly ITimeZoneClient _timeZoneClient;
    private readonly IContourClient _contourClient;
    private readonly ILogicClient _logicClient;

    public MainForm(
        IMemberClient memberClient,
        IPassClient passClient,
        IAtlasClient atlasClient,
        IZoneClient zoneClient,
        ITransitClient transitClient,
        ISpotClient spotClient,
        IRouteClient routeClient,
        ITimeZoneClient timeZoneClient,
        IContourClient contourClient,
        ILogicClient logicClient)
    {
        InitializeComponent();
        _memberClient = memberClient;
        _passClient = passClient;
        _atlasClient = atlasClient;
        _zoneClient = zoneClient;
        _transitClient = transitClient;
        _spotClient = spotClient;
        _routeClient = routeClient;
        _timeZoneClient = timeZoneClient;
        _contourClient = contourClient;
        _logicClient = logicClient;
        AddFormsToTabs();
    }

    private void AddFormsToTabs()
    {
        // Actor.member tab
        var memberForm = new MemberClientForm(_memberClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageActorMember.Controls.Add(memberForm);
        memberForm.Show();

        // Actor.pass tab
        var passForm = new PassClientForm(_passClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageActorPass.Controls.Add(passForm);
        passForm.Show();

        // Atlas tab
        var atlasForm = new AtlasClientForm(_atlasClient, _zoneClient, _transitClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageAtlas.Controls.Add(atlasForm);
        atlasForm.Show();

        // Spot tab
        var spotForm = new SpotClientForm(_spotClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageSpot.Controls.Add(spotForm);
        spotForm.Show();

        // Route tab
        var routeForm = new RouteClientForm(_routeClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageRoute.Controls.Add(routeForm);
        routeForm.Show();

        // Zone tab
        var zoneForm = new ZoneClientForm(_zoneClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageZone.Controls.Add(zoneForm);
        zoneForm.Show();

        // Transit tab
        var transitForm = new TransitClientForm(_transitClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageTransit.Controls.Add(transitForm);
        transitForm.Show();

        // TimeZone tab
        var timeZoneForm = new TimeZoneClientForm(_timeZoneClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageTimeZone.Controls.Add(timeZoneForm);
        timeZoneForm.Show();

        // Contour control tab
        var contourForm = new ContourForm(_contourClient, _spotClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageContour.Controls.Add(contourForm);
        contourForm.Show();

        // Logic tab (main)
        var logicForm = new Gui.WinForms.Forms.LogicForm(_logicClient)
        {
            TopLevel = false,
            FormBorderStyle = FormBorderStyle.None,
            Dock = DockStyle.Fill
        };
        tabPageMain.Controls.Add(logicForm);
        logicForm.Show();
    }
}
