using System.Reflection;

namespace Gui.WinForms;

public class RequestPropertyDialog : Form
{
    private readonly PropertyGrid _propertyGrid;
    private readonly Button _executeButton;
    private readonly Button _cancelButton;

    public object RequestObject { get; private set; }

    public RequestPropertyDialog(object request, string title = "Edit Request")
    {
        RequestObject = request;
        Text = title;
        FormBorderStyle = FormBorderStyle.FixedDialog;
        StartPosition = FormStartPosition.CenterParent;
        MinimizeBox = false;
        MaximizeBox = false;
        ShowInTaskbar = false;
        Width = 400;
        Height = 500;

        _propertyGrid = new PropertyGrid
        {
            Dock = DockStyle.Top,
            Height = 400,
            SelectedObject = request
        };
        _propertyGrid.PropertyValueChanged += (s, e) =>
        {
            // Revert the value to the original (read-only effect)
            _propertyGrid.SelectedObject = _propertyGrid.SelectedObject;
        };

        _executeButton = new Button
        {
            Text = "Execute",
            DialogResult = DialogResult.OK,
            Anchor = AnchorStyles.Bottom | AnchorStyles.Right,
            Left = 200,
            Top = 410,
            Width = 80
        };
        _executeButton.Click += (s, e) => { DialogResult = DialogResult.OK; Close(); };

        _cancelButton = new Button
        {
            Text = "Cancel",
            DialogResult = DialogResult.Cancel,
            Anchor = AnchorStyles.Bottom | AnchorStyles.Right,
            Left = 290,
            Top = 410,
            Width = 80
        };
        _cancelButton.Click += (s, e) => { DialogResult = DialogResult.Cancel; Close(); };

        Controls.Add(_propertyGrid);
        Controls.Add(_executeButton);
        Controls.Add(_cancelButton);

        ExpandAllGridItems();
    }

    private void ExpandAllGridItems()
    {
        var gridViewField = typeof(PropertyGrid).GetField("gridView", BindingFlags.NonPublic | BindingFlags.Instance);
        var gridView = gridViewField?.GetValue(_propertyGrid);
        if (gridView != null)
        {
            var expandMethod = gridView.GetType().GetMethod("ExpandAllGridItems", BindingFlags.NonPublic | BindingFlags.Instance);
            expandMethod?.Invoke(gridView, null);
        }
    }
}
