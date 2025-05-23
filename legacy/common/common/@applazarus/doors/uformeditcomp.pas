unit uformeditcomp;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  umain, memds, DB;

type

  { Tformeditcomp }

  Tformeditcomp = class(TForm)
    DBGrid1: TDBGrid;
    ds: TDataSource;
    md: TMemDataset;
    MenuItem1: TMenuItem;
    pop1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure editcomp(d:pvstrecord);
    procedure MenuItem1Click(Sender: TObject);
  private

  public

  end;

var
  formeditcomp: Tformeditcomp;
  cd   :pvstrecord;
  cmyid:string;

implementation

{$R *.lfm}

{ Tformeditcomp }

procedure Tformeditcomp.editcomp(d:pvstrecord);
var
  pctyp,myid,acts:string;
  rc: umain.trcfld;
  act:boolean;
begin
     cd:=d;
     myid:=inttostr(d^.dbmyid);
       cmyid:=myid;
     rc:=form1.readfld('select pctyp from tss_comps where myid='+myid);
     pctyp:=rc.Value;

     rc:=form1.readfld('select actual from tss_comps where myid='+myid);
     acts:=rc.Value;
     if lowercase(acts)='true' then act:=true else act:=false;
     show;
     md.open;
     md.clear(false);
     md.insert;
     md.FieldByName('actual').Asboolean:=act;
     md.FieldByName('pctyp').AsString:=pctyp;
     md.FieldByName('name').AsString:=d^.nm0;
     md.FieldByName('url').AsString:=d^.host;
     md.Post;

end;

procedure Tformeditcomp.MenuItem1Click(Sender: TObject);
var
  s,acts,pctyp,nm,url:string;
begin
   acts:=md.FieldByName('actual').Asstring;
   pctyp:=md.FieldByName('pctyp').AsString;
   nm:=md.FieldByName('name').AsString;
   url:=md.FieldByName('url').AsString;
   s:='update tss_comps set actual='+acts+zp+
      '  pctyp='+ap+pctyp+ap+zp+
       ' name='+ap+nm+ap+zp+
       'url ='+ap+url+ap+
       ' where myid='+cmyid;
   form1.log('l','s='+s);
   form1.selfupd(s);


end;

procedure Tformeditcomp.FormCreate(Sender: TObject);
begin

end;

end.

