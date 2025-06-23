namespace Gui.WinForms.Forms
{
    partial class ContourForm
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.Panel topPanel;
        private System.Windows.Forms.LinkLabel swaggerLinkLabel;
        private System.Windows.Forms.PropertyGrid propertyGrid;
        private System.Windows.Forms.Button btnState;
        private System.Windows.Forms.Button btnEvents;
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

        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.topPanel = new System.Windows.Forms.Panel();
            this.swaggerLinkLabel = new System.Windows.Forms.LinkLabel();
            this.propertyGrid = new System.Windows.Forms.PropertyGrid();
            this.btnState = new System.Windows.Forms.Button();
            this.btnEvents = new System.Windows.Forms.Button();
            this.btnLink = new System.Windows.Forms.Button();
            this.btnRelayOn = new System.Windows.Forms.Button();
            this.btnRelayOff = new System.Windows.Forms.Button();
            this.buttonPanel = new System.Windows.Forms.FlowLayoutPanel();
            this.dataGridViewSpots = new System.Windows.Forms.DataGridView();

            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewSpots)).BeginInit();
            this.SuspendLayout();

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
            this.swaggerLinkLabel.Text = "Swagger UI";

            // dataGridViewSpots
            this.dataGridViewSpots.Dock = System.Windows.Forms.DockStyle.Left;
            this.dataGridViewSpots.Width = 250;
            this.dataGridViewSpots.ReadOnly = true;
            this.dataGridViewSpots.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dataGridViewSpots.AllowUserToAddRows = false;
            this.dataGridViewSpots.AllowUserToDeleteRows = false;
            this.dataGridViewSpots.AllowUserToOrderColumns = true;

            // buttonPanel
            this.buttonPanel.Dock = System.Windows.Forms.DockStyle.Top;
            this.buttonPanel.Height = 40;
            this.buttonPanel.FlowDirection = System.Windows.Forms.FlowDirection.LeftToRight;
            this.buttonPanel.Controls.Add(this.btnState);
            this.buttonPanel.Controls.Add(this.btnEvents);
            this.buttonPanel.Controls.Add(this.btnLink);
            this.buttonPanel.Controls.Add(this.btnRelayOn);
            this.buttonPanel.Controls.Add(this.btnRelayOff);

            // btnState
            this.btnState.Text = "State";
            this.btnState.Width = 90;

            // btnEvents
            this.btnEvents.Text = "Events";
            this.btnEvents.Width = 90;

            // btnLink
            this.btnLink.Text = "Link";
            this.btnLink.Width = 90;

            // btnRelayOn
            this.btnRelayOn.Text = "Relay On";
            this.btnRelayOn.Width = 90;

            // btnRelayOff
            this.btnRelayOff.Text = "Relay Off";
            this.btnRelayOff.Width = 90;

            // propertyGrid
            this.propertyGrid.Dock = System.Windows.Forms.DockStyle.Fill;

            // ContourForm
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(850, 500);
            this.Controls.Add(this.propertyGrid);
            this.Controls.Add(this.dataGridViewSpots);
            this.Controls.Add(this.buttonPanel);
            this.Controls.Add(this.topPanel);
            this.Name = "ContourForm";
            this.Text = "Contour Client";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewSpots)).EndInit();
            this.ResumeLayout(false);
        }
    }
} 