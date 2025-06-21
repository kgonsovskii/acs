using System.ComponentModel;
using SevenSeals.Tss.Shared;
using Shared.Proto;

namespace Gui.ControlPanel.WinForms.Forms;

public class BaseClientForm<TClient> : Form where TClient : IProtoClient
{
    protected readonly TClient Client;
    protected readonly PropertyGrid PropertyGrid;
    protected readonly Panel ButtonsPanel;
    protected readonly Panel ContentPanel;

    public BaseClientForm(TClient client)
    {
        Client = client;
        
        // Initialize layout
        Dock = DockStyle.Fill;
        
        // Create main layout
        ContentPanel = new Panel
        {
            Dock = DockStyle.Fill,
            AutoScroll = true
        };

        ButtonsPanel = new Panel
        {
            Dock = DockStyle.Left,
            Width = 200,
            AutoScroll = true
        };

        PropertyGrid = new PropertyGrid
        {
            Dock = DockStyle.Right,
            Width = 300,
            ToolbarVisible = true,
            CommandsVisibleIfAvailable = true
        };

        var splitter1 = new Splitter
        {
            Dock = DockStyle.Right,
            Width = 5
        };

        var splitter2 = new Splitter
        {
            Dock = DockStyle.Left,
            Width = 5
        };

        Controls.AddRange(new Control[] { ContentPanel, splitter1, PropertyGrid, splitter2, ButtonsPanel });
    }

    protected async Task ExecuteClientMethod<TRequest>(string buttonText, TRequest request, Func<TRequest, Task> method)
        where TRequest : class, new()
    {
        try
        {
            var button = new Button
            {
                Text = buttonText,
                Dock = DockStyle.Top,
                Height = 30
            };

            button.Click += async (s, e) =>
            {
                PropertyGrid.SelectedObject = request;
                if (MessageBox.Show("Execute this request?", "Confirm", MessageBoxButtons.YesNo) == DialogResult.Yes)
                {
                    button.Enabled = false;
                    try
                    {
                        await method(request);
                        MessageBox.Show("Operation completed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                    finally
                    {
                        button.Enabled = true;
                    }
                }
            };

            ButtonsPanel.Controls.Add(button);
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Error setting up method: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
} 