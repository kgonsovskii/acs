program doors;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, memdslaz, lazcontrols, umain, uformstarter, uglink, TSSMQTTC,
  brokerunit, mqttclass, uallog, ualfunc, udtrans, uwwcomp, uwwac, uformhelp,
  uformalnewloc, ualnewlocsens, uformimportff, umars1, uformvst2, uformeditch,
  uwwch, ulocm5, uemul, rxnew, ushowmes;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tformallog, formallog);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tdmmqt, dmmqt);
  Application.CreateForm(Tformstarter, formstarter);
  Application.CreateForm(Tformglink, formglink);
  Application.CreateForm(Tformwwcomp, formwwcomp);
  Application.CreateForm(Tformwwac, formwwac);
  Application.CreateForm(Tforhelp, forhelp);
  Application.CreateForm(Tformalnewloc, formalnewloc);
  Application.CreateForm(Tformalnewlocsens, formalnewlocsens);
  Application.CreateForm(Tformimportff, formimportff);
  Application.CreateForm(Tformmars1, formmars1);
  Application.CreateForm(Tformvst2, formvst2);
  Application.CreateForm(Tformeditch, formeditch);
  Application.CreateForm(Tformwwch, formwwch);
  Application.CreateForm(Tformlocm5, formlocm5);
  Application.CreateForm(Tformshowmes, formshowmes);
  //Application.CreateForm(Tformeditall, formeditall);
  Application.Run;
end.

