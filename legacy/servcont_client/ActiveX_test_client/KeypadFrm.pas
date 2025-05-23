unit KeypadFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BFServCont_TLB, StdCtrls, Grids;

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
    procedure Data2Controls(Data: ITSSServCont_KeypadItems);
    procedure Controls2Data(Data: ITSSServCont_KeypadItems);
  end;

{
var
  frmKeypad: TfrmKeypad;
}

implementation

const
  cPortCount = 8;


{$R *.dfm}

{ TfrmKeypad }

procedure TfrmKeypad.Controls2Data(Data: ITSSServCont_KeypadItems);
var
  i: Integer;
begin
  for i:=0 to Data.Count - 1 do begin
    Data.KeyCount[I] := StrToInt(Grid.Cells[1, i + 1]);
    Data.Timeout[I] := StrToInt(Grid.Cells[2, i + 1]);
  end;
end;

procedure TfrmKeypad.Data2Controls(Data: ITSSServCont_KeypadItems);
var
  i: Integer;
begin
  for i:=0 to Data.Count - 1 do begin
    Grid.Cells[1, i + 1] := IntToStr(Data.KeyCount[i]);
    Grid.Cells[2, i + 1] := IntToStr(Data.Timeout[i]);
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
