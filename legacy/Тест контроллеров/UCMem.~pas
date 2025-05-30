unit UCMem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids;

type
  TFCmem = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SGParam: TStringGrid;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    BWrite: TButton;
    BExit: TButton;
    procedure FormShow(Sender: TObject);
    procedure SGParamKeyPress(Sender: TObject; var Key: Char);
    procedure BExitClick(Sender: TObject);
    procedure BWriteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCmem: TFCmem;

implementation
uses UNTest, SDataMod, SIntProc2;

{$R *.DFM}

procedure TFCmem.FormShow(Sender: TObject);
var
 i, ind : word;
 Acntr  : word;
begin
  try
  FCMem.Caption := 'Автономные установки контроллера '+Form1.BoxCntr.Text;
  ACntr := StrToInt(Form1.BoxCntr.Text);
  ind   := DPGetIndexCntr(ACntr);
  Cnt.Refresh(ACntr);
  for i := 1 to 8 do
   begin
    SGParam.Cells[i-1,0] := IntToStr(CntrOpt[ind].FPort[i].FPRelayTime);
   end;
  for i := 1 to 8 do
   begin
    SGParam.Cells[i-1,1] := IntToStr(CntrOpt[ind].FPort[i].FPDelayKey);
   end;
  for i := 1 to 8 do
   begin
    SGParam.Cells[i-1,2] := IntToStr(CntrOpt[ind].FPort[i].FPDelayRTE);
   end;
  for i := 1 to 8 do
   begin
    SGParam.Cells[i-1,3] := IntToStr(CntrOpt[ind].FPort[i].FPDelayDATA);
   end;
  BWrite.Visible := False;

  except
   ShowMessage('Проверьте адрес контроллера');
  end;
end;

procedure TFCmem.SGParamKeyPress(Sender: TObject; var Key: Char);
begin
  BWrite.Visible := True;
end;

procedure TFCmem.BExitClick(Sender: TObject);
begin
  BWrite.Visible := True;
  Close;
end;

procedure TFCmem.BWriteClick(Sender: TObject);
var
 i, ind : word;
 Acntr  : word;
begin
 try
  ACntr := StrToInt(Form1.BoxCntr.Text);
  ind   := DPGetIndexCntr(ACntr);
  for i := 1 to 8 do
   begin
    CntrOpt[ind].FPort[i].FPRelayTime := StrToInt(SGParam.Cells[i-1,0]);
   end;
  for i := 1 to 8 do
   begin
    CntrOpt[ind].FPort[i].FPDelayKey := StrToInt(SGParam.Cells[i-1,1]);
   end;
  for i := 1 to 8 do
   begin
    CntrOpt[ind].FPort[i].FPDelayRTE := StrToInt(SGParam.Cells[i-1,2]);
   end;
  for i := 1 to 8 do
   begin
    CntrOpt[ind].FPort[i].FPDelayDATA := StrToInt(SGParam.Cells[i-1,2]);
   end;
  Cnt.ControlMemPost(ACntr);
  BWrite.Visible := False;
  except
   ShowMessage('Проверьте правильность ввода');
  end;
end;

end.
