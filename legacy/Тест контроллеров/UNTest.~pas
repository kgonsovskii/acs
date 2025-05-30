unit UNTest;
{$R-}               
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, OoMisc, AdPort, StdCtrls, SIntProc2, SDatamod, SIntProc1,
  lmdctrl, lmdstdcS, lmdextcA, Buttons, URelay, SDalComp, SProc207,
  SocketDalnova, UChannel, SRaspisanie;

type
  TForm1 = class(TForm)

    M1: TMemo;
    Label1: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Accelerator: TTimer;
    LReserv: TLabel;
    Timer4: TTimer;
    Timer5: TTimer;
    Timer6: TTimer;
    Panel1: TPanel;
    PS1: TPanel;
    PS2: TPanel;
    PS3: TPanel;
    PS4: TPanel;
    PS5: TPanel;
    PS6: TPanel;
    PS7: TPanel;
    PS8: TPanel;
    AskCOM: TButton;
    AskIP: TButton;
    BSetClock: TButton;
    BSetDate: TButton;
    BSend: TButton;
    CSend: TCheckBox;
    ESend: TEdit;
    CResKey: TCheckBox;
    Button4: TButton;
    ECommand: TEdit;
    Button3: TButton;
    Panel2: TPanel;
    BStart: TButton;
    IntTimer: TCheckBox;
    BStack: TButton;
    Label3: TLabel;
    RRasp: TButton;
    Button2: TButton;
    CTrace: TCheckBox;
    CAvt: TCheckBox;
    C1: TSpeedButton;
    C2: TSpeedButton;
    C3: TSpeedButton;
    C4: TSpeedButton;
    C5: TSpeedButton;
    C6: TSpeedButton;
    C7: TSpeedButton;
    C8: TSpeedButton;
    C9: TSpeedButton;
    C10: TSpeedButton;
    C11: TSpeedButton;
    C12: TSpeedButton;
    C13: TSpeedButton;
    C14: TSpeedButton;
    C15: TSpeedButton;
    C16: TSpeedButton;
    C17: TSpeedButton;
    C18: TSpeedButton;
    C19: TSpeedButton;
    C20: TSpeedButton;
    C21: TSpeedButton;
    C22: TSpeedButton;
    C23: TSpeedButton;
    C24: TSpeedButton;
    C25: TSpeedButton;
    C26: TSpeedButton;
    C27: TSpeedButton;
    C28: TSpeedButton;
    C29: TSpeedButton;
    C30: TSpeedButton;
    C31: TSpeedButton;
    C32: TSpeedButton;
    C33: TSpeedButton;
    C34: TSpeedButton;
    C35: TSpeedButton;
    C36: TSpeedButton;
    C37: TSpeedButton;
    C38: TSpeedButton;
    C39: TSpeedButton;
    C40: TSpeedButton;
    C41: TSpeedButton;
    C42: TSpeedButton;
    C43: TSpeedButton;
    C44: TSpeedButton;
    BSetChannel: TButton;
    BS: TButton;
    BL: TButton;
    BC: TButton;
    BR: TButton;
    BRead: TButton;
    BControlMem: TButton;
    M2: TMemo;
    BE: TButton;
    BoxPort: TComboBox;
    BoxSpeed: TComboBox;
    BoxCntr: TComboBox;
    Lcntr: TLabel;
    Ind: TLMDProgressFill;
    Label2: TLabel;
    BRejim: TButton;
    BOption: TButton;
    Button1: TButton;
    Label4: TLabel;
    procedure CntErrorCntr(Sender: TObject);
    procedure CntEventCntr(Sender: TObject);
    procedure CntProgCntr(Sender: TObject);
    procedure CntAnswerCntr(Sender : TObject; AddrCntr : string);
    procedure CntDisconnect(Sender: TObject; Channel : string);
    procedure RecLog(S : string);

    procedure BLClick(Sender: TObject);
    procedure BCClick(Sender: TObject);
    procedure BAClick(Sender: TObject);
    procedure BSClick(Sender: TObject);
    procedure BStartClick(Sender: TObject);
    procedure BOptionClick(Sender: TObject);
    procedure BRClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BReadClick(Sender: TObject);
    procedure BoxCntrChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BNumEventClick(Sender: TObject);
   
    procedure BControlMemClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BSetClockClick(Sender: TObject);
    procedure BSetDateClick(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure IntTimerClick(Sender: TObject);
    procedure BStackClick(Sender: TObject);
    procedure BSendClick(Sender: TObject);
    procedure AskCOMClick(Sender: TObject);
    procedure BRejimClick(Sender: TObject);
    procedure AcceleratorTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Debug(Sender:TObject;Msg : string);
    procedure BSetChannelClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CAvtClick(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure RRaspClick(Sender: TObject);
 //   procedure AskIPClick(Sender: TObject);
    procedure BEClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer6Timer(Sender: TObject);
    procedure CTraceClick(Sender: TObject);
 

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure Visibl;
  procedure VisiblC;
  procedure InVisible;
  procedure InVisibleC;
  function  Vklucheno : bool;

var
  Form1    : TForm1;
  ACont    : word;
  CntrType : string;
  GlobalExit : boolean;
  MemEnabled : bool;
  LogFile  : TextFile;
  FClose   : boolean;
  Cnt      : TSocketController;
  FTimeOut : integer;
  FNumError: integer;
  FDisc    : integer;
  Traffic  : longint;
    gInfo : TCont;

implementation
uses UKey, UOption, UMem, UCMem, URep, UReg;

{$R *.DFM}

procedure TForm1.CntErrorCntr(Sender: TObject);
var
 S : string;
begin
   S := Cnt.GetError;
   M1.Lines.Add(TimeToStr(Time)+'  '+S);
   if FOption.CDisk.Checked then
    begin
     WriteLn(LogFile,TimeToStr(Time)+'  '+S);
     Flush(LogFile);
    end;
end;

procedure TForm1.CntEventCntr(Sender: TObject);
var
 S, SH : string;
 Cntr, Port : word;
begin
   S  := Cnt.GetEvent;
 //  if DCGetType(S) = 'KEY' then Timer6.Enabled := True;
   SH := Cnt.GetEventHex;
   WiewEvent(M1,S,SH);
end;

procedure TForm1.CntProgCntr(Sender: TObject);
var
 S : string;
begin
 S := Cnt.GetProg;
 M1.Lines.Add(TimeToStr(Time)+'  '+S);
   if FOption.CDisk.Checked then
    begin
     WriteLn(LogFile,TimeToStr(Time)+'  '+S);
     Flush(LogFile);
    end;
end;

procedure TForm1.CntDisconnect(Sender: TObject; Channel : string);
begin
  WiewString('Самостоятельное отключение от канала '+Channel);
  GlobalOpt.GPortBusy := False;
  Cnt.APD.Open := False;
  Cnt.APD.Open := True;
  Cnt.StopCntr;
  Cnt.StartCntr := True;
end;

procedure TForm1.BLClick(Sender: TObject);
var
  i : word;
  CntrAddr : word;
  BC : TSpeedButton;
begin
 FKey.ShowModal;
 for i := 0 to BoxCntr.Items.Count-1 do
  begin
   CntrAddr := StrToInt(BoxCntr.Items.Strings[i]);
   Cnt.CntrOFF(CntrAddr);
   BC := FindComponent('C'+IntToStr(i+1)) as TSpeedButton;
   BC.Down := False;
  end;
end;

procedure TForm1.BCClick(Sender: TObject);
begin
  Cnt.Reset(StrToInt(BoxCntr.Text));
end;

procedure TForm1.BAClick(Sender: TObject);
begin
  if BoxCntr.Text = '' then exit;
end;

//поиск контроллеров
procedure TForm1.BSClick(Sender: TObject);
var
 i, j, k : word;
 S : string;
 ListCntr, AppDir, NumCom : string;
 Speed : integer;
 FSt : bool;
 NumCntr, NC : word;
 NAddr, KAddr : word;
 CntsTyp : array[1..256] of byte;
 CntAddresses   : array[1..256] of word;
begin
  try
   FTimeOut := StrToInt(FOption.eTimeOut.Text);
   FDisc := StrToInt(FOption.EDisc.Text);
  except
   FTimeOut := 2;
   FDisc := 1;
  end;
  Timer1.Enabled := False;
  NC := 0;
  MemEnabled := False;
  Cnt.Close;
  M1.Lines.Clear;
  M2.Lines.Clear;
  Cnt.APD.DeleteAllChannels;
  if FormChannel.ChannelList.Items.Count = 0 then
   begin
    ShowMessage('Не определено ни одного канала');
    exit;
   end;
  for i := 0 to FormChannel.ChannelList.Items.Count-1 do
   begin
    S := FormChannel.ChannelList.Items.Strings[i];
    if FormChannel.CheckChannel(S) = 'COM' then
     begin
      S := S + ',';
      NumCom := DCGetElement(S,1);
      Speed := StrToInt(DCGetElement(S,2));
      Cnt.AddChannel(NumCom,Speed);
     // Cnt.FIPAddr;
     end
    else
     begin
      Cnt.AddChannel(S,9600);
     end;
   end;
    Cnt.APD.SelectChannel(1);
   // Cnt.SetSpeedCntr(1,StrToInt(BoxSpeed.Text));
    Cnt.InitCntr := True;
 //   Cnt.APD.Channel[0].Open := True;
    Cnt.SetOKfactor(0);
    Cnt.SetTimeout(1,FTimeOut);

 // end;

  InVisible;
  InVisibleC;
  BStart.Visible := False;
  NumCntr := 0;
  BoxCntr.Items.Clear;
  BoxCntr.Text := '';

  Ind.Position := 0;
  Ind.Visible := True;

  FSt := True;
  ListCntr := '';
  NAddr := StrToInt(DSec(FOption.EN.Text));
  KAddr := StrToInt(DSec(FOption.EK.Text));
  if (NAddr > KAddr) or (NAddr<1) or (NAddr>254) or (KAddr<1) or (KAddr>254) then
   begin
    ShowMessage('Ошибка в задании границ поиска');
    exit;
   end;
// DCDelay(1000);
 BS.Visible := False;
 BE.Visible := True;
 for j := 1 to Cnt.APD.Channels do
 begin
  Cnt.APD.SelectChannel(j);
 // if not Cnt.APD.ChannelOpen(j) then continue;
  WiewString('Поиск контроллеров на канале '+Cnt.APD.ChannelName);
  Ind.Position := 0;
  FOR i := NAddr TO KAddr DO
   BEGIN
    if GlobalExit then
     begin
      GlobalExit := False;
      BE.Visible := False;
      BS.Visible := True;
      Ind.Position := 0;
      Ind.Visible := False;

      if NumCntr = 0 then begin
       WiewString('Контроллеров нет');
       exit;
      end;
      if NumCntr > 0 then
      begin
       NC := Cnt.SetCntrList(ListCntr);    // (ListCntr);

       for k := 1 to NumCntr do
        begin
         if true //(CntsTyp[i] = WA48) or (CntsTyp[i] = C207) or (CntsTyp[i] = SZ35v20)
         then
          begin
           if not FReg.ChComplex.Checked then Cnt.SetComplexON(CntAddresses[k])
           else Cnt.SetComplexOFF(CntAddresses[k]);
          end;
        end;
       BL.Visible := True;
       VisiblC;
       BoxCntr.Visible := True;
       LCntr.Visible := True;
       WiewString('Поиск окончен, контроллеров '+IntToStr(NC)+' - '+ListCntr);
       exit;
     end;
    end; 
    S := Cnt.AskCntr(i);
    Ind.Position := ((i-NAddr)*100) div (KAddr-NAddr);
    if (s <> '') {and (Length(s) = 5) } then begin
     WiewString('Нашли контроллер типа '+Copy(S,1,4)+' '+
             StrInHex(Copy(S,5,1),False)+' с адресом '+IntToStr(i)+' ('+
             StrInHex(Chr(i),False)+' h), канал '+IntToStr(j)+' = '+Cnt.APD.ChannelName);
     NumCntr := NumCntr + 1;
     BoxCntr.Items.Add(IntToStr(i));
     CntsTyp[NumCntr] := Ord(S[5]);
     CntAddresses[NumCntr] := i;
     if Fst then begin
      Fst := False;
      ListCntr := IntToStr(i)+':'+IntToStr(j);
     end
     else
      ListCntr := ListCntr + ','+IntToStr(i)+':'+IntToStr(j);
    end;
    if Length(S)=1 then begin
     WiewString('Нашли что-то типа '+
             StrInHex(S,False)+' с адресом '+IntToStr(i)+' ('+
             StrInHex(Chr(i),False)+' h)');
    end;
   end;

  end;
   Ind.Position := 0;
   Ind.Visible := False;

   if NumCntr = 0 then begin
     WiewString('Контроллеров нет');
     GlobalExit := False;
      BE.Visible := False;
      BS.Visible := True;
      Ind.Position := 0;
      Ind.Visible := False;
     exit;
    end;
   if NumCntr > 0 then
    begin
     NC := Cnt.SetCntrList(ListCntr);    // (ListCntr);

     for i := 1 to NumCntr do
      begin 
       if true //(CntsTyp[i] = WA48) or (CntsTyp[i] = C207) or (CntsTyp[i] = SZ35v20)
       then
        begin
         if not FReg.ChComplex.Checked then Cnt.SetComplexON(CntAddresses[i])
          else Cnt.SetComplexOFF(CntAddresses[i]);
        end;
      end;
     BL.Visible := True;
     VisiblC;
     BoxCntr.Visible := True;
     LCntr.Visible := True;
     WiewString('Поиск окончен, контроллеров '+IntToStr(NC)+' - '+ListCntr);
     BS.Visible := True;
     BE.Visible := False;
    for i := 1 to GlobalOpt.GNumCntr do
     begin
      Cnt.CntrOFF(Ord(CntrOpt[i].FAddrCntr));
     end;
    end;
   if FOption.CheckTimer.Checked then
    begin
     try
     AppDir := ExtractFilePath(Application.ExeName);
     Timer2.Interval := StrToInt(FOption.ERecTimer.Text)*1000*60;
     Timer2.Enabled := True;
     if not FileExists(AppDir+'SYSLOG.TXT') then begin
      AssignFile(LogFile,AppDir+'SYSLOG.TXT');
      Rewrite(LogFile);
      CloseFile(LogFile);
     end;
     except
     ShowMessage('Неверное значение интервала');
     exit;
     end;
     for i := 1 to NC do
      begin
       NAddr := Ord(CntrOpt[i].FAddrCntr);
       Cnt.SetClock(NAddr,Time);
      end;
    end;
end;

procedure TForm1.BStartClick(Sender: TObject);
begin

  if (BStart.Caption = 'В комплекс') and Vklucheno then
   begin
    Traffic := 0;
    Timer4.Enabled := True;
    Timer5.Enabled := True;
    Timer5.Interval := FDisc * 60000;
    IntTimer.Visible := False;
    Timer3.Enabled := True;
    Cnt.SetTimeout(1,FTimeOut);
    Cnt.StartCntr := True;
    Ind.Visible := True;
    InVisible;
    BS.Visible := False;
    Timer1.Enabled := True;
    if Cnt.StartCntr then BStart.Caption := 'В автоном';
   end
  else
   begin  
    if Cnt.StartCntr then begin Cnt.StartCntr := False;  end;
    Timer4.Enabled := False;
    Timer5.Enabled := False;
    Timer5.Interval := FDisc * 60000;
    Timer3.Enabled := False;
    VisiblC;
    Ind.Visible := False;
    BS.Visible := True;
    BoxCntr.Visible := True;
    LCntr.Visible := True;
    Timer1.Enabled := False;
    if BoxCntr.Text <> '' then Visibl;
    BStart.Caption := 'В комплекс';
   end;
 // Cnt.SetComplexON(25);
end;

procedure TForm1.BOptionClick(Sender: TObject);
var
 S : string;
begin
  FOption.ShowModal;
end;

procedure TForm1.BRClick(Sender: TObject);
var
  i : word;
begin
  FRelay.ShowModal;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Speed : word;          
  i : integer;
  Col : TColor;
begin
 try
  if BoxCntr.Text <> '' then begin
  i := CntrOpt[DPGetIndexCntr(StrToInt(BoxCntr.Text))].FVersProg;
  if (BoxCntr.Text <> '') and ((i = SZ35SKD)or(i = SZ35v20)) then begin
   Cnt.GetDATAPrior(StrToInt(BoxCntr.Text),True);
   Cnt.GetDATAPrior(StrToInt(BoxCntr.Text),False);
   if not Cnt.GetDataStatus(StrToInt(BoxCntr.Text),1) then PS1.Color := clLime else PS1.Color := clRed;
   if not Cnt.GetDataStatus(StrToInt(BoxCntr.Text),2) then PS2.Color := clLime else PS2.Color := clRed;
   if not Cnt.GetDataStatus(StrToInt(BoxCntr.Text),3) then PS3.Color := clLime else PS3.Color := clRed;
   if not Cnt.GetDataStatus(StrToInt(BoxCntr.Text),4) then PS4.Color := clLime else PS4.Color := clRed;
   if not Cnt.GetDataStatus(StrToInt(BoxCntr.Text),5) then PS5.Color := clLime else PS5.Color := clRed;
   if not Cnt.GetDataStatus(StrToInt(BoxCntr.Text),6) then PS6.Color := clLime else PS6.Color := clRed;
   if not Cnt.GetDataStatus(StrToInt(BoxCntr.Text),7) then PS7.Color := clLime else PS7.Color := clRed;
   if not Cnt.GetDataStatus(StrToInt(BoxCntr.Text),8) then PS8.Color := clLime else PS8.Color := clRed;
  end;
  end; 
 except

 end;
  Speed := Cnt.GetSpeed;
  Traffic := Traffic + Speed;
  Label1.Caption := IntToStr(Speed)+' '+IntToStr(Ind.Position);
  Ind.UserValue := Speed;
end;

procedure TForm1.BReadClick(Sender: TObject);
var
 S : string;
 i : word;
begin
 FMem.ShowModal;
end;

procedure TForm1.BoxCntrChange(Sender: TObject);
var
  S, S1, RS : string;
  Addr, Idx, i, ib : word;
  Amem : integer;
  SByte : byte;
  NumKeys : word;
  TD : TDateTime;
 // gInfo : TCont;
begin
  try
   Addr := StrToInt(BoxCntr.Text);
   ACont := Addr;
   Visibl;
   Cnt.Refresh(Addr);
   S   := Cnt.GetCntrInfo(Addr);
   Idx := DPGetIndexCntr(Addr);
  WITH CntrOpt[Idx] DO BEGIN
   if (FVersProg = SZ35SKD) or (FVersProg = SZ35v20) then
    begin
     BStack.Visible := False;
     IntTimer.Visible := False;
     BControlmem.Caption := 'Установки по умолчанию';
     CntrType := 'SZ35';
     BSetDate.Visible := False;
     BSetClock.Visible := True;
     M2.Lines.Clear;
//     showmessage(FormChannel.ChannelList.Items.Strings[FChannel-1]);
     //     GlobalOpt.GNumPort;   FChannel
//     M2.Lines.Add(S);
     M2.Lines.Add('Адрес контроллера  '+IntToStr(Addr)+
     '           Тип контроллера '+DCGetElement(S,1));
     M2.Lines.Add('Порт '+FormChannel.ChannelList.Items.Strings[FChannel-1]);
     M2.Lines.Add('Нач. адрес ключей  '+IntToStr(FKeyAddr)+
     '        Количество страниц в базе ключей '+IntToStr(FKeyPage));
     M2.Lines.Add('Нач. адрес событий '+IntToStr(FEventAddr)+
     '        Емкость стека событий '+IntToStr(FEventNum));
     RS := '';
     if Cnt.KeyLoad(Addr) then
      begin
       NumKeys := 0;
       for i := 1 to FKeyPage do
        begin
         S := DPReadBlock8(Cnt.APD,Chr(Addr),FKeyAddr+(256*(i-1)));
         if Copy(S,1,6) = 'DALLAS' then
          begin
           NumKeys := NumKeys + Ord(S[8]);
          end
         else break; 
        end;
       RS := 'Загружено '+IntToStr(NumKeys)+' ключей СКД  ';
      end
     else  RS := 'Ключи СКД не загружены ';
     S := DPReadBlock8(Cnt.APD,Chr(Addr),FKeyAddr);
     if Copy(S,1,5) = 'ALARM' then
      begin
        RS := 'Загружено '+IntToStr(Ord(S[8]))+' охранных ключей '
      end;
     Amem := FKeyAddr+(FKeyPage-1)*256+240;
     S := DPReadBlock8(Cnt.APD,Chr(Addr),AMem)+DPReadBlock8(Cnt.APD,Chr(Addr),AMem+8);
     if Copy(S,9,6) = 'KEYPAD' then
      begin
       RS := RS + '         Кодонаборники на портах ';
       for i := 1 to 8 do
        begin
         if S[i] <> #$00 then RS := RS + IntToStr(i) + ' ';
        end;
      end;
     if RS <> '' then M2.Lines.Add(RS);
     if Cnt.ControlMemEnabled(Addr) then begin
        M2.Lines.Add('Доступ к установкам разрешен'); MemEnabled := True; end
       else begin
        M2.Lines.Add('Доступ к установкам запрещен'); MemEnabled := False; end;
     if MemEnabled then BControlmem.Visible := True else BControlmem.Visible := False;

     BSetDate.Visible := False;
     BSetClock.Visible := True;
    end;

  //****************************************************************************
  // КОНТРОЛЛЕРЫ ТИПА  WA-48

    if FVersProg = WA48 then
     begin
      TD := Cnt.GetDateTime(Addr);
      BStack.Visible := False;
      IntTimer.Visible := True;
      MemEnabled := False;
      BControlmem.Visible := False;
      BSetDate.Visible := True;
      BSetClock.Visible := True;
      CntrType := 'WA48';
      M2.Lines.Clear;
      M2.Lines.Add('Адрес контроллера  '+IntToStr(Addr)+
     '           Тип контроллера '+DCGetElement(S,1));

      M2.Lines.Add('Порт '+FormChannel.ChannelList.Items.Strings[FChannel-1]);
      S := DPReadBlock8(Cnt.APD,Chr(Addr),FKeyAddr);

      M2.Lines.Add('Нач. блок ключей '+IntToStr(FKeyAddr)+
     '         Количество блоков в базе ключей '+IntToStr(FKeyPage));
     M2.Lines.Add('Дата контроллера  - '+DateToStr(TD));
      M2.Lines.Add('Время контроллера - '+TimeToStr(Time));
     if Cnt.KeyLoad(Addr) then  M2.Lines.Add('Загружены ключи СКД    ')
                         else  M2.Lines.Add('Ключи СКД не загружены ');
     S :=  FCon207.ReadKeyPad;
      if (Copy(S,1,2) = '43') and (Copy(S,3,2) <> '00') then
       begin
        S1 := '';
        for i := 1 to 2 do
         begin
          if Copy(S,(i-1)*2 + 5,2) <> '00' then
           begin
            if S1 = '' then S1 := IntToStr(i) else S1 := S1+','+IntToStr(i);
           end;
         end;
        M2.Lines.Add('Кодонаборники на портах '+S1);
       end
      else
       begin
         M2.Lines.Add('Кодонаборников нет');
       end;                    
  {   WiewString('Размер буфера загрузки WA48  '+IntToStr(FWriteBuffer));
     WiewString('Размер буфера выгрузки WA48   '+IntToStr(FReadBuffer));
     WiewString('Начальный блок НБК  '+IntToStr(FAdrNBK));
     WiewString('Размер НБК в блоках  '+IntToStr(FNBKSize));
     WiewString('Начальный блок расписания  '+IntToStr(FBlockRasp));
     WiewString('Размер расписания в блоках  '+IntToStr(FRaspSize));
     WiewString('Количество ключей на странице(блоке)  '+IntToStr(FKeyOnPage));
     WiewString('Тип микросхемы памяти  WA48  '+IntToStr(FTypeStorage));
     WiewString('Размер блока памяти    WA48  '+IntToStr(FBlockSize));
     WiewString('Общий размер памяти  '+IntToStr(FStorageSize));
     WiewString('Длина записи о событии WA48  '+IntToStr(FEventLength));  }
        
     end;

    if FVersProg = HBIT then
     begin
      BStack.Visible := False;
      BSetDate.Visible := False;
      BSetClock.Visible := False;
      MemEnabled := False;
      BControlMem.Caption := 'Настройка репитера';
      BControlmem.Visible := True;
      CntrType := 'HBIT';
      M2.Lines.Clear;
      M2.Lines.Add('Адрес контроллера  '+IntToStr(Addr)+
     '           Тип контроллера HBIT');
      SByte := DPReadRPD(Cnt.APD,Chr(Addr),#$21);
      S := DPReadBlock8(Cnt.APD,Chr(Addr),$20);
      S := S+DPReadBlock8(Cnt.APD,Chr(Addr),$28);
      S := S+DPReadBlock8(Cnt.APD,Chr(Addr),$30);
      S := S+DPReadBlock8(Cnt.APD,Chr(Addr),$38);
      S1 := '';
      for i := 1 to 32 do
       begin
        SByte := Ord(S[i]);
        for ib := 1 to 8 do
         begin
          if (SByte and $01) = 0 then S1 := S1 + ' '+IntToStr((i-1)*8+ib-1);
          SByte := SByte shr 1;
         end;
       end;
      M2.Lines.Add('На ведомом канале контроллеры '+S1);
     end;

     if FVersProg = HABA then
     begin
      BStack.Visible := False;
      BSetDate.Visible := False;
      BSetClock.Visible := False;
      MemEnabled := False;
      BControlMem.Caption := 'Настройка H422';
      BControlmem.Visible := True;
      CntrType := 'HABA';
      M2.Lines.Clear;
      M2.Lines.Add('Адрес контроллера  '+IntToStr(Addr)+
     '           Тип контроллера '+DCGetElement(S,1));

     end;
     if FVersProg = CREL then
     begin
      BStack.Visible := False;

     end;
     if FVersProg = C207 then
     begin
      BStack.Visible := True;
      M2.Lines.Clear;
      CntrType := 'C207';
      BControlmem.Caption := 'Стереть события';
      BControlmem.Visible := True;
      BSetDate.Visible := True;
      BSetClock.Visible := True;
    //  gInfo := TCont.Create;
      gInfo := FCon207.ContInfo; //  Check(StrToInt(BoxCntr.Text));
      M2.Lines.Add('Начальный адрес ключей - '+IntToStr(FAdrNBK));
      M2.Lines.Add('Серийный номер - '+FStrNum+'  Версия - '+
             'V '+IntToStr(gInfo.VersProg)+'.'+IntToStr(gInfo.SubVers));
      M2.Lines.Add('Порт '+FormChannel.ChannelList.Items.Strings[FChannel-1]);
      M2.Lines.Add('Ключей - '+IntToStr(FNumLoadKey));
      M2.Lines.Add('Событий - '+IntToStr(FEventReady));
      TD := Cnt.GetDateTime(Addr);
      M2.Lines.Add('Дата и время контроллера  - '+DateToStr(TD)+'  '+TimeToStr(TD));
      S :=  FCon207.ReadKeyPad;
      if (Copy(S,1,2) = '43') and (Copy(S,3,2) <> '00') then
       begin
        S1 := '';
        for i := 1 to 8 do
         begin
          if Copy(S,(i-1)*2 + 5,2) <> '00' then
           begin
            if S1 = '' then S1 := IntToStr(i) else S1 := S1+','+IntToStr(i);
           end;
         end;
        M2.Lines.Add('Кодонаборники на портах '+S1);
       end
      else
       begin
         M2.Lines.Add('Кодонаборников нет');
       end;
  //    gInfo.Free;
     end;
  RS := '';
  if CntrOpt[DPGetIndexCntr(Addr)].FClose then
        RS := 'Поддерживаются события CLOSE';
  if CntrOpt[DPGetIndexCntr(Addr)].FAvtonom then
   begin
    if RS = '' then
     RS := 'Поддерживается чтение событий в автономе'
    else RS := RS + ' и чтение событий в автономе' 
   end;
  if RS <> '' then M2.Lines.Add(RS); 
  END;
  except
    on E : Exception do begin
      showmessage('Фатальная ошибка: '+E.Message);
    end;

  end;
end;

procedure Visibl;
begin
 with Form1 do
  begin
    BoxCntr.Visible := True;
    BL.Visible := True;
    BC.Visible := True;
    BR.Visible := True;
    BRead.Visible := True;
 //   BA.Visible := True;
    Lcntr.Visible := True;
    BControlMem.Visible := MemEnabled;
  end;
end;

procedure VisiblC;
var
 i : word;
 CB : TSpeedButton;
begin
 with Form1 do
  begin
   BStart.Visible := True;
   for i := 1 to GlobalOpt.GNumCntr do
    begin
     CB := FindComponent('C'+IntToStr(i)) as TSpeedButton;
     CB.Caption := IntToStr(Ord(CntrOpt[i].FAddrCntr));
     CB.Visible := True;
    // Cnt.CntrOFF(Ord(CntrOpt[i].FAddrCntr));
    end;
  end;
end;

procedure InVisibleC;
var
 i : word;
 CB : TSpeedButton;
begin
 with Form1 do
  begin
   for i := 1 to 22 do
    begin
     CB := FindComponent('C'+IntToStr(i)) as TSpeedButton;
     CB.Visible := False;
    end;
  end;
end;

procedure InVisible;
var
  i : word;
begin
 with Form1 do
  begin
   // for i := 1 to 22 do
   //  begin
   //   (FindComponent('C'+IntToStr(i)) as TSpeedButton).Visible := False;
   //  end;
    BoxCntr.Visible := False;
    BL.Visible := False;
    BC.Visible := False;
    BR.Visible := False;
    BRead.Visible := False;
  //  BA.Visible := False;
    Lcntr.Visible := False;
    BControlmem.Visible := False;
  end;
end;

function Vklucheno : bool;
var
 i : word;
 CB : TSpeedButton;
begin
 with Form1 do
  begin
   Result := False;
   for i := 1 to 22 do
    begin
     CB := FindComponent('C'+IntToStr(i)) as TSpeedButton;
     if CB.Visible and CB.Down then result := True;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 try
  GlobalExit := False;
  Cnt := TSocketController.Create(Self);
  Cnt.APD.OnDebug := Debug;
//  Cnt.OnAnswer := CntAnswerCntr;
  Cnt.OnEventCntr := CntEventCntr;
  Cnt.OnErrorCntr := CntErrorCntr;
  Cnt.OnProgCntr := CntProgCntr;
  Cnt.APD.OnWsDisconnect := CntDisconnect;
//  Application.HelpFile := ExtractFilePath(Application.ExeName)+'HELP\NewTest.hlp';
//  Form1.Caption := Form1.Caption + '     '
//       +FormatDateTime('d.mm.yyyy',FileDateToDatetime(FileAge(Application.ExeName)));
  ACont := 0;
  Form1.Left := 0;
  Form1.Top  := 0;
  gInfo := TCont.Create;
//  Memo1.Lines:=FormChannel.ChannelList.Items;
 except
  ShowMessage('TForm1.FormCreate');
 end;
end;

procedure TForm1.C1Click(Sender: TObject);
var
  i : word;
  CB : TSpeedButton;
begin

  CB := Sender as TSpeedButton;
 // if CB.Down then CB.Down := False else CB.Down := True;
  if CB.Down then begin
    Cnt.CntrON(StrToInt(CB.Caption));
   // if DCGetElement(Cnt.GetCntrInfo(StrToInt(CB.Caption)),1) = 'WA48' then
                   Cnt.SetComplexON(StrToInt(CB.Caption));
    try
    GlobalOpt.GERROR := StrToInt(FOption.EErrCnt.Text);
    except
     FOption.EErrCnt.Text := '10';
     GlobalOpt.GERROR := 10;
    end;
   end;
  if not CB.Down then Cnt.CntrOFF(StrToInt(CB.Caption));
  if not Vklucheno then
   begin
    if Cnt.StartCntr then Cnt.StopCntr;
    Ind.Visible := False;
    BStart.Caption := 'В комплекс';
    WiewString('Все контроллеры переведены в автоном');
    Timer1.Enabled := False;
    BS.Visible := True;
    LCntr.Visible := True;
    BoxCntr.Visible := True;
    if BoxCntr.Text <> '' then Visibl;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.HelpCommand(Help_Contents,0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  M1.Lines.Clear;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
  Cnt.StartCntr := False;
  DCDelay(30);
end;

procedure TForm1.BNumEventClick(Sender: TObject);
begin
 WiewString(IntToStr(Cnt.GetNumEvent(StrToInt(BoxCntr.Text)))); 
end;



procedure TForm1.BControlMemClick(Sender: TObject);
begin
  if BcontrolMem.Caption = 'Установки по умолчанию' then
   begin
    FCmem.ShowModal;
    exit;
   end;
  if BcontrolMem.Caption = 'Настройка репитера' then
   begin
    FRep.ShowModal;
    exit;
   end;
  if BcontrolMem.Caption = 'Дополнительно' then
   begin

   end;
  if BcontrolMem.Caption = 'Стереть события' then
   begin
    FCon207.AddrCont := Chr(ACont);
    FCon207.Check(ACont);
    FCon207.ClearEvent;
   end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  TContr, TComp : TDateTime;
  i : word;
  S : string;
begin
 if FOption.CheckTimer.Checked then
  begin
  M1.Lines.Clear;
  AssignFile(LogFile,ExtractFilePath(Application.ExeName)+'SYSLOG.TXT');
  Append(LogFile);
  for i := 1 to GlobalOpt.GNumCntr do
   begin
    TComp := Time;
    TContr := Cnt.GetClock(Ord(CntrOpt[i].FAddrCntr));
    S := TimeToStr(TComp)+' '+TimeToStr(TContr)+' '+'Расхождение часов контроллера '+
        IntToStr(Ord(CntrOpt[i].FAddrCntr))+' - '+ TimeToStr(TComp-TContr);
    WiewString(S);
       WriteLn(LogFile,S);
    Flush(LogFile);
   end;
   WriteLn(LogFile,'--------------------------------------------------------');
   Flush(LogFile);
   CloseFile(LogFile);
  end;
end;

procedure TForm1.BSetClockClick(Sender: TObject);
begin
 try
  Cnt.SetClock(StrToInt(BoxCntr.Text),Time);
 except
  ShowMessage('Не выбран контроллер');
 end;
end;

procedure TForm1.BSetDateClick(Sender: TObject);
begin
 try
  Cnt.SetDate(StrToInt(BoxCntr.Text),Date);
 except
  ShowMessage('Не выбран контроллер');
 end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var
 i : integer;
begin
exit;
 try
  i := Cnt.WriteKeyA(StrToInt(BoxCntr.Text),3080,'000000000000','1,2');
  WiewString(IntToStr(i));
  if i<0 then Timer3.Enabled := False;
 except
 end;
end;

procedure TForm1.IntTimerClick(Sender: TObject);
begin
  if IntTimer.Checked then
   begin
    Cnt.APD.PutString(#$16+#$6D+Chr(StrToInt(BoxCntr.Text))+#$01);
   end
  else
   begin
    Cnt.APD.PutString(#$16+#$6D+Chr(StrToInt(BoxCntr.Text))+#$00);
   end;
end;

procedure TForm1.BStackClick(Sender: TObject);
var
  S : string;
  i,Len : word;
  Stack : integer;
  Events : integer;
begin
  S := '00';
  
  Cnt.APD.PutString(#$16+#$6C+Chr(StrToInt(BoxCntr.Text))+#$01);
  DCDelay(50);
  S[1] := Cnt.APD.GetChar;
  S[2] := Cnt.APD.GetChar;
  Len := Ord(S[2]);
  for i := 1 to len do S := S + Cnt.APD.GetChar;
WiewString('Из порта - '+StrInHex(S,True));
  if Ord(S[3]) = $02 then
   begin
    Stack  := Ord(S[5])*256 + Ord(S[4]);
    Events := Ord(S[7])*256 + Ord(S[6]);
   end;
  if Ord(S[3]) = $03 then
   begin
    Stack  := Ord(S[6])*65536 + Ord(S[5])*256 + Ord(S[4]);
    Events := Ord(S[9])*65536 + Ord(S[8])*256 + Ord(S[7]);
   end;
//  WiewString(StrInHex(S,True));
  WiewString('Емкость стека       - '+IntToStr(Stack*16)+' байт ('+
       IntToStr(Stack)+' событий)');
  WiewString('Накопленных событий - '+IntToStr(Events)+
       ', занято событиями '+IntToStr(Events*16)+' байт ('
       +IntToStr(((Events*16)*100) div (Stack*16))+
       ' %).');
end;


procedure TForm1.BSendClick(Sender: TObject);
var
 S : string;
 AddrC : word;
 i,k : integer;
begin
  if not Cnt.InitCntr then
   begin
 //   Cnt.FSpeedCntr := StrToInt(BoxSpeed.Text);
  //  Cnt.FPortCntr  := StrToInt(BoxPort.Text);
    Cnt.InitCntr := True;
   end;
  if Pos(',',ESend.Text) <> 0 then
   begin
    Cnt.APD.SelectChannel(StrToInt(Copy(ESend.Text,1,Pos(',',ESend.Text)-1)));
    AddrC := StrToInt(DCGetElement(ESend.Text+',',2));
   end
   else AddrC := StrToInt(ESend.Text);
  repeat
   Cnt.APD.PutString(#$16+#$2B+Chr(AddrC));
   while Cnt.APD.OutBuffUsed > 0 do Application.ProcessMessages;
   while Cnt.APD.InBuffUsed < 3 do Application.ProcessMessages;
   S := '';
   while Cnt.APD.InBuffUsed > 0 do S := S+Cnt.APD.GetChar;
   if S <> Chr(AddrC)+#$00+Chr(AddrC) then
     begin
      while Cnt.APD.InBuffUsed < 14 do Application.ProcessMessages;
       while Cnt.APD.InBuffUsed > 0 do S := S+Cnt.APD.GetChar;
     end;
   WiewString(StrInHex(S,True)+'    '+Cnt.APD.ChannelName);
  until not CSend.Checked;   
end;
// записать ключ на контроллер типа 207
procedure TForm1.AskCOMClick(Sender: TObject);
var
 S : string;
 i : word;
begin
  try
    S := Cnt.AskCntr(StrToInt(BoxCntr.Text));
    if S <> '' then M1.Lines.Add('Нашли '+Copy(S,1,4)+' '+StrInHex(Copy(S,5,1),True));
  except
    ShowMessage('Не выбран или неправилен адрес контроллера');
  end;
end;

procedure TForm1.BRejimClick(Sender: TObject);
var
 i : integer;
begin
 { try
   i := StrToInt(BoxCntr.Text);
  except
   ShowMessage('Необходимо выбрать контроллер');
   exit;
  end;                                            }
  FReg.Show;
end;

procedure TForm1.AcceleratorTimer(Sender: TObject);
begin
  // if (Cnt.APD.DeviceLayer = dlWinSock) and (CNT.APD.Open) then Cnt.APD.PutString(' ');
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 try
  GlobalExit := True;
  Accelerator.Enabled := False;          
  Cnt.APD.Open := False;
  DCDelay(200);
  CanClose := True;
 except
  CanClose := True;
 end;
end;

 procedure TForm1.Debug(Sender:TObject;Msg : string);
 begin
  WiewString('DEBUG '+Msg);
 end;

procedure TForm1.BSetChannelClick(Sender: TObject);
begin
  FormChannel.ShowModal;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
 i : word;
 Key, S : string;
 Addr : word;
begin
 try
 if ECommand.Text = '' then exit;
 Key := '';
 for i := 1 to Length(ECommand.Text) div 2 do
  begin
   S := Copy(ECommand.Text,(i-1)*2+1,2);
   Key := Key + DPHexInChar(S);
  end;
 WiewString('SEND    - '+StrInHex(Key,True));
 Cnt.APD.PutString(Key);
 while Cnt.APD.OutBuffUsed > 0 do Application.ProcessMessages;
 DCDelay(200);
 S := '';
 while Cnt.APD.InBuffUsed > 0 do S := S + Cnt.APD.GetChar;
 WiewString('RECEIVE - '+StrInHex(S,True));
 except
 end;
end;

procedure TForm1.CAvtClick(Sender: TObject);
var
 i : word;
begin
  if CAvt.Checked then
   begin
    for i := 1 to GlobalOpt.GNumCntr do Cnt.SetComplexOFF(Ord(CntrOpt[i].FAddrCntr));
   end
  else
   begin
    for i := 1 to GlobalOpt.GNumCntr do Cnt.SetComplexON(Ord(CntrOpt[i].FAddrCntr));
   end;
end;

procedure TForm1.Timer5Timer(Sender: TObject);
begin
   if Cnt.StartCntr then
    begin
     Cnt.StartCntr := False;
     WiewString('Отсоединение от сетки');
     DCDelay(200);
     Cnt.APD.Open := False;
     DCDelay(1000);
     WiewString('Присоединение к сетке');
     Cnt.APD.Open := True;
     GlobalOpt.GPortBusy := False;
     Cnt.StartCntr := True;
    end;
end;

procedure TForm1.RecLog(S : string);
begin
    WiewString(S);
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
 { if M1.Lines.Count > 3000 then M1.Lines.Clear;
  WiewString('Обменов - '+IntToStr(Traffic));
  Traffic := 0;         }
end;

procedure TForm1.RRaspClick(Sender: TObject);
var
  Ras : TStringList;
begin
  Ras := TStringList.Create;
  try
   M1.Lines.Add(BoxCntr.Text);
   Ras := Cnt.RaspRead(StrToInt(BoxCntr.Text),1);
   M1.Lines.Clear;
   M1.Lines.AddStrings(Ras);
   Ras.Free;
  except
   M1.Lines.Add('Не выбран контроллер');
   Ras.Free;
  end; 
end;

{
procedure TForm1.AskIPClick(Sender: TObject);
var
S : string;
begin
 try
  S := '';
  S := Cnt.AskCntrIP(StrToInt(BoxCntr.Text),StrToInt(FOption.Edit1.Text));
  if S <> '' then M1.Lines.Add('Нашли '+Copy(S,1,4)+' '+StrInHex(Copy(S,5,1),True));
  except
    ShowMessage('Не выбран или неправилен адрес контроллера');
  end;
end;            }

procedure TForm1.BEClick(Sender: TObject);
begin
  GlobalExit := True;
end;

procedure TForm1.CntAnswerCntr(Sender : TObject; AddrCntr : string);
begin
 // M1.Lines.Add(AddrCntr);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    try
       Cnt.WriteKeyA(StrToInt(BoxCntr.Text),32768,'000001525FDC','11111111');
    except
       ShowMessage('Выбери контроллер');
    end;
end;

procedure TForm1.Timer6Timer(Sender: TObject);
begin
 try
    Timer6.Enabled := False;
    Cnt.WriteKeyA(StrToInt(BoxCntr.Text),32768,'000001525FDC','11111111');
 finally
    Timer6.Enabled := False;
 end;   
end;

procedure TForm1.CTraceClick(Sender: TObject);
begin
   if CTrace.Checked then FCon207.Trace := True else FCon207.Trace := False;
end;

end.


