namespace Gui.WinForms;

partial class MainForm
{
    /// <summary>
    ///  Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    private System.Windows.Forms.TabControl tabControlMain;
    private System.Windows.Forms.TabPage tabPageMain;
    private System.Windows.Forms.TabPage tabPageActorMember;
    private System.Windows.Forms.TabPage tabPageActorPass;
    private System.Windows.Forms.TabPage tabPageAtlas;
    private System.Windows.Forms.TabPage tabPageSpot;
    private System.Windows.Forms.TabPage tabPageRoute;
    private System.Windows.Forms.TabPage tabPageZone;
    private System.Windows.Forms.TabPage tabPageTransit;
    private System.Windows.Forms.TabPage tabPageTimeZone;
    private System.Windows.Forms.TabPage tabPageContour;

    /// <summary>
    ///  Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
        if (disposing && (components != null))
        {
            components.Dispose();
        }

        base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    ///  Required method for Designer support - do not modify
    ///  the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.components = new System.ComponentModel.Container();
        this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
        this.ClientSize = new System.Drawing.Size(800, 450);
        this.Text = "Control Panel";
        this.WindowState = System.Windows.Forms.FormWindowState.Maximized;

        this.tabControlMain = new System.Windows.Forms.TabControl();
        this.tabPageMain = new System.Windows.Forms.TabPage();
        this.tabPageActorMember = new System.Windows.Forms.TabPage();
        this.tabPageActorPass = new System.Windows.Forms.TabPage();
        this.tabPageAtlas = new System.Windows.Forms.TabPage();
        this.tabPageSpot = new System.Windows.Forms.TabPage();
        this.tabPageRoute = new System.Windows.Forms.TabPage();
        this.tabPageZone = new System.Windows.Forms.TabPage();
        this.tabPageTransit = new System.Windows.Forms.TabPage();
        this.tabPageTimeZone = new System.Windows.Forms.TabPage();
        this.tabPageContour = new System.Windows.Forms.TabPage();

        this.tabControlMain.Dock = System.Windows.Forms.DockStyle.Fill;
        this.tabControlMain.TabPages.Add(this.tabPageMain);
        this.tabControlMain.TabPages.Add(this.tabPageActorMember);
        this.tabControlMain.TabPages.Add(this.tabPageActorPass);
        this.tabControlMain.TabPages.Add(this.tabPageAtlas);
        this.tabControlMain.TabPages.Add(this.tabPageSpot);
        this.tabControlMain.TabPages.Add(this.tabPageRoute);
        this.tabControlMain.TabPages.Add(this.tabPageZone);
        this.tabControlMain.TabPages.Add(this.tabPageTransit);
        this.tabControlMain.TabPages.Add(this.tabPageTimeZone);
        this.tabControlMain.TabPages.Add(this.tabPageContour);

        this.tabPageMain.Text = "main";
        this.tabPageActorMember.Text = "actor.member";
        this.tabPageActorPass.Text = "actor.pass";
        this.tabPageAtlas.Text = "atlas.atlas";
        this.tabPageSpot.Text = "contour.spot";
        this.tabPageRoute.Text = "codex.route";
        this.tabPageZone.Text = "atlas.zone";
        this.tabPageTransit.Text = "atlas.transit";
        this.tabPageTimeZone.Text = "codex.timezone";
        this.tabPageContour.Text = "contour.control";

        this.Controls.Add(this.tabControlMain);
        this.ResumeLayout(false);
    }

    #endregion
}
