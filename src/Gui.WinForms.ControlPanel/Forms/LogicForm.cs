using SevenSeals.Tss.Logic;
using SevenSeals.Tss.Logic.Api;
using SevenSeals.Tss.Shared;

namespace Gui.WinForms.Forms;

public partial class LogicForm : Form
{
    private readonly ILogicClient _logicClient;
    private readonly PassTouchedClientEvent _request;

    public LogicForm(ILogicClient logicClient)
    {
        _logicClient = logicClient;
        InitializeComponent();

        // Set up Swagger link
        swaggerLinkLabel.Text = "Swagger UI";
        swaggerLinkLabel.Click += (s, e) => System.Diagnostics.Process.Start("explorer.exe", GetSwaggerUrl());

        // Set up PassTouched event handler
        _logicClient.OnPassTouched += LogicClient_PassTouched;

        // Initialize default request
        _request = new DefaultPassTouchedRequest
        {
            AccessGranted = false,
            Reason = "",
            Member = null,
            Pass = null
        };
        propertyGridRequest.SelectedObject = _request;
        propertyGridResponse.SelectedObject = null;

        // Set up Fire Pass Touched button
        firePassTouchedButton.Click += firePassTouchedButton_Click;

        // Set up timer for periodic client event
        timerClientEvent.Tick += TimerClientEvent_Tick;
        timerClientEvent.Start();
        timerClientEvent.Interval = 500;
        timerClientEvent.Enabled = true;

        // Set up fake button
        buttonFakeClientEvent.Click += ButtonFakeClientEvent_Click;
    }

    private string GetSwaggerUrl()
    {
        var baseAddress = _logicClient.Options.BaseUri.TrimEnd('/');
        return $"{baseAddress}/swagger";
    }

    private async void firePassTouchedButton_Click(object sender, EventArgs e)
    {
        if (propertyGridRequest.SelectedObject is not PassTouchedClientEvent req)
        {
            MessageBox.Show("Invalid request object.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
        }
        try
        {
          //  var response = await _logicClient.FirePassTouched(req);
      //      propertyGridResponse.SelectedObject = response;
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    private void LogicClient_PassTouched(object? sender, PassTouchedClientEvent e)
    {
        // Add event info to the eventListBox
        // var info = $"[{DateTime.Now:HH:mm:ss}] Spot: {e.Spot?.Id}, Member: {e.Member?.Id}, Pass: {e.Pass?.Number}, Result: {e.Result}";
        // if (eventListBox.InvokeRequired)
        // {
        //     eventListBox.Invoke(new Action(() => eventListBox.Items.Add(info)));
        // }
        // else
        // {
        //     eventListBox.Items.Add(info);
        // }
    }

    private async void TimerClientEvent_Tick(object? sender, EventArgs e)
    {
        try
        {
            await CallClientEventAndUpdateUI();
        }
        catch (Exception exception)
        {
           labelReason.Text = exception.Message;
        }

    }

    private async void ButtonFakeClientEvent_Click(object? sender, EventArgs e)
    {
        await CallClientEventAndUpdateUI();
    }

    private async Task CallClientEventAndUpdateUI()
    {

        var responses = await _logicClient.OnClientEvent(new ProtoRequest()); // Expecting List<dynamic> or similar
        foreach (var response in responses)
        {
            propertyGridResponse.SelectedObject = response;
            panelAccessResult.BackColor = response.AccessGranted ? Color.Green : Color.Red;
            labelReason.Text = response.Reason;

            await Task.Delay(500_000); // 500 seconds
        }
    }

    // Default implementation for demo/testing
    private class DefaultPassTouchedRequest : PassTouchedClientEvent
    {
        public DefaultPassTouchedRequest()
        {

        }
    }

    private void buttonFakeClientEvent_Click(object sender, EventArgs e)
    {
        throw new System.NotImplementedException();
    }
}
