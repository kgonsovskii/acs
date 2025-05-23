unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  StdCtrls, laz.virtualtrees, laz.VTHeaderPopup,base64,zlib,SQLDB, DB, memds,Types,
   ctypes,StrUtils, LCLType,FileUtil, ExtendedTabControls, DateTimePicker ,
  //TSSMQTTC,
  dateutils,
  ImgList,
  fpjson, jsonparser,
 // uformstarter,udtrans,
  UniqueInstance, RxTimeEdit,
  ComCtrls, Buttons, DBGrids, PairSplitter, DBCtrls, ExtDlgs, EditBtn;


type tnewds=record
      root  :string;
      nm0    :string;
      nm1    :string;
      nm2    :string;
      sti    :integer;
      sti1   :integer;
      tag    :integer;
      ndcheck       :boolean;
      ndcheck_state :boolean;
      end;

type tglsfio=record
      bidname1:string;
      name1   :string;
      bidname2:string;
      name2   :string;
      bidname3:string;
      name3   :string;
      flag    :string;
      end;



type
  trcfld= record
    rc    : string;
    value : string;
   end;


type
  tinsr = record
    mes: string;
    myid: integer;
  end;


type tmysysinfo  =record
      mode         :string;   // work or config
      computername :string;
      trclientid   :string;
      ip           :string;
      os           :string;
      username     :string;
      sep          :string;
      traddr       :string;
      baseaddr     :string;
      basename     :string;
      basepsw      :string;
     end;

type tshema_idx =record
     count        :integer;
     end;

type tshema_shn =record
      no           :tshema_idx;
      name         :string;   // work or config
      myid         :integer;
     end;

  type tshema_node =record
      name          :string;   // work or config
      myid          :integer;
      tag           :integer;
     end;

type tsh_uzel = record
     title     :tshema_shn;
     body      :tshema_node;
     end;

type
  tsubsysst= record
    cn   : string;
    pid  :string;
    luxt : int64;
   end;


type
  pvstrecord = ^Tpvstrecord;
  Tpvstrecord = record
  root     :string;
  tmzname  :string;
  ndp      :pvirtualnode;
  nm0      :string;
  nm1      :string;
  nm2     :string;
  myid  :integer;
  level:integer;
  tag  :integer;
  bid  :integer;
  bpsh :integer;
  bp   :integer;
  sti  :integer;
  sti1 :integer;
  ndcheck       :boolean;
  ndcheck_state :boolean;


  end;


type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Button3: TButton;
    Button4: TButton;
    cmbtsspsh: TComboBox;
    dst: TDataSource;
    ds1: TDataSource;
    etscd: TEdit;
    LargeImages: TImageList;
    MainMenu1: TMainMenu;
    md: TMemDataset;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    tdm: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Panel6: TPanel;
    Panel7: TPanel;
    popnil: TPopupMenu;
    p_comcentr: TPanel;
    p_databasef: TPanel;
    p_databases: TPanel;
    p_dms: TPanel;
    p_firebird: TPanel;
    p_sgrd: TPanel;
    P_transport: TPanel;
    p_writerlog: TPanel;
    timerspecwait: TTimer;
    timerstart: TTimer;
    Timer1s: TTimer;
    vst: TLazVirtualStringTree;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;

    UniqueInstance1: TUniqueInstance;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure bttokeyClick(Sender: TObject);
    procedure bitkeysClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure cbactChange(Sender: TObject);
    procedure cd1Change(Sender: TObject);
    procedure cd1Close(Sender: TObject);

    procedure cmbname1CloseUp(Sender: TObject);
    procedure cmbname1DblClick(Sender: TObject);
    procedure cmbname2DblClick(Sender: TObject);
    procedure cmbname3Change(Sender: TObject);
    procedure cmbname3DblClick(Sender: TObject);
    procedure cmbname3EditingDone(Sender: TObject);
    procedure cmbtsspshChange(Sender: TObject);
    procedure dbgCellClick(Column: TColumn);
    procedure ds1DataChange(Sender: TObject; Field: TField);
    procedure ds1StateChange(Sender: TObject);
    procedure ds1UpdateData(Sender: TObject);
    procedure dtstartChange(Sender: TObject);
    procedure DtstopChange(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure le_keypad1DblClick(Sender: TObject);
    procedure le_startChange(Sender: TObject);

    procedure le_startDblClick(Sender: TObject);
    procedure le_stopChange(Sender: TObject);
    procedure le_stopDblClick(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure PageControl3Change(Sender: TObject);
    procedure PageControl4Change(Sender: TObject);
    procedure panaddkeyClick(Sender: TObject);
    procedure Panel12Click(Sender: TObject);
    procedure Panel15Click(Sender: TObject);
    procedure Panel16Click(Sender: TObject);
    procedure Panel17Click(Sender: TObject);
    procedure Panel19Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel9Click(Sender: TObject);
    procedure pantosysClick(Sender: TObject);
    procedure panupdkeyClick(Sender: TObject);
    procedure Pan_name4Click(Sender: TObject);
    procedure sb1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TabSheet3ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TabSheet6ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TabSheet8ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Timer1sTimer(Sender: TObject);
    procedure timerspecwaitTimer(Sender: TObject);
    procedure timerstartTimer(Sender: TObject);
    procedure vstBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure log(pr, txt: string);
  //  function  newnode(asf:string;cnd:pvirtualnode;ds:pvstrecord):pvirtualnode;
    procedure ptitlenode;
    procedure vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: Boolean);
    procedure vstGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure vstGetImageIndexEx(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer; var ImageList: TCustomImageList);
    procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure pereborvst;
    procedure readtsspsh;
    procedure prolog1;
    procedure prolog2;
    procedure prolog3;
    procedure pgsconnect(status:string);
    function  getqr(line:string):TSQLQuery;
    function  getlastmyid(tbn: string): integer;
    function  selfupd(s: string): string;
    function  readfld(LINE:string):trcfld;
    function  yesno(s: string): boolean;
    function  formirinsertdatatree(bidshema:string;nd:pvirtualnode):tstringlist;
    function  Inputsg(const Prompt: string; var Value: string): boolean;
    procedure readdata;
    function  findndofymid(myid:integer): pvirtualnode;
    function  togls(tbn,nm:string):string;
    function  selfupdc(s: string): string;
    procedure read2;
    procedure loadtext(tbn:string;cmb:tcombobox);
    function  calcqr(line:string):TSQLQuery;
    procedure readglsfio;
    procedure linkglsfio(gf:tglsfio);
    function  getcps(myid:string):integer;
    procedure linkonperson(cnd:pvirtualnode);
    function  selpersonsfromnode(cnd:pvirtualnode):string;
    procedure topersinfo;
    function  getcps10(cnd:pvirtualnode):integer;
    procedure updpage_fio;
    procedure readkeys(line:string);
    function  jstosl(sJSON: String):string;
    function  fnewkey:boolean;
    procedure pmsg(cl:int64;txt:string);
    procedure slog(txt:string);
    function  faddkey:string;
    function  checkpersvalues:boolean;
    function  calcsum32(qr:tsqlquery):longword;
    procedure readglstmz;
    procedure readtmz(bidname:string);
    Function  setdaynames: string;
    procedure crstandartzones;
    procedure totmz(nmz,zap:string);
    procedure clearmd(mdx:TMemDataset);
    procedure formirzone(nmz:string);
    function  formirnodeman(cnd:pvirtualnode):string;
    function  fnna(cnd:pvirtualnode;dsn:tnewds):pvirtualnode;
     function fnni(cnd:pvirtualnode;dsn:tnewds):pvirtualnode;
    procedure filliklist(dbg:tdbgrid;nmf:string);
    procedure dumpbin;
    procedure restorebin;
    function  fupdatef(myidf,bidpers:string):boolean;




  private

  public

  end;

var
  Form1: TForm1;
  stdzones:tstringlist;
  fstart:boolean;
  autor:boolean;
  uzelsh : array  of tsh_uzel;
  mysysinfo:tmysysinfo;
  currnd,firstnd:pvirtualnode;
  flagexit:boolean;
  app,appexe,ap,zp,appdir,myos:string;
  slappstatus,slmqtbox,slspec:tstringlist;
  subsysst :array[1..8] of tsubsysst;

implementation

{$R *.lfm}
uses uallog,ushemanode,ulazfunc,uformstarter,upgs,uperskeys,uglsnames,upersdata,utmzvst,undgrf,UPERS1,ualfunc;

{ TForm1 }


function TForm1.findndofymid(myid:integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecord;
begin

  try
    Result := nil;
    nd := vst.getfirst(True);
    Data := vst.getnodedata(nd);
    if (Data^.myid = myid)  then begin
      result:=nd;
      exit;
    end;
    while True do  begin
     // log('w','findndofymid START MYID='+INTTOSTR(MYID));
      nd := vst.getnext(nd);
      Data := vst.getnodedata(nd);
     // form1.log('y','BEFORE IF ASSGUN ???????????????????????????????');
      if not assigned(nd) then exit;
     // log('r','AFTER IF ASSGN ????????????????????');
      Data := vst.getnodedata(nd);
      //log('r','data.myid='+inttostr(data^.myid));
      if (Data^.myid = myid)  then
      begin
        Result := nd;
        //log('r','findvstndbymid nm0 ='+data^.nm0);
        //log('r','findvstndbymid tag ='+inttostr(data^.tag));
        exit;
      end;
    end;
    //form1.log('r', 'findndofymid NOT FOUND');
  except
    on e: Exception do
    begin
      form1.log('e', 'findndofymid,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;


function tform1.getcps10(cnd:pvirtualnode):integer;
var
  s,myid:string;
  d:pvstrecord;
  qr:tsqlquery;
begin
      d:=vst.getnodedata(cnd);
      myid:=inttostr(d^.myid);
      s:='SELECT count(*) '+
        ' FROM '+
        ' tsspsh_datatree  as d, '+
        ' tss_persinfo  as p '+
        ' where '+
        '( '+
        ' p.bidtree=d.myid '+
        ' and d.tag=5 ' +
        ' and d.bp='+myid+')';
       log('y','XXXgetpcs10='+s);
      qr:=form1.calcqr(s);
      result:=qr.Fields[0].AsInteger;


end;

function tform1.getcps(myid:string):integer;
var
  s:string;
  qr:tsqlquery;
begin
     result:=-1;
     s:='select count(*) from tss_persinfo where bidtree='+myid ;
     log('y','getcps s='+s);
     qr:=calcqr(s);
     result:=strtoint(qr.Fields[0].Asstring);
     log('w','RESULT='+inttostr(result));
end;

procedure tform1.readdata;
var
  cnd,nd:pvirtualnode;
  bidsh,biddtree,nm,s:string;
  rc:trcfld;
  qrz: TSQLQuery;
  n,x:integer;
  ds,dsx,ds2:pvstrecord;
  abi,level,sti,bp,bpsh,autor,myid,ttg,cps:string;
begin
    try
      vst.Clear;
      x:=1;
     // qrz:=TSQLQuery.Create(nil);
      s:='select myid from tsspsh_shema where statusdef=true';
       rc:=readfld(s);
      bidsh:=rc.value;
      //log('l','readdata bidsh='+bidsh);
      qrz:=TSQLQuery.Create(nil);
      s:='select * from  tsspsh_datatree  where bpsh='+bidsh+
      ' order by bp,myid';
      n:=0;
      x:=2;
      qrz.DataBase:=formpgs.pgc1;
      qrz.Transaction:=formpgs.trc1;
   //pgc1.Open;
      qrz.SQL.Clear;
      qrz.SQL.add(s);
      qrz.Active:=true;
      x:=3;
      qrz.First;
      while not qrz.eof do begin
         n:=n+1;
         x:=4;
         nm:=trim(qrz.FieldByName('name').AsString);
         log('y','name='+nm);
         bp:=trim(qrz.FieldByName('bp').AsString);
         myid:=trim(qrz.FieldByName('myid').AsString);
        // biddtree:=trim(qrz.FieldByName('biddree').AsString);
         sti:=trim(qrz.FieldByName('sti').AsString);
         ttg:=trim(qrz.FieldByName('tag').AsString);
        // log('y','name='+nm+zp+'n='+inttostr(n));
          x:=5;
         if n=1 then begin
          nd:=vst.AddChild(nil,NIL);
          ds:=vst.getnodedata(nd);
          ds^.nm0:=nm;

          ds^.sti:=-1;     //strtoint(sti);
          ds^.sti1:=-1;
          ds^.ndcheck_state:=true;
          //ds^.ndcheck:=true;
          ds^.myid:=strtoint(myid);
          x:=52;
          //nd:=newnode('a',nil,nil);
         // nd:=vst.AddChild(nil,NIL);
         // ds:=vst.GetNodeData(nd);
          x:=6;
        end;

         if n>1 then begin
      // log('w','>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  1 ,'+inttostr(n));
        x:=7;
       // log('w','before findnd bp='+bp);
        cnd:=findndofymid(strtoint(bp));
        if cnd=nil then begin
          //log('r','AFTER FINDBAD NM='+NM+zp+'cnd=nil');
        end;
        ds2:=vst.getnodedata(cnd);

        x:=8;

        nd:=vst.AddChild(cnd,NIL);
        dsx:=vst.getnodedata(nd);
        dsx^.nm0:=nm;
        dsx^.sti:=strtoint(sti);
        dsx^.sti1:=-1;
        dsx^.tag:=strtoint(ttg);
        dsx^.myid:=strtoint(myid);
        if dsx^.tag=5 then begin
         cps:=inttostr(getcps(myid));
         dsx^.nm1:='cps='+cps+zp+' tag='+inttostr(dsx^.tag)+zp+' bid='+inttostr(dsx^.myid);
         if strtoint(cps)>0 then formirnodeman(nd);
        end
        else begin
          cps:=inttostr(getcps10(nd));
          dsx^.nm1:='cps='+cps+',tag='+inttostr(dsx^.tag)+zp+' bid='+inttostr(dsx^.myid);


        end;
       end;
        //log('r','next nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
        qrz.Next;
      end;
    except
      on ee: Exception do
      begin
        log('e', 'readdata nm='+nm+zp+' bp='+bp+zp+' x='+inttostr(x)+' ,ee=' + ee.Message);
      end;
     end;
end;

{
procedure tform1.readdata;
var
  cnd,nd:pvirtualnode;
  bidsh,nm,s:string;
  rc:trcfld;
  qrz: TSQLQuery;
  n:integer;
  ds:pvstrecord;
  abi,level,sti,bp,bpsh,autor,myid:string;
begin
  try
     ptitlenode;
      qrz:=TSQLQuery.Create(nil);
      s:='select myid from tsspsh_shema where statusdef=true';
      rc:=readfld(s);
      bidsh:=rc.value;
      log('l','readdata bidsh='+bidsh);
      qrz:=TSQLQuery.Create(nil);
      s:='select  * from  tsspsh_datatree  where bpsh='+bidsh;
      //'order by bp,myid';
      n:=1;
      //exit;
      qrz:=getqr(s);
      qrz.First;
      ds:=vst.getnodedata(firstnd);
      if ds=nil then log('r','ds=NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN');
      //VST.SELECTED[firstnd] := True;
      nd:=nil;
      while not qrz.eof do begin
        n:=2;
        bp:=trim(qrz.FieldByName('bp').AsString);
        myid:=trim(qrz.FieldByName('myid').AsString);

        nd:=findndofymid(strtoint(bp));
        if nd=nil then begin
         log('r','readdata findnd NIL NIL NIL');
        end
        else begin
         cnd:=nd;
         ds:=vst.getnodedata(nd);
        end;
        //if strtoint(bp)=0 then cnd:=nil else cnd:=nd;
        //if n=1 then cnd:=firstnd else cnd:=nd;
        nm:=trim(qrz.FieldByName('name').AsString);
        sti:=trim(qrz.FieldByName('sti').AsString);
        //log('c','name='+nm+zp+'myid='+myid+ZP+'BP='+BP);
        n:=3;
        ds^.nm0:=nm;
        n:=31;
        //ds^.sti:=strtoint(sti);
        //ds^.ndcheck_state:=true;
        //ds^.ndcheck:=true;

        n:=31;
        nd:=newnode('a',nil,ds);
        ds:=vst.GetNodeData(nd);
        n:=32;

        ds^.nm0:=nm;
        ds^.sti:=strtoint(sti);
        ds^.ndcheck_state:=true;
        ds^.ndcheck:=true;
        ds^.myid:=strtoint(myid);
        n:=4;
        qrz.Next;
      end;
     except
      on ee: Exception do
      begin
        log('e', 'readdata n='+inttostr(n)+' ,ee=' + ee.Message);
      end;
     end;

      vst.refresh;
      qrz.Close;
end;
 }

function TForm1.getlastmyid(tbn: string): integer;
var
  qrz: TSQLQuery;
  s: string;
  n: integer;
begin
  try
    s := 'select myid from ' + tbn + ' order by myid desc limit 1';
    //log('y', 'gsel=' + s);
    qrz:=form1.getqr(s);
    result:=qrz.FieldByName('myid').AsInteger;
    qrz.Close;
    qrz.FreeOnRelease;
    exit;
  except
    on ee: Exception do
    begin
      log('e', 'getlastmyid ,ee=' + ee.Message);
      Result := -1;
    end;
  end;
end;


function TForm1.readfld(LINE:string):trcfld;

var
  qrz: TSQLQuery;
  s: string;
  rc:trcfld;
begin
  try
    rc.rc:='ok';
    rc.value:='';
    //log('y', 'readfld=' + s);
    qrz := TSQLQuery.Create(self);
    qrz.DataBase :=formpgs.pgc1; //form1.getqr(line);
    qrz.Transaction:=formpgs.trc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(line);
    qrz.Active := True;
    rc.value:=qrz.Fields[0].AsString;
    result:=rc;
    exit;
  except
     on ee: Exception do
     begin
      log('e', 'readfld ,ee=' + ee.Message);
      rc.rc:=ee.Message;
      rc.value:='';
      result:=rc;
    end;
  end;
 end;


function TForm1.selfupd(s: string): string;
var
  qrz: TSQLQuery;
  f:boolean;
  trx:TSQLTransaction;
begin
  try
    Result := 'ok';
    f:=false;
    qrz :=TSQLQuery.Create(self);
    trx :=TSQLTransaction.Create(self);
    trx.DataBase:=formpgs.pgc1;
    qrz.DataBase := formpgs.pgc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(' begin; ');
    qrz.SQL.Add(s + ' ;');
    qrz.SQL.Add(' commit;');
    qrz.Transaction := trx;
    try
      qrz.ExecSQL;
      f:=true;
    except
     on e: Exception do
      begin
       formpgs.trc1.Rollback;
       log('e', 'selfuppd 1,e=' + e.Message);
       Result := e.Message;
       exit;
     end;
    end;
   // if f then formpgs.trc1.Commit;
   // log('w', 'selfuppd AFTER COMMIT');
  except
    on e: Exception do
    begin
      log('e', 'selfuppd,e=' + e.Message);
      Result := e.Message;
    end;
  end;
  qrz.Close;
  qrz.FreeOnRelease;
  //trx.FreeOnRelease;
end;

function TForm1.selfupdc(s: string): string;
var
  qrz: TSQLQuery;
  f:boolean;
  trx:TSQLTransaction;
begin
  try
    Result := 'ok';
    f:=false;
    qrz :=TSQLQuery.Create(self);
    trx :=TSQLTransaction.Create(self);
    trx.DataBase:=formpgs.pgc1;
    qrz.DataBase := formpgs.pgc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(' begin; ');
    qrz.SQL.Add(s + ' ;');
    qrz.SQL.Add(' commit;');
    qrz.Transaction := trx;
    try
      qrz.ExecSQL;
      f:=true;
    except
     on e: Exception do
      begin
       formpgs.trc1.Rollback;
       log('e', 'selfuppd 1,e=' + e.Message);
       Result := e.Message;
        qrz.Close;
        qrz.FreeOnRelease;
        trx.FreeOnRelease;
       exit;
     end;
    end;
    if f then formpgs.trc1.Commit;
    log('w', 'selfuppd AFTER COMMIT');
  except
    on e: Exception do
    begin
      log('e', 'selfuppd,e=' + e.Message);
      Result := e.Message;
       qrz.Close;
       qrz.FreeOnRelease;
       trx.FreeOnRelease;
    end;
  end;


end;




procedure TForm1.prolog2;
var
  i:integer;
begin



      formstarter.openstarter;
      formstarter.rereadstarter;

      log('c','umain.mysysinfo.baseaddr='+umain.mysysinfo.baseaddr);
      log('c','umain.mysysinfo.basename='+umain.mysysinfo.basename);
      log('c','umain.mysysinfo.baspsw ='+umain.mysysinfo.basepsw);

      prolog3;


end;

procedure TForm1.prolog3;
var
  i:integer;
begin
       formpgs.connect;
     //titlenode;
     //reread;
     //prolog4;

 end;


procedure TForm1.prolog1;
var
  D,FileDateTime,S:STRING;
  i:integer;
begin;

TIMERSTART.Enabled:=FALSE;

  mysysinfo.mode:='work';
  d:=dmfunc.ZZdate(datetostr(now));
  {
  for i:=1 to 11 do begin
   if not assigned(formallog) then begin
     ualfunc.MyDelay(100);
   end
   else begin
       break;
      end;
     end;
  }
   subsysst[1].cn:='p_transport';
   subsysst[2].cn:='p_comcentr';
   subsysst[3].cn:='p_writerlog';
   subsysst[4].cn:='p_firebird';
   subsysst[5].cn:='p_databeses';
   subsysst[6].cn:='p_databesef';
   subsysst[7].cn:='p_dms';
   subsysst[8].cn:='p_sgrd';
  for i:=1 to length(subsysst) do begin
    subsysst[i].luxt:=0;
  end;
  form1.WindowState:=wsnormal;
  form1.show;
  //form1.WindowState:=wsmaximized;
  formallog.WindowState:=wsmaximized;
  formallog.show;
  form1.BringToFront;




  if trim(myos)='' then begin
   myos:='windows';
   mysysinfo.os:=myos;
   mysysinfo.sep:='\';
  end;
   if trim(myos)='linux' then begin
   myos:='linux';
   mysysinfo.os:=myos;
   mysysinfo.sep:='/';
  end;


  FileDateTime := FormatDateTime('YYYY.MM.DD hh:mm:ss', FileDateToDateTime(FileAge(appExe)));
  s:='APP='+appexe +' VERSION='+filedatetime+' APPDIR='+APPDIR+app;
   caption:=S;
  log('l','END OF PROLOG1 11111111111111111111111111111111111111111111111111111111');


  prolog2;

end;

procedure tform1.pgsconnect(status:string);
begin
      if status='connect' then begin
       p_databases.Color:=cllime;
       p_databases.font.Color:=clblack;
       timerspecwait.Enabled:=true;

      end;
       if status='disconnect' then begin
       p_databases.Color:=clyellow;
       p_databases.font.Color:=clblack;
      end;


end;

procedure tform1.readglsfio;
var
 qrz:tsqlquery;
 s:string;
begin
          formglsnames.md1.open;
          s:='select * from tssgls_name1 order by text';
          qrz:=calcqr(s);
          formglsnames.md1.Clear(false);
          //clearmd(formglsnames.md1);
          formglsnames.md1.DisableControls;
          while not qrz.EOF do begin
           application.ProcessMessages;
           formglsnames.md1.Insert;
             formglsnames.md1.FieldByName('myid').AsInteger:=qrz.FieldByName('myid').AsInteger;
             formglsnames.md1.FieldByName('text').Asstring:=qrz.FieldByName('text').Asstring;
             formglsnames.md1.FieldByName('nn').AsInteger:=formglsnames.md1.RecordCount+1;
             formglsnames.md1.Post;
             qrz.next;

          end;
          formglsnames.md1.EnableControls;
          formglsnames.md1.First;

          formglsnames.md2.open;
          s:='select * from tssgls_name2 order by text';
          qrz:=calcqr(s);
          formglsnames.md2.Clear(false);
          //clearmd(formglsnames.md2);
          formglsnames.md2.DisableControls;
          while not qrz.EOF do begin
           application.ProcessMessages;
           formglsnames.md2.Insert;
             formglsnames.md2.FieldByName('myid').AsInteger:=qrz.FieldByName('myid').AsInteger;
             formglsnames.md2.FieldByName('text').Asstring:=qrz.FieldByName('text').Asstring;
             formglsnames.md2.FieldByName('nn').AsInteger:=formglsnames.md2.RecordCount+1;
             formglsnames.md2.Post;
             qrz.next;

          end;
          formglsnames.md2.EnableControls;
          formglsnames.md2.First;

          formglsnames.md3.open;
          s:='select * from tssgls_name3 order by text';
          qrz:=calcqr(s);
          formglsnames.md3.Clear(false);
          //clearmd(formglsnames.md3);
          formglsnames.md3.DisableControls;
          while not qrz.EOF do begin
           application.ProcessMessages;
           formglsnames.md3.Insert;
             formglsnames.md3.FieldByName('myid').AsInteger:=qrz.FieldByName('myid').AsInteger;
             formglsnames.md3.FieldByName('text').Asstring:=qrz.FieldByName('text').Asstring;
             formglsnames.md3.FieldByName('nn').AsInteger:=formglsnames.md3.RecordCount+1;
             formglsnames.md3.Post;
             qrz.next;

          end;
          formglsnames.md3.EnableControls;
          formglsnames.md3.First;



end;

function Tform1.calcqr(line:string):TSQLQuery;
var
  qrz:tsqlquery;
  I:INTEGER;
begin
      TRY
        i:=1;
        qrz:=tsqlquery.Create(self);
        i:=2;
        qrz.DataBase:=formpgs.pgc1;
        qrz.Transaction:=formpgs.trc1;
        i:=3;
        formpgs.pgc1.Open;
        i:=4;
        qrz.SQL.Clear;
        qrz.SQL.add(line);
        qrz.Active:=true;
        i:=5;
        //form1.log('c','calcqr line='+line);
        //form1.log('c','calcqr rc='+inttostr(qrz.RecordCount));
        result:=qrz;
       except
    on e: Exception do
     begin
      form1.log('e', 'calcqr,e=' + e.message + '/i=' + IntToStr(i));
     end;

    end;

end;
function Tform1.getqr(line:string):TSQLQuery;
var
  qrz:tsqlquery;
begin
       try
        formpgs.qrs.DataBase:=formpgs.pgc1;
        formpgs.qrs.Transaction:=formpgs.trc1;
        formpgs.pgc1.Open;
        formpgs.qrs.SQL.Clear;
        formpgs.qrs.SQL.add(line);
        formpgs.qrs.Active:=true;
     //   form1.log('c','getqr line='+line);
     //   form1.log('c','getqr rc='+inttostr(formpgs.qrs.RecordCount));
        result:=formpgs.qrs;
       except
     on e: Exception do
      begin
       log('e', 'getqr,e=' + e.Message);
      end;
    end;
end;


procedure tform1.readtsspsh;
var
qrz: TSQLQuery;
 s,ss,myid: string;
 n: integer;
 a,d:char;
begin

 try
   //showmessage('readtsspsh start ='+cmbtsspsh.Items.Text);
   s := 'select myid,name from  tsspsh_shema';//  order by name';
   log('y', 'readtsspsh=' + s);
   //   showmessage('s='+s);
   qrz :=TSQLQuery.Create(self);   //form1.getqr(s);
   qrz.DataBase:=formpgs.pgc1;
   qrz.Transaction:=formpgs.trc1;
   //pgc1.Open;
   qrz.SQL.Clear;
   qrz.SQL.add(s);
   qrz.Active:=true;
   log('c','getqr s='+s);
   log('c','getqr rc='+inttostr(qrz.RecordCount));
   log('l','readtsspsh l='+inttostr(qrz.RecordCount));
   cmbtsspsh.Items.Clear;
   while not qrz.eof do begin
    s:=trim(qrz.FieldByName('name').AsString);
    myid:=trim(qrz.FieldByName('myid').AsString);
    cmbtsspsh.Color:=cllime;
    log('w','s='+s);
    cmbtsspsh.Items.Add(s);
    //log('r','??????????????????????????????????????='+s);
    qrz.next;
   end;
   cmbtsspsh.ItemIndex:=0;
 except
     on e: Exception do
      begin
       log('e', 'readtsspsh,e=' + e.Message);
      end;
    end;


end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

        try
         flagexit:=true;
        // try formxtrans.mqttClnt.doDisConnect;except end;
         // try mqttClnt.Destroy;except end;
         // try mqttClnt.Free;except end;
        vst.Clear;
        vst.Free;

        finally
         //halt(0)
        end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
          if not yesno ('ВЫ ДЕЙСТВИТЕЛЬНО ХОТИТЕ УДАЛИТЬ все профили ???' ) then exit;
       selfupd(' delete from tsspsh_datatree ');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    // formshemanode.show;
    //formindgrf.show;
 //ptitlenode;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin

end;


procedure tform1.topersinfo;
var
 s,name1,name2,name3,bidpers:string;

begin
       try
        md.post;
       except
       end;
       md.first;
       s:='delete from tss_persinfo';
       selfupdc(s);
       while not md.eof do begin
        s:=md.FieldByName('name1').asstring;
        bidpers:=md.FieldByName('myid').AsString;
        name3:=dmfunc.ExtractStr(1,s,' ');
        name1:=dmfunc.ExtractStr(2,s,' ');
        name2:=dmfunc.ExtractStr(3,s,' ');
        s:='insert into tss_persinfo (name1,name2,name3,bidpers) values ('+
        ap+name1+ap+zp+
        ap+name2+ap+zp+
        ap+name3+ap+zp+
        bidpers+
        ')';
         log('l','s='+s);
        selfupdc(s);

        md.next
       end;

       md.disablecontrols;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
         log('r','6666666666666666666666666666666');
         topersinfo;
         exit;

end;

procedure TForm1.Button7Click(Sender: TObject);
begin

end;

procedure TForm1.Button8Click(Sender: TObject);
begin

end;

procedure TForm1.cbactChange(Sender: TObject);
begin

end;

procedure tform1.readkeys(line:string);
var
 qr:tsqlquery;
begin

    showmessage('readkeys='+line);
    qr:=form1.calcqr(line);
    persdata.mdk.open;
    persdata.mdk.Clear(false);
    //clearmd(persdata.mdk);
    while not qr.EOF do begin
     persdata.mdk.insert;
     persdata.mdk.FieldByName('LABELCODE').Asstring:=qr.FieldByName('labelcode').Asstring;
     persdata.mdk.FieldByName('myid').AsInteger:=qr.FieldByName('myid').AsInteger;
     persdata.mdk.FieldByName('bppers').AsInteger:=qr.FieldByName('bppers').AsInteger;
     persdata.mdk.FieldByName('kluch').Asstring:=qr.FieldByName('kluch').Asstring;
    // le_kluch.text:=  qr.FieldByName('kluch').Asstring;
     persdata.mdk.FieldByName('code').AsInteger:=qr.FieldByName('code').AsInteger;
     persdata.mdk.FieldByName('actual').Asboolean:=qr.FieldByName('actual').Asboolean;
    // cbactkey.Checked:=qr.FieldByName('actual').Asboolean;
     persdata.mdk.FieldByName('keypad').Asstring:=qr.FieldByName('keypad').Asstring;
   //  le_keypad.text:=  qr.FieldByName('keypad').Asstring;
     persdata.mdk.FieldByName('start').Asstring:=qr.FieldByName('start').Asstring;
    // le_start.Text:=qr.FieldByName('start').Asstring;
     persdata.mdk.FieldByName('stop').Asstring:=qr.FieldByName('stop').Asstring;
     persdata.mdk.FieldByName('tmzname').Asstring:=qr.FieldByName('tmzname').Asstring;
     //le_stop.Text:=qr.FieldByName('stop').Asstring;
     persdata.mdk.post;
     qr.next;
    end;
    persdata.mdk.first;
end;


procedure TForm1.cd1Change(Sender: TObject);
var
 s:string;
 sd:tdate;
begin
  {
     s:=datetostr(persdata.cd1.date);
     sd:=strtodate(s);
     s:=FormatDateTime('YYYY-MM-DD',sd);
     le_start.text:=s;
     }
end;

procedure TForm1.cd1Close(Sender: TObject);
begin
        //le_start.text:=datetostr(cd1.date);
end;


procedure TForm1.cmbname1CloseUp(Sender: TObject);
begin
end;

procedure TForm1.cmbname1DblClick(Sender: TObject);
begin

end;

procedure TForm1.cmbname2DblClick(Sender: TObject);
begin
     //loadtext('tssgls_name2',cmbname2);

    //  formname2.show ;
     // formname2.Top:=0;
    //  formname2.Left:=200;
      //formname2.BringToFront;
end;

procedure TForm1.cmbname3Change(Sender: TObject);
begin

end;
procedure tform1.loadtext(tbn:string;cmb:tcombobox);
var

 da,s,ss:string;
  qrz: TSQLQuery;
 begin


        s:='select text from '+tbn+' order by text';
        log('y','loadtext s='+s);
       qrz:=calcqr(s);
       //exit;
       cmb.Items.Clear;
       while not qrz.eof do begin
        s:=trim(qrz.FieldByName('text').asstring);
        ss:=dmfunc.deleteda(s);
        if (ss<>'') or (ss<>' ') then cmb.Items.Add(ss);
        log('w','ss='+ss);
        qrz.next;
       end;

 end;


procedure TForm1.cmbname3DblClick(Sender: TObject);

begin
       //loadtext('tssgls_name3',cmbname3);
    //  formname1.show;
      //formname1.Top:=0;
      //fo//rmname1.Left:=0;
      //formname1.BringToFront;

end;

procedure TForm1.cmbname3EditingDone(Sender: TObject);
begin
      log('w','cmbname3EditingDone');

end;

procedure TForm1.cmbtsspshChange(Sender: TObject);
begin

end;

procedure TForm1.dbgCellClick(Column: TColumn);
var
  myid,nm,s,v,vbs:string;

begin
   if not form1.yesno('Вы дествительно хотите обновить данные') then BEGIN
        log('r','EXIT');
        EXIT;
       END;

   nm:=column.FieldName;
       myid:=persdata.mdtmz.FieldByName('myid').AsString;
       log('w','dbgCellClick nm='+nm) ;
       if nm='zapret' then begin
        if persdata.mdtmz.FieldByName('zapret').AsBoolean=true then vbs:='true' else vbs:='false';
        s:='update tss_tmz set zapret='+vbs+ ' where myid='+myid;
        log('w','s='+s);
        selfupd(s);
       end;

       if (nm='t1') or(nm='t2') then begin
         if nm='t1' then begin
         // v:=timetostr(rxtmz1.Time);
          s:='update tss_tmz set t1='+ap+v+ap+ ' where myid='+myid;
          log('w',s);
          selfupd(s);
         end;
        if nm='t2' then begin
         // v:=timetostr(rxtmz2.Time);
          s:='update tss_tmz set t2='+ap+v+ap+ ' where myid='+myid;
          log('w',s);
          selfupd(s);
         end;
       end;
end;

procedure TForm1.ds1DataChange(Sender: TObject; Field: TField);
var
  s,myid:string;
begin
     {
     sb1.Panels[0].Text:=inttostr(md.RecNo);
     sb1.Panels[1].Text:=inttostr(md.RecordCount);
     sb1.Panels[2].Text:=' ТАБЛИЦА  " ПЕРСОНЫ "';
     //sb1.Panels[2].Text:=md.FieldByName('bpkeys').asstring;
     cbact.Checked:=md.FieldByName('actual').AsBoolean;
     cbadmin.Checked:=md.FieldByName('fadmin').AsBoolean;
     form1.le_crtscd.text:=md.FieldByName('crcdts').AsString;
     form1.le_updcdts.text:=md.FieldByName('updcdts').AsString;
     if cbadmin.Checked then panadmin.Color:=cllime else panadmin.Color:=clsilver;
     if cbact.Checked then panact.Color:=cllime else panact.Color:=clsilver;
     edit1.Text:=md.FieldByName('name1').asstring;
     le_name3.Text:=dmfunc.ExtractStr(1,edit1.text,' ');
     le_name1.Text:=dmfunc.ExtractStr(2,edit1.text,' ');
     le_name2.Text:=dmfunc.ExtractStr(3,edit1.text,' ');
     myid:=md.FieldByName('myid').asstring;
     //log('w','myid='+myid);
     //showmessage('myid='+myid);
     if fstart then  begin
      sb2.Panels[0].Text:=inttostr(md.RecNo);
      sb2.Panels[1].Text:=inttostr(md.RecordCount);
      if trim(myid)='' then exit;
      s:='select * from tss_keys where bppers='+myid;
      log('w','ds1change='+s);
      readkeys(s);

     // sb2.Panels[2].Text:=md.FieldByName('bpkeys').asstring;
     end;
     }


end;

procedure TForm1.ds1StateChange(Sender: TObject);
begin

end;

procedure TForm1.ds1UpdateData(Sender: TObject);
begin

end;

procedure TForm1.dtstartChange(Sender: TObject);
var
  s:string;
begin
  {
       s:=datetostr(dtstart.Date);
       le_start.Text:=s;
       }
end;

procedure TForm1.DtstopChange(Sender: TObject);
var
  s:string;
begin
  {
       s:=datetostr(dtstop.Date);
       le_stop.Text:=s;
       }

end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

function tform1.formirinsertdatatree(bidshema:string;nd:pvirtualnode):tstringlist;
var
 bplast,lvl,s:string;
 abi:integer;
 data:pvstrecord;
 sl:tstringlist;
 bpl:string;
begin

   sl:=tstringlist.Create;
   result:=sl;

   abi:=vst.AbsoluteIndex(nd);
   Data := vst.getnodedata(nd);
   lvl:=inttostr(vst.GetNodeLevel(nd)) ;
   log('l','pereborvst nm0='+data^.nm0+zp+'tag='+inttostr(data^.tag)+zp+'level='+lvl);
   s:='insert into tsspsh_datatree (abi,level,tag,sti,bp,bpsh,name) values('+
   inttostr(abi)+zp+
   lvl+zp+
   inttostr(data^.tag)+zp+
   inttostr(data^.sti)+zp+
   bplast+zp+
      bidshema+zp+
      ap+data^.nm0+ap+')';
      log('y',s);
      selfupd(s);
      bplast:=inttostr(form1.getlastmyid('tsspsh_datatree'));
      sl.Values['bplast']:=bplast;
      sl.Values['line']:=s;
      result:=sl;
      //log('l','sl='+sl.text);

end;

procedure tform1.pereborvst;
var
  nd:pvirtualnode;
  data:pvstrecord;
  i,abi:integer;
  bplast,bidshema,lvl,s:string;
  rc:trcfld;
  sl:tstringlist;
begin
  try
    bplast:='-1';
    sl:=tstringlist.Create;
    log('c','NEW count='+inttostr(cmbtsspsh.Items.Count));
    if form1.cmbtsspsh.Items.Count=0 then begin
      showmessage('ВЫ НЕ ВЫБРАЛИ ИМЯ СХЕМЫ');
      EXIT;
    end;
    s:='select myid from tsspsh_shema where name='+ap+form1.cmbtsspsh.Text+ap;
    log('y','s='+s);
    rc:=form1.readfld(s);
    bidshema:=rc.value;
    s:='delete from tsspsh_datatree where bpsh='+bidshema;
    log('w',s);
    selfupd(s);
    log('y','bidshema='+bidshema);

    nd := vst.getfirst(True);
    Data := vst.getnodedata(nd);

    if assigned(nd) then begin
     sl:=formirinsertdatatree(bidshema,nd);
    end;
    while True do
    begin
      // application.processmessages;
      nd := vst.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
       sl:=formirinsertdatatree(bidshema,nd)
    end;
    form1.log('r', 'pereborvst NOT FOUND');
  except
    on e: Exception do
    begin
      form1.log('e', 'pereborvst,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin

    pereborvst;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
    vst.Clear;
     //VST.SELECTED[firstnd] := True;
    ulazfunc.dmfunc.MyDelay(500);
  readdata;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  a,s:string;
  rc:string;
begin    if autor then a:='true' else a:='false';
         s:='insert into tsspsh_shema(autor,name,sti)values('+
         a+zp+ ap+form1.cmbtsspsh.Text+ap+zp+'-1)';
         log('y',s);
         rc:=selfupd(s);
         if rc<>'ok' then showmessage(rc);

end;

procedure TForm1.bttokeyClick(Sender: TObject);
begin

         showmessage('labelcode convert');
  {
         formglsnames.show ;
         formglsnames.Top:=0;
         formglsnames.BringToFront;
         readglsfio;
         }
end;

procedure  tform1.linkglsfio(gf:tglsfio);
var
  myid,s:string;

begin
  {
         myid:=md.FieldByName('myid').AsString;
         log('l','myid='+myid);
         le_name3.Text:=gf.name3;
         le_name2.Text:=gf.name2;
         le_name1.Text:=gf.name1;
         if not yesno('связывать ???') then exit;
         s:='update tss_persons set bidname1='+gf.bidname1+zp+
            'bidname2='+gf.bidname2+zp+
            'bidname3='+gf.bidname3 +' where myid='+myid;
         log('l','linkglsfio s='+s);
         form1.selfupdc(s);
         }
end;

procedure linkglsbase;
var
  s:string;
begin

end;

procedure TForm1.bitkeysClick(Sender: TObject);
begin
               formpersids.show ;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
begin
          for i:=1 to 40 do begin
           tdm.insert;
           tdm.FieldByName('f1').AsString:=inttostr(i)+'/'+timetostr(time);
           tdm.post;
          end;
end;


Function tform1.setdaynames: string;
  begin

    sysutils.LongDayNames[1] := 'понедельник ';
    sysutils.LongDayNames[2] := 'вторник ';
    sysutils.LongDayNames[3] := 'среда ';
    sysutils.LongDayNames[4] := 'четверг ';
    sysutils.LongDayNames[5] := 'пятница ';
    sysutils.LongDayNames[6] := 'суббота ';
    sysutils.LongDayNames[7] := 'воскресенье ';
    //sysutils.LongDayNames[8] := 'Праздник, ';

  end;




procedure TForm1.FormCreate(Sender: TObject);
var
  FileDateTime,s,t1,t2:string;
  n:integer;
  nd2:tdate;
begin
     stdzones:=tstringlist.Create;
     stdzones.Add('Никогда');
     stdzones.add('Всегда');

     n:=sysutils.DayOfWeek(now);

     setdaynames;

     s:=sysutils.LongDayNames[n];
     //showmessage(s);
     //exit;
     sysutils.ShortDateFormat:='yyyy-mm-dd';
     sysutils.longDateFormat :='yyyy-mm-dd';

     slspec:=tstringlist.Create;
     slappstatus:=tstringlist.Create;;
     slmqtbox   :=tstringlist.Create;




     ap:='''';
     zp:=',';

      VST.NodeDataSize := SizeOf(tpvstrecord);
      VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions + [toCheckSupport];

      appDir     := ExtractFilePath(FORMS.Application.ExeName);
      appExe     := ExtractFileName(FORMS.Application.ExeName);
      app        := dmfunc.ExtractStr(1,appexe,'.');

      FileDateTime := FormatDateTime('YYYY.MM.DD hh:mm:ss', FileDateToDateTime(FileAge(appExe)));
      s:='APP='+appexe +' VERSION='+filedatetime+' APPDIR='+APPDIR+app;
      caption:=S;



   timerstart.Enabled:=true;



end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.le_keypad1DblClick(Sender: TObject);
begin
       showmessage('преобразовать код на карте в КЛЮЧ');
end;

procedure TForm1.le_startChange(Sender: TObject);
begin

end;

procedure TForm1.filliklist(dbg:tdbgrid;nmf:string);
var
  nm,s:string;
  c:tcolumn;
  qrx:tsqlquery;
  i:integer;
begin

      // c:=dbgrid3.Columns.ColumnByFieldname('tmzname');
       c:=dbg.Columns.ColumnByFieldname(nmf);
       nm:=c.FieldName;
       s:='select distinct name from tss_tmzvst order by name';
       qrx:=form1.calcqr(s);
       c.PickList.Clear;
       while not qrx.EOF do begin
       c.PickList.Add(trim(qrx.FieldByName('name').AsString));
      // log('l','name='+nm);
       qrx.Next;

       end;

end;

procedure TForm1.le_startDblClick(Sender: TObject);
begin


end;

procedure TForm1.le_stopChange(Sender: TObject);
begin

end;

procedure TForm1.le_stopDblClick(Sender: TObject);
begin
      persdata.cd2.Execute;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
var
  s,ss,myid:string ;
  qr:tsqlquery;

begin
       exit;

       s:='select * from tss_persinfo order by name3';
       qr:=form1.calcqr(s);
       while not qr.eof do begin
        myid:=qr.FieldByName('myid').asstring;
        s:=qr.FieldByName('name3').asstring;
        s:=dmfunc.mycrypt(s);
        ss:='update tss_persinfo set name3='+ap+s+ap+
         ' where myid='+myid ;
        // selfupd(s);

        qr.Next;
       end;

end;

function tform1.calcsum32(qr:tsqlquery):longword;
var
  w:word;
  i:integer;
  nm,v:string;
  sum:longword;
begin

  sum:=0;
       for i :=0 to qr.Fields.Count-1 do begin
        nm:=qr.Fields[i].FieldName;
        v := qr.Fields[i].AsString;
        sum:=sum+dmfunc.crc32(v);
        log('l','nm='+nm+' /v='+v);
       end;
       result:=sum;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
var
  s:string;
  qrx:tsqlquery;
  sum:integer;
begin
        s:='select * from tss_persinfo limit 1';
        qrx:=form1.calcqr(s);
        sum:=calcsum32(qrx);
        log('l','sum='+inttostr(sum));
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
var
  s,myid,nm:string;
begin

    formindgrf.SHOW;

     {
      form1.Inputsg('Введите новое имя',nm);
      myid:=persdata.mdnamrtmz.FieldByName('myid').asstring;
      s:='update tssgls_nametmz set name='+ap+nm+ap+' where myid='+myid;
      log('y',s);
      selfupd(s);
      }

end;


procedure Tform1.clearmd(mdx:TMemDataset);

begin
     // mdx.open;
      //mdx:=mdx;
      mdx.First;
      mdx.DisableControls;
      while not mdx.EOF do begin;
       mdx.Edit;
       mdx.Delete;
      end;
      try
       mdx.post;
      except
      end;
      mdx.EnableControls;
end;

procedure tform1.readtmz(bidname:string);
var
  s:string;
  x:integer;
  qrx:tsqlquery;
begin
      try
       x:=1;
    //   showmessage('0000000000000000000000000000');
       persdata.mdtmz.DisableControls;

       s:='select * from tss_tmz where bidname='+bidname; //+' order by t1 ';
       qrx:=form1.calcqr(s);

       log('c','readtmz RC='+inttostr(qrx.RecordCount));
       persdata.mdtmz.Open;
       //persdata.mdtmz.Clear(false);
       clearmd(persdata.mdtmz);

       x:=2;
      // showmessage('2');
       while not qrx.EOF do begin
        persdata.mdtmz.Insert;
        persdata.mdtmz.FieldByName('zapret').Asboolean:=qrx.FieldByName('zapret').AsBoolean;
        x:=3;
        persdata.mdtmz.FieldByName('bidname').AsInteger:=STRTOINT(bidname);
        persdata.mdtmz.FieldByName('myid').AsInteger:=qrx.FieldByName('myid').AsInteger;
        persdata.mdtmz.FieldByName('t1').Asstring:=qrx.FieldByName('t1').Asstring;
        x:=4;
        persdata.mdtmz.FieldByName('t2').Asstring:=qrx.FieldByName('t2').Asstring;
        persdata.mdtmz.Post;
        qrx.next;
       end;
       x:=5;
     //  showmessage('3');
       persdata.mdtmz.First;
       persdata.mdnamrtmz.EnableControls;
       //showmessage('4');
    except
     on e: Exception do
     begin
      form1.log('e', 'readtmz,e=' + e.message + '/x=' + IntToStr(x));
     end;
   end;
   //showmessage('5');
   persdata.mdtmz.enableControls;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
var
  s,bidname,t1,t2:string;
begin
        form_pers1.SHOW;
   {

      t1:=timetostr(rxtmz1.Time);
      t2:=timetostr(rxtmz2.Time);
      bidname:=persdata.mdnamrtmz.FieldByName('myid').AsString;
      s:='insert into tss_tmz(bidname,t1,t2)values ('+
      bidname+zp+
      ap+t1+ap+zp+
      ap+t2+ap+
      ')';
      selfupd(s);
   )+}
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
VAR
 ds:pvstrecord;
 nm0:string;
 dsn:tnewds;
begin
       dsn.nm0:=timetostr(time);
       dsn.sti:=31;
       dsn.sti1:=-1;
       dsn.tag:=3;
       dsn.ndcheck_state:=true;
       dsn.ndcheck:=true;
       form1.fnna(currnd,dsn);

end;

procedure TForm1.MenuItem15Click(Sender: TObject);
var
  nm,s:string;

begin
          form1.Inputsg('Введите  имя новой зоны',nm);
         // s:='insert into tssgls_nametmz (name)values('+ap+nm+ap+')';
         // selfupd(s);
          form1.formirzone(nm);
end;

procedure tform1.restorebin;
begin
//pg_restore --dbname=postgresql://postgres:Tss2252531@127.0.0.1:5432/postgres -c -Fc /home/astra/work/postgres/vvg/test2.dump


end;

procedure tform1.dumpbin;
//pg_dump --dbname=postgresql://postgres:Tss2252531@192.168.0.251:5432/postgres -Fc > common/@@@transit/arcpgs/2023-08-24_16:08:36.dump


 var
fn,line:string;
ba,dbn,psw:string;
rc:string;
begin


       ba:=mysysinfo.baseaddr;
       dbn:=mysysinfo.basename;
       psw:=mysysinfo.basepsw;

      fn:=FormatDateTime('yyyy-mm-dd_hh:nn:ss', now)+'.dump';

      //line:='pg_dump --dbname=postgresql://postgres:'+psw+'@'+ba+':5432/postgres -Fc > '+appdir+'arcpg/'+fn;
      line:='pg_dump --dbname=postgresql://postgres:'+psw+'@'+ba+':5432/postgres -Fc > '+' common/@@@transit/arcpgs/'+fn;

      log('l','line='+line);
      rc:=ualfunc.vagoloapprun(line);


      log('y','rc='+rc);
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
var
  myid,s:string;
begin
      dumpbin;

end;


procedure tform1.totmz(nmz,zap:string);
var
  bidname,s,zb:string;

begin
     if nmz='Никогда'   then begin
      log('r','TOTMZ nmz='+nmz);

     end;
     bidname:=inttostr(form1.getlastmyid('tssgls_nametmz'));
     zb:='false';
     if nmz='Никогда'   then begin zb:='true'; log('w','nmz='+nmz); end;
     if nmz='Праздник'  then zb:='true' ;
     s:='delete from tss_tmz where bidname='+bidname;
     selfupd(s);
     log('y',s);
     s:='insert into  tss_tmz(bidname,t1,t2,zapret)values('+
       bidname+zp+
       ap+'00:00:00'+ap+zp+
       ap+'23:59:59'+ap+zp+
       zap+')';
     selfupd(s);
     log('l',s);

end;

procedure tform1.formirzone(nmz:string);
var
  s,snm,nm,day:string;
  i,j,n:integer;
begin

      for j:=1 to 7 do begin
        day:=sysutils.LongDayNames[j];
        s:='insert into tssgls_nametmz (name,day,dayow)values('+
        ap+nmz+ap+zp+
        ap+day+ap+zp+
        inttostr(j)+')';
        selfupd(s);
        totmz(nmz,'true');
       end;
        s:='insert into tssgls_nametmz (name,day,dayow)values('+
        ap+nmz+ap+zp+
        ap+'Праздник'+ap+zp+
        inttostr(8)+')';
        selfupd(s);
        totmz(nmz,'TRUE');

end;

procedure tform1.crstandartzones;
var
  s,snm,nm,day:string;
  i,j,n:integer;
begin

      //snm:=umain.stdzones;
      //showmessage('n='+inttostr(n));
      for i:=0 to stdzones.Count-1 do begin
       nm:=stdzones[i];
       s:='delete from tssgls_nametmz where name='+ap+nm+ap;
       selfupd(s);
       for j:=1 to 7 do begin
        day:=sysutils.LongDayNames[j];
        s:='insert into tssgls_nametmz (name,day,dayow)values('+
        ap+nm+ap+zp+
        ap+day+ap+zp+
        inttostr(j)+')';
        selfupd(s);
        if nm='Всегда' then  totmz(nm,'false') else totmz(nm,'true');
       end;
         s:='insert into tssgls_nametmz (name,day,dayow)values('+
        ap+nm+ap+zp+
        ap+'Праздник'+ap+zp+
        inttostr(8)+')';
        selfupd(s);
        totmz(nm,'true');

      end;

end;

function  TForm1.fupdatef(myidf,bidpers:string):boolean;
var
qr:tsqlquery;
s,bidkeys,bidtree:string;
rc:trcfld;
begin

       s:='select bpkeys from tss_persons where myid='+bidpers;
       log('w','s='+s);
       rc:=readfld(s);
       if rc.rc<>'ok' then begin
        exit;
       end;
       bidkeys:=rc.value;
       s:='select biddtree from tss_persons where myid='+bidpers;
       log('c','s='+s);
       rc:=readfld(s);
       if rc.rc<>'ok' then begin
        exit;
       end;
       bidtree:=rc.value;
       log('l','bidpers='+bidpers+' /bidkeys='+bidkeys+' /bidtree='+bidtree);
       s:='update tss_persinfo set bidkeys='+bidkeys+',bidtree='+bidtree+' where myid='+myidf;
       log('y','s='+s);
       form1.selfupd(s);
        s:='update tss_keys set bppers='+myidf+' where bppers='+bidpers;
       log('l','s='+s);
       form1.selfupd(s);





end;

procedure TForm1.MenuItem18Click(Sender: TObject);
var
qrp,qrf:tsqlquery;
s,ss:string;
bidpers,bidkeys,bidtree,myidf:string;
begin
      //showmessage('создать СТАНДАРТНЫЕ ЗОНЫ');
     // showmessage('pers to persinfo');
      s:='select * from tss_persinfo order by name3,name1,name2';
      qrf:=form1.calcqr(s);
     // showmessage(' A1');
      //ss:='select * from tss_persons';
      //qrp:=form1.calcqr(ss);
      //showmessage(' A2');
      while not qrf.EOF do begin
       log('y','name3='+qrf.FieldByName('name3').asstring);
       myidf:=qrf.FieldByName('myid').asstring;
       bidpers:=qrf.FieldByName('bidpers').asstring;
       fupdatef(myidf,bidpers);

       qrf.next;
      end;



end;

 function tform1.fnni(cnd:pvirtualnode;dsn:tnewds):pvirtualnode;
var
 nd:pvirtualnode;
 dsx:pvstrecord ;
begin


    nd:=vst.InsertNode(cnd,amInsertafter,nil);
    dsx:=vst.getnodedata(nd);
    if dsn.ndcheck_state then begin
          nd^.CheckType     := ctTriStateCheckBox;
          vst.CheckState[nd]:= cscheckedNormal;

          nd^.CheckType := ctCheckBox;
          Dsx := VST.GetNodeData(nd);
          if not (vsInitialized in nd^.States) then  VST.ReinitNode(nd, False);
        end;

       dsx^.nm0:=dsn.nm0;
       dsx^.tag:=dsn.tag;
       dsx^.sti:=dsn.sti;
       dsx^.sti1:=dsn.sti1;
       dsx^.ndp:=cnd;
       result:=nd;


end;


function tform1.fnna(cnd:pvirtualnode;dsn:tnewds):pvirtualnode;
var
 nd:pvirtualnode;
 dsx:pvstrecord ;
begin
    nd:=vst.AddChild(cnd,nil);
    dsx:=vst.getnodedata(nd);
    if dsn.ndcheck_state then begin
          nd^.CheckType     := ctTriStateCheckBox;
          vst.CheckState[nd]:= cscheckedNormal;

          nd^.CheckType := ctCheckBox;
          Dsx := VST.GetNodeData(nd);
          if not (vsInitialized in nd^.States) then  VST.ReinitNode(nd, False);
        end;

       dsx^.nm0:=dsn.nm0;
       dsx^.tag:=dsn.tag;
       dsx^.sti:=dsn.sti;
       dsx^.sti1:=dsn.sti1;
       dsx^.ndp:=cnd;
       result:=nd;


end;

 {
function tform1.newnode(asf:string;cnd:pvirtualnode;ds:pvstrecord):pvirtualnode;
var
  nd:pvirtualnode;
  dsx,data:pvstrecord;
  s:string;
begin   if asf='i' then   nd:=vst.InsertNode(cnd,amInsertafter,ds);
        if asf='a' then   nd:=vst.AddChild(cnd,ds);
       //  s:='newnode sti='+inttostr(ds^.sti)+',ndcheck_state='+booltostr(ds^.ndcheck_state);
       // log('l',s);
        //if ds^.ndcheck=true  then begin
        if ds^.ndcheck_state then begin
          nd^.CheckType     := ctTriStateCheckBox;
          vst.CheckState[nd]:= cscheckedNormal;

          nd^.CheckType := ctCheckBox;
          Data := VST.GetNodeData(nd);
          if not (vsInitialized in nd^.States) then  VST.ReinitNode(nd, False);

        end;
       {
        dsx:=vst.getnodedata(nd);
        dsx^:=ds^;}
        result:=nd;
end;
 }

procedure TForm1.MenuItem1Click(Sender: TObject);
var
  nd:pvirtualnode;
  ds,dsy:pvstrecord;
begin

     dsy:=vst.getnodedata(currnd);
     log('l','nm000000000000000000000000000000='+dsy^.nm0);
     dsy^.level:=vst.GetNodeLevel(currnd);

     dsy^.ndcheck:=true;
     dsy^.ndcheck_state :=true;
     //formshemanode.lename.setfocus;
     formshemanode.lename.Color:=clred;
     formshemanode.setprm(currnd);
     formshemanode.Show;

     // ds^.nm0:=dsn^.nm0;
     // ds^.level:=dsn^.level;
    //  log('l','nm0='+ds^.nm0+' /level='+inttostr(ds^.level));

end;


function TForm1.yesno(s: string): boolean;
var
  rez: boolean;
begin
  if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then rez := False
  else
    rez := True;
  Result := rez;
end;




function TForm1.Inputsg(const Prompt: string; var Value: string): boolean;
var
  s: string;
  i: integer;
begin
  s := Value;
  Result := InputQuery('Введите время реле ', Prompt, s);
  if Result then
    Value := s;
  //Value :=LowerCase (s);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
VAR
  ds:pvstrecord;
  myid,nm0,s:string;
begin
    ds:=vst.GetNodeData(currnd);
    nm0:=ds^.nm0;
    myid:=inttostr(ds^.myid);
    if not yesno ('ВЫ ДЕЙСТВИТЕЛЬНО ХОТИТЕ УДАЛИТЬ УЗЕЛ='+nm0) then exit;
    vst.DeleteNode(currnd);
    s:='delete from tsspsh_datatree where myid='+myid +' and name='+ap+nm0+ap;
    log('c','s='+s);
    selfupd(s);
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
var
  nd:pvirtualnode;
  ds:pvstrecord;
  nms:string;
  i:integer;
begin
    try
      i:=1;
      nd:=currnd;
      ds:=vst.GetNodeData(nd);
      if ds <> nil then begin
       form1.log('y', 'MenuItem3Clic myid='+inttostr(ds^.myid));
      end
      else begin
        form1.log('r', 'MenuItem3Clic DS=NIL');
      end;
      i:=2;
      LOG('y','BEFORE  formshemanode.SHOW');
     // formshemanode.Visible:=true;
    // showmessage('tut');
      formshemanode.show;
      formshemanode.BringToFront;
      formshemanode.setprm(currnd);
      LOG('w','AFTER  formshemanode.SHOW');
      except
        on e: Exception do
         begin
          form1.log('e', 'MenuItem3Click,e=' + e.message + '/i=' + IntToStr(i));
        end;
  end;

       {
        form1.Inputsg('введите название',nms);
        nd:=vst.AddChild(nil);
        ds:=vst.getnodedata(nd);
        ds^.nm0:=nms+ ' СХЕМА ='+form1.cmbtsspsh.text;
        exit;
       }

        //nd:=vst.AddChild(nd);
        //ds:=vst.getnodedata(nd);
        //ds^.nm0:=datetimetostr(now);
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
var
  s,cps:string;
begin
   //showmessage('IN WORK');
   cps:=inttostr(getcps10(currnd));
   log('l','cps='+cps);

  {
    select  count(*) from
tsspsh_datatree  as d1,
--tsspsh_datatree  as d2,
tss_persons        as p
where
d1.bp=275
and p.biddtree=d1.myid
--and d2.bp=d1.myid
}
    s:='SELECT count(*) '+
     ' FROM  '+
     ' tsspsh_datatree  as d,'+
     ' tss_persons  as p '+
     ' WHERE '+
     ' ( '+
     ' p.biddtree=d.myid '+
     ' and d.tag=5 '+
     ' and d.bp=275 '+
     ' ) ';


end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin

end;

function tform1.togls(tbn,nm:string):string;
var
  myid,s:string;
  rc:trcfld;
begin
     try
      result:='-1';
     // s:='select myid from '+tbn+' where text='+ap+nm+ap;
     // rc:=readfld(s)  ;
     //  myid:=trim(rc.value);
     //  if myid<>'' then begin
     //   result:=myid;
     //   exit;
     //  end;
      s:='insert into '+tbn+' (text)values('+ap+nm+ap+')';
      selfupd(s);
      myid:=inttostr(form1.getlastmyid(tbn));
      result:=myid;
     except
       {
       s:='select myid from '+tbn+' where text='+ap+nm+ap;
        rc:=readfld(s)  ;
        myid:=trim(rc.value);
        if myid<>'' then begin
         result:=myid;
        }
         exit;
     end;



      end;



procedure TForm1.read2;
var
nm,s,name1,name2,name3,myid,myid1,myid2,myid3:string;
begin
         //selfupdc('delete from tssgls_name1 ');
        selfupdc('delete from tssgls_name2 ');
        // selfupdc('delete from tssgls_name3 ');
      log('y','read2 222222222222222222222222222222222222222222222222222222222222222222222222222222222222222');
      md.First;
      while not md.eof do begin
       // name1:=md.FieldByName('name1').asstring;
       name2:=md.FieldByName('name2').asstring;
       //name3:=md.FieldByName('name3').asstring;
       //myid1:=togls('tssgls_name1',name1);
       myid2:=togls('tssgls_name2',name2);
     // myid3:=togls('tssgls_name3',name3);
       md.next;
      end;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);

var
qrz:TSQLQuery;
nm,s,name1,name2,name3,myid,myid1,myid2,myid3:string;
 x,nn:integer;
begin


      x:=1;
   try

     qrz:=TSQLQuery.Create(nil);
      s:='select MYID,FIO  from tss_persons order by fio';
      qrz:=TSQLQuery.Create(nil);
      qrz.DataBase:=formpgs.pgc1;
      qrz.Transaction:=formpgs.trc1;
      qrz.SQL.Clear;
      qrz.SQL.add(s);
      qrz.Active:=true;
      x:=3;
      qrz.First;
      md.Open;
      while not qrz.eof do begin
         x:=4;
         myid:=trim(qrz.FieldByName('myid').AsString);
         nm:=trim(qrz.FieldByName('fio').AsString);
         name2:=trim(dmfunc.ExtractStr(3,nm,' ')) ;
         name1:=trim(dmfunc.ExtractStr(2,nm,' ')) ;
         name3:=trim(dmfunc.ExtractStr(1,nm,' ')) ;
         X:=5;
         md.Insert;
         md.FieldByName('nn').AsInteger:=md.RecordCount+1;
         X:=6;
       //  myid1:=togls('tssgls_name1',name1);
         X:=7;
       //  myid2:=togls('tssgls_name2',name2);
         X:=8;
       //  myid3:=togls('tssgls_name3',name3);
         X:=9;
         s:=myid1+zp+myid2+zp+myid3;
         md.fieldbyname('name1').asstring:=name1;
         md.fieldbyname('name2').asstring:=name2;
         md.fieldbyname('name3').asstring:=name3;
         md.Post;


         qrz.next;



      end;
      except
       on e: Exception do
       begin
        form1.log('e', 'LINETOGLS,e=' + e.message + '/X=' + IntToStr(X));
       end;
      end;
     read2;


   end;

function tform1.formirnodeman(cnd:pvirtualnode):string;
var
  biddtree,myid,s:string;
  qr:tsqlquery;
  ds,dsn:pvstrecord;
  name1,name2,name3,pmyid,pbpkeys,dep:string;
begin
     exit;
     SHOWMESSAGE('NODEMAN 0');
     ds:=vst.GetNodeData(cnd);
     myid:=inttostr(ds^.myid);
     result:='';
     //  SHOWMESSAGE('NODEMAN 00');
     //dsn^.nm0:=timetostr(time);
     //SHOWMESSAGE('NODEMAN 000');

     //   dsn^.sti:=31;
     //dsn^.sti1:=-1;
     //dsn^.tag:=3;
     //dsn^.ndcheck_state:=true;
     //SHOWMESSAGE('NODEMAN 1');

       s:='select inf.name3 ,inf.name1,inf.name2, p.myid ,p.bpkeys,d.name  from '+
        ' tss_persons       as p,'+
        ' tsspsh_datatree  as d,'+
        ' tss_persinfo       as inf '+
        ' where '+
        ' p.biddtree='+myid+
        ' and  p.biddtree=d.myid'+
        ' and p.myid =inf.bidpers    order by inf.name3';
     // SHOWMESSAGE('NODEMAN 2');
     log('c',s);
     //exit;
     qr:=calcqr(s);
     md.Open;
     md.DisableControls;
     md.Clear(false);
     //clearmd(md);
     //showmessage('selpersonsfromnode 1');
     while not qr.eof do begin
     // showmessage('selpersonsfromnode 2');
      name3:=qr.Fields[0].AsString;
      //log('r','name3='+name3);
      name1:=qr.Fields[1].AsString;
      name2:=qr.Fields[2].AsString;
      pmyid:=qr.Fields[3].AsString;
      pbpkeys:=qr.Fields[4].AsString;
      dep  :=qr.Fields[5].AsString;
      //dsn^.nm0:=name3+' '+name1+' '+name2;
      log('y','FORMIRMAN FIO='+name3+' '+name1+' '+name2);
     //  SHOWMESSAGE('NODEMAN 3');
      //form1.fnna(cnd,dsn);

      md.Insert;
      md.FieldByName('nn').AsInteger:=md.RecordCount+1;
      md.FieldByName('myid').AsInteger:=strtoint(pmyid);
      md.FieldByName('bpkeys').AsInteger:=strtoint(pbpkeys);
      md.FieldByName('biddree').AsInteger:=strtoint(myid);
      md.FieldByName('name1').asstring:=name3+' '+name1+' '+name2;
      md.Post;
      qr.next;
     end;
     md.EnableControls;
     md.First;

end;

function tform1.selpersonsfromnode(cnd:pvirtualnode):string;
var
  biddtree,myid,s:string;
  qr:tsqlquery;
  ds,dsn:pvstrecord;
  dsxx:tnewds;
  nd:pvirtualnode;
  name1,name2,name3,pmyid,pbpkeys,dep,root:string;
begin
     ds:=vst.GetNodeData(cnd);
     myid:=inttostr(ds^.myid);
     result:='';
     root:=ds^.nm0;
     dsxx.nm0:=timetostr(time);
     dsxx.sti:=-1;
     dsxx.sti1:=-1;
     dsxx.tag:=3;
     dsxx.ndcheck_state:=false;
     //SHOWMESSAGE('NODEMAN 1');


       s:='select inf.name3 ,inf.name1,inf.name2, p.myid ,p.bpkeys,d.name  from '+
        ' tss_persons       as p,'+
        ' tsspsh_datatree  as d,'+
        ' tss_persinfo       as inf '+
        ' where '+
        ' p.biddtree='+myid+
        ' and  p.biddtree=d.myid'+
        ' and p.myid =inf.bidpers    order by inf.name3';
    // showmessage('selpersonsfromnode');
     log('r',s);
     //exit;
     qr:=calcqr(s);
     md.Open;
     md.DisableControls;
     md.Clear(false);
     //clearmd(md);
     //showmessage('selpersonsfromnode 1');
     while not qr.eof do begin
     // showmessage('selpersonsfromnode 2');
      name3:=qr.Fields[0].AsString;
      //log('r','name3='+name3);
      name1:=qr.Fields[1].AsString;
      name2:=qr.Fields[2].AsString;
      pmyid:=qr.Fields[3].AsString;
      pbpkeys:=qr.Fields[4].AsString;
      dep  :=qr.Fields[5].AsString;
    //  log('y','FIO='+name3+' '+name1+' '+name2);
     // dsxx.nm1:=name3+' '+name1+' '+name2;
      nd:=form1.fnna(cnd,dsxx);
      dsn:=vst.GetNodeData(nd);
      dsn^.root:=root;
      dsn^.nm0:=name3+' '+name1+' '+name2;
     // dsn^.nm1:=timetostr(time);
      md.Insert;
      md.FieldByName('nn').AsInteger:=md.RecordCount+1;
      md.FieldByName('myid').AsInteger:=strtoint(pmyid);
      md.FieldByName('bpkeys').AsInteger:=strtoint(pbpkeys);
      md.FieldByName('biddree').AsInteger:=strtoint(myid);
      md.FieldByName('name1').asstring:=name3+' '+name1+' '+name2;
      md.Post;
      qr.next;
     end;
     md.EnableControls;
     md.First;

end;

procedure TForm1.linkonperson(cnd:pvirtualnode);
var
 myid,myidsh,s:string;
 ds:pvstrecord;
 begin
       ds:=vst.getnodedata(cnd);
       myid:=form_pers1.md.FieldByName('myid').AsString;
       myidsh:=inttostr(ds^.myid);
       s:='update tss_persons set biddtree='+myidsh+' where myid='+myid;
       log('y','linkonperson='+s);
       form1.selfupdc(s);
       s:='update tss_persons set actual=false'+' where myid='+myid;
       form1.selfupdc(s);

       md.Edit;
       md.FieldByName('biddree').AsInteger:=strtoint(myidsh);
       md.post;
 end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
    // showmessage('link to persons');
       linkonperson(currnd);
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
       form1.filliklist(form_pers1.DBGrid2,'tmzname');
       form_pers1.selpersonsfromnode(currnd);
end;



function tform1.jstosl(sJSON: String):string; //text tstringlist
var
  SL: TStringList;
  i: Integer;
  sdaTmp: TStringDynArray;
begin
  // !!! В ключах и значениях не должно быть символов ':' и ',' !!!

  sJSON:=Trim(sJSON);
  sJSON:=sJSON.Substring(1,Length(sJSON)-2).Replace('"','');

  sdaTmp:=sJSON.Split([':']);
  sJSON:='';
  for i:=0 to Length(sdaTmp)-1 do sJSON:=sJSON+ifthen(0=length(sJSON),'','=')+Trim(sdaTmp[i]);

  sdaTmp:=sJSON.Split([',']);
  sJSON:='';
  for i:=0 to Length(sdaTmp)-1 do sJSON:=sJSON+ifthen(0=length(sJSON),'',',')+Trim(sdaTmp[i]);

  //SL:= TStringList.Create;
  //SL.DelimitedText:=sJSON;
  // Result:= SL;
   result:=sJSON;
end; // function TfmMain.doJSON2SL(..): TStringList;





procedure TForm1.PageControl2Change(Sender: TObject);
var
  i:integer;
begin
       {
       i:=PageControl2.ActivePageIndex;
       LOG('w','PageControl2Change i='+inttostr(i));
       if i=2 then begin
        formtmzvst.Show;
        formtmzvst.BringToFront;
        formtmzvst.rereadvst;
       end;
       }
end;

procedure TForm1.PageControl3Change(Sender: TObject);
var
 pg:tpagecontrol;
 i:integer;
 s:string;
begin
   pg:=sender as tpagecontrol;

   i:=pg.ActivePageIndex;
   log('y','PageControl3Change caption='+' / i='+inttostr(i));


   s:='select * from tss_keys where bppers='+md.FieldByName('myid').AsString;
    log('y',s);
    if (i=1) and (md.RecordCount>0) then readkeys(s);
   // if i=3 then formindgrf.SHOW;

end;

procedure tform1.readglstmz;
var
 i,j,k:integer;
 s,nmz:string;
 qrd,qrx:tsqlquery;
 sl:tstringlist;
begin
       if not fstart then EXIT;
     //  showmessage('readglstmz start');
       sl:=tstringlist.Create;
       s:='select  distinct name from tssgls_nametmz';
       qrd:=form1.calcqr(s);
       while not qrd.eof do begin
        sl.Add(qrd.Fields[0].AsString);
        log('y','readglstmz='+qrd.Fields[0].AsString);
        qrd.next;
       end;
       persdata.mdnamrtmz.Clear(false);
       //clearmd(persdata.mdnamrtmz);
       for i:=0 to sl.Count-1 do begin;
        nmz:=sl[i];
      //  showmessage('nmz='+nmz);
        s:='select  distinct myid, name,day,dayow'+
           ' from tssgls_nametmz'+
           ' where name='+ap+nmz+ap+
           ' group by myid,name,dayow,day'+
           ' order by name,dayow';
          log('w',s);
        //s:='select myid,name,day from tssgls_nametmz order by name';
        qrx:=calcqr(s);
        persdata.mdnamrtmz.open;
        k:=0;
        while not qrx.eof do begin
         persdata.mdnamrtmz.insert;
         persdata.mdnamrtmz.FieldByName('myid').AsInteger:=qrx.FieldByName('myid').AsInteger;
         if k=0 then begin
          persdata.mdnamrtmz.FieldByName('name').Asstring:=qrx.FieldByName('name').Asstring;
          k:=k+1;
         end;
         persdata.mdnamrtmz.FieldByName('day').Asstring:=qrx.FieldByName('day').Asstring;
         persdata.mdnamrtmz.FieldByName('dayow').Asinteger:=strtoint(qrx.FieldByName('dayow').Asstring);
         log('l',qrx.FieldByName('day').Asstring);
         persdata.mdnamrtmz.post;
         qrx.next;
        end;
        persdata.mdnamrtmz.first;
      end;


end;

procedure TForm1.PageControl4Change(Sender: TObject);
var
 i:integer;
begin

end;


procedure tform1.pmsg(cl:int64;txt:string);
begin
     log('y','pmsg='+txt);
    {
     memo1.Lines.Clear;
     memo1.Lines.Add(txt+' '+datetimetostr(now));
     if cl=clred  then begin  memo1.color:=clred; memo1.Font.color:=clblack; end;
     if cl=cllime then begin  memo1.color:=cllime; memo1.Font.color:=clblack; end;
     }
end;

procedure tform1.slog(txt:string);
begin
      //listbox1.Items.Add(txt);
end;

function tform1.faddkey:string;
var
 s,bppers,kluch,keypad,code,start,stop,acts:string;
begin
   {
      bppers:=md.FieldByName('myid').asstring;
      kluch:=trim(le_kluch.text);
      code:=inttostr(dmfunc.skeytox(kluch));
      keypad:=trim(le_keypad.text);
      start:=trim(le_start.text);
      stop:=trim(le_stop.text);
      if cbactkey.Checked then acts:='true' else acts:='false';
      s:='insert into tss_keys(actual,code,bppers,kluch,keypad,start,stop)values('+
        acts+zp+
        code+zp+
        bppers+zp+
        ap+kluch+ap+zp+
        ap+keypad+ap+zp+
        ap+start+ap+zp+
        ap+stop+ap+
         ')';
      slog('s='+s);
      result:=selfupd(s);
      if result='ok' then begin
       s:='update tss_persinfo set upd_cdts=current_timestamp where bidpers='+bppers;
       result:=selfupd(s);
      end;
      log('y','faddkey s='+s);
      s:='select * from tss_keys where bppers='+bppers;
      log('w','ds1change='+s);
      readkeys(s);
      //mdk.first;

       }

end;

function tform1.checkpersvalues:boolean;
var
 code:int64;
 l,n:integer;
 cd:tdate;
 rc,s,kluch,keypad,start,stop,acts:string;
begin
       {
        result:=true;
        if md.RecordCount=0 then begin
         pmsg(clred,'НЕТ ВЫБРАННЫХ ПЕРСОН') ;
         exit;
       end;

       kLUCH:=trim(LE_KLUCH.TEXT);
       l:=length(kluch);
       log('r','l='+inttostr(l));
       slog('fnewkey start '+datetimetostr(now));
       
       if l>12 then begin
         pmsg(clred,'код ключа содержит более 12 символов или не шестнадцатиричные знаки');
         exit;
       end;

       code:=dmfunc.skeytox(kluch);
       keypad:=le_keypad.Text;
       start:=le_start.Text;
       stop :=le_stop.Text;
       if cbactkey.Checked then acts:='true' else acts:='false';

       log('y','fnewkey kl='+kluch+' /code='+inttostr(code));
       if code=0 then begin
        pmsg(clred,'код ключа либо пусто либо не шестнадцатиричные цифры');
        exit;
       end;
       
       try
         cd:=strtodate(le_start.Text);
         start:=le_start.text;
         cd:=strtodate(le_stop.Text);
         stop:=le_stop.text;
       except
        pmsg(clred,'неправильно задана дата');
        exit;
       end;


       try
        s:=trim(le_keypad.text);
        l:=length(s);
        if l>0 then begin
         n:=strtoint(s);
        end;
        if l>4 then begin
         pmsg(clred,' 1 неправильно задан keypad');
         exit;
        end;
       except
         pmsg(clred,' 2 неправильно задан keypad');
         exit;
       end;
       }

end;

function tform1.fnewkey:boolean;
var
 rcx:boolean;
 rc:string;
begin

       rcx:=checkpersvalues;
       if rcx then begin
        rc:=faddkey;
        if rc<>'ok' then begin
         pmsg(clred,rc);
         exit;
       end;
      end;
      pmsg(cllime,'   ВЫПОЛНЕНО');



end;

procedure TForm1.panaddkeyClick(Sender: TObject);
var
p:tpanel;
cl:int64;
i:integer;
f:boolean;
begin

    f:=false;
    p:=sender as tpanel;
    cl:=p.color;
    p.Color:=cllime;
    p.BevelInner:=bvlowered;
    //showmessage('newkey');
    fnewkey;
    dmfunc.MyDelay(500);
    p.BevelInner:=bvraised;
    p.BevelOuter:=bvraised;
    p.Color:=cl;


end;

procedure TForm1.Panel12Click(Sender: TObject);
begin

end;

procedure TForm1.Panel15Click(Sender: TObject);
begin

end;

procedure TForm1.Panel16Click(Sender: TObject);
begin

end;

procedure TForm1.Panel17Click(Sender: TObject);
begin

end;

procedure TForm1.Panel19Click(Sender: TObject);
begin

end;

procedure TForm1.Panel4Click(Sender: TObject);
begin

end;

procedure TForm1.Panel9Click(Sender: TObject);
begin

end;

procedure tform1.updpage_fio;
var
 s,name1,name2,name3:string;
 sd:tdate;
begin
     {
        md.open;
        name1:=le_name1.Text;
        name2:=le_name2.Text;
        name3:=le_name3.Text;
        s:='update tss_persinfo '+
        ' set name1='+ap+name1+ap+zp+
        ' name2='+ap+name2+ap+zp+
        ' name3='+ap+name3+ap+zp+'upd_cdts= current_timestamp '+
        ' where bidpers='+md.FieldByName('myid').asstring;
        log('y','updpage_fio='+s);
        selfupd(s);
        }

end;

procedure TForm1.pantosysClick(Sender: TObject);
var
p:tpanel;
cl:int64;
i:integer;
f:boolean;
begin
    if md.RecordCount=0 then begin
     showmessage('ВЫ НЕ ВЫБРАЛИ ПЕРСОНУ --EXIT');
     EXIT;
    end;
    f:=false;
    p:=sender as tpanel;
    cl:=p.color;
    p.Color:=cllime;
    p.BevelInner:=bvlowered;
    updpage_fio;
    dmfunc.MyDelay(500);
    p.BevelInner:=bvraised;
    p.BevelOuter:=bvraised;
    p.Color:=cl;



end;

procedure TForm1.panupdkeyClick(Sender: TObject);
var
p:tpanel;
cl:int64;
i:integer;
f:boolean;
begin

    f:=false;
    p:=sender as tpanel;
    cl:=p.color;
    p.Color:=cllime;
    p.BevelInner:=bvlowered;
    //updpage_key;
    dmfunc.MyDelay(500);
    p.BevelInner:=bvraised;
    p.BevelOuter:=bvraised;
    p.Color:=cl;


end;

procedure TForm1.Pan_name4Click(Sender: TObject);
begin

end;

procedure TForm1.sb1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
begin


end;

procedure TForm1.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.TabSheet3ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.TabSheet6ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.TabSheet8ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.Timer1sTimer(Sender: TObject);
var
 s:string;
 i:integer;
begin

      timer1s.Enabled:=false;
      etscd.Text:= FormatDateTime('yyyy-mm-dd, hh:nn:ss', now);
     // log('y','timerr1s='+etscd.Text);

      timer1s.Enabled:=true;

end;


procedure TForm1.timerspecwaitTimer(Sender: TObject);
var
 pt:string;
begin
       timerspecwait.enabled:=false;
       pt:=appdir+'starter/eg.txt';
       autor:=false;
      if fileexists(pt) then begin
       log('r','AUTOR is HEER');
       panel7.Color:=clskyblue;
        panel7.Caption:='A';
        autor:=true;
      end;
         form1.readtsspsh;
end;


procedure TForm1.log(pr, txt: string);
var
   nn:string;
begin

     // lb1.Items.Add(txt);
     // lb1.ItemIndex:=lb1.ItemIndex+1;
     // exit;
     formallog.LOG(pr,txt);

end;

procedure TForm1.timerstartTimer(Sender: TObject);
begin
      timerstart.Enabled:=false;
      fstart:=true;
       prolog1;
      readtsspsh;
      //ptitlenode;




end;

procedure TForm1.vstBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
   Data: pvstrecord;
begin

    data:=vst.GetNodeData(node);
   // if (data^.foncol>0)  then begin
   //  TargetCanvas.Brush.Color :=clskyblue; //suda05
   //  TargetCanvas.FillRect(CellRect);

  // end;


end;


procedure TForm1.ptitlenode;
var
 dsx:pvstrecord;
 nd:pvirtualnode;
 bplast,bidshema:string;
begin
      bplast:='-1';
      bidshema:='-1';
     vst.clear;
     nd:=vst.AddChild(nil);
     dsx:=vst.getnodedata(nd);
     dsx^.nm0:='Владелец СКУД  схема='+form1.cmbtsspsh.text;
     dsx^.level:=0;    //vst.GetNodeLevel(currnd);
     // showmessage('tut 1');
     dsx^.sti1:=-1;
     dsx^.sti:=-1;
     dsx^.sti1:=-1;
     dsx^.tag:=-10;
     dsx^.myid:=0;
     umain.firstnd:=nd;
     //showmessage('tut 2');
     //firstnd:=form1.newnode('a',nil,dsx);
     //log('l','titlenode AFTER FNN');
     //exit;

end;

procedure TForm1.vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var NewState: TCheckState; var Allowed: Boolean);
var
  dl: pvstrecord;
begin

  dl := vst.GetNodeData(node);
  dl^.ndcheck_state:=true;
  // log('w','nm0='+dl^.nm0+' /dbmyid='+inttostr(dl^.dbmyid));
  if newstate = csCheckedNormal then  dl^.ndcheck_state := True;
  if newstate = csUncheckedNormal then  dl^.ndcheck_state := False;
  //log('c','checking=============='+booltostr(dl^.ndcheck_state));

end;

procedure TForm1.vstGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
  var ImageIndex: Integer);

var
nd: PVirtualNode;
Data: PVSTRecord;
vv: TBaseVirtualTree;
n: integer;
begin

Data := vst.GetNodeData(node);
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

procedure TForm1.vstGetImageIndexEx(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer; var ImageList: TCustomImageList
  );
var
  nd: PVirtualNode;
  Data: PVSTRecord;

  vv: TBaseVirtualTree;
  n: integer;
begin

  Data := vst.GetNodeData(node);
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

procedure TForm1.vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);

var data : pvstrecord;
begin
    Data := Sender.GetNodeData(node);
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

procedure TForm1.vstPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
data :pvstrecord;
rc:boolean;
begin
   data:=vst.GetNodeData(node);
  //if column=1 then begin
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
  //if (not data^.act ) and ((data^.tag=0) or  (data^.tag=1) or(data^.tag=2)) then begin
   // TargetCanvas.Font.Color :=clskyblue;   //   suda vstfontcolor
   //end;
  // if ( data^.atention=true ) and (data^.tag=4)then begin
  //  TargetCanvas.Font.Color :=clskyblue ;   //   suda vstfontcolor
  // end;
    //if ( data^.tag=2 ) and (data^.wkpx=0)then begin       suda13
    //TargetCanvas.Font.Color :=cllime;   //   suda vstfontcolor
   //end;
   // if ( data^.tag=2 ) and (data^.wkpx=1)then begin
   // TargetCanvas.Font.Color :=clyellow;   //   suda vstfontcolor
  // end;
 //  if ( data^.tag=1 ) and (data^.fatal='e')then begin
 //   TargetCanvas.Font.Color :=clred;   //   suda vstfontcolor
   end;
  //  if ( data^.tag=1 ) and (data^.fatal='?')then begin
   // TargetCanvas.Font.Color :=cllime;   //   suda vstfontcolor
  // end;



procedure TForm1.vstChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
VAR
   ds:pvstrecord ;
   I:INTEGER;
begin
     try
      i:=1;
      //log('l','vstchange start ???');


         if node=nil then begin
          vst.PopupMenu:=popnil;
         end;
        i:=2;
        currnd:=node;
        if currnd=nil then exit;
        ds:= vst.getnodedata(node);
        ds^.level:=vst.GetNodeLevel(currnd);
        i:=3;
         if ds=nil then begin
           log('r','ds=nil');
           exit;
         end;
        i:=4;
        log('c','vstchanmyid='+inttostr(ds^.myid)+zp+'root='+ds^.root+zp+zp+' nm0='+ds^.nm0+',level='+inttostr(ds^.level)+zp+'tag='+inttostr(ds^.tag));
      except
       on e: Exception do
       begin
        form1.log('e', 'VSTCHANGE,e=' + e.message + '/i=' + IntToStr(i));
       end;
      end;


end;

end.

