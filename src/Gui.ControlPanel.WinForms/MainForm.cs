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
        var memberTab = new TabPage("Member");
        var memberForm = new MemberClientForm(_memberClient);
        memberTab.Controls.Add(memberForm);
        _tabControl.TabPages.Add(memberTab);

        // Add Pass tab
        var passTab = new TabPage("Pass");
        var passForm = new PassClientForm(_passClient);
        passTab.Controls.Add(passForm);
        _tabControl.TabPages.Add(passTab);
    }
}
