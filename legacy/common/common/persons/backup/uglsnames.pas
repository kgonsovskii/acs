unit uglsnames;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, DBGrids, DBCtrls, Menus;

type

  { Tformglsnames }

  Tformglsnames = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBNavigator2: TDBNavigator;
    DBNavigator3: TDBNavigator;
    DBNavigator4: TDBNavigator;
    ds1: TDataSource;
    ds2: TDataSource;
    ds3: TDataSource;
    lefind: TLabeledEdit;
    lefind1: TLabeledEdit;
    lefind2: TLabeledEdit;
    MainMenu1: TMainMenu;
    md1: TMemDataset;
    md2: TMemDataset;
    md3: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    sb1: TStatusBar;
    sb2: TStatusBar;
    sb3: TStatusBar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    procedure ds1DataChange(Sender: TObject; Field: TField);
    procedure ds2DataChange(Sender: TObject; Field: TField);
    procedure ds3DataChange(Sender: TObject; Field: TField);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
  private

  public

  end;

var
  formglsnames: Tformglsnames;

implementation

{$R *.lfm}
uses umain;

{ Tformglsnames }

procedure Tformglsnames.MenuItem2Click(Sender: TObject);
begin
end;

procedure Tformglsnames.ds1DataChange(Sender: TObject; Field: TField);
begin
      sb1.Panels[0].Text:=inttostr(md1.RecNo);
      sb1.Panels[1].Text:=inttostr(md1.Recordcount);

end;

procedure Tformglsnames.ds2DataChange(Sender: TObject; Field: TField);
begin
      sb2.Panels[0].Text:=inttostr(md2.RecNo);
      sb2.Panels[1].Text:=inttostr(md2.Recordcount);
end;

procedure Tformglsnames.ds3DataChange(Sender: TObject; Field: TField);
begin
      sb3.Panels[0].Text:=inttostr(md3.RecNo);
      sb3.Panels[1].Text:=inttostr(md3.Recordcount);
      sb3.Panels[2].text:=datetimetostr(now);
end;

procedure Tformglsnames.MenuItem4Click(Sender: TObject);
VAR
  glsfio:umain.tglsfio;
begin
         glsfio.bidname1:=md1.FieldByName('myid').AsString;
         glsfio.name1:=md1.FieldByName('text').AsString;

         glsfio.bidname2:=md1.FieldByName('myid').AsString;
         glsfio.name2:=md1.FieldByName('text').AsString;

         glsfio.bidname3:=md1.FieldByName('myid').AsString;
         glsfio.name3:=md1.FieldByName('text').AsString;
         form1.linkglsfio(glsfio);
         CLOSE;
end;

end.

