unit uformlistpers;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, Menus,SQLDB;

type

  { Tformlistpers }

  Tformlistpers = class(TForm)
    dbg: TDBGrid;
    ds1: TDataSource;
    md: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    popowner: TPopupMenu;
    procedure MenuItem2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure readpersons(mymenu:string);
    procedure newreadpersons(mymenu:string);
    procedure clearmd;
    function  formirqrpers(line:string):tsqlquery;

  private

  public

  end;

var
  formlistpers: Tformlistpers;

implementation

{$R *.lfm}
uses umain,uglink,uloc2;

{ Tformlistpers }


procedure Tformlistpers.clearmd;
begin
      md.First;
      md.DisableControls;
      while not md.EOF do begin;
       md.Edit;
       md.Delete;
      end;
      try
       md.post;
      except
      end;
      md.EnableControls;
end;

function   Tformlistpers.formirqrpers(line:string):tsqlquery;
var
  s:string;
begin

end;

procedure Tformlistpers.newreadpersons(mymenu:string);
var
  qrz: TSQLQuery;
  s,kluch,fio,myid: string;
  n: integer;
begin


      if mymenu='owner' then begin
       dbg.PopupMenu:=popowner;
      end;

     qrz:=formirqrpers(s);
     exit;
  try
        s := 'select kl.kluch,ps.fio,ps.mrs,ps.ntmz,ps.myid  from '+
       ' tss_persons as ps,'+
       ' tss_keys as kl '+
       ' where ps.bpkeys=kl.myid '+
       ' order by fio';
    md.DisableControls;
    top:=0;
    left:=0;
    form1.log('y', 's=' + s);
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(s);
    md.open;
    clearmd;
    qrz.Active := True;
    while not qrz.eof do begin
     kluch := qrz.FieldByName('kluch').Asstring;
     fio := qrz.FieldByName('fio').Asstring;
     myid:= inttostr(qrz.FieldByName('myid').Asinteger);
     md.Insert;
     md.FieldByName('kluch').Asstring:=kluch;
     md.FieldByName('fio').Asstring:=fio;
     md.FieldByName('myid').Asinteger:=strtoint(myid);

     qrz.Next;
    end;
    md.post;
    md.First;
    md.EnableControls;
    vglink.qrx := qrz;
    exit;
  except
    on ee: Exception do
    begin
     form1.log('e', 'readpersons ,ee=' + ee.Message);
    end;
  end;
   md.EnableControls;
end;




procedure  Tformlistpers.readpersons(mymenu:string);
var
  qrz: TSQLQuery;
  s,kluch,fio,myid: string;
  n: integer;
begin


      if mymenu='owner' then begin
      dbg.PopupMenu:=popowner;
      end;

  try
    s := 'select kl.kluch,ps.fio,ps.mrs,ps.ntmz,ps.myid  from '+
       ' tss_persons as ps,'+
       ' tss_keys as kl '+
       ' where ps.bpkeys=kl.myid '+
       ' order by fio';
    md.DisableControls;
    top:=0;
    left:=0;
    form1.log('y', 's=' + s);
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(s);
    md.open;
    clearmd;
    qrz.Active := True;
    while not qrz.eof do begin
     kluch := qrz.FieldByName('kluch').Asstring;
     fio := qrz.FieldByName('fio').Asstring;
     myid:= inttostr(qrz.FieldByName('myid').Asinteger);
     md.Insert;
     md.FieldByName('kluch').Asstring:=kluch;
     md.FieldByName('fio').Asstring:=fio;
     md.FieldByName('myid').Asinteger:=strtoint(myid);

     qrz.Next;
    end;
    md.post;
    md.First;
    md.EnableControls;
    vglink.qrx := qrz;
    exit;
  except
    on ee: Exception do
    begin
     form1.log('e', 'readpersons ,ee=' + ee.Message);
    end;
  end;
   md.EnableControls;
end;


procedure Tformlistpers.Panel1Click(Sender: TObject);
begin

end;

procedure Tformlistpers.MenuItem2Click(Sender: TObject);
begin
         formloc2.leownerfio.Text:=md.FieldByName('fio').AsString;
         formloc2.lepersid.Text:=md.FieldByName('myid').AsString;
end;

end.

