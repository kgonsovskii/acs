unit uname2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, DBGrids;

type

  { Tformname2 }

  Tformname2 = class(TForm)
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
  formname2: Tformname2;

implementation

{$R *.lfm}

end.

