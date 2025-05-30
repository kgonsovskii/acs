unit UKey;
  
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,SIntProc2,  SIntProc1, SDataMod, Grids, ComCtrls, Db, DBTables,
  Halcn6DB,gs6_shel;

type
  TFKey = class(TForm)
   // FOnCntEvent : TNotifyEvent;
    BStart: TButton;
    Button2: TButton;
    Label1: TLabel;
    BRead: TButton;
    BClear: TButton;
    Button1: TButton;
    BLoad: TButton;
    BKeyClear: TButton;
    SB2: TStatusBar;
    StaticText1: TStaticText;
    CoCntr: TComboBox;
    SG: TStringGrid;
    BFicLoad: TButton;
    BInt: TButton;
    ListKeys: TListBox;
    CEv207: TButton;
    Button3: TButton;
    OD: TOpenDialog;
    M9: TMemo;
    Button4: TButton;
    Pers: THalcyonDataSet;
    Button5: TButton;
    SD: TSaveDialog;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    MCount: TMemo;
    Button9: TButton;
    procedure BReadClick(Sender: TObject);
    procedure BStartClick(Sender: TObject);
    procedure CntEvent(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BClearClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BLoadClick(Sender: TObject);
    procedure BKeyClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CoCntrChange(Sender: TObject);
    procedure BFicLoadClick(Sender: TObject);
    procedure BIntClick(Sender: TObject);
    procedure CEv207Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FOnCntEvent : TNotifyEvent;
  published
    property  OnCntEvent : TNotifyEvent read FOnCntEvent write FOnCntEvent;
  end;

  procedure WKeyOnBase(S : string; Addr : word);

var
  FKey  : TFKey;
  NKey  : word;
  FL    : boolean;

  Cntr1  :  string;
  Keys1  :  string;
  Ports1 :  string;

  Adres : word;
implementation
uses UNTest;

{$R *.DFM}

procedure TFKey.CntEvent;
begin
 //if Assigned(FOnCntEvent) then FOnCntEvent(Self);
 //MK.Lines.Add(Cnt.GetEvent);
end;

procedure TFKey.BReadClick(Sender: TObject);
var
  S : string;
  S1 : string;
  ACntr : word;
  AMem, AllKeys  : integer;
  NStr  : word;
  NPage, NKey : word;
  iP, iK: word;
  idx : word;
  nc, ic : word;
  Kc : integer;
//******************************************************************
//  ЧТЕНИЕ КЛЮЧЕЙ ИЗ КОНТРОЛЛЕРОВ
//******************************************************************
begin
 with Form1 do begin
 Kc := 0;
 FKey.Enabled := False;
 SB2.SimpleText := 'Идет чтение...   Ждите...';
 if CoCntr.Text <> 'Все сразу' then nc := 1 else nc := CoCntr.Items.Count-1;

 for ic := 1 to nc do  // ЦИКЛ ПО КОНТРОЛЛЕРАМ
  BEGIN
   if CoCntr.Text <> 'Все сразу' then ACntr := StrToInt(CoCntr.Text) else
          Acntr := StrToInt(CoCntr.Items[ic]);
//  Cnt.ReadKeys(ACntr,ListKeys.Items);
  idx := DPGetIndexCntr(ACntr);
  S := Cnt.GetCntrInfo(ACntr);
  if CntrOpt[Idx].FVersProg = C207 then
   begin
     NPage := CntrOpt[Idx].FKeyPage;
     FCon207.AddrCont := Chr(ACntr);
     AMem := CntrOpt[Idx].FKeyAddr;
     M9.Lines.Add('NPAGE = '+IntToStr(NPage));
     M9.Lines.Add('ADDR =  '+IntToStr(Amem));
     AllKeys:=0;
     for iP := 1 to NPage do
      begin
       S1 := FCon207.ReadRAM(AMem+(512*(iP-1)),8);
//       M9.Lines.Add('...iP =  '+IntToStr(iP));
//       M9.Lines.Add('...S1 =  '+S1);
//       if Copy(S1,1,6) <> 'DALLAS' then break;
       if Copy(S1,1,6) = 'DALLAS' then begin
         NKey := Ord(S1[8]);
         M9.Lines.Add('...NKey =  '+IntToStr(NKey)+' ('+IntToStr(AllKeys)+')');
         if NKey = 0 then continue;
         for iK := 1 to NKey do
          begin
           Inc(AllKeys);
//           MCount.Visible:=Not MCount.Visible;
           MCount.Lines.Clear;
           MCount.Lines.Add(IntToStr(AllKeys));
           MCount.Color:=clYellow;
           S1 := FCon207.ReadRAM(AMem+(512*(iP-1))+((iK)*8),8);
//           M9.Lines.Add('...ключ N =  '+IntToStr(AllKeys));
           WKeyOnBase(S1,ACntr);
          end;  // NKey
        end;  // DALLAS
      end; // NPage;

   end;

  if (CntrOpt[Idx].FVersProg = SZ35SKD) or (CntrOpt[Idx].FVersProg = SZ35v20) then
   begin
    NPage := CntrOpt[idx].FKeyPage;
    Amem := StrToInt(DCGetElement(S,4));
    for iP := 1 to NPage do        // ЦИКЛ ПО СТРАНИЦАМ
     begin
      S1 := DPReadBlock8(Cnt.APD,Chr(ACntr),AMem+(256*(iP-1)));
      if Copy(S1,1,6) <> 'DALLAS' then    // СИГНАТУРА
       begin
 //       MK.Lines.Add('Ключей нет');
        break;
       end;
      NKey := Ord(S1[8]);

      for iK := 1 to NKey do       // ЦИКЛ ПО КЛЮЧАМ НА СТРАНИЦЕ
       begin
        S1 := DPReadBlock8(Cnt.APD,Chr(ACntr),AMem+(256*(iP-1))+((iK)*8));
        WKeyOnBase(S1,Acntr);
        Kc := Kc + 1;
       end;  // NKey

     end; // NPage
   end;


   if CntrOpt[Idx].FVersProg = WA48 then
   begin
    NPage := CntrOpt[idx].FKeyPage;
    Amem := StrToInt(DCGetElement(S,4))*512;
     M9.Lines.Add('NPAGE = '+IntToStr(NPage));
     M9.Lines.Add('ADDR =  '+IntToStr(Amem));
    for iP := 1 to NPage do
     begin
      S1 := Cnt.ReadMemWA48(ACntr,AMem+(256*(iP-1)));
      if Copy(S1,1,6) <> 'DALLAS' then continue;
//       begin
  //      MK.Lines.Add('Ключей нет');
//        break;
//       end;
      NKey := Ord(S1[8]);
      for iK := 1 to NKey do
       begin
        S1 := Cnt.ReadMemWA48(ACntr,AMem+(256*(iP-1))+((iK)*8));
        WKeyOnBase(S1,Acntr);
        Kc := Kc + 1;
       end;  // NKey
     end; // NPage;
   end;
  END; // по контроллерам
 FKey.Enabled := True;
// SB2.SimpleText := 'Чтение ключей завершено. Всего ключей - '+IntToStr(Kc);
 SB2.SimpleText := 'Чтение ключей завершено. Всего ключей - '+IntToStr(AllKeys);
 MCount.Visible:=True;
 MCount.Color:=clLime;
 MCount.Lines.Clear;
 MCount.Lines.Add(IntToStr(AllKeys));

 end; // with
end;

procedure TFKey.BStartClick(Sender: TObject);
var
  CntrAddr : word;
  i : word;
begin
 BKeyClear.Visible := False;
 Button1.Visible := False;
 BClear.Visible  := False;
 BRead.Visible := False;
 Button2.Visible := True;
 BStart.Visible := False;
 BLoad.Visible := False;
 with Form1 do begin

 if Cnt.InitCntr then
   begin
    Cnt.OnEventCntr := Fkey.FormDestroy;
    // Включение нужных контроллеров
    if CoCntr.Text = 'Все сразу' then
     begin
      for i := 1 to CoCntr.Items.Count-1 do
       begin
        CntrAddr := StrToInt(CoCntr.Items.Strings[i]);
        Cnt.CntrON(CntrAddr);
        Cnt.SetComplexON(CntrAddr);
        if (CntrOpt[DPGetIndexCntr(CntrAddr)].FVersProg = WA48) or
           (CntrOpt[DPGetIndexCntr(CntrAddr)].FVersProg = C207)
                then Cnt.SetComplexON(CntrAddr);
        Cnt.Reset(CntrAddr);
       end;
     end
    else
     begin
      for i := 1 to CoCntr.Items.Count-1 do
       begin
        CntrAddr := StrToInt(CoCntr.Items.Strings[i]);
        Cnt.CntrOFF(CntrAddr);
       end;
      CntrAddr := StrToInt(CoCntr.Text);
      Cnt.CntrON(CntrAddr);
      Cnt.SetComplexON(CntrAddr);
      if CntrOpt[DPGetIndexCntr(CntrAddr)].FVersProg = WA48
                then Cnt.SetComplexON(CntrAddr);
      Cnt.Reset(CntrAddr);
     end;
    Cnt.StartCntr := True;
   end
   else
    ShowMessage('Не инициализированы контроллеры');

 end; // with
end;

procedure TFKey.FormDestroy(Sender: TObject);
var
 S : string;
 SKey : string;
 SCntr : word;
 SPort, i : word;
 FS : bool;
begin
 S := Cnt.GetEvent;
 if (DCGetType(S) = 'KEY') and (DCGetElement(S,1) <> 'A')  then
  begin
   SKey  := DCGetKey(S);
   SCntr := DCGetController(S);
   SPort := DCGetPort(S);
   if NKey > 0 then begin  // не первый ключ
    FS := False;
    for i := 1 to NKey do
     begin
      if (SG.Cells[2,i] = SKey) and (SG.Cells[1,i] = IntToStr(SCntr)) then begin
       FS := True;
       break;
      end;
     end;
    if FS then begin
     if Pos(IntToStr(SPort),Ports1)=0 then
              Ports1 := Ports1+IntToStr(SPort);

   //  MK.Lines.Strings[i-1] := Keys[i]+'  '+Ports[i];
     if i > SG.RowCount-1 then SG.RowCount := SG.RowCount +1;
     SG.Row := i;
     SG.Cells[0,i] := IntToStr(i);
     SG.Cells[1,i] := Cntr1;
     SG.Cells[2,i] := Keys1;
     SG.Cells[3,i] := Ports1;
    end
    else begin
     NKey := NKey + 1;
     Cntr1 := IntToStr(SCntr);
     Keys1 := SKey;
     Ports1 := IntToStr(SPort);
  //   MK.Lines.Add(Keys[NKey]+'  '+Ports[NKey]);
     if NKey > SG.RowCount-1 then SG.RowCount := SG.RowCount +1;
     SG.Row := NKey;
     SG.Cells[0,NKey] := IntToStr(NKey);
     SG.Cells[1,NKey] := Cntr1;
     SG.Cells[2,NKey] := Keys1;
     SG.Cells[3,NKey] := Ports1;
    end;

   end
   else begin // первый ключ
    NKey := NKey + 1;
    Keys1 := SKey;
    Cntr1 := IntToStr(SCntr);
    Ports1 := IntToStr(SPort);
  //  MK.Lines.Add(Keys[NKey]+'  '+Ports[NKey]);
    if NKey > SG.RowCount then SG.RowCount := SG.RowCount +1;
    SG.Row := NKey;
    SG.Cells[0,NKey] := IntToStr(NKey);
    SG.Cells[1,NKey] := Cntr1;
    SG.Cells[2,NKey] := Keys1;
    SG.Cells[3,NKey] := Ports1;
   end;
  end;
end;

procedure TFKey.Button2Click(Sender: TObject);
begin
 with Form1 do begin
  if CoCntr.Text <> 'Все сразу' then
       Cnt.SetComplexOFF(StrToInt(CoCntr.Text));
  DCDelay(20);
  Cnt.StopCntr;
  DCDelay(100);
  Cnt.OnEventCntr := Form1.CntEventCntr;

//  FKey.Close;
 end;
 BKeyClear.Visible := True;
 Button1.Visible := True;
 BClear.Visible  := True;
 BRead.Visible := True;
 Button2.Visible := False;
 BStart.Visible := True;
 BLoad.Visible := True;
end;

procedure TFKey.FormCreate(Sender: TObject);
var
I,J,K : integer;
begin
 SG.ColWidths[2] := 110;
 SG.ColWidths[1] := 50;
 SG.ColWidths[3] := 70;
 SG.Cells[0,0] := '№ п/п';
 SG.Cells[1,0] := 'Контр.';
 SG.Cells[2,0] := 'Код ключа';
 SG.Cells[3,0] := 'Порт';
 SG.Cells[4,0] := 'Сост';
 SG.Cells[5,0] := 'Фактор';
 NKey := 0;
end;

procedure TFKey.BClearClick(Sender: TObject);
var
 i : word;
begin
  NKey := 0;
 // MK.Lines.Clear;
  SG.RowCount:=2;
  SG.FixedRows:=1;

//  SG.RowCount-1 do
  for i := 1 to SG.RowCount-1 do
   begin
//    SG.RowCount := 4;
    SG.Cells[0,i] := '';
    SG.Cells[1,i] := '';
    SG.Cells[2,i] := '';
    SG.Cells[3,i] := '';
   end;
   
end;

procedure TFKey.Button1Click(Sender: TObject);
begin
  if Cnt.StartCntr then Cnt.StartCntr := False;
  FKey.Close;
end;

procedure TFKey.BLoadClick(Sender: TObject);
var
 ACntr : word;
 i     : word;
 ic    : word;
begin
 with Form1 do
  begin
   if NKey = 0 then exit;
   ACntr := Adres;
   if ACntr <> 0 then begin
    M9.Lines.Add('Загрузка ключей в контроллер '+IntToStr(Adres));
    SB2.SimpleText := 'Загрузка ключей в контроллер '+IntToStr(Adres);
    Cnt.InitKeyPage(ACntr);
    for i := 1 to NKey do begin
      if FKey.SG.Cells[1,i] = IntToStr(ACntr)
                then Cnt.PutKey(FKey.SG.Cells[2,i],FKey.SG.Cells[3,i]);
      SB2.SimpleText := 'Загрузка ключей в контроллер '+IntToStr(Adres) +'    '+ IntToStr(i);
      M9.Lines.Add('Загрузка ключей в контроллер '+IntToStr(Adres) +'    '+ IntToStr(i));
     end;
    Cnt.PostKeyPage;
   end
   else
    begin
     for ic := 1 to CoCntr.Items.Count-1 do
      begin
//MK.Lines.Add('/// '+CoCntr.Items[ic]);
       ACntr := StrToInt(CoCntr.Items[ic]);
       SB2.SimpleText := 'Загрузка ключей в контроллер '+CoCntr.Items[ic];
       Cnt.InitKeyPage(ACntr);
       for i := 1 to NKey do begin
        if FKey.SG.Cells[1,i] = IntToStr(ACntr)
                then Cnt.PutKey(FKey.SG.Cells[2,i],FKey.SG.Cells[3,i]);
        SB2.SimpleText := 'Загрузка ключей в контроллер '+IntToStr(Adres) +'    '+ IntToStr(i);
        M9.Lines.Add('Загрузка ключей в контроллер '+IntToStr(Adres) +'    '+ IntToStr(i));
       end;
       Cnt.PostKeyPage;
      end;
    end;
   SB2.SimpleText := 'Загрузка ключей окончена';
   M9.Lines.Add('Загрузка ключей окончена');
  end;
end;

procedure WKeyOnBase(S : string; Addr : word);
var
 i : word;
 Mask : byte;
 K : string;

begin
 K := DCKeyReverse(StrInHex(Copy(S,1,6),False));
 for i := 1 to NKey do
  begin
   if (FKey.SG.Cells[1,i] = IntToStr(Addr)) and (FKey.SG.Cells[2,i] = K) then exit;
   Application.ProcessMessages;
  end;
 NKey := NKey + 1;
 Cntr1 := IntToStr(Addr);
 Keys1 := K;
 Mask := Ord(S[7]);
 Ports1 := '';
 for i := 1 to 8 do
  begin
   if (Mask and $01) <> 0 then
       Ports1 := Ports1 + IntToStr(i);
   Mask := Mask shr 1;
  end;
  if NKey > FKey.SG.RowCount-1 then FKey.SG.RowCount := FKey.SG.RowCount +1;
  FKey.SG.Row := NKey;
  FKey.SG.Cells[0,NKey] := IntToStr(NKey);
  FKey.SG.Cells[1,NKey] := Cntr1;
  FKey.SG.Cells[2,NKey] := Keys1;
  FKey.SG.Cells[3,NKey] := Ports1;
  FKey.SG.Cells[4,NKey] := 'U';
  FKey.SG.Cells[5,NKey] := '0E';
//FKey.MK.Lines.Add(Keys[NKey]+' '+Ports[NKey]);
end;

procedure TFKey.BKeyClearClick(Sender: TObject);
begin
  if Adres = 0 then begin
    ShowMessage('Можно стирать ключи только одного контроллера');
    exit;
    end;
  MessageBeep($FFFFFFFF);
  if MessageDlg('ВСЕ КЛЮЧИ В КОНТРОЛЛЕРЕ '+CoCntr.Text+' БУДУТ СТЕРТЫ ! СТЕРЕТЬ?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   FKey.Enabled := False;
   Cnt.KeyClear(StrToInt(CoCntr.Text));
   SB2.SimpleText := 'Ключи контроллера '+CoCntr.Text+' стерты';
   FKey.Enabled := True;
  end;
end;

procedure TFKey.FormShow(Sender: TObject);
var
  i : word;
begin
  with Form1 do
   begin
    if BoxCntr.Items.Count <> 0 then
     CoCntr.Items.Clear;
     CoCntr.Items.Add('Все сразу');
     begin
      for i := 0 to BoxCntr.Items.Count-1 do
         CoCntr.Items.Add(BoxCntr.Items[i]);
      if CoCntr.Text <> 'Все сразу' then Adres := StrToInt(CoCntr.Text)
         else Adres := 0;
     end;
   end;
end;

procedure TFKey.CoCntrChange(Sender: TObject);
begin
  if CoCntr.Text <> 'Все сразу' then Adres := StrToInt(CoCntr.Text)
        else Adres := 0;
end;

procedure TFKey.BFicLoadClick(Sender: TObject);
var
 Addr : integer;
 NKey : integer;
 Key  : string;
begin
 try
  BFicLoad.Visible := false;
  BInt.Visible := True;
  FL := True;
  if CoCntr.Text = 'Все сразу' then
   begin
    ShowMessage('Эта операция возможна только с одним контроллером');
    BFicLoad.Visible := True;
    BInt.Visible := false;
    exit;
   end;
  NKey := 0;
  Cnt.InitKeyPage(StrToInt(CoCntr.Text));
  repeat
   Key := IntToStr(NKey);
   case Length(Key) of
    1: Key := 'A0000000000'+Key;
    2: Key := 'A000000000'+Key;
    3: Key := 'A00000000'+Key;
    4: Key := 'A0000000'+Key;
    5: Key := 'A000000'+Key;
    6: Key := 'A00000'+Key;
   end;
   Key := DCKeyReverse(Key);
   Addr := Cnt.PutKey(Key,'');
   SB2.SimpleText := 'Загрузка ключа по адресу '+IntToStr(Addr)+'  '+Key;
   Application.ProcessMessages;
   if not FL then break;
   NKey := NKey + 1;
  until Addr < 0;
  FL := False;
  Cnt.PostKeyPage;
  SB2.SimpleText := 'Загрузка окончена, в базе '+IntToStr(NKey)+' ключей';
  BFicLoad.Visible := True;
  BInt.Visible := false;
 except
  ShowMessage('Проверьте правильность адреса контроллера');
  BFicLoad.Visible := True;
  BInt.Visible := false;
  FL := False;
 end;
end;

procedure TFKey.BIntClick(Sender: TObject);
begin
  FL := False;
end;

procedure TFKey.CEv207Click(Sender: TObject);
var
 S : string;
begin
  if CoCntr.Text = 'Все сразу' then
   begin
    ShowMessage('Не выбран контроллер');
    exit;
   end;
  S := Cnt.AskCntr(StrToInt(CoCntr.Text));
  if S[5] <> #$9C then
   begin
    ShowMessage('У Вас гранаты не той системы');
    exit;
   end;
  FCon207.Check(StrToInt(CoCntr.Text));
  if FCon207.ClearEvent then SB2.SimpleText := 'События стерты'
   else SB2.SimpleText := 'Ошибка при стирании событий'
end;

procedure TFKey.Button3Click(Sender: TObject);
var
  F, FN : string;
  Key, KeyPad,Maska,t,cont : string;
  i, i1 : integer;
begin
  F := '';
  if OD.Execute then F := OD.FileName;
  if not FileExists(F) then exit;
  FN:=ExtractFileName(F);
  F:=ExtractFilePath(F);
  if F = '' then exit;
//  F := Copy(F,1,Length(F)-13);
  Try
   Pers.Active := False;
   Pers.DatabaseName := F;
   Pers.TableName := FN;
   Pers.Active := True;
   Pers.First;
  except
   on E:exception do begin
     showmessage('Ошибка открытия таблицы '+F);
     exit;
   end;  
  end;
  i := 1;
  NKey := 0;
  while not Pers.Eof do
   begin
    if CoCntr.Text = 'Все сразу' then
     begin
      for i1 := 0 to CoCntr.Items.Count-2 do
       begin
        if i+i1 > SG.RowCount-1 then SG.RowCount := SG.RowCount +1;
        SG.Cells[0,i+i1] := IntToStr(i);
//        t := CoCntr.Items.Strings[i1+1];
        Key := '00000000';
        KeyPad := '0000';
        Maska := '12345678';
        Cont :='';
        Try Key := Pers.FieldByName('KLUCH').AsString;Except end;
        Try KeyPad := Pers.FieldByName('KEYPAD').AsString;Except end;
        Try Maska := Pers.FieldByName('MASKA').AsString;Except end;
        Try Cont := Pers.FieldByName('CONT').AsString;Except end;

        if Length(Keypad)=4 then Key := KeyPad + Copy(Key,5,8);

        if cont='' then SG.Cells[1,i+i1] := CoCntr.Items.Strings[i1+1]
                   else SG.Cells[1,i+i1] := cont;

        SG.Cells[2,i+i1] := Key;
        SG.Cells[3,i+i1] := Maska;
        NKey := NKey + 1;
       end;
     end
    else
     begin
      if i > SG.RowCount-1 then SG.RowCount := SG.RowCount +1;
      SG.Cells[0,i] := IntToStr(i);
      Key := '00000000';
      KeyPad := '0000';
      Maska := '12345678';
      Try Key := Pers.FieldByName('KLUCH').AsString;Except end;
      Try KeyPad := Pers.FieldByName('KEYPAD').AsString;Except end;
      Try Maska := Pers.FieldByName('MASKA').AsString;Except end;
      Try Cont := Pers.FieldByName('CONT').AsString;Except end;

      if Length(Keypad)=4 then Key := KeyPad + Copy(Key,5,8);

      if cont='' then SG.Cells[1,i+i1] := CoCntr.Text
                 else SG.Cells[1,i+i1] := cont;
      SG.Cells[2,i] := Key;
      SG.Cells[3,i] := Maska;
      NKey := NKey + 1;
     end;
    i := i + 1;
    Pers.Next;
   end; // while eof
  Pers.Active := false;
end;

procedure TFKey.Button4Click(Sender: TObject);
var
 i:integer;
 NKey,Cntr1,Keys1,Ports1:string;
 F,FN:string;
 TS:TStringList;
begin
  F := '';
  if SD.Execute then F := SD.FileName;
  if not FileExists(F) then begin
   Try
    TS:=TStringList.Create;
    TS.Add('KLUCH;C;12;0');
    TS.Add('KEYPAD;C;4;0');
    TS.Add('MASKA;C;8;0');
    TS.Add('CONT;C;3;0');
//   CreateDBF(f, '', DBaseIV, TStringList(memo1.lines));
    CreateDBF(f, '', DBaseIV, TS);
    TS.Free;
   except
   end;
  end;
  FN:=ExtractFileName(F);
  F:=ExtractFilePath(F);
  if F = '' then exit;
  Try
   Pers.Active := False;
   Pers.DatabaseName := F;
   Pers.TableName := FN;
   Pers.Active := True;
  except
   on E:exception do begin
     showmessage('Ошибка открытия таблицы '+F);
     exit;
   end;
  end;

  For i:=1 to FKey.SG.RowCount-1 do begin
  //    FKey.SG.Row := NKey;
     Pers.Append;
     NKey   :=   FKey.SG.Cells[0,i];
     Cntr1  :=   FKey.SG.Cells[1,i];
     Keys1  :=   FKey.SG.Cells[2,i];
     Ports1 :=   FKey.SG.Cells[3,i];
//    showmessage(NKey+' '+Cntr1+' '+Keys1+' '+Ports1);
     Try Pers.FieldByName('KLUCH').asstring:=Keys1;Except end;
     Try Pers.FieldByName('KEYPAD').asstring:='0000';Except end;
     Try Pers.FieldByName('MASKA').asstring:=Ports1;Except end;
     Try Pers.FieldByName('CONT').asstring:=Cntr1;Except end;
     Pers.Post;
  end;
  Pers.Active:=False;  
end;

procedure TFKey.Button5Click(Sender: TObject);
var
 i:integer;
 F,FN:string;
begin
  F := '';
  if OD.Execute then F := OD.FileName;
  if not FileExists(F) then exit;
  FN:=ExtractFileName(F);
  F:=ExtractFilePath(F);
  if F = '' then exit;
  Try
   Pers.Active := False;
   Pers.DatabaseName := F;
   Pers.TableName := FN;
   Pers.Exclusive:=True;
   Pers.Active := True;
   Pers.Zap;
   Pers.Active := False;
  except
   on E:exception do begin
     showmessage('Ошибка очистки таблицы '+F);
     exit;
   end;
  end;

end;

//Keys to txt
procedure TFKey.Button7Click(Sender: TObject);
begin

 try

    MCount.Lines.SaveToFile('AlCount.txt'); //keys number
    FKey.SG.Cols[0].SaveToFile('AlKeys0.txt'); //N
    FKey.SG.Cols[1].SaveToFile('AlKeys01.txt'); //Controller
    FKey.SG.Cols[2].SaveToFile('AlKeys1.txt'); //code
    FKey.SG.Cols[3].SaveToFile('AlKeys2.txt'); //port
//    FKey.SG.Cols[3].SaveToFile('AlKeys3.txt'); //status
//    FKey.SG.Cols[3].SaveToFile('AlKeys4.txt'); //factor
    M9.Lines.Add('Коды чипов сохранены в 5 файлах AlKeysN.txt');
//     NKey   :=   FKey.SG.Cells[0,i];
//     Cntr1  :=   FKey.SG.Cells[1,i];
//     Keys1  :=   FKey.SG.Cells[2,i];
//     Ports1 :=   FKey.SG.Cells[3,i];


 except
     showmessage('Ошибка записи в файлы AlKeysN.txt ');
 end;


end;

procedure TFKey.Button6Click(Sender: TObject);
begin
 try
  MCount.Lines.Clear;
  MCount.Lines.LoadFromFile('AlCount.txt');
  FKey.SG.RowCount := StrToInt(MCount.Lines[0]);

   Try
    FKey.SG.Cols[0].LoadFromFile('AlKeys0.txt'); //N
   except
     showmessage('Ошибка чтения  из файла AlKeys0.txt ');
   end;
   Try
    FKey.SG.Cols[1].LoadFromFile('AlKeys01.txt'); //Controller
   except
     showmessage('Ошибка чтения  из файла AlKeys0.txt ');
   end;
   Try
    FKey.SG.Cols[2].LoadFromFile('AlKeys1.txt'); //code
   except
     showmessage('Ошибка чтения  из файла AlKeys0.txt ');
   end;
   Try
    FKey.SG.Cols[3].LoadFromFile('AlKeys2.txt'); //port
   except
     showmessage('Ошибка чтения  из файла AlKeys0.txt ');
   end;
    M9.Lines.Add('Коды ключей вычитаны из файлов AlKeysN.txt');
    NKey:= FKey.SG.RowCount;
    Adres:=StrToInt(FKey.SG.Cells[1,1]);
//     NKey   :=   FKey.SG.Cells[0,i];
//     Cntr1  :=   FKey.SG.Cells[1,i];
//     Keys1  :=   FKey.SG.Cells[2,i];
//     Ports1 :=   FKey.SG.Cells[3,i];


 except
     showmessage('Ошибка чтения  из файлов AlKeysN.txt ');
 end;

end;

procedure TFKey.Button9Click(Sender: TObject);
begin
 try

    MCount.Lines.SaveToFile('AlCount.txt'); //keys number
//    FKey.SG.Cols[0].SaveToFile('AlKeys0.txt'); //N
//    FKey.SG.Cols[1].SaveToFile('AlKeys01.txt'); //Controller
    FKey.SG.Cols[2].SaveToFile('AlKeys1.txt'); //code
    FKey.SG.Cols[3].SaveToFile('AlKeys2.txt'); //port
    FKey.SG.Cols[4].SaveToFile('AlKeys3.txt'); //status   U
    FKey.SG.Cols[5].SaveToFile('AlKeys4.txt'); //factor    0E
    M9.Lines.Add('Коды чипов сохранены в 5 файлах AlKeysN.txt');
//     NKey   :=   FKey.SG.Cells[0,i];
//     Cntr1  :=   FKey.SG.Cells[1,i];
//     Keys1  :=   FKey.SG.Cells[2,i];
//     Ports1 :=   FKey.SG.Cells[3,i];


 except
     showmessage('Ошибка записи в файлы AlKeysN.txt ');
 end;

end;

end.
