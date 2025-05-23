unit ChipsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, ExtCtrls, ActnList, Menus;

type
  TfrmChips = class(TForm)
    Grid: TStringGrid;
    StatusBar: TStatusBar;
    Panel1: TPanel;
    Label12: TLabel;
    chbPort1: TCheckBox;
    chbPort2: TCheckBox;
    chbPort3: TCheckBox;
    chbPort4: TCheckBox;
    chbPort5: TCheckBox;
    chbPort6: TCheckBox;
    chbPort7: TCheckBox;
    chbPort8: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    actAdd: TAction;
    actDel: TAction;
    actClear: TAction;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    ClearAll1: TMenuItem;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actDelExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure GridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    function Controls2Data(var Data: string): Integer;
  end;

var
  frmChips: TfrmChips;

implementation

uses
  TSSServContAPI, MainFrm;

{$R *.dfm}

function TfrmChips.Controls2Data(var Data: string): Integer;
var
  i, j: Integer;
  chb: TCheckBox;
  Chip: TControllerChip;
begin
  Result := Grid.RowCount - 2;
  if Result < 1 then
    Exit;
  SetLength(Data, SizeOf(TControllerPorts) + SizeOf(TControllerChip) * Result);
  for j:=0 to cPortCount - 1 do begin
    chb := FindComponent('chbPort' + IntToStr(j + 1)) as TCheckBox;
    Assert(chb <> nil);
    Data[j + 1] := Chr(Ord(chb.Checked));
  end;
  for i:=0 to Result - 1 do begin
    with Chip, Grid do begin
      Move(Bin(Cells[0, i+1])[1], Value, cKeySize);
      Active := StrToBool(Cells[1, i+1]);
      OpenEvenComplex := StrToBool(Cells[2, i+1]);
      CheckCount := StrToInt(Cells[3, i+1]);
      Port := StrToInt(Cells[4, i+1]);
    end;
    Move(Chip, Data[SizeOf(TControllerPorts) + (i * SizeOf(TControllerChip)) + 1], SizeOf(TControllerChip));
  end;
end;

procedure TfrmChips.FormCreate(Sender: TObject);
begin
  Grid.Cells[0,0] := 'Chip';
  Grid.Cells[1,0] := 'Active';
  Grid.Cells[2,0] := 'OpenEvenComplex';
  Grid.Cells[3,0] := 'CheckCount';
  Grid.Cells[4,0] := 'Port';
end;

procedure TfrmChips.actAddExecute(Sender: TObject);
begin
  AddGridRow(Grid);
end;

procedure TfrmChips.actClearExecute(Sender: TObject);
begin
  ClearGrid(Grid);
end;

procedure TfrmChips.actDelExecute(Sender: TObject);
begin
  RemoveGridRow(Grid, Grid.Row);
end;

procedure TfrmChips.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := True;
  if Action = actAdd then
    TAction(Action).Enabled := Grid.RowCount <= (127 + 2)
  else
  if Action = actDel then
    TAction(Action).Enabled := (Grid.Row <> 0) and (Grid.Row <> (Grid.RowCount - 1))
  else
  if Action = actClear then
    TAction(Action).Enabled := True
  else
    Handled := False;
end;

procedure TfrmChips.GridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_INSERT then
    actAdd.Execute
  else if Key = VK_DELETE then
    actDel.Execute;
end;

end.
