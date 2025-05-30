unit UOption;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SIntProc2, Mask, IniFiles;

type
  TFOption = class(TForm)
    Panel1: TPanel;
    CKEY: TCheckBox;
    CKEYA: TCheckBox;
    CRTE: TCheckBox;
    CRTEA: TCheckBox;
    CSPEC: TCheckBox;
    Label1: TLabel;
    CSTART: TCheckBox;
    CVOLT: TCheckBox;
    CDSTR: TCheckBox;
    CWDOG: TCheckBox;
    CSym: TCheckBox;
    CHex: TCheckBox;
    Label2: TLabel;
    CH1: TCheckBox;
    CH2: TCheckBox;
    CH3: TCheckBox;
    CH4: TCheckBox;
    CH5: TCheckBox;
    CH6: TCheckBox;
    CH7: TCheckBox;
    CH8: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    CRKEY: TCheckBox;
    CRKEYA: TCheckBox;
    CRRTE: TCheckBox;
    CRRTEA: TCheckBox;
    Label5: TLabel;
    Panel3: TPanel;
    CDATA: TCheckBox;
    Label6: TLabel;
    ETime: TEdit;
    StaticText1: TStaticText;
    EN: TMaskEdit;
    EK: TMaskEdit;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Panel4: TPanel;
    CheckTimer: TCheckBox;
    Label7: TLabel;
    CDisk: TCheckBox;
    Panel5: TPanel;
    Label8: TLabel;
    eTimeOut: TEdit;
    Timer1: TTimer;
    Panel6: TPanel;
    Label9: TLabel;
    EDisc: TEdit;
    Panel7: TPanel;
    Label10: TLabel;
    EErrCnt: TEdit;
    Panel8: TPanel;
    Label11: TLabel;
    Edit1: TEdit;
    ERecTimer: TEdit;
    procedure CSymClick(Sender: TObject);
    procedure CHexClick(Sender: TObject);
    procedure CDiskClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure eTimeOutChange(Sender: TObject);
    procedure EDiscChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure WiewEvent(Kuda : TMemo; S : string; SH : string);
  procedure WiewString(S : string);

var
  FOption: TFOption;
  FIni : TIniFile;
  Flash : boolean;

implementation
uses UNTest;

{$R *.DFM}

procedure WiewString(S : string);
begin
  Form1.M1.Lines.Add(TimeToStr(Time)+'  '+S);
  if FOption.CDisk.Checked then
   begin
    WriteLn(LogFile,TimeToStr(Time)+'  '+S);
    Flush(LogFile);
   end;
end;


procedure WiewEvent(Kuda : TMemo; S : string; SH : string);
var
 Key : string;
 Port : word;
 Cntr : word;
 EvType, EvKey : string;
 CName : string;
 Check : TCheckBox;
 Res1, Res2   : string;
 H,M,Sec,MSec : word;
 H1,M1,Sec1,MSec1 : word;
 F : boolean;
begin
 EvType := DCGetType(S);
WITH FOption DO
BEGIN
 if (EvType = 'START') and not CSTART.Checked then exit;
 if (EvType = 'VOLT')  and not CVOLT.Checked  then exit;
 if (EvType = 'DSTR')  and not CDSTR.Checked  then exit;
 if (EvType = 'WDOG')  and not CWDOG.Checked  then exit;
 if (EvType = 'SPEC')  and not CSPEC.Checked  then exit;
 if (EvType = 'KEY')   and not CKEY.Checked   then exit;
 if (EvType = 'KEYA')  and not CKEYA.Checked  then exit;
 if (EvType = 'RTE')   and not CRTE.Checked   then exit;
 if (EvType = 'RTEA')  and not CRTEA.Checked  then exit;
 if (EvType = 'DATA')  and not CDATA.Checked  then exit;

 if (EvType = 'KEY')or(EvType = 'KEYA')or(EvType = 'RTE')
            or(EvType = 'RTEA')or(EvType = 'DATA') then
      begin  //  ¿Õ¿À‹Õ€≈ —Œ¡€“»ﬂ
       Port := DCGetPort(S);
       Cntr := DCGetController(S);
       CName := 'CH'+IntToStr(Port);
       Check := FindComponent(CName) as TCheckBox;
       if not Check.Checked then exit;
      end;

  if CSym.Checked then Res1 := S  else Res1 := '';
  if CHex.Checked then Res2 := SH else Res2 := '';
  Kuda.Lines.Add(TimeToStr(Time)+'  '+Res1+'  '+Res2);
  if CDisk.Checked then
   begin
    WriteLn(LogFile,TimeToStr(Time)+'  '+Res1+'  '+Res2);
    Flush(LogFile);
   end;


  if (EvType = 'KEY')   and CRKEY.Checked   then Cnt.RelayON(Cntr,Port,StrToInt(ETime.Text));
  if (EvType = 'KEYA')  and CRKEYA.Checked  then Cnt.RelayON(Cntr,Port,StrToInt(ETime.Text));
  if (EvType = 'RTE')   and CRRTE.Checked   then Cnt.RelayON(Cntr,Port,StrToInt(ETime.Text));
  if (EvType = 'RTEA')  and CRRTEA.Checked  then Cnt.RelayON(Cntr,Port,StrToInt(ETime.Text));


END;
end;

procedure TFOption.CSymClick(Sender: TObject);
begin
  if not CSym.Checked and not CHex.Checked then CSym.Checked := True;
end;

procedure TFOption.CHexClick(Sender: TObject);
begin
  if not CSym.Checked and not CHex.Checked then CHex.Checked := True;
end;

procedure TFOption.CDiskClick(Sender: TObject);
begin
  if CDisk.Checked then
   begin
    if FileExists('Test.log') then
     begin
      AssignFile(LogFile,'Test.log');
      Append(LogFile);
     end
    else
     begin
      AssignFile(LogFile,'Test.log');
      Rewrite(LogFile);
     end;
   end
  else CloseFile(LogFile);
end;

procedure TFOption.FormCreate(Sender: TObject);
begin
try
  FIni := TIniFile.Create('Test.ini');
  EN.Text := FIni.ReadString('OPTION','LOWADDRESS','1');
  EK.Text := FIni.ReadString('OPTION','HIGHADDRESS','254');

  if CDisk.Checked then
   begin
    if FileExists('Test.log') then
     begin
      AssignFile(LogFile,'Test.log');
      Append(LogFile);
     end
    else
     begin
      AssignFile(LogFile,'Test.log');
      Rewrite(LogFile);
     end;
   end
  else CloseFile(LogFile);
 except

 end;
end;

procedure TFOption.FormActivate(Sender: TObject);
begin
  EN.Text := FIni.ReadString('OPTION','LOWADDRESS','1');
  EK.Text := FIni.ReadString('OPTION','HIGHADDRESS','254');
end;

procedure TFOption.FormDeactivate(Sender: TObject);
begin
  FIni.WriteString('OPTION','LOWADDRESS',EN.Text);
  FIni.WriteString('OPTION','HIGHADDRESS',EK.Text);
end;

procedure TFOption.Timer1Timer(Sender: TObject);
begin
  FlashWindow(FOption.Handle, Flash);
 // FlashWindow(Application.Handle, Flash);
  Flash := not Flash;

end;

procedure TFOption.eTimeOutChange(Sender: TObject);
begin
  try
   FTimeOut := StrToInt(eTimeOut.Text);
  except
   eTimeOut.Text := '2';
  end;
end;

procedure TFOption.EDiscChange(Sender: TObject);
begin
  try
   FDisc := StrToInt(EDisc.Text);
  except
   EDisc.Text := '1';
  end;
end;

end.
