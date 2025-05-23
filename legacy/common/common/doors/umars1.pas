unit umars1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  laz.VirtualTrees, ImgList, ExtCtrls,SQLDB;

type

  { Tformmars1 }

  Tformmars1 = class(TForm)
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    pop1: TPopupMenu;
    StatusBar1: TStatusBar;
    vstmars: TLazVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    function  fnn(ndo:PVirtualNode;sl:tstringlist):PVirtualNode;
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure vstmarsBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstmarsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstmarsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstmarsChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: Boolean);
    procedure vstmarsGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstmarsGetImageIndexEx(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer;
      var ImageList: TCustomImageList);
    procedure vstmarsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstmarsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    function    readmarscount:integer;
    procedure   reread;
    function      fdeletend(cnd:pvirtualnode):boolean;
    function    findchcknd(vt:TLazVirtualStringTree):tstringlist;
    procedure crndlocinmars(ndm:pvirtualnode);
    function  fnnmars(ndo:PVirtualNode;sl:tstringlist):PVirtualNode;
    function  findndnm0tag(nm:string;tgg:integer):pvirtualnode;





  private

  public

  end;

var
  formmars1: Tformmars1;
  currnd,currndmars : pvirtualnode;

implementation

{$R *.lfm}
uses umain,umdlog,ulazfunc,uglink;


{ Tformmars1 }

function Tformmars1.findndnm0tag(nm:string;tgg:integer):pvirtualnode;
var
i,limit,n:integer;
nd:pvirtualnode;
data:pvstrecord;
begin

     form1.log('y','start findndnm0tag  NM='+nm+'>');
     form1.log('L','start findndnm0tag  NM='+nm+'>');
     //showmessage('start findndnm0tag  NM='+nm+'>');
      try
        result:=nil;
        //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
        nd:=vstmars.getfirst(true);
        data:=vstmars.getnodedata(nd);
        limit:=vstmars.TotalCount;
        n:=0;
        while true do begin
         application.processmessages;
         n:=n+1;
         if n>limit then begin
          showmessage('formmars1.findndnm0tag n>limit');
          exit;
         end;
        // application.processmessages;
         nd:=vstmars.getnext(nd);
         //form1.log('y','nm0='+data.nm0+'>');
         if not assigned(nd) then exit;
         data:=vstmars.getnodedata(nd);
          if trim(data^.nm0)=nm  then   begin
            result:=nd;
            form1.log('l','findndnm0tag FOUND FOUND ='+data^.nm0);
            exit;
          end;
        end;
        showmessage('nm='+nm);
        form1.log('y','findndnm0tag not found nm='+nm);
        exit;
      except
        on e:exception do begin
         form1.log('e','findndnm0tag,e='+e.message+'/i='+inttostr(i));
       end;
      end;
end;


function Tformmars1.fnnmars(ndo:PVirtualNode;sl:tstringlist):PVirtualNode;
var
ndn:PVirtualNode;
data:PVSTRecordloc;
nm,s:string;
i,n:integer;
begin
        n:=0;
       // SHOWMESSAGE('fnnloc='+SL.TEXT);
        try
         //VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions+[toCheckSupport];
         ndn:=vstmars.AddChild(ndo);

        // log('y','AFTER ADDCHILD ');
         if sl.Values['ndcheck']='y' then begin
          ndn^.CheckType := ctTriStateCheckBox;
          if sl.Values['ndcheck_state'] ='y'    then vstmars.CheckState[ndn]:= cscheckedNormal;
          if sl.Values['ndcheck_state']<>'n'    then vstmars.CheckState[ndn]:= csUncheckedNormal;
          //vst.CheckState[ndn]:= csUncheckedNormal;
         n:=1;
          if not (vsInitialized in ndn^.States) then  vstmars.ReinitNode(ndn,false);
            ndn^.CheckType := ctCheckBox;
             //Data := VST.GetNodeData(ndn);
         end;

         if ndn=nil then begin
           SHOWMESSAGE('TUT NIL');
          exit;
         end;
         n:=2;
         data:=vstmars.GetNodeData(ndn);
         data^.abi:=vstmars.AbsoluteIndex(ndn)
        finally
        end;
       //  SHOWMESSAGE('================================================');
       //   SHOWMESSAGE('@@@@@='+sl.text);
          data^.ndp:=ndo;
          data^.nm0:=sl.Values['nm0'];
          data^.sti:=strtoint(sl.Values['sti']);
          n:=3;
               //log('m','n='+inttostr(n));
               // log('m','n='+inttostr(n)+' /sti1='+sl.Values['sti1']);
          data^.sti1:=strtoint(sl.Values['sti1']);
             //log('m','n='+inttostr(n));
          n:=4;
          data^.tag:=strtoint(sl.Values['tag']);
             //log('m','n='+inttostr(n));
         // SHOWMESSAGE('FNNLOC NEW TAG='+INTTOSTR(data^.tag)+' stag='+sl.Values['tag']);
          n:=5;
          try
           data^.smrn:=sl.Values['smrn'];  ;
          except
           data^.smrn:='-1';
          end;

          try
           data^.dbmyid:=strtoint(sl.Values['bpp']);
          except
           data^.dbmyid:=-1;
          end;
          n:=9;
          data^.nm0:=sl.Values['nm0'];
          data^.nm1:=sl.Values['nm1'];
          data^.nm2:=sl.Values['nm2'];
          data^.nm3:=sl.Values['nm3'];
          data^.nm4:=sl.Values['nm4'];
          form1.log('m','n='+inttostr(n));
          vstmars.Refresh;
          result:=ndn;



        //except
         // on ee:exception DO BEGIN
         //  form1.log('e','fnloc n='+inttostr(n)+' / eee='+ee.Message);
         // end;
      // end;

end;


function Tformmars1.fdeletend(cnd:pvirtualnode):boolean;
var
 data:pvstrecord;
 dataloc:pvstrecordloc;
 nm,dbmyid,tbn,s:string;
 ttg:integer;

begin

      data:=vstmars.GetNodeData(cnd);
      nm:=data^.nm0;
      form1.log('y','fdeletend='+nm);
      if not  form1.yesno('@@@@ Вы действительно хотите удалить узел и все дочерние элементы')then EXIT;
      form1.log('m','nm='+nm+'>');

      data:=vstmars.GetNodeData(cnd);
      dbmyid:=inttostr(data^.dbmyid);
        ttg:=data^.tag;
        tbn:='tss_marsrut';
        s:='delete from '+tbn+' where myid='+dbmyid;
        form1.log('r','fdeletend s='+s);
        form1.selfupd(s);


      vstmars.DeleteNode(cnd);
      vstmars.refresh;
      form1.log('l','fdeletend s='+s);

end;


procedure Tformmars1.FormCreate(Sender: TObject);
begin

       currnd:=nil;
       VSTmars.NodeDataSize := SizeOf(tpvstrecordloc);
       VSTmars.TreeOptions.MiscOptions := VSTmars.TreeOptions.MiscOptions+[toCheckSupport];
end;

procedure Tformmars1.MenuItem1Click(Sender: TObject);
begin
     close;
end;


function Tformmars1.fnn(ndo:PVirtualNode;sl:tstringlist):PVirtualNode;
var
ndn:PVirtualNode;
data:PVSTRecord;
nm,s:string;
i:integer;
begin

        try
         //VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions+[toCheckSupport];
         ndn:=vstmars.AddChild(ndo);
       //  log('y','AFTER ADDCHILD ');
         if sl.Values['ndcheck']='y' then begin
          ndn^.CheckType := ctTriStateCheckBox;
          if sl.Values['ndcheck_state'] ='y'    then vstmars.CheckState[ndn]:= cscheckedNormal;
          if sl.Values['ndcheck_state']<>'y'    then vstmars.CheckState[ndn]:= csUncheckedNormal;

          if not (vsInitialized in ndn^.States) then  VSTmars.ReinitNode(ndn,false);
             ndn^.CheckType := ctCheckBox
         end;


         //if ndn=nil then begin
         // exit;
         //end;

          //log('y','fnn  NILLLLLLLLLLLLLLLLLLLLLL ?????????????????????????????????????????');;
          data:=vstmars.GetNodeData(ndn);
          data^.ndp:=ndo; //suda 1109
          data^.nm0:=sl.Values['nm0'];
         // form1.log('c','nm0='+data^.nm0);
          data^.sti:=strtoint(sl.Values['sti']);
          data^.sti1:=strtoint(sl.Values['sti1']);

          data^.tag:=strtoint(sl.Values['tag']);
          try
           data^.dbmyid:=strtoint(sl.Values['myid']);
          except
           data^.dbmyid:=-1;
          end;
          data^.nm1:=sl.Values['nm1'];
          data^.nm2:=sl.Values['nm2'];
          data^.nm3:=sl.Values['nm3'];
          data^.nm4:=sl.Values['nm4'];
          vstmars.Refresh;
          result:=ndn;
          data:=vstmars.GetNodeData(ndn);
         // showmessage('fnn nm0='+data^.nm0);
        except
     on ee:exception DO BEGIN
      // form1.log('e','fnewnode ,eee='+ee.Message);
     end;
    end;
end;

procedure Tformmars1.MenuItem3Click(Sender: TObject);
begin
    reread;
end;

procedure Tformmars1.MenuItem4Click(Sender: TObject);
begin
       fdeletend(currnd);
end;

procedure Tformmars1.vstmarsBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  exit;
end;

procedure Tformmars1.vstmarsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
 nc,pid,pidch:integer;
 data,datandp:pvstrecord;
 nm,dbmyid,stag,s:string;
 ndp:pvirtualnode;
 f:boolean;
 abi,idx,ldm0:string;
begin

  data:=vstmars.GetNodeData(node);
  if data=nil then exit;
  CURRND:=NODE;
  currndmars:=node;
  abi:=inttostr(vstmars.AbsoluteIndex(node));
  idx:=inttostr(node^.Index);
  ndp:=form1.getpnd(vstmars,node);
  if ndp=nil THEN begin
    form1.log('r','vstChange NDP=NIL');
   // EXIT;
  end;
  datandp:=vstmars.GetNodeData(ndp);


  form1.log('y','tag='+inttostr(data^.tag)+' /bpsens='+inttostr(data^.bpsens)+' /bploc='+inttostr(data^.bploc)+
  '/DBmyid='+inttostr(data^.dbmyid)+' /mrn='+inttostr(data^.mrn));
  try
   datandp:=vstmars.GetNodeData(node);
   ndp:= data^.ndp;
   nm:=data^.nm0;
   f:=true;
  except
   f:=false;
   form1.log('e','error vstmarschange');
  end;



end;

procedure Tformmars1.vstmarsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode
  );
begin

end;

procedure Tformmars1.vstmarsChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
var
 dl:pvstrecord;
begin

       dl:=vstmars.GetNodeData(node);
       form1.log('w','nm0='+dl^.nm0+' /dbmyid='+inttostr(dl^.dbmyid));
       if newstate=csCheckedNormal    then  dl^.chkstate:=true;
        if newstate=csUncheckedNormal then  dl^.chkstate:=false;

       if dl^.chkstate=TRUE then form1.log('l','normal check')else form1.log('l','uncheck');
      // if newstate=csCheckedNormal then form1.log('l','normal');
       //form1.log('c','checking=');
end;

procedure Tformmars1.vstmarsGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);

  
var
  nd:PVirtualNode ;
  Data: PVSTRecord;
  vv:TBaseVirtualTree;
  n:integer;
begin


  data:=vstmars.GetNodeData(node);
  ImageIndex := -1;


  if  (column =0)  then begin
   ImageIndex :=data^.sti;
  end;

  if  (column =1) then begin
   //ImageIndex :=-1;
   ImageIndex :=data^.sti1;
  end;
// if  (column =3) then begin
//   ImageIndex := 0 //data.sti3;
//  end;

  nd:=node;



end;

procedure Tformmars1.vstmarsGetImageIndexEx(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer; var ImageList: TCustomImageList
  );
var
  nd:PVirtualNode ;
  Data: PVSTRecord;
  vv:TBaseVirtualTree;
  n:integer;
  begin



  data:=vstmars.GetNodeData(node);
  ImageIndex := -1;


  if  (column =0) then begin
   ImageIndex := data^.sti;
  end;

  if  (column =1) then begin
   ImageIndex :=data^.sti1;
  end;

  //if  column <> 0 then begin
  // exit;
  //end;
  //if  (data.tag< 4) and (column >0) then exit;


  nd:=node;     //vst.GetNodeData(Node);
  //if not Assigned(nd) then exit;
  //data:=vst.GetNodeData(nd);
  ;
  //if df then log('y,vstGetImageIndex='+data.ElementName);
  //imageindex:=data.sti;




end;

procedure Tformmars1.vstmarsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var
data:pvstrecord;
begin
   Data := Sender.GetNodeData(node);
    CellText := '';

    if column = 0 then begin
        CellText := data^.nm0;
    end;
     if column = 1 then begin
        CellText := data^.nm1;
    end;
      if column = 2 then begin
        CellText := data^.nm2;
    end;


   {
    else if column = FUsageCol then begin
        if data.NodeType <> ntSource then exit;

        if assigned(FUsage) and FUsage.ContainsKey(data.id) then
             CellText := IntToStr(FUsage[data.ID])
        else CellText := '0';
    end;
   }
end;

procedure Tformmars1.vstmarsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
data :pvstrecord;
begin
   data:=vstmars.GetNodeData(node);
  //if column=1 then begin
   if (data^.tag=-1)   then begin
   TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
 end;
  if (data^.tag=1)   then begin
   TargetCanvas.Font.Color :=clsilver;   //   suda fontcolor
 end;

  if (data^.tag=4) and (data^.bploc>0)   then begin
   TargetCanvas.Font.Color :=claqua;   //   suda fontcolor
  end;

  if (data^.tag=0) and(data^.sti=42)   then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;
  if (data^.tag=1) and(data^.sti=41)   then begin
    TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
  end;


end;

procedure Tformmars1.crndlocinmars(ndm:pvirtualnode);
var
data:pvstrecord;
nd:pvirtualnode;
qrz:TSQLQuery;
s,mrn,myid,bpsens,bploc,bpself,nm:string;
sl:tstringlist;
begin
   data:=vstmars.GetNodeData(ndm);
   bpself:=inttostr(data^.dbmyid);
 {
  s:='select tssloc_locations.name,tss_marsrut.myid ,tss_marsrut.tag , tss_marsrut.mrn '+
  ' from tssloc_locations,tss_marsrut where'+
  ' tssloc_locations.myid =tss_marsrut.bploc'+
  ' and tss_marsrut .bpself='+bpself+
  ' and tss_marsrut.tag=3';
  }

  s:='select tssloc_locations.name,tss_marsrut.myid ,tss_marsrut.tag , tss_marsrut.mrn '+
    ' from tssloc_locations,tss_marsrut '+
    ' where  '+
    ' tssloc_locations.myid =tss_marsrut.bprootloc '+
    ' and tss_marsrut.bpself='+bpself +
    ' and tss_marsrut.tag=3';




   form1.log('l','s='+s);
   qrz:=TSQLQuery.Create(self);
   qrz.DataBase:=formglink.pqc1;
   qrz.SQL.Add(s);
   qrz.Active:=true;
   sl:=tstringlist.Create;
    while not qrz.eof do begin
       myid:=qrz.FieldByName('myid').AsString;
       mrn:=qrz.FieldByName('mrn').AsString;
       nm:=qrz.FieldByName('name').AsString;
     //  bpsens:=qrz.FieldByName('bpsens').AsString;
      // bploc:=qrz.FieldByName('bploc').AsString;
       form1.log('y','myid================================='+myid);
       sl.Values['nm0']:=nm;
       // sl.Values['nm1']:=inttostr(i)+' nm1';
       sl.Values['dbmyid']:=myid;
        sl.Values['myid']:=myid;
        sl.Values['tag']:='3';
        sl.Values['sti']:='-1';
        sl.Values['sti1']:='-1';
        sl.Values['ndcheck']:='n';
        sl.Values['ndcheck_state']:='n';
        nd:=fnn(ndm,sl);
       //  VSTmars.Expanded[ndm]:=true;
       qrz.Next;
    end;
  //  showmessage('AFTER crndlocinmars') ;


end;

procedure Tformmars1.reread;
var
data:pvstrecord;
nd:pvirtualnode;
qrz:TSQLQuery;
s,mrn,myid,bpsens,bploc:string;
sl:tstringlist;
begin
   try
    vstmars.Clear;
     s:='select  *  from tss_marsrut  where tag=1 order by mrn';
     //form1.log('l','s='+s);
     qrz:=TSQLQuery.Create(self);
     qrz.DataBase:=formglink.pqc1;
     qrz.SQL.Add(s);
     qrz.Active:=true;
     sl:=tstringlist.Create;
     while not qrz.eof do begin
       myid:=qrz.FieldByName('myid').AsString;
       mrn:=qrz.FieldByName('mrn').AsString;
       bpsens:=qrz.FieldByName('bpsens').AsString;
       bploc:=qrz.FieldByName('bploc').AsString;
       sl:=tstringlist.Create;
        sl.Values['nm0']:=mrn;
       // sl.Values['nm1']:=inttostr(i)+' nm1';
        sl.Values['dbmyid']:=myid;
        sl.Values['myid']:=myid;
        sl.Values['tag']:='1';
        sl.Values['sti']:='31';
        sl.Values['sti1']:='-1';
        sl.Values['tag']:='1';
        sl.Values['ndcheck']:='y';
        sl.Values['ndcheck_state']:='n';
        nd:=fnn(currnd,sl);
        data:=vstmars.GetNodeData(nd);
        data^.dbmyid:=strtoint(myid);
        data^.bpsens:=strtoint(bpsens);
        data^.bploc:=strtoint(bploc);
        data^.nm0:=sl.Values['nm0'];  ;
        data^.mrn:=strtoint(mrn);
       // form1.log('l','mrn='+sl.Values['nm0']);
        crndlocinmars(nd);
        qrz.Next;
     end;
     vstmars.Refresh;

   except
    on e:exception do begin
      form1.log('e','reread,e='+e.message);
    end;
   end;

end;


function Tformmars1.readmarscount:integer;
var
qrz:TSQLQuery;
s:string;
begin
   try
     result:=-1;
     s:='select  count(*) from tss_marsrut  where tag=1';
     form1.log('l','s='+s);
     qrz:=TSQLQuery.Create(self);
     qrz.DataBase:=formglink.pqc1;
     qrz.SQL.Add(s);
     qrz.Active:=true;
     result:=qrz.Fields[0].AsInteger;
     form1.log('r','result='+inttostr(result));


   except
          on e:exception do begin
           form1.log('e','readmarscount,e='+e.message);
         end;

   end;


end;

function Tformmars1.findchcknd(vt:TLazVirtualStringTree):tstringlist;
var
dl:pvstrecord;
nd:pvirtualnode;
cc,mrn:integer;
sl:tstringlist;
s:string;
begin
      //  try
        result:=nil;
        //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
        nd:=vt.getfirst(true);
        dl:=vt.getnodedata(nd);
        sl:=tstringlist.create;
        //showmessage('findchcknd first nm='+dl^.nm0);
        if  dl^.chkstate then begin
         mrn:=dl^.mrn;
         s:=inttostr(mrn);
         sl.Add(s+','+inttostr(dl^.dbmyid));
        end;


        cc:=vt.CheckedCount;
        form1.log('m',' /cc='+inttostr(cc));
       {
        if cc=0 then begin
         showmessage('ВЫ НЕ ВЫБРАЛИ МАРШРУТ(ы). ПОВТОРИТЕ');
         exit;
        end;
       }
      //  sl:=tstringlist.Create;
        while true do begin
         application.processmessages;
         nd:=vt.getnext(nd);
         //form1.log('y','nm0='+data.nm0+'>');
         if not assigned(nd) then begin
           result:=sl;
           exit;
         end;
         dL:=vt.getnodedata(nd);
         if  dl^.chkstate then begin
          DL:=vt.GetNodeData(ND);
          form1.log('l','SELECTED nm0='+dl^.nm0+' /cc='+inttostr(cc));
         // s:=inttostr(mrn);
         // sl.Add(s+','+inttostr(dl^.dbmyid));
          mrn:=dl^.mrn;
          s:=inttostr(mrn);
          sl.Add(s+','+inttostr(dl^.dbmyid));
          Vt.Refresh;
         end;
        end;
        showmessage('text='+sl.text);
        result:=sl;


end;
procedure Tformmars1.MenuItem2Click(Sender: TObject);
var
sl:tstringlist;
mrn:integer;
s,rc:string;
begin
        mrn:=readmarscount+1;
        s:='insert into tss_marsrut(mrn,tag)values('+
           inttostr(mrn)+zp+
           '1'+')';
        form1.log('y','s='+s);

       rc:=form1.selfupd(s);

     //  showmessage('NEW MARS 1');
        sl:=tstringlist.Create;
        sl.Values['nm0']:=inttostr(mrn);
       // sl.Values['nm1']:=inttostr(i)+' nm1';
        sl.Values['tag']:='1';
        sl.Values['sti']:='31';
        sl.Values['sti1']:='-1';
        sl.Values['tag']:='1';
        sl.Values['ndcheck']:='y';
        sl.Values['ndcheck_state']:='n';
        fnn(nil,sl);
        sl.Free;
        reread;


end;

end.

