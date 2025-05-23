unit uformxedit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Menus, Buttons,
  laz.VirtualTrees, Types,SQLDB;

type

  { Txformedit }

  Txformedit = class(TForm)
    bb_ac_cancel: TBitBtn;
    bb_ac_ok: TBitBtn;
    bb_ch_cancel: TBitBtn;
    bb_ch_ok: TBitBtn;
    bb_comp_cancel: TBitBtn;
    bb_comp_cancel1: TBitBtn;
    bb_comp_cancel2: TBitBtn;
    bb_comp_ok: TBitBtn;
    bb_port_ok: TBitBtn;
    bb_sens_ok: TBitBtn;
    cb_ac_actual: TCheckBox;
    cb_ch_actual: TCheckBox;
    cb_comp_actual: TCheckBox;
    cb_port_actual: TCheckBox;
    cb_sens_ignore: TCheckBox;
    cmb_ac_actype: TComboBox;
    cmb_ch_chtype: TComboBox;
    cmb_comp_: TPanel;
    cmb_comp_1: TPanel;
    cmb_comp_2: TPanel;
    cmb_comp_pctyp: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    lb_ac_actype: TLabel;
    le_ac_ac: TLabeledEdit;
    le_ac_cp: TLabeledEdit;
    le_ac_tscd: TLabeledEdit;
    le_ch_ch: TLabeledEdit;
    le_ch_lobs: TLabeledEdit;
    le_ch_tscd: TLabeledEdit;
    le_comp_name: TLabeledEdit;
    le_comp_tscd: TLabeledEdit;
    le_comp_url: TLabeledEdit;
    le_port_nmr: TLabeledEdit;
    le_port_nump: TLabeledEdit;
    le_port_tmr: TLabeledEdit;
    le_port_tscd: TLabeledEdit;
    le_sens_code: TLabeledEdit;
    le_sens_name: TLabeledEdit;
    le_sens_tscd: TLabeledEdit;
    Panel4: TPanel;
    Panel5: TPanel;
    pg1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure bb_ac_cancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure prepare(cnd:pvirtualnode);
    procedure log(pr,txt:string) ;
    procedure read_comp;
    procedure read_ch;
    procedure read_ac;
    procedure read_port;
    procedure read_sensor;

  private

  public

  end;

var
  xformedit: Txformedit;
   mnode:pvirtualnode;
    pagi,mtag :integer;

implementation

{$R *.lfm}
uses umain,uglink;

{ Txformedit }


procedure Txformedit.log(pr,txt:string) ;
begin
        form1.log(pr,txt);

end;

procedure Txformedit.prepare(cnd:pvirtualnode);
var
  ds:pvstrecord;
  i:integer;
begin
        showmessage('api='+inttostr(pg1.ActivePageIndex));
        mnode:=cnd;
        ds:=form1.vst.GetNodeData(cnd);
        showmessage('tut');
        log('y','prepare tag='+inttostr(ds^.tag));
        showmessage('after prepare ');
        //for i:=0 to pg1.PageCount-1 do begin
        //if i<> ds^.tag then pg1.Page[i].Visible:=false;
        pg1.ActivePageIndex:=0;
        //end;
        pg1.ActivePageIndex:=0;
        mtag:=ds^.tag;
        if ds^.tag=0 then begin  xformedit.pg1.ActivePageIndex:=0; pagi:=0; read_comp;end;
        if ds^.tag=1 then begin  xformedit.pg1.ActivePageIndex:=1; pagi:=1; read_ch;end;
        if ds^.tag=2 then begin  xformedit.pg1.ActivePageIndex:=2; pagi:=2; read_ac;end;
        if ds^.tag=3 then begin  xformedit.pg1.ActivePageIndex:=3; pagi:=3; read_port;end;
        if ds^.tag=4 then begin  xformedit.pg1.ActivePageIndex:=4; pagi:=4; read_sensor;end;




end;


procedure Txformedit.read_comp;
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
     xformedit.cb_comp_actual.Checked:=qrz.FieldByName('actual').AsBoolean;
     xformedit.le_comp_name.Text:=qrz.FieldByName('name').Asstring;
     xformedit.le_comp_url.Text:=qrz.FieldByName('url').Asstring;
     xformedit.cmb_comp_pctyp.Text:=qrz.FieldByName('pctyp').Asstring;
     xformedit.le_comp_tscd.text:=qrz.FieldByName('tscd').Asstring;
   except
    on e:exception do begin
         log('e','read_comp,e='+e.message);
    end;
   end;
   qrz.Free;

end;
procedure Txformedit.read_ch;
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
     xformedit.cb_ch_actual.Checked:=qrz.FieldByName('actual').AsBoolean;
     xformedit.le_ch_ch.Text:=qrz.FieldByName('ch').Asstring;
     //xformedit.le_ch_url.Text:=qrz.FieldByName('ch').Asstring;
     xformedit.cmb_ch_chtype.Text:=qrz.FieldByName('chtype').Asstring;
     xformedit.le_ch_tscd.text:=qrz.FieldByName('tscd').Asstring;
     xformedit.le_ch_lobs.text:=qrz.FieldByName('lobs').Asstring;
     qrz.Free;
   except
    on e:exception do begin
         log('e','read_ch,e='+e.message);
    end;
   end;


end;
procedure Txformedit.read_ac;
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
     xformedit.cb_ac_actual.Checked:=qrz.FieldByName('actual').AsBoolean;
     xformedit.le_ac_ac.Text:=qrz.FieldByName('ac').Asstring;
     //xformedit.le_ch_url.Text:=qrz.FieldByName('ch').Asstring;
     xformedit.cmb_ac_actype.Text:=qrz.FieldByName('ctyp').Asstring;
     xformedit.le_ac_cp.Text:=qrz.FieldByName('cp').Asstring;
     xformedit.le_ac_tscd.text:=qrz.FieldByName('tscd').Asstring;
   except
    on e:exception do begin
         log('e','read_ch,e='+e.message);
    end;
   end;
   qrz.Free;

end;
procedure Txformedit.read_port;
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
     xformedit.cb_port_actual.Checked:=qrz.FieldByName('actual').AsBoolean;
     xformedit.le_port_nump.Text:=qrz.FieldByName('nump').Asstring;
     xformedit.le_port_tmr.Text:=qrz.FieldByName('tmr').Asstring;
     xformedit.le_port_nmr.Text:=qrz.FieldByName('nmr').Asstring;
     xformedit.le_port_tscd.text:=qrz.FieldByName('tscd').Asstring;
   except
    on e:exception do begin
         log('e','read_port,e='+e.message);
    end;
   end;
   qrz.Free;

end;
procedure Txformedit.read_sensor;
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
     xformedit.cb_sens_ignore.Checked:=qrz.FieldByName('ignore').AsBoolean;
     xformedit.le_sens_name.Text:=qrz.FieldByName('name').Asstring;
     xformedit.le_sens_code.text:=qrz.FieldByName('code').Asstring;
     xformedit.le_sens_tscd.text:=qrz.FieldByName('tscd').Asstring;
   except
    on e:exception do begin
         log('e','read_sensor,e='+e.message);
    end;
   end;
   qrz.Free;

end;


procedure Txformedit.FormCreate(Sender: TObject);
begin

end;

procedure Txformedit.bb_ac_cancelClick(Sender: TObject);
begin

end;

end.

