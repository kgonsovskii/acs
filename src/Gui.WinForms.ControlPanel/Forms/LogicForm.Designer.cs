namespace Gui.WinForms.Forms
{
    partial class LogicForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
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
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            components = new System.ComponentModel.Container();
            topPanel = new System.Windows.Forms.Panel();
            swaggerLinkLabel = new System.Windows.Forms.LinkLabel();
            mainPanel = new System.Windows.Forms.Panel();
            firePassTouchedButton = new System.Windows.Forms.Button();
            propertyGridRequest = new System.Windows.Forms.PropertyGrid();
            propertyGridResponse = new System.Windows.Forms.PropertyGrid();
            propertyGridSplitter = new System.Windows.Forms.Splitter();
            eventListBox = new System.Windows.Forms.ListBox();
            timerClientEvent = new System.Windows.Forms.Timer(components);
            panelAccessResult = new System.Windows.Forms.Panel();
            labelReason = new System.Windows.Forms.Label();
            buttonFakeClientEvent = new System.Windows.Forms.Button();
            panelStatusRow = new System.Windows.Forms.Panel();
            panelPropertyGrids = new System.Windows.Forms.Panel();
            panelEventMessage = new System.Windows.Forms.Panel();
            topPanel.SuspendLayout();
            mainPanel.SuspendLayout();
            panelPropertyGrids.SuspendLayout();
            panelEventMessage.SuspendLayout();
            SuspendLayout();
            // 
            // topPanel
            // 
            topPanel.Controls.Add(swaggerLinkLabel);
            topPanel.Dock = System.Windows.Forms.DockStyle.Top;
            topPanel.Location = new System.Drawing.Point(0, 350);
            topPanel.Name = "topPanel";
            topPanel.Size = new System.Drawing.Size(800, 40);
            topPanel.TabIndex = 5;
            // 
            // swaggerLinkLabel
            // 
            swaggerLinkLabel.AutoSize = true;
            swaggerLinkLabel.Location = new System.Drawing.Point(12, 12);
            swaggerLinkLabel.Name = "swaggerLinkLabel";
            swaggerLinkLabel.Size = new System.Drawing.Size(52, 15);
            swaggerLinkLabel.TabIndex = 0;
            swaggerLinkLabel.TabStop = true;
            swaggerLinkLabel.Text = "Swagger";
            // 
            // mainPanel
            // 
            mainPanel.Controls.Add(firePassTouchedButton);
            mainPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            mainPanel.Location = new System.Drawing.Point(0, 0);
            mainPanel.Name = "mainPanel";
            mainPanel.Padding = new System.Windows.Forms.Padding(8);
            mainPanel.Size = new System.Drawing.Size(800, 356);
            mainPanel.TabIndex = 0;
            // 
            // firePassTouchedButton
            // 
            firePassTouchedButton.Location = new System.Drawing.Point(0, 0);
            firePassTouchedButton.Name = "firePassTouchedButton";
            firePassTouchedButton.Size = new System.Drawing.Size(75, 23);
            firePassTouchedButton.TabIndex = 0;
            // 
            // propertyGridRequest
            // 
            propertyGridRequest.Dock = System.Windows.Forms.DockStyle.Left;
            propertyGridRequest.Location = new System.Drawing.Point(0, 0);
            propertyGridRequest.Name = "propertyGridRequest";
            propertyGridRequest.Size = new System.Drawing.Size(350, 300);
            propertyGridRequest.TabIndex = 1;
            // 
            // propertyGridResponse
            // 
            propertyGridResponse.Dock = System.Windows.Forms.DockStyle.Fill;
            propertyGridResponse.HelpVisible = false;
            propertyGridResponse.Location = new System.Drawing.Point(356, 0);
            propertyGridResponse.Name = "propertyGridResponse";
            propertyGridResponse.PropertySort = System.Windows.Forms.PropertySort.NoSort;
            propertyGridResponse.Size = new System.Drawing.Size(444, 300);
            propertyGridResponse.TabIndex = 2;
            propertyGridResponse.ToolbarVisible = false;
            // 
            // propertyGridSplitter
            // 
            propertyGridSplitter.Location = new System.Drawing.Point(350, 0);
            propertyGridSplitter.Name = "propertyGridSplitter";
            propertyGridSplitter.Size = new System.Drawing.Size(6, 300);
            propertyGridSplitter.TabIndex = 5;
            propertyGridSplitter.TabStop = false;
            // 
            // eventListBox
            // 
            eventListBox.Dock = System.Windows.Forms.DockStyle.Bottom;
            eventListBox.ItemHeight = 15;
            eventListBox.Location = new System.Drawing.Point(0, 356);
            eventListBox.Name = "eventListBox";
            eventListBox.Size = new System.Drawing.Size(800, 94);
            eventListBox.TabIndex = 4;
            // 
            // timerClientEvent
            // 
            timerClientEvent.Interval = 300000;
            // 
            // panelAccessResult
            // 
            panelAccessResult.BackColor = System.Drawing.SystemColors.Info;
            panelAccessResult.Dock = System.Windows.Forms.DockStyle.Left;
            panelAccessResult.Location = new System.Drawing.Point(8, 8);
            panelAccessResult.Name = "panelAccessResult";
            panelAccessResult.Size = new System.Drawing.Size(80, 34);
            panelAccessResult.TabIndex = 2;
            // 
            // labelReason
            // 
            labelReason.Dock = System.Windows.Forms.DockStyle.Fill;
            labelReason.Font = new System.Drawing.Font("Segoe UI", 16F, System.Drawing.FontStyle.Bold);
            labelReason.Location = new System.Drawing.Point(88, 8);
            labelReason.Name = "labelReason";
            labelReason.Size = new System.Drawing.Size(504, 34);
            labelReason.TabIndex = 0;
            labelReason.Text = "(reason)";
            // 
            // buttonFakeClientEvent
            // 
            buttonFakeClientEvent.Dock = System.Windows.Forms.DockStyle.Right;
            buttonFakeClientEvent.Location = new System.Drawing.Point(592, 8);
            buttonFakeClientEvent.Name = "buttonFakeClientEvent";
            buttonFakeClientEvent.Size = new System.Drawing.Size(200, 34);
            buttonFakeClientEvent.TabIndex = 1;
            buttonFakeClientEvent.Text = "Generate event";
            buttonFakeClientEvent.Click += buttonFakeClientEvent_Click;
            // 
            // panelStatusRow
            // 
            panelStatusRow.Dock = System.Windows.Forms.DockStyle.Top;
            panelStatusRow.Location = new System.Drawing.Point(0, 0);
            panelStatusRow.Name = "panelStatusRow";
            panelStatusRow.Padding = new System.Windows.Forms.Padding(8);
            panelStatusRow.Size = new System.Drawing.Size(200, 50);
            panelStatusRow.TabIndex = 10;
            // 
            // panelPropertyGrids
            // 
            panelPropertyGrids.Controls.Add(propertyGridResponse);
            panelPropertyGrids.Controls.Add(propertyGridSplitter);
            panelPropertyGrids.Controls.Add(propertyGridRequest);
            panelPropertyGrids.Dock = System.Windows.Forms.DockStyle.Top;
            panelPropertyGrids.Location = new System.Drawing.Point(0, 0);
            panelPropertyGrids.Name = "panelPropertyGrids";
            panelPropertyGrids.Size = new System.Drawing.Size(800, 300);
            panelPropertyGrids.TabIndex = 11;
            // 
            // panelEventMessage
            // 
            panelEventMessage.Controls.Add(labelReason);
            panelEventMessage.Controls.Add(buttonFakeClientEvent);
            panelEventMessage.Controls.Add(panelAccessResult);
            panelEventMessage.Dock = System.Windows.Forms.DockStyle.Top;
            panelEventMessage.Location = new System.Drawing.Point(0, 300);
            panelEventMessage.Name = "panelEventMessage";
            panelEventMessage.Padding = new System.Windows.Forms.Padding(8);
            panelEventMessage.Size = new System.Drawing.Size(800, 50);
            panelEventMessage.TabIndex = 12;
            // 
            // LogicForm
            // 
            AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            ClientSize = new System.Drawing.Size(800, 450);
            Controls.Add(topPanel);
            Controls.Add(panelEventMessage);
            Controls.Add(panelPropertyGrids);
            Controls.Add(mainPanel);
            Controls.Add(eventListBox);
            Text = "Logic";
            topPanel.ResumeLayout(false);
            topPanel.PerformLayout();
            mainPanel.ResumeLayout(false);
            panelPropertyGrids.ResumeLayout(false);
            panelEventMessage.ResumeLayout(false);
            ResumeLayout(false);
        }

        #endregion

        private System.Windows.Forms.Panel topPanel;
        private System.Windows.Forms.LinkLabel swaggerLinkLabel;
        private System.Windows.Forms.Panel mainPanel;
        private System.Windows.Forms.PropertyGrid propertyGridRequest;
        private System.Windows.Forms.Splitter propertyGridSplitter;
        private System.Windows.Forms.PropertyGrid propertyGridResponse;
        private System.Windows.Forms.Button firePassTouchedButton;
        private System.Windows.Forms.ListBox eventListBox;
        private System.Windows.Forms.Timer timerClientEvent;
        private System.Windows.Forms.Panel panelAccessResult;
        private System.Windows.Forms.Label labelReason;
        private System.Windows.Forms.Button buttonFakeClientEvent;
        private System.Windows.Forms.Panel panelStatusRow;
        private System.Windows.Forms.Panel panelPropertyGrids;
        private System.Windows.Forms.Panel panelEventMessage;
    }
}
