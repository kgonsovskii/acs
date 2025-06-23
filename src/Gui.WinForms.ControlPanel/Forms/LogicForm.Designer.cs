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
            this.components = new System.ComponentModel.Container();
            this.topPanel = new System.Windows.Forms.Panel();
            this.swaggerLinkLabel = new System.Windows.Forms.LinkLabel();
            this.mainPanel = new System.Windows.Forms.Panel();
            this.propertyGridRequest = new System.Windows.Forms.PropertyGrid();
            this.propertyGridSplitter = new System.Windows.Forms.Splitter();
            this.propertyGridResponse = new System.Windows.Forms.PropertyGrid();
            this.firePassTouchedButton = new System.Windows.Forms.Button();
            this.eventListBox = new System.Windows.Forms.ListBox();

            // topPanel
            this.topPanel.Dock = System.Windows.Forms.DockStyle.Top;
            this.topPanel.Height = 40;
            this.topPanel.Controls.Add(this.swaggerLinkLabel);

            // swaggerLinkLabel
            this.swaggerLinkLabel.AutoSize = true;
            this.swaggerLinkLabel.Location = new System.Drawing.Point(12, 12);
            this.swaggerLinkLabel.Name = "swaggerLinkLabel";
            this.swaggerLinkLabel.Size = new System.Drawing.Size(100, 15);
            this.swaggerLinkLabel.TabIndex = 0;
            this.swaggerLinkLabel.Text = "Swagger";

            // mainPanel
            this.mainPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mainPanel.Padding = new System.Windows.Forms.Padding(8, 8, 8, 8);
            this.mainPanel.Controls.Add(this.propertyGridResponse);
            this.mainPanel.Controls.Add(this.propertyGridSplitter);
            this.mainPanel.Controls.Add(this.propertyGridRequest);
            this.mainPanel.Controls.Add(this.firePassTouchedButton);

            // firePassTouchedButton
            this.firePassTouchedButton.Dock = System.Windows.Forms.DockStyle.Top;
            this.firePassTouchedButton.Height = 40;
            this.firePassTouchedButton.Text = "Fire PassTouched";
            this.firePassTouchedButton.Name = "firePassTouchedButton";
            this.firePassTouchedButton.TabIndex = 3;

            // propertyGridRequest
            this.propertyGridRequest.Dock = System.Windows.Forms.DockStyle.Left;
            this.propertyGridRequest.Width = 350;
            this.propertyGridRequest.Name = "propertyGridRequest";
            this.propertyGridRequest.TabIndex = 1;

            // propertyGridSplitter
            this.propertyGridSplitter.Dock = System.Windows.Forms.DockStyle.Left;
            this.propertyGridSplitter.Width = 6;
            this.propertyGridSplitter.Name = "propertyGridSplitter";
            this.propertyGridSplitter.TabIndex = 5;
            this.propertyGridSplitter.TabStop = false;

            // propertyGridResponse
            this.propertyGridResponse.Dock = System.Windows.Forms.DockStyle.Fill;
            this.propertyGridResponse.Name = "propertyGridResponse";
            this.propertyGridResponse.TabIndex = 2;
            this.propertyGridResponse.ToolbarVisible = false;
            this.propertyGridResponse.HelpVisible = false;
            this.propertyGridResponse.PropertySort = System.Windows.Forms.PropertySort.NoSort;

            // eventListBox
            this.eventListBox.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.eventListBox.Height = 100;
            this.eventListBox.Name = "eventListBox";
            this.eventListBox.TabIndex = 4;

            // LogicForm
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.mainPanel);
            this.Controls.Add(this.eventListBox);
            this.Controls.Add(this.topPanel);
            this.Name = "LogicForm";
            this.Text = "Logic";
            this.topPanel.ResumeLayout(false);
            this.topPanel.PerformLayout();
            this.mainPanel.ResumeLayout(false);
            this.ResumeLayout(false);
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
    }
} 