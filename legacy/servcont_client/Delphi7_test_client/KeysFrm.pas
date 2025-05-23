unit KeysFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls;

type
  TfrmKeys = class(TForm)
    Grid: TStringGrid;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  frmKeys: TfrmKeys;}

implementation

{$R *.dfm}

procedure TfrmKeys.FormCreate(Sender: TObject);
begin
  Grid.ColWidths[0] := 35;
  Grid.Cells[1,0] := 'Key';
  Grid.Cells[2,0] := 'Ports';
  Grid.Cells[3,0] := 'PersCat';
  Grid.Cells[4,0] := 'SuppressDoorEvent';
  Grid.Cells[5,0] := 'OpenEvenComplex';
  Grid.Cells[6,0] := 'IsSilent';
end;

end.
