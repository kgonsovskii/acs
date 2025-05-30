unit UReg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SIntProc2, SDataMod, ULan, SRaspisanie;

type
  TFReg = class(TForm)
    SetData: TCheckBox;
    ETime: TEdit;
    Label1: TLabel;
    TimerDATA: TTimer;
    ChComplex: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    EData: TEdit;
    ButtonBreak: TButton;
    Button4: TButton;
    M5: TMemo;
    Button3: TButton;
    Button5: TButton;
    BBios: TButton;
    OpenDial: TOpenDialog;
    WBios: TButton;
    TMemory: TButton;
    Button6: TButton;
    procedure SetDataClick(Sender: TObject);
    procedure TimerDATATimer(Sender: TObject);
    procedure ChComplexClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonBreakClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BBiosClick(Sender: TObject);
    procedure WBiosClick(Sender: TObject);
    procedure TMemoryClick(Sender: TObject);
    function  SetupString(TwoByte : word) : string;
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FReg: TFReg;
  

implementation

uses UNTest;
procedure FingerPrints; external 'P.dll' Name '_FingerPrints';
type
  DProc = procedure(A1 : integer; A2 : integer; A3 : PChar; A4 : Pointer); stdcall;
var
  Lib : HMODULE;
  ProcPtr : DProc;


{$R *.DFM}

procedure TFReg.SetDataClick(Sender: TObject);
begin
try
  StrToInt(Form1.BoxCntr.Text);
  if SetData.Checked and Cnt.StartCntr then
   begin
    TimerDATA.Interval := StrToInt(ETime.Text);
    TimerDATA.Enabled := True;
   end
  else TimerDATA.Enabled := False;
except
 ShowMessage('Неправильно введен интервал');
end;
end;

procedure TFReg.TimerDATATimer(Sender: TObject);
var
  S, OldS : string;
  P : TPanel;
  i : word;
begin
try
  with Form1 do
   begin
    if Cnt.StartCntr then
     begin
      S := Cnt.GetDATAPrior(StrToInt(BoxCntr.Text),True);
      S := Cnt.GetDATAPrior(StrToInt(BoxCntr.Text),False);
      if S <> oldS then
       begin
        OldS := S;
        for i := 1 to 8 do
         begin
          P := FindComponent('PS'+IntToStr(i)) as TPanel;
          if S[i] = '1' then P.Color := clRed else P.Color := clLime;
         end;
       end;
     end;
   end;
except
  TimerDATA.Enabled := False;
  ShowMessage('Не выбран контроллер');
  SetData.Checked := False;
end;
end;

procedure TFReg.ChComplexClick(Sender: TObject);
var
 i : word;
begin
  if ChComplex.Checked then
   begin
    for i := 1 to GlobalOpt.GNumCntr do
     begin
     // if (CntrOpt[i].FVersProg = WA48) or (CntrOpt[i].FVersProg = C207)
     //     or (CntrOpt[i].FVersProg = SZ35v20) then
        Cnt.SetComplexOFF(Ord(CntrOpt[i].FAddrCntr));
     end;
   end
  else
   begin
    for i := 1 to GlobalOpt.GNumCntr do
     begin
    //  if (CntrOpt[i].FVersProg = WA48) or (CntrOpt[i].FVersProg = C207)
    //     or (CntrOpt[i].FVersProg = SZ35v20) then
        Cnt.SetComplexON(Ord(CntrOpt[i].FAddrCntr));
     end;
   end;
end;

procedure TFReg.Button1Click(Sender: TObject);
var
 i,j,k : longint;
 Key : string;
 Addr : integer;
begin
 with Form1 do
  begin
   try
M1.Lines.Add(BoxCntr.Text);
   Addr := StrToInt(BoxCntr.Text);
   if (Length(EData.Text) <= 8) and (Length(EData.Text) >= 0) then
    begin
     for i := 1 to Length(EData.Text) do
      begin
       if (Ord(EData.Text[i]) < $31) or (Ord(EData.Text[i]) > $38) then
        begin
         M5.Lines.Add('Ошибка в задании маски портов');
         exit;
        end;
      end;
M1.Lines.Add('До SetKeyPad');
     Cnt.SetKeypad(Addr,4,15,EData.Text);
     M5.Lines.Add('Дескрипторы - '+FCon207.ContInfo.KeypadInfo);
     exit;
    end;
    M5.Lines.Add('Ошибка в задании маски портов');
   except
    M5.Lines.Add('Ошибка - не выбран контроллер');
   end;
  end;


end;

procedure TFReg.Button2Click(Sender: TObject);
begin
  EData.Text := Cnt.GetDATAPrior(StrToInt(Form1.BoxCntr.Text),True);
  EData.Text := Cnt.GetDATAPrior(StrToInt(Form1.BoxCntr.Text),False);
end;

procedure TFReg.ButtonBreakClick(Sender: TObject);
var
 i,j,K : longint;
begin
 for i := 1 to 2000000000 do
  begin
   j := i;
   K := i+j;
  end;
end;

procedure TFReg.Button4Click(Sender: TObject);
begin
  with Form1 do
   begin
    M1.Lines.Add('К-во событий = '+IntToStr(Cnt.GetNumEvent(StrToInt(BoxCntr.Text))));

   end;
end;

procedure TFReg.Button3Click(Sender: TObject);
begin
  Cnt.ReadKeys(StrToInt(Form1.BoxCntr.Text),M5.Lines);
end;

procedure TFReg.Button5Click(Sender: TObject);
begin
   if Cnt.StartCntr then Cnt.StartCntr := False;
//   FAlarm.ShowModal;
   FAlarm.Show;
   if FClose then FAlarm.Close;        
end;

procedure TFReg.BBiosClick(Sender: TObject);
var
 i, j : integer;
 Bin : File;
 S : string;
 C : array[1..256] of char;
begin
  S := '';

  if Form1.BoxCntr.Text = '' then
   begin
    ShowMessage('Не выбран контроллер');
    exit;
   end;
   FCon207.Open := False;
   FCon207.Trace := True;
   FCon207.Open := True;
   Fcon207.AddrCont := Chr(StrToInt(Form1.BoxCntr.Text));

  // FCon207.TraceMode := (ttReads,ttWrites);
   if OpenDial.Execute then
    begin
     M5.Lines.Add(OpenDial.FileName);
     AssignFile(Bin,OpenDial.FileName);
     Reset(Bin,256);
     for i := 1 to 12 do
      begin
       BlockRead(Bin,C,1);
       S := '';
       for J := 1 to 256 do
        begin
         S := S + C[j];
        end;
       FCon207.WriteRAM((i-1)*256,S);
       M5.Lines.Add('Записываем '+IntToStr(Length(S))+'  '+StrInHex(C[1]+C[2]+C[3],True));
      end;
     S := #$00+ #$00+ #$01+ #$52+ #$5F+ #$DC+ #$00+ #$00;
     Fcon207.PutKey(S);

    end;
end;

procedure TFReg.WBiosClick(Sender: TObject);
var
 A: array[1..65536] of char;
 S : string;
 R: array[1..2] of char;
 i, j : integer;
begin
  if Lib = 0 then
   begin
    Lib := LoadLibrary('P.dll');
    if Lib = 0 then
     begin
      ShowMessage('Нет библиотеки');
      exit;
     end;
    ProcPtr := DProc(GetProcAddress(Lib,'_FingerPrints'));

   end;
  ProcPtr(2,115200,@A,@R);

  M5.Lines.Add(StrInHex(R[1]+R[2],True));

  FCon207.Trace := False;
  FCon207.Open := True;
  Fcon207.AddrCont := Chr(StrToInt(Form1.BoxCntr.Text));

  for i := 1 to 12 do
      begin
       S := '';
       for J := 1 to 256 do
        begin
         S := S + A[j+(i-1)*256];
        end;
       FCon207.WriteRAM((i-1)*256,S);
       M5.Lines.Add('Записываем '+IntToStr(Length(S))+'  '+StrInHex(A[(i-1)*256+1]+A[(i-1)*256+2]+A[(i-1)*256+3],True));
      end;
     S := #$00+ #$00+ #$01+ #$52+ #$5F+ #$DC+ #$00+ #$00;
     Fcon207.PutKey(S);

end;

procedure TFReg.TMemoryClick(Sender: TObject);
var
  AddrCont : word;
  S : string;
begin
 try
  AddrCont := StrToInt(Form1.BoxCntr.Text);
 except
  ShowMessage('Не выбран контроллер');
  exit;
 end;
  M5.Lines.Add('Начало теста памяти контроллера '+IntToStr(AddrCont)+'. Ждите...');
  M5.Lines.Add('Тест нулей...');
  S := SetupString($0000);


end;

function TFReg.SetupString(TwoByte : word) : string;
var
 i : word;
 S : string;
 Sym1 : char;
 Sym2 : char;
begin
 S := '';
 Sym1 := Chr((TwoByte shr 8) and $00FF);
 Sym2 := Chr(TwoByte and $00FF);
 for i := 1 to 128 do
  begin
   S := S + Sym1 + Sym2;
  end;
 Result := S;
end;

procedure TFReg.Button6Click(Sender: TObject);
var
  TR : TRaspisanie;
begin
  TR := TRaspisanie.Create;
  TR.SetHolyday('01.05.2003');
  TR.SetTime(1,1,1,'10:20','10:40');
  TR.SetTime(1,1,2,'10:50','11:00');
  TR.SetTime(1,1,3,'11:30','11:45');
  TR.WriteRasp(Cnt,StrToInt(Form1.BoxCntr.Text));
end;

end.


