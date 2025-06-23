// This file is intentionally left blank for future designer support.

namespace Gui.WinForms.Forms
{
    partial class AtlasClientForm
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.TreeView treeViewZones;
        private System.Windows.Forms.PictureBox pictureBoxPlot;
        private System.Windows.Forms.PropertyGrid propertyGrid;
        private System.Windows.Forms.Button btnCreateZone;
        private System.Windows.Forms.Button btnCreateTransit;
        private System.Windows.Forms.Button btnRefresh;
        private System.Windows.Forms.SplitContainer splitContainerMain;
        private System.Windows.Forms.SplitContainer splitContainerRight;
        private System.Windows.Forms.FlowLayoutPanel buttonPanel;
        private System.Windows.Forms.Button btnAddZone;
        private System.Windows.Forms.Button btnDeleteZone;
        private System.Windows.Forms.Button btnAddTransit;
        private System.Windows.Forms.Button btnDeleteTransit;
        private System.Windows.Forms.Button btnUpdate;
        private System.Windows.Forms.ToolTip toolTip;
        private System.Windows.Forms.FlowLayoutPanel rightButtonPanel;

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
            components = new System.ComponentModel.Container();
            splitContainerMain = new System.Windows.Forms.SplitContainer();
            treeViewZones = new System.Windows.Forms.TreeView();
            buttonPanel = new System.Windows.Forms.FlowLayoutPanel();
            btnAddZone = new System.Windows.Forms.Button();
            btnDeleteZone = new System.Windows.Forms.Button();
            btnAddTransit = new System.Windows.Forms.Button();
            btnDeleteTransit = new System.Windows.Forms.Button();
            splitContainerRight = new System.Windows.Forms.SplitContainer();
            pictureBoxPlot = new System.Windows.Forms.PictureBox();
            propertyGrid = new System.Windows.Forms.PropertyGrid();
            toolTip = new System.Windows.Forms.ToolTip(components);
            rightButtonPanel = new System.Windows.Forms.FlowLayoutPanel();
            btnUpdate = new System.Windows.Forms.Button();
            btnRefresh = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)splitContainerMain).BeginInit();
            splitContainerMain.Panel1.SuspendLayout();
            splitContainerMain.Panel2.SuspendLayout();
            splitContainerMain.SuspendLayout();
            buttonPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)splitContainerRight).BeginInit();
            splitContainerRight.Panel1.SuspendLayout();
            splitContainerRight.Panel2.SuspendLayout();
            splitContainerRight.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)pictureBoxPlot).BeginInit();
            SuspendLayout();
            // 
            // splitContainerMain
            // 
            splitContainerMain.Dock = System.Windows.Forms.DockStyle.Fill;
            splitContainerMain.Location = new System.Drawing.Point(0, 0);
            splitContainerMain.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            splitContainerMain.Name = "splitContainerMain";
            // 
            // splitContainerMain.Panel1
            // 
            splitContainerMain.Panel1.Controls.Add(treeViewZones);
            splitContainerMain.Panel1.Controls.Add(buttonPanel);
            // 
            // splitContainerMain.Panel2
            // 
            splitContainerMain.Panel2.Controls.Add(splitContainerRight);
            splitContainerMain.Size = new System.Drawing.Size(875, 525);
            splitContainerMain.SplitterDistance = 218;
            splitContainerMain.TabIndex = 0;
            // 
            // treeViewZones
            // 
            treeViewZones.Dock = System.Windows.Forms.DockStyle.Fill;
            treeViewZones.Location = new System.Drawing.Point(0, 115);
            treeViewZones.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            treeViewZones.Name = "treeViewZones";
            treeViewZones.Size = new System.Drawing.Size(218, 410);
            treeViewZones.TabIndex = 0;
            // 
            // buttonPanel
            // 
            buttonPanel.Controls.Add(btnAddZone);
            buttonPanel.Controls.Add(btnDeleteZone);
            buttonPanel.Controls.Add(btnAddTransit);
            buttonPanel.Controls.Add(btnDeleteTransit);
            buttonPanel.Dock = System.Windows.Forms.DockStyle.Top;
            buttonPanel.FlowDirection = System.Windows.Forms.FlowDirection.LeftToRight;
            buttonPanel.Height = 40;
            buttonPanel.Location = new System.Drawing.Point(0, 0);
            buttonPanel.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            buttonPanel.Name = "buttonPanel";
            buttonPanel.Size = new System.Drawing.Size(218, 40);
            buttonPanel.TabIndex = 1;
            // 
            // btnAddZone
            // 
            btnAddZone.Location = new System.Drawing.Point(3, 2);
            btnAddZone.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnAddZone.Name = "btnAddZone";
            btnAddZone.Size = new System.Drawing.Size(90, 32);
            btnAddZone.TabIndex = 0;
            btnAddZone.Text = "Add Zone";
            btnAddZone.Width = 90;
            btnAddZone.Height = 32;
            toolTip.SetToolTip(btnAddZone, "Add a new zone under the selected node");
            // 
            // btnDeleteZone
            // 
            btnDeleteZone.Location = new System.Drawing.Point(88, 2);
            btnDeleteZone.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnDeleteZone.Name = "btnDeleteZone";
            btnDeleteZone.Size = new System.Drawing.Size(90, 32);
            btnDeleteZone.TabIndex = 1;
            btnDeleteZone.Text = "Delete Zone";
            btnDeleteZone.Width = 90;
            btnDeleteZone.Height = 32;
            toolTip.SetToolTip(btnDeleteZone, "Delete the selected zone");
            // 
            // btnAddTransit
            // 
            btnAddTransit.Location = new System.Drawing.Point(3, 23);
            btnAddTransit.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnAddTransit.Name = "btnAddTransit";
            btnAddTransit.Size = new System.Drawing.Size(90, 32);
            btnAddTransit.TabIndex = 2;
            btnAddTransit.Text = "Add Transit";
            btnAddTransit.Width = 90;
            btnAddTransit.Height = 32;
            toolTip.SetToolTip(btnAddTransit, "Add a new transit for the selected zone");
            // 
            // btnDeleteTransit
            // 
            btnDeleteTransit.Location = new System.Drawing.Point(88, 23);
            btnDeleteTransit.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnDeleteTransit.Name = "btnDeleteTransit";
            btnDeleteTransit.Size = new System.Drawing.Size(90, 32);
            btnDeleteTransit.TabIndex = 3;
            btnDeleteTransit.Text = "Delete Transit";
            btnDeleteTransit.Width = 90;
            btnDeleteTransit.Height = 32;
            toolTip.SetToolTip(btnDeleteTransit, "Delete the selected transit");
            // 
            // splitContainerRight
            // 
            splitContainerRight.Dock = System.Windows.Forms.DockStyle.Fill;
            splitContainerRight.Location = new System.Drawing.Point(0, 0);
            splitContainerRight.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            splitContainerRight.Name = "splitContainerRight";
            splitContainerRight.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainerRight.Panel1
            // 
            splitContainerRight.Panel1.Controls.Add(pictureBoxPlot);
            // 
            // splitContainerRight.Panel2
            // 
            splitContainerRight.Panel2.Controls.Add(propertyGrid);
            splitContainerRight.Panel2.Controls.Add(rightButtonPanel);
            splitContainerRight.Size = new System.Drawing.Size(653, 525);
            splitContainerRight.SplitterDistance = 300;
            splitContainerRight.SplitterWidth = 3;
            splitContainerRight.TabIndex = 1;
            // 
            // pictureBoxPlot
            // 
            pictureBoxPlot.Dock = System.Windows.Forms.DockStyle.Fill;
            pictureBoxPlot.Location = new System.Drawing.Point(0, 0);
            pictureBoxPlot.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            pictureBoxPlot.Name = "pictureBoxPlot";
            pictureBoxPlot.Size = new System.Drawing.Size(653, 300);
            pictureBoxPlot.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            pictureBoxPlot.TabIndex = 0;
            pictureBoxPlot.TabStop = false;
            // 
            // propertyGrid
            // 
            propertyGrid.Dock = System.Windows.Forms.DockStyle.Fill;
            propertyGrid.Location = new System.Drawing.Point(0, 0);
            propertyGrid.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            propertyGrid.Name = "propertyGrid";
            propertyGrid.Size = new System.Drawing.Size(653, 222);
            propertyGrid.TabIndex = 0;
            propertyGrid.PropertySort = System.Windows.Forms.PropertySort.Categorized;
            propertyGrid.HelpVisible = true;
            propertyGrid.ToolbarVisible = true;
            // 
            // rightButtonPanel
            // 
            rightButtonPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            rightButtonPanel.FlowDirection = System.Windows.Forms.FlowDirection.LeftToRight;
            rightButtonPanel.Height = 40;
            rightButtonPanel.Location = new System.Drawing.Point(0, 222);
            rightButtonPanel.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            rightButtonPanel.Name = "rightButtonPanel";
            rightButtonPanel.Size = new System.Drawing.Size(653, 40);
            rightButtonPanel.TabIndex = 1;
            rightButtonPanel.Controls.Add(btnUpdate);
            rightButtonPanel.Controls.Add(btnRefresh);
            // 
            // btnUpdate
            // 
            btnUpdate.Location = new System.Drawing.Point(3, 2);
            btnUpdate.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnUpdate.Name = "btnUpdate";
            btnUpdate.Size = new System.Drawing.Size(90, 32);
            btnUpdate.TabIndex = 0;
            btnUpdate.Text = "Update";
            btnUpdate.Width = 90;
            btnUpdate.Height = 32;
            toolTip.SetToolTip(btnUpdate, "Update the selected object (zone or transit)");
            // 
            // btnRefresh
            // 
            btnRefresh.Location = new System.Drawing.Point(88, 2);
            btnRefresh.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnRefresh.Name = "btnRefresh";
            btnRefresh.Size = new System.Drawing.Size(90, 32);
            btnRefresh.TabIndex = 1;
            btnRefresh.Text = "Refresh";
            btnRefresh.Width = 90;
            btnRefresh.Height = 32;
            toolTip.SetToolTip(btnRefresh, "Refresh the client");
            // 
            // AtlasClientForm
            // 
            AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            ClientSize = new System.Drawing.Size(875, 525);
            Controls.Add(splitContainerMain);
            Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            Text = "Atlas Client";
            Load += AtlasClientForm_Load;
            splitContainerMain.Panel1.ResumeLayout(false);
            splitContainerMain.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)splitContainerMain).EndInit();
            splitContainerMain.ResumeLayout(false);
            buttonPanel.ResumeLayout(false);
            splitContainerRight.Panel1.ResumeLayout(false);
            splitContainerRight.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)splitContainerRight).EndInit();
            splitContainerRight.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)pictureBoxPlot).EndInit();
            ResumeLayout(false);
        }
    }
} 