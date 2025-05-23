unit uwwac;

{$mode ObjFPC}{$H+}

interface

uses
   Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, StdCtrls, Menus,
  Types,SQLDB,laz.VirtualTrees;
type

  { Tformwwac }

  Tformwwac = class(TForm)
    bb_comp_cancel: TBitBtn;
    bb_comp_ok: TBitBtn;
    dbg: TDBGrid;
    ds: TDataSource;
    lsm: TListBox;
    md: TMemDataset;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure bb_comp_cancelClick(Sender: TObject);
    procedure bb_comp_okClick(Sender: TObject);
    procedure dbgCellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure mdAfterEdit(DataSet: TDataSet);
    procedure mdBeforeEdit(DataSet: TDataSet);
    procedure prepare(fn,f:string;ttg:integer;cnd:pvirtualnode);
    procedure read1(fn,f:string;ttg:integer;cnd:pvirtualnode);
    procedure readandsave;
    procedure formirgrports(cbid,cp:string);
    procedure formirgrsens(cbid:integer);

  private

  public

  end;

var
  formwwac: Tformwwac;
   sll :tstringlist;
   cf,cfn  :string;
   cttg,cbid,bidch:integer;
   ndacX,ndch:pvirtualnode;


implementation

{$R *.lfm}
uses umain,uglink;

{ Tformwwac }

procedure Tformwwac.read1(fn,f:string;ttg:integer;cnd:pvirtualnode);
var
s,myid:string;
qrz:TSQLQuery;
dss:pvstrecord;
fx:boolean;
d:pvstrecord;
ndch:pvirtualnode;
begin
     ndacX:=cnd;
     d:=form1.vst.GetNodeData(ndacX);
     md.Open;
     fx:=false;
     show;
     dss:=form1.vst.GetNodeData(cnd);
     cbid:=dss^.dbmyid;
     form1.log('y','formwwac.read1 nm0='+dss^.NM0+'cbid='+inttostr(cbid));

     myid:=inttostr(dss^.dbmyid);
     bidch:=dss^.bidch;
     form1.LOG('l','READ1  bidch='+inttostr(bidch));


     qrz:=TSQLQuery.Create(self);
     qrz.SQL.clear;
     qrz.DataBase:=formglink.pqc1;
     s:=' select * from ' +fn+'  where myid='+myid;
     form1.log('c','read1 s='+s);
     qrz.SQL.Add(s);
     qrz.Active:=true;
     md.first;
     while not qrz.eof do begin
      md.Insert;
      fx:=true;
      md.FieldByName('actual').AsBoolean:=qrz.FieldByName('actual').AsBoolean;
      md.FieldByName('ac').Asstring:=trim(qrz.FieldByName('ac').Asstring);
      md.FieldByName('ctyp').Asstring:=trim(qrz.FieldByName('ctyp').Asstring);
      md.FieldByName('cp').Asstring:=trim(qrz.FieldByName('cp').Asstring);
      md.FieldByName('limitinfoerr').Asstring:=trim(qrz.FieldByName('limitinfoerr').Asstring);
      md.FieldByName('limitcrasherr').Asstring:=trim(qrz.FieldByName('limitcrasherr').Asstring);
      MD.POST;
      qrz.next;
     end;
     MD.EDIT;
     //try md.post; except end;


end;




procedure Tformwwac.prepare(fn,f:string;ttg:integer;cnd:pvirtualnode);

begin
       cf:=f;
       cttg:=ttg;
       cfn:=fn;
       show;
     if f='e' then begin
       read1(fn,f,ttg,cnd);
     end;
     if f='i' then begin
        read1(fn,f,ttg,cnd);
     end;

    // exit;


end;


procedure Tformwwac.readandsave;
var
 line:string;
 rcx:tinsr;
 rc,mes,myid:string;
 d:pvstrecord;
 s:string;
begin
     try md.post; except end;
     MD.First;

      d:=form1.vst.GetNodeData(ndacX);


      md.First;
      sll.Values['actual'] :=md.FieldByName('actual').Asstring;
      form1.log('w','actual='+sll.Values['actual']);


      sll.Values['ac']    :=md.FieldByName('ac').Asstring;
      sll.Values['cp']    :=md.FieldByName('cp').Asstring;
      sll.Values['ctyp']     :=md.FieldByName('ctyp').Asstring;
      sll.Values['limitinfoerr'] :=md.FieldByName('limitinfoerr').Asstring;
      sll.Values['limitcrasherr']   :=md.FieldByName('limitcrasherr').Asstring;
       if cf='e' then line:='update '+cfn+' set actual='+sll.Values['actual']+zp;
       if cf='i' then line:='insert into '+cfn+'(actual,tag,bp,ac,ctyp,cp,limitinfoerr,limitcrasherr)values(';

       if cf='e' then begin
        line:=line+
        ' bp='+inttostr(bidch)+zp+
        ' ac=' +sll.values['ac']+zp+
        ' cp='  +sll.values['cp']+zp+
        ' ctyp='+ap+sll.values['ctyp']+ap+zp+
        ' limitinfoerr='+sll.values['limitinfoerr']+zp+
        ' limitcrasherr='+sll.values['limitcrasherr']+
        '  where myid='+inttostr(cbid);
        form1.log('w','line='+line);
        mes:=form1.selfupd(line);

         if mes='ok' then begin
         lsm.Font.Color:=cllime;
         lsm.Clear;
         lsm.Items.Add(mes);
        end;
         if mes<>'ok' then begin
         lsm.Font.Color:=clred;
         lsm.Clear;
         lsm.Items.Add(mes);
        end;
       end;

        if cf='i' then begin

        line:=line+
         sll.Values['actual']+zp+
         '2'+zp+
         inttostr(bidch)+zp+
         sll.Values['ac']+zp+
        ap+ sll.Values['ctyp']+ap+zp+
         sll.values['cp']+zp+
         sll.values['limitinfoerr']+zp+
         sll.values['limitcrasherr']+')';

        form1.log('c','line='+line);

        mes:=form1.selfupd(line);

        myid:=inttostr(form1.getlastmyid('tss_acl'));
        if  mes='ok' then begin
         lsm.Font.Color:=cllime;
         lsm.Clear;
         lsm.Items.Add(mes);
         formirgrports(myid,sll.Values['cp']);
        end;

         if mes<>'ok' then begin
         lsm.Font.Color:=clred;
         lsm.Clear;
         lsm.Items.Add(mes);
         FORM1.LOG('r','AFTER ADD CONT='+mes);
        end;
        end;

        d:=form1.vst.GetNodeData(ndacX);
        s:='actual='+md.FieldByName('actual').asstring+zp+timetostr(time);
        d^.nm1:=s;
        form1.vst.refresh;
        formwwac.close;


    end;


procedure Tformwwac.formirgrsens(cbid:integer);
var
i:integer;
s:string;
rc:tinsr;
begin
      s:='insert into tss_sensors (tag,bp,code,name)values('+
      '4'+zp+
      inttostr(cbid)+zp+
      '1'+zp+
      ap+'key'+ap+')';
      form1.log('l','s='+s);
      form1.selfupd(s);

      s:='insert into tss_sensors (tag,bp,code,name)values('+
      '4'+zp+
      inttostr(cbid)+zp+
      '2'+zp+
      ap+'open'+ap+')';
      form1.log('l','s='+s);
      form1.selfupd(s);

      s:='insert into tss_sensors (tag,bp,code,name)values('+
      '3'+zp+
      inttostr(cbid)+zp+
      '3'+zp+
      ap+'close'+ap+')';
      form1.log('l','s='+s);
      form1.selfupd(s);


      s:='insert into tss_sensors (tag,bp,code,name)values('+
      '4'+zp+
      inttostr(cbid)+zp+
      '4'+zp+
      ap+'rte'+ap+')';
      form1.log('l','s='+s);
      form1.selfupd(s);





end;

procedure Tformwwac.formirgrports(cbid,cp:string);
var
i:integer;
s,nmyid:string;
rc:tinsr;
begin
        if not form1.yesno('создать порты для контроллера ??? ') then exit;
        for i:=1 to strtoint(cp) do begin
          s:='insert into tss_ports(actual,nump,bp,tag)values('+
          'true'+zp+
          inttostr(i)+zp+
          cbid+zp+
          '3'+')';
          rc:=form1.myinsertr('tss_ports',s);
          nmyid:=inttostr(rc.myid);
          form1.log('y','formirgrports='+s+zp+' nmyid='+nmyid);
           if rc.mes='ok' then  formirgrsens(rc.myid);
        end;

 end;

procedure Tformwwac.FormCreate(Sender: TObject);
begin
    sll:=tstringlist.Create;
end;

procedure Tformwwac.mdAfterEdit(DataSet: TDataSet);
begin
   EXIT;
   form1.log('y','AFTER EDIT 1 actual='+md.FieldByName('actual').AsString);
    try md.post; except end;
    form1.log('y','AFTER EDIT 2 actual='+md.FieldByName('actual').AsString);

end;

procedure Tformwwac.mdBeforeEdit(DataSet: TDataSet);
begin
   //try md.post; except end;
  // form1.log('y','BEFORE actual='+md.FieldByName('actual').AsString);

end;


procedure Tformwwac.bb_comp_okClick(Sender: TObject);
begin
    try
     try md.post; except end;
     readandsave;
    except
    end;
end;

procedure Tformwwac.dbgCellClick(Column: TColumn);
var
acts:string;
begin
      EXIT;

      if column.FieldName='actual' then begin
       acts:=md.FieldByName('actual').AsString;
       form1.log('l','actual='+acts);
       md.post;
       acts:=md.FieldByName('actual').AsString;
       form1.log('w','LAST actual='+acts);
      end;
end;

procedure Tformwwac.bb_comp_cancelClick(Sender: TObject);
begin
    try
     md.post;
     close;

    except
    end;
end;

end.

