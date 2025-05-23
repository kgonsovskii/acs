unit uformeditch;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, DBGrids,
  Menus, SQLDB, umain;

type

  { Tformeditch }

  Tformeditch = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    md: TMemDataset;
    MenuItem1: TMenuItem;
    pop1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure editch(d:pvstrecord);
    procedure MenuItem1Click(Sender: TObject);
  private

  public

  end;

var
  formeditch: Tformeditch;

implementation

{$R *.lfm}
uses uglink;

{ Tformeditch }
procedure Tformeditch.editch(d:pvstrecord);
var
s,ch,app,acts,myid,chtype:string;
rc:umain.trcfld;
act:boolean;
begin
     showmessage('editch start');
     myid:=inttostr(d^.dbmyid);
     s:='select actual from tss_ch where myid='+myid;
     rc:=form1.readfld(s);
     acts:=rc.value;
     if lowercase(acts)='true' then act:=true else act:=false;

     s:='select ch from tss_ch where myid='+myid;
     rc:=form1.readfld(s);
     ch:=rc.value;

     s:='select app from tss_ch where myid='+myid;
     rc:=form1.readfld(s);
     app:=rc.value;

     s:='select chtype from tss_ch where myid='+myid;
     rc:=form1.readfld(s);
     chtype:=rc.value;



     form1.log('l','nm0='+d^.nm0);
     md.Open;
     md.Clear(false);
     md.insert;
     md.FieldByName('actual').AsBoolean:=act;
     md.FieldByName('app').Asstring:=app;
     md.FieldByName('ch').Asstring:=ch;
     md.FieldByName('chtype').Asstring:=chtype;
     md.FieldByName('myid').Asinteger:=strtoint(myid);
     md.post;


end;

procedure Tformeditch.MenuItem1Click(Sender: TObject);
var
s,ch,app,acts,myid,chtype:string;
rc:umain.trcfld;
act:boolean;
begin
        try md.post; except end;
        acts:=md.FieldByName('actual').asstring;
        myid:=md.FieldByName('myid').asstring;
        app:=md.FieldByName('app').Asstring;
        ch:=md.FieldByName('ch').Asstring;
        chtype:=md.FieldByName('chtype').Asstring;
        s:='update tss_ch set actual='+acts+zp+
           ' app='+ap+app+ap+zp+
           ' ch='+ap+ch+ap+zp+
           ' chtype='+ap+chtype+ap+
           ' where myid='+myid;
       form1.log('l','s='+s) ;
       form1.selfupd(s);
end;

procedure Tformeditch.FormCreate(Sender: TObject);
begin
      left:=50 ;top:=200;
end;

end.

