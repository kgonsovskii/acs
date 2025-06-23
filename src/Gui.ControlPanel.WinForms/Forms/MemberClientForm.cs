using Actor.Client;
using Actor.Model;
using SevenSeals.Tss.Actor;
using System.ComponentModel;

namespace Gui.ControlPanel.WinForms.Forms;

public partial class MemberClientForm : Form
{
    private readonly MemberClient _client;
    private readonly PropertyGrid _propertyGrid;
    private readonly TableLayoutPanel _mainLayout;
    private readonly FlowLayoutPanel _buttonsPanel;
    private readonly Panel _contentPanel;

    private readonly Button btnGetAllMembers;
    private readonly Button btnGetMemberById;
    private readonly Button btnCreateMember;
    private readonly Button btnUpdateMember;
    private readonly Button btnDeleteMember;

    public MemberClientForm(MemberClient client)
    {
        _client = client;
        Dock = DockStyle.Fill;
        Text = "Member Management";

        _mainLayout = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 3,
            RowCount = 1
        };
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 200));
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 300));

        _buttonsPanel = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            FlowDirection = FlowDirection.TopDown,
            AutoScroll = true,
            WrapContents = false
        };
        _contentPanel = new Panel
        {
            Dock = DockStyle.Fill,
            AutoScroll = true
        };
        _propertyGrid = new PropertyGrid
        {
            Dock = DockStyle.Fill,
            ToolbarVisible = true,
            CommandsVisibleIfAvailable = true
        };

        // Explicit buttons
        btnGetAllMembers = new Button { Text = "Get All Members", Width = 180, Height = 30, Margin = new Padding(5) };
        btnGetMemberById = new Button { Text = "Get Member by ID", Width = 180, Height = 30, Margin = new Padding(5) };
        btnCreateMember = new Button { Text = "Create Member", Width = 180, Height = 30, Margin = new Padding(5) };
        btnUpdateMember = new Button { Text = "Update Member", Width = 180, Height = 30, Margin = new Padding(5) };
        btnDeleteMember = new Button { Text = "Delete Member", Width = 180, Height = 30, Margin = new Padding(5) };

        btnGetAllMembers.Click += btnGetAllMembers_Click;
        btnGetMemberById.Click += btnGetMemberById_Click;
        btnCreateMember.Click += btnCreateMember_Click;
        btnUpdateMember.Click += btnUpdateMember_Click;
        btnDeleteMember.Click += btnDeleteMember_Click;

        _buttonsPanel.Controls.Add(btnGetAllMembers);
        _buttonsPanel.Controls.Add(btnGetMemberById);
        _buttonsPanel.Controls.Add(btnCreateMember);
        _buttonsPanel.Controls.Add(btnUpdateMember);
        _buttonsPanel.Controls.Add(btnDeleteMember);

        _mainLayout.Controls.Add(_buttonsPanel, 0, 0);
        _mainLayout.Controls.Add(_contentPanel, 1, 0);
        _mainLayout.Controls.Add(_propertyGrid, 2, 0);
        Controls.Add(_mainLayout);
    }

    private async void btnGetAllMembers_Click(object? sender, EventArgs e)
    {
        try
        {
            btnGetAllMembers.Enabled = false;
            var members = await _client.GetAll();
            DisplayMembers(members);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnGetAllMembers.Enabled = true;
        }
    }

    private async void btnGetMemberById_Click(object? sender, EventArgs e)
    {
        var request = new { Id = Guid.Empty };
        _propertyGrid.SelectedObject = request;
        if (MessageBox.Show("Get this member?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            btnGetMemberById.Enabled = false;
            var member = await _client.GetById(request.Id);
            if (member != null)
                DisplayMembers(new[] { member });
            else
                MessageBox.Show("Member not found", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnGetMemberById.Enabled = true;
        }
    }

    private async void btnCreateMember_Click(object? sender, EventArgs e)
    {
        var member = new Member();
        _propertyGrid.SelectedObject = member;
        if (MessageBox.Show("Create this member?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            btnCreateMember.Enabled = false;
            await _client.Create(member);
            MessageBox.Show("Member created successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            btnGetAllMembers_Click(null, EventArgs.Empty);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnCreateMember.Enabled = true;
        }
    }

    private async void btnUpdateMember_Click(object? sender, EventArgs e)
    {
        var request = new { Id = Guid.Empty, Member = new Member() };
        _propertyGrid.SelectedObject = request;
        if (MessageBox.Show("Update this member?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            btnUpdateMember.Enabled = false;
            await _client.Update(request.Id, request.Member);
            MessageBox.Show("Member updated successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            btnGetAllMembers_Click(null, EventArgs.Empty);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnUpdateMember.Enabled = true;
        }
    }

    private async void btnDeleteMember_Click(object? sender, EventArgs e)
    {
        var request = new { Id = Guid.Empty };
        _propertyGrid.SelectedObject = request;
        if (MessageBox.Show("Delete this member?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            btnDeleteMember.Enabled = false;
            await _client.Delete(request.Id);
            MessageBox.Show("Member deleted successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            btnGetAllMembers_Click(null, EventArgs.Empty);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnDeleteMember.Enabled = true;
        }
    }

    private void DisplayMembers(IEnumerable<Member> members)
    {
        var grid = new DataGridView
        {
            Dock = DockStyle.Fill,
            AutoGenerateColumns = true,
            AllowUserToAddRows = false,
            AllowUserToDeleteRows = false,
            ReadOnly = true,
            SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            MultiSelect = false
        };
        grid.DataSource = members.ToList();
        _contentPanel.Controls.Clear();
        _contentPanel.Controls.Add(grid);
        grid.CellClick += (s, e) =>
        {
            if (e.RowIndex >= 0)
            {
                var member = members.ElementAt(e.RowIndex);
                _propertyGrid.SelectedObject = member;
            }
        };
    }
} 
} 