unit uname1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, memds, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, ComCtrls;

type

  { Tformname1 }

  Tformname1 = class(TForm)
    DBGrid1: TDBGrid;
    ds: TDataSource;
    lefind: TLabeledEdit;
    md: TMemDataset;
    Panel1: TPanel;
    sb2: TStatusBar;
  private

  public

  end;

var
  formname1: Tformname1;

implementation

{$R *.lfm}

end.

