unit uformeditall;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Menus, Buttons,
  laz.VirtualTrees, Types,SQLDB;


type

  { Tformeditall }

  Tformeditall = class(TForm)
    bb_ac_cancel: TBitBtn;
    bb_ac_ok: TBitBtn;
    bb_comp_cancel: TBitBtn;
    bb_ch_cancel: TBitBtn;
    bb_comp_cancel1: TBitBtn;
    bb_comp_cancel2: TBitBtn;
    bb_comp_ok: TBitBtn;
    bb_ch_ok: TBitBtn;
    bb_port_ok: TBitBtn;
    bb_sens_ok: TBitBtn;
    cb_ch_actual: TCheckBox;
    cb_ac_actual: TCheckBox;
    cb_comp_actual: TCheckBox;
    cb_port_actual: TCheckBox;
    cb_sens_ignore: TCheckBox;
    cmb_ch_chtype: TComboBox;
    cmb_ac_actype: TComboBox;
    cmb_comp_1: TPanel;
    cmb_comp_2: TPanel;
    cmb_comp_pctyp: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    lb_ac_actype: TLabel;
    le_ac_cp: TLabeledEdit;
    le_ch_ch: TLabeledEdit;
    le_ac_ac: TLabeledEdit;
    le_ac_tscd: TLabeledEdit;
    le_ch_lobs: TLabeledEdit;
    le_port_nump: TLabeledEdit;
    le_comp_tscd: TLabeledEdit;
    le_ch_tscd: TLabeledEdit;
    le_sens_name: TLabeledEdit;
    le_sens_code: TLabeledEdit;
    le_port_tscd: TLabeledEdit;
    le_comp_url: TLabeledEdit;
    le_comp_name: TLabeledEdit;
    cmb_comp_: TPanel;
    le_port_tmr: TLabeledEdit;
    le_port_nmr: TLabeledEdit;
    le_sens_tscd: TLabeledEdit;
    Panel4: TPanel;
    Panel5: TPanel;
    pg1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure bb_ac_okClick(Sender: TObject);
    procedure bb_ch_okClick(Sender: TObject);
    procedure bb_comp_cancelClick(Sender: TObject);
    procedure bb_comp_okClick(Sender: TObject);
    procedure bb_port_okClick(Sender: TObject);
    procedure bb_sens_okClick(Sender: TObject);
    procedure pg1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure prepare(cnd:pvirtualnode);
    procedure log(pr,txt:string);
    procedure pg1Change(Sender: TObject);
    procedure TabSheet4ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure read_comp;
    procedure read_ch;
    procedure read_ac;
    procedure read_port;
    procedure read_sensor;
  private

  public

  end;

var
  formeditall: Tformeditall;
  pagi,mtag :integer;
  mnode:pvirtualnode;
 // mdata:pvstrecord;

implementation

{$R *.lfm}
uses umain,uglink;


{ Tformeditall }
procedure Tformeditall.log(pr,txt:string);
begin
      form1.log(pr,txt);
end;

procedure Tformeditall.prepare(cnd:pvirtualnode);
var
  ds:pvstrecord;
  i:integer;
begin
        mnode:=cnd;
        ds:=form1.vst.GetNodeData(cnd);
        log('y','prepare tag='+inttostr(ds^.tag));
        //for i:=0 to pg1.PageCount-1 do begin
        // if i<> ds^.tag then pg1.Page[i].Visible:=false;
        //end;
        //pg1.ActivePageIndex:=0;
        mtag:=ds^.tag;
        if ds^.tag=0 then begin  formeditall.pg1.ActivePageIndex:=0; pagi:=0; read_comp;end;
        if ds^.tag=1 then begin  formeditall.pg1.ActivePageIndex:=1; pagi:=1; read_ch;end;
        if ds^.tag=2 then begin  formeditall.pg1.ActivePageIndex:=2; pagi:=2; read_ac;end;
        if ds^.tag=3 then begin  formeditall.pg1.ActivePageIndex:=3; pagi:=3; read_port;end;
        if ds^.tag=4 then begin  formeditall.pg1.ActivePageIndex:=4; pagi:=4; read_sensor;end;




end;

procedure Tformeditall.read_comp;
var
s,myid:string;
qrz:TSQLQuery;
ds:pvstrecord;
begin
   try
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     show;
     qrz:=TSQLQuery.Create(self);
     qrz.DataBase:=formglink.pqc1;
     s:=' select * from tss_comps where myid='+myid;
     qrz.SQL.Add(s);
     qrz.Active:=true;
     formeditall.cb_comp_actual.Checked:=qrz.FieldByName('actual').AsBoolean;
     formeditall.le_comp_name.Text:=qrz.FieldByName('name').Asstring;
     formeditall.le_comp_url.Text:=qrz.FieldByName('url').Asstring;
     formeditall.cmb_comp_pctyp.Text:=qrz.FieldByName('pctyp').Asstring;
     formeditall.le_comp_tscd.text:=qrz.FieldByName('tscd').Asstring;
   except
    on e:exception do begin
         log('e','read_comp,e='+e.message);
    end;
   end;
   qrz.Free;

end;
procedure Tformeditall.read_ch;
var
s,myid:string;
qrz:TSQLQuery;
ds:pvstrecord;
begin
   try
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     show;
     qrz:=TSQLQuery.Create(self);
     qrz.DataBase:=formglink.pqc1;
     s:=' select * from tss_ch where myid='+myid;
     qrz.SQL.Add(s);
     qrz.Active:=true;
     formeditall.cb_ch_actual.Checked:=qrz.FieldByName('actual').AsBoolean;
     formeditall.le_ch_ch.Text:=qrz.FieldByName('ch').Asstring;
     //formeditall.le_ch_url.Text:=qrz.FieldByName('ch').Asstring;
     formeditall.cmb_ch_chtype.Text:=qrz.FieldByName('chtype').Asstring;
     formeditall.le_ch_tscd.text:=qrz.FieldByName('tscd').Asstring;
     formeditall.le_ch_lobs.text:=qrz.FieldByName('lobs').Asstring;
     qrz.Free;
   except
    on e:exception do begin
         log('e','read_ch,e='+e.message);
    end;
   end;


end;
procedure Tformeditall.read_ac;
var
s,myid:string;
qrz:TSQLQuery;
ds:pvstrecord;
begin
   try
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     show;
     qrz:=TSQLQuery.Create(self);
     qrz.DataBase:=formglink.pqc1;
     s:=' select * from tss_acl where myid='+myid;
     qrz.SQL.Add(s);
     qrz.Active:=true;
     formeditall.cb_ac_actual.Checked:=qrz.FieldByName('actual').AsBoolean;
     formeditall.le_ac_ac.Text:=qrz.FieldByName('ac').Asstring;
     //formeditall.le_ch_url.Text:=qrz.FieldByName('ch').Asstring;
     formeditall.cmb_ac_actype.Text:=qrz.FieldByName('ctyp').Asstring;
     formeditall.le_ac_cp.Text:=qrz.FieldByName('cp').Asstring;
     formeditall.le_ac_tscd.text:=qrz.FieldByName('tscd').Asstring;
   except
    on e:exception do begin
         log('e','read_ch,e='+e.message);
    end;
   end;
   qrz.Free;

end;
procedure Tformeditall.read_port;
var
s,myid:string;
qrz:TSQLQuery;
ds:pvstrecord;
begin
   try
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     show;
     qrz:=TSQLQuery.Create(self);
     qrz.DataBase:=formglink.pqc1;
     s:=' select * from tss_ports where myid='+myid;
     qrz.SQL.Add(s);
     qrz.Active:=true;
     formeditall.cb_port_actual.Checked:=qrz.FieldByName('actual').AsBoolean;
     formeditall.le_port_nump.Text:=qrz.FieldByName('nump').Asstring;
     formeditall.le_port_tmr.Text:=qrz.FieldByName('tmr').Asstring;
     formeditall.le_port_nmr.Text:=qrz.FieldByName('nmr').Asstring;
     formeditall.le_port_tscd.text:=qrz.FieldByName('tscd').Asstring;
   except
    on e:exception do begin
         log('e','read_port,e='+e.message);
    end;
   end;
   qrz.Free;

end;
procedure Tformeditall.read_sensor;
var
s,myid:string;
qrz:TSQLQuery;
ds:pvstrecord;
begin
   try
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     show;
     qrz:=TSQLQuery.Create(self);
     qrz.DataBase:=formglink.pqc1;
     s:=' select * from tss_sensors where myid='+myid;
     qrz.SQL.Add(s);
     qrz.Active:=true;
     formeditall.cb_sens_ignore.Checked:=qrz.FieldByName('ignore').AsBoolean;
     formeditall.le_sens_name.Text:=qrz.FieldByName('name').Asstring;
     formeditall.le_sens_code.text:=qrz.FieldByName('code').Asstring;
     formeditall.le_sens_tscd.text:=qrz.FieldByName('tscd').Asstring;
   except
    on e:exception do begin
         log('e','read_sensor,e='+e.message);
    end;
   end;
   qrz.Free;

end;





procedure Tformeditall.pg1Changing(Sender: TObject; var AllowChange: Boolean);
begin
     pg1.ActivePageIndex:=pagi;
end;

procedure Tformeditall.bb_comp_okClick(Sender: TObject);
var
ds:pvstrecord;
myid,s:string;
f:string;
begin
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     if formeditall.cb_comp_actual.Checked then f:='true' else f:='false';
     s:='update tss_comps set actual='+f+zp+
        'name='+ap+formeditall.le_comp_name.text+ap+zp+
        'url='+ap+formeditall.le_comp_url.text+ap+zp+
        'tscd='+'current_timestamp'+
        ' where myid='+myid;
     log('l','bb_comp_okClick='+s);
     form1.selfupd(s);
     close;

end;

procedure Tformeditall.bb_port_okClick(Sender: TObject);
var
ds:pvstrecord;
myid,s:string;
f:string;
begin
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     if formeditall.cb_port_actual.Checked then f:='true' else f:='false';
     s:='update tss_ports set actual='+f+zp+
        'nump='+formeditall.le_port_nump.text+zp+
        'tmr='+formeditall.le_port_tmr.text+zp+
        'nmr='+formeditall.le_port_nmr.text+zp+
        'tscd='+'current_timestamp'+
        ' where myid='+myid;
     log('l','bb_ch_okClick='+s);
     form1.selfupd(s);
     close;

end;

procedure Tformeditall.bb_sens_okClick(Sender: TObject);
var
ds:pvstrecord;
myid,s:string;
f:string;
begin
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     if formeditall.cb_sens_ignore .Checked then f:='true' else f:='false';
     s:='update tss_sensors set ignore='+f+zp+
        'name='+ap+formeditall.le_sens_name.text+ap+zp+
        'code='+formeditall.le_sens_code.text+zp+
        'tscd='+'current_timestamp'+
        ' where myid='+myid;
     log('l','bb_sens_okClick='+s);
     form1.selfupd(s);
     close;

end;

procedure Tformeditall.bb_comp_cancelClick(Sender: TObject);
begin
       log('l','bbcancel');
end;

procedure Tformeditall.bb_ch_okClick(Sender: TObject);
var
ds:pvstrecord;
myid,s:string;
f:string;
begin
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     if formeditall.cb_ch_actual.Checked then f:='true' else f:='false';
     s:='update tss_ch set actual='+f+zp+
        'chtype='+ap+formeditall.cmb_ch_chtype.text+ap+zp+
        'ch='+ap+formeditall.le_ch_ch.text+ap+zp+
        'lobs='+formeditall.le_ch_lobs.text+zp+
        'tscd='+'current_timestamp'+
        ' where myid='+myid;
     log('l','bb_ch_okClick='+s);
     form1.selfupd(s);
     close;

end;

procedure Tformeditall.bb_ac_okClick(Sender: TObject);
var
ds:pvstrecord;
myid,s:string;
f:string;
begin
     ds:=form1.vst.GetNodeData(mnode);
     myid:=inttostr(ds^.dbmyid);
     if formeditall.cb_ac_actual.Checked then f:='true' else f:='false';
     s:='update tss_acl set actual='+f+zp+
        'ctyp='+ap+formeditall.cmb_ac_actype.text+ap+zp+
        'ac='+ap+formeditall.le_ac_ac.text+ap+zp+
        'cp='+formeditall.le_ac_cp.Text+zp+
         'tscd='+'current_timestamp'+
        ' where myid='+myid;
     log('l','bb_ac_okClick='+s);
     form1.selfupd(s);
     close;


end;

procedure Tformeditall.pg1Change(Sender: TObject);
begin
        log('l','aindex=='+inttostr(pg1.ActivePageIndex));
        pg1.ActivePageIndex:=pagi;
end;

procedure Tformeditall.TabSheet4ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.

