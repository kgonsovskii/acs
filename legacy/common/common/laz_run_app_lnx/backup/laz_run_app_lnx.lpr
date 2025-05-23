program laz_run_app_lnx;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp, Unix
  { you can add units after this };

type

  { TRunApp }

  TRunApp = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TRunApp }

procedure TRunApp.DoRun;
var
  ErrorMsg: String;
begin
  {
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;
  }

  { add your program here }

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end // if HasOption('h', 'help')
  else begin
    if HasOption('r', 'run') then begin
      WriteLn(format('OK! => %s',[getOptionValue('r', 'run')]));
      fpsystem(getOptionValue('r', 'run'));
    end
    else begin
      WriteHelp;
    end;
  end; // else: if HasOption('h', 'help')

  // stop program loop
  Terminate;
end;

constructor TRunApp.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TRunApp.Destroy;
begin
  inherited Destroy;
end;

procedure TRunApp.WriteHelp;
begin
  { add your help code here }
  writeln(' === Usage: ', ExeName, ' -r "./myapp -p1 param1 -p2 param2"');
end;

var
  Application: TRunApp;
begin
  Application:=TRunApp.Create(nil);
  Application.Title:='Lazarus Run Application Linux';
  Application.Run;
  Application.Free;
end.

