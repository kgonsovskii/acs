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
  brokerunit, mqttclass, uallog, ualfunc, udtrans, uwwcomp, uwwch, uwwac,
  uformhelp, uformalnewloc, ualnewlocsens, uformimportff, umars1, rxnew,
  uacslog, usyslog, uconfs, ulocm5, uloc2, uformvst2, uemul, upanmenu, uvdtmenu,
  ualgol, uformeditch, uformeditcomp, uformedittmz, uformlistpers;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tdmmqt, dmmqt);
  Application.CreateForm(Tformstarter, formstarter);
  Application.CreateForm(Tformglink, formglink);
  Application.CreateForm(Tformallog, formallog);
  Application.CreateForm(Tformwwcomp, formwwcomp);
  Application.CreateForm(Tformwwch, formwwch);
  Application.CreateForm(Tformwwac, formwwac);
  Application.CreateForm(Tforhelp, forhelp);
  Application.CreateForm(Tformalnewloc, formalnewloc);
  Application.CreateForm(Tformalnewlocsens, formalnewlocsens);
  Application.CreateForm(Tformimportff, formimportff);
  Application.CreateForm(Tformmars1, formmars1);
  Application.CreateForm(Tformsyslog, formsyslog);
  Application.CreateForm(Tformcnfs, formcnfs);
  Application.CreateForm(Tformlocm5, formlocm5);
  Application.CreateForm(Tformloc2, formloc2);
  Application.CreateForm(Tformvst2, formvst2);
  Application.CreateForm(Tformemul, formemul);
  Application.CreateForm(Tformpanmenu, formpanmenu);
  Application.CreateForm(Tformvdtmenu, formvdtmenu);
  Application.CreateForm(Tformalgol, formalgol);
  Application.CreateForm(Tformeditch, formeditch);
  Application.CreateForm(Tformeditcomp, formeditcomp);
  Application.CreateForm(Tformedittmz, formedittmz);
  Application.CreateForm(Tformlistpers, formlistpers);
  //Application.CreateForm(Tformeditall, formeditall);
  Application.Run;
end.

