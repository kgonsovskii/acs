unit uwwcomp;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, Buttons,
  Types,SQLDB,laz.VirtualTrees;

type

  { Tformwwcomp }

  Tformwwcomp = class(TForm)
    bb_comp_cancel: TBitBtn;
    bb_comp_ok: TBitBtn;
    dbg: TDBGrid;
    ds: TDataSource;
    md: TMemDataset;
    Panel1: TPanel;
    procedure bb_comp_cancelClick(Sender: TObject);
    procedure bb_comp_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mdAfterInsert(DataSet: TDataSet);
    procedure mdBeforeInsert(DataSet: TDataSet);
    procedure prepare(fn,f:string;ttg:integer;cnd:pvirtualnode);
    procedure read1(f:string;ttg:integer;cnd:pvirtualnode);
    procedure readandsave;
    function  getvaluesql:string;
    procedure formirsql;

  private

  public

  end;

var
  formwwcomp: Tformwwcomp;
  sll :tstringlist;
  cf,cfn  :string;
  cttg,cbid:integer;

implementation

{$R *.lfm}
uses umain,uglink;

{ Tformwwcomp }

function  Tformwwcomp.getvaluesql:string;
begin
            if sll.Count=0 then exit;
            result:=sll.Strings[0];
            sll.Delete(0);
end;

procedure Tformwwcomp.formirsql;
var
  line:string;
  i:integer;
begin
      if cf='e' then line:='update '+cfn+' set ';
      for i:=0 to sll.count-1 do begin
       line:=line +getvaluesql;
      end;
      form1.log('l','formirsql='+line);
end;

procedure Tformwwcomp.readandsave;
var
 line:string;
begin

    md.First;
      sll.Values['actual'] :=md.FieldByName('actual').Asstring;
      sll.Values['name']   :=md.FieldByName('name').Asstring;
      sll.Values['url']    :=md.FieldByName('url').Asstring;
      sll.Values['state']  :=md.FieldByName('state').Asstring;
      sll.Values['pctyp']  :=md.FieldByName('pctyp').Asstring;
      sll.Values['legenda']:=md.FieldByName('legenda').Asstring;
       if cf='e' then line:='update '+cfn+' set actual='+sll.Values['actual']+zp;
       if cf='i' then line:='insert into '+cfn+'(actual,name,url,pctyp,legenda)values(';
       if cf='e' then begin
        line:=line+
        ' name=' +ap+sll.values['name']+ap+zp+
        ' url='  +ap+sll.values['url']+ap+zp+
        ' pctyp='+ap+sll.values['pctyp']+ap+zp+
        ' legenda='+ap+sll.values['legenda']+ap+
        '  where myid='+inttostr(cbid);
        form1.log('c','line='+line);
        form1.selfupd(line);
       end;
        if cf='i' then begin
        line:=line+
         sll.Values['actual']+zp+
         ap+sll.values['name']+ap+zp+
        ap+sll.values['url']+ap+zp+
        ap+sll.values['pctyp']+ap+zp+
        ap+sll.values['legenda']+ap+')';
        form1.log('c','line='+line);
        form1.selfupd(line);
       end;

     end;


procedure Tformwwcomp.bb_comp_okClick(Sender: TObject);
begin
     readandsave;
end;




procedure Tformwwcomp.read1(f:string;ttg:integer;cnd:pvirtualnode);
var
s,myid:string;
qrz:TSQLQuery;
dss:pvstrecord;
begin
    try
     show;
     dss:=form1.vst.GetNodeData(cnd);
     myid:=inttostr(dss^.dbmyid);
     cbid:=dss^.dbmyid;


     qrz:=TSQLQuery.Create(self);
     qrz.DataBase:=formglink.pqc1;
     s:=' select * from tss_comps where myid='+myid;
     qrz.SQL.Add(s);
     qrz.Active:=true;
     md.first;
     while not qrz.eof do begin
      md.Insert;
      md.FieldByName('actual').AsBoolean:=qrz.FieldByName('actual').AsBoolean;
      md.FieldByName('name').Asstring:=trim(qrz.FieldByName('name').Asstring);
      md.FieldByName('url').Asstring:=trim(qrz.FieldByName('url').Asstring);
      md.FieldByName('state').Asstring:=trim(qrz.FieldByName('state').Asstring);
      md.FieldByName('pctyp').Asstring:=trim(qrz.FieldByName('pctyp').Asstring);
      md.FieldByName('legenda').Asstring:=trim(qrz.FieldByName('legenda').Asstring);
      qrz.next;
     end;
     md.Post;

   {
     xformedit.le_comp_name.Text:=qrz.FieldByName('name').Asstring;
     xformedit.le_comp_url.Text:=qrz.FieldByName('url').Asstring;
     xformedit.cmb_comp_pctyp.Text:=qrz.FieldByName('pctyp').Asstring;
     xformedit.le_comp_tscd.text:=qrz.FieldByName('tscd').Asstring;
    }
   except

    on e:exception do begin
         form1.log('e','read1,e='+e.message);
    end;
   end;
   qrz.Free;



end;

procedure Tformwwcomp.prepare(fn,f:string;ttg:integer;cnd:pvirtualnode);

begin
       cf:=f;
       cttg:=ttg;
       cfn:=fn;
       show;
     if f='e' then begin
       read1(f,ttg,cnd);
       exit;
     end;
     if f='i' then begin
       exit;
     end;



end;

procedure Tformwwcomp.FormCreate(Sender: TObject);
begin
       dbg.Font.Color:=clblack;
       sll:=tstringlist.create;
       ;
end;

procedure Tformwwcomp.mdAfterInsert(DataSet: TDataSet);
begin
  if md.RecordCount>=1 then md.first;
end;

procedure Tformwwcomp.mdBeforeInsert(DataSet: TDataSet);
begin
     if md.RecordCount>=1 then md.first;

end;

procedure Tformwwcomp.bb_comp_cancelClick(Sender: TObject);
begin
     close;
end;

end.

