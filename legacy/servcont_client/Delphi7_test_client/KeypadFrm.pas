unit KeypadFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TSSServContAPI, StdCtrls, Grids;

type
  TfrmKeypad = class(TForm)
    Grid: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Data2Controls(Data: PKeypadItems);
    procedure Controls2Data(Data: PKeypadItems);
  end;

{
var
  frmKeypad: TfrmKeypad;
}

implementation

{$R *.dfm}

{ TfrmKeypad }

procedure TfrmKeypad.Controls2Data(Data: PKeypadItems);
var
  i: Integer;
begin
  for i:=0 to cPortCount - 1 do begin
    Data^.Items[i].KeyCount := StrToInt(Grid.Cells[1, i + 1]);
    Data^.Items[i].Timeout := StrToInt(Grid.Cells[2, i + 1]);
  end;
end;

procedure TfrmKeypad.Data2Controls(Data: PKeypadItems);
var
  i: Integer;
begin
  for i:=0 to cPortCount - 1 do begin
    Grid.Cells[1, i + 1] := IntToStr(Data^.Items[i].KeyCount);
    Grid.Cells[2, i + 1] := IntToStr(Data^.Items[i].Timeout);
  end;
end;

procedure TfrmKeypad.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Grid.Cells[0, 0] := 'Port';
  Grid.Cells[1, 0] := 'Count';
  Grid.Cells[2, 0] := 'Timeout';
  for i:=1 to cPortCount do
    Grid.Cells[0, i] := IntToStr(i);
end;

end.
