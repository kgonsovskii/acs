unit ULan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Menus, ComCtrls, SDatamod, SIntProc2, Buttons, ExtCtrls;

type
  TFAlarm = class(TForm)
    Cods: TStringGrid;
    BRead: TButton;
    BWrite: TButton;
    EChip: TEdit;
    BLoad: TButton;
    EdPort: TEdit;
    BSave: TButton;
    BAdd: TButton;
    MCount: TMemo;
    BChange: TButton;
    BDelete: TButton;
    SBar: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    BlockAll: TButton;
    UnBlockAll: TButton;
    Block: TButton;
    UnBlock: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    SetFactor: TButton;
    BCntrOn: TButton;
    BCntrOff: TButton;
    Panel1: TPanel;
    O2: TPanel;
    O3: TPanel;
    O4: TPanel;
    O5: TPanel;
    O6: TPanel;
    O7: TPanel;
    O8: TPanel;
    O1: TPanel;
    Panel10: TPanel;
    K2: TPanel;
    K3: TPanel;
    K4: TPanel;
    K5: TPanel;
    K6: TPanel;
    K7: TPanel;
    K8: TPanel;
    K1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    OTimer: TTimer;
    KTimer: TTimer;
    procedure CodsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BLoadClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure CodsClick(Sender: TObject);
    procedure BChangeClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    function  CheckInput : boolean;
    procedure BWriteClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BReadClick(Sender: TObject);
    procedure BlockClick(Sender: TObject);
    procedure UnBlockClick(Sender: TObject);
    procedure BlockAllClick(Sender: TObject);
    procedure UnBlockAllClick(Sender: TObject);
    procedure BCntrOnClick(Sender: TObject);
    procedure BCntrOffClick(Sender: TObject);
    procedure LanOnEvent(Sender: TObject);
    procedure KTimerTimer(Sender: TObject);
    procedure OTimerTimer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAlarm: TFAlarm;
  AddrCont : word;
  FObr : array[1..8] of boolean;
  FKZ  : array[1..8] of boolean; 

implementation
uses UNTest;

{$R *.DFM}


//--------------------------------------------
//  Действия при создании формы
procedure TFAlarm.FormCreate(Sender: TObject);
begin
  Cods.Cells[0,0] := 'Код чипа';
  Cods.Cells[1,0] := 'Порт';
  Cods.Cells[2,0] := 'Сост';
  Cods.Cells[3,0] := 'Фактор';
end;

//--------------------------------------------
//   Дейстфия при изменении информации в клетке
procedure TFAlarm.CodsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
 S : string;
begin
  S := Cods.Cells[Acol,ARow];
  if Cods.Cells[2,ARow] = 'A' then
  begin
   Cods.Canvas.Brush.Color := clRed;
   Cods.Canvas.FillRect(Rect);
  end;
  if Cods.Cells[2,ARow] = 'B' then
  begin
   Cods.Canvas.Brush.Color := clSilver;
   Cods.Canvas.FillRect(Rect);
  end;
  if Cods.Cells[2,ARow] = 'U' then
  begin
   Cods.Canvas.Brush.Color := clLime; 
   Cods.Canvas.FillRect(Rect);
  end;
  Cods.Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+5,S);
end;

//*******************************************
//  ПРОЦЕДУРЫ РАБОТЫ СО СПИСКОМ             *
//*******************************************

//--------------------------------------------
//  Загрузка из файла
procedure TFAlarm.BLoadClick(Sender: TObject);
begin
 // Cods.Rows
 // Cods.Rows.Clear;
 try
  MCount.Lines.Clear;
  if FileExists('AlCount.txt') then MCount.Lines.LoadFromFile('AlCount.txt') else
   begin
    SBar.SimpleText := 'Файла с кодами чипов нет';
    exit;
   end;
  Cods.RowCount := StrToInt(MCount.Lines[0]);
  Cods.Cols[0].LoadFromFile('AlKeys1.txt');
  Cods.Cols[1].LoadFromFile('AlKeys2.txt');
  Cods.Cols[2].LoadFromFile('AlKeys3.txt');
  Cods.Cols[3].LoadFromFile('AlKeys4.txt');
 except
  SBar.SimpleText := 'Файла с кодами чипов нет';
 end;
end;

//--------------------------------------------
//   Сохранение в файл
procedure TFAlarm.BSaveClick(Sender: TObject);
begin
 try
  MCount.Lines.Clear;
  MCount.Lines.Add(IntToStr(Cods.RowCount));
  MCount.Lines.SaveToFile('AlCount.txt');
  Cods.Cols[0].SaveToFile('AlKeys1.txt');
  Cods.Cols[1].SaveToFile('AlKeys2.txt');
  Cods.Cols[2].SaveToFile('AlKeys3.txt');
  Cods.Cols[3].SaveToFile('AlKeys4.txt');
  SBar.SimpleText := 'Коды чипов сохранены в файле';
 except
  SBar.SimpleText := 'Ошибка при сохранении кодов чипов';
 end;
end;

//---------------------------------------------
//  Выбор строки в списке чипов
procedure TFAlarm.CodsClick(Sender: TObject);
begin
  if Cods.Row = 0 then Cods.Row := 1;
  EChip.Text := Cods.Cells[0,Cods.Row];
  EdPort.Text := Cods.Cells[1,Cods.Row];
end;

//----------------------------------------------
//  Добавление
procedure TFAlarm.BAddClick(Sender: TObject);
begin
  {if Cods.RowCount > 2 then}
  if not CheckInput then exit;
  Cods.RowCount := Cods.RowCount + 1;
  Cods.Cells[0,Cods.RowCount - 1] := EChip.Text;
  Cods.Cells[1,Cods.RowCount - 1] := EdPort.Text;
end;

//----------------------------------------------
//  Изменение
procedure TFAlarm.BChangeClick(Sender: TObject);
begin
  if Cods.Row = 0 then exit;
  if not CheckInput then exit;
  Cods.Cells[0,Cods.Row] := EChip.Text;
  Cods.Cells[1,Cods.Row] := EdPort.Text;
end;

//----------------------------------------------
//  Удаление
procedure TFAlarm.BDeleteClick(Sender: TObject);
var
 i : integer;
begin
  if Cods.Row = 0 then exit;
  if Cods.Row = Cods.RowCount - 1 then
   begin
    Cods.RowCount :=  Cods.RowCount -1;
    exit;
   end;
  for i := Cods.Row to Cods.RowCount - 2 do
   begin
    Cods.Rows[i] := Cods.Rows[i+1];
   end;
  Cods.RowCount :=  Cods.RowCount -1;
end;

//*******************************************
//  ПРОЦЕДУРЫ РАБОТЫ С КОНТРОЛЛЕРОМ
//*******************************************

//------------------------------------------------
//  Запись охранной информации в контроллер
procedure TFAlarm.BWriteClick(Sender: TObject);
var
 i : word;
begin
  with Form1 do
   begin
    if Cods.RowCount = 1 then
     begin
      ShowMessage('В списке нет чипов');
      exit;
     end;
    SBar.SimpleText := 'Идет загрузка кодов в контроллер '+IntToStr(AddrCont)+
                       '.  Ждите...';
    Cnt.InitAlarmPage(AddrCont,0);
    if Cods.RowCount > 127 then Cods.RowCount := 127;
    for i := 1 to Cods.RowCount-1 do
     begin
      Cnt.PutAlarmKey(DCKeyReverse(Cods.Cells[0,i]),StrToInt(Cods.Cells[1,i]),0);
     end;
    Cnt.PostAlarmPage;
    for i := 1 to Cods.RowCount-1 do
     begin
      Cods.Cells[3,i] := StrInHex(GAlarmPage.Keys[i].Flag,False);
     end;    
    SBar.SimpleText := 'Загрузка кодов в контроллер '+IntToStr(AddrCont)+
                       ' окончена.';
   end;
end;

//------------------------------------------------
//  Чтение охранной информации из контроллера
procedure TFAlarm.BReadClick(Sender: TObject);
var
  i      : word;
  S      : string;
  NChips : word;
  NStr   : word;
  Cod    : string;
  Port   : string;
  Factor : string;
begin
 with Form1 do
  begin
   SBar.SimpleText := 'Идет чтение кодов из контроллера '+IntToStr(AddrCont)+
                       '.  Ждите...';
//   S := Cnt.ReadMem256(AddrCont,32768);   // читаем первую страницу
   S := Cnt.ReadMem256(AddrCont,4096);   // читаем первую страницу
   showmessage(s);
   if Copy(S,1,5) <> 'ALARM' then
    begin
     ShowMessage('Нет сигнатуры ALARM. Коды отсутствуют');  // Ничего нет
     SBar.SimpleText := 'В контроллере '+IntToStr(AddrCont)+
                        ' коды чипов отсутствуют.';
     exit;
    end;
   NChips := Ord(S[8]);           // количество чипов
   NStr := (NChips div 32);        // к-во задействованых страниц(кроме первой)
   if NStr > 0 then
    for i := 1 to NStr do
     S := S + Cnt.ReadMem256(AddrCont,32768+(i*256)); // читаем остальные страницы
   Cods.RowCount := NChips+1;  
   for i := 1 to NChips do
    begin
     Cod := Copy(S,i*8+1,6);
     Cod := DCKeyReverse(StrInHex(Cod,False));
     Port := Copy(S,i*8+7,1);
     Port := Chr(Ord(Port[1])+1);
     Port := StrInHex(Port,False);
     if Copy(Port,1,1) = '8' then Cods.Cells[2,i] := 'B'
                             else Cods.Cells[2,i] := 'U';
     Port := Copy(Port,2,1);
     Factor := Copy(S,i*8+8,1);
     Cods.Cells[0,i] := Cod;
     Cods.Cells[1,i] := Port;
     Cods.Cells[3,i] := StrInHex(Factor,False);
    end;
   Cods.Refresh; 
   SBar.SimpleText := 'Чтение кодов из контроллера '+IntToStr(AddrCont)+' закончено';
  end;
end;

//------------------------------------------------
//  Блокировка чипа
procedure TFAlarm.BlockClick(Sender: TObject);
begin
  Cnt.BlockAlarmKey(AddrCont,StrToInt(Cods.Cells[1,Cods.Row]),Cods.Row);
  Cods.Cells[2,Cods.Row] := 'B';
  Cods.Refresh;
end;

//------------------------------------------------
//  Разблокировка чипа
procedure TFAlarm.UnBlockClick(Sender: TObject);
begin
  Cnt.UnBlockAlarmKey(AddrCont,StrToInt(Cods.Cells[1,Cods.Row]),Cods.Row);
  Cods.Cells[2,Cods.Row] := 'U';
  Cods.Refresh;
end;

//------------------------------------------------
//  Заблокировать все
procedure TFAlarm.BlockAllClick(Sender: TObject);
var
 i : word;
begin
 if Cods.RowCount < 2 then exit;
 for i := 1 to Cods.RowCount - 1 do
  begin
   Cnt.BlockAlarmKey(AddrCont,StrToInt(Cods.Cells[1,i]),i);
   Cods.Cells[2,i] := 'B';
  end;
  Cods.Refresh;
end;

//------------------------------------------------
//  Разблокировать все
procedure TFAlarm.UnBlockAllClick(Sender: TObject);
var
 i : word;
begin
 if Cods.RowCount < 2 then exit;
 for i := 1 to Cods.RowCount - 1 do
  begin
   Cnt.UnBlockAlarmKey(AddrCont,StrToInt(Cods.Cells[1,i]),i);
   Cods.Cells[2,i] := 'U';
  end;
  Cods.Refresh;
end;

//------------------------------------------------
//  Контроль правильности входной информации
function TFAlarm.CheckInput : boolean;
var
 i, f : word;
begin
  Result := True;
  EChip.Text := AnsiUpperCase(EChip.Text);
  if (Ord(EdPort.Text[1]) > $38) or (Ord(EdPort.Text[1]) < $31) then Result := False;
  if length(EChip.Text) <> 12 then Result := False;
  for i := 1 to Length(EChip.Text) do
   begin
    f := Ord(EChip.Text[i]);
    if not (((f>=$30) and (f<=$39)) or ((f>=$41) and (f<=$46))) then Result := False;
   end;
  if not Result then ShowMessage('Введены неверные данные');
end;

//------------------------------------------------
//  При активизации формы выключаем опрос и
//  переводим все контроллеры в состояние OFF
//
procedure TFAlarm.FormActivate(Sender: TObject);
var
 i : word;
 CntrAddr : word;
 BT : TSpeedButton;
begin
  try
  FClose := False;
  if Cnt.StartCntr then Cnt.StartCntr := False;
{  for i := 1 to Form1.BoxCntr.Items.Count-1 do
   begin
    CntrAddr := StrToInt(Form1.BoxCntr.Items.Strings[i]);
    Cnt.CntrOFF(CntrAddr);
    BT := Form1.FindComponent('C'+IntToStr(i)) as TSpeedButton;
    BT.Down := False;
   end;                }
  AddrCont := StrToInt(Form1.BoxCntr.Text);
  except
   ShowMessage('Не выбран контроллер');
   FClose := True;
  end;
end;

//-----------------------------------------------
//  Включение рабочего режима
procedure TFAlarm.BCntrOnClick(Sender: TObject);
var
 i : word;
begin
  for i := 1 to 8 do
   begin
    FObr[i] := False;
    FKZ[i] := False;
   end;
  OTimer.Enabled := True;
  KTimer.Enabled := True;
  BCntrOn.Enabled := False;
  BCntrOff.Enabled := True;
  Cnt.CntrON(AddrCont);
  Cnt.Reset(AddrCont);
  Cnt.OnEventCntr := LanOnEvent;
  Cnt.StartCntr := True;
end;

//-----------------------------------------------
//  Выключение рабочего режима
procedure TFAlarm.BCntrOffClick(Sender: TObject);
begin
  Cnt.StartCntr := False;
  OTimer.Enabled := False;
  KTimer.Enabled := False;
  BCntrOn.Enabled := True;
  BCntrOff.Enabled := False;
  Cnt.CntrOFF(AddrCont);
  Cnt.OnEventCntr := Form1.CntEventCntr;
end;

//-----------------------------------------------------------------
//  Прием сообщений от контроллера
procedure TFAlarm.LanOnEvent(Sender: TObject);
var
 S : string;
 SKey : string;
 SCntr : word;
 SPort, i : word;
 SP : TPanel;
begin
  S := Cnt.GetEvent;
  Form1.M1.Lines.Add(S);
  if (DCGetType(S) = 'KEY') and (DCGetElement(S,1) <> 'A')  then
  begin
   SKey  := DCGetKey(S);
   SCntr := DCGetController(S);
   SPort := DCGetPort(S);
   if SCntr <> AddrCont then exit;
{begin
   if SPort = 1 then BlockAllClick(Self);
   if SPort = 2 then UnblockAllClick(Self);


end;   }
   SBar.SimpleText := S;
   if SKey = '000000000000' then         // КЗ
    begin
     SP := FindComponent('K'+IntToStr(SPort)) as TPanel;
     SP.Color := clRed;
     SP := FindComponent('O'+IntToStr(SPort)) as TPanel;
     SP.Color := clBtnFace;
     FKZ[SPort] := True;
     exit;
    end;
   if SKey = 'FFFFFFFFFFFF' then         // Обрыв
    begin
     SP := FindComponent('O'+IntToStr(SPort)) as TPanel;
     SP.Color := clRed;
     SP := FindComponent('K'+IntToStr(SPort)) as TPanel;
     SP.Color := clBtnFace;
     FObr[SPort] := True;
     exit;
    end;
   for i := 1 to Cods.RowCount - 1 do
    begin
     if Cods.Cells[0,i] = SKey then
      begin
       Cods.Cells[2,i] := 'A';
       Cnt.BlockAlarmKey(AddrCont,SPort,i);
       Cods.Refresh;
      end;
    end;
  end;
end;

procedure TFAlarm.KTimerTimer(Sender: TObject);
var
 i : word;
 SP : TPanel;
begin
 for i := 1 to 8 do
  begin
   SP := FindComponent('K'+IntToStr(i)) as TPanel;
   if not FKZ[i] then SP.Color := clBtnFace;
   FKZ[i] := False;
  end;
end;

procedure TFAlarm.OTimerTimer(Sender: TObject);
var
 i : word;
 SP : TPanel;
begin
 for i := 1 to 8 do
  begin
   SP := FindComponent('O'+IntToStr(i)) as TPanel;
   if not FObr[i] then SP.Color := clBtnFace;
   FObr[i] := False;
  end;
end;

end.
