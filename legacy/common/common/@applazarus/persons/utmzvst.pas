unit utmzvst;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Menus,laz.VirtualTrees,SQLDB,
  umain, ImgList, StdCtrls, RxTimeEdit;

type
  tmzint= record
    bp     :string;
    name   :string;
    day    :string;
    dayow  :string;
    zapret :boolean;
    start  :string;
    stop   :string;
   end;


type

  { Tformtmzvst }

  Tformtmzvst = class(TForm)
    cbzapret: TCheckBox;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    pop2: TPopupMenu;
    rxtmz1: TRxTimeEdit;
    rxtmz2: TRxTimeEdit;
    tmzvst: TLazVirtualStringTree;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    tmzpopnil: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure tmzvstBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
     procedure tmzvstChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    function  newnode(asf:string;cnd:pvirtualnode;ds:pvstrecord):pvirtualnode;
    procedure tmzvstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: Boolean);
    procedure tmzvstGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure tmzvstGetImageIndexEx(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer;
      var ImageList: TCustomImageList);
    procedure tmzvstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tmzvstPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure crtmzvst(nm,defzap:string);
    procedure rereadvst;
    function  getfirst(nmz:string):string;
    function  getinterval(myid:string):tmzint;




  private

  public

  end;

var
  formtmzvst: Tformtmzvst;
  currnd:pvirtualnode;

implementation

{$R *.lfm}
uses ulazfunc;

{ Tformtmzvst }

procedure Tformtmzvst.tmzvstChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  ds:pvstrecord;
  myid,ttg:string;
begin
        currnd:=node;
        if currnd=nil then begin
         tmzvst.PopupMenu:=tmzpopnil;
         EXIT;
        end;
        ds:=tmzvst.GetNodeData(currnd);
        myid:=inttostr(ds^.myid);
        ttg:=inttostr(ds^.tag);
        if ds^.tag=1 then   tmzvst.PopupMenu:=tmzpopnil;
        if ds^.tag=2 then   tmzvst.PopupMenu:=pop2;
        form1.log('c','tmzvstChange  tag='+ttg+' / myid='+myid+' /bp='+inttostr(ds^.bp)+'/name='+ds^.tmzname);
end;

function Tformtmzvst.newnode(asf:string;cnd:pvirtualnode;ds:pvstrecord):pvirtualnode;
var
  nd:pvirtualnode;
  dsx,data:pvstrecord;
  s:string;
begin   if asf='i' then   nd:=tmzvst.InsertNode(cnd,amInsertafter,ds);
        if asf='a' then   nd:=tmzvst.AddChild(cnd,ds);
       //  s:='newnode sti='+inttostr(ds^.sti)+',ndcheck_state='+booltostr(ds^.ndcheck_state);
       // log('l',s);
        //if ds^.ndcheck=true  then begin
        if ds^.ndcheck_state then begin
          nd^.CheckType     := ctTriStateCheckBox;
          tmzvst.CheckState[nd]:= cscheckedNormal;

          nd^.CheckType := ctCheckBox;
          Data := tmzVST.GetNodeData(nd);
          if not (vsInitialized in nd^.States) then  tmzVST.ReinitNode(nd, False);

        end;

        dsx:=tmzvst.getnodedata(nd);
        dsx^:=ds^;
        result:=nd;
end;

procedure Tformtmzvst.tmzvstChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
var
  dl: pvstrecord;
begin

  dl := tmzvst.GetNodeData(node);
  dl^.ndcheck_state:=true;
  // log('w','nm0='+dl^.nm0+' /dbmyid='+inttostr(dl^.dbmyid));
  if newstate = csCheckedNormal then  dl^.ndcheck_state := True;
  if newstate = csUncheckedNormal then  dl^.ndcheck_state := False;


end;

procedure Tformtmzvst.tmzvstGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);

var
nd: PVirtualNode;
Data: PVSTRecord;
vv: TBaseVirtualTree;
n: integer;
begin

Data := tmzvst.GetNodeData(node);
ImageIndex := -1;

if (column = 0) then
begin
  ImageIndex := Data^.sti;
end;

if (column = 1) then
begin
  //ImageIndex :=-1;
  ImageIndex := Data^.sti1;
end;
// if  (column =3) then begin
//   ImageIndex := 0 //data.sti3;
//  end;

nd := node;


end;

procedure Tformtmzvst.tmzvstGetImageIndexEx(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer; var ImageList: TCustomImageList
  );
var
nd: PVirtualNode;
Data: PVSTRecord;

vv: TBaseVirtualTree;
n: integer;
begin

Data := tmzvst.GetNodeData(node);
ImageIndex := -1;


if (column = 0) then
begin
  ImageIndex := Data^.sti;
end;

if (column = 1) then
begin
  ImageIndex := Data^.sti1;
end;

//if  column <> 0 then begin
// exit;
//end;
//if  (data.tag< 4) and (column >0) then exit;


nd := node;




end;

procedure Tformtmzvst.tmzvstGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);

var data : pvstrecord;
begin
    Data := Sender.GetNodeData(node);
    //data := tmzvst.GetNodeData(node);
    CellText := '';

    if column = 0 then begin
        CellText :=  data^.nm0;
    end;
     if column = 1 then begin
        CellText := data^.nm1;
    end;
      if column = 2 then begin
        CellText := data^.nm2;
    end;




end;

procedure Tformtmzvst.tmzvstPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
data :pvstrecord;
rc:boolean;
begin
   data:=tmzvst.GetNodeData(node);
  //if column=1 then begin
   TargetCanvas.Font.Color :=clwhite;
   if (data^.tag=-1)   then begin
   TargetCanvas.Font.Color :=clwhite;   //   suda fontcolor
 end;
  if (data^.tag=1)   then begin
   //TargetCanvas.Font.Color :=clsilver;   //   suda fontcolor
 end;

{
  if data^.tag=4 then begin
   rc:= checklinkbploc(data^.dbmyid);
   if rc then begin
    TargetCanvas.Font.Color :=claqua;
    TargetCanvas.Font.Size:=16;
    TargetCanvas.font.Style:=  TargetCanvas.font.Style + [fsBold];
   end else begin
   //  TargetCanvas.Font.Color :=clskyblue;
  end;

  end;
}

  if (data^.tag=0) and(data^.sti=42)   then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;
  if (data^.tag=1) and(data^.sti=41)   then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;
   if (data^.tag=-100) and (data^.sti=42) and(column=1)  then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;
   if (data^.tag=-101) and (data^.sti=42) and(column=1)  then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;
   if (data^.tag=-102) and (data^.sti=42) and(column=1)  then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;
  if (data^.tag=-109) and (data^.sti=42) and(column=1)  then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;
  if (data^.tag=-111) and (data^.sti=42) and(column=1)  then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;
   if (data^.tag=-111) and (data^.sti=44) and(column=1)  then begin
    TargetCanvas.Font.Color :=clred;   //   suda fontcolor
  end;

end;



procedure Tformtmzvst.FormCreate(Sender: TObject);
VAR
T1,T2:string;

begin
   
     t1:='00:00:00';
     t2:='23:59:59';
     rxtmz1.Time:=strtotime(t1);
     rxtmz2.Time:=strtotime(t2);


   tmzvst.NodeDataSize := SizeOf(tpvstrecord);
      tmzvst.TreeOptions.MiscOptions := tmzvst.TreeOptions.MiscOptions + [toCheckSupport];
end;
function Tformtmzvst.getfirst(nmz:string):string;
var
s:string;
rc:trcfld;
begin
        s:='select myid  from tss_tmzvst where name='+ap+nmz+ap+' order  by MYID asc limit 1';
        rc:=form1.readfld(s);
        result:=rc.value;

end;

procedure Tformtmzvst.rereadvst;
var
bp,day,myid,nmz,s,s0,s1,s2,start,stop,ss:string;
ds:pvstrecord;
ndn,ndi:pvirtualnode;
qrx,qrn:tsqlquery;
sl:tstringlist;
i:integer;
zapret:boolean;
begin
           tmzvst.Clear;
           qrn:=form1.calcqr('select distinct name from tss_tmzvst order by name');
           sl:=tstringlist.Create;
           while not qrn.eof do begin
            nmz:=qrn.FieldByName('name').asstring;
            myid:=getfirst(nmz);
            sl.Add(nmz+zp+myid);
            qrn.next;
           end;
           //showmessage(sl.text);
           for i:=0 to sl.Count-1 do begin;
            ss:=sl[i];
            nmz:=dmfunc.ExtractStr(1,ss,',');
            bp:=dmfunc.ExtractStr(2,ss,',');
            ndn:=tmzvst.AddChild(nil,NIL);
            ds:=tmzvst.getnodedata(ndn);
            ds^.sti:=12;
            ds^.sti1:=-1;
            ds^.tag:=1;
            ds^.nm0:=nmz;

            s:='select  * from tss_tmzvst where name='+ap+nmz+ap+' order by name,dayow,day ';
            form1.log('w','reread='+s);
            qrx:=form1.calcqr(s);
            while not qrx.eof do begin
             ndi:=tmzvst.AddChild(ndn,NIL);
             ds:=tmzvst.getnodedata(ndi);
             ds^.bp:=strtoint(bp);
             s0:=nmz;
             s1:=qrx.FieldByName('day').aSSTRING;
             start:=qrx.FieldByName('start').aSSTRING;
             stop :=qrx.FieldByName('stop').aSSTRING;
             zapret :=qrx.FieldByName('zapret').asboolean;
             ds^.nm1:=s1;
             ds^.myid:=qrx.FieldByName('myid').aSinteger;
             ds^.nm2:=start+' '+stop ;
             ds^.nm0:=' '+inttostr(ds^.myid)+zp+inttostr(ds^.bp);
             ds^.tag:=2;

             if zapret  then ds^.sti:=44 else ds^.sti:=42;
             ds^.sti1:=-1;
             ds^.ndcheck_state:=false;
             ds^.tmzname:=nmz;
             qrx.Next;


            end;
           end;





end;

procedure Tformtmzvst.MenuItem1Click(Sender: TObject);
var
  nd:pvirtualnode;
  ds:pvstrecord;
  nms:string;
  i:integer;
begin
      exit;
      i:=1;

       //showmessage('newzone');
        //nd:=tmzvst.AddChild(nil);
        nd:=tmzvst.AddChild(currnd,NIL);
        ds:=tmzvst.getnodedata(nd);
        ds^.nm0:=datetimetostr(now);
        ds^.sti:=12;     //strtoint(sti);
        ds^.sti1:=-1;
        ds^.ndcheck_state:=false;

end;

procedure Tformtmzvst.crtmzvst(nm,defzap:string);
 var
 j:integer;
 bp,s,day,start,stop:string;
 begin
     start:=timetostr(rxtmz1.Time);
     stop :=timetostr(rxtmz2.Time);
     s:='delete from tssgls_nametmz where name='+ap+nm+ap;
     form1.selfupd(s);
     bp:='-1';
     for j:=1 to 7 do begin
      if j=2 then  bp:=inttostr(form1.getlastmyid('tss_tmzvst'));
      day:=sysutils.LongDayNames[j];
      s:='insert into tss_tmzvst (bp,zapret,start,stop,name,day,dayow)values('+
      bp+zp+
      defzap+zp+
      ap+start+ap+zp+
      ap+stop+ap+zp+
      ap+nm+ap+zp+
      ap+day+ap+zp+
      inttostr(j)+')';
      form1.selfupd(s);
      form1.totmz(nm,defzap);
      //bp:=inttostr(form1.getlastmyid('tss_tmzvst'));
      form1.log('w','s='+s);
     end;
     s:='insert into tss_tmzvst (bp,zapret,start,stop,name,day,dayow)values('+
      bp+zp+
      defzap +zp+
      ap+start+ap+zp+
      ap+stop+ap+zp+
      ap+nm+ap+zp+
      ap+'Праздник'+ap+zp+
      inttostr(8)+')';
      form1.selfupd(s);
      form1.totmz(nm,'true');
      form1.log('c','spr='+s);

end;

procedure Tformtmzvst.MenuItem3Click(Sender: TObject);
var
  nmz,s:string;
begin
       nmz:='ВСЕГДА';
       crtmzvst(nmz,'false');

end;

procedure Tformtmzvst.MenuItem4Click(Sender: TObject);
var
  nmz,s:string;
begin
       nmz:='НИКОГДА';
       crtmzvst(nmz,'TRUE');

end;

procedure Tformtmzvst.MenuItem5Click(Sender: TObject);
var
  nm:string;
begin
          form1.Inputsg('Введите  имя временной зоны',nm);
          formtmzvst.crtmzvst(nm,'true');
end;

procedure Tformtmzvst.MenuItem6Click(Sender: TObject);
begin
       rereadvst;
end;

procedure Tformtmzvst.MenuItem7Click(Sender: TObject);
var
  ds:pvstrecord;
  myid,s,zaps:string;
  ti:tmzint;
begin
        //showmessage('tut');
        if cbzapret.Checked then zaps:='true' else zaps:='false';
        ds:=tmzvst.GetNodeData(currnd);
        myid:=inttostr(ds^.myid);
        s:='update tss_tmzvst '+
        'set zapret='+zaps+zp+
        ' start='+ap+timetostr(rxtmz1.time)+ap+zp+
        ' stop='+ap+timetostr(rxtmz2.time)+ap+
        ' where myid='+myid;
        form1.log('l',s);
        form1.selfupd(s);
        ti:=formtmzvst.getinterval(myid);
        ds^.nm1:=ti.day;
        ds^.nm2:=ti.start+' '+ti.stop;
        if ti.zapret then ds^.sti:=44 else ds^.sti:=42;
      //  formtmzvst.rereadvst;

end;

function Tformtmzvst.getinterval(myid:string):tmzint;
var
  s:string;
  qrx:tsqlquery;
  ti:tmzint;
begin
      s:='select * from tss_tmzvst where myid='+myid;
      qrx:=form1.calcqr(s);
      ti.bp:=qrx.FieldByName('bp').asstring;
      ti.name  :=qrx.FieldByName('name').asstring;
      ti.day   :=qrx.FieldByName('day').asstring;
      ti.dayow :=qrx.FieldByName('dayow').asstring;
      ti.start :=qrx.FieldByName('start').asstring;
      ti.stop :=qrx.FieldByName('stop').asstring;
      ti.zapret :=qrx.FieldByName('zapret').asboolean;
      result:=ti;
end;

procedure Tformtmzvst.MenuItem8Click(Sender: TObject);
var
  ti:tmzint;
  ds:pvstrecord;
  myid,s:string;
  nmz,day,dayow,bp,zaps,start,stop:string;
begin

      ds:=tmzvst.GetNodeData(currnd);
      myid:=inttostr(ds^.myid);
      bp:=inttostr(ds^.BP);
      ti:=getinterval(myid);
      if cbzapret.Checked then zaps:='true' else zaps:='false';
      s:='insert into tss_tmzvst(name,day,dayow,bp,zapret,start,stop)values('+
         ap+ti.name+ap+zp+
         ap+ti.day+ap+zp+
         ti.dayow+zp+
         bp+zp+
         zaps+zp+
         ap+timetostr(rxtmz1.Time)+ap+zp+
         ap+timetostr(rxtmz2.Time)+ap+
         ')';

      form1.log('y','add interval s='+s);
      form1.selfupd(s);
      formtmzvst.rereadvst;

end;

procedure Tformtmzvst.MenuItem9Click(Sender: TObject);
var
  ds:pvstrecord;
  bp,myid,s:string;
begin

        if not form1.yesno ('ВЫ ДЕЙСТВИТЕЛЬНО ХОТИТЕ УДАЛИТЬ ИНТЕРВАЛ ???' ) then exit;
        ds:=tmzvst.GetNodeData(currnd);
        myid:=inttostr(ds^.myid);
        bp:=inttostr(ds^.BP);

        s:='delete from tss_tmzvst where myid='+myid;
        form1.selfupd(s);
        tmzvst.DeleteNode(currnd);
        //formtmzvst.rereadvst;
end;

procedure Tformtmzvst.tmzvstBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  data:pvstrecord;
begin
         data:=tmzvst.GetNodeData(node);
end;

end.

