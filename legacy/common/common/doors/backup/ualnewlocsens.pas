unit ualnewlocsens;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  SQLDB,laz.virtualtrees,
  umain;

type
  tlsql = record
    flagoper:string;
    mpcl :string;
    name :string;
    bp:  string;
    tag: string;
    code:string;
    fckps:string;
    fioflag:string;
  end;

type

  { Tformalnewlocsens }

  Tformalnewlocsens = class(TForm)
    btnok: TButton;
    cbfckp: TCheckBox;
    cbioflag: TCheckBox;
    cmbsens: TComboBox;
    Label1: TLabel;
    lefckp: TLabeledEdit;
    leloc: TLabeledEdit;
    lenx: TLabeledEdit;
    lesens: TLabeledEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnokClick(Sender: TObject);
    procedure cbfckpChange(Sender: TObject);
    procedure cbioflagChange(Sender: TObject);
    procedure cmbsensChange(Sender: TObject);
    procedure cmbsensClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure allupd(cnd:pvirtualnode;flagoper:string);
    function  findmpcl(dl:pvstrecordloc):integer;
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure aladdgrp(cnd:pvirtualnode);

  private

  public

  end;

var
  formalnewlocsens: Tformalnewlocsens;
  lsql :tlsql;

implementation

{$R *.lfm}
uses uglink,ualfunc;

{ Tformalnewlocsens }


function Tformalnewlocsens.findmpcl(dl:pvstrecordloc):integer;
var
 rc:integer;
 s:string;
 qrz: TSQLQuery;
begin
      result:=-1;
      s := 'select myid  from tssloc_locations  where tag=3';
      qrz := TSQLQuery.Create(self);
      qrz.DataBase := formglink.pqc1;
      qrz.SQL.Add(s);
      qrz.Active := True;
      rc:=qrz.RecordCount;

     if qrz.RecordCount=0 then begin
      form1.log('y','findmpcl rc= '+inttostr(rc)) ;
      result:=0;
      exit;
     end ;
      qrz.Close;
      s := 'select mpcl from tssloc_locations  where tag=3 and bp='+inttostr(dl^.dbmyid)+' order by mpcl desc limit 1';
      form1.log('r','s='+s);
        qrz.SQL.clear;
        qrz.SQL.Add(s);
        showmessage('findmpcl 2');
        qrz.Active := True;
        s:=trim(qrz.FieldByName('mpcl').AsString);
        if s='' then s:='0';
        showmessage('findmpcl 3='+s);
        result:=strtoint(s);
        showmessage('result='+inttostr(result));
        form1.log('c','last value mpcl='+inttostr(result));


end;

procedure Tformalnewlocsens.Panel1Click(Sender: TObject);
begin

end;

procedure Tformalnewlocsens.Panel2Click(Sender: TObject);
begin

end;

procedure tformalnewlocsens.aladdgrp(cnd:pvirtualnode);
var
  dl:pvstrecordloc;
  i,mpcl,nx:integer;
  sl:tstringlist;
  s,nm,nm1,k:string;
begin
         dl:=form1.vstLOC.GetNodeData(cnd);
         mpcl:=findmpcl(dl);
         mpcl:=mpcl+1;
         //showmessage('aladdgrp 1');
         lsql.mpcl:=inttostr(mpcl);
         lsql.mpcl:=ualfunc.Azerol(lsql.mpcl,2);
         form1.log('y','aladdgrp mpcl='+(lsql.mpcl));
         sl:=tstringlist.Create;
         sl.values['key']  :='1';
         sl.values['open'] :='2';
         sl.values['close']:='3';
         sl.values['rte']  :='4';
         lsql.tag:='3';
         lsql.bp:=inttostr(dl^.dbmyid);
         lsql.fioflag:='True';
         lsql.fckps:=dl^.fckps;
         showmessage('aladdgrp fckps='+ lsql.fckps);
         for i:=0 to sl.count-1 do begin;
          nm1:=sl.Names[i];
          nm:=nm1+'_'+lsql.mpcl;
           s:='insert into tssloc_locations(mpcl,bp,tag,code,name,fckp,ioflag)values('+
           lsql.mpcl+zp+
           lsql.bp+zp+
           lsql.tag+zp+
           sl.Values[nm1]+zp+
           ap+nm+ap+zp+
           lsql.fckps+zp+
           lsql.fioflag+
           ')';
           form1.log('l','s='+s);
           form1.selfupd(s);
          end;

end;

procedure Tformalnewlocsens.allupd(cnd:pvirtualnode;flagoper:string);
var
  dl:pvstrecordloc;
  bp,tgg,s,ss,fckps:string;
  fckp,f:boolean;
   mpcl:integer;


begin
     lsql.flagoper:=flagoper;
     show;
     f:=false;
     dl:=form1.vstLOC.GetNodeData(cnd);
     fckp:=dl^.fckp;
     fckps:=dl^.fckps;
     cbfckp.Checked:=fckp;
     cmbsens.ItemIndex:=-1;
     bp:=inttostr(dl^.dbmyid);
     mpcl:=findmpcl(dl);
     mpcl:=mpcl+1;
     lsql.mpcl:=inttostr(mpcl);
     ss:=inttostr(mpcl);
     ss:=ualfunc.Azerol(ss,2);
     dl^.mpcl := mpcl;
     lenx.Text:=ss;
     tgg:='3';
     lsql.bp:=bp;
     lsql.tag:=tgg;


   {

     if f=false then begin
      s := 'select  max(mpcl) from tssloc_locations  where tag=3  and bp=' + bp;
      form1.log('l', 's=' + s);
      qrz := TSQLQuery.Create(self);
      qrz.DataBase := formglink.pqc1;
      qrz.SQL.Add(s);
      qrz.Active := True;

      showmessage('tut 1111111111111111111111111111111111'+' rc='+inttostr(qrz.RecordCount));
      if qrz.RecordCount=0 then begin
       showmessage('net records');
       mpcl:=0;
      end;
      mpcl := strtoint(qrz.Fields[0].Asstring);
       form1.log('l', 'mpcl=' + inttostr(mpcl));
      showmessage('mpcl='+inttostr(mpcl));
      dl^.mpcl := mpcl;
      lenx.Text:=inttostr(mpcl);
     }


     if fckp then lefckp.text:='   на проходной' else lefckp.text:='  на двери' ;

     if fckp then cbfckp.Caption:=' на проходной' else cbfckp.Caption:='  на двери' ;
     leloc.Text:=dl^.nm0;

     if flagoper='insert' then begin
       btnok.caption:='Добавить';

     end;


    form1.log('l','f='+booltostr(f));
    dl^.mpcl := mpcl;
    lenx.Text:=inttostr(mpcl);


end;

procedure Tformalnewlocsens.FormCreate(Sender: TObject);
begin
  //
end;

procedure Tformalnewlocsens.cbfckpChange(Sender: TObject);
begin
      //form1.log('c','cccccccccccccccccccccccccccccccccccccccccccccccc') ;
end;

procedure Tformalnewlocsens.btnokClick(Sender: TObject);
var
   s:string;
begin
      if lsql.flagoper='insert' then begin
       s:='insert into tssloc_locations(bp,tag,code,name)values('+
       lsql.bp+zp+
       lsql.tag+zp+
       lsql.code+zp+
       ap+lesens.text+ap+
       ')';
       form1.log('l',s);
       form1.selfupd(s);

      end;





end;

procedure Tformalnewlocsens.cbioflagChange(Sender: TObject);
var
 cb: tcheckbox;
begin
     cb:=sender as tcheckbox;
     if cb.Checked=true  then cb.caption:=' ВХОД';
     if cb.Checked=false then cb.caption:=' ВЫХОД';
end;

procedure Tformalnewlocsens.cmbsensChange(Sender: TObject);
VAR
 s,code:string;
begin
     s:=trim(cmbsens.Text);
     if s='key'   then code:='1';
     if s='open'  then code:='2';
     if s='close' then code:='3';
     if s='rte'   then code:='4';
     lsql.code:=code;
     form1.log('y','code='+code);

     form1.log('c','cmbsensChange txt='+cmbsens.Text);
     lesens.Text:=cmbsens.Text+'_'+lenx.text;
     lsql.name:=lesens.Text;
     form1.log('l','sens='+lesens.Text);

end;

procedure Tformalnewlocsens.cmbsensClick(Sender: TObject);
begin

end ;


end.

