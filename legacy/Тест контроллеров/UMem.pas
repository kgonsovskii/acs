unit UMem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, SIntProc1, SIntProc2, ComCtrls;

type
  TFMem = class(TForm)
    BMRead: TButton;
    NPage: TEdit;
    LPage: TListBox;
    BMWrite: TButton;
    EPage: TMaskEdit;
    TextCnt: TStaticText;
    StaticText1: TStaticText;
    Label1: TLabel;
    BEdit: TButton;
    SBar: TStatusBar;
    ALBox: TListBox;
    BZero: TButton;
    BOne: TButton;
    procedure FormCreate(Sender: TObject);
    procedure LPageClick(Sender: TObject);
    procedure BMReadClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BMWriteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BZeroClick(Sender: TObject);
    procedure BOneClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMem     : TFMem;
  ACntr    : word;
//  CntrType : string;
  OldS     : string;

implementation
uses UNTest;

{$R *.DFM}

procedure TFMem.FormCreate(Sender: TObject);
var
 i : word;
begin
  LPage.Items.Clear;
  ALBox.Items.Clear;
  EPage.Text := '';
//  CntrType := 'SZ35';
  for i := 1 to 16 do LPage.Items.Add('');
  for i := 1 to 16 do ALBox.Items.Add('');
end;

procedure TFMem.LPageClick(Sender: TObject);
begin
  EPage.Text := LPage.Items.Strings[LPage.ItemIndex];
  FMem.ActiveControl := EPage;
end;

procedure TFMem.BMReadClick(Sender: TObject);
var
 MemAddr : integer;
 i : word;
 S : string;
begin
  try
    MemAddr := Ord(DPHexInChar(NPage.Text));
    MemAddr := MemAddr*256;
  except
   ShowMessage('Неверное значение номера страницы');
   exit;
  end;
  EPage.Text := '';
  LPage.Items.Clear;
  ALBox.Items.Clear;
  SBar.SimpleText :=
    'Идет чтение памяти контроллера '+IntToStr(ACont)+' по адресу '+
        IntToStr(MemAddr)+'  '+CntrType;
  for i := 1 to 16 do LPage.Items.Add('');
  for i := 1 to 16 do ALBox.Items.Add('');
    for i := 1 to 16 do
     begin
      if (CntrType = 'SZ35') or (CntrType = 'HBIT') then begin
        S := DPReadBlock8(Cnt.APD,Chr(ACont),MemAddr+(i-1)*16);
        S := S+DPReadBlock8(Cnt.APD,Chr(ACont),MemAddr+(i-1)*16+8);
      end;
      if (CntrType = 'WA48')or(CntrType = 'HABA')then begin

        S := Read8WA48(Cnt.APD,ACont,MemAddr+(i-1)*16);
        S := S+Read8WA48(Cnt.APD,ACont,MemAddr+(i-1)*16+8);
      end;
      if (CntrType = 'C207') then begin
        S := Cnt.ReadMemWA48(ACont,MemAddr+(i-1)*16);
        S := S+Cnt.ReadMemWA48(ACont,MemAddr+(i-1)*16+8);
      end;
      ALBox.Items.Strings[i-1] := ' '+IntToHex(MemAddr+(i-1)*16,6);
      LPage.Items.Strings[i-1] := StrInHex(S,True);
     end;
  SBar.SimpleText := 'Прочитано';
end;

procedure TFMem.BEditClick(Sender: TObject);
var
 i : word;
 Sym : char;
 F : bool;
 S : string;
begin
 // EPage.Text := ANSIUpperCase(EPage.Text);
  S := EPage.Text;
  for i := 0 to 15 do
   begin
    Sym := S[1+(i*3)];
    if ((Sym >= #$30) and (Sym <= #$39)) or ((Sym >= #$41) and (Sym <= #$46)) or
           ((Sym >= #$61) and (Sym <= #$66))
      then F := True
      else begin F := False; break; end;
   end;
   if F then LPage.Items.Strings[LPage.ItemIndex] := ANSIUpperCase(S);
   if not F then
     begin
      ShowMessage('Не шестнадцатеричная цифра');
      exit;
     end;

end;

procedure TFMem.BMWriteClick(Sender: TObject);
var
i,si  : word;
S, SS : string;
MemAddr : integer;
begin
  try
   MemAddr := Ord(DPHexInChar(NPage.Text));
   MemAddr := MemAddr*256;
  except
   ShowMessage('Неверное значение номера страницы');
   exit;
  end;
  FMem.Enabled := False;
  for si := 0 to 15 do
  begin
    S := '';
    SS := LPage.Items.Strings[si];
    for i := 0 to 15 do S := S + DPHexInChar(SS[i*3+1] + SS[i*3+2]);
    SBar.SimpleText :=
    'Идет запись памяти контроллера '+IntToStr(ACont)+' по адресу '+IntToStr(MemAddr);
    if (CntrType = 'SZ35')or(CntrType = 'HBIT') then
    begin

      if DPWriteBlock8(Cnt.APD,Chr(ACont),MemAddr+si*16,Copy(S,1,8)) < 0 then
       begin
         SBar.SimpleText := 'ОШИБКА ! ! !   '+IntToStr(si);
         FMem.Enabled := True;
         exit;
       end;
      if DPWriteBlock8(Cnt.APD,Chr(ACont),MemAddr+si*16+8,Copy(S,9,8)) < 0 then
       begin
         SBar.SimpleText := 'ОШИБКА ! ! !  2 '+IntToStr(si);
         FMem.Enabled := True;
         exit;
       end;
    end;

   if (CntrType = 'WA48')or(CntrType = 'HABA')then
    begin
     WriteWA48N(Cnt.APD,ACont,MemAddr+si*16,Copy(S,1,8),8);
     WriteWA48N(Cnt.APD,ACont,MemAddr+si*16+8,Copy(S,9,8),8);
    end;

   if CntrType = 'C207' then
    begin
     Cnt.WriteMemWA48(ACont,MemAddr+si*16,Copy(S,1,8),8);
     Cnt.WriteMemWA48(ACont,MemAddr+si*16+8,Copy(S,9,8),8);
    end;
  end;
  SBar.SimpleText := 'Записано';
  FMem.Enabled := True;
end;

procedure TFMem.FormShow(Sender: TObject);
begin
  SBar.SimpleText := 'Готов к работе, контроллер '+Form1.BoxCntr.Text;
end;

procedure TFMem.BZeroClick(Sender: TObject);
var
  S : string;
  i : word;
begin
  LPage.Items.Clear;
  ALBox.Items.Clear;
  EPage.Text := '';
  S := '';
  for i := 1 to 16 do S := S + #$00;
  for i := 1 to 16 do LPage.Items.Add(StrInHex(S,True));
  for i := 1 to 16 do ALBox.Items.Add('');
end;

procedure TFMem.BOneClick(Sender: TObject);
var
  S : string;
  i : word;
begin
  LPage.Items.Clear;
  ALBox.Items.Clear;
  EPage.Text := '';
  S := '';
  for i := 1 to 16 do S := S + #$FF;
  for i := 1 to 16 do LPage.Items.Add(StrInHex(S,True));
  for i := 1 to 16 do ALBox.Items.Add('');

end;

end.

