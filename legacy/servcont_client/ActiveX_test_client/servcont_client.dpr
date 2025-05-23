program servcont_client;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {frmMain},
  DateTimeFrm in 'DateTimeFrm.pas' {frmDateTime},
  KeysFrm in 'KeysFrm.pas' {frmKeys},
  TimetableFrm in 'TimetableFrm.pas' {frmTimetable},
  KeypadFrm in 'KeypadFrm.pas' {frmKeypad},
  ChipsFrm in 'ChipsFrm.pas' {frmChips},
  BFServCont_TLB in 'BFServCont_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
