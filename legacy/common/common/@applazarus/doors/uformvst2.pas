unit uformvst2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, laz.virtualtrees, SQLDB,umain;

type

  { Tformvst2 }

  Tformvst2 = class(TForm)
    BitBtn1: TBitBtn;
    cbx_actual: TCheckBox;
    cmb_ctyp: TComboBox;
    ed_tmr5: TEdit;
    erepitpoll: TEdit;
    elimitinfoerr: TEdit;
    elimitcrasherr: TEdit;
    ecp: TEdit;
    ed_actual: TEdit;
    ed_rdrtype: TEdit;
    ed_tmr3: TEdit;
    ecomp: TEdit;
    ech: TEdit;
    eac: TEdit;
    ed_tmr4: TEdit;
    keyp1: TPanel;
    keyp10: TPanel;
    keyp11: TPanel;
    keyp4: TPanel;
    keyp7: TPanel;
    keyp8: TPanel;
    keyp9: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure editac(cnd:pvirtualnode);
    procedure addac(cnd:pvirtualnode);
    procedure formirgrports(cbid,cp:string);
    procedure formirgrsens(cbid:integer);

  private

  public

  end;

var
  formvst2: Tformvst2;
  func:string;
  cmyid,bidch:string;
  cdata:pvstrecord;

implementation

{$R *.lfm}


{ Tformvst2 }



procedure Tformvst2.addac(cnd:pvirtualnode);
var
  d:pvstrecord;
  acts,s:string;
  rc:trcfld;
  act:boolean;
begin
         func:='add';
         show;
         d:=form1.VST.GetNodeData(cnd);
         cdata:=d;
         ecomp.Text:=d^.comp;
         ech.text:=d^.ch;
         cbx_actual.Checked:=true;
         bidch:=inttostr(d^.dbmyid);

         eac.text:='255';
         ecp.text:='2';
         elimitinfoerr.text:='20';
         elimitcrasherr.text:='100';
         erepitpoll.text:='30';



end;

procedure Tformvst2.editac(cnd:pvirtualnode);
var
  d:pvstrecord;
  acts,s:string;
  rc:trcfld;
  act:boolean;
begin
         func:='edit';
         show;
         d:=form1.VST.GetNodeData(cnd);
         cdata:=d;
         ecomp.Text:=d^.comp;
         ech.text:=d^.ch;
         cmyid:=inttostr(d^.dbmyid);
         s:='select ac from tss_acl where myid='+cmyid;
         rc:=form1.readfld(s);
         eac.text:=rc.value;
          s:='select cp from tss_acl where myid='+cmyid;
         rc:=form1.readfld(s);
         ecp.text:=rc.value;
         s:='select limitinfoerr from tss_acl where myid='+cmyid;
         rc:=form1.readfld(s);
         elimitinfoerr.text:=rc.value;
         s:='select limitcrasherr from tss_acl where myid='+cmyid;
         rc:=form1.readfld(s);
         elimitcrasherr.text:=rc.value;
          s:='select repitpoll from tss_acl where myid='+cmyid;
         rc:=form1.readfld(s);
         erepitpoll.text:=rc.value;



       {
         s:='select actual from tss_acl where myid='+cmyid;
         rc:=form1.readfld(s);
         if rc.rc='ok' then begin
         if  rc.value='True' then act:=true else act:=false;
          cbx_actual.Checked:=act;
          cdata^.NM1:='actual='+rc.value;
          form1.vst.refresh;
          form1.log('y','editac value='+rc.value);
         end;
        }



end;

procedure Tformvst2.FormCreate(Sender: TObject);
begin

end;

procedure Tformvst2.formirgrsens(cbid:integer);
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
      '4'+zp+
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



procedure Tformvst2.formirgrports(cbid,cp:string);
var
i:integer;
s,nmyid:string;
rc:tinsr;
begin
        //if not form1.yesno('создать порты для контроллера ??? ') then exit;
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


procedure Tformvst2.BitBtn1Click(Sender: TObject);
var
 d:pvstrecord;
 ac,cp,acts,limitinfoerr,limitcrasherr,ctyp,s,repitpoll,mes,bidac:string;
 act:boolean;
 rc:trcfld;
begin
       if cbx_actual.Checked then acts:='True' else acts:='False';
       if cbx_actual.Checked then act:=true else act:=false;
       ac:= eac.text;
       cp:=ecp.text;
       limitinfoerr:=elimitinfoerr.text;
       limitcrasherr:=elimitcrasherr.text;
       ctyp:= cmb_ctyp.text;

       if func='edit' then begin

        s:='update tss_acl set actual='+ap+acts+ap+zp+
        'ac='+ac+zp+
        'cp='+cp+zp+
        'limitinfoerr='+limitinfoerr+zp+
        'limitcrasherr='+limitcrasherr+zp+
        'repitpoll='+erepitpoll.text+
        ' where myid='+cmyid;
        form1.log('y','s='+s);
        form1.selfupd(s);
        s:='select actual from tss_acl where myid='+cmyid;
        rc:=form1.readfld(s);
        if rc.rc='ok' then begin
        if  rc.value='True' then act:=true else act:=false;
          acts:=rc.value;
          cbx_actual.Checked:=act;
          cdata^.NM1:='actual='+rc.value+zp+'ctyp='+cmb_ctyp.text;
          form1.vst.refresh;
          form1.log('y','editac value='+rc.value);
         end;
       end;
       if func='add' then begin
        s:='insert into tss_acl(actual,bp,ac,cp,tag,ctyp,limitinfoerr,limitcrasherr)values('+
        acts+zp+
        bidch+zp+
        ac+zp+
        cp+zp+
        '2'+zp+
        cmb_ctyp.text+zp+
        limitinfoerr+zp+
        limitcrasherr+
        ')';
        mes:=form1.selfupd(s);
        if mes='ok' then  begin
         bidac:=inttostr(form1.getlastmyid('tss_acl'));
         formirgrports(bidac,cp);
         form1.currreread;
        end;

       end;

       close;
end;

end.

