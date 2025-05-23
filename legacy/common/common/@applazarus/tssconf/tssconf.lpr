program tssconf;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, memdslaz, umain, uallog, ualfunc, ueditnewshab;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tformallog, formallog);
  Application.CreateForm(Tformeditnewshab, formeditnewshab);
  Application.Run;
end.

