unit uloc2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, StdCtrls, Buttons,laz.virtualtrees,SQLDB,umain  ;

type

  { Tformloc2 }

  Tformloc2 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    cmb: TComboBox;
    ed_nameloc: TEdit;
    keyp4: TPanel;
    leownerfio: TLabeledEdit;
    lepersid: TLabeledEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure prepare(nd:pvirtualnode);

  private

  public

  end;

var
  formloc2: Tformloc2;
  cqrz: TSQLQuery;
  slc:tstringlist;
  ttg,cmyid :integer;
  cnd :pvirtualnode;



implementation

{$R *.lfm}
uses uglink,uformlistpers;

{ Tformloc2 }
procedure Tformloc2.prepare(nd:pvirtualnode);
var
  s,sc,cnm:string;
  dl:pvstrecordloc;
  n,ttg,loccode:integer;
  rc:trcfld;
begin
    // showmessage('preparestart');
     cnd:=nd;
     show;
     dl:=form1.vstloc.GetNodeData(nd);
     ed_nameloc.Text:=dl^.nm0;
     ttg:=dl^.tag;
     cmyid:=dl^.dbmyid;
     s:='select p.fio,p.myid  from tssloc_locations as '+
     ' lc,tss_persons as p  '+
     ' where lc.myid='+inttostr(cmyid)+' and p.myid =lc.bidowner';
     form1.log('l','s='+s);
     //exit;
     rc:=form1.readfld(s);
     leownerfio.text:=rc.value;
     s:='select p.myid,p.fio  from tssloc_locations as '+
     ' lc,tss_persons as p '+
     ' where lc.myid='+inttostr(cmyid)+' and p.myid =lc.bidowner';
     rc:= form1.readfld(s);
     lepersid.text:= rc.value;
     loccode:=dl^.loccode;
     form1.log('y','loccode='+inttostr(loccode));

     cmb.Clear;
     s:='select * from tssloc_loccode order by loccode';
     cqrz:=formglink.gselqr(s);
     cmb.Items.Clear;
     while not cqrz.EOF do begin
      s:=cqrz.FieldByName('name').AsString;
      sc:=cqrz.FieldByName('loccode').AsString;
      if (ttg=2) and (strtoint(sc) <> 6) then  begin
       cmb.Items.Add(s);
       slc.Values[s]:=sc;
       if sc=inttostr(loccode) then cnm:=s;
       form1.log('r','cnm='+cnm);
      end;
      cqrz.Next;
     end;
     n:=cmb.Items.IndexOf(cnm);
    // showmessage(inttostr(n));
     cmb.ItemIndex:=n;
     s:='select bidowner';

end;


procedure Tformloc2.FormCreate(Sender: TObject);
begin
       slc:=tstringlist.create;
end;

procedure Tformloc2.BitBtn1Click(Sender: TObject);
var
  lc,s,bidowner:string;
begin

     if trim(lepersid.text)<>'' then  bidowner:=trim(lepersid.text) else
      bidowner:='-1';

     lc:=slc.Values[cmb.text];
     s:='update tssloc_locations set name='+ap+ed_nameloc.Text+ap+zp+
         'bidowner='+bidowner+zp+
         ' loccode='+lc+' where myid='+inttostr(cmyid) ;
     form1.log('c','s='+s);
     FORM1.selfupd(s);

end;

procedure Tformloc2.Button1Click(Sender: TObject);
var
  mymenu:string;
begin
      mymenu:='owner' ;
      formlistpers.dbg.PopupMenu:=formlistpers.popowner;
      formlistpers.show;
      formlistpers.readpersons(mymenu);
end;

end.

