using System;
using System.Windows.Forms;
using SevenSeals.Tss.Logic;
using SevenSeals.Tss.Logic.Api;
using SevenSeals.Tss.Contour;

namespace Gui.WinForms.Forms;

public partial class LogicForm : Form
{
    private readonly ILogicClient _logicClient;
    private PassTouchedRequest _request;

    public LogicForm(ILogicClient logicClient)
    {
        _logicClient = logicClient;
        InitializeComponent();

        // Set up Swagger link
        swaggerLinkLabel.Text = "Swagger UI";
        swaggerLinkLabel.Click += (s, e) => System.Diagnostics.Process.Start("explorer.exe", GetSwaggerUrl());

        // Set up PassTouched event handler
        _logicClient.PassTouched += LogicClient_PassTouched;

        // Initialize default request
        _request = new DefaultPassTouchedRequest();
        propertyGridRequest.SelectedObject = _request;
        propertyGridResponse.SelectedObject = null;

        // Set up Fire Pass Touched button
        firePassTouchedButton.Click += firePassTouchedButton_Click;
    }

    private string GetSwaggerUrl()
    {
        var baseAddress = _logicClient.Options.BaseUri.TrimEnd('/');
        return $"{baseAddress}/swagger";
    }

    private async void firePassTouchedButton_Click(object sender, EventArgs e)
    {
        if (propertyGridRequest.SelectedObject is not PassTouchedRequest req)
        {
            MessageBox.Show("Invalid request object.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
        }
        try
        {
            var response = await _logicClient.FirePassTouched(req);
            propertyGridResponse.SelectedObject = response;
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    private void LogicClient_PassTouched(object? sender, PassTouchedResponse e)
    {
        // Add event info to the eventListBox
        var info = $"[{DateTime.Now:HH:mm:ss}] Spot: {e.Spot?.Id}, Member: {e.Member?.Id}, Pass: {e.Pass?.Number}, Result: {e.Result}";
        if (eventListBox.InvokeRequired)
        {
            eventListBox.Invoke(new Action(() => eventListBox.Items.Add(info)));
        }
        else
        {
            eventListBox.Items.Add(info);
        }
    }

    // Default implementation for demo/testing
    private class DefaultPassTouchedRequest : PassTouchedRequest
    {
        public DefaultPassTouchedRequest()
        {
            SpotId = Guid.Empty;
            KeyNumber = "123456";
        }
    }
}
