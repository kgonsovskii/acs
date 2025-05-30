unit URep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SIntProc2, SIntProc1, Crc8;

type
  TFRep = class(TForm)
    ERCnt: TEdit;
    ERSpeed: TEdit;
    ERCntList: TEdit;
    Label1: TLabel;
    BRWrite: TButton;
    Label2: TLabel;
    Label3: TLabel;
    BRClear: TButton;
    procedure FormShow(Sender: TObject);
    procedure ERCntChange(Sender: TObject);
    procedure BRWriteClick(Sender: TObject);
    procedure BRClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRep: TFRep;

implementation
uses UNTest;

{$R *.DFM}

procedure TFRep.FormShow(Sender: TObject);
var
  i,i1 : word;
  S : string;
  F : bool;
begin
// Читаем установочные данные
WITH Form1 DO BEGIN
  BRWrite.Visible := False;
try
  F := False;
  S := '';
  S := DPReadBlock8(Cnt.APD,Chr(StrToInt(BoxCntr.Text)),0);
  if length(S) <> 8 then exit;
except
 ShowMessage('Проверьте адрес контроллера');
 FRep.Close;
end;

  if Copy(S,1,4) = #$00+#$4B+#$70+#$FF then F := True;
  if CheckSumCRC8(Copy(S,1,7)) = S[8]  then F := True;
  if F then
    begin
     FRep.Caption := 'Настройка репитера (установочные данные имеются)';
     ERCntList.Text := '';
     ERCnt.Text := IntToStr(Ord(S[5]));
     ERSpeed.Text := IntToStr(57600 div ($100 - Ord(S[6])));
     S := DPReadBlock8(Cnt.APD,Chr(StrToInt(BoxCntr.Text)),$20) +
          DPReadBlock8(Cnt.APD,Chr(StrToInt(BoxCntr.Text)),$28) +
          DPReadBlock8(Cnt.APD,Chr(StrToInt(BoxCntr.Text)),$30) +
          DPReadBlock8(Cnt.APD,Chr(StrToInt(BoxCntr.Text)),$38);
      for i := 1 to 32 do
       begin
        for i1 := 0 to 7 do
         begin
          if ((Ord(S[i]) shr i1) and $01) = 0 then
           ERCntList.Text := ERCntList.Text + IntToStr((i-1)*8+i1) + ',';
         end;
       end;
       ERCntList.Text := Copy(ERCntList.Text,1,Length(ERCntList.Text)-1);
    end
   else
    begin
     FRep.Caption := 'Настройка репитера (установочные данные не выставлены)';
     ERSpeed.Text := '9600';
     ERCnt.Text := BoxCntr.Text;
     ERCntList.Text := '';
    end;
   BRWrite.Visible := False;
END;
end;

procedure TFRep.ERCntChange(Sender: TObject);
begin
  BRWrite.Visible := True;
end;

procedure TFRep.BRWriteClick(Sender: TObject);
var
  S : string;
  Adr : char;
  i : word;
  Address : array[1..256] of word;
  NumCnt : word;
  Spisok : string;
  NByte, NBit : word;
begin
try
  S := #$00+#$4B+#$70+#$FF+Chr(StrToInt(ERCnt.Text))+
           Chr($100 - (57600 div StrToInt(ERSpeed.Text)))+#$FF;
  S := S + CheckSumCRC8(S);
  Adr := Chr(StrToInt(Form1.BoxCntr.Text));
except
  ShowMessage('Проверьте адрес и скорость');
  exit;
end;
  DPWriteBlock8(Cnt.APD,Adr,0,S);  // записали сигнатуру
  i := 1;
  S := '';
  NumCnt := 1;
  Spisok := ERCntList.Text+',';
  while i <= length(Spisok) do
    begin
     if (Ord(Spisok[i]) >= $30) and (Ord(Spisok[i]) <= $39) then
         S := S + Spisok[i]
       else
        begin
         if length(S) <> 0 then begin
           Address[NumCnt] := StrToInt(S);
           NumCnt := NumCnt+1;
         end;
         S := '';
        end;
     i := i + 1;
    end;
   NumCnt := NumCnt-1;
  S := '';
  for i := 1 to 32 do S := S + #$FF;
  for i := 1 to NumCnt do
   begin
     NByte := (Address[i] div 8)+1;
     NBit := Address[i] - (Address[i] div 8)*8;
     S[NByte] := Chr(Ord(S[NByte]) and ($FF xor ($01 shl NBit)));
   end;
   DPWriteBlock8(Cnt.APD,Adr,$20,Copy(S,1,8));
   DPWriteBlock8(Cnt.APD,Adr,$28,Copy(S,9,8));
   DPWriteBlock8(Cnt.APD,Adr,$30,Copy(S,17,8));
   DPWriteBlock8(Cnt.APD,Adr,$38,Copy(S,25,8));
end;

procedure TFRep.BRClearClick(Sender: TObject);
var
 S : string;
 i : word;
 Adr : char;
begin
try
  Adr := Chr(StrToInt(Form1.BoxCntr.Text));
except
  ShowMessage('Проверьте адрес');
  exit;
end;
  S := '';
  for i := 1 to 8 do S := S + #$FF;
  DPWriteBlock8(Cnt.APD,Adr,0,S);
end;

end.
