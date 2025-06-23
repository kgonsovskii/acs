namespace Gui.WinForms.Forms
{
    partial class ContourForm
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.Panel topPanel;
        private System.Windows.Forms.LinkLabel swaggerLinkLabel;
        private System.Windows.Forms.PropertyGrid propertyGrid;
        private System.Windows.Forms.Button btnState;
        private System.Windows.Forms.Button btnLink;
        private System.Windows.Forms.Button btnRelayOn;
        private System.Windows.Forms.Button btnRelayOff;
        private System.Windows.Forms.FlowLayoutPanel buttonPanel;
        private System.Windows.Forms.DataGridView dataGridViewSpots;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            topPanel = new System.Windows.Forms.Panel();
            swaggerLinkLabel = new System.Windows.Forms.LinkLabel();
            propertyGrid = new System.Windows.Forms.PropertyGrid();
            btnState = new System.Windows.Forms.Button();
            btnLink = new System.Windows.Forms.Button();
            btnRelayOn = new System.Windows.Forms.Button();
            btnRelayOff = new System.Windows.Forms.Button();
            buttonPanel = new System.Windows.Forms.FlowLayoutPanel();
            dataGridViewSpots = new System.Windows.Forms.DataGridView();
            topPanel.SuspendLayout();
            buttonPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dataGridViewSpots).BeginInit();
            SuspendLayout();
            //
            // topPanel
            //
            topPanel.Controls.Add(swaggerLinkLabel);
            topPanel.Dock = System.Windows.Forms.DockStyle.Top;
            topPanel.Location = new System.Drawing.Point(0, 0);
            topPanel.Name = "topPanel";
            topPanel.Size = new System.Drawing.Size(850, 40);
            topPanel.TabIndex = 3;
            //
            // swaggerLinkLabel
            //
            swaggerLinkLabel.AutoSize = true;
            swaggerLinkLabel.Location = new System.Drawing.Point(12, 12);
            swaggerLinkLabel.Name = "swaggerLinkLabel";
            swaggerLinkLabel.Size = new System.Drawing.Size(66, 15);
            swaggerLinkLabel.TabIndex = 0;
            swaggerLinkLabel.TabStop = true;
            swaggerLinkLabel.Text = "Swagger UI";
            //
            // propertyGrid
            //
            propertyGrid.Dock = System.Windows.Forms.DockStyle.Fill;
            propertyGrid.Location = new System.Drawing.Point(250, 80);
            propertyGrid.Name = "propertyGrid";
            propertyGrid.Size = new System.Drawing.Size(600, 420);
            propertyGrid.TabIndex = 0;
            //
            // btnState
            //
            btnState.Location = new System.Drawing.Point(3, 3);
            btnState.Name = "btnState";
            btnState.Size = new System.Drawing.Size(90, 23);
            btnState.TabIndex = 0;
            btnState.Text = "State";
            btnState.Click += btnState_Click;
            //
            // btnLink
            //
            btnLink.Location = new System.Drawing.Point(195, 3);
            btnLink.Name = "btnLink";
            btnLink.Size = new System.Drawing.Size(90, 23);
            btnLink.TabIndex = 2;
            btnLink.Text = "Link";
            //
            // btnRelayOn
            //
            btnRelayOn.Location = new System.Drawing.Point(291, 3);
            btnRelayOn.Name = "btnRelayOn";
            btnRelayOn.Size = new System.Drawing.Size(90, 23);
            btnRelayOn.TabIndex = 3;
            btnRelayOn.Text = "Relay On";
            //
            // btnRelayOff
            //
            btnRelayOff.Location = new System.Drawing.Point(387, 3);
            btnRelayOff.Name = "btnRelayOff";
            btnRelayOff.Size = new System.Drawing.Size(90, 23);
            btnRelayOff.TabIndex = 4;
            btnRelayOff.Text = "Relay Off";
            //
            // buttonPanel
            //
            buttonPanel.Controls.Add(btnState);
            buttonPanel.Controls.Add(btnLink);
            buttonPanel.Controls.Add(btnRelayOn);
            buttonPanel.Controls.Add(btnRelayOff);
            buttonPanel.Dock = System.Windows.Forms.DockStyle.Top;
            buttonPanel.Location = new System.Drawing.Point(0, 40);
            buttonPanel.Name = "buttonPanel";
            buttonPanel.Size = new System.Drawing.Size(850, 40);
            buttonPanel.TabIndex = 2;
            //
            // dataGridViewSpots
            //
            dataGridViewSpots.AllowUserToAddRows = false;
            dataGridViewSpots.AllowUserToDeleteRows = false;
            dataGridViewSpots.AllowUserToOrderColumns = true;
            dataGridViewSpots.Dock = System.Windows.Forms.DockStyle.Left;
            dataGridViewSpots.Location = new System.Drawing.Point(0, 80);
            dataGridViewSpots.Name = "dataGridViewSpots";
            dataGridViewSpots.ReadOnly = true;
            dataGridViewSpots.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            dataGridViewSpots.Size = new System.Drawing.Size(250, 420);
            dataGridViewSpots.TabIndex = 1;
            //
            // ContourForm
            //
            AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            ClientSize = new System.Drawing.Size(850, 500);
            Controls.Add(propertyGrid);
            Controls.Add(dataGridViewSpots);
            Controls.Add(buttonPanel);
            Controls.Add(topPanel);
            Text = "Contour Client";
            topPanel.ResumeLayout(false);
            topPanel.PerformLayout();
            buttonPanel.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dataGridViewSpots).EndInit();
            ResumeLayout(false);
        }
    }
}
