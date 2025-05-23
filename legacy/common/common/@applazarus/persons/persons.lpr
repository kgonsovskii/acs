program persons;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, memdslaz, lazcontrols, datetimectrls, umain, uallog, ushemanode,
  uformstarter, upgs, ulazfunc, uperskeys, uname1, uname2, uglsnames, uboxpas,
  upersdata, rxnew, utmzvst, undgrf, upers1;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tformallog, formallog);
  Application.CreateForm(Tformpgs, formpgs);
  Application.CreateForm(Tformshemanode, formshemanode);
  Application.CreateForm(Tformstarter, formstarter);
  Application.CreateForm(Tdmfunc, dmfunc);
  Application.CreateForm(Tformpersids, formpersids);
  Application.CreateForm(Tformname1, formname1);
  Application.CreateForm(Tformname2, formname2);
  Application.CreateForm(Tformglsnames, formglsnames);
  Application.CreateForm(Tformbox, formbox);
  Application.CreateForm(Tpersdata, persdata);
  Application.CreateForm(Tformtmzvst, formtmzvst);
  Application.CreateForm(Tformindgrf, formindgrf);
  Application.CreateForm(Tform_pers1, form_pers1);
  Application.Run;
end.

