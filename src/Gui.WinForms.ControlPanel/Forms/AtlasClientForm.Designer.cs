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
            panel1 = new System.Windows.Forms.Panel();
            treeViewZones = new System.Windows.Forms.TreeView();
            panel2 = new System.Windows.Forms.Panel();
            btnDown = new System.Windows.Forms.Button();
            btnUp = new System.Windows.Forms.Button();
            buttonPanel = new System.Windows.Forms.FlowLayoutPanel();
            btnAddZone = new System.Windows.Forms.Button();
            btnDeleteZone = new System.Windows.Forms.Button();
            btnAddTransit = new System.Windows.Forms.Button();
            btnDeleteTransit = new System.Windows.Forms.Button();
            splitContainerRight = new System.Windows.Forms.SplitContainer();
            pictureBoxPlot = new System.Windows.Forms.PictureBox();
            propertyGrid = new System.Windows.Forms.PropertyGrid();
            rightButtonPanel = new System.Windows.Forms.FlowLayoutPanel();
            btnSaveAll = new System.Windows.Forms.Button();
            btnUpdate = new System.Windows.Forms.Button();
            btnRefresh = new System.Windows.Forms.Button();
            toolTip = new System.Windows.Forms.ToolTip(components);
            ((System.ComponentModel.ISupportInitialize)splitContainerMain).BeginInit();
            splitContainerMain.Panel1.SuspendLayout();
            splitContainerMain.Panel2.SuspendLayout();
            splitContainerMain.SuspendLayout();
            panel1.SuspendLayout();
            panel2.SuspendLayout();
            buttonPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)splitContainerRight).BeginInit();
            splitContainerRight.Panel1.SuspendLayout();
            splitContainerRight.Panel2.SuspendLayout();
            splitContainerRight.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)pictureBoxPlot).BeginInit();
            rightButtonPanel.SuspendLayout();
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
            splitContainerMain.Panel1.Controls.Add(panel1);
            splitContainerMain.Panel1.Controls.Add(buttonPanel);
            // 
            // splitContainerMain.Panel2
            // 
            splitContainerMain.Panel2.Controls.Add(splitContainerRight);
            splitContainerMain.Size = new System.Drawing.Size(875, 525);
            splitContainerMain.SplitterDistance = 218;
            splitContainerMain.TabIndex = 0;
            // 
            // panel1
            // 
            panel1.Controls.Add(treeViewZones);
            panel1.Controls.Add(panel2);
            panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            panel1.Location = new System.Drawing.Point(0, 40);
            panel1.Name = "panel1";
            panel1.Size = new System.Drawing.Size(218, 485);
            panel1.TabIndex = 2;
            // 
            // treeViewZones
            // 
            treeViewZones.Dock = System.Windows.Forms.DockStyle.Fill;
            treeViewZones.Location = new System.Drawing.Point(0, 0);
            treeViewZones.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            treeViewZones.Name = "treeViewZones";
            treeViewZones.Size = new System.Drawing.Size(159, 485);
            treeViewZones.TabIndex = 2;
            // 
            // panel2
            // 
            panel2.Controls.Add(btnDown);
            panel2.Controls.Add(btnUp);
            panel2.Dock = System.Windows.Forms.DockStyle.Right;
            panel2.Location = new System.Drawing.Point(159, 0);
            panel2.Margin = new System.Windows.Forms.Padding(4);
            panel2.Name = "panel2";
            panel2.Padding = new System.Windows.Forms.Padding(4);
            panel2.Size = new System.Drawing.Size(59, 485);
            panel2.TabIndex = 0;
            // 
            // btnDown
            // 
            btnDown.Dock = System.Windows.Forms.DockStyle.Top;
            btnDown.Location = new System.Drawing.Point(4, 49);
            btnDown.Margin = new System.Windows.Forms.Padding(4);
            btnDown.Name = "btnDown";
            btnDown.Padding = new System.Windows.Forms.Padding(4);
            btnDown.Size = new System.Drawing.Size(51, 54);
            btnDown.TabIndex = 1;
            btnDown.Text = "DOWN";
            btnDown.UseVisualStyleBackColor = true;
            // 
            // btnUp
            // 
            btnUp.Dock = System.Windows.Forms.DockStyle.Top;
            btnUp.Location = new System.Drawing.Point(4, 4);
            btnUp.Margin = new System.Windows.Forms.Padding(4);
            btnUp.Name = "btnUp";
            btnUp.Padding = new System.Windows.Forms.Padding(4);
            btnUp.Size = new System.Drawing.Size(51, 45);
            btnUp.TabIndex = 0;
            btnUp.Text = "UP";
            btnUp.UseVisualStyleBackColor = true;
            // 
            // buttonPanel
            // 
            buttonPanel.Controls.Add(btnAddZone);
            buttonPanel.Controls.Add(btnDeleteZone);
            buttonPanel.Controls.Add(btnAddTransit);
            buttonPanel.Controls.Add(btnDeleteTransit);
            buttonPanel.Dock = System.Windows.Forms.DockStyle.Top;
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
            toolTip.SetToolTip(btnAddZone, "Add a new zone under the selected node");
            // 
            // btnDeleteZone
            // 
            btnDeleteZone.Location = new System.Drawing.Point(99, 2);
            btnDeleteZone.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnDeleteZone.Name = "btnDeleteZone";
            btnDeleteZone.Size = new System.Drawing.Size(90, 32);
            btnDeleteZone.TabIndex = 1;
            btnDeleteZone.Text = "Delete Zone";
            toolTip.SetToolTip(btnDeleteZone, "Delete the selected zone");
            // 
            // btnAddTransit
            // 
            btnAddTransit.Location = new System.Drawing.Point(3, 38);
            btnAddTransit.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnAddTransit.Name = "btnAddTransit";
            btnAddTransit.Size = new System.Drawing.Size(90, 32);
            btnAddTransit.TabIndex = 2;
            btnAddTransit.Text = "Add Transit";
            toolTip.SetToolTip(btnAddTransit, "Add a new transit for the selected zone");
            // 
            // btnDeleteTransit
            // 
            btnDeleteTransit.Location = new System.Drawing.Point(99, 38);
            btnDeleteTransit.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnDeleteTransit.Name = "btnDeleteTransit";
            btnDeleteTransit.Size = new System.Drawing.Size(90, 32);
            btnDeleteTransit.TabIndex = 3;
            btnDeleteTransit.Text = "Delete Transit";
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
            splitContainerRight.Panel1.Controls.Add(propertyGrid);
            splitContainerRight.Panel1.Controls.Add(rightButtonPanel);
            // 
            // splitContainerRight.Panel2
            // 
            splitContainerRight.Panel2.Controls.Add(pictureBoxPlot);
                         splitContainerRight.Size = new System.Drawing.Size(653, 525);
             splitContainerRight.SplitterDistance = 240;
             splitContainerRight.SplitterWidth = 3;
            splitContainerRight.TabIndex = 1;
            // 
            // pictureBoxPlot
            // 
            pictureBoxPlot.Dock = System.Windows.Forms.DockStyle.Fill;
            pictureBoxPlot.Location = new System.Drawing.Point(0, 0);
            pictureBoxPlot.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            pictureBoxPlot.Name = "pictureBoxPlot";
            pictureBoxPlot.Size = new System.Drawing.Size(653, 402);
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
            propertyGrid.PropertySort = System.Windows.Forms.PropertySort.Categorized;
            propertyGrid.Size = new System.Drawing.Size(653, 80);
            propertyGrid.TabIndex = 0;
            // 
            // rightButtonPanel
            // 
            rightButtonPanel.Controls.Add(btnSaveAll);
            rightButtonPanel.Controls.Add(btnUpdate);
            rightButtonPanel.Controls.Add(btnRefresh);
            rightButtonPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            rightButtonPanel.Location = new System.Drawing.Point(0, 40);
            rightButtonPanel.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            rightButtonPanel.Name = "rightButtonPanel";
            rightButtonPanel.Size = new System.Drawing.Size(653, 40);
            rightButtonPanel.TabIndex = 1;
            // 
            // btnSaveAll
            // 
            btnSaveAll.DialogResult = System.Windows.Forms.DialogResult.Ignore;
            btnSaveAll.Location = new System.Drawing.Point(3, 2);
            btnSaveAll.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnSaveAll.Name = "btnSaveAll";
            btnSaveAll.Size = new System.Drawing.Size(186, 32);
            btnSaveAll.TabIndex = 2;
            btnSaveAll.Text = "Сохранить снимок данных";
            toolTip.SetToolTip(btnSaveAll, "Refresh the client");
            btnSaveAll.Click += btnSaveAll_Click;
            // 
            // btnUpdate
            // 
            btnUpdate.Location = new System.Drawing.Point(195, 2);
            btnUpdate.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnUpdate.Name = "btnUpdate";
            btnUpdate.Size = new System.Drawing.Size(90, 32);
            btnUpdate.TabIndex = 0;
            btnUpdate.Text = "Update";
            toolTip.SetToolTip(btnUpdate, "Update the selected object (zone or transit)");
            // 
            // btnRefresh
            // 
            btnRefresh.Location = new System.Drawing.Point(291, 2);
            btnRefresh.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            btnRefresh.Name = "btnRefresh";
            btnRefresh.Size = new System.Drawing.Size(90, 32);
            btnRefresh.TabIndex = 1;
            btnRefresh.Text = "Refresh";
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
            panel1.ResumeLayout(false);
            panel2.ResumeLayout(false);
            buttonPanel.ResumeLayout(false);
            splitContainerRight.Panel1.ResumeLayout(false);
            splitContainerRight.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)splitContainerRight).EndInit();
            splitContainerRight.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)pictureBoxPlot).EndInit();
            rightButtonPanel.ResumeLayout(false);
            ResumeLayout(false);
        }

        private System.Windows.Forms.Button btnSaveAll;

        private System.Windows.Forms.Button btnUp;
        private System.Windows.Forms.Button btnDown;

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
    }
}
