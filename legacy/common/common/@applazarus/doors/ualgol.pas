unit ualgol;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,SQLDB,
  DBGrids, Menus,umain,uglink;

type

  { Tformalgol }

  Tformalgol = class(TForm)
    ds1: TDataSource;
    DBGrid1: TDBGrid;
    md: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    pop1: TPopupMenu;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure readalgol;
    procedure clearlog;
  private

  public

  end;

var
  formalgol: Tformalgol;
  myid:integer;
  descr,acts,name,cerr,abrv:string;
  act:boolean;

implementation

{$R *.lfm}

{ Tformalgol }

procedure Tformalgol.clearlog;
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

procedure  Tformalgol.readalgol;
var
  qrz: TSQLQuery;
  s: string;
  n: integer;
begin
  try
    s := 'select actual,myid,descr,name,cerr,abrv from tss_algol order by num';
    //s := 'select *  from tss_algol order by num';
    form1.log('y', 's=' + s);
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(s);
    md.open;
     clearlog;
    qrz.Active := True;
    while not qrz.eof do begin
     acts := qrz.FieldByName('actual').Asstring;
     name := qrz.FieldByName('name').Asstring;
     cerr := trim(qrz.FieldByName('cerr').Asstring);
    // if cerr<> '' then showmessage('cerr='+cerr);

     abrv := qrz.FieldByName('abrv').Asstring;
     act := qrz.FieldByName('actual').Asboolean;
     myid := qrz.FieldByName('myid').Asinteger;
     form1.log('y', 'myid=' + inttostr(myid));
     descr := qrz.FieldByName('descr').Asstring;
     md.Insert;
     md.FieldByName('myid').AsInteger:=myid;
     md.FieldByName('actual').Asboolean:=act;
     md.FieldByName('descr').asstring:=descr;
     md.FieldByName('name').asstring:=name;
     md.FieldByName('cerr').asstring:=cerr;
     md.FieldByName('abrv').asstring:=abrv;
     qrz.Next;
    end;
    md.post;
    vglink.qrx := qrz;
    exit;
  except
    on ee: Exception do
    begin
     form1.log('e', 'getlastmyid ,ee=' + ee.Message);
    end;
  end;
end;




procedure Tformalgol.DBGrid1CellClick(Column: TColumn);
var
  a:string;
  act:boolean;
begin
      if column.FieldName='actual' then begin
       acts:=md.FieldByName('actual').asstring;
       form1.log('l','a='+a);

      end;
end;

procedure Tformalgol.MenuItem1Click(Sender: TObject);
begin
      readalgol;
end;

procedure Tformalgol.MenuItem2Click(Sender: TObject);
var
  s:string;
begin
      myid:=md.FieldByName('myid').AsInteger;
      acts:=md.FieldByName('actual').asstring;
      descr:=md.FieldByName('descr').asstring;
      s:='update tss_algol set actual='+acts +zp+' descr='+ap+descr+ap+' where myid='+inttostr(myid);
      form1.log('l','s='+s);
      form1.selfupd(s);
end;

end.

