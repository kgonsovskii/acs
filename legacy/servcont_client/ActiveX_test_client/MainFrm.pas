unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, SyncObjs, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, IniFiles, ExtCtrls, Math,
  ActnList, Grids, Menus, BFServCont_TLB;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    GroupBox4: TGroupBox;
    cbxRpcHost: TComboBox;
    Button4: TButton;
    GroupBox2: TGroupBox;
    pgcChannel: TPageControl;
    tbsSerial: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    cbxChannelSerialPort: TComboBox;
    cbxChannelSerialSpeed: TComboBox;
    tbsIp: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    cbxChannelIPHost: TComboBox;
    cbxChannelIPPort: TComboBox;
    Add: TButton;
    Button2: TButton;
    Button5: TButton;
    Button6: TButton;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    cbxControllerAddr: TComboBox;
    Button1: TButton;
    Button8: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Button7: TButton;
    Button14: TButton;
    cbxRelayPort: TComboBox;
    cbxRelayInterval: TComboBox;
    ActionList1: TActionList;
    actRpcClose: TAction;
    actRpcOpen: TAction;
    Button3: TButton;
    actServcontAddChannel: TAction;
    actServcontRemoveChannel: TAction;
    actServcontActivateChannel: TAction;
    actServcontDeactivateChannel: TAction;
    actServcontAddController: TAction;
    actServcontRemoveController: TAction;
    actControllerRelayOn: TAction;
    actControllerRelayOff: TAction;
    Label1: TLabel;
    pgcEvents: TPageControl;
    tbsKey: TTabSheet;
    Label2: TLabel;
    sttReady: TStaticText;
    sgdKey: TStringGrid;
    tbsBtn: TTabSheet;
    sgdButton: TStringGrid;
    tbsDoorOpen: TTabSheet;
    tbsDoorClose: TTabSheet;
    sgdDoorOpen: TStringGrid;
    sgdDoorClose: TStringGrid;
    Button9: TButton;
    actControllerPollOn: TAction;
    actControllerPollOff: TAction;
    Button10: TButton;
    chbSuppressDoorEvent: TCheckBox;
    tbsCase: TTabSheet;
    sgdCase: TStringGrid;
    tbs220V: TTabSheet;
    sgd220V: TStringGrid;
    tbsTimer: TTabSheet;
    tbsAutoTimeout: TTabSheet;
    tbsRestart: TTabSheet;
    tbsStart: TTabSheet;
    sgdTimer: TStringGrid;
    sgdAutoTimeout: TStringGrid;
    sgdRestart: TStringGrid;
    sgdStart: TStringGrid;
    actControllerTimerOn: TAction;
    actControllerTimerOff: TAction;
    cbxControllerAuto: TCheckBox;
    cbxControllerReliable: TCheckBox;
    GroupBox6: TGroupBox;
    cbxKeyValue: TComboBox;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    actControllerWriteKey: TAction;
    Label9: TLabel;
    actControllerEraseKey: TAction;
    actControllerKeyExist: TAction;
    Button12: TButton;
    actControllerEraseAllKeys: TAction;
    chbKeyPort1: TCheckBox;
    chbKeyPort2: TCheckBox;
    chbKeyPort3: TCheckBox;
    chbKeyPort4: TCheckBox;
    chbKeyPort5: TCheckBox;
    chbKeyPort6: TCheckBox;
    chbKeyPort7: TCheckBox;
    chbKeyPort8: TCheckBox;
    Label12: TLabel;
    chbKeySuppressDoorEvent: TCheckBox;
    Label13: TLabel;
    cbxKeyPersCat: TComboBox;
    actControllerProgId: TAction;
    actControllerProgVer: TAction;
    actControllerSerNum: TAction;
    actControllerReadClock: TAction;
    actControllerWriteClockDate: TAction;
    actControllerWriteClockTime: TAction;
    Button19: TButton;
    actControllerReadAllKeys: TAction;
    actControllerTimetableEdit: TAction;
    actControllerTimetableErase: TAction;
    actControllerRestartProg: TAction;
    tbsSensor: TTabSheet;
    sgdSensor: TStringGrid;
    cbxChannelResponseTimeout: TComboBox;
    Label14: TLabel;
    Label15: TLabel;
    tbsChannelError: TTabSheet;
    sgdChannelError: TStringGrid;
    tbsControllerError: TTabSheet;
    sgdControllerError: TStringGrid;
    Panel2: TPanel;
    btnClear: TButton;
    Button25: TButton;
    sttRecCnt: TStaticText;
    Label16: TLabel;
    tbsChannelState: TTabSheet;
    sgdChannelState: TStringGrid;
    actControllerEraseAllEvents: TAction;
    actControllerEventsInfo: TAction;
    actControllerKeysInfo: TAction;
    actControllerPortsInfo: TAction;
    actControllerGenerateTimerEvents: TAction;
    actControllerEditKeypad: TAction;
    actServcontChannelList: TAction;
    actServcontControllerList: TAction;
    MainMenu1: TMainMenu;
    RPC1: TMenuItem;
    Servcont1: TMenuItem;
    Controller1: TMenuItem;
    Application1: TMenuItem;
    Exit1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    Add1: TMenuItem;
    Remove1: TMenuItem;
    Activate1: TMenuItem;
    Deactivate1: TMenuItem;
    Add2: TMenuItem;
    Remove2: TMenuItem;
    ChannelList1: TMenuItem;
    ControllerList1: TMenuItem;
    On1: TMenuItem;
    Off1: TMenuItem;
    Poll1: TMenuItem;
    Stoppolling1: TMenuItem;
    On2: TMenuItem;
    Off2: TMenuItem;
    Write1: TMenuItem;
    KeyErase1: TMenuItem;
    KeyExist1: TMenuItem;
    KeyEraseAll1: TMenuItem;
    ProgId2: TMenuItem;
    ProgVer2: TMenuItem;
    SerNum2: TMenuItem;
    ReadClock2: TMenuItem;
    WriteClockDate2: TMenuItem;
    WriteClockTime2: TMenuItem;
    ReadAll1: TMenuItem;
    Edit1: TMenuItem;
    imetableErase1: TMenuItem;
    RestartProg2: TMenuItem;
    EraseAllEvents2: TMenuItem;
    EventsInfo2: TMenuItem;
    KeysInfo2: TMenuItem;
    PortsInfo2: TMenuItem;
    GenerateTimerEvents2: TMenuItem;
    EditKeypad2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    tbsChannelPollSpeed: TTabSheet;
    sgdChannelPollSpeed: TStringGrid;
    actServcontSwitchToAuto: TAction;
    SwitchtoAutonomicmode1: TMenuItem;
    N9: TMenuItem;
    actControllerGenerateKeyBase: TAction;
    GenerateKeyBase1: TMenuItem;
    N10: TMenuItem;
    actControllerReadAllChips: TAction;
    actControllerWriteAllChips: TAction;
    Chips1: TMenuItem;
    N11: TMenuItem;
    actControllerActivateChip: TAction;
    actControllerDeactivateChip: TAction;
    actControllerEraseAllChips: TAction;
    actServcontMainClient: TAction;
    MainClient1: TMenuItem;
    N12: TMenuItem;
    actServcontCoEvtLogSend: TAction;
    N13: TMenuItem;
    CoEvtLogSend1: TMenuItem;
    actServcontCoEvtLogClear: TAction;
    CoEvtLogClear1: TMenuItem;
    GroupBox5: TGroupBox;
    Button11: TButton;
    chbLogControllerEvents: TCheckBox;
    tbsControllerState: TTabSheet;
    sgdControllerState: TStringGrid;
    Label11: TLabel;
    cbxChannelAliveTimeout: TComboBox;
    Label17: TLabel;
    Label18: TLabel;
    cbxChannelDeadTimeout: TComboBox;
    Label19: TLabel;
    actServcontClientList: TAction;
    ClientList1: TMenuItem;
    tbsChannelsChanged: TTabSheet;
    tbsControllersChanged: TTabSheet;
    tbsClientsChanged: TTabSheet;
    sgdChannelsChanged: TStringGrid;
    sgdControllersChanged: TStringGrid;
    sgdClientsChanged: TStringGrid;
    cbxQueueLimit: TComboBox;
    Label20: TLabel;
    tbsQueueFull: TTabSheet;
    sgdQueueFull: TStringGrid;
    actServcontSetHostClock: TAction;
    N14: TMenuItem;
    ServcontSetHostClock1: TMenuItem;
    tbsRs422: TTabSheet;
    Label21: TLabel;
    cbxChannelRS422Speed: TComboBox;
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actRpcOpenExecute(Sender: TObject);
    procedure actRpcCloseExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure actServcontAddChannelExecute(Sender: TObject);
    procedure actServcontRemoveChannelExecute(Sender: TObject);
    procedure actServcontActivateChannelExecute(Sender: TObject);
    procedure actServcontDeactivateChannelExecute(Sender: TObject);
    procedure actServcontAddControllerExecute(Sender: TObject);
    procedure actServcontRemoveControllerExecute(Sender: TObject);
    procedure actControllerRelayOnExecute(Sender: TObject);
    procedure actControllerRelayOffExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actControllerPollOnExecute(Sender: TObject);
    procedure actControllerPollOffExecute(Sender: TObject);
    procedure actControllerTimerOffExecute(Sender: TObject);
    procedure actControllerTimerOnExecute(Sender: TObject);
    procedure actControllerWriteKeyExecute(Sender: TObject);
    procedure actControllerEraseKeyExecute(Sender: TObject);
    procedure actControllerKeyExistExecute(Sender: TObject);
    procedure actControllerEraseAllKeysExecute(Sender: TObject);
    procedure actControllerProgIdExecute(Sender: TObject);
    procedure actControllerProgVerExecute(Sender: TObject);
    procedure actControllerSerNumExecute(Sender: TObject);
    procedure actControllerReadClockExecute(Sender: TObject);
    procedure actControllerWriteClockDateExecute(Sender: TObject);
    procedure actControllerWriteClockTimeExecute(Sender: TObject);
    procedure actControllerReadAllKeysExecute(Sender: TObject);
    procedure actControllerTimetableEraseExecute(Sender: TObject);
    procedure actControllerRestartProgExecute(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure pgcEventsChange(Sender: TObject);
    procedure actControllerEraseAllEventsExecute(Sender: TObject);
    procedure actControllerEventsInfoExecute(Sender: TObject);
    procedure actControllerKeysInfoExecute(Sender: TObject);
    procedure actControllerPortsInfoExecute(Sender: TObject);
    procedure actControllerGenerateTimerEventsExecute(Sender: TObject);
    procedure actControllerEditKeypadExecute(Sender: TObject);
    procedure actServcontControllerListExecute(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure actServcontSwitchToAutoExecute(Sender: TObject);
    procedure actControllerGenerateKeyBaseExecute(Sender: TObject);
    procedure actControllerReadAllChipsExecute(Sender: TObject);
    procedure Chips1Click(Sender: TObject);
    procedure actControllerWriteAllChipsExecute(Sender: TObject);
    procedure actControllerActivateChipExecute(Sender: TObject);
    procedure actControllerDeactivateChipExecute(Sender: TObject);
    procedure actControllerEraseAllChipsExecute(Sender: TObject);
    procedure actServcontMainClientExecute(Sender: TObject);
    procedure actServcontCoEvtLogSendExecute(Sender: TObject);
    procedure actServcontCoEvtLogClearExecute(Sender: TObject);
    procedure actServcontClientListExecute(Sender: TObject);
    procedure actControllerTimetableEditExecute(Sender: TObject);
    procedure actServcontChannelListExecute(Sender: TObject);
    procedure actServcontSetHostClockExecute(Sender: TObject);
  private
    { Private declarations }
    FSc : TTSSServContX;
    ChReady: Boolean;


    Procedure _OnCont220VEvent(ASender: TObject; const ChannelId: WideString; const Event: ITSSServCont_ControllerEvent);
    Procedure _OnContCaseEvent(ASender: TObject; const ChannelId: WideString;
                                                             const Event: ITSSServCont_ControllerEvent);
    Procedure _OnContTimerEvent(ASender: TObject; const ChannelId: WideString;
                                                              const Event: ITSSServCont_ControllerEvent);
    Procedure _OnContStartEvent(ASender: TObject; const ChannelId: WideString;
                                                              const Event: ITSSServCont_ControllerEvent);
    Procedure _OnContRestartEvent(ASender: TObject; const ChannelId: WideString;
                                                                const Event: ITSSServCont_ControllerEvent);
    Procedure _OnContAutoTimeoutEvent(ASender: TObject; const ChannelId: WideString;
                                                                    const Event: ITSSServCont_ControllerEvent);
    Procedure _OnContButtonEvent(ASender: TObject; const ChannelId: WideString;
                                                               const Event: ITSSServCont_ControllerPortRelayEvent);
    Procedure _OnContDoorOpenEvent(ASender: TObject; const ChannelId: WideString;
                                                                 const Event: ITSSServCont_ControllerPortRelayEvent);
    Procedure _OnContDoorCloseEvent(ASender: TObject; const ChannelId: WideString;
                                                                  const Event: ITSSServCont_ControllerPortRelayEvent);
    Procedure _OnContKeyEvent(ASender: TObject; const ChannelId: WideString;
                                                            const Event: ITSSServCont_ControllerKeyEvent);
    Procedure _OnContStaticSensorEvent(ASender: TObject; const ChannelId: WideString;
                                                                     const Event: ITSSServCont_ControllerStaticSensorEvent);
    Procedure _OnContErrorEvent(ASender: TObject; const ChannelId: WideString;
                                                              const Time: ITSSServCont_ServcontDateTime;
                                                              const EClass: WideString;
                                                              const EMessage: WideString;
                                                              Addr: Integer);
    Procedure _OnContChannelErrorEvent(ASender: TObject; const ChannelId: WideString;
                                                                     const Time: ITSSServCont_ServcontDateTime;
                                                                     const EClass: WideString;
                                                                     const EMessage: WideString);
    Procedure _OnContChannelStateEvent(ASender: TObject; const ChannelId: WideString;
                                                                     const Time: ITSSServCont_ServcontDateTime;
                                                                     IsReady: WordBool);
    Procedure _OnContChannelPollSpeedEvent(ASender: TObject; const ChannelId: WideString;
                                                                         const Time: ITSSServCont_ServcontDateTime;
                                                                         Value: Integer);
    Procedure _OnContChangeStateEvent(ASender: TObject; const ChannelId: WideString;
                                                                    ControllerAddr: Integer;
                                                                    const Time: ITSSServCont_ServcontDateTime;
                                                                    State: TTSSServCont_ControllerState);
    Procedure _OnClientsChangedEvent(ASender: TObject; const Time: ITSSServCont_ServcontDateTime);

    Procedure _OnContChannelChangedEvent(ASender: TObject; const Time: ITSSServCont_ServcontDateTime);
    Procedure _OnContChangedEvent(ASender: TObject; const ChannelId: WideString; const Time: ITSSServCont_ServcontDateTime);

    Procedure _OnQueueFullEvent(ASender: TObject; const Time: ITSSServCont_ServcontDateTime);

    procedure RpcChange(Sender: TObject);
    procedure Maintain;
    procedure ExecRelay(IsOn: Boolean);
    function ChannelId: string;
    function ControllerAddr: Integer;
    function ControllerEvent(Grid: TStringGrid; const Channel: string; pData: ITSSServCont_ControllerEvent): Integer;
    function ChannelEvent(Grid: TStringGrid; ChannelID : String; EventTime : ITSSServCont_ServcontDateTime): Integer;
    function ChannelErrorEvent(Grid: TStringGrid; aClass, aMessage : String; Row: Integer): Integer;
    procedure ControllerPortEvent(Grid: TStringGrid; pData: ITSSServCont_ControllerPortEvent);
    procedure ControllerPortRelayEvent(Grid: TStringGrid; pData: ITSSServCont_ControllerPortRelayEvent);
    procedure SerializeCheckBox(ini: TIniFile; chb: TCheckBox);
    procedure InitGrid(ini: TIniFile; Grid: TStringGrid);
    procedure ControllerWriteClock(IsTime: Boolean);
    procedure ReadTimetable(Out SpecialDays : ITSSServCont_TimetableSpecialDayList;
                            Out Items: ITSSServCont_TimetableItemList);
    procedure WriteTimetable(SpecialDays : ITSSServCont_TimetableSpecialDayList;
                                 Items: ITSSServCont_TimetableItemList);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

function Bin(const S: string): string;
procedure ClearGrid(Grid: TStringGrid);
function AddGridRow(Grid: TStringGrid): Integer;
function GridLastRow(Grid: TStringGrid): Integer;
procedure RemoveGridRow(Grid: TStringGrid; Row: Integer);
procedure InitComboBox(ini: TIniFile; cbx: TComboBox);
procedure InitCheckBox(ini: TIniFile; chb: TCheckBox);
procedure SerializeGrid(ini: TIniFile; Grid: TStringGrid);
procedure SerializeComboBox(ini: TIniFile; cbx: TComboBox);
function Timestamp2Str(pTimestamp: ITSSServCont_ServcontDateTime): string;
function ControllerPorts2Str(pPorts: ITSSServCont_ControllerPorts): string;
procedure Now2DateTimeIntf(pTimestamp: ITSSServCont_ServcontDateTime; SecAdj: Integer = 0);


implementation

uses
  TypInfo, DateUtils, DateTimeFrm, KeysFrm, TimetableFrm, KeypadFrm, ChipsFrm;

{$R *.dfm}

function Bin(const S: string): string;
var
  Len, i: Integer;
begin
  Result := '';
  Len := Length(S);
  i := 1;
  while i < Len do begin
    if S[i] = #32 then begin
      Inc(i);
      Continue;
    end;
    Result := Result + Char(StrToInt('$' + AnsiString(S[i]) + AnsiString(S[i+1])));
    Inc(i, 2);
  end;
end;

procedure ClearGrid(Grid: TStringGrid);
var
  i: Integer;
begin
  for i:=1 to Grid.RowCount - 1 do
    Grid.Rows[i].Clear;
  Grid.RowCount := 2;
end;

function AddGridRow(Grid: TStringGrid): Integer;
var
  x: Integer;
begin
  x := Grid.RowCount + 1;
  Grid.RowCount := x;
  Result := Grid.RowCount - 2;
  Grid.Row := Result;
end;

Function KeyToStr(Data : ITSSServCont_ControllerKeyValue) : String;
var
  i: Integer;
begin
  Result := '';
  for i:= 0 to Data.Count - 1 do
    Result := Result + IntToHex(Data.B[i], 2) + ' ';
  Result := Trim(Result);
end;

Function StrToKey(const S : String) : ITSSServCont_ControllerKeyValue;
var V, i: Integer;
Begin
  Result := CoTSSServCont_ControllerKeyValueX.Create;
  V := 0;
  i := 1;
  while (i < Length(S)) and (V < Result.Count) do
    if S[i] = #32 then begin
      Inc(i);
      Continue;
    end else Begin
      Result.B[V] := StrToInt('$' + AnsiString(S[i]) + AnsiString(S[i+1]));
      Inc(V);
      Inc(i, 2);
    end;
end;

function GridLastRow(Grid: TStringGrid): Integer;
begin
  Result := Grid.RowCount - 2;
end;

procedure RemoveGridRow(Grid: TStringGrid; Row: Integer);
var
  i: Integer;
begin
  if ((Row + 1) = Grid.RowCount) or (Grid.RowCount = 2) then
    Exit;
  for i := Row + 1 to Grid.RowCount - 1 do
    Grid.Rows[i - 1].Text := Grid.Rows[i].Text;
  Grid.RowCount := Grid.RowCount - 1;
end;

procedure InitComboBox(ini: TIniFile; cbx: TComboBox);
var
  i: Integer;
  s: string;
begin
  i := 0;
  while ini.ValueExists(cbx.Name, IntToStr(i)) do begin
    s := Trim(ini.ReadString(cbx.Name, IntToStr(i), ''));
    if s <> '' then
      cbx.Items.Add(s);
    Inc(i);
  end;
  i := ini.ReadInteger(cbx.Name, 'i', 0);
  if cbx.Items.Count > i then
    cbx.ItemIndex := i;
end;

procedure InitCheckBox(ini: TIniFile; chb: TCheckBox);
begin
  chb.Checked := ini.ReadBool('FLAGS', chb.Name, False);
end;

procedure SerializeGrid(ini: TIniFile; Grid: TStringGrid);
var
  i: Integer;
begin
  for i:=0 to Grid.ColCount - 1 do
    ini.WriteInteger(Grid.Name, IntToStr(i), Grid.ColWidths[i]);
end;

procedure SerializeComboBox(ini: TIniFile; cbx: TComboBox);
var
  i: Integer;
  s: string;
begin
  ini.EraseSection(cbx.Name);
  i := cbx.Items.IndexOf(cbx.Text);
  if i <> -1 then
    ini.WriteInteger(cbx.Name, 'i', i);
  for i:=0 to cbx.Items.Count - 1 do begin
    s := Trim(cbx.Items[i]);
    if s <> '' then
      ini.WriteString(cbx.Name, IntToStr(i), s);
  end;
end;

function Timestamp2Str(pTimestamp: ITSSServCont_ServcontDateTime): string;
var
  dt: TDateTime;
begin
  with pTimestamp do
    if TryEncodeDateTime(Year + 2000, Month, Day, Hour, Minute, Second, 0, dt) then
      Result := DateTimeToStr(dt)
    else
      Result := '<Invalid Value>';
end;

function ControllerPorts2Str(pPorts: ITSSServCont_ControllerPorts): string;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to pPorts.Count - 1 do
    Result := Result + IntToStr(Abs(Integer(pPorts.P[i]=True)));
end;

procedure Now2DateTimeIntf(pTimestamp: ITSSServCont_ServcontDateTime; SecAdj: Integer);
var
  y,m,d,h,n,s,z: Word;
begin
  DecodeDateTime(Now, y,m,d,h,n,s,z);
  with pTimestamp do begin
    Year := y - 2000;
    Month := m;
    Day := d;
    Hour := h;
    Minute := n;
    Second := s + SecAdj;
  end;
end;


procedure TfrmMain.btnClearClick(Sender: TObject);
var
  Grid: TStringGrid;
begin
  Grid := pgcEvents.ActivePage.Controls[0] as TStringGrid;
  ClearGrid(Grid);
  sttRecCnt.Caption := '0';
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  ini: TIniFile;
  i: Integer;
begin
  Caption := Application.Title;

  sgdKey.Cells[9,0] := 'Key';
  sgdKey.Cells[10,0] := 'IsTimeRestrict';
  sgdKey.Cells[11,0] := 'IsTimeRestrictDone';
  sgdKey.Cells[12,0] := 'IsAccessGranted';
  sgdKey.Cells[13,0] := 'IsKeyFound';
  sgdKey.Cells[14,0] := 'IsKeySearchDone';
  sgdSensor.Cells[7,0] := 'Value';

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    for i:=0 to ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        InitComboBox(ini, TComboBox(Components[i]))
      else
      if (Components[i] is TCheckBox) then
        InitCheckBox(ini, TCheckBox(Components[i]))
      else
      if (Components[i] is TStringGrid) then
        InitGrid(ini, TStringGrid(Components[i]));
  finally
    ini.Free;
  end;

  FSc := TTSSServContX.Create(Self);
  FSc.OnCont220VEvent := _OnCont220VEvent;
  FSc.OnContCaseEvent := _OnContCaseEvent;
  FSc.OnContTimerEvent := _OnContTimerEvent;
  FSc.OnContStartEvent := _OnContStartEvent;
  FSc.OnContRestartEvent := _OnContRestartEvent;
  FSc.OnContAutoTimeoutEvent := _OnContAutoTimeoutEvent;
  FSc.OnContButtonEvent := _OnContButtonEvent;
  FSc.OnContDoorOpenEvent := _OnContDoorOpenEvent;
  FSc.OnContDoorCloseEvent := _OnContDoorCloseEvent;
  FSc.OnContKeyEvent := _OnContKeyEvent;
  FSc.OnContStaticSensorEvent := _OnContStaticSensorEvent;
  FSc.OnContErrorEvent := _OnContErrorEvent;
  FSc.OnContChannelErrorEvent := _OnContChannelErrorEvent;
  FSc.OnContChannelStateEvent := _OnContChannelStateEvent;
  FSc.OnContChannelPollSpeedEvent := _OnContChannelPollSpeedEvent;
  FSc.OnContChangeStateEvent := _OnContChangeStateEvent;
  FSc.OnClientsChangedEvent := _OnClientsChangedEvent;
  FSc.OnContChannelChangedEvent := _OnContChannelChangedEvent;
  FSc.OnContChangedEvent := _OnContChangedEvent;
  FSc.OnQueueFullEvent := _OnQueueFullEvent;
  FSc.OnReadyChangeEvent := RpcChange; 
end;

procedure TfrmMain.ExecRelay(IsOn: Boolean);
Begin
  if IsOn then
    FSc.cntRelayOn(ChannelId, ControllerAddr, StrToInt(cbxRelayPort.Text), chbSuppressDoorEvent.Checked, StrToInt(cbxRelayInterval.Text))
  else
    FSc.cntRelayOff(ChannelId, ControllerAddr, StrToInt(cbxRelayPort.Text), chbSuppressDoorEvent.Checked);
  Maintain;
end;

procedure TfrmMain.Maintain;
var
  i: Integer;
  cbx: TComboBox;
  s: string;
begin
  for i:=0 to ComponentCount - 1 do
    if Components[i] is TComboBox then begin
      cbx := TComboBox(Components[i]);
      s := Trim(cbx.Text);
      if s <> '' then
        if cbx.Items.IndexOf(s) = -1 then
          cbx.Items.Add(s);
    end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  ini: TIniFile;
  i: Integer;
begin
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    for i:=0 to ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        SerializeComboBox(ini, TComboBox(Components[i]))
      else
      if Components[i] is TCheckBox then
        SerializeCheckBox(ini, TCheckBox(Components[i]))
      else
      if (Components[i] is TStringGrid) then
        SerializeGrid(ini, TStringGrid(Components[i]));
  finally
    ini.Free;
  end;

  FSc.Free;
  //Rpc.Free;
end;

procedure TfrmMain.actRpcOpenExecute(Sender: TObject);
begin
  FSc.Host := cbxRpcHost.Text;
  FSc.Port := 4000;
  FSc.Active := True;

  Maintain;
end;

procedure TfrmMain.actRpcCloseExecute(Sender: TObject);
begin
  FSc.Active := False;
end;

procedure TfrmMain.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := True;
  if Action = actRpcOpen then
    TAction(Action).Enabled := not FSc.Active
  else
  if Action = actRpcClose then
    TAction(Action).Enabled := FSc.Active
  else
    TAction(Action).Enabled := FSc.Ready;
end;

procedure TfrmMain.actServcontAddChannelExecute(Sender: TObject);
Begin
  If pgcChannel.ActivePage = tbsIp Then
    FSc.srvAddIPChannel(cbxChannelIPHost.Text, StrToInt(cbxChannelIPPort.Text),
                        StrToInt(cbxChannelResponseTimeout.Text),
                        StrToInt(cbxChannelAliveTimeout.Text),
                        StrToInt(cbxChannelDeadTimeout.Text))
  else If pgcChannel.ActivePage = tbsSerial Then begin
    FSc.srvAddChannel(cbxChannelSerialPort.Text, StrToInt(cbxChannelSerialSpeed.Text),
                        StrToInt(cbxChannelResponseTimeout.Text),
                        StrToInt(cbxChannelAliveTimeout.Text),
                        StrToInt(cbxChannelDeadTimeout.Text));
  end else
    FSc.srvAddDvRs422Channel(StrToInt(cbxChannelRS422Speed.Text),
                        StrToInt(cbxChannelResponseTimeout.Text),
                        StrToInt(cbxChannelAliveTimeout.Text),
                        StrToInt(cbxChannelDeadTimeout.Text));

  Maintain;
end;

procedure TfrmMain.actServcontRemoveChannelExecute(Sender: TObject);
Begin
  FSc.srvRemoveChannel( ChannelId );

  Maintain;
end;

procedure TfrmMain.actServcontActivateChannelExecute(Sender: TObject);
begin
  FSc.srvActivateChannel( ChannelId );
end;

procedure TfrmMain.actServcontDeactivateChannelExecute(Sender: TObject);
begin
  FSc.srvDeactivateChannel( ChannelId );
end;

procedure TfrmMain.actServcontAddControllerExecute(Sender: TObject);
begin
  FSc.srvAddController( ControllerAddr, ChannelId );
  Maintain;
end;

procedure TfrmMain.actServcontRemoveControllerExecute(Sender: TObject);
begin
  FSc.srvRemoveController( ControllerAddr, ChannelId );
  Maintain;
end;

procedure TfrmMain.actControllerRelayOnExecute(Sender: TObject);
begin
  ExecRelay(True);
end;

procedure TfrmMain.actControllerRelayOffExecute(Sender: TObject);
begin
  ExecRelay(False);
end;

procedure TfrmMain.InitGrid(ini: TIniFile; Grid: TStringGrid);
var
  i: Integer;
begin
  if (Grid = sgdChannelsChanged) or (Grid = sgdClientsChanged) or (Grid = sgdQueueFull) then
    Grid.Cells[0,0] := 'Time'
  else
    Grid.Cells[0,0] := 'Channel';
  if not((Grid = sgdChannelError) or (Grid = sgdControllerError) or (Grid = sgdChannelState) or (Grid = sgdChannelPollSpeed) or (Grid = sgdControllerState) or (Grid = sgdControllersChanged)) then begin
    Grid.Cells[1,0] := 'Time2';
    Grid.Cells[2,0] := 'Addr';
    Grid.Cells[3,0] := 'No';
    Grid.Cells[4,0] := 'IsAuto';
    Grid.Cells[5,0] := 'Time1';
    Grid.Cells[6,0] := 'IsLast';
    if (Grid = sgdKey) or (Grid = sgdButton) or (Grid = sgdDoorOpen) or (Grid = sgdDoorClose) then
      Grid.Cells[7,0] := 'Port';
    if (Grid = sgdKey) or (Grid = sgdButton) then
      Grid.Cells[8,0] := 'IsOpen';
  end else begin
    Grid.Cells[1,0] := 'Time';
    if Grid = sgdChannelState then
      Grid.Cells[2,0] := 'IsReady'
    else
    if Grid = sgdControllerState then begin
      Grid.Cells[2,0] := 'Addr';
      Grid.Cells[3,0] := 'State';
    end else
    if (Grid = sgdChannelError) or (Grid = sgdControllerError) then begin
      Grid.Cells[2,0] := 'Class';
      Grid.Cells[3,0] := 'Message';
      if Grid = sgdControllerError then
        Grid.Cells[4,0] := 'Addr';
    end else
    if Grid = sgdChannelPollSpeed then
      Grid.Cells[2,0] := 'Value';
  end;

  for i:=0 to Grid.ColCount - 1 do
    Grid.ColWidths[i] := ini.ReadInteger(Grid.Name, IntToStr(i), Grid.DefaultColWidth);
end;

function TfrmMain.ControllerEvent(Grid: TStringGrid; const Channel: string; pData: ITSSServCont_ControllerEvent): Integer;
begin
  Result := AddGridRow(Grid);
  pgcEventsChange(pgcEvents);
  Grid.Cells[0, Result] := Channel;
  with Grid, pData do begin
    Cells[1, Result] := Timestamp2Str(Timestamp2);
    Cells[2, Result] := IntToStr(Addr);
    Cells[3, Result] := IntToStr(No);
    Cells[4, Result] := BoolToStr(IsAuto, True);
    Cells[5, Result] := Timestamp2Str(Timestamp1);
    Cells[6, Result] := BoolToStr(IsLast, True);
  end;
end;

procedure TfrmMain.RpcChange(Sender: TObject);
begin
  sttReady.Caption := BoolToStr(FSc.Ready, True);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Tag := 1;
  actRpcClose.Execute;
end;

procedure TfrmMain.actControllerPollOnExecute(Sender: TObject);
Begin
  FSc.cntPollOn(ChannelId, ControllerAddr, cbxControllerAuto.Checked, cbxControllerReliable.Checked);
end;

procedure TfrmMain.actControllerPollOffExecute(Sender: TObject);
Begin
  FSc.cntPollOff(ChannelId, ControllerAddr, True);
end;

procedure TfrmMain.ControllerPortEvent(Grid: TStringGrid;
  pData: ITSSServCont_ControllerPortEvent);
begin
  Grid.Cells[7, GridLastRow(Grid)] := IntToStr(pData.Port);
end;

procedure TfrmMain.ControllerPortRelayEvent(Grid: TStringGrid;
  pData: ITSSServCont_ControllerPortRelayEvent);
begin
  Grid.Cells[8, GridLastRow(Grid)] := BoolToStr(pData.IsOpen, True);
end;

procedure TfrmMain.actControllerTimerOffExecute(Sender: TObject);
begin
  FSc.cntTimerOff(ChannelId, ControllerAddr);
end;

procedure TfrmMain.actControllerTimerOnExecute(Sender: TObject);
var
  s: string;
begin
  s := '1';
  if InputQuery('Timer', 'Interval:', s) then
    FSc.cntTimerOn(ChannelId, ControllerAddr, StrToInt(s));
end;

procedure TfrmMain.actControllerWriteKeyExecute(Sender: TObject);
var Key : ITSSServCont_ControllerKey;
    V : ITSSServCont_ControllerKeyValue;
    P : ITSSServCont_ControllerPorts;
    S : String;
    chb: TCheckBox;
    I : Integer;
begin
  Key := CoTSSServCont_ControllerKeyX.Create;
  Key.PersCat := StrToInt(cbxKeyPersCat.Text);
  Key.SuppressDoorEvent := chbKeySuppressDoorEvent.Checked;
  Key.OpenEvenComplex := False;
  Key.IsSilent := False;

  V := Key.Value;
  s := Bin(cbxKeyValue.Text);
  if Length(s) <> V.Count then
    raise Exception.Create('Invalid key value');
  For I := 0 to V.Count - 1 do
    V.B[I] := Ord(S[I+1]);

  P := Key.Ports;
  For I := 0 to P.Count - 1 do Begin
    chb := FindComponent('chbKeyPort' + IntToStr(i+1)) as TCheckBox;
    Assert(chb <> nil);
    P.P[i] := chb.Checked;
  end;

  FSc.cntWriteKey(ChannelId, ControllerAddr, Key);

  Maintain;
end;

function TfrmMain.ControllerAddr: Integer;
begin
  Result := StrToInt(cbxControllerAddr.Text);
end;

procedure TfrmMain.actControllerEraseKeyExecute(Sender: TObject);
var V : ITSSServCont_ControllerKeyValue;
    S : String;
    I : Integer;
Begin
  V := CoTSSServCont_ControllerKeyValueX.Create;
  s := Bin(cbxKeyValue.Text);
  if Length(s) <> V.Count then
    raise Exception.Create('Invalid key value');
  For I := 0 to V.Count - 1 do
    V.B[I] := Ord(S[I+1]);


  FSc.cntEraseKey(ChannelId, ControllerAddr, V);

  Maintain;
end;

procedure TfrmMain.actControllerKeyExistExecute(Sender: TObject);
var KeyValue: ITSSServCont_ControllerKeyValue;
    IsExist: WordBool;
    KeyAttr: ITSSServCont_ControllerKeyAttr;
    I : Integer;
    s : String;
Begin
  KeyValue := CoTSSServCont_ControllerKeyValueX.Create;

  s := Bin(cbxKeyValue.Text);
  if Length(s) <> KeyValue.Count then
    raise Exception.Create('Invalid key value');
  For I := 0 to KeyValue.Count - 1 do
    KeyValue.B[I] := Ord(S[I+1]);

  FSc.cntKeyExist(ChannelId, ControllerAddr, KeyValue, IsExist, KeyAttr);

  s := 'IsExist: ' + BoolToStr(IsExist, True);
  if IsExist then begin
    s := s + #13#10 + 'Ports: ';
    s := s + ControllerPorts2Str(KeyAttr.Ports);
    s := s + #13#10 + 'PersCat: ' + IntToStr(KeyAttr.PersCat) + #13#10;
    s := s + 'SuppressDoorEvent: ' + BoolToStr(KeyAttr.SuppressDoorEvent, True) + #13#10;
    s := s + 'OpenEvenComplex: ' + BoolToStr(KeyAttr.OpenEvenComplex, True) + #13#10;
    s := s + 'IsSilent: ' + BoolToStr(KeyAttr.IsSilent, True);
  end;
  ShowMessage(s);

  Maintain;
end;

procedure TfrmMain.actControllerEraseAllKeysExecute(Sender: TObject);
begin
  FSc.cntEraseAllKeys(ChannelId, ControllerAddr);
  Maintain;
end;

procedure TfrmMain.SerializeCheckBox(ini: TIniFile; chb: TCheckBox);
begin
  ini.WriteBool('FLAGS', chb.Name, chb.Checked);
end;

procedure TfrmMain.actControllerProgIdExecute(Sender: TObject);
var Id: Integer;
Begin
  FSc.cntProgId(ChannelId, ControllerAddr, ID  );
  ShowMessage(IntToHex(ID, 2) + 'h');

  Maintain;
end;

procedure TfrmMain.actControllerProgVerExecute(Sender: TObject);
var Ver : WideString;
Begin
  FSc.cntProgVer(ChannelId, ControllerAddr, Ver);
  ShowMessage(Ver);
  Maintain;
end;

procedure TfrmMain.actControllerSerNumExecute(Sender: TObject);
var SNum : Integer;
Begin
  FSc.cntSerNum(ChannelId, ControllerAddr, SNum);
    ShowMessage(IntToStr(SNum));

  Maintain;
end;

procedure TfrmMain.actControllerReadClockExecute(Sender: TObject);
var Clock : ITSSServCont_ServcontDateTime;
Begin
  FSc.cntReadClock(ChannelId, ControllerAddr, Clock);
  ShowMessage('Controller Clock: ' + Timestamp2Str(Clock));
  Maintain;
end;

procedure TfrmMain.actControllerWriteClockDateExecute(Sender: TObject);
begin
  ControllerWriteClock(False);
end;

procedure TfrmMain.actControllerWriteClockTimeExecute(Sender: TObject);
begin
  ControllerWriteClock(True);
end;

procedure TfrmMain.ControllerWriteClock(IsTime: Boolean);
Begin
  with TfrmDateTime.Create(nil) do
    try
      Init(IsTime);
      ShowModal;
      if ModalResult <> mrOk then Exit;

      if IsTime then
        FSc.cntWriteClockTime(ChannelId, ControllerAddr, DateTimePicker.Time)
      else
        FSc.cntWriteClockDate(ChannelId, ControllerAddr, DateTimePicker.DateTime);
    finally
      Free;
    end;
end;

procedure TfrmMain.actControllerReadAllKeysExecute(Sender: TObject);
var KeyList: ITSSServCont_KeyList;
    Key : ITSSServCont_ControllerKey;
    I, y : Integer;
Begin
  FSc.cntReadAllKeys(ChannelId, ControllerAddr, KeyList);
  if KeyList.Count <> 0 then begin
    with TfrmKeys.Create(nil) do
      try
        StatusBar.SimpleText := 'Total: ' + IntToStr(KeyList.Count);
        Grid.RowCount := KeyList.Count + 1;
        for i :=0 to KeyList.Count - 1 do begin
          y := i + 1;
          Grid.Cells[0, y] := IntToStr(y);
          Key := KeyList.Items[I];
          Grid.Cells[1, y] :=  KeyToStr(Key.Value);
          Grid.Cells[2, y] := ControllerPorts2Str(Key.Ports);
          Grid.Cells[3, y] := IntToStr(Key.PersCat);
          Grid.Cells[4, y] := BoolToStr(Key.SuppressDoorEvent, True);
          Grid.Cells[5, y] := BoolToStr(Key.OpenEvenComplex, True);
          Grid.Cells[6, y] := BoolToStr(Key.IsSilent, True);
        end;
        ShowModal;
      finally
        Free;
      end;
  end else
    ShowMessage('No keys.');

  Maintain;
end;

procedure TfrmMain.actControllerTimetableEditExecute(Sender: TObject);
var SpecialDays : ITSSServCont_TimetableSpecialDayList;
    Items: ITSSServCont_TimetableItemList;
Begin
  ReadTimetable(SpecialDays, Items);
  with TfrmTimetable.Create(nil) do
  try
    Timetable2Controls(SpecialDays, Items);
    ShowModal;
    if ModalResult <> mrOk then
      Exit;
    Controls2Timetable(SpecialDays, Items);
  finally
    Free;
  end;
  WriteTimetable(SpecialDays, Items);
end;

procedure TfrmMain.WriteTimetable(SpecialDays : ITSSServCont_TimetableSpecialDayList;
                                 Items: ITSSServCont_TimetableItemList);
Begin
  FSc.cntWriteTimetable(ChannelId, ControllerAddr, SpecialDays, Items);
  Maintain;
end;

procedure TfrmMain.ReadTimetable(Out SpecialDays : ITSSServCont_TimetableSpecialDayList;
                                 Out Items: ITSSServCont_TimetableItemList);
Begin
  FSc.cntReadTimetable(ChannelId, ControllerAddr, SpecialDays, Items);
  Maintain;
end;

procedure TfrmMain.actControllerTimetableEraseExecute(Sender: TObject);
begin
  FSc.cntTimetableErase(ChannelId, ControllerAddr);
  Maintain;
end;

procedure TfrmMain.actControllerRestartProgExecute(Sender: TObject);
begin
  FSc.cntRestartProg(ChannelId, ControllerAddr);
  Maintain;
end;

procedure TfrmMain.Button25Click(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to pgcEvents.PageCount - 1 do
    ClearGrid( pgcEvents.Pages[i].Controls[0] as TStringGrid );
  sttRecCnt.Caption := '0';
end;

function TfrmMain.ChannelEvent(Grid: TStringGrid; ChannelID : String; EventTime : ITSSServCont_ServcontDateTime): Integer;
begin
  Result := AddGridRow(Grid);
  pgcEventsChange(pgcEvents);
  Grid.Cells[0, Result] := ChannelID;
  Grid.Cells[1, Result] := Timestamp2Str(EventTime);
end;

function TfrmMain.ChannelErrorEvent(Grid: TStringGrid;
  aClass, aMessage : String; Row: Integer): Integer;
begin
  Grid.Cells[2, Row] := aClass;
  Grid.Cells[3, Row] := aMessage;
  Result := Row;
end;

procedure TfrmMain.pgcEventsChange(Sender: TObject);
begin
  sttRecCnt.Caption := IntToStr((pgcEvents.ActivePage.Controls[0] as TStringGrid).RowCount - 2);
end;

procedure TfrmMain.actControllerEraseAllEventsExecute(Sender: TObject);
begin
  FSc.cntEraseAllEvents(ChannelId, ControllerAddr);
  Maintain;
end;

procedure TfrmMain.actControllerEventsInfoExecute(Sender: TObject);
var Capacity: Integer;
    Count: Integer;
Begin
  FSc.cntEventsInfo(ChannelId, ControllerAddr, Capacity, Count);
  ShowMessage( Format('Capacity = %d'#13#10'Count = %d', [Capacity, Count]) );

  Maintain;
end;

procedure TfrmMain.actControllerKeysInfoExecute(Sender: TObject);
var Capacity: Integer;
    Count: Integer;
Begin
  FSc.cntKeysInfo(ChannelId, ControllerAddr, Capacity, Count);
  ShowMessage( Format('Capacity = %d'#13#10'Count = %d', [Capacity, Count]) );

  Maintain;
end;

procedure TfrmMain.actControllerPortsInfoExecute(Sender: TObject);
var Ports: ITSSServCont_ControllerPorts;
Begin
  FSc.cntPortsInfo(ChannelId, ControllerAddr, Ports);
  ShowMessage(ControllerPorts2Str(Ports));
  Maintain;
end;

procedure TfrmMain.actControllerGenerateTimerEventsExecute(
  Sender: TObject);
var S : String;
Begin
  if InputQuery('Count', '1 .. 65535', s) then
    FSc.cntGenerateTimerEvents(ChannelId, ControllerAddr, StrToInt(s));
  Maintain;
end;

procedure TfrmMain.actControllerEditKeypadExecute(Sender: TObject);
var KeypadItems: ITSSServCont_KeypadItems;
Begin
  FSc.cntReadKeypad(ChannelId, ControllerAddr, KeypadItems);
  with TfrmKeypad.Create(Self) do
    try
      Data2Controls(KeypadItems);
      ShowModal;
      if ModalResult = mrOk then begin
        Controls2Data(KeypadItems);
        FSc.cntWriteKeypad(ChannelId, ControllerAddr, KeypadItems);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.actServcontChannelListExecute(Sender: TObject);
var Data: ITSSServCont_ChannelList;
Begin
  FSc.srvChannelList(Data);

  ShowMessage(IntToStr(Data.Count));
end;

procedure TfrmMain.actServcontControllerListExecute(Sender: TObject);
var Data: ITSSServCont_ControllerList;
Begin
  FSc.srvControllerList(ChannelId, Data);
  ShowMessage(IntToStr(Data.Count));
end;

procedure TfrmMain.actServcontClientListExecute(Sender: TObject);
var Data: ITSSServCont_ClientList;
Begin
  FSc.srvClientList(Data);
  ShowMessage(IntToStr(Data.Count));
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;


procedure TfrmMain.actServcontSwitchToAutoExecute(Sender: TObject);
Begin
  FSc.srvSwitchToAuto;
end;

procedure TfrmMain.actControllerGenerateKeyBaseExecute(Sender: TObject);
var
  Start: DWORD;
  Capacity, Count : Integer;
  KL : ITSSServCont_KeyList;
  K : ITSSServCont_ControllerKey;
  V : ITSSServCont_ControllerKeyValue;
  P : ITSSServCont_ControllerPorts;
  I, J : Integer;
begin
  Start := GetTickCount;

  FSc.cntKeysInfo(ChannelId, ControllerAddr, Capacity, Count);

  KL := CoTSSServCont_KeyListX.Create;
  KL.Count := min(255, Capacity - Count);
  For I := 0 to KL.Count - 1 do Begin
    K := KL.Items[I];
    K.PersCat := 16;
    P := K.Ports;
    For J := 0 to P.Count - 1 do
      P.P[J] := True;
    K.SuppressDoorEvent := false;
    K.OpenEvenComplex := false;
    K.IsSilent := false;
    V := K.Value;
    For J := 0 to V.Count - 1 do
      V.B[J] := I;
  end;
  FSc.cntWriteAllKey(ChannelId, ControllerAddr, KL  );


  FSc.cntGenerateKeyBase(ChannelId, ControllerAddr);
  ShowMessage(Format('%d seconds.', [(GetTickCount - Start) div 1000]));
end;

procedure TfrmMain.actControllerReadAllChipsExecute(Sender: TObject);
var Ports: ITSSServCont_ControllerPorts;
    ChipsList: ITSSServCont_ControllerChipList;
    J, I : Integer;
    y: Integer;
    chb: TCheckBox;
    Chips : ITSSServCont_ControllerChip;
Begin
  FSc.cntReadAllChips(ChannelId, ControllerAddr, Ports, ChipsList);

  ClearGrid(frmChips.Grid);
  if ChipsList.Count <> 0 then begin
    with frmChips do begin
      StatusBar.SimpleText := 'Chips read: ' + IntToStr(ChipsList.Count);
      Grid.RowCount := ChipsList.Count + 2;
      //Chips := r.vString['Chips'];
      for j:=0 to Ports.Count - 1 do begin
        chb := FindComponent('chbPort' + IntToStr(j+1)) as TCheckBox;
        Assert(chb <> nil);
        chb.Checked := Ports.P[j];
      end;
      for i:=0 to ChipsList.Count - 1 do begin
        y := i + 1;
        Chips := ChipsList.Items[I];
        Grid.Cells[0, y] := KeyToStr(Chips.Value );
        Grid.Cells[1, y] := BoolToStr(Chips.Active, True);
        Grid.Cells[2, y] := BoolToStr(Chips.OpenEvenComplex, True);
        Grid.Cells[3, y] := IntToStr(Chips.CheckCount);
        Grid.Cells[4, y] := IntToStr(Chips.Port);
      end;
    end;
  end else
    ShowMessage('No chips.');


  Maintain;
end;

procedure TfrmMain.Chips1Click(Sender: TObject);
begin
  frmChips := TfrmChips.Create(nil);
  try
    frmChips.ShowModal;
  finally
    frmChips.Free;
  end;
end;

procedure TfrmMain.actControllerWriteAllChipsExecute(Sender: TObject);
var
  Ports : ITSSServCont_ControllerPorts;
  Chips : ITSSServCont_ControllerChipList;
begin
  Ports := CoTSSServCont_ControllerPortsX.Create;
  Chips := CoTSSServCont_ControllerChipListX.Create;
  frmChips.Controls2Data(Ports, Chips);
  if Chips.Count < 1 then begin
    frmChips.StatusBar.SimpleText := 'Chips written: ' + IntToStr(0);
    Exit;
  end;
  FSc.cntWriteAllChips(ChannelId, ControllerAddr, Ports, Chips);
  frmChips.StatusBar.SimpleText := 'Chips written: ' + IntToStr(Chips.Count);
end;

procedure TfrmMain.actControllerActivateChipExecute(Sender: TObject);
begin
  FSc.cntActivateChip(ChannelId, ControllerAddr, StrToKey(frmChips.Grid.Cells[0, frmChips.Grid.Row]));
end;

procedure TfrmMain.actControllerDeactivateChipExecute(Sender: TObject);
begin
  FSc.cntDeactivateChip(ChannelId, ControllerAddr, StrToKey(frmChips.Grid.Cells[0, frmChips.Grid.Row]));

end;

procedure TfrmMain.actControllerEraseAllChipsExecute(Sender: TObject);
Begin
  FSc.cntEraseAllChips(ChannelId, ControllerAddr);
end;

procedure TfrmMain.actServcontMainClientExecute(Sender: TObject);
Begin
  FSc.srvMainClient(chbLogControllerEvents.Checked, StrToInt(cbxQueueLimit.Text) );
end;

procedure TfrmMain.actServcontCoEvtLogSendExecute(Sender: TObject);
var Count : Integer;
    BeginInt, EndInt :  ITSSServCont_ServcontDateTime;
Begin
  BeginInt := CoTSSServCont_ServcontDateTimeX.Create;


    BeginInt.Year := 0;  BeginInt.Hour := 0;
    BeginInt.Month := 0; BeginInt.Minute := 0;
    BeginInt.Day := 0;  BeginInt.Second := 0;


  EndInt := CoTSSServCont_ServcontDateTimeX.Create;

    EndInt.Year := 99;  EndInt.Hour := 99;
    EndInt.Month := 99; EndInt.Minute := 99;
    EndInt.Day := 99;  EndInt.Second := 99;

  FSc.srvCoEvtLogSend(BeginInt, EndInt, 1000, -1,  Count );
  ShowMessage(IntToStr(Count));
end;

procedure TfrmMain.actServcontCoEvtLogClearExecute(Sender: TObject);
Begin
  FSc.srvCoEvtLogClear;
end;

procedure TfrmMain._OnClientsChangedEvent(ASender: TObject;
  const Time: ITSSServCont_ServcontDateTime);
var
  x: Integer;
begin
  x := AddGridRow(sgdClientsChanged);
  sgdClientsChanged.Cells[0, x] := Timestamp2Str(Time);
end;

procedure TfrmMain._OnCont220VEvent(ASender: TObject; const ChannelId: WideString;
  const Event: ITSSServCont_ControllerEvent);
begin
  ControllerEvent(sgd220V, ChannelId, Event);
end;

procedure TfrmMain._OnContAutoTimeoutEvent(ASender: TObject;
  const ChannelId: WideString; const Event: ITSSServCont_ControllerEvent);
begin
  ControllerEvent(sgdAutoTimeout, ChannelId, Event);
end;

procedure TfrmMain._OnContButtonEvent(ASender: TObject;
  const ChannelId: WideString;
  const Event: ITSSServCont_ControllerPortRelayEvent);
var
  x: Integer;
begin
  x := ControllerEvent(sgdButton, ChannelId, Event.ControllerPortEvent.ControllerEvent);
  ControllerPortEvent(sgdButton, Event.ControllerPortEvent);
  ControllerPortRelayEvent(sgdButton, Event);
  sgdButton.Cells[8, x] := BoolToStr(Event.IsOpen, True);
end;

procedure TfrmMain._OnContCaseEvent(ASender: TObject;
  const ChannelId: WideString; const Event: ITSSServCont_ControllerEvent);
begin
  ControllerEvent(sgdCase, ChannelId, Event);
end;

procedure TfrmMain._OnContChangedEvent(ASender: TObject;
  const ChannelId: WideString; const Time: ITSSServCont_ServcontDateTime);
Begin
  ChannelEvent(sgdControllersChanged, ChannelId, Time);
end;

procedure TfrmMain._OnContChangeStateEvent(ASender: TObject;
  const ChannelId: WideString; ControllerAddr: Integer;
  const Time: ITSSServCont_ServcontDateTime;
  State: TTSSServCont_ControllerState);
var
  x: Integer;
begin
  x := ChannelEvent(sgdControllerState, ChannelId, Time);
  sgdControllerState.Cells[2, x] := IntToStr(ControllerAddr);
  Case State Of
    csNone : sgdControllerState.Cells[3, x] := 'csNone';
    csStateless : sgdControllerState.Cells[3, x] := 'csStateless';
    csAutonomicPolling : sgdControllerState.Cells[3, x] := 'csAutonomicPolling';
    csComplex : sgdControllerState.Cells[3, x] := 'csComplex';
    else sgdControllerState.Cells[3, x] := IntToStr(State);
  end;
end;

procedure TfrmMain._OnContChannelChangedEvent(ASender: TObject;
  const Time: ITSSServCont_ServcontDateTime);
var
  x: Integer;
begin
  x := AddGridRow(sgdChannelsChanged);
  sgdChannelsChanged.Cells[0, x] := Timestamp2Str(Time);
end;

procedure TfrmMain._OnContChannelErrorEvent(ASender: TObject;
  const ChannelId: WideString; const Time: ITSSServCont_ServcontDateTime;
  const EClass, EMessage: WideString);
var x : Integer;
begin
  x := ChannelEvent(sgdChannelError, ChannelId, Time);
  ChannelErrorEvent(sgdChannelError, EClass, EMessage, x)
end;

procedure TfrmMain._OnContChannelPollSpeedEvent(ASender: TObject;
  const ChannelId: WideString; const Time: ITSSServCont_ServcontDateTime;
  Value: Integer);
var
  x: Integer;
begin
  x := ChannelEvent(sgdChannelPollSpeed, ChannelId, Time);
  sgdChannelPollSpeed.Cells[2, x] := IntToStr(Value);
end;

procedure TfrmMain._OnContChannelStateEvent(ASender: TObject;
  const ChannelId: WideString; const Time: ITSSServCont_ServcontDateTime;
  IsReady: WordBool);
var
  x: Integer;
begin
  x := ChannelEvent(sgdChannelState, ChannelId, Time);
  ChReady := IsReady;
  sgdChannelState.Cells[2, x] := BoolToStr(ChReady, True);
end;

procedure TfrmMain._OnContDoorCloseEvent(ASender: TObject;
  const ChannelId: WideString;
  const Event: ITSSServCont_ControllerPortRelayEvent);
begin
  ControllerEvent(sgdDoorClose, ChannelId, Event.ControllerPortEvent.ControllerEvent);
  ControllerPortEvent(sgdDoorClose, Event.ControllerPortEvent);
  ControllerPortRelayEvent(sgdDoorClose, Event);
end;

procedure TfrmMain._OnContDoorOpenEvent(ASender: TObject;
  const ChannelId: WideString;
  const Event: ITSSServCont_ControllerPortRelayEvent);
begin
  ControllerEvent(sgdDoorOpen, ChannelId, Event.ControllerPortEvent.ControllerEvent);
  ControllerPortEvent(sgdDoorOpen, Event.ControllerPortEvent);
  ControllerPortRelayEvent(sgdDoorOpen, Event);
end;

procedure TfrmMain._OnContErrorEvent(ASender: TObject;
  const ChannelId: WideString; const Time: ITSSServCont_ServcontDateTime;
  const EClass, EMessage: WideString; Addr: Integer);
var
  x: Integer;
begin
  x := ChannelEvent(sgdControllerError, ChannelId, Time);
  ChannelErrorEvent(sgdControllerError, EClass, EMessage, x);
  sgdControllerError.Cells[4, x] := IntToStr(Addr);
end;

procedure TfrmMain._OnContKeyEvent(ASender: TObject;
  const ChannelId: WideString;
  const Event: ITSSServCont_ControllerKeyEvent);
var
  x: Integer;
begin
  x := ControllerEvent(sgdKey, ChannelId, Event.ControllerPortRelayEvent.ControllerPortEvent.ControllerEvent);
  ControllerPortEvent(sgdKey, Event.ControllerPortRelayEvent.ControllerPortEvent);
  ControllerPortRelayEvent(sgdKey, Event.ControllerPortRelayEvent);
  with sgdKey, Event do begin
    Cells[9, x] := KeyToStr(Key);
    Cells[10, x] := BoolToStr(IsTimeRestrict, True);
    Cells[11, x] := BoolToStr(IsTimeRestrictDone, True);
    Cells[12, x] := BoolToStr(IsAccessGranted, True);
    Cells[13, x] := BoolToStr(IsKeyFound, True);
    Cells[14, x] := BoolToStr(IsKeySearchDone, True);
  end;
end;

procedure TfrmMain._OnContRestartEvent(ASender: TObject;
  const ChannelId: WideString; const Event: ITSSServCont_ControllerEvent);
begin
  ControllerEvent(sgdRestart, ChannelId, Event);
end;

procedure TfrmMain._OnContStartEvent(ASender: TObject;
  const ChannelId: WideString; const Event: ITSSServCont_ControllerEvent);
begin
  ControllerEvent(sgdStart, ChannelId, Event);
end;

procedure TfrmMain._OnContStaticSensorEvent(ASender: TObject;
  const ChannelId: WideString;
  const Event: ITSSServCont_ControllerStaticSensorEvent);
begin
  sgdSensor.Cells[7, ControllerEvent(sgdSensor, ChannelId, Event.ControllerEvent)] :=
    IntToStr(Event.Value);
end;

procedure TfrmMain._OnContTimerEvent(ASender: TObject;
  const ChannelId: WideString; const Event: ITSSServCont_ControllerEvent);
begin
  ControllerEvent(sgdTimer, ChannelId, Event);
end;

procedure TfrmMain._OnQueueFullEvent(ASender: TObject;
  const Time: ITSSServCont_ServcontDateTime);
var x: Integer;
begin
  x := AddGridRow(sgdQueueFull);
  sgdQueueFull.Cells[0, x] := Timestamp2Str(Time);
end;

procedure TfrmMain.actServcontSetHostClockExecute(Sender: TObject);
var
  Today:  ITSSServCont_ServcontDateTime;
Begin
  Today := CoTSSServCont_ServcontDateTimeX.Create;
  Now2DateTimeIntf(Today);
  FSc.srvSetHostClock(Today);
end;

function TfrmMain.ChannelId: string;
begin
  if pgcChannel.ActivePage = tbsRs422 then
    Result := 'DVRS422'
  else if pgcChannel.ActivePage = tbsIp then
    Result := cbxChannelIPHost.Text + ':' + cbxChannelIPPort.Text
  else
    Result := cbxChannelSerialPort.Text;
end;

end.
