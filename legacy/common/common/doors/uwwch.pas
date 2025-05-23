unit uwwch;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, StdCtrls, Menus,
  Types,SQLDB,laz.VirtualTrees;

type

  { Tformwwch }

  Tformwwch = class(TForm)
    bb_comp_cancel: TBitBtn;
    bb_comp_ok: TBitBtn;
    dbg: TDBGrid;
    ds: TDataSource;
    lsm: TListBox;
    md: TMemDataset;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    poplsm: TPopupMenu;
    procedure bb_comp_cancelClick(Sender: TObject);
    procedure bb_comp_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure prepare(fn,f:string;ttg:integer;cnd:pvirtualnode);
    procedure read1(fn,f:string;ttg:integer;cnd:pvirtualnode);
    procedure readandsave;

  private

  public

  end;

var
  formwwch: Tformwwch;
   sll :tstringlist;
   cf,cfn  :string;
   cttg,cbid:integer;

implementation

{$R *.lfm}
uses umain,uglink;

{ Tformwwch }
procedure Tformwwch.read1(fn,f:string;ttg:integer;cnd:pvirtualnode);
var
s,myid:string;
qrz:TSQLQuery;
dss:pvstrecord;
fx:boolean;
begin
     fx:=false;
     show;
     dss:=form1.vst.GetNodeData(cnd);
     myid:=inttostr(dss^.dbmyid);
     cbid:=dss^.dbmyid;


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
      md.FieldByName('app').Asstring:=trim(qrz.FieldByName('app').Asstring);
      md.FieldByName('ch').Asstring:=trim(qrz.FieldByName('ch').Asstring);
      md.FieldByName('drv').Asstring:=trim(qrz.FieldByName('drv').Asstring);
      md.FieldByName('chtype').Asstring:=trim(qrz.FieldByName('chtype').Asstring);
      md.FieldByName('lobs').Asstring:=trim(qrz.FieldByName('lobs').Asstring);
      qrz.next;
     end;
     if fx then  md.Post;
end;


procedure Tformwwch.prepare(fn,f:string;ttg:integer;cnd:pvirtualnode);

begin
       cf:=f;
       cttg:=ttg;
       cfn:=fn;
       show;
     if f='e' then begin
       read1(fn,f,ttg,cnd);
       exit;
     end;
     if f='i' then begin
        read1(fn,f,ttg,cnd);
       exit;
     end;


end;


procedure Tformwwch.readandsave;
var
 line,rc:string;
begin

    md.First;
      sll.Values['actual'] :=md.FieldByName('actual').Asstring;
      sll.Values['app']    :=md.FieldByName('app').Asstring;
       sll.Values['drv']    :=md.FieldByName('drv').Asstring;
      sll.Values['ch']     :=md.FieldByName('ch').Asstring;
      sll.Values['chtype'] :=md.FieldByName('chtype').Asstring;
      sll.Values['lobs']   :='10';
       if cf='e' then line:='update '+cfn+' set actual='+sll.Values['actual']+zp;
       if cf='i' then line:='insert into '+cfn+'(tag,bp,drv,actual,app,ch,chtype,lobs)values(';
       if cf='e' then begin
        line:=line+
        ' bp='+inttostr(cbid)+zp+
        ' app=' +ap+sll.values['app']+ap+zp+
        ' ch='  +ap+sll.values['ch']+ap+zp+
        ' chtype='+ap+sll.values['chtype']+ap+zp+
        ' lobs='+sll.values['lobs']+
        '  where myid='+inttostr(cbid);

        form1.log('c','line='+line);
        rc:=form1.selfupd(line);
         if rc='ok' then begin
         lsm.Font.Color:=cllime;
         lsm.Clear;
         lsm.Items.Add(rc);
        end;
         if rc<>'ok' then begin
         lsm.Font.Color:=clred;
         lsm.Clear;
         lsm.Items.Add(rc);
        end;
       end;
      {
        if cf='e' then begin
        line:=line+
        ' set actual='+sll.Values['actual']+zp+
        ' bp='+inttostr(cbid)+zp+
        ' app='+sll.Values['app']+zp+
        ' ch='+sll.Values['ch']+zp+
        ' chtype='+sll.Values['chtype']+zp+
        ' lobs='+sll.Values['lobs']+zp+
        ' where myid='+inttostr(cbid);
        rc:=form1.selfupd(line);
        if rc='ok' then begin
         lsm.Font.Color:=cllime;
         lsm.Clear;
         lsm.Items.Add(rc);
          if rc<>'ok' then begin
         lsm.Font.Color:=clred;
         lsm.Clear;
         lsm.Items.Add(rc);
        end;
       }



        if cf='i' then begin
        line:=line+
         '1'+zp+
         inttostr(cbid)+zp+
         ap+ sll.Values['drv']+ap+zp+
         sll.Values['actual']+zp+
         ap+sll.values['app']+ap+zp+
        ap+sll.values['ch']+ap+zp+
        ap+sll.values['chtype']+ap+zp+
        sll.values['lobs']+')';
        form1.log('c','line='+line);
        rc:=form1.selfupd(line);
        if rc='ok' then begin
         lsm.Font.Color:=cllime;
         lsm.Clear;
         lsm.Items.Add(rc);
        end;
         if rc<>'ok' then begin
         lsm.Font.Color:=clred;
         lsm.Clear;
         lsm.Items.Add(rc);
        end;

       end;

     end;



procedure Tformwwch.bb_comp_cancelClick(Sender: TObject);
begin
  close;
end;

procedure Tformwwch.bb_comp_okClick(Sender: TObject);
begin

  readandsave;
end;

procedure Tformwwch.FormCreate(Sender: TObject);
begin
    sll:=tstringlist.create;
end;

procedure Tformwwch.MenuItem1Click(Sender: TObject);
begin
  lsm.Clear;
end;

end.

