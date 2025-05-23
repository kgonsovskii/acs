unit uperskeys;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, memds, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, ComCtrls, DBCtrls;

type

  { Tformpersids }

  Tformpersids = class(TForm)
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    ds: TDataSource;
    mdk: TMemDataset;
    Panel1: TPanel;
    StatusBar3: TStatusBar;
  private

  public

  end;

var
  formpersids: Tformpersids;

implementation

{$R *.lfm}

end.

