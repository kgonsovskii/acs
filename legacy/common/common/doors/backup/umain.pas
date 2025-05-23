unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  StdCtrls, laz.virtualtrees,base64,uglink,SQLDB,Types,
  TSSMQTTC,dateutils,
  ImgList,
  fpjson, jsonparser,
  uformstarter,udtrans, UniqueInstance,
  ctypes,StrUtils, LCLType;

type thostparam =record
     comp   :string;
     ip     :string;
     end;

type
   temuldata =record
   bidlocsens :string;
   bidsens    :string;
   sens :string;
   ch   :string;
   ac   :string;
   port :string;
   kluch:string;
   codekey:string;
   mrs  :string;
   fio  :string;
   ntmz :string;
  end;

type
  trcsenscode=record
   code :string;
   sens :string;
  end;

type
  trcfld= record
    rc    : string;
    value : string;
   end;


type
  tsubsysst= record
    cn   : string;
    pid  :string;
    luxt : int64;
   end;




type
  tlinkusens= record
    pcode :array[1..4] of string;
    lcode :array[1..4] of string;
   end;


type
  tfillnd = record
    nm0:string;
    nm1:string;
    sti:integer;
    sti1:integer;
    tag:integer;
    code:integer;
    sens :string;
    loccode:integer;
    ndcheck: string;
    ndcheck_state:string;
    place :string;
  end;

type
  tcs2 = record
    Count: integer;
    line: string;
  end;


type
  tsubsysstatus = record
     lbase:     int64;
     lmqtt:     int64;


  end;


type
  tinsr = record
    mes: string;
    myid: integer;
  end;


type
  tsqlauzel = record
    pnd: pvirtualnode;
    fckp :boolean;
    locinside:boolean;
    fckps :string;
    myid: integer;
    smrn: string;
    bp: integer;
    sti: integer;
    tag: integer;
    bidch :integer;
    bpsens :integer;
    loccode :integer;
    code:integer;
    sens:string;
    Name: string;
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

type
  pvstrecordloc = ^Tpvstrecordloc;

  Tpvstrecordloc = record
    ndp: pvirtualnode;
    bpsens: integer;
    numsens:integer;
    code    :integer;
    sens    :string;

    nx :integer;
    bidch:integer;
    bidac:integer;
    ac   :string;
    locindide:boolean;
    act: boolean;
    slchild: TStringList;
    ctypx: string;
    abi: integer;
    mpcl: integer;
    bp: integer;
    bps: integer;
    bpp: integer;
    bpfloor: integer;
    fckp: boolean;
    fckps: string;
    ioflag: boolean;
    ioflags: string;
    loccode: integer;
    smrn: string;
    tag: integer;
    loctype: integer;
    dbmyid: integer;
    lastobs: int64;
    src: string;
    nm0: string;
    nm1: string;
    nm2: string;
    nm3: string;
    nm4: string;

    sti: integer;
    sti0: integer;
    sti1: integer;
    keyname: string;  // составное имя=bp+zp+dbmyid+zp+nm0+zp+tag;
    Image: integer;
    Size: int64;

  end;


type
  pvstrecord = ^Tpvstrecord;
  Tpvstrecord = record
    foncol    : int64;
    idxmenu   :integer;
    bidch     :integer;
    fatal     :string;
    wkpx      :integer;
    path      :string;
    launchline:string;
    idkomu   :string;
    comp     :string;
    ch       :string;
    ac       :string;
    port     :string;
    sensor   :string;
    bidac    :integer;
    act      :boolean;
    ctyp     :string;
    pidguard :integer;
    pidch    :integer;
    chtype   :string;
    chkstate :boolean;
    atention :boolean;
    bp       :integer;
    bploc    :integer;
    bpsens    :integer;
    mrn      :integer;
    ndp      :pvirtualnode;
    tag      :integer;
    dbmyid   :integer;
    lastobs  :int64;
    idx_loc_1:integer;
    idx_loc_2:integer;
    src      :string;
    nm0      :string;
    nm1      :string;
    nm2      :string;
    nm3      :string;
    nm4      :string;
    nm5      :string;
    sti      :integer;
    sti0     :integer;
    sti1     :integer;
    keyname  :string;  // составное имя=bp+','+dbmyid+'.'+nm0+'.'+tag;
    app      :string;
    host     :string;

    f2     :string;
    Image: Integer;
    Size: Int64;
  end;




  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbr: TCheckBox;
    eevx: TEdit;
    etscd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    MenuItem104: TMenuItem;
    MenuItem105: TMenuItem;
    MenuItem106: TMenuItem;
    MenuItem107: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItem68: TMenuItem;
    MenuItem69: TMenuItem;
    MenuItem70: TMenuItem;
    MenuItem71: TMenuItem;
    MenuItem72: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem79: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    MenuItem89: TMenuItem;
    MenuItem90: TMenuItem;
    MenuItem91: TMenuItem;
    MenuItem92: TMenuItem;
    MenuItem93: TMenuItem;
    MenuItem94: TMenuItem;
    MenuItem95: TMenuItem;
    MenuItem96: TMenuItem;
    MenuItem97: TMenuItem;
    MenuItem98: TMenuItem;
    MenuItem99: TMenuItem;
    OPD1: TOpenDialog;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    popbase: TPopupMenu;
    poplocm5dr: TPopupMenu;
    popdms: TPopupMenu;
    pop2: TPopupMenu;
    p_dms: TPanel;
    p_sgrd: TPanel;
    p_writerlog: TPanel;
    p_firebird: TPanel;
    p_databases: TPanel;
    p_databasef: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    P_transport: TPanel;
    p_comcentr: TPanel;
    poploctag0: TPopupMenu;
    poploctag1: TPopupMenu;
    poploctag2: TPopupMenu;
    poplocm3: TPopupMenu;
    poplocm4: TPopupMenu;
    popm109: TPopupMenu;
    poplocm5: TPopupMenu;
    poptag4: TPopupMenu;
    timerinmqtt: TTimer;
    Timer5s: TTimer;
    vstloc: TLazVirtualStringTree;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem9: TMenuItem;
    poptag2: TPopupMenu;
    poptag0: TPopupMenu;
    poptag1: TPopupMenu;
    poplocnil: TPopupMenu;
    selftr: TSQLTransaction;
    timerchecks: TTimer;
    UniqueInstance1: TUniqueInstance;

    LargeImages: TImageList;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    popminus: TPopupMenu;
    timer1s: TTimer;
    timerstart: TTimer;
    vst: TLazVirtualStringTree;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    popnil: TPopupMenu;
    Splitter1: TSplitter;
    spl2: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbrClick(Sender: TObject);
    procedure etscdChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure MainMenu1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure MenuItem100Click(Sender: TObject);
    procedure MenuItem101Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem105Click(Sender: TObject);
    procedure MenuItem106Click(Sender: TObject);
    procedure MenuItem107Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem35Click(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem37Click(Sender: TObject);
    procedure MenuItem38Click(Sender: TObject);
    procedure MenuItem39Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuItem41Click(Sender: TObject);
    procedure MenuItem42Click(Sender: TObject);
    procedure MenuItem43Click(Sender: TObject);
    procedure MenuItem44Click(Sender: TObject);
    procedure MenuItem45Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure MenuItem47Click(Sender: TObject);
    procedure MenuItem48Click(Sender: TObject);
    procedure MenuItem49Click(Sender: TObject);
    procedure MenuItem51Click(Sender: TObject);
    procedure MenuItem52Click(Sender: TObject);
    procedure MenuItem53Click(Sender: TObject);
    procedure MenuItem54Click(Sender: TObject);
    procedure MenuItem55Click(Sender: TObject);
    procedure MenuItem56Click(Sender: TObject);
    procedure MenuItem57Click(Sender: TObject);
    procedure MenuItem58Click(Sender: TObject);
    procedure MenuItem59Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem60Click(Sender: TObject);
    procedure MenuItem61Click(Sender: TObject);
    procedure MenuItem62Click(Sender: TObject);
    procedure MenuItem63Click(Sender: TObject);
    procedure MenuItem64Click(Sender: TObject);
    procedure MenuItem65Click(Sender: TObject);
    procedure MenuItem67Click(Sender: TObject);
    procedure MenuItem68Click(Sender: TObject);
    procedure MenuItem69Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem71Click(Sender: TObject);
    procedure MenuItem72Click(Sender: TObject);
    procedure MenuItem73Click(Sender: TObject);
    procedure MenuItem75Click(Sender: TObject);
    procedure MenuItem76Click(Sender: TObject);
    procedure MenuItem77Click(Sender: TObject);
    procedure MenuItem78Click(Sender: TObject);
    procedure MenuItem79Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem80Click(Sender: TObject);
    procedure MenuItem81Click(Sender: TObject);
    procedure MenuItem82DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure MenuItem83Click(Sender: TObject);
    procedure MenuItem83DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure MenuItem84Click(Sender: TObject);
    procedure MenuItem86Click(Sender: TObject);
    procedure MenuItem87Click(Sender: TObject);
   // procedure MenuItem81MeasureItem(Sender: TObject; ACanvas: TCanvas;
   //   var AWidth, AHeight: Integer);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem90Click(Sender: TObject);
    procedure MenuItem91Click(Sender: TObject);
    procedure MenuItem92Click(Sender: TObject);
    procedure MenuItem93Click(Sender: TObject);
    procedure MenuItem95Click(Sender: TObject);
    procedure MenuItem96Click(Sender: TObject);
    procedure MenuItem97Click(Sender: TObject);
    procedure MenuItem98Click(Sender: TObject);
    procedure MenuItem99Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure OPD1CanClose(Sender: TObject; var CanClose: Boolean);
    procedure OPD1Close(Sender: TObject);
    procedure OPD1SelectionChange(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel8Click(Sender: TObject);
    procedure Panel9Click(Sender: TObject);
    procedure poplocm5drDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure poptag4DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      AState: TOwnerDrawState);
    procedure poptag4MeasureItem(Sender: TObject; ACanvas: TCanvas; var AWidth,
      AHeight: Integer);
    procedure spl2CanOffset(Sender: TObject; var NewOffset: Integer;
      var Accept: Boolean);
    procedure timer1sTimer(Sender: TObject);
   procedure  Timer5sTimer(Sender: TObject);
    procedure timerchecksTimer(Sender: TObject);
    procedure timerinmqttTimer(Sender: TObject);
    procedure timerstartTimer(Sender: TObject);
    procedure UniqueInstance1OtherInstance(Sender: TObject;
      ParamCount: Integer; const Parameters: array of String);
    procedure vstAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const CellRect: TRect);
    procedure vstBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure MenuItem4Click(Sender: TObject);
    procedure titlenode;
    function  fnn(ndo:PVirtualNode;sl:tstringlist):PVirtualNode;
    procedure log(pr,txt:string);
    procedure vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: Boolean);
    procedure vstDblClick(Sender: TObject);
    procedure vstGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure vstGetImageIndexEx(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer; var ImageList: TCustomImageList);
    procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstlocAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode
      );
    procedure vstlocAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const CellRect: TRect);
    function vstlocAfterNodeExport(Sender: TBaseVirtualTree;
      aExportType: TVTExportType; Node: PVirtualNode): Boolean;
    procedure vstlocChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstlocChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstlocChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: Boolean);
    procedure vstlocCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstlocCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var Allowed: Boolean);
    procedure vstlocDblClick(Sender: TObject);
    procedure vstlocExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstlocFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstlocGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure vstlocGetImageIndexEx(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer;
      var ImageList: TCustomImageList);
    procedure vstlocGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstlocInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var ChildCount: Cardinal);
    procedure vstlocInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstlocLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure vstlocPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure vstlocRemoveFromSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vstlocSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure vstPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
   procedure   prolog;
   procedure readgrp(cnd:pvirtualnode);
   function  readfld(line:string):trcfld;


    procedure reread;
    procedure read_comps;
    procedure formirndstarter(ndc: pvirtualnode);
    function  findndnm0tag(nm: string; tgg: integer): pvirtualnode;
    procedure read_ch(bpbid: integer; ndc: pvirtualnode);
    function  fidkomu(Data: pvstrecord): pvstrecord;
    procedure read_acl(ndc: pvirtualnode);
    procedure read_ports(ndc: pvirtualnode);
    function  getmarsforports(myid: integer): integer;
    procedure read_sensors(ndp: pvirtualnode);
    procedure titlenodeloc;
    function  fnnloc(ndo: PVirtualNode; sl: TStringList): PVirtualNode;
    procedure rereadloc;
    procedure read_locations;
    procedure fillsqluzel;
    procedure currrereadloc;
    procedure showsqluzel;
    function  findj(i: integer): integer;
    function  getprmtag3(dl: pvstrecordloc): pvstrecordloc;
    function  checklinkbps(bps: integer): boolean;
    procedure formirjs_ac(cnd: pvirtualnode; subcmd: string);
    procedure showtr(p: string; rc: integer);
    procedure showbase(p: string);
    procedure prolog1;
    procedure prolog2;
    procedure prolog3;
    procedure prolog4;
    procedure prolog5;
    procedure razborinjs(v:string);
    function  findvstndbymid(dbmyid, ttg: integer): pvirtualnode;
    procedure showch(js:string);
    procedure showac(js:string);
    procedure showacerr(js:string);
    procedure currreread;
   // function  selfupd(s: string): string;
    function  yesno(s: string): boolean;
    function  fdeletend(vt: TLazVirtualStringTree; cnd: pvirtualnode): boolean;
    function  insretunr(tbn,s: string): tinsr;
    function  getlastmyid(tbn: string): integer;
    procedure checksubs;
    procedure checkbase;
    procedure showac_state(js:string);
    function  Inputsg(const Prompt: string; var Value: string): boolean;
    procedure alnewobject;
    procedure alnewsensor(cnd:pvirtualnode;flagoper:string);
    function  vstlocins(cnd:pvirtualnode;cf:tfillnd):pvirtualnode;
    procedure readingrp(cnd:pvirtualnode;bidport:string);
    function  formirlocinside(cnd:pvirtualnode;sl:tstringlist):pvirtualnode;
    function  fdelloc(cnd: pvirtualnode): boolean;
    procedure updateobj(cnd:pvirtualnode);
    procedure updatefloor(cnd:pvirtualnode);
    procedure formir_chstrart(cnd:pvirtualnode);
    procedure formir_chstop(cnd:pvirtualnode);
    function  findchckndtag(vt: TLazVirtualStringTree; ttg: integer): pvirtualnode;
    procedure updlocgrp(cnd:pvirtualnode;bpp,bidch:string) ;
    function  checklinkbploc(bploc: integer): boolean;
    function  getpnd(vt: TBaseVirtualTree; nd: pvirtualnode): pvirtualnode;
    function  formiremul(bpp,bpsens,bidch:string):tstringlist;
    function  myinsertr(tbn,s:string):tinsr;
    function  vaginsertr(tbn,s:string):tinsr;
    procedure showwriterlog(p: string; rc: integer);
    procedure showsens(sl:tstringlist);
    procedure showdms(p: string; rc: integer);
    procedure showcomcentr(p: string; rc: integer);
    procedure showsgrd(p: string; rc: integer);
    function   getidxsubsys(cn:string):integer;
    function  showsubsys(cn,prm:string):integer;
    procedure  formirjs_ac_mod(cnd: pvirtualnode; subcmd: string;sl:tstringlist);
    function  checklink(bidlocsens: integer): boolean;
    function  getbidsens(dbmyid:string):string;
    function  doJSON2SL(sJSON: String): TStringList;
    function  doSL2JSON(SL: TStringList): String;
    procedure linklocsenstousens(cnd:pvirtualnode);
    procedure playwav(pt:string);
    procedure showfindsens(ndl:pvirtualnode);
    procedure foncolvst(d:pvstrecord);
    function  jstosl(sJSON: String):string;
    procedure formirlocjs_todms(cnd: pvirtualnode; subcmd: string;sl:tstringlist);
    procedure doMIClr(ACanvas: TCanvas; ARect: TRect; sTxt: String);
    procedure addnewloc(cnd:pvirtualnode);
    procedure deleteingrp(cnd: pvirtualnode);
    function getacport(bidport:string):string;
    function get2rset(dl :pvstrecordloc;io:boolean):integer;
    function findndlocnm0tag(nm: string; tgg: integer): pvirtualnode;
    function findvstlocndbymid(dbmyid, ttg: integer): pvirtualnode;
    procedure showentryexit(sl:tstringlist;ttg:integer);
    procedure dumpbin;
    procedure restbin(fn:string);
    FUNCTION  calcdumpfile:string;
    procedure dumpsql;
    procedure pclearpasses;
    procedure ptmz;
    procedure updlocs(ndvst,ndl:pvirtualnode);
    function  aquacheck(myid,bidsens:string):boolean;
    function  aquacheckloc(myid,bidsens:string):boolean;
    function  getchonbpsens(bpsens:string):string;
    function  gethostparam:thostparam;
    procedure xshowch(sl: tstringlist);



  private

  public
        function  selfupd(s: string): string;

  end;

var
  Form1: TForm1;
  vhostparam:thostparam;
  vemuldata:temuldata;
  Fmqtt:boolean;
   subsysst :array[1..8] of tsubsysst;
  linkusens:tlinkusens ;
  substatus : tsubsysstatus ;
  currmtag: integer;
  fillnd   :tfillnd;

  countnotll:integer;
  flagprolog:boolean;
  ctrerr: int64;
  slappstatus,slmqtbox:tstringlist;
  trclientid:string;
  auzel: array of tsqlauzel;
  mfiltr:string;
  vglink:tglink;
  mysysinfo :tmysysinfo;
  app,appdir,appexe,ap,zp,myos:string;
  currnd,currndloc,firstnd,firstndloc:pvirtualnode;
  globalexit,fbroker:boolean;

implementation

{$R *.lfm}
uses  uallog,ualfunc,uwwcomp,uwwch,uwwac,uformhelp,uformalnewloc,ualnewlocsens,uformimportff,umars1,usyslog,uconfs,ulocm5,uloc2,uformvst2,uemul,
  upanmenu,ualgol,uformeditch,uformeditcomp,uformedittmz,uformlistpers;


{ TForm1 }


 
procedure Tform1.doMIClr(ACanvas: TCanvas; ARect: TRect; sTxt: String);
begin
  log('l','doMIClr DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');
  ACanvas.FillRect(ARect);
  ACanvas.TextOut(ARect.Left, ARect.Top, sTxt);
end;


function TForm1.fdeletend(vt: TLazVirtualStringTree; cnd: pvirtualnode
  ): boolean;
var
  Data: pvstrecord;
  dataloc: pvstrecordloc;
  nm, dbmyid, tbn, s: string;
  ttg: integer;

begin


  nm := vt.Name;
  log('y', 'fdeletend=' + vt.Name);
  if not yesno(
    '@@@@ Вы действительно хотите удалить узел и все дочерние элементы') then
    EXIT;
  log('m', 'nm=' + nm + '>');

  if nm = 'vstloc' then
  begin
    dataloc := vt.GetNodeData(cnd);
    dbmyid := IntToStr(dataloc^.dbmyid);
    ttg := dataloc^.tag;
    if ttg = 3 then tbn := 'tssloc_controls';
    if (ttg = 2) or (ttg = 3) then tbn := 'tssloc_locations';
    s := 'delete from ' + tbn + ' where myid=' + dbmyid;
    log('r', 'fdeletend s=' + s);
    form1.selfupd(s);
    //form1.titlenodeloc;
  end;
  if nm = 'vst' then
  begin
    Data := vt.GetNodeData(cnd);
    dbmyid := IntToStr(Data^.dbmyid);
    ttg := Data^.tag;
    if ttg = 2 then
    begin
      tbn := 'tss_acl';
      s := 'delete from ' + tbn + ' where myid=' + dbmyid;
      log('r', 'fdeletend s=' + s);
      form1.selfupd(s);
    end;

    if ttg = 1 then
    begin
      tbn := 'tss_ch';
      s := 'delete from ' + tbn + ' where myid=' + dbmyid;
      log('l', 'fdeletend s=' + s);
      form1.selfupd(s);
    end;
      if ttg = 0 then
    begin
      tbn := 'tss_comps';
      s := 'delete from ' + tbn + ' where myid=' + dbmyid;
      log('l', 'fdeletend s=' + s);
      form1.selfupd(s);
    end;


  end;

  vt.DeleteNode(cnd);
  vt.refresh;
  //log('l','fdeletend s='+s);

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

   // log('y', 'readfld=' + s);
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
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

function TForm1.getlastmyid(tbn: string): integer;
var
  qrz: TSQLQuery;
  s: string;
  n: integer;
begin
  try
    s := 'select myid from ' + tbn + ' order by myid desc limit 1';
    //log('y', 'gsel=' + s);
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(s);
    qrz.Active := True;
    Result := qrz.FieldByName('myid').AsInteger;
    vglink.qrx := qrz;
    exit;
  except
    on ee: Exception do
    begin
      log('e', 'getlastmyid ,ee=' + ee.Message);
      Result := -1;
    end;
  end;
end;




function TForm1.insretunr(tbn,s: string): tinsr;
var
  qrz: TSQLQuery;
  f:boolean;
  mid:string;
  rc:tinsr;
begin
  try
    Result.mes := 'ok';
    f:=false;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    selftr.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(' begin; ');
    qrz.SQL.Add(s + ' ;');
    qrz.SQL.Add(' commit;');
    qrz.Transaction := selftr;
    try
      qrz.ExecSQL;
      f:=true;
    except
     on e: Exception do
      begin
       selftr.Rollback;
       log('e', 'selinsreturn 1,e=' + e.Message);
     end;
    end;
    if f then selftr.Commit;
    //log('w', 'selfuppd AFTER COMMIT');
    result.myid:=getlastmyid(tbn);

  except
    on e: Exception do
    begin
      log('e', 'selfuppd,e=' + e.Message);
      Result.mes := e.Message;
    end;
  end;
  result:=rc;

end;

function TForm1.selfupd(s: string): string;
var
  qrz: TSQLQuery;
  f:boolean;
begin
  try
    Result := 'ok';
    f:=false;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    selftr.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(' begin; ');
    qrz.SQL.Add(s + ' ;');
    qrz.SQL.Add(' commit;');
    qrz.Transaction := selftr;
    try
      qrz.ExecSQL;
      f:=true;
    except
     on e: Exception do
      begin
       selftr.Rollback;
       log('e', 'selfuppd 1,e=' + e.Message);
       Result := e.Message;
       exit;
     end;
    end;
    if f then selftr.Commit;
    log('w', 'selfuppd AFTER COMMIT');
  except
    on e: Exception do
    begin
      log('e', 'selfuppd,e=' + e.Message);
      Result := e.Message;
    end;
  end;

end;

procedure TForm1.currrereadloc;
begin
  mfiltr := 'select distinct myid,bp,name,tag,sti,smrn,fckp,locinside,bidch,bidsens,loccode,code from tssloc_locations ' +
    'where tag<>3 ' + ' order by myid,bp';

  fillsqluzel;
  form1.showsqluzel;

end;

function TForm1.findj(i: integer): integer;
var
  k: integer;
begin
  Result := -1;
  for k := 0 to length(auzel) - 1 do
  begin
    if auzel[i].bp = auzel[k].myid then
    begin
      Result := k;
      log('l', 'findj=====================' + IntToStr(k));
      exit;
    end;
  end;
end;


function TForm1.getprmtag3(dl: pvstrecordloc): pvstrecordloc;
var
  bp, myid, fckp, ioflag, mpcl,ss: string;
  k, s: string;
  qrz: TSQLQuery;
  n,ci,co: integer;
  rc:umain.trcfld;


begin
  if dl^.tag <> 2 then
  begin
    Result := dl;
    exit;
  end;
  bp := IntToStr(dl^.dbmyid);
  s := 'select  max(mpcl) from tssloc_locations  where tag=3  and bp=' + bp;
  log('l', 's=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.DataBase := formglink.pqc1;
  qrz.SQL.Add(s);
  qrz.Active := True;
  mpcl := qrz.Fields[0].AsString;
  if mpcl = '' then mpcl := '0';
  dl^.mpcl := StrToInt(mpcl);
  ci:=get2rset(dl,true);
  co:=get2rset(dl,false);
  ss:=zp+'Ri='+INTTOSTR(ci)+zp+'Ro='+INTTOSTR(co);

  dl^.nm1 := 'id=' + IntToStr(dl^.dbmyid)+ss + ',CGS=' + mpcl + ',bp=' + IntToStr(dl^.bp);
  //suda0212
  log('l', '??????????? mpcl=' + mpcl);
  dl^.mpcl := StrToInt(mpcl);
  Result := dl;
  s := 'select NAME  from tssloc_locations  where tag=3  and bp=' +
    bp + '  order by loccode ';

end;


function TForm1.formirlocinside(cnd: pvirtualnode; sl: tstringlist
  ): pvirtualnode;
var
    cf:tfillnd;
begin
         //  showmessage('formirlocinside sl='+sl.text);
         cf.place:='first';
         cf.sti:=strtoint(sl.Values['sti']);
         cf.sti1:=strtoint(sl.Values['sti1']);
         cf.tag:=strtoint(sl.Values['tag']);
         cf.nm0:=sl.Values['nm0'];
         cf.ndcheck:=sl.Values['ndcheck'];
         cf.ndcheck_state:=sl.Values['ndcheck_state'];
         result:=form1.vstlocins(cnd,cf);
end;

procedure TForm1.showsqluzel;
var
  dl: pvstrecordloc;
  i, j,X: integer;
  ndn: pvirtualnode;
  sl: TStringList;
  cf:tfillnd;
  cnd:pvirtualnode;
begin
 TRY
   X:=0;
     form1.log('r', 'showsqluzel x='+inttostr(x));
  sl := TStringList.Create;

  for i := 0 to length(auzel) - 1 do
  begin

    x:=10;
    sl.Values['nm0'] := auzel[i].Name;
    sl.Values['sens']:= auzel[i].sens;

    sl.Values['tag'] := IntToStr(auzel[i].tag);
    sl.Values['sti'] := IntToStr(auzel[i].sti);
    sl.Values['code'] := IntToStr(auzel[i].code);

    sl.Values['smrn'] := auzel[i].smrn;
    sl.Values['fckps'] := auzel[i].fckps;
    sl.Values['sti1'] := '-1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    //showmessage('showsqluzel 3');
    j := findj(i);
    X:=1;
    //form1.log('c', 'showsqluzel x='+inttostr(x));
    //showmessage('showsqluzel 4');
    if j = -1 then cnd := nil
    else
      cnd:= auzel[j].pnd;

      sl.values['bpp']:='-1';
      sl.values['smrn']:='-1';
      //showmessage('showsqluzel 5,sl='+sl.text);

    if auzel[i].locinside=false then ndn := form1.fnnloc(cnd, sl);
    if auzel[i].locinside=true  then begin
     ndn:= form1.formirlocinside(cnd,sl) //sudalocinside
    end;
    //showmessage('showsqluzel 6');
    X:=2;
    //form1.log('r', 'showsqluzel x='+inttostr(x));
    auzel[i].pnd := ndn;
    //showmessage('showsqluzel 7');
    dl := vstloc.GetNodeData(ndn);
    dl^.dbmyid := auzel[i].myid;
    dl^.sti := auzel[i].sti;
    dl^.tag := auzel[i].tag;
    dl^.bidch:=auzel[i].bidch;
    dl^.bpsens:=auzel[i].bpsens;
    dl^.loccode:=auzel[i].loccode;
    dl^.sens:=auzel[i].sens;
    dl^.code:=strtoint(sl.Values['code']);
    X:=3;
    //form1.log('c', 'showsqluzel x='+inttostr(x));
    dl^.fckps:=sl.Values['fckps'];
    if  dl^.fckps='False' then dl^.fckp:=false;
    if dl^.fckps='True'   then begin
     dl^.fckp:=true;
     log('l','nm0='+dl^.nm0+' fckp='+dl^.fckps) ;
     //showmessage(dl^.nm0);
    end;

    dl^.sti1 := -1;
    dl^.bp := auzel[i].bp;
    dl := getprmtag3(dl);
    X:=4;
    //form1.log('r', 'showsqluzel x='+inttostr(x));
    // currndloc:=ndn;
  end;
  except
    on e: Exception do
    begin
      //showmessage('showsqluzel x='+inttostr(x));
      form1.log('e', 'showsqluzel,e=' + e.message + ' /X=' + IntToStr(X));
    end;
  end;
end;


procedure TForm1.read_acl(ndc: pvirtualnode);
var
  Data, dataold: pvstrecord;
  nd, ndp: pvirtualnode;
  s, comp, ac, ch, x: string;
  sl: TStringList;
  qrx: TSQLQuery;
  acts: string;
  bidch:integer;
  act:boolean;
begin
  dataold := vst.GetNodeData(ndc);
  comp := dataold^.comp;
  ch := dataold^.ch;
  bidch:=dataold^.dbmyid;


  s := 'select * from tss_acl  where bp=' + IntToStr(bidch);
  log('l', 's=' + s);
  log('l', 's=' + s);
 // SHOWMESSAGE('ACl='+s);

  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  sl := TStringList.Create;
  while not qrx.EOF do
  begin
    //  x:=qrx.Fields.Fields[0].AsString;
    // showmessage('x='+x);
    ac := qrx.FieldByName('ac').AsString;
    //SHOWMESSAGE('AC='+ac);
    log('y', 'read_acl=' + ac);
    sl.Values['nm0'] := qrx.FieldByName('ac').AsString;
    sl.Values['ctyp'] := qrx.FieldByName('ctyp').AsString;
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['actual'] := qrx.FieldByName('actual').AsString;
    acts := qrx.FieldByName('actual').Asstring;
    act  := qrx.FieldByName('actual').AsBoolean;
    sl.Values['nm1'] := 'actual=' + sl.Values['actual'] +zp+
      'ctyp=' + sl.Values['ctyp'];
   // s := sl.Values['nm1'] + ',' + sl.Values['actual'];
    sl.Values['sti'] := '41';
    sl.Values['sti1'] := '-1';
    sl.Values['tag'] := '2';
    sl.Values['ndcheck'] := 'y';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnn(ndc, sl);

    Data := vst.GetNodeData(nd);
    Data^.ctyp := sl.Values['ctyp'];
    Data^.bp := dataold^.dbmyid;
    Data^.dbmyid := StrToInt(sl.Values['myid']);
    Data^.comp := comp;
    Data^.ch := ch;
    Data := fidkomu(Data);
    Data^.ac := sl.Values['nm0'];
    data^.bidch:=bidch;
    data^.act:=act;
    //showmessage('bidch='+inttostr(bidch));

    VST.Expanded[ndc] := True;
   // log('c', 'sl=' + sl.Text);
    read_ports(nd);
    qrx.Next;
    sl.Clear;
  end;

end;


function TForm1.getmarsforports(myid: integer): integer;
var
  s: string;
  qrx: TSQLQuery;
begin
  s := 'select  m.mrn  from tss_ports as p,' + ' tss_marsrut  as m ' +
    ' where m.bpport =' + IntToStr(myid);

  // log('c','s='+s);
  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  Result := qrx.Fields[0].AsInteger;
  if (Result > 0) then
  begin
    log('w', 'result=' + IntToStr(Result));
    //showmessage(s);
  end;

end;



procedure TForm1.read_sensors(ndp: pvirtualnode);
var
  Data, dataold: pvstrecord;
  nd, pnd: pvirtualnode;
  nump, s, comp, ch, ac, port, sensor, sti: string;
  sl: TStringList;
  qrx: TSQLQuery;
  llink:string;
  att:boolean;
  bidch,bidac:integer;
begin
  dataold := vst.GetNodeData(ndp);
  comp := dataold^.comp;
  ch := dataold^.ch;
  ac := dataold^.ac;
  port := dataold^.port;
  ch := dataold^.ch;
  bidch:= dataold^.bidch;
  bidac:= dataold^.bidac;
  s := 'select * from tss_sensors  where bp=' + IntToStr(dataold^.dbmyid) + ' order by code';
  log('l', 's=' + s);
  // showmessage('s='+s);
  qrx := TSQLQuery.Create(self);
  qrx.SQL.Clear;
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  sl := TStringList.Create;
  while not qrx.EOF do
  begin
    att:=false;
    sl.Values['sti'] := qrx.FieldByName('sti').AsString;
    sl.Values['nm0'] := qrx.FieldByName('name').AsString;
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['actual'] := qrx.FieldByName('ignore').AsString;
    sl.Values['bp'] := qrx.FieldByName('bp').AsString;
    sl.Values['bploc'] := qrx.FieldByName('bploc').AsString;
    llink:=' ';
    if sl.Values['bploc']='-1' then begin
     llink:=''; //    'нет связи';
     att:=true;
     countnotll:=countnotll+1;
    end;
 //   if  (strtoint(sl.Values['bploc'])>0) and checklinkbploc(strtoint(sl.Values['bploc'])) then llink:=' связь есть!' ;
    llink:='';
    sl.Values['nm1'] :='myid='+ sl.Values['myid']+zp+'bploc='+sl.Values['bploc'];
    s := sl.Values['nm1'] + ',' + sl.Values['actual'];
    sl.Values['sti'] := '-1';
    sl.Values['sti1'] := '-1';
    sl.Values['tag'] := '4';
    sl.Values['ndcheck'] := 'y';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnn(ndp, sl);
    Data := vst.GetNodeData(nd);
    data^.nm1:=sl.Values['nm1'];


    if nd <> nil then
    begin
      //log ('l','read_sensor myid='+sl.Values['myid']);
      Data := vst.GetNodeData(nd);
      Data^.dbmyid := StrToInt(sl.Values['myid']);
      Data^.bploc := StrToInt(sl.Values['bploc']);
      Data^.bp := StrToInt(sl.Values['bp']);
      Data^.comp := comp;
      Data^.ch := ch;
      Data^.ac := ac;
      Data^.port := port;
      Data^.bidch := bidch;
      Data^.bidac := bidac;
      Data^.sensor := sl.Values['nm0'];
      if att then data^.atention:=true;
      Data := fidkomu(Data);


    end;
    qrx.Next;
    sl.Clear;
  end;

end;



procedure TForm1.read_ports(ndc: pvirtualnode);
var
  Data, dataold: pvstrecord;
  nd, pnd: pvirtualnode;
  nump, s, comp, ch, ac, port: string;
  sl: TStringList;
  qrx: TSQLQuery;
  mrn,bidch,bidac: integer;
begin

  dataold := vst.GetNodeData(ndc);
  comp := dataold^.comp;
  ch := dataold^.ch;
  ac := dataold^.ac;
  bidac:=dataold^.dbmyid;
  bidch := dataold^.bidch;
  s := 'select * from tss_ports  where bp=' + IntToStr(dataold^.dbmyid) + ' order by nump';
  //log('l','s='+s);
  //showmessage('s='+s);
  qrx := TSQLQuery.Create(self);
  qrx.SQL.Clear;
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  sl := TStringList.Create;
  while not qrx.EOF do
  begin
    nump := qrx.FieldByName('nump').AsString;
    //log('y','read_ports='+ac);
    sl.Values['nm0'] := qrx.FieldByName('nump').AsString;
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['actual'] := qrx.FieldByName('actual').AsString;
    sl.Values['nm1'] := 'port of ACS controller';
    s := sl.Values['nm1'] + ',' + sl.Values['actual'];
    sl.Values['sti'] := '-1';
    sl.Values['sti1'] := '-1';
    sl.Values['tag'] := '3';
    sl.Values['ndcheck'] := 'y';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnn(ndc, sl);
    Data := vst.GetNodeData(nd);
    Data^.dbmyid := StrToInt(sl.Values['myid']);
    Data^.bp := dataold^.dbmyid;
    mrn := form1.getmarsforports(StrToInt(sl.Values['myid']));
    Data^.mrn := mrn;
    Data^.comp := comp;
    Data^.port := sl.Values['nm0'];
    Data^.ch := ch;
    Data^.ac := ac;
    Data^.bidch := bidch;
    Data^.bidac := bidac;
    Data := fidkomu(Data);

    Data^.nm1 :='id='+sl.Values['myid'];
    // showmessage('readports='+inttostr(data^.dbmyid));
    // log('r','read_ports-dbmyid='+inttostr(data^.dbmyid));
    // showmessage('dbmyid='+inttostr( data^.dbmyid));
    //VST.Expanded[ndc]:=true;
    //log('c','sl='+sl.text);
    read_sensors(nd);
    qrx.Next;
    sl.Clear;
  end;

  //titlenode;
  //reread;

end;




procedure TForm1.showbase(p: string);
var
  d: pvstrecord;
  nd: pvirtualnode;
  pn:tpanel;
begin
      // log('y','showbase ???????? p='+p);
      pn:=findcomponent('p_databases') as tpanel;
      if P='pgconnect' then begin
       pn.Color:=cllime;
       pn.font.color:=clblack;
      end;
      if p='pgerror' then begin
       pn.Color:=clred;
       pn.font.color:=clblack;
      end;
 end;


procedure TForm1.showsens(sl:tstringlist);
var
  d: pvstrecord;
  nd,ndp,ndac: pvirtualnode;
  bidsens,ct,nm0:string;
begin
  //log('c','showsensl='+sl.text);
  //showmessage(sl.text);
  bidsens:=sl.Values['bidsens'];
  nd:= findvstndbymid(strtoint(sl.Values['bidsens']),4);
 // nd:= findvstndbymid(653,4);
  if nd = nil then
  begin
    log('r', 'showsens nd=NIL');
    EXIT;
  end;
   eevx.text:=sl.values['sens']+zp+'ac='+sl.Values['ac']+zp+'port='+sl.Values['port']+zp+'bidsens='+bidsens+zp+'kluch='+sl.Values['kluch'];
   eevx.Text:=eevx.text+zp+datetimetostr(now);
  d := vst.GetNodeData(nd);
  if not d^.chkstate then begin
    log('y','showsens NOTCHECKSTATE sens='+sl.values['sens']+', ac='+sl.Values['ac']+',port='+sl.Values['port']+',bidsens='+sl.Values['bidsens']);
    EXIT;

  end;
  nm0:=d^.NM0;

  log('w','bidsens========'+sl.Values['bidsens']);
  log('y','showsens sens='+eevx.text);

  umain.substatus.lmqtt:=dateutils.DateTimeToUnix(now,false);

   if sl.Values['sens']=nm0 then begin
    // log('c','tut 1 ??????????????????????????????????????????????????????????????????????');
    if mysysinfo.mode='config' then  begin
    log('c','tut 2222222222222222222222222222222222222222222222222222222222222222222222222');
     ct:=timetostr(time);
     d^.nm1:= sl.Values['sens']+zp+'ac='+sl.Values['ac']+zp+'port='+sl.Values['port']+zp+ct+zp+'kluch='+sl.Values['kluch'] ;
     d^.sti := 33;                   ;
     ndp:=d^.ndp;
     d:=vst.GetNodeData(ndp);
     ndac:=d^.ndp;
     VST.Expanded[ndp] := True;
     VST.Expanded[ndac] := True;
     log('w','tut ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
     vst.refresh;
    // d^.nm1 := 'Работает ' + datetimetostr(now);
  end;
 end;
end;


procedure TForm1.showsgrd(p: string; rc: integer);
var
  d: pvstrecord;
  nd: pvirtualnode;
  pn:tpanel;
begin

end;


procedure TForm1.showdms(p: string; rc: integer);
var
  d: pvstrecord;
  nd: pvirtualnode;
  pn:tpanel;
jb,jbx:TJSONObject;
jd,jdx,jdy:tjsondata;
cmd,regim:string;

begin
   //showmessage('p='+p);
   showsubsys('p_dms',p);

end;

procedure TForm1.showcomcentr(p: string; rc: integer);
var
  d: pvstrecord;
  nd: pvirtualnode;
  pn:tpanel;
begin
   showsubsys('p_comcentr',p);

  exit;

end;

procedure TForm1.showwriterlog(p: string; rc: integer);
var
  d: pvstrecord;
  nd: pvirtualnode;
  pn:tpanel;
begin
   showsubsys('p_writerlog',p);


  end;


function tform1.showsubsys(cn,prm:string):integer;
var
  p:integer;
  pn:tpanel;
  i:integer;
  sl:tstringlist;
  jb,jbx:TJSONObject;
  jd,jdx,jdy:tjsondata;
  cmd,cmdsl,REGIM,subcmd,pid:string;

begin
      jd:=GETJSON(prm);

      jb:=tjsonobject(jd);

      try REGIM:=jb.Get('regim'); except end;
      try pid:=trim(jb.Get('pid')); except end;

      // log('w','showsubsys  cn='+cn+' /prm='+prm);
       i:=form1.getidxsubsys(cn);
       subsysst[i].luxt:=dateutils.DateTimeToUnix(now,false);
       if pid<>'' then subsysst[i].pid:=pid;
       pn:=findcomponent(cn) as tpanel;
       if pn.Name='p_dms' then  pn.caption:='DMS '+regim+zp+pid;
       pn.Color:=cllime;
       pn.font.color:=clblack;
       jb.Free;
end;

procedure TForm1.showtr(p: string; rc: integer);
var
  i:integer;
  d: pvstrecord;
  nd: pvirtualnode;
  pn:tpanel;
begin

  // showmessage('showtr p='+p);
 // log('l','showtr==========================================================='+p);

   //pn:=findcomponent('p_transport') as tpanel;
   //pn.Color:=cllime;
   //pn.font.color:=clblack;

  //showsubsys('p_transport');
  // EXIT;

   if fmqtt then   begin
    p_transport.Color:=cllime;
    p_transport.font.Color:=clblack;
   end
   else begin
    p_transport.Color:=clred;
    p_transport.font.Color:=clblack;
   end;

   EXIT;

  d := vst.GetNodeData(nd);
  umain.substatus.lmqtt:=dateutils.DateTimeToUnix(now,false);
       //dlmqtt:=abs(uxt-umain.substatus.lmqtt);

  d^.nm1 := p + '   ' + timetostr(time);
  if p = 'mqttdisconnect' then
  begin

    d^.sti := 44;
    d^.nm1 := 'Проблемы ' + datetimetostr(now)+',adr='+mysysinfo.traddr;
  end;

  if p = 'mqttconnect' then
  begin
    d^.sti := 42;
    d^.nm1 := 'Работает ' + datetimetostr(now)+',adr='+mysysinfo.traddr;
  end;

end;




procedure TForm1.reread;
begin
  countnotll:=0;
  //form1.formirndstarter(firstnd);
  read_comps;
   if countnotll>0 then begin
   // panrunits.Color:=clyellow;
    //showmessage('Обнаружено '+inttostr(countnotll)+' сенсоров без связи с локациями');

  end
   else begin
     //panrunits.Color:=cllime;
   end;

end;

procedure TForm1.formirndstarter(ndc: pvirtualnode);
var
  nd: pvirtualnode;
  d: pvstrecord;
  qrz: TSQLQuery;
  s, nmapp, ttg, spath,ptf: string;
  n: integer;
  sl: TStringList;
begin
  try


    //showmessage('formirndstarter START');
    sl := TStringList.Create;
    s := 'select * from starter ';
    log('y', 'formirnodeapp=' + s);
    qrz := TSQLQuery.Create(self);
    qrz := formstarter.getqrz(s);
    while not qrz.EOF do
    begin
      nmapp := trim(qrz.FieldByName('app').AsString);
      spath := qrz.FieldByName('adrpath').AsString;
      ttg := qrz.FieldByName('tag').AsString;
      sl.Values['nm0'] := nmapp;
      sl.Values['sti'] := '43';
      sl.Values['sti1'] := '-1';
      sl.Values['tag'] := ttg;
      sl.Values['ndcheck'] := 'n';
      sl.Values['ndcheck_state'] := 'n';
      nd := fnn(ndc, sl);
      d := vst.GetNodeData(nd);
      d^.tag := StrToInt(ttg);
      d^.path := spath;
      d^.nm1 := spath;
     {
      if nmapp='comcentr' then begin
       ptf:='python3 '+appdir+'/alpy/'+spath ;
       log('w','ptf='+ptf);
       log('w','ptf='+ptf);
       log('w','ptf='+ptf);
       ualfunc.vagoloapprun(ptf);
      end;
     }
      qrz.Next;
    end;

  finally
  end;


end;


function TForm1.findndnm0tag(nm: string; tgg: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecord;
begin
  // form1.log('y','start findndofnm0 1 NM1='+nm0+'>');
  try
    Result := nil;
    nm:=ualfunc.trim(nm);
    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := vst.getfirst(True);
    Data := vst.getnodedata(nd);
    Result := nil;
    while True do
    begin

      nd := vst.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vst.getnodedata(nd);
      //log('c','findndofnm0tag.nm0='+data^.nm0+'>'+',nm='+nm);
      if trim(Data^.nm0) = nm then
      begin
        Result := nd;
        //log('l','findndofnm0tag FOUND FOUND ='+data^.nm0+' /nm='+nm);
        exit;
      end;
    end;
    //ShowMessage('nm=' + nm);
    //form1.log('y', 'findndof not found nm=' + nm);
    exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndof,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;



function TForm1.findndlocnm0tag(nm: string; tgg: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecordloc;
begin
  // form1.log('y','start findndofnm0 1 NM1='+nm0+'>');
  try
    Result := nil;
    nm:=ualfunc.trim(nm);
    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := vstloc.getfirst(True);
    Data := vstloc.getnodedata(nd);
    Result := nil;
    while True do
    begin
      //application.ProcessMessages;
      nd := vstloc.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vstloc.getnodedata(nd);
      //log('c','findndofnm0tag.nm0='+data^.nm0+'>'+',nm='+nm);
      if trim(Data^.nm0) = nm then
      begin
        Result := nd;
        //log('l','findndofnm0tag FOUND FOUND ='+data^.nm0+' /nm='+nm);
        exit;
      end;
    end;
    //ShowMessage('nm=' + nm);
    //form1.log('y', 'findndof not found nm=' + nm);
    exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndlocnm0tag,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;





function TForm1.fidkomu(Data: pvstrecord): pvstrecord;
var
  comp, ch, s: string;
begin
  comp := Data^.comp;
  ch := Data^.ch;
  //   komu:=mysysinfo.computername+'#drv209_'+data^.nm0;
  Data^.idkomu := comp + '#drv209_' + ch;
  Result := Data;

end;


procedure TForm1.read_ch(bpbid: integer; ndc: pvirtualnode);
var
  Data, dataold: pvstrecord;
  nd, pnd: pvirtualnode;
  s, comp, ch: string;
  sl: TStringList;
  qrx: TSQLQuery;
  act: boolean;
  acts: string;
begin
  dataold := vst.GetNodeData(ndc);
  comp := dataold^.nm0;
  s := 'select * from tss_ch where bp=' + IntToStr(bpbid);
  log('l', 's=' + s);
  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  sl := TStringList.Create;
  while not qrx.EOF do
  begin
    ch := qrx.FieldByName('ch').AsString;
    //log('r','ch='+ch);
    sl.Values['nm0'] := qrx.FieldByName('ch').AsString;
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['chtype'] := qrx.FieldByName('chtype').AsString;
    s := sl.Values['nm1'] + ',' + sl.Values['actual'];
    act := qrx.FieldByName('actual').AsBoolean;
    acts := qrx.FieldByName('actual').AsString;
    sl.Values['nm1'] := 'actual=' + acts + ',channel=' + sl.Values['chtype'];
   // if act=true then  sl.Values['sti'] := '31'else sl.Values['sti']:='41';
    sl.Values['sti'] :='41';
    sl.Values['sti1'] :='-1';
    sl.Values['tag'] := '1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnn(ndc, sl);

    Data := vst.GetNodeData(nd);
    Data^.dbmyid := StrToInt(sl.Values['myid']);
    Data^.bp := dataold^.dbmyid;
    Data^.act := act;
    Data^.comp := comp;
    Data^.ch := sl.Values['nm0'];
    Data := fidkomu(Data);
    Data^.chtype := sl.Values['chtype'];
    VST.Expanded[ndc] := True;
    log('c', 'sl=' + sl.Text);
    read_acl(nd);
    qrx.Next;
    sl.Clear;
  end;

end;



procedure TForm1.read_comps;
var
  Data, datandp: pvstrecord;
  nd, ndp: pvirtualnode;
  s, nm,url: string;
  sl: TStringList;
  act: boolean;
begin

  s := 'select * from tss_comps';
  formglink.gsel(s);
  sl := TStringList.Create;
  vglink.qrx.First;
  while not vglink.qrx.EOF do
  begin
    nm := vglink.qrx.FieldByName('name').AsString;
    sl.Values['url'] := vglink.qrx.FieldByName('url').AsString;
    sl.Values['nm0'] := vglink.qrx.FieldByName('name').AsString;
    sl.Values['myid'] := vglink.qrx.FieldByName('myid').AsString;
    sl.Values['actual'] := vglink.qrx.FieldByName('actual').AsString;
    act := vglink.qrx.FieldByName('actual').AsBoolean;
    sl.Values['nm1'] := vglink.qrx.FieldByName('url').AsString;
    s := sl.Values['nm1'] + ',' + sl.Values['actual'];
    sl.Values['sti'] := '-1';
    sl.Values['sti1'] := '-1';
    sl.Values['tag'] := '0';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    firstnd := vst.getfirst(True);

    //formirndstarter(firstnd);  //SUDABEDA
    nd := form1.fnn(firstnd, sl);

    Data := vst.GetNodeData(nd);
    ndp := Data^.ndp;
    datandp := vst.GetNodeData(ndp);
    Data^.bp := datandp^.dbmyid;
    data^.host:=sl.Values['nm1'];
    Data^.dbmyid := StrToInt(sl.Values['myid']);
    VST.Expanded[firstnd] := True;
    Data^.act := act;
    //log('r','myid='+sl.Values['myid']);
    nd := form1.findndnm0tag(sl.Values['nm0'], 0);
    // data:=vst.GetNodeData(nd);

    Data^.bp := Data^.dbmyid;

    read_ch(StrToInt(sl.Values['myid']), nd);
    //end;
    vglink.qrx.Next;

  end;
  sl.Free;

end;


function TForm1.fnnloc(ndo: PVirtualNode; sl: TStringList): PVirtualNode;
var
  ndn: PVirtualNode;
  Data: PVSTRecordloc;
  nm, s: string;
  i, n: integer;
begin
  n := 0;
  //(amNoWhere, amInsertBefore, amInsertAfter, amAddChildFirst, amAddChildLast)
  try
    //VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions+[toCheckSupport];
    ndn := vstloc.AddChild(ndo);
    //ndn:=vstloc.InsertNode(ndo,amInsertAfter,nil);
    //  tvtnodeattachmode
    // log('y','AFTER ADDCHILD ');
    if sl.Values['ndcheck'] = 'y' then
    begin
      ndn^.CheckType := ctTriStateCheckBox;
      if sl.Values['ndcheck_state'] = 'y' then
        vst.CheckState[ndn] := cscheckedNormal;
      if sl.Values['ndcheck_state'] <> 'n' then
        vst.CheckState[ndn] := csUncheckedNormal;
      //vst.CheckState[ndn]:= csUncheckedNormal;
      n := 1;
      if not (vsInitialized in ndn^.States) then  VSTloc.ReinitNode(ndn, False);
      ndn^.CheckType := ctCheckBox;
      //Data := VST.GetNodeData(ndn);
    end;

   // SHOWMESSAGE('FNNLOC   1');
    if ndn = nil then
    begin
      ShowMessage('TUT NIL');
      exit;
    end;
    n := 2;
     //  SHOWMESSAGE('FNNLOC   2');
    Data := vstloc.GetNodeData(ndn);
    //Data^.abi := vstloc.AbsoluteIndex(ndn)
   except
    on ee:exception DO BEGIN
     log('e','fnloc n='+inttostr(n)+' / eee='+ee.Message);
   end;
  end;
         //LOG('y','fnnloc ##1') ;
  Data^.ndp := ndo;
  Data^.nm0 := sl.Values['nm0'];
  Data^.sti := StrToInt(sl.Values['sti']);
     //LOG('y','fnnloc ##2') ;
  n := 3;
  //log('m','n='+inttostr(n));
  // log('m','n='+inttostr(n)+' /sti1='+sl.Values['sti1']);
  Data^.sti1 := StrToInt(sl.Values['sti1']);
       //LOG('y','fnnloc ##3') ;
  n := 4;
     //SHOWMESSAGE('FNNLOC   4');
  Data^.tag := StrToInt(sl.Values['tag']);
  //LOG('y','fnnloc after tag') ;
  //log('m','n='+inttostr(n));
  // SHOWMESSAGE('FNNLOC NEW TAG='+INTTOSTR(data^.tag)+' stag='+sl.Values['tag']);
  n := 5;
  try
       //SHOWMESSAGE('FNNLOC   6');
    Data^.smrn := sl.Values['smrn'];

  except
    Data^.smrn := '-1';
  end;
     //SHOWMESSAGE('FNNLOC   7');
  try
      Data^.dbmyid := StrToInt(sl.Values['bpp']);
        //LOG('y','fnnloc ##4') ;
  except
    Data^.dbmyid := -1;
  end;
  n := 9;
  //LOG('y','fnnloc ##5') ;
  Data^.nm0 := sl.Values['nm0'];
  Data^.nm1 := sl.Values['nm1'];
  Data^.nm2 := sl.Values['nm2'];
     //SHOWMESSAGE('FNNLOC   9');
  //Data^.nm3 := sl.Values['nm3'];
  //Data^.nm4 := sl.Values['nm4'];
  //log('w', 'fnnloc. n=' + IntToStr(n));
  vstloc.Refresh;
  Result := ndn;
 // LOG('y','fnnloc ###########################################3333') ;


end;


procedure TForm1.read_locations;
var
  dataloc: pvstrecordloc;
  nd, pnd: pvirtualnode;
  s, nm: string;
  sl: TStringList;
begin
  log('w', 'read_locations START');

  exit;
  //prdp; suda ?

  //vstloc.Refresh;
  exit;

end;

procedure TForm1.rereadloc;
begin
  read_locations;
end;


procedure TForm1.titlenodeloc;
var
  sl: TStringList;
  i: integer;
begin
  try
    //log('c', 'titlenodeloc start  ?????????????????????????????????????????????');
    //vstloc.Clear;
    sl := TStringList.Create;
    i := 1;
    sl.Values['nm0'] := 'ДЕРЕВО ЛОКАЦИЙ ';
    //sl.Values['nm1']:='BASE postgreS='+VGLINK.state;
    sl.Values['sti'] := '-1';
    sl.Values['sti1'] := '-1';
    sl.Values['tag'] := '-1';
    sl.Values['bpp'] := '-1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    i := 2;
    firstndloc := fnnloc(nil, sl);
    //log('c', 'titlenodeloc start  2');
   // VSTLOC.Refresh;
    i := 3;
    //log('m', 'titlenodeloc call rereadloc');
   // rereadloc;
   //   log('c', 'titlenodeloc start  3');
  except
    on e: Exception do
    begin
      log('e', 'titlenodeloc,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
 //  log('w', 'titlenodeloc ended eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
end;


procedure TForm1.fillsqluzel;
var
  Data: pvstrecord;
  s,ss: string;
  nd, pnd: pvirtualnode;
  I, l: integer;
  qrz: TSQLQuery;
begin
  log('c', 'fillsqluzel START');
 // SHOWMESSAGE('fillsqluzel START');
  s := mfiltr;
  log('l', 'MFILTR=' + MFILTR);

  qrz := TSQLQuery.Create(self);
  qrz := formglink.gselqr(s);
  i := 0;
  SetLength(auzel, 0);
  vstloc.Clear;
  if qrz.RecordCount=0 then begin
   forhelp.top:=0;
   forhelp.Left:=0;
   forhelp.show;

  end;
try
  while not qrz.EOF do
  begin
    l := length(auzel);
    SetLength(auzel, l + 1);
    auzel[i].Name := qrz.FieldByName('name').AsString;
    ss := qrz.FieldByName('name').AsString;
    auzel[i].sens := ualfunc.ExtractStr(1,ss,'_');
    auzel[i].myid := qrz.FieldByName('myid').AsInteger;
    auzel[i].bp   := qrz.FieldByName('bp').AsInteger;
    auzel[i].tag  := qrz.FieldByName('tag').AsInteger;
    auzel[i].sti  := qrz.FieldByName('sti').AsInteger;
    auzel[i].smrn := qrz.FieldByName('smrn').AsString;
    auzel[i].fckp := qrz.FieldByName('fckp').Asboolean;
    auzel[i].bidch:= qrz.FieldByName('bidch').Asinteger;
    auzel[i].bpsens:= qrz.FieldByName('bidsens').Asinteger;
    auzel[i].loccode:= qrz.FieldByName('loccode').Asinteger;
    auzel[i].code:= qrz.FieldByName('code').Asinteger;

    auzel[i].locinside := qrz.FieldByName('locinside').Asboolean;
   // showmessage('fcp='+booltostr(auzel[i].fckp));
    auzel[i].fckps := qrz.FieldByName('fckp').Asstring;
    auzel[i].pnd  := nil;
    log('w', 'fillsqluzel.name=' + auzel[i].Name);
    log('r', 'fillsqluzel.name=' + auzel[i].Name);
   // SHOWMESSAGE('NAME='+auzel[i].Name);
    qrz.Next;
    i := i + 1;
  end;
 except
    on e: Exception do
    begin
      log('e', 'fillsqluzel,e=' + e.message);
    end;
  end;

  qrz.Free;
end;



procedure TForm1.prolog5;
var
  i:integer;
begin

     titlenodeloc;
     fillsqluzel;
     showsqluzel;
     timer1s.Enabled:=true;
     timer5s.Enabled:=true;
     timerinmqtt.Enabled:=true;
     timerchecks.Enabled:=true;

end;


procedure TForm1.prolog4;
var
  i:integer;
begin


     dmmqt.gconnect(umain.trclientid,mysysinfo.traddr);
     ualfunc.MyDelay(500);
     prolog5;

     dmmqt.gsubscr('maldms');
     dmmqt.gsubscr('tomain');
    // showmessage('ip='+mysysinfo.traddr);
    // ualfunc.MyDelay(1000);
     //timer1s.Enabled:=true;

end;

procedure TForm1.prolog3;
var
  i:integer;
begin
       {
  for i:=1 to 11 do begin
   if not assigned(formglink) then begin
     ualfunc.MyDelay(100);
   end
   else begin
       break;
      end;
     end;
  }
     formglink.xgconnect(vglink);
     titlenode;
     reread;
     prolog4;

 end;

procedure TForm1.prolog2;
var
  i:integer;
begin



  for i:=1 to 11 do begin
   if not assigned(formstarter) then begin
     ualfunc.MyDelay(100);
   end
   else begin
       break;
      end;
     end;

      //showmessage('prolog2 start');
      formstarter.openstarter;
      formstarter.rereadstarter;

      log('c','umain.mysysinfo.baseaddr='+umain.mysysinfo.baseaddr);
      log('c','umain.mysysinfo.basename='+umain.mysysinfo.basename);
      log('c','umain.mysysinfo.baspsw ='+umain.mysysinfo.basepsw);

      prolog3;




end;


function tform1.getidxsubsys(cn:string):integer;
var
  i:integer;
begin
      result:=-1;
      for i:=1 to length(subsysst) do begin
       if cn=subsysst[i].cn then begin
        result:=i;
        exit;
       end;
      end;

 end;

procedure TForm1.prolog1;
var
  D,FileDateTime,S,cn:STRING;
  i,size:integer;
  buffer: array[0..255] of char;
begin;

TIMERSTART.Enabled:=FALSE;
TIMER1S.Enabled:=FALSE;
mysysinfo.mode:='work';
  d:=ualfunc.ZZdate(datetostr(now));
  for i:=1 to 11 do begin
   if not assigned(formallog) then begin
     ualfunc.MyDelay(100);
   end
   else begin
       break;
      end;
     end;

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

  appDir     := ExtractFilePath(FORMS.Application.ExeName);
  appExe     := ExtractFileName(FORMS.Application.ExeName);
  app        := ualfunc.ExtractStr(1,appexe,'.');
  form1.WindowState:=wsnormal;
  form1.show;
  //form1.WindowState:=wsmaximized;
 formallog.WindowState:=wsmaximized;
  formallog.show;
  form1.BringToFront;
  gethostparam;
  cn:=vhostparam.comp;
 ;
      cn:=lowercase(cn);
      trclientid := cn + '.' + app;
      trclientid := LOWERCASE(trclientid);
      mysysinfo.trclientid:=trclientid;
      mysysinfo.computername:=cn;
      mysysinfo.username:=GetEnvironmentVariable('USERNAME');
      //showmessage('trcli='+trclientid+' /username='+mysysinfo.username);




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


  //showmessage('app='+app);




  FileDateTime := FormatDateTime('YYYY.MM.DD hh:mm:ss', FileDateToDateTime(FileAge(appExe)));
  s:='APP='+appexe +' VERSION='+filedatetime+' APPDIR='+APPDIR+app;
   caption:=S;
  log('l','END OF PROLOG1 11111111111111111111111111111111111111111111111111111111');


  prolog2;


END;



procedure TForm1.prolog;
var
   cn,d,FileDateTime,lint,s,s2:string;
   sl:tstringlist;
   i,l,n,w:integer;
begin
{$IFDEF linux}
 myos:='linux';
{$ENDIF}

      showmessage('prolog start NEW myos='+myos);
      EXIT;
      TIMERSTART.Enabled:=FALSE;
     flagprolog:=false;

     TIMER1S.Enabled:=FALSE;
      ualfunc.MyDelay(1000);
      //if  assigned(formxtrans) then begin
       // showmessage('transa');
       // exit;
      // end;

    // SHOWMESSAGE('PROLOG.START  ??????????????????????????????????????????????');
    // log('c','PROLOG START !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // SHOWMESSAGE('PROLOG.START  ??????????????????????????????????????????????');
     TIMERSTART.Enabled:=FALSE;
     TIMER1S.Enabled:=FALSE;
      d:=ualfunc.ZZdate(datetostr(now));

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
    //  showmessage('next 1');

     //log('y','PROLOG START myos=============================================='+myos);

     appDir     := ExtractFilePath(FORMS.Application.ExeName);
     appExe     := ExtractFileName(FORMS.Application.ExeName);
     app        := ualfunc.ExtractStr(1,appexe,'.');

     FileDateTime := FormatDateTime('YYYY.MM.DD hh:mm:ss', FileDateToDateTime(FileAge(appExe)));
     s:='APP='+appexe +' VERSION='+filedatetime+' APPDIR='+APPDIR+app;
      caption:=S;
      // showmessage('next 2');
     //log('l','appdir='+appdir);
     //log('l','appexe='+appexe);
     //log('l','app='+app);
     //log('l','s ='+s);
      //showmessage('next 3');


     // TIMER1S.Enabled:=TRUE;
     // gcrmqtt ;
      //showmessage('PROLOG START NEXT 2');

      //formallog.show;

      // log('y','prolog AFTER TIMER1S = TRUE') ;
     // dmfunc.MyDelay(1000);

       // showmessage('next 4');
      formstarter.openstarter;
      formstarter.rereadstarter;
       //  showmessage('next 5');
      cn:=GetEnvironmentVariable('COMPUTERNAME');
      cn:=lowercase(cn);
      trclientid := GetEnvironmentVariable('COMPUTERNAME') + '#' + app;
      showmessage('trcli='+trclientid);
      trclientid := LOWERCASE(trclientid);
      mysysinfo.trclientid:=trclientid;
      mysysinfo.computername:=cn;
      // showmessage('next 6');
      //mysysinfo.os:=GetEnvironmentVariable('OS');
      mysysinfo.username:=GetEnvironmentVariable('USERNAME');
      //dmfunc.MyDelay(1000);
      log('y','call gconnectmqtt') ;

      dmmqt.gconnect('doors',mysysinfo.traddr);

      titlenode;
      //
    //  showmessage('AFTER  2');
      formglink.xgconnect(vglink);
     // showmessage('AFTER  3');
      reread;
      //showmessage('AFTER  4');
      //showmessage('next 7 11111111111111111111111111111');
      log('w','call TITLENODELOC');
      titlenodeloc;
      //   showmessage('AFTER  5');
      log('w','call fillsqluzel');
      fillsqluzel;
     // showmessage('call showsqluzel ');
     // showsqluzel;
      //ualfunc.MyDelay(100);
      //formallog.WindowState:=wsnormal;
      //formallog.show;
      timer1s.Enabled:=true;
{
  ledatetime+' APPDIR='+APPDIR;
  caption:=S;

  lint:=readtssparams('comon','life_interval');
 //  showmessage('lint='+lint);
  log('y','lint='+lint);
  n:=strtoint(lint);
  n:=n*1000;
 // showmessage('n='+inttostr(n));
 // formpgctr.timerlife.Interval:=n;
 // formpgctr.timerlife.Enabled:=true;
 //showmessage('prolog1');
  titlenode;
  reread;
  //showmessage('prolog 2');
 // readapplist;
  //titlenodeloc;
  fillsqluzel;
  showsqluzel;

     s2:=timetostr(time);
     s2:=dmfunc.ExtractStr(3,s2,':');
     //s:=app+'_'+s2;
     s:=app;

     log('w','BEFORE TRANSPORT GCONNECT');
     trclientid:=GetEnvironmentVariable('COMPUTERNAME')+'#'+app;
     trclientid:=LOWERCASE(trclientid);

     //sudavagolo
       formxtrans.gconnect('abc',mysysinfo.'192.168.0.241');
     formxtrans.gconnect(trclientid,mysysinfo.traddr);

     log('l','PROLOG ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
     log('l','++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
     log('l','++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
     log('r','end  prolog');

 }


end;



procedure TForm1.log(pr, txt: string);
var
   nn:string;
begin

     // lb1.Items.Add(txt);
     // lb1.ItemIndex:=lb1.ItemIndex+1;
     // exit;
     formallog.LOG(pr,txt);

      {
      //FORMMDLOG.log(PR,TXT);
     if formlistlog.ListBox1.count>100 then formlistlog.ListBox1.Clear;
     nn:= inttostr(formlistlog.ListBox1.count);
     nn:=dmfunc.Azerol(nn,4);
     formlistlog.ListBox1.Items.Add(nn+zp+pr+',/ '+txt);
     formlistlog.ListBox1.ItemIndex:=formlistlog.ListBox1.count-1;

    }
end;

procedure TForm1.vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var NewState: TCheckState; var Allowed: Boolean);
var
  dl: pvstrecord;
begin

  dl := vst.GetNodeData(node);
  // log('w','nm0='+dl^.nm0+' /dbmyid='+inttostr(dl^.dbmyid));
  if newstate = csCheckedNormal then  dl^.chkstate := True;
  if newstate = csUncheckedNormal then  dl^.chkstate := False;
  log('c','checking=============='+booltostr(dl^.chkstate));

  //  if dl^.chkstate=TRUE then form1.log('l','normal check')else form1.log('l','uncheck');
  // if newstate=csCheckedNormal then form1.log('l','normal');
  //form1.log('c','checking=');

end;

procedure TForm1.currreread;
begin
  titlenode;
  reread;
end;

procedure TForm1.vstDblClick(Sender: TObject);
  var
    d: pvstrecord;
  begin
    d := vst.GetNodeData(currnd);
    if d^.tag = -1 then form1.currreread;
    if d^.tag =  2 then formvst2.editac(currnd);
    if d^.tag =  0 then formeditcomp.editcomp(d);
    if d^.tag =  1 then formeditch.editch(d);

    //Form1.titlenode;
    //form1.reread;

    // if d^.tag=1 then begin  xformedit.pg1.ActivePageIndex:=0;  xformedit.Show; end;
    //if d^.tag=2 then begin  xformedit.pg1.ActivePageIndex:=1;  xformedit.Show; end;

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


  nd := node;     //vst.GetNodeData(Node);
  //if not Assigned(nd) then exit;
  //data:=vst.GetNodeData(nd);
  ;
  //if df then log('y,vstGetImageIndex='+data.ElementName);
  //imageindex:=data.sti;



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

procedure TForm1.vstlocAddToSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin

end;

procedure TForm1.vstlocAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const CellRect: TRect);
begin
  exit;

end;

function TForm1.vstlocAfterNodeExport(Sender: TBaseVirtualTree;
  aExportType: TVTExportType; Node: PVirtualNode): Boolean;
begin

end;

procedure TForm1.vstlocChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  CC, nc,rcmenu: integer;
  Data, datandp: pvstrecordloc;
  dataloc: pvstrecordloc;
  nm, nm1, dbmyid, stag, s: string;
  ndp: pvirtualnode;
  f: boolean;
  abi: integer;
  stagm2, stagm1, stag0, stag1, stag2, stag3: string;
  fee, fckp: string;
  cs2: tcs2;
begin
   CURRNDLOC := NODE;
  currmtag := -1;
  dataloc := vstLOC.GetNodeData(node);
  if dataloc = nil then exit;

  CURRNDLOC := NODE;
  dataloc := vstLOC.GetNodeData(node);
  abi := vstloc.AbsoluteIndex(node);
  log('w', 'vstlocch nm0=' + dataloc^.nm0);
  log('w', 'vstlocch bp=' + IntToStr(dataloc^.bp));
  log('w','dbmyid='+inttostr(dataloc^.DBmyid));
  log('w','bpsens='+inttostr(dataloc^.bpsens));
  log('w','SENS='+dataloc^.sens);


  log('w','vstloc FCKPS=' + DATALOC^.fckps +' /fckp='+booltostr(dataloc^.fckp) +' /tag=' + IntToStr(dataloc^.tag)+' /mpcl='+
  inttostr(dataloc^.mpcl)+' /nx='+inttostr(dataloc^.nx)+zp+'tag='+inttostr(dataloc^.tag)+zp+'bpsens='+inttostr(dataloc^.bpsens)+zp+'sens='+dataloc^.sens);

  //exit;

  try
    dataLOC := vstLOC.GetNodeData(node);
    ndp := dataloc^.ndp;
    if ndp = nil then
    begin
      currmtag := -1;
      vstloc.PopupMenu := popLOCNIL;
      log('r', 'NNNNNNNNNNNNNNNNNNNNNIL');
      // EXIT;
    end;

    f := True;
  except
    f := False;
    log('e', 'error 3');
  end;


  if dataloc^.tag = 0 then
  begin
    currmtag := 0;
    vstloc.PopupMenu:=poploctag0;

  end;




  if dataloc^.tag = -3 then
  begin
    vstloc.PopupMenu:=poplocm3;
  end;
  if dataloc^.tag = -4 then
  begin
    vstloc.PopupMenu:=poplocm4;
  end;

  if dataloc^.tag = -5 then
  begin
     vstloc.PopupMenu:=poplocm5;
    log('r','-5 555555555555555555555555555555555555555555555555555555');
   // rcmenu:=formpanmenu.mmpan('ltm5',dataloc^.nm0);
    log('y','rcmenu='+inttostr(rcmenu));
    if rcmenu=1 then begin

    end;

   // vstloc.PopupMenu:= formpanmenu.mmpan('ltm5'); // poplocm5;    //poplocm5dr;//  poplocm5;
  end;



  if dataloc^.tag = 1 then
  begin
    currmtag := 1;
    cc := vstloc.ChildCount[currndloc];
    nm1 := s;
    s := 'ksens=' + IntToStr(cc);
    stag1 := s;
    vstloc.PopupMenu:=poploctag1;
  end;

  if dataloc^.tag = 2 then
  begin
    currmtag := 2;
    vstloc.PopupMenu:=poploctag2;
    log('r','222222222222222222222222222222222222222222222222222222222');
   // rcmenu:=formpanmenu.mmpan('lt2',dataloc^.nm0);
    log('y','rcmenu='+inttostr(rcmenu));
    if rcmenu=1 then begin
     formloc2.prepare(currndloc);

    end;
   if rcmenu=3 then begin
      addnewloc(currndloc);
   end;

     if rcmenu=5 then begin
      formalnewlocsens.aladdgrp(currndloc);
     end;
    if rcmenu=6 then begin
     readgrp(currndloc);
    end;

    if rcmenu=7 then begin
     formalnewlocsens.allupd(currndloc,'insert');
    end;
   if rcmenu=8 then begin
     fdelloc(currndloc);

   end;

  end;

  EXIT;  //sudaexit;

  if dataloc^.tag = 3 then
  begin
    fee := 'und';
    currmtag := 3;
    if dataloc^.ioflag = True then fee := 'ВХОД';
    if dataloc^.ioflag = False then fee := 'ВЫХОД';

    if dataloc^.fckp = True then fckp := 'прох-ная';
    if dataloc^.fckp = False then fckp := 'дверь';

    if dataloc^.nm0 = 'key' then
    begin
      s := 'MRN=' + dataloc^.smrn + '  / IO=' + fee + ' /CKP=' + fckp +
        ' / dbmyid=' + IntToStr(dataloc^.dbmyid) + zp + ' /bps=' + IntToStr(dataloc^.bps) +
        ' /bpfl=' + IntToStr(dataloc^.bpfloor);
      stag3 := 'mrn=' + dataloc^.smrn + zp + ' ckp=' + fckp + zp + ' io=' + fee;
    end
    else
    begin
      s := '/ dbmyid=' + IntToStr(dataloc^.dbmyid) + zp + ' /mrn=' + dataloc^.smrn +
        ' /bps=' + IntToStr(dataloc^.bps) + ' /bpfl=' + IntToStr(dataloc^.bpfloor) + ' /fee=' + fee;
      stag3 := 'mrn=' + dataloc^.smrn + zp + ' ckp=' + fckp + zp + ' io=' + fee;
    end;
  end;
  log('r', 'p01.............................................');
  if dataloc^.tag = 1 then
  begin
    dataloc^.nm1 := nm1;
    log('r', nm1);
  end;

  if dataloc^.tag = -3 then
  begin

  end;

  if dataloc^.tag = -1 then
  begin
    currmtag := -1;
    vstloc.PopupMenu := popLOCNIL;
  end;


  if dataloc^.tag = 1 then
  begin
    currmtag := 1;
   // vstloc.PopupMenu := poploctag1;
    //dataloc^.nm1:=inttostr(dataloc^.mrn);
  end;
  if dataloc^.tag = 3 then
  begin
    currmtag := 3;
   // vstloc.PopupMenu := poploctag3;
  end;


  if dataloc^.tag = -1 then
  begin
    currmtag := -1;
    dataloc^.nm1 := stagm1;
  end;
  if dataloc^.tag = 0 then
  begin
    dataloc^.nm1 := stag0;
    currmtag := 0;
  end;
  if dataloc^.tag = 1 then
  begin
    currmtag := 1;
    dataloc^.nm1 := stag1;
  end;
  if dataloc^.tag = 2 then
  begin
    currmtag := 2;
    //dataloc^.nm1:=stag2;
  end;
  if dataloc^.tag = 3 then
  begin
    currmtag := 3;
    dataloc^.nm1 := stag3;
  end;




  log('r', 'p03.............................................');
  log('r', 'p03.............................................?????????????????????????????????????????????????????????????');
  log('r', 'p03.............................................?????????????????????????????????????????????????????????????');
  stag := IntToStr(dataloc^.tag);
  dbmyid := IntToStr(dataloc^.dbmyid);
  log('c', 'VSTLOC / mrn=' + dataloc^.smrn + ' / Code=' + inttostr(dataloc^.code)+
    IntToStr(abi) + ' /tag= ' + stag + ' /dbmyid=' + dbmyid + '/ bp=' + IntToStr(
    dataloc^.bp) + ' /bpsens=' + IntToStr(dataloc^.bps) + '/loccode=' + IntToStr(
    dataloc^.loccode));

end;




procedure TForm1.vstlocChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin

end;

procedure TForm1.vstlocChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var NewState: TCheckState; var Allowed: Boolean);
  begin
end;

procedure TForm1.vstlocCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  dl: pvstrecordloc;
begin
  dl := vstloc.GetNodeData(node);
  log('y', 'vstlocCollapsed=' + dl^.nm0);

end;

procedure TForm1.vstlocCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var Allowed: Boolean);
var
  dl: pvstrecordloc;
begin
  dl := vstloc.GetNodeData(node);
  log('l,', 'vstlocCollapsing=' + dl^.nm0);

end;

procedure TForm1.vstlocDblClick(Sender: TObject);
var
  dl: pvstrecordloc;
begin
  dl := vstloc.GetNodeData(currndloc);
  log('l', 'dbl=' + dl^.nm0);
  if dl^.tag = 0 then form1.currrereadloc;
end;

procedure TForm1.vstlocExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin

end;

procedure TForm1.vstlocFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin

end;

procedure TForm1.vstlocGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);

var
  nd: PVirtualNode;
  Data: PVSTRecordloc;
  //vv:TBaseVirtualTree;
  n: integer;
begin

  Data := vstloc.GetNodeData(node);
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

procedure TForm1.vstlocGetImageIndexEx(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer; var ImageList: TCustomImageList
  );
var
  nd: PVirtualNode;
  Data: PVSTRecordloc;
  vv: TBaseVirtualTree;
  n: integer;
begin

  Data := vstloc.GetNodeData(node);
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


  nd := node;     //vst.GetNodeData(Node);
  //if not Assigned(nd) then exit;
  //data:=vst.GetNodeData(nd);
  ;
  //if df then log('y,vstGetImageIndex='+data.ElementName);
  //imageindex:=data.sti;

end;

procedure TForm1.vstlocGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);

var
  Data: pvstrecordloc;
begin
  Data := Sender.GetNodeData(node);
  //  Data := vstloc.GetNodeData(node);
  //CellText := '';

  if column = 0 then
  begin
    CellText := Data^.nm0;
  end;
  if column = 1 then
  begin
    CellText := Data^.nm1;
  end;
  // end;
  if column = 2 then
  begin
    CellText := Data^.nm2;
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

procedure TForm1.vstlocInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
begin
    // log('c','vstlocInitChildren ????????????????????????');
end;

procedure TForm1.vstlocInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin

       // log('y','vstlocInitNode ????????????????????????');
end;

procedure TForm1.vstlocLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Stream: TStream);
var
  abi: integer;
  //data:pvstrcordloc;
begin
  log('r', 'abi= ??????????????????????????????????????');
  abi := vstloc.AbsoluteIndex(node);
  ShowMessage('abi=' + IntToStr(abi));
  // log('r','abi='+inttostr(abi));

end;


function TForm1.checklink(bidlocsens: integer): boolean;
var
  s: string;
  qrz: TSQLQuery;
begin
  try
    Result := False;
    //exit;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    s := ' select bidsens  from tss_sensorlinks where bidlocsens=' + IntToStr(bidlocsens);
    //log('r','checklink ='+s);
    qrz.SQL.Add(s);
    qrz.Active := True;
    if qrz.RecordCount > 0 then Result := True;
  except
    on e: Exception do
    begin
      log('e', 'checklinkbps,e=' + e.message);
    end;
  end;

end;


function TForm1.checklinkbps(bps: integer): boolean;
var
  s: string;
  qrz: TSQLQuery;
begin
  try
    Result := False;
    //exit;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    s := ' select bploc from tss_sensors where myid=' + IntToStr(bps) + ' and bploc>0';
    //log('r','checklinkbps='+s);
    qrz.SQL.Add(s);
    qrz.Active := True;
    if qrz.RecordCount > 0 then Result := True;
  except
    on e: Exception do
    begin
      log('e', 'checklinkbps,e=' + e.message);
    end;
  end;

end;

procedure TForm1.vstlocPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  dataloc: pvstrecordloc;
  x1,x2:string;
begin
  dataloc := vstLOC.GetNodeData(node);
  //if column=1 then begin
  // log('m','tag='+inttostr(data^.tag));
  if dataloc^.tag = 0 then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor
    //TargetCanvas.Font.Bold:=true;
    //TargetCanvas.Font.Underline:=true;
    //TargetCanvas.Font.Italic:=true;
  end;
  if (dataloc^.tag = 1) then
  begin
    TargetCanvas.Font.Color := clAQUA;   //   suda fontcolor
    dataloc^.nm1 := ' ------------ ЭТАЖ -------------';
  end;
   if (dataloc^.tag = -1) then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor

  end;
  if (dataloc^.tag = -2) then
  begin
    TargetCanvas.Font.Color := clsilver;   //   suda fontcolor

  end;
  if (dataloc^.tag = 3) then
  begin
    TargetCanvas.Font.Color := clsilver;   //   suda fontcolor
  end;
  {
  if (dataloc^.tag = -5) and (dataloc^.bps > 0) and (Column = 1) and
    (checklinkbps(dataloc^.bps)) then
  begin
    TargetCanvas.Font.Color := claqua;   //   suda0203 fontcolor
  end;
  }
               //suda11
   if (dataloc^.tag = -5) and    (dataloc^.ioflag=false) and(dataloc^.sens='key') then
  begin
    TargetCanvas.Font.Color := cllime;
  end;
   if (dataloc^.tag = -5) and    (dataloc^.ioflag=true) and(dataloc^.sens='key') then
    begin
    if column=1 then    TargetCanvas.Font.Color := clyellow;
   // dataloc^.NM2:='link 111111111111111113333333333'
    end;


   if (dataloc^.tag = -5) and    (dataloc^.ioflag=true) and(dataloc^.sens='open') then
    begin
    //if column=1 then    TargetCanvas.Font.Color := clskyblue;
    //if column=2 then    TargetCanvas.Font.Color := cllime;   ;
   // dataloc^.NM2:='link 111111111111111113333333333'
    end;


  x1:=inttostr(dataloc^.dbmyid);
  x2:=inttostr(dataloc^.bpsens);
  if (dataloc^.tag = -5) and    (aquacheckloc(x1,x2)=true)  then
  begin
   if column=2 then    TargetCanvas.Font.Color := claqua;
  end;


  if (dataloc^.tag = 3) and (dataloc^.bps > 0) and (Column = 2) then
  begin
    TargetCanvas.Font.Color := clred;   //   suda fontcolor
    TargetCanvas.Font.Size := 16;
  end;
  if (dataloc^.tag = -4)  then
  begin
    TargetCanvas.Font.Color := clmoneygreen;   //   suda fontcolor
    TargetCanvas.Font.Size := 16;
  end;




end;

procedure TForm1.vstlocRemoveFromSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  dl:pvstrecordloc;
  s:string;
begin

       // log('y','vstlocRemoveFromSelection') ;
        //dl:=vstloc.GetNodeData(node);
        //log('y','vstlocRemove nm0='+dl^.nm0+' /myid='+inttostr(dl^.dbmyid)) ;
      //  s:='delete from tssloc_locations where myid='+inttostr(dl^.dbmyid);
      //  selfupd(s);
      //  showmessage('remove');


end;

procedure TForm1.vstlocSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Stream: TStream);
var
  ap, s, nm0: string;
  Data: pvstrecordloc;
  sl: TStringList;
  abi, idx: integer;
begin
  ap := '''';
  abi := Sender.AbsoluteIndex(node);
  Data := vstloc.GetNodeData(node);
  sl := TStringList.Create;
  //sl.Delimiter:='#';
  nm0 := Data^.nm0;
  sl.Values['nm0'] := Data^.nm0;
  sl.Values['nm1'] := Data^.nm1;
  sl.Values['tag'] := IntToStr(Data^.tag);
  sl.Values['dbmyid'] := IntToStr(Data^.dbmyid);
  sl.Values['bp'] := IntToStr(Data^.bp);
  sl.Values['bpp'] := IntToStr(Data^.bpp);
  sl.Values['bps'] := IntToStr(Data^.bps);
  sl.Values['fckp'] := booltostr(Data^.fckp);
  sl.Values['ioflag'] := booltostr(Data^.ioflag);
  //data^.
  s := 'insert into tssloc_sls(abi,nm0,line)values(' + IntToStr(abi) + zp +
    ap + nm0 + ap + zp + ap + sl.DelimitedText + ap + ')';
  log('w', 's=' + s);
  form1.selfupd(s);
  sl.Free;


end;



function TForm1.checklinkbploc(bploc: integer): boolean;
var
  s: string;
  qrz: TSQLQuery;
begin
  try
    Result := False;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
   // s := ' select count(*) from tssloc_locations where myid=' + IntToStr(bploc);
    s := ' select bidsens from tssloc_locations where bidsens=' + IntToStr(bploc);
    qrz.SQL.Clear;
    qrz.SQL.Add(s);
    qrz.Active := True;
    if qrz.RecordCount > 0 then begin
     Result := True;
    // log('c','s='+s+' /rc='+inttostr(qrz.RecordCount));
     qrz.Close;
     qrz.Free;
     exit;
    end;
   // log('r','s='+s+' /rc='+inttostr(qrz.RecordCount));
    qrz.Close;
    qrz.Free;
    exit;
  except
    on e: Exception do
    begin
      log('e', 'checklinkbploc,e=' + e.message);
    end;
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
   TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
 end;
  if (data^.tag=1)   then begin
   //TargetCanvas.Font.Color :=clsilver;   //   suda fontcolor
 end;

 // if (data^.tag=4) and (data^.bploc>0) and checklinkbploc(data^.bploc)   then begin  //suda07
  if data^.tag=4 then begin
   rc:= form1.aquacheck(inttostr(data^.dbmyid),inttostr(data^.bploc)); //sudaaq
   if rc then begin
    TargetCanvas.Font.Color :=claqua;
    TargetCanvas.Font.Size:=16;
    TargetCanvas.font.Style:=  TargetCanvas.font.Style + [fsBold];
   end else begin
   //  TargetCanvas.Font.Color :=clskyblue;
  end;

  end;

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
  if (not data^.act ) and ((data^.tag=0) or  (data^.tag=1) or(data^.tag=2)) then begin
    TargetCanvas.Font.Color :=clskyblue;   //   suda vstfontcolor
   end;
  // if ( data^.atention=true ) and (data^.tag=4)then begin
  //  TargetCanvas.Font.Color :=clskyblue ;   //   suda vstfontcolor
  // end;
    //if ( data^.tag=2 ) and (data^.wkpx=0)then begin       suda13
    //TargetCanvas.Font.Color :=cllime;   //   suda vstfontcolor
   //end;
    if ( data^.tag=2 ) and (data^.wkpx=1)then begin
    TargetCanvas.Font.Color :=clyellow;   //   suda vstfontcolor
   end;
   if ( data^.tag=1 ) and (data^.fatal='e')then begin
    TargetCanvas.Font.Color :=clred;   //   suda vstfontcolor
   end;
    if ( data^.tag=1 ) and (data^.fatal='?')then begin
    TargetCanvas.Font.Color :=cllime;   //   suda vstfontcolor
   end;








end;




function TForm1.fnn(ndo: PVirtualNode; sl: tstringlist): PVirtualNode;
var
ndn:PVirtualNode;
data:PVSTRecord;
nm,s:string;
i:integer;
begin

        try
         //VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions+[toCheckSupport];
         ndn:=vst.AddChild(ndo);
         //showmessage('fnn 1');
         if sl.Values['ndcheck']='y' then begin
         //showmessage('fnn 2');
          ndn^.CheckType := ctTriStateCheckBox;
          if sl.Values['ndcheck_state'] ='y'    then vst.CheckState[ndn]:= cscheckedNormal;
         // if sl.Values['ndcheck_state']<>'y'    then vst.CheckState[ndn]:= csUncheckedNormal;

          if not (vsInitialized in ndn^.States) then  VST.ReinitNode(ndn,false);
             ndn^.CheckType := ctCheckBox;
             Data := VST.GetNodeData(ndn);
         end;


         //if ndn=nil then begin
         // exit;
         //end;

          //log('y','fnn  NILLLLLLLLLLLLLLLLLLLLLL ?????????????????????????????????????????');
          data:=vst.GetNodeData(ndn);
          data^.ndp:=ndo; //suda 1109
          data^.nm0:=sl.Values['nm0'];
          data^.sti:=strtoint(sl.Values['sti']);
          data^.sti1:=strtoint(sl.Values['sti1']);
          data^.tag:=strtoint(sl.Values['tag']);
          data^.dbmyid:=-1;

          data^.nm1:=sl.Values['nm1'];
          data^.nm2:=sl.Values['nm2'];
          data^.nm3:=sl.Values['nm3'];
          data^.nm4:=sl.Values['nm4'];

          vst.Refresh;
          result:=ndn;
          data:=vst.GetNodeData(ndn);
          //log('c','fnn nm0='+data^.nm0);
        except
     on ee:exception DO BEGIN
      // form1.log('e','fnewnode ,eee='+ee.Message);
     end;
    end;
end;



procedure TForm1.FormCreate(Sender: TObject);
begin

      Fmqtt:=false;
      poplocm5dr.OwnerDraw:=TRUE;
      TIMER1S.Enabled:=FALSE;
       flagprolog:=false;
      timerstart.Enabled:=false;
      slappstatus:=tstringlist.Create;
      slmqtbox:=tstringlist.Create;
      substatus.lmqtt:=dateutils.DateTimeToUnix(now,false);
      substatus.lbase:=dateutils.DateTimeToUnix(now,false);

      //grb1.Font.Color:=clwhite;
      //grb1.Color:=cllime;
      ap:='''';
      zp:=',';
      mfiltr := 'select distinct myid,bp,name,tag,sti,smrn,fckp,locinside,bidch,bidsens,loccode,code from tssloc_locations  where tag<>3 order by myid,bp';

      spl2.Color:=clblack;
      vst.Font.Color:=clwhite;

      vstloc.Enabled:=true;
      VST.NodeDataSize := SizeOf(tpvstrecord);
      VSTloc.NodeDataSize := SizeOf(tpvstrecordloc);

       VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions + [toCheckSupport];
      VSTloc.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions + [toCheckSupport];

      timerstart.Enabled:=true;
end;

procedure TForm1.GroupBox1Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin

end;

procedure TForm1.MainMenu1DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
var
  s: string;
begin
  log('r','poptag4DrawItem ??????????????????????????????????????');
  ACanvas.Font.Name := 'tahoma';
  ACanvas.Font.Size := 18;
  ACanvas.Font.Style := [fsBold];
  ACanvas.Font.Color := clYellow;
  // change background
  ACanvas.Brush.Color := clBlack;
  ACanvas.Rectangle(ARect);
  // write caption/text
  s := (Sender as TMenuItem).Caption;
  ACanvas.TextOut(ARect.Left + 2, ARect.Top + 2 , s);

end;

procedure TForm1.MenuItem100Click(Sender: TObject);
var
  myid,s,dt:string;
  dl:pvstrecordloc;
  sl:tstringlist;
  qrz: TSQLQuery;

begin
     
      dl:=vstloc.GetNodeData(currndloc);
      myid:=inttostr(dl^.dbmyid);
      sl:=tstringlist.Create;
      qrz := TSQLQuery.Create(self);
      qrz.DataBase := formglink.pqc1;
      log('l','getbidsens s='+s);

      s:='select p.tscd,p.myid,ps.fio '+
      ' from '+
      ' tss_passes  as p,'+
      ' tss_persons as ps '+
      ' where '+
      ' p.ioflag =true '+
      ' and p.bidlocparent='+myid+
      ' and p.bidpers =ps.myid ';
      log('l',s);
      qrz.SQL.Add(s);
      qrz.Active:=true;
      while not qrz.EOF do begin
       dt:=(qrz.FieldByName('tscd').AsString);
       sl.Add(dt+' / '+qrz.FieldByName('fio').AsString);
       qrz.Next;
      end;
      showmessage(sl.text);
      sl.Free;

end;



FUNCTION tform1.calcdumpfile:string;
begin

     opd1.InitialDir:=appdir+'arcpg/';
     opd1.Filter:='|*.dump|';
     opd1.Execute;
     if opd1.FileName='' then exit;
     log('l','AFTER EXECUTE opd1.filename='+opd1.FileName);

    // if yesno('ВЫ ВЫБРАЛИ ФАЙЛ='+OPD1.FILENAME) THEN BEGIN
      log('r','RESTORE FROM ='+opd1.filename);
      RESULT:=opd1.FileName;
     //end;

end;

procedure TForm1.MenuItem101Click(Sender: TObject);
begin
  
//pg_dump --dbname=postgresql://postgres:Tss2252531@127.0.0.1:5432/postgres -Fc > /home/astra/work/postgres/vvg/test2.dump






     opd1.InitialDir:=appdir+'arcpg/';
     opd1.Execute;
     if opd1.FileName='' then exit;
     log('l','AFTER EXECUTE opd1.filename='+opd1.FileName);

     if yesno('ВЫ ВЫБРАЛИ ФАЙЛ='+OPD1.FILENAME) THEN BEGIN
      log('r','RESTORE FROM ='+opd1.filename);
     end;
end;

procedure TForm1.MenuItem102Click(Sender: TObject);
BEGIN



     opd1.InitialDir:=appdir+'arcpg/';
     opd1.Execute;
     if opd1.FileName='' then exit;
     log('l','AFTER EXECUTE opd1.filename='+opd1.FileName);

     if yesno('ВЫ ВЫБРАЛИ ФАЙЛ='+OPD1.FILENAME) THEN BEGIN
      log('r','RESTORE FROM ='+opd1.filename);
     end;



end;

procedure tform1.restbin(fn:string);
//pg_restore --dbname=postgresql://postgres:Tss2252531@127.0.0.1:5432/postgres -c -Fc /home/astra/work/postgres/vvg/test2.dump
var
line:string;
ba,dbn,psw:string;
rc:string;
begin
       LOG('y','AFTER CALC fn='+fn);
       ba:=mysysinfo.baseaddr;
       dbn:=mysysinfo.basename;
       psw:=mysysinfo.basepsw;

      //fn:=FormatDateTime('yyyy-mm-dd_hh:nn:ss', now)+'.dump';

      line:='pg_restore --dbname=postgresql://postgres:'+psw+'@'+ba+':5432/postgres -c  -Fc < '+fn;
      log('l','BEFORE RESTORE line='+line);
      //rc:=ualfunc.vagoloapprun(line);
      //log('y','rc='+rc);
end;


procedure tform1.dumpbin;
//pg_dump --dbname=postgresql://postgres:Tss2252531@127.0.0.1:5432/postgres -Fc > /home/astra/work/postgres/vvg/test2.dump
//pg_dump --dbname=postgresql://postgres:Tss2252531@127.0.0.1:5432/postgres -Fc > /home/astra/common/postgres2300824.dump

 var
fn,line:string;
ba,dbn,psw:string;
rc:string;
begin

       ba:=mysysinfo.baseaddr;
       dbn:=mysysinfo.basename;
       psw:=mysysinfo.basepsw;

      fn:=FormatDateTime('yyyy-mm-dd_hh:nn:ss', now)+'.dump';

      line:='pg_dump --dbname=postgresql://postgres:'+psw+'@'+ba+':5432/postgres -Fc > '+appdir+'arcpg/'+fn;
       line:='pg_dump --dbname=postgresql://postgres:'+psw+'@'+ba+':5432/postgres -Fc > '+'common/@@@transit/arcpgs/'+fn;
       //pg_dump --dbname=postgresql://postgres:Tss2252531@192.168.0.251:5432/postgres -Fc > common/@@@transit/arcpgs/2023-08-24_15:48:19.dump
      log('l','line='+line);
      rc:=ualfunc.vagoloapprun(line);


      log('y','rc='+rc);
end;

procedure TForm1.MenuItem103Click(Sender: TObject);

//pg_dump --dbname=postgresql://postgres:Tss2252531@127.0.0.1:5432/postgres -Fc > /home/astra/work/postgres/vvg/test2.dump
 var
fn,line:string;
ba,dbn,psw:string;
rc:string;
begin

       ba:=mysysinfo.baseaddr;
       dbn:=mysysinfo.basename;
       psw:=mysysinfo.basepsw;

      fn:=FormatDateTime('yyyy-mm-dd_hh:nn:ss', now)+'.dump';

     // line:='pg_dump --dbname=postgresql://postgres:Tss2252531@127.0.0.1:5432/postgres -Fc > /home/astra/work/postgres/vvg/test2.dump
     //    line=pg_dump  --dbname=postgresql://postgres:postgres@192.168.0.251:5432/postgres -Fc > /home/astra/common/doors/arcpg/2023-06-26_16:43:48.dump

      line:='pg_dump --dbname=postgresql://postgres:'+psw+'@'+ba+':5432/postgres -Fc > '+appdir+'arcpg/'+fn;
      log('l','line='+line);
      rc:=ualfunc.vagoloapprun(line);
      log('r','rc='+rc);


end;

procedure TForm1.MenuItem105Click(Sender: TObject);
begin
     dumpbin;
end;

procedure TForm1.MenuItem106Click(Sender: TObject);
var
fn:string;
begin
       fn:=form1.calcdumpfile;
       //showmessage('MenuItem106Click fn='+fn);
       form1.restbin(fn);
end;

procedure TForm1.MenuItem107Click(Sender: TObject);
begin
    dumpsql;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
var
ds:pvstrecord;
nd:pvirtualnode;
begin
  log('y','ac_writeallkeys');
  ds:=vst.GetNodeData(currnd);
 // if ds=nil then log('r','NNNNNNNNNNNNNNNNNNNNNNNNNNIL');
  formirjs_ac(currnd, 'ac_writeallkeys');
end;


function TForm1.findvstndbymid(dbmyid, ttg: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecord;
begin

  try
    Result := nil;
    nd := vst.getfirst(True);
    Data := vst.getnodedata(nd);
    while True do
    begin
      // application.processmessages;
      nd := vst.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vst.getnodedata(nd);
      if (Data^.dbmyid = dbmyid) and (Data^.tag = ttg) then
      begin
        Result := nd;
        //  log('l','findvstndbymid tag ='+inttostr(data^.tag));
        //  log('l','findvstndbymid tag ='+inttostr(data^.tag));
        exit;
      end;
    end;
    form1.log('r', 'findvstndbymid NOT FOUND');
  except
    on e: Exception do
    begin
      form1.log('e', 'findndvstdbmyid,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;

function TForm1.findvstlocndbymid(dbmyid, ttg: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecordloc;
begin

  try
    Result := nil;
    nd := vstloc.getfirst(True);
    Data := vstloc.getnodedata(nd);
    while True do
    begin
      // application.processmessages;
      nd := vstloc.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vstloc.getnodedata(nd);
      if (Data^.dbmyid = dbmyid) and (Data^.tag = ttg) then
      begin
        Result := nd;
        //  log('l','findvstndbymid tag ='+inttostr(data^.tag));
        //  log('l','findvstndbymid tag ='+inttostr(data^.tag));
        exit;
      end;
    end;
    form1.log('r', 'findvstlocndbymid NOT FOUND');
  except
    on e: Exception do
    begin
      form1.log('e', 'findvstlocndbymid,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;



procedure TForm1.MenuItem12Click(Sender: TObject);
begin
   formirjs_ac(currnd, 'ac_readallkeys');
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
   formirjs_ac(currnd, 'ac_getpassport');
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
     showbase('pgconnect');
end;

procedure TForm1.playwav(pt:string);
begin
      log('w','pt='+pt);
      dmmqt .pls.SoundFile:=pt;
      dmmqt .pls.Execute;
end;

procedure TForm1.MenuItem15Click(Sender: TObject);
var
  pt:string;
begin
      pt:=appdir+'alpy/wav/ping1.wav';
      log('w','pt='+pt);
      dmmqt .pls.SoundFile:=pt;
      dmmqt .pls.Execute;

end;

procedure TForm1.MenuItem16Click(Sender: TObject);
var
  pt:string;
begin
      pt:=appdir+'alpy/wav/prolog.wav';
      log('w','pt='+pt);
      dmmqt .pls.SoundFile:=pt;
      dmmqt .pls.Execute;

end;

procedure TForm1.MenuItem17Click(Sender: TObject);
 var
  pt:string;
begin
      pt:=appdir+'alpy/wav/alarm3.wav';
      log('w','pt='+pt);
      dmmqt .pls.SoundFile:=pt;
      dmmqt .pls.Execute;

end;

procedure TForm1.MenuItem18Click(Sender: TObject);
var
  pt:string;
begin
       pt:=' /home/astra/common/doors/alpy/./run209.sh';
       pt:=' htop';
       dmmqt.execommand(pt);
       log('c','pt='+pt)

end;

procedure TForm1.MenuItem19Click(Sender: TObject);
begin
      //formwwcomp.show;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem20Click(Sender: TObject);
begin
       formwwch.prepare('tss_ch','i',1,currnd);
end;

procedure TForm1.MenuItem21Click(Sender: TObject);
begin
      form1.fdeletend(vst,currnd);
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
begin
    formwwch.show;
end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin
       form1.fdeletend(vst,currnd);
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
var
    d: pvstrecord;
  begin
    d := vst.GetNodeData(currnd);
    // formwwac.show;
   // formwwac.prepare('tss_acl','i',2,currnd);
   formvst2.addac(currnd);

end;

procedure TForm1.MenuItem28Click(Sender: TObject);
begin
       form1.fdeletend(vst,currnd);
end;

procedure TForm1.MenuItem29Click(Sender: TObject);
begin
     titlenodeloc;
end;

procedure TForm1.MenuItem30Click(Sender: TObject);
var
    nd:pvirtualnode;
begin
         alnewobject;
         currrereadloc;
end;

procedure TForm1.MenuItem32Click(Sender: TObject);
var
   s:string;
   dl:pvstrecordloc;
begin
      dl:=vstloc.GetNodeData(currndloc);
      vstloc.DeleteNode(currndloc);
      s:='delete from tssloc_locations where myid='+inttostr(dl^.dbmyid);
      log('l','s='+s);
      form1.selfupd(s);
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

procedure TForm1.alnewobject;
var
  s,nmo:string;
    begin
      if not form1.Inputsg('ВВЕДИТЕ НАЗВАНИЕ ВАШЕГО ОБЪЕКТА',nmo) then exit;
      s:='insert  into tssloc_locations(tag,name) values('+
      '0'+zp+
      ap+nmo+ap+')';
      form1.selfupd(s);


    end;

procedure TForm1.MenuItem33Click(Sender: TObject);
begin
   formirjs_ac(currnd, 'ac_wkpx_avt');
end;

procedure TForm1.MenuItem34Click(Sender: TObject);
begin
  formirjs_ac(currnd, 'ac_wkpx_kpx');
end;

procedure TForm1.MenuItem35Click(Sender: TObject);
begin
      updatefloor(currndloc);
end;

procedure TForm1.MenuItem36Click(Sender: TObject);
VAR
  nme,s:string;
  dl:pvstrecordloc;
begin
       dl:=vstloc.GetNodeData(currndloc);
       if not form1.Inputsg('ВВЕДИТЕ НАЗВАНИЕ ЭТАЖА',NME) then exit;
       s:='insert into tssloc_locations(tag,bp,name)values('+
        '1'+zp+
        inttostr(dl^.dbmyid)+zp+
        ap+nme+ap+
        ')';
       log('l','s='+s);
       form1.selfupd(s);
       currrereadloc;


end;

procedure TForm1.MenuItem37Click(Sender: TObject);
begin
       uformalnewloc.cnd:=currndloc;
       uformalnewloc.flagoper:='insert';

       formalnewloc.Button1.Caption:='Добавить';
       formalnewloc.prepare;
       formalnewloc.Button1.Caption:='Добавить';
       formalnewloc.show;



end;

procedure TForm1.addnewloc(cnd:pvirtualnode);
var
     qrz: TSQLQuery;
     s:string;
begin
       uformalnewloc.cnd:=cnd;
       uformalnewloc.flagoper:='insert';
       formalnewloc.prepare;
       formalnewloc.Button1.Caption:='Добавить';
       formalnewloc.show;


end;

procedure TForm1.MenuItem38Click(Sender: TObject);
var
     qrz: TSQLQuery;
     s:string;
begin
       uformalnewloc.cnd:=currndloc;
       uformalnewloc.flagoper:='insert';
       formalnewloc.prepare;
       formalnewloc.Button1.Caption:='Добавить';
       formalnewloc.show;
end;

procedure TForm1.MenuItem39Click(Sender: TObject);
var
  dl:pvstrecordloc;
  s:string;
   qrz: TSQLQuery;
begin
       uformalnewloc.cnd:=currndloc;
       dl:=vstloc.GetNodeData(currndloc);
       uformalnewloc.flagoper:='update';
       formalnewloc.prepare;
       formalnewloc.Button1.Caption:='Изменить';
       formalnewloc.lename.text:=dl^.nm0;
       formalnewloc.show;
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

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
        // try formxtrans.mqttClnt.doDisConnect;except end;
         // try mqttClnt.Destroy;except end;
         // try mqttClnt.Free;except end;
         // halt(0);

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
      form1.dumpbin;
      //line=pg_dump --dbname=postgresql://postgres:Tss2252531@192.168.0.251:5432/postgres -Fc > common/@@@transit/arcpgs/2023-08-24_15:25:58.dump

end;               //pg_dump --dbname=postgresql://postgres:Tss2252531@192.168.0.251:5432/postgres -Fc > common/@@@transit/arcpgs/2023-08-24_15:25:58.dump

function tform1.gethostparam:thostparam;
VAR
  s,sc,sip:string;
  rc,pt:string;
  sl:tstringlist;
begin
     sl:=tstringlist.Create;
      pt:=appdir+'hostname_comp.txt';
      log('l',pt);
      sc:='hostname>'+pt;
      rc:=ualfunc.vagoloapprun(sc);
      sl.LoadFromFile(pt);
      s:=sl[0];
      vhostparam.comp:=lowercase(ualfunc.ExtractStr(1,s,' '));
      log('l','comp='+vhostparam.comp);
      sl.Clear;

      pt:=appdir+'hostname_ipa.txt';
      log('l',pt);
      sip:='hostname -I >'+pt;
      rc:=ualfunc.vagoloapprun(sip);
      sl.LoadFromFile(pt);
      s:=sl[0] ;
      vhostparam.ip:=lowercase(ualfunc.ExtractStr(1,s,' '));
      log('l','ipa='+vhostparam.ip);
      sl.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
      gethostparam;
end;

procedure TForm1.cbrClick(Sender: TObject);
begin
       if cbr.Checked then vst.refresh;
end;

procedure TForm1.etscdChange(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
       formallog.WindowState:=wsnormal;
       formallog.show;
end;

function TForm1.vstlocins(cnd:pvirtualnode;cf:tfillnd):pvirtualnode;
var
  node:pvirtualnode;
  dl:pvstrecordloc;
begin

   result:=nil;
   if cf.place='first' then     Node:=Vstloc.InsertNode(Vstloc.FocusedNode,amAddChildfirst);
   if cf.place='last'  then     Node:=Vstloc.InsertNode(Vstloc.FocusedNode,amAddChildlast);
   dl:=Vstloc.GetNodeData(Node);
   dl^.ndp:=cnd;
   dl^.nm0:=cf.nm0;
   dl^.tag:=cf.tag;
   dl^.sti:=cf.sti;
   dl^.sti1:=cf.sti1 ;

    if cf.ndcheck = 'y' then
    begin
      node^.CheckType := ctTriStateCheckBox;
      if cf.ndcheck_state = 'y' then
        vstloc.CheckState[node] := cscheckedNormal;
      if cf.ndcheck_state <> 'n' then
        vstloc.CheckState[node] := csUncheckedNormal;

      if not (vsInitialized in node^.States) then  VSTloc.ReinitNode(node, False);
      node^.CheckType := ctCheckBox;
    end;


   result:=node;
  // vstloc.Expanded[currndloc]:=true;

end;

procedure TForm1.MenuItem40Click(Sender: TObject);
var
  node:pvirtualnode;
  dl:pvstrecordloc;
  cc,ci,co:integer;

begin
      dl:=vstloc.GetNodeData(currndloc);
      ci:=form1.get2rset(dl,true);
      co:=form1.get2rset(dl,false);
      dl^.nm1:='RI='+inttostr(ci)+zp+'RO='+inttostr(co);
     // log('r','nm1='+_dl^.nm1);
     {
    log('r','  Vstloc.DeleteNode(currndloc) nm0='+dl^.nm0);
     Vstloc.DeleteNode(currndloc);
     ualfunc.MyDelay(500);
     vstloc.refresh;
    }
end;

procedure TForm1.alnewsensor(cnd:pvirtualnode;flagoper:string);
begin
     formalnewlocsens.show;
end;

procedure TForm1.MenuItem41Click(Sender: TObject);
begin
       formalnewlocsens.allupd(currndloc,'insert');
end;

procedure TForm1.MenuItem42Click(Sender: TObject);
begin
   if yesno('ВЫ действительно хотите добавить стандартнуд гру сенсоров ???') then begin
    formalnewlocsens.aladdgrp(currndloc);
   end;
end;



function tform1.getbidsens(dbmyid:string):string;
var
qrz: TSQLQuery;
s:string;
begin
    qrz := TSQLQuery.Create(self);
     qrz.DataBase := formglink.pqc1;
      //s := ' select bidsens  from tss_sensorlinks where bidlocsens=' + dbmyid;
      s:='select myid from tss_sensors  where bploc='+dbmyid;
      log('l','getbidsens s='+s);
     qrz.SQL.Add(s);
     qrz.Active := True;
     if qrz.RecordCount=0 then begin
      result:='-1';
      exit;
     end;
     while not qrz.eof do begin
       result:=qrz.FieldByName('myid').AsString;
       log('l','getbidsens result='+result);
       qrz.Close;
       qrz.Free;
       exit;
     end;
end;



procedure TForm1.deleteingrp(cnd: pvirtualnode);
var
  nd:pvirtualnode;
dl,dls:pvstrecordloc;
bp,s,nm,nx,dbmyid,ioflags,iof,bpsens,bidch,bpp,NUMSENS,loccode,smrn:string;
qrz: TSQLQuery;
cf:tfillnd;
ioflag:boolean;
x :integer;
begin

     dl:=vstloc.GetNodeData(cnd);
     bp:=inttostr(dl^.bp);
     nx:=inttostr(dl^.nx);
     log('l','nm0='+dl^.nm0+' /nx='+inttostr(dl^.nx));
     s:='delete  from tssloc_locations where bp='+bp+' and tag=3 and mpcl='+nx;
     log('l','DELETEingrp s='+s);
     form1.selfupd(s);


end;



function tform1.getacport(bidport:string):string;
var
ndport,ndac,ndch,ndxomp:pvirtualnode;
ac,port,bp:string;
dd:pvstrecord;
begin
      bp:=bidport;
      if strtoint(bp)<0 then begin
        result:='';
        exit;
      end;
      log('l','bp='+bp);
      ndport:=form1.findvstndbymid(strtoint(bp),3);
      dd:=vst.GetNodeData(ndport);
      log('l','nm0='+dd^.nm0);
      ac:=dd^.ac;
      port:=dd^.port;
      result:=ac+zp+port;

end;

procedure TForm1.readingrp(cnd: pvirtualnode;bidport:string);
var
  nd:pvirtualnode;
dl,dls:pvstrecordloc;
bidsens,bp,s,nm,nx,dbmyid,ioflags,iof,bpsens,bidch,bpp,NUMSENS,loccode,smrn,code,sens,sk,sd,fckps,ckps,s1,s2,acport:string;
qrz: TSQLQuery;
cf:tfillnd;
ioflag:boolean;
x :integer;
begin

    // showmessage('readingrp start');
     dl:=vstloc.GetNodeData(cnd);
     bp:=inttostr(dl^.bp);
     nx:=inttostr(dl^.nx);
     log('l','nm0='+dl^.nm0+' /nx='+inttostr(dl^.nx));
     s:='select * from tssloc_locations where bp='+bp+' and tag=3 and mpcl='+nx+' order by code desc';
     log('l','s='+s);

     qrz := TSQLQuery.Create(self);
     qrz.DataBase := formglink.pqc1;
     qrz.SQL.Add(s);
     qrz.Active := True;
     x:=0;
     // showmessage('readingrp start 1');
     while not qrz.eof do begin
       nm:=qrz.FieldByName('name').AsString;
       bp:=qrz.FieldByName('bp').AsString;
       sens:=ualfunc.ExtractStr(1,nm,'_');
       code:=qrz.FieldByName('code').AsString;
       log('w','readingrp x='+inttostr(x));
       dbmyid:=qrz.FieldByName('myid').AsString;
       bidch:=qrz.FieldByName('bidch').AsString;
       bpp:=qrz.FieldByName('bidport').AsString;
       bidsens:=qrz.FieldByName('bidsens').AsString;
       bpsens:=getbidsens(dbmyid);
       log('r','readingrp bpsens='+bpsens);
       numsens:=qrz.FieldByName('code').AsString;
       loccode:=qrz.FieldByName('loccode').AsString;
       smrn:=qrz.FieldByName('smrn').AsString;
       ioflags:=qrz.FieldByName('ioflag').AsString;
       fckps:=qrz.FieldByName('fckp').AsString;
       if ioflags='True' then iof:='Вход ' else iof:='Выход';
       x:=1;
       ioflag:=qrz.FieldByName('ioflag').Asboolean;
       log('w','readingrp x='+inttostr(x));
       // showmessage('readingrp start 2');
       cf.nm0:=nm;
       cf.tag:=-5;
       cf.sti:=-1;
       cf.sti1:=-1;
       cf.ndcheck:='y';
       cf.place:='first';
       cf.ndcheck_state:='n';
       nd:=vstlocins(cnd,cf);
       x:=2;
       // showmessage('readingrp start 3');
       dls:=vstloc.GetNodeData(nd);
       dls^.bp:=dl^.dbmyid;
       dls^.fckps:=dl^.fckps;

       if lowercase(fckps)='true' then begin
        ckps:='Прoхд';
        dls^.fckp:=true;

       end;
       if lowercase(fckps)='false' then begin
        ckps:='Дверь';
          dls^.fckp:=false;
       end;
        //showmessage('readingrp start 4');
        log('w','readingrp x='+inttostr(x));
       dls^.fckp:=dl^.fckp;
       dls^.mpcl:=dl^.mpcl;
       dls^.dbmyid:=strtoint(dbmyid);
       dls^.ioflag:=ioflag;
       dls^.ioflags:=ioflags;
       x:=3;
       dls^.nx:=strtoint(nx);
       log('w','readingrp x='+inttostr(x));
       x:=31;
       dls^.bps:=strtoint(bpsens);
       log('w','readingrp x='+inttostr(x));
       dls^.bidch:=strtoint(bidch) ;
       x:=32;
       dls^.bpsens:=strtoint(bpsens);
       log('w','readingrp x='+inttostr(x));
       dls^.numsens:=strtoint(bpsens);
       dls^.Code:=strtoint(code);
       dls^.sens:=sens;
       x:=33;
       x:=4;
       dls^.bp:=strtoint(bp);
       dls^.bpp:=strtoint(bpp);
       dls^.bpsens:=strtoint(bidsens);
       log('w','readingrp x='+inttostr(x));
       //getsenscode(dbmyid):trcsenscode;
       //acport:=getacport(dls);
       acport:='';
      //  showmessage('readingrp start 5');
       s1:='Mrs='+'['+SMRN+']'+ZP+'IOF='+iof+' ' +ZP+'ckp='+CKPS;
        if dls^.bpp>0 then begin
         acport:=getacport(bpp);
        end;
        s2:='id='+dbmyid+zp+'tag='+inttostr(dls^.tag)+zp+'bp='+inttostr(dls^.bp)+zp+'bpsens='+bpsens+zp+'bpp='+bpp;
        s2:='id='+dbmyid+zp+'bidsens='+bidsens+zp+'bpp='+bpp;
        dls^.nm1:='acp='+acport+zp+s1;
        dls^.nm2:=s2;

       qrz.Next;
     end;



end;



procedure TForm1.readgrp(cnd: pvirtualnode);
var
  nd:pvirtualnode;
dl,dls:pvstrecordloc;
bp,s,nm,myid,code,sens:string;
qrz: TSQLQuery;
sl:tstringlist;
cf:tfillnd;
nx:integer;
rc:umain.trcfld;
begin

     dl:=vstloc.GetNodeData(cnd);
     bp:=inttostr(dl^.dbmyid);
    // s := 'select *  from tssloc_locations  where tag=3 and bp='+bp;

    s:='select distinct mpcl from tssloc_locations '+
    ' where tag=3  and bp='+bp+
    ' order by mpcl desc';
     qrz := TSQLQuery.Create(self);
     qrz.DataBase := formglink.pqc1;
     qrz.SQL.Add(s);
     qrz.Active := True;
     //showmessage('1');
     while not qrz.eof do begin
      // nm:=qrz.FieldByName('name').asstring;
       nm:=qrz.FieldByName('mpcl').AsString;
      // myid:=qrz.FieldByName('myid').AsString;
       //code:=qrz.FieldByName('code').AsString;
       sens:=ualfunc.ExtractStr(1,nm,'_');
       nm:=ualfunc.Azerol(nm,2);
       nx:=strtoint(nm);
       cf.place:='first';
       log('l','nm='+nm);
       nm:='grpsens_'+nm;
      // qrz.Next;
       cf.nm0:=nm;
       cf.tag:=-4;
       cf.sti:=-1;
       cf.sti1:=-1;
       cf.ndcheck:='n';
       cf.ndcheck_state:='n';
       nd:=vstlocins(cnd,cf);
       dls:=vstloc.GetNodeData(nd);
       dls^.bp:=dl^.dbmyid;
       dls^.fckps:=dl^.fckps;
       dls^.fckp:=dl^.fckp;
       dls^.mpcl:=dl^.mpcl;
       dls^.nx:=nx;
       //s:='select * from tssloc_locations' ;

       qrz.Next;
     end;
     //vstloc.Refresh;
end;

procedure TForm1.MenuItem43Click(Sender: TObject);
begin
      readgrp(currndloc);
end;

procedure TForm1.MenuItem44Click(Sender: TObject);
begin
        vstloc.IsVisible[currndloc] := false;
end;

procedure TForm1.MenuItem45Click(Sender: TObject);
var
dl:pvstrecordloc;
dbmyid,bP:string;
begin
     dl:=vstloc.GetNodeData(currndloc);
     dbmyid:=inttostr(dl^.dbmyid);
     bp    :=inttostr(dl^.bp);
     log('c','CALL INGRP dbmyid='+dbmyid+' / bp='+bp);
     readingrp(currndLOC,'');
end;


function TForm1.fdelloc(cnd: pvirtualnode): boolean;
var
  dataloc: pvstrecordloc;
  nm, dbmyid, tbn, s: string;
  ttg: integer;
begin

  if not yesno(
    '@@@@ Вы действительно хотите удалить узел и все дочерние элементы') then begin
     EXIT;
    end;
    log('r','fDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');
    dataloc := vstloc.GetNodeData(cnd);
    dbmyid := IntToStr(dataloc^.dbmyid);
    ttg := dataloc^.tag;
    tbn:= 'tssloc_locations';
    s := 'delete from ' + tbn + ' where myid=' + dbmyid;
    log('y', 'fdeletend s=' + s);
    form1.selfupd(s);
    //vstloc.focusednode :=cnd;
    vstloc.DeleteNode(cnd,true);
    vstloc.Refresh;
    log('l','fdeletend s='+s);


end;


procedure TForm1.MenuItem46Click(Sender: TObject);
begin
      fdelloc(currndloc);
end;


procedure TForm1.updatefloor(cnd:pvirtualnode);
var
  bp,s,v,myid:string;
  dl:pvstrecordloc;
begin
     dl:=vstloc.getnodedata(cnd);
     myid:=inttostr(dl^.dbmyid);
     bp:=inttostr(dl^.bp);
     v:=dl^.nm0;
     log('l',' NM0='+v);
     //dl^.nm0:=timetostr(time);
     log('l','MYID='+MYID+' NM0='+DL^.NM0+' /bp='+bp);

     if   form1.Inputsg('измените название',v) then begin
     // showmessage('v='+v);
       s:='update tssloc_locations set name='+ap+v+ap+' where myid='+myid;
       log('w','s='+s);
      selfupd(s);
      form1.currrereadloc;
     end;



end;


procedure TForm1.updateobj(cnd:pvirtualnode);
var
  bp,s,v,myid:string;
  dl:pvstrecordloc;
begin
     dl:=vstloc.getnodedata(cnd);
     myid:=inttostr(dl^.dbmyid);
     bp:=inttostr(dl^.bp);
     v:=dl^.nm0;
     log('l',' NM0='+v);
     //dl^.nm0:=timetostr(time);
     log('l','MYID='+MYID+' NM0='+DL^.NM0+' /bp='+bp);

     if   form1.Inputsg('измените название',v) then begin
     // showmessage('v='+v);
       s:='update tssloc_locations set name='+ap+v+ap+' where myid='+myid;
       log('w','s='+s);
      selfupd(s);
      form1.currrereadloc;
     end;



end;

procedure TForm1.MenuItem47Click(Sender: TObject);
begin
       form1.fdelloc(currndloc);
end;

procedure TForm1.MenuItem48Click(Sender: TObject);
var
  line,rc:string;
begin
    line:='aplay /home/astra/common/doors/alpy/wav/prlog.wav &';
    rc:=ualfunc.vagoloapprun(line);
    log('y','vagoloapprun rc='+rc)
end;

procedure TForm1.MenuItem49Click(Sender: TObject);

begin
      updateobj(currndloc);
end;


procedure TForm1.formir_chstop(cnd:pvirtualnode);
var
  dl:pvstrecord;
  ch,ptf,host,pch,pf,s1:string;
  begin
       dl:=vst.GetNodeData(cnd);
       ch:=dl^.NM0;
       //c:\@laz\@atss_units\atss_drv209\drv209.py -host 127.0.0.1  -dbname postgres -os windows -ch 192.168.0.96 -regim real

        //python3   aldrv209.py -ch 192.168.0.96 -chtimeout 0.001 -find n
        //mysysinfo.
        ptf:='sudo kill '+inttostr(dl^.pidch);
        log('y','ptf='+ptf);
        ualfunc.vagoloapprun(ptf);
        dl^.nm1:='послал кманду ='+ptf+' '+timetostr(time);
        vst.refresh;
        //./python3 /home/astra/common/doors/alpy/aldrv209.py  -ch 192.168.0.96 -find n -chtimeout 0.001


end;

procedure TForm1.formir_chstrart(cnd:pvirtualnode);
var
  dl:pvstrecord;
  ch,ptf,host,pch,pf,s1:string;
  begin
       dl:=vst.GetNodeData(cnd);
       ch:=dl^.NM0;
       //c:\@laz\@atss_units\atss_drv209\drv209.py -host 127.0.0.1  -dbname postgres -os windows -ch 192.168.0.96 -regim real

        //python3   aldrv209.py -ch 192.168.0.96 -chtimeout 0.001 -find n
        //mysysinfo.
        pch:=' -ch '+ch +' -find n -chsleep 0.01   & ';
        log('y','pch='+pch);
        ptf:='python3 '+appdir+'alpy/aldrv209.py '+pch;
        log('c','ptf='+ptf);
        ualfunc.vagoloapprun(ptf);
        //./python3 /home/astra/common/doors/alpy/aldrv209.py  -ch 192.168.0.96 -find n -chtimeout 0.001


end;

procedure TForm1.MenuItem51Click(Sender: TObject);
begin
       formir_chstrart(currnd);
end;

procedure TForm1.MenuItem52Click(Sender: TObject);
begin
      formir_chstop(currnd);
end;

procedure TForm1.MenuItem53Click(Sender: TObject);
begin
    formimportff.Show;
end;

procedure TForm1.MenuItem54Click(Sender: TObject);
VAR
  s:tdatetime;
  fa:longint;
  ss:string;
begin
      fa:=fileage(appexe);
      s:=filedatetodatetime(fa);
      ss:=datetimetostr(s);
      log('w','ss='+ss);
end;

procedure tform1.dumpsql;
var
fn,line,rc:string;
begin
      fn:=FormatDateTime('yyyy-mm-dd_hh:nn:ss', now)+'.sql';
      line:='pg_dump "host=localhost port=5432 dbname=postgres user=postgres password=postgres" > '+appdir+'arcpg/'+fn;
      log('l','line='+line);
      rc:=ualfunc.vagoloapprun(line);
      log('l','rc='+rc);

end;

procedure TForm1.MenuItem55Click(Sender: TObject);
var
fn,line:string;
begin
      fn:=FormatDateTime('yyyy-mm-dd_hh:nn:ss', now)+'.sql';
      line:='pg_dump "host=localhost port=5432 dbname=postgres user=postgres password=postgres" > /home/astra/common/arcpg/'+fn;
      log('l','line='+line);
      ualfunc.vagoloapprun(line);
end;

procedure TForm1.updlocgrp(cnd: pvirtualnode; bpp, bidch: string);
var
  nd:pvirtualnode;
dl,dls:pvstrecordloc;
bp,s,nm,nx,dbmyid,ioflags:string;
qrz: TSQLQuery;
cf:tfillnd;
ioflag:boolean;
i :integer;
bidsens,bidlocsens:string;
qrx:TSQLQuery;
begin

   // s=update  tssloc_locations set bpp=121 where bp=2311 and tag=3 and mpcl=1
   // update  tssloc_locations set bpp=121 where bp=2311 and tag=3 and mpcl=1

     dl:=vstloc.GetNodeData(cnd);
     bp:=inttostr(dl^.bp);
     nx:=inttostr(dl^.nx);
     log('l','nm0='+dl^.nm0+' /nx='+inttostr(dl^.nx));
     s:='update  tssloc_locations set bpp='+bpp+zp+
     'bidch='+bidch+
      ' where bp='+bp+' and tag=3 and mpcl='+nx;
     log('l','s='+s);
     form1.selfupd(s);

     for i:=1 to 4 do begin
      linkusens.pcode[i]:='-1';
      linkusens.lcode[i]:='-1';
     end;
     s:='select myid from tss_sensors where bp='+bpp + ' order by code';
     qrx:=formglink.gselqr(s);
     i:=1;
     while not qrx.eof do begin
       linkusens.pcode[i]:=qrx.FieldByName('myid').AsString;
       log('c','plink='+linkusens.pcode[i]);
       i:=i+1;
       qrx.next;
     end;

     s:='select myid from tssloc_locations where bp='+bp+' and tag=3 and mpcl='+nx +' order by code';
     log('w','s='+s);
     qrx.close;
     qrx.SQL.Clear;
    // showmessage('1') ;
     qrx:=formglink.gselqr(s);
     i:=1;
     while not qrx.eof do begin
       linkusens.lcode[i]:=qrx.FieldByName('myid').AsString;
       // showmessage('i='+ linkusens.lcode[i]) ;
       log('y','plink='+linkusens.lcode[i]);
       i:=i+1;
       qrx.next;
     end;

     // new version
     for i:=1 to 4 do begin
     // s:='update tss_sensors set bploc='+linkusens.lcode[i] +
     // ' where bp='+bpp +
     // ' and code='+inttostr(i);
      bidsens:= linkusens.pcode[i];
      bidlocsens:=linkusens.lcode[i];
      s:='insert into tss_sensorlinks (bidsens,bidlocsens,bidch,bidport)values('+
       bidsens+zp+
       bidlocsens+zp+
       bidch+ zp+
       bpp+')';
       log('w','sensors='+s);
       selfupd(s);

     end;

   {
     for i:=1 to 4 do begin
      s:='update tss_sensors set bploc='+linkusens.lcode[i] +
      ' where bp='+bpp +
      ' and code='+inttostr(i);
      log('w','sensors='+s);
      selfupd(s);
     end;

      for i:=1 to 4 do begin
      s:='update tssloc_locations set bpsens='+linkusens.pcode[i] + zp+' bidch='+bidch+
      ' where bp='+bp+' and code='+inttostr(i) +
      ' and tag=3 and mpcl='+nx ;
      log('y','locations='+s);
      selfupd(s);
     end;

   }





end;

procedure TForm1.updlocs(ndvst,ndl:pvirtualnode);
var
i:integer;
s,bp:string;
nd,ndloc:pvirtualnode;
d:pvstrecord;
dl:pvstrecordloc;
sl:tstringlist;
bidport,bidch,bidcomp,bpsens,comp,myid:string;
rc:trcfld;
qr:tsqlquery;
begin
      sl:=tstringlist.Create;
      d:=vst.GetNodedata(ndvst);
      comp:=d^.comp;
      bidch:=inttostr(d^.bidch);
      bpsens:=inttostr(d^.dbmyid);
      rc:=readfld('select myid from tss_comps where name='+ap+comp+ap);
      bidcomp:=rc.value;
     // log('r','UPDLOCS nm0='+d^.nm0+'/comp='+d^.comp+'/bploc='+inttostr(d^.bploc));
      dl:=vstloc.GetNodeData(ndl);
      bp:=inttostr(dl^.bp);
      s:='update tssloc_locations set bidport='+bpsens+zp+
      ' bidcomp='+bidcomp+zp+
      ' bidch= '+bidch+
      ' where bp='+bp;
      log('y','UPDLOCS s='+s);
      selfupd(s);
     for i:=1 to 4 do begin
      s:='select myid  from tss_sensors where bp='+bpsens +' and code='+inttostr(i);
      rc:=readfld(s);
      myid:=rc.value;
      sl.Add(myid);
      s:='update tssloc_locations set bidsens='+myid+' where bidport='+bpsens+' and code='+inttostr(i);
      log('w','UPDLOCS s='+s);
      selfupd(s);
      end;

      for i:=1 to 4 do begin;
       s:='select myid from tssloc_locations where bidport='+bpsens+' and code='+inttostr(i);
       rc:=readfld(s);
       myid:=rc.value;
       s:='update tss_sensors  set bploc='+myid+' where bp='+bpsens+' and code='+inttostr(i);
       log('c','UPDLOCS='+S);
       SELFUPD(S);
      end;





end;

procedure TForm1.MenuItem56Click(Sender: TObject);
var
nd,ndloc:pvirtualnode;
d:pvstrecord;
dl:pvstrecordloc;
sl:tstringlist;
bidport,bidch:string;
begin    // tss_locations
        // bpsens,bidcomp,bpsens,bidch
        ndloc:=currndloc;
        dl:=vstloc.GetNodeData(ndloc);
        //bp:=inttostr(dl^.dbmyid);
        sl:=tstringlist.Create;
        nd:=form1.findchckndtag(vst,3);
        if nd=nil then begin
         showmessage('НЕ НАЙДЕН ОТМЕЧЕННЫЙ ПОРТ--> ОТМЕТЬТЕ  и ПОВТОРИТЕ');
         exit;
        end;
        //showmessage('tut');
        d:=vst.GetNodeData(nd);
        bidport:=inttostr(d^.dbmyid);
        bidch:=inttostr(d^.bidch);

        log('y','nm0='+d^.nm0+'/comp='+d^.comp);
       // form1.updlocgrp(ndloc,bidport,bidch);
        updlocs(nd,ndloc);



end;

procedure TForm1.MenuItem57Click(Sender: TObject);
var
sl:tstringlist;
ptf,s,ss,kl,fio,code,bidkeys,bpkeys,bppers:string;
i:integer;

rc:tinsr;
begin
       sl:=tstringlist.create;
       ptf:=appdir+'starter/fromff.txt';
       sl.LoadFromFile(ptf);
      // sl.Sort;
       s:='delete from tss_keys';
       selfupd(s);
       s:='delete from tss_persons';
       selfupd(s);

       for i:=0 to sl.Count-1 do begin
         s:=trim(sl[i]);
        if s<>'' then begin
        // log('r','s='+s);
         kl :=ualfunc.ExtractStr(1,s,',');
        // log('l','kl='+kl);
         fio:=ualfunc.ExtractStr(2,s,',');
         //log('w','fio='+fio);
         try
          code:=inttostr(ualfunc.keytox(kl));
           ss:=kl+zp+fio+zp+code;
           log('y','ss='+ss);
           s:='insert into tss_keys (code,kluch)values('+
           code+zp+
           ap+kl+ap+')';
           if selfupd(s)='ok' then begin
            bpkeys:=inttostr(getlastmyid('tss_keys'));
            log('l',s);
            s:='insert into tss_persons (bpkeys,fio) values('+
            bpkeys+zp+
            ap+fio+ap+')';
            selfupd(s);
            bppers:=inttostr(getlastmyid('tss_persons'));
            log('l',s);
            s:='update tss_keys set bppers='+bppers+' where myid='+bpkeys;
            selfupd(s);

           end;

         except
          on ee:exception DO BEGIN
           log('e','showac kl='+kl+' ,ee='+ee.Message);
          end;
         end;

        end;
       end;




end;

procedure TForm1.MenuItem58Click(Sender: TObject);
VAR
kl,kl2,s:string;
code :int64;
begin
      s:='000000828e34,qwerty';
      log('w','s='+s) ;
      kl:=ualfunc.ExtractStr(1,s,',');
      log('w','kl='+kl) ;
      exit;

      code:=ualfunc.keytox(kl);
      kl2:=ualfunc.xkeytos(code);
      log('l','kl='+kl+zp+'code='+inttostr(code)+zp+'kl2='+kl2);


end;

function  TForm1.formiremul(bpp,bpsens,bidch:string):tstringlist;
var
s,s1,s2,sn,evid,pt:string;
sl:tstringlist;
qrx:tsqlquery;
begin
      try
       s:='select ac.ac, pt.nump ,ss.name,ch.ch,ch.chtype,cp.myid,cp.name,ac.myid from  tss_ports as pt,tss_acl as ac,tss_sensors as ss,tss_ch as ch, tss_comps as cp '+
       ' where  ch.myid='+bidch+' and '+
       ' pt.myid='+bpp +' and ac.myid=pt.bp  and ss.myid='+bpsens+
       '  and ch.myid='+bidch+' and cp.myid=ch.bp';
       log('w','fev='+s);
     except
      on ee: Exception do
       begin
        log('e', 'formiremul ,ee=' + ee.Message);
       end;
    end;

    qrx:=formglink.gselqr(s);
    if qrx.RecordCount=0 then begin
      showmessage('Нет связи с сенсором контроллера');
      exit;
    end;
    pt:='.';
    sl:=tstringlist.Create;
    sl.Values['ac']      :=qrx.Fields[0].asstring;
    sl.Values['port']    :=qrx.Fields[1].asstring;
    sl.Values['ev']      :=qrx.Fields[2].asstring;
    sl.Values['sens']    :=qrx.Fields[2].asstring;
    sl.Values['ch']      :=qrx.Fields[3].asstring;
    sl.Values['chtype']  :=qrx.Fields[4].asstring;
    sl.Values['bidcomp'] :=qrx.Fields[5].asstring;
    sl.Values['compname']:=qrx.Fields[6].asstring;
    sl.Values['bidac']   :=qrx.Fields[7].asstring;

    evid:=sl.Values['bidcomp']+pt+bidch+pt+sl.Values['bidac'];
    sl.Values['rpcchname']:='drv'+sl.Values['chtype']+'_'+sl.Values['ch'];
    sl.Values['evid']:=evid;

    result:=sl;
    //showmessage('after formiremul');
end;

function tform1.getchonbpsens(bpsens:string):string;
var
ch,ac,port:string;
myid:integer;
d:pvstrecord;
nd:pvirtualnode;
begin
       myid:=strtoint(bpsens);
       nd:=form1.findvstndbymid(myid,4);
       d:=vst.GetNodeData(nd);
       ch:=d^.ch;
       ac:=d^.ac;
       port:=d^.port;
       result:=ch;
       log('y','ch='+ch+zp+'ac='+ac+zp+'port='+port+ '     ???????????????????????????????????');
       vemuldata.ac:=ac;
       vemuldata.port:=port;


end;

procedure TForm1.MenuItem59Click(Sender: TObject);
var
i,n,ri:integer;
jb:TJSONObject;
jd:tjsondata;
sj,s,bidch,bpp,bidac,bpsens,evpid,sens,st,kluch,code,mrs,NTMZ:string;
dl:pvstrecordloc;
ac,port,ev,pt,topic:string;
//sl:tstringlist;


begin


     log('l','EMUL p00');
     pt:='.';
     dl:=vstloc.GetNodeData(currndloc);
     if dl^.bpsens=-1 then begin
      showmessage('НЕТ СВЯЗИ С СЕНСОРОМ КОНТРОЛЛЕРА ');
      EXIT;
     end;
     log('l','EMUL p01');
     st:=dl^.NM0;
     st:=ualfunc.ExtractStr(1,st,'_');
     sens:=st;

     vemuldata.bidlocsens:=inttostr(dl^.dbmyid);
     vemuldata.sens:=sens;

     log('r',''+'loccode='+inttostr(dl^.loccode)+'/loctype='+inttostr(dl^.loctype)+' /st='+st);
     bidch:=inttostr(dl^.bidch);
     bpsens:=inttostr(dl^.bpsens);

     vemuldata.bidsens:=bpsens;
     vemuldata.ch:=getchonbpsens(bpsens);

     log('l','EMUL p02');
     bpp:=inttostr(dl^.bpp);
     bidac:=inttostr(dl^.bidac);
     log('l','EMUL p03');
     {
     sl:=formiremul(bpp,bpsens,bidch);
     log('w', 'NNNNNNNNNNNNN SL='+SL.Text);
     if (sl = nil) or  (sl.Count=0) then exit;
     log('l','EMUL p04');
     log('w', 'NNNNNNNNNNNNN bidch=' + bidch+zp+'bpp='+bpp+zp+'bidac='+bidac+zp+'bpsens='+bpsens);
     evpid:=sl.Values['evid']+pt+sl.Values['port'];
     log('y', 'NNNNNNNNNNNNN evpid='+evpid);
     }
     if sens='key' then begin
     // SHOWMESSAGE('EMUL 041');
     //  log('l','EMUL p05');
      Top:=0;
     // SHOWMESSAGE('EMUL BEFORE REdpersons');
      formemul.readpersons;

      //SHOWMESSAGE('EMUL 051');
      //log('l','EMUL p06');
      formemul.showmodal;
      //SHOWMESSAGE('EMUL 061');
    //  log('l','EMUL p07');
      kluch:=formemul.ekluch.text;
      mrs:=formemul.emars.text;
      ntmz:=formemul.entmz.text;
      //log('l','EMUL p08');
//    SHOWMESSAGE('EMUL 08');
     end;
     //SHOWMESSAGE('EMUL 081');
     jb:=TJSONObject.Create(['cmd','oneemul',
                            'komu'    ,'maldms',
                            'ch'    ,vemuldata.ch,
                            'ac'      ,vemuldata.ac,
                            'port'    ,vemuldata.port,
                            'kpx'    ,'kpx',
                            'sens'   ,vemuldata.sens,
                            'kluch'  ,vemuldata.kluch,
                            'code'   ,vemuldata.codekey,
                            'mrs'   ,vemuldata.mrs,
                            'ntmz'  ,vemuldata.ntmz,
                            'no'     ,'-111111']);



     //log('l','EMUL p09');
     //SHOWMESSAGE('EMUL 09');
     sj := jb.AsJSON;
     //log('l', 'BEFORE SEND sj=' + sj);
     n:= strtoint(formemul.lerepeat.text);
     ri:= strtoint(formemul.lerint.Text);
     //log('l','EMUL p10');
     topic:='maldms';

      //SHOWMESSAGE('sj='+sj);
      dmmqt.mysend(topic,sj);

      FreeAndNil(jb);


end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
      log('l','call titlenode');
      titlenode;
end;

procedure TForm1.MenuItem60Click(Sender: TObject);
begin
    formmars1.Show;

end;

//////////
function TForm1.vaginsertr(tbn, s: string): tinsr;
VAR
  qrx :TSQLQuery;
  sRslt: String = '';
  iRecLastId: Integer = -1;
begin
  log('l',format('tbn: %s',[tbn]));
  log('l','vaginsertr='+s);

  {
  //////////
  // TODO: [TDM.doInsert] Добавление записи в ТБД по sSql
  // Выражение sSql должно содержать 'returning ID' (ID - имя поля индекса):
  //    insert into THEME (NAME, DADID, RULE) values ('new_name',123,'new_rule') returning ID;
  //    update or insert into CHANNEL (STATE, NAME, THEFILE) VALUES ('F','new_name','*.txt') matching (NAME) returning ID;
  // Возврат:
  //   Успех: строковое представление Id новой записи
  //   Провал: строка с ошибкой (должна начинаться с 'ERROR')
  function TDM.doInsert(sSql: String): String;
  var
    sRslt: String;
    qryTmp: TSQLQuery;
    iRecLastId: Integer;
  begin
    sRslt:='ERROR: Unknown!';
    qryTmp:= TSQLQuery.Create(DM);
    qryTmp.DataBase:= DM.DB;
    qryTmp.Options:=[sqoAutoCommit];
    qryTmp.UsePrimaryKeyAsKey:=True;
    qryTmp.SQL.Text:=sSql;
    try
      qryTmp.Open;
      qryTmp.SQLTransaction.CommitRetaining;
      try
          iRecLastId:=qryTmp.FieldByName('ID').AsInteger; // OK!
          sRslt:=IntToStr(iRecLastId);
      except on E: Exception do
        begin
          sRslt:='ERROR in TDM.doInsert -> iRecLastId: '+E.ClassName+'/'+E.Message;
        end;
      end;
    except on E: Exception do
      begin
        sRslt:='ERROR in TDM.doInsert -> sSql: '+E.ClassName+'/'+E.Message+' in '+LineEnding+sSql;
      end;
    end;
    qryTmp.Close;
    qryTmp.Free;
    Result:=sRslt;
  end; // function TDM.doInsert(sSql: String): String;
  }

  //sRslt:='';
  qrx:= TSQLQuery.Create(self);
  //qrx.DataBase:= DM.DB;
  qrx.DataBase := formglink.pqc1;
  qrx.Transaction:=formglink.tr1;
  qrx.Options:=[sqoAutoCommit];
  qrx.UsePrimaryKeyAsKey:=True;
  qrx.SQL.Text:=s;

  try
    qrx.Open;
    qrx.SQLTransaction.CommitRetaining;
    try
      iRecLastId:=qrx.FieldByName('myid').AsInteger; // OK!
      sRslt:=IntToStr(iRecLastId);
      result.myid:=iRecLastId;
      result.mes:='ok';
    except on E: Exception do begin
        sRslt:='ERROR in vaginsertr -> iRecLastId: '+E.ClassName+'/'+E.Message;
        result.myid:=-3;
        result.mes:=sRslt;
      end;
    end;
  except on E: Exception do
    begin
      sRslt:='ERROR in vaginsertr -> s: '+E.ClassName+'/'+E.Message+' in '+LineEnding+s;
      result.myid:=-2;
      result.mes:=sRslt;
    end;
  end;
  qrx.Close;
  qrx.Free;

end; // function TForm1.vaginsertr(..): tinsr;


function TForm1.myinsertr(tbn, s: string): tinsr;
VAR
  qrx :TSQLQuery;

begin

      qrx := TSQLQuery.Create(self);
      qrx.DataBase := formglink.pqc1;
      qrx.Transaction:=formglink.tr1;
      qrx.SQL.Clear;
      qrx.SQL.Add(s);
      //qrx.Options:=[sqoAutoCommit];
      //qrx.UsePrimaryKeyAsKey:=True;
      qrx.ExecSQL;
      qrx.Close;
      formglink.tr1.Commit;

      qrx.SQL.Clear;
      s:='select myid from  '+tbn+' order by myid desc limit 1';
      qrx.SQL.Add(s);
      qrx.Active:=true;
      result.myid:=qrx.FieldByName('myid').AsInteger;
      result.mes:='ok';


end;

procedure TForm1.MenuItem61Click(Sender: TObject);
var
  s:string;
  rc:tinsr;
begin
      s:='insert into tss_comps(name)values('+ap+timetostr(time)+ap+') returning myid';
      log('y','s='+s);
      rc:=form1.vaginsertr('tss_comps',s);
      log('l','rc.myid='+inttostr(rc.myid)+zp+'mss='+rc.mes);
end;

procedure TForm1.MenuItem62Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem63Click(Sender: TObject);
begin
      formsyslog.show;
     // formsyslog.log('l','astraorel','192.168.0.98','000000828e34');

end;

procedure TForm1.MenuItem64Click(Sender: TObject);
var
  dl,dlt2:pvstrecordloc;
  ndp:pvirtualnode;
  nmt2,nmt3:string;
begin
      log('y','redaktor');
      dl:=vstloc.GetNodeData(currndloc);
      log('l','redaktor myid='+inttostr(dl^.dbmyid));
      nmt3:=dl^.nm0;
      ndp:=dl^.ndp;
      dlt2:=form1.vstloc.GetNodeData(ndp);
      ndp:=dlt2^.ndp;
      dlt2:=form1.vstloc.GetNodeData(ndp);
      nmt2:=dlt2^.nm0;
      log('l','nmt2==='+nmt2);
      log('l','nmt3==='+nmt3);

       formlocm5.etag2.Text:=nmt2;
       formlocm5.etag3.Text:=nmt3;

       formlocm5.updloc5(dl^.dbmyid);

end;

procedure TForm1.linklocsenstousens(cnd:pvirtualnode);
var
nd,ndloc:pvirtualnode;
d:pvstrecord;
dl:pvstrecordloc;
bidloc,bidsens,bpp,bidch:integer;
s:string;
begin

        ndloc:=currndloc;
        dl:=vstloc.GetNodeData(ndloc);
        bidloc:=dl^.dbmyid;


        nd:=form1.findchckndtag(vst,4);
        if nd=nil then begin
         showmessage('НЕ НАЙДЕН ОТМЕЧЕННЫЙ СЕНСОР--> ОТМЕТЬТЕ  и ПОВТОРИТЕ');
         exit;
        end;
        d:=vst.GetNodeData(nd);
        bidsens:=d^.dbmyid;
        bidch:=d^.bidch;
        bpp:=d^.bp;
        log('w','linklocsenstousens usens='+d^.nm0+zp+'bidsens='+inttostr(bidsens));
        //s:='update tssloc_locations set bpsens='+inttostr(bidsens)+zp+
        //' bpp='+inttostr(bpp)+
        //' where myid='+inttostr(bidloc);
        s:='insert into tss_sensorlinks (bidlocsens,bidch,bidport,bidsens) values('+
        inttostr(bidloc)+zp+
        inttostr(bidch)+zp+
        inttostr(bpp)  +zp+
        inttostr(bidsens)+
        ')';
        form1.selfupd(s);
        dl^.NM1:='myid='+inttostr(bidloc)+zp+'bpsens='+inttostr(bidsens)+zp+'bpp='+inttostr(bpp);
        vstloc.Refresh;

end;

procedure TForm1.MenuItem65Click(Sender: TObject);
var
nd,ndloc:pvirtualnode;
d:pvstrecord;
dl:pvstrecordloc;
bidport,bidch,bidsens,bidls,s:string;
begin
        ndloc:=currndloc;
        linklocsenstousens(ndloc);

         EXIT;

        dl:=vstloc.GetNodeData(ndloc);
        bidls:=inttostr(dl^.dbmyid);
        //bp:=inttostr(dl^.dbmyid);

        nd:=form1.findchckndtag(vst,4);
        if nd=nil then begin
         showmessage('НЕ НАЙДЕН ОТМЕЧЕННЫЙ ПОРТ--> ОТМЕТЬТЕ  и ПОВТОРИТЕ');
         exit;
        end;
        d:=vst.GetNodeData(nd);
        bidsens:=inttostr(d^.dbmyid);
        bidch:=inttostr(d^.bidch);
        s:='update tssloc_locations set bpsens='+bidsens+' where myid='+bidls;
        log('l','s='+s);
        selfupd(s);
        s:='update tss_sensors set bploc='+bidsens +' where myid='+bidsens;
        log('l','s='+s);
        selfupd(s);



        //form1.updlocgrp(ndloc,bidport,bidch);


end;

procedure TForm1.MenuItem67Click(Sender: TObject);
begin
     if vst.color<> clblack then begin
      vst.Color:=clblack;
      vstloc.Color:=clblack;
      mysysinfo.mode:='config';
      eevx.Visible:=true;
     end
     else begin
      vst.Color:=$003C3C3C ;
      vstloc.Color:=$003C3C3C ;
      formcnfs.top:=0;
      formcnfs.left:=0;
      mysysinfo.mode:='work';
      form1.eevx.Visible:=false;
     end;

end;

function tform1.aquacheck(myid,bidsens:string):boolean;
var
s,smyid:string;
rc:trcfld;
begin
      result:=false;
      s:='select bidsens   from tssloc_locations where myid='+bidsens;
      rc:=readfld(s);
      smyid:=rc.value;
      if smyid=myid then begin
        result:=true;
      end;
end;


function tform1.aquacheckloc(myid,bidsens:string):boolean;
var
s,smyid:string;
rc:trcfld;
begin
      result:=false;
      s:='select bploc from tss_SENSORS where myid='+bidsens;
      //log('r','aquacheckloc s='+s);
      rc:=readfld(s);
      //LOG('l','bploc='+rc.value);
      smyid:=rc.value;
      if smyid=myid then begin
        result:=true;
        //   log('l','TRRUEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');
      end;
end;

procedure TForm1.MenuItem68Click(Sender: TObject);
var
  d:pvstrecord;
  bidsens,smyid,lmyid,myid,s:string;
  RC:TRCFLD;
begin
      d:=vst.getnodedata(currnd);
      bidsens:=INTTOSTR(d^.bploc);
      myid:=inttostr(d^.DBmyid);


      EXIT;

      form1.playwav(appdir+'alpy/wav/ping1.wav');

      d^.foncol:=clmedgray;
      ualfunc.MyDelay(1000);
      d^.foncol:=0;
      vst.refresh;
      exit;
      if not d^.chkstate then begin
       d^.NM1:='notchecked';
      end
      else begin
           d^.NM1:='CHECKED';
       end;
      vst.refresh;
end;

procedure TForm1.MenuItem69Click(Sender: TObject);
var
fn,line,ba,dbn,psw:string;
rc:string;
begin

       ba:=mysysinfo.baseaddr;
       dbn:=mysysinfo.basename;
       psw:=mysysinfo.basepsw;

      fn:=FormatDateTime('yyyy-mm-dd_hh:nn:ss', now)+'.sql';
      line:='pg_dump "host=localhost port=5432 dbname=postgres user=postgres password=postgres" > /home/astra/common/arcpg/'+fn;
     // line:='pg_dump "host=localhost port=5432 dbname=postgres user=postgres password=postgres" > /home/astra/common/doors/arcpg/'+fn;
      line:='pg_dump "host=localhost port=5432 dbname='+dbn+' user=postgres password='+psw+'"'+' >'+appdir+'arcpg/'+fn;
      log('l','line='+line);
      rc:=ualfunc.vagoloapprun(line);
      log('y','rc='+rc);
     // line=pg_dump "host=localhost port=5432 dbname= user=postgres password=postgres" >/home/astra/common/doors/arcpg/2023-06-25_07:35:00.sql
      //pg_dump "host=localhost port=5432 dbname= user=postgres password=postgres" >/home/astra/common/doors/arcpg/2023-06-25_07:38:53.sql
      //pg_dump "host=localhost port=5432 dbname= user=postgres password=postgres" >/home/astra/common/doors/arcpg/2023-06-26_06:38:31.sql



end;


function TForm1.getpnd(vt: TBaseVirtualTree; nd: pvirtualnode): pvirtualnode;
var
  Data: pvstrecord;

begin
  // if vt.Name='vst' then begin
  try
    Data := vt.GetNodeData(nd);
    Result := Data^.ndp;
  except
    on ee: Exception do
    begin
      log('e', 'getpnd ,ee=' + ee.Message);
    end;
  end;
  //end;

end;

function tform1.get2rset(dl:pvstrecordloc;io:boolean):integer;
var
 s,myid,ci,co:string;
 rc:trcfld;
begin

      myid:=inttostr(dl^.dbmyid);

    if io then begin
     s:='select count(*) '+
     ' from tssloc_locations as l2,tssloc_locations as l3 '+
     ' where ' +
     ' l2.tag=2 '+
     ' and l3.code=1'+
     ' and l3.tag=3 '+
     ' and l2.myid='+myid+
     ' and l3.bp='+myid+
     ' and l3.ioflag=true';      // selected  ENTRY ';
       log('y',s);
     rc:=readfld(s);
     result:=strtoint(rc.value);
     log('y',s+' /ci='+rc.value);
    end;
    if not io then begin
       s:='select count(*)'+
     ' from tssloc_locations as l2,tssloc_locations as l3 '+
     ' where ' +
     ' l2.tag=2 '+
     ' and l3.code=1'+
     ' and l3.tag=3 '+
     ' and l2.myid='+myid+
     ' and l3.bp='+myid +
     ' and l3.ioflag=false';
        log('l',s);
       rc:=readfld(s);
     log('y',s+' /co='+rc.value);
     result:=strtoint(rc.value);
    end;

 end;





procedure TForm1.MenuItem6Click(Sender: TObject);
var
  nd:pvirtualnode;
  d:pvstrecord;

begin
      {
      formedittmz.WindowState:=wsnormal;
      formedittmz.show;
      formedittmz.readalltmz;
      }
end;

procedure TForm1.MenuItem71Click(Sender: TObject);
begin
  formirjs_ac(currnd, 'ac_test_delallkeys');
end;

procedure TForm1.MenuItem72Click(Sender: TObject);
begin
       formirjs_ac(currnd, 'ac_test_readallkeys');
end;

procedure TForm1.MenuItem73Click(Sender: TObject);
var
  sl:tstringlist;
  n1,n2:string;
begin

      sl:=tstringlist.Create;
     if form1.Inputsg('start code ???',n1) then  sl.values['n1']:=n1 else exit;
     if form1.Inputsg('start code ???',n2) then  sl.values['n2']:=n2 else exit;
     //sl.values['n1']:='1';
     //sl.values['n2']:='100';
     log('l','n1='+n1+' /n2='+n2);
     formirjs_ac_mod(currnd, 'ac_test_writewallkeys',sl);
end;

procedure TForm1.MenuItem75Click(Sender: TObject);
begin
      formloc2.prepare(currndloc);
end;

procedure TForm1.MenuItem76Click(Sender: TObject);
var
  nd:pvirtualnode;
  dl:pvstrecordloc;
  data:pvstrecord;
  id,ttg,loccode:integer;
begin
     dl:=vstloc.GetNodeData(currndloc);
     nd:=findvstndbymid(dl^.dbmyid, 4) ;
     data:=vst.GetNodeData(nd);
     IF FORM1.yesno('ВЫ ДЕЙСТВИТЕЛЬНО ХОТИТЕ УДАЛИТЬ ЭТУ ГРУППУ ???')THEN BEGIN
     DELETEingrp(currndLOC);
     currrereadloc;
     //titlenodeloc;
     //fillsqluzel;
     //showsqluzel;


     end;



end;

procedure tform1.foncolvst(d:pvstrecord);
begin
      d^.foncol:=clmedgray;
      vst.refresh;
      ualfunc.MyDelay(1000);
      d^.foncol:=0;
      vst.refresh;
end;

procedure tform1.showfindsens(ndl:pvirtualnode);
var
nd:  pvirtualnode;
dl:pvstrecordloc;
d:pvstrecord;
myid,bpsens:integer;
begin
    dl:=vstloc.GetNodeData(ndl);
    myid:=dl^.dbmyid;
    bpsens:=dl^.bpsens;
    log('l','myid='+inttostr(myid)+zp+'bpsens='+inttostr(bpsens));
    nd:=findvstndbymid(bpsens,4) ;
    if ND=NIL then begin
     showmessage('НЕТ СВЯЗИ(СООТВЕТСТВИЯ) !?');
     EXIT;
    end;
    d:=vst.GetNodeData(nd);
    //d^.NM1:='FIND !!!!!!!!!!!!!!!!!!!!!!! '+timetostr(time);
   // form1.playwav(appdir+'alpy/wav/ping1.wav');
    d^.NM1:=d^.nm1+' соответствие !!! '+timetostr(time);
    foncolvst(d);
    vst.focusednode :=nd;
    vst.refresh;




end;

procedure TForm1.MenuItem77Click(Sender: TObject);
var
  nd,ndac,ndch:pvirtualnode;
  dl:pvstrecordloc;
  data,dac,dch:pvstrecord;
  id,ttg:integer;
begin
     dl:=vstloc.GetNodeData(currndloc);
     log('l','nm0='+dl^.nm0);
     log('l','bpsens='+inttostr(dl^.bpsens));
    // log('l','bpsens='+inttostr(dl^.bpsens));
     log('l','bpp='+inttostr(dl^.bpp));

     nd:=findvstndbymid(dl^.bpp, 3) ;
     if nd =nil then begin
      log('r','nillllllllllllllllllllllllll=');
      exit;
     end;
      VST.Expanded[nd] := True;
     data:=vst.GetNodeData(nd);
     data^.NM1:='СЕНСОРЫ СВЯЗИ НИЖЕ !!!!!!!!!!!!!!!!!!!!!!!!!!!!';
     vst.refresh;

     ndac:=data^.ndp;
     dac:=vst.GetNodeData(ndac);
     ndch:=dac^.NDP;
     log('l','NNNNNNNNN  nm0='+dac^.nm0);
     VST.Expanded[ndch] := True;
      vst.refresh;
     VST.Expanded[ndac] := True;
     VST.ClearSelection;
     VST.SELECTED[ndac] := True;
     vst.focusednode :=ndac;
     vst.refresh;

end;

procedure TForm1.MenuItem78Click(Sender: TObject);
var
  dl:pvstrecordloc;
  myid,s:string;
begin
      dl:=vstloc.getnodedata(currndloc);
       myid:=inttostr(dl^.dbmyid);
      s:='delete from tssloc_locations where myid='+myid;
      log('l','s='+s);
      vstloc.DeleteNode(currndloc);
      selfupd(s);
       s:='delete from tss_sensorlinks where bidlocsens='+myid;
       log('l','s='+s);
       selfupd(s);
       vstloc.refresh;

end;

procedure TForm1.MenuItem79Click(Sender: TObject);
begin
  showfindsens(currndloc);
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
var
s1,s2:string;
 s:string ;
begin
       s:='женя' ;
       s1:=base64.EncodeStringBase64(s) ;
       s2:=base64.DecodeStringBase64(s1);
       log('l','s='+s+'/s1='+s1+' /s2='+s2);
end;

procedure TForm1.MenuItem80Click(Sender: TObject);
var
  dl:pvstrecordloc;
begin
       dl:=vstloc.GetNodeData(currndloc);
       //form1.getacport(dl);

end;

procedure TForm1.MenuItem81Click(Sender: TObject);
begin
     showmessage('editsens');
end;

procedure TForm1.MenuItem82DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin
  //redaktorsens
    with ACanvas do begin
      Brush.Color :=$003C3C3C;
      Font.Color :=clskyblue;
     //Font.Style := [fsItalic];
      Font.Style := [fsBold];
      Font.Name:='tahoma';
     //FONT.Name:='Courier New';
      font.Size:=14;
    end;
    doMIClr(ACanvas,ARect,'СВЯЗАТЬ  сенсор   ');
end;

procedure TForm1.MenuItem83Click(Sender: TObject);
begin
    // showmessage('test1');
end;

procedure TForm1.MenuItem83DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin
 // showmessage('свввв');
  log('y','MenuItem83DrawItem  tttttttttttt');

   with ACanvas do begin
     Brush.Color :=$003C3C3C;
     Font.Color :=clskyblue;
    //Font.Style := [fsItalic];
     Font.Style := [fsBold];
     //Font.Name:='tahoma';
     FONT.Name:='Courier New';
     font.Size:=14;
   end;
   doMIClr(ACanvas,ARect,'11111111111111111111111111111111122222222222222222222222222222222222');
end;

procedure TForm1.MenuItem84Click(Sender: TObject);
var
 dl:pvstrecordloc;
 myid,bidsens:string;
 rc:boolean;
begin
        //showmessage('tuta');
        dl:=vstloc.GetNodeData(currndloc);
        myid:=inttostr(dl^.dbmyid);
        bidsens:=inttostr(dl^.bpsens);
        log('r','myid='+myid+' / bidsens='+bidsens);
        rc:=aquacheckloc(myid,bidsens);
end;

procedure TForm1.MenuItem86Click(Sender: TObject);
begin
    formalgol.show;
    formalgol.readalgol;
end;

procedure TForm1.MenuItem87Click(Sender: TObject);
begin

end;


procedure TForm1.MenuItem8Click(Sender: TObject);
var
    d: pvstrecord;
  begin
    d := vst.GetNodeData(currnd);
    formwwcomp.prepare('tss_comps','i',0,currnd);




end;

procedure TForm1.MenuItem90Click(Sender: TObject);
var
  s:string;
begin
         s:='delete from tssloc_locations where tag=3';
         if form1.yesno('ТОЧНО ХОТИТЕ УДАЛИТЬ SENSORS TAG 3 FROM LOCATIONS') then begin
          form1.selfupd(s);

         end;


end;

procedure TForm1.MenuItem91Click(Sender: TObject);
var
  s:string;
begin
         s:='delete from tss_passes';
         log('c',s);
         if form1.yesno('ТОЧНО ХОТИТЕ УДАЛИТЬ ДАННЫЕ ИЗ TSS_Passes') then begin
          form1.selfupd(s);
         end;


end;

procedure TForm1.MenuItem92Click(Sender: TObject);
var
  s:string;
begin
         s:='delete from tss_sensorlinks';
         log('c',s);
         if form1.yesno('ТОЧНО ХОТИТЕ УДАЛИТЬ tss_sensorslinks') then begin
          form1.selfupd(s);
         end;

end;

procedure TForm1.MenuItem93Click(Sender: TObject);
 var
   ptf:string;

  begin

        ptf:=appdir+'alpy/./emul.sh';
        log('c',ptf);
        ualfunc.vagoloapprun(ptf);





end;

procedure TForm1.MenuItem95Click(Sender: TObject);
var
  dl:pvstrecordloc;
begin
       dl:=vstloc.GetNodeData(currndloc);
       //form1.getacport(dl);
end;

procedure TForm1.MenuItem96Click(Sender: TObject);
var
  pt:string;
begin
      pt:=appdir+'wav/pass1.wav';
      log('w','pt='+pt);
      dmmqt .pls.SoundFile:=pt;
      dmmqt .pls.Execute;

end;

procedure TForm1.MenuItem97Click(Sender: TObject);
begin
     formlistpers.show;
     formlistpers.readpersons('owner');
end;

procedure TForm1.MenuItem98Click(Sender: TObject);
var
 nd:pvirtualnode;
 dl:pvstrecordloc;
 nm:string;
 ttg:integer;
begin
     dl:=vstloc.GetNodeData(currndloc);
     nm:=dl^.NM0;
     ttg:=dl^.tag;
     nd:=findndlocnm0tag(nm, ttg);
     dl:=vstloc.GetNodeData(nd);
     dl^.NM1:='01234567890123456789';
     dl^.NM2:='01234567890123456789';

end;

procedure tform1.showentryexit(sl:tstringlist;ttg:integer);
var
 nd:pvirtualnode;
 dl:pvstrecordloc;
 ci,co,s:string;
 rc:umain.trcfld;
begin
          ci:='?';
          co:='?';
          nd:=findvstlocndbymid(strtoint(sl.Values['bidlocparent']), ttg);
          dl:=vstloc.GetNodeData(nd);
          //dl^.NM2:='Вход=10,Выход=10';
          //dl^.NM2:=FormatDateTime('yyyy-mm-dd_hh:nn:ss', now);
          s:=' Select count(*) from tss_passes '+
          '  where  ' +
          ' bidlocparent='+sl.Values['bidlocparent']+
          ' and ioflag=true';
          rc:=readfld(s);
          ci:=rc.value ;
            s:=' Select count(*) from tss_passes '+
          '  where  ' +
          ' bidlocparent='+sl.Values['bidlocparent']+
          ' and ioflag=false';
          rc:=readfld(s);
          co:=rc.value ;

          dl^.NM2:='Вход='+ci+',Выход='+co;
end;

procedure TForm1.MenuItem99Click(Sender: TObject);
var
 nd:pvirtualnode;
 dl:pvstrecordloc;
 nm:string;
 bid,ttg:integer;
begin
     dl:=vstloc.GetNodeData(currndloc);
     nm:=dl^.NM0;
     ttg:=dl^.tag;
     bid:=dl^.dbmyid;
     nd:=findvstlocndbymid(bid, ttg);
     dl:=vstloc.GetNodeData(nd);
    // dl^.NM1:='01234567890123456789';
     dl^.NM2:='Вход=10,Выход=10';
     //vstloc.refresh;

end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin

end;

procedure TForm1.OPD1CanClose(Sender: TObject; var CanClose: Boolean);
begin

end;

procedure TForm1.OPD1Close(Sender: TObject);
begin

end;

procedure TForm1.OPD1SelectionChange(Sender: TObject);
begin
       log('c','ppd1='+opd1.FileName);
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;
procedure TForm1.pclearpasses;
var
  s:string;
begin
         s:='delete from tss_passes';
         log('c',s);
         if form1.yesno('ТОЧНО ХОТИТЕ УДАЛИТЬ ДАННЫЕ Истории проходов ???') then begin
          form1.selfupd(s);
         end;


end;
procedure tform1.ptmz;
var
  nd:pvirtualnode;
  d:pvstrecord;

begin

      formedittmz.WindowState:=wsnormal;
      formedittmz.readalltmz;
      formedittmz.show;

end;

procedure TForm1.Panel8Click(Sender: TObject);
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
    pclearpasses;
    ualfunc.MyDelay(500);
    p.BevelInner:=bvraised;
    p.BevelOuter:=bvraised;
    p.Color:=cl;

end;

procedure TForm1.Panel9Click(Sender: TObject);
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
    ptmz;
    ualfunc.MyDelay(500);
    p.BevelInner:=bvraised;
    p.BevelOuter:=bvraised;
    p.Color:=cl;

end;

procedure TForm1.poplocm5drDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin
  //redaktorsens
   with ACanvas do begin
     Brush.Color :=$003C3C3C;
     Font.Color :=clskyblue;
    //Font.Style := [fsItalic];
     Font.Style := [fsBold];
     Font.Name:='tahoma';
    //FONT.Name:='Courier New';
     font.Size:=14;
   end;
   doMIClr(ACanvas,ARect,'редактировать сенсор   ');
end;

procedure TForm1.poptag4DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);

begin


end;

procedure TForm1.poptag4MeasureItem(Sender: TObject; ACanvas: TCanvas;
  var AWidth, AHeight: Integer);
begin
  exit;
end;



procedure TForm1.spl2CanOffset(Sender: TObject; var NewOffset: Integer;
  var Accept: Boolean);
begin

end;


procedure TForm1.showacerr(js: string);
var
 jb:TJSONObject;
 jd:tjsondata;
cmd,k,s,sj:string;

 d:pvstrecord;
 nd:pvirtualnode;
 bid:integer;
 ki,ei,bidac,sn,pgi,pv,speed,toterr,errtopic:string;
begin

  try

      jd:=GETJSON(js);
      jb:=tjsonobject(jd);
     // log('y','showacerr js='+js);

      //ki:=jb.Get('keys_info');
      //ei:=jb.Get('events_info');
     // log('r','showacerr 1111111111111111111111111111111111111111111111111111111111111111111111111');

      //sn:=jb.Get('ser_num');
      //pv:=jb.Get('prog_ver');
     // log('r','showacerr 2222222222222222222222222222222222222221111111111111111111111111111111111111');
      //pgi:=jb.Get('prog_id');
      bidac:=jb.Get('bidac');
      //speed:=jb.Get('speed');

      //log('r','showacerr 2222222222222222222222222222222222222222222222222222222222222222222222222');
      toterr:=jb.Get('toterr');
      //errtopic:=jb.Get('errtopic');
      //log('r','showacerr 333333333333333333333333333333333333333333333333333333333333333333333333333');
      nd:=form1.findvstndbymid(strtoint(bidac),2);
      if nd=nil then begin
       log('r','nilllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll' );
       exit;
      end;
      d:=vst.GetNodeData(nd);
      d^.sti:=40;
      d^.NM1:='ERR ='+toterr+zp+' '+datetimetostr(now);
      jb.free;
      vst.refresh;
    except
      on ee:exception DO BEGIN
       log('e','showacerr ,ee='+ee.Message);
      end;
     end;
 end;


procedure TForm1.showac_state(js: string);
var
 jb:TJSONObject;
 jd:tjsondata;
cmd,k,s,sj:string;

 d:pvstrecord;
 nd:pvirtualnode;
 bid,sti:integer;
 ki,ei,bidac,cerr,toterr,pv,flag,s2,wkpx,ww,sn,pgi,speed,s1:string;
begin

  try

      jd:=GETJSON(js);
      jb:=tjsonobject(jd);

      bidac:=jb.Get('bidac');
      cerr :=jb.Get('cerr');
      toterr :=jb.Get('toterr');
      flag   :=jb.Get('flag');
      wkpx   :=jb.Get('wkpx');

      sn:=jb.Get('ser_num');
      pv:=jb.Get('prog_ver');
      pgi:=jb.Get('prog_id');
      bidac:=jb.Get('bidac');
      speed:=jb.Get('speed');
      toterr:=jb.Get('toterr');


      if flag='err' then begin
       sti:=40;
       ww:='Помехи';
      end
      else begin
       sti:=38;
        ww:='Работает';

      end;
      nd:=form1.findvstndbymid(strtoint(bidac),2);
      if nd=nil then exit;
      d:=vst.GetNodeData(nd);
      d^.NM1:=datetimetostr(now);
      d^.sti:=sti;
      d^.wkpx:=strtoint(wkpx);
      s1:='sn='+sn+pv+zp+'pgi='+pgi;
      s2:='kpx='+wkpx+zp+'cerr='+cerr+zp+'toterr='+toterr;
      d^.nm1:=ww+s1+zp+s2+zp+ FormatDateTime('yyyy-mm-dd, hh:nn:ss', now);
      //d^.NM2:='sn='+sn+zp+'pv='+pv+zp+'pgi='+pgi+zp+'ki='+ki+zp+'ei='+ei;

      jb.free;
    except
      on ee:exception DO BEGIN
       log('e','showac ,ee='+ee.Message);
      end;
     end;
 end;






procedure TForm1.showac(js: string);
var
 jb:TJSONObject;
 jd:tjsondata;
cmd,k,s,sj:string;

 d:pvstrecord;
 nd:pvirtualnode;
 bid:integer;
 ki,ei,bidac,sn,pgi,pv,s2,s1,cerr,toterr,flag,wkpx:string;
begin

  try
     // showmessage('showac='+js);
      jd:=GETJSON(js);
      jb:=tjsonobject(jd);
      ki:=jb.Get('keys_info');
      ei:=jb.Get('events_info');
      sn:=jb.Get('ser_num');
      pv:=jb.Get('prog_ver');
      pgi:=jb.Get('prog_id');
      bidac:=jb.Get('bidac');
      cerr :=jb.Get('cerr');
      toterr :=jb.Get('toterr');
      //flag   :=jb.Get('flag');
      wkpx   :=jb.Get('wkpx');

      nd:=form1.findvstndbymid(strtoint(bidac),2);
      if nd=nil then exit;
      d:=vst.GetNodeData(nd);
      d^.NM1:=datetimetostr(now);
      d^.sti:=38;
      s2:='sn='+sn+zp+'kpx='+wkpx+zp+'pv='+pv+zp+'te='+toterr+zp+'ce='+cerr+zp+'pgi=' +pgi+zp+'ki='+ki+zp+'ei='+ei;
      d^.nm1:='Работает '+zp+s2+zp+datetimetostr(now);
      //d^.NM2:='sn='+sn+zp+'pv='+pv+zp+'pgi='+pgi+zp+'ki='+ki+zp+'ei='+ei;

      jb.free;
    except
      on ee:exception DO BEGIN
       log('e','showac ,ee='+ee.Message);
      end;
     end;
 end;


function tform1.jstosl(sJSON: String):string;
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




procedure TForm1.xshowch(sl: tstringlist);
var


 d:pvstrecord;
 nd:pvirtualnode;
 bid:integer;
 bidch,councerr,opros,speed,fatal,pidch,lsacexclude:string;
begin
   try
     showmessage('xshow='+sl.text);
    bidch:=sl.Values['bidch'];
    log('y','ch='+sl.Values['ch']);
    nd:=form1.findndnm0tag(sl.Values['ch'],1);
    d:=vst.GetNodeData(nd);
    if sl.Values['subcmd']='excl'then begin
     d^.sti:=32;
     d^.nm1:='addrs='+sl.Values['addrs']+zp+'EXCL='+sl.Values['excl'];
     vst.refresh;
    end;


    //showmessage(d^.nm0);
 except
      on ee:exception DO BEGIN
       log('e','xshowch ,ee='+ee.Message);
      end;
     end;

end;

procedure TForm1.showch(js: string);
var
 jb:TJSONObject;
 jd:tjsondata;
cmd,k,s,sj:string;

 d:pvstrecord;
 nd:pvirtualnode;
 bid:integer;
 councerr,opros,speed,fatal,pidch,lsacexclude:string;
begin
   try
      //log('w','showch js='+js);
      jd:=GETJSON(js);

      jb:=tjsonobject(jd);
      s:=jb.Get('bidch');
      bid:=strtoint(s) ;
      opros:=jb.Get('regim_opros');
      councerr:=jb.Get('councerr');
      speed:=jb.Get('speed');
      fatal:=jb.Get('fatal');
      pidch:=jb.Get('pid');
      lsacexclude:=jb.Get('lsacexclude');
      //showmessage('excl='+lsacexclude);
      nd:=form1.findvstndbymid(bid,1);
      if nd=nil then exit;
      d:=vst.GetNodeData(nd);
      d^.fatal:=fatal;
      d^.pidch:=strtoint(pidch);
      d^.nm1:='kpx='+opros+zp+' pid='+pidch+zp+' speed='+speed+zp+'cce='+councerr+zp+'excl='+lsacexclude+zp+
      timetostr(time);
      if fatal<>'e' then d^.sti:=33 else d^.sti:=30;
      jb.Free;
      vst.refresh;
     except
      on ee:exception DO BEGIN
       log('e','showch ,ee='+ee.Message);
      end;
     end;

end;

procedure TForm1.razborinjs(v: string);
var
jb,jbx:TJSONObject;
jd,jdx,jdy:tjsondata;
cmd,cmdsl,k,s,sj,subcmd:string;

i:integer;
bidch:string;
sl:tstringlist;
emp:string;
fn:string;
begin
       // showmessage('razborinjs='+v);
        sl:=tstringlist.Create;
        try
        log('w','RZB0='+v);
         jd:=GETJSON(v);
         jb:=tjsonobject(jd);
         sj:=jd.FormatJSON;
         //cmd:=jb.Get('cmd');
        // try
        //  subcmd:=jb.Get('subcmd');
        // finally
        // end;
        // log('r','NEW cmd      ='+cmd+'      /SUBCMD='+subcmd+' /fn='+fn);

         sl.DelimitedText:=form1.jstosl(v);
         //log('l','VAGOLOsl==='+sl.text);
         cmd:=sl.Values['cmd'];
         subcmd:=sl.Values['subcmd'];
         //log('w','cmd ===='+cmd+'/ SUBCMD='+subcmd);
         cmd:=sl.values['cmd'];
         subcmd:=sl.Values['subcmd'];
         //log('r','cmd ===='+cmd+'/ SUBCMD='+subcmd);
         //sl.SaveToFile(fn);


         //cmdsl:=trim(sl.Values['cmd']);
         //if cmdsl= '' then emp:=' EMPTY  ' else emp:='NOT EMPTY';

        // log('c', 'razborinjs cmd=' +cmd+zp+'cmdsl='+cmdsl+' / '+emp);
         //log('r', 'razborinjs cmd=' +cmd+zp);
       except
        on ee: Exception do begin
          log('e', 'razborinjs ,ee=' + ee.Message);
        end;
       end;

        if cmd='tocomcentr' then begin
          try
          // subcmd:=jb.Get('subcmd');
          finally
          if subcmd='mbacerr' then begin
          //log('w','razbor='+v);
          //showmessage('v='+v);
          showacerr(v);
          end;
        end;


         if subcmd='acsev' then formsyslog.log(v);
          if subcmd='tosyslog' then begin
           formsyslog.log(v);
           log('c','RZB='+v);
          end;
          if subcmd='writerloglife' then begin
           showwriterlog(v,0);
          end;


          if subcmd='dmslife' then begin
          // showmessage('RAZBOR='+v);
           showdms(v,0);
          end;
            if subcmd='sgrdlife' then begin

           showsgrd(v,0);
          end;


          if subcmd='comcentrlife' then begin

            showcomcentr(v,0);
          end;
        end;

        jb.free;
       // log('w','FFFFFFFFFFFFFFFFRRRRRRRRRRRRRRRRRRRRRRREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');

       // log('r','SUBCMD='+subcmd);
        if cmd='answ_acgetpassport' then begin
          showac(v);
        end;
        if subcmd='excl' then begin
         xshowch(sl);
           //showmessage('sl='+sl.text);
           //showch(v);
        end;

        if subcmd='mbacinfo' then begin
         //  showmessage('v='+v) ;
           showac(v);
        end;
         sl.Free;

end;

{




end;
}

procedure TForm1.checkbase;
var
  qrx: TSQLQuery;
  act: boolean;
  S:STRING;
begin
 try
  s := 'select * from tss_comps';
  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  showbase('pgconnect');
  qrx.Close;
  qrx.free;
  except
    on ee: Exception do
    begin
      log('e', 'checkbase ,ee=' + ee.Message);
       showbase('pgerror');
    end;
  end;


   {
       uxt:=dateutils.DateTimeToUnix(now,false);
       s:='select myid from tss_comps';
       log('y','checkbase s='+s);
       rc:=formglink.gsel(s);
       if rc then begin
          umain.substatus.lbase:= dateutils.DateTimeToUnix(now,false);
          dlbase:=abs(uxt-umain.substatus.lbase);
          form1.showbase('pgconnect');
       end
       else begin
          log('r','AFTER GSEL');
          form1.showbase('pgerror');
       end;
     }
end;


procedure TForm1.checksubs;
var
uxt:int64;
dlmqtt,dlbase:int64;
begin
       uxt:=dateutils.DateTimeToUnix(now,false);
       dlmqtt:=abs(uxt-umain.substatus.lmqtt);
      // log('y','dmqtt='+inttostr(dlmqtt));
       if dlmqtt>=10 then begin
        showtr('mqttdisconnect',0);
       end
       else begin
         showtr('mqttconnect',0);
       end;
end;



procedure TForm1.timer1sTimer(Sender: TObject);
var
 s:string;
 i:integer;
begin



      timer1s.Enabled:=false;


      etscd.Text:= FormatDateTime('yyyy-mm-dd, hh:nn:ss', now);
     // log('y','timerr1s='+etscd.Text);
     // dmmqt.mysend(etscd.Text);
      if slappstatus.Count=0 then begin
         timer1s.Enabled:=true;
         exit;
      end;
     // timer1s.Enabled:=true;


      s:=slappstatus.Strings[0];
      //log('r','timer1s s='+s+'>');
      if s='pgconnect' then begin
       showbase(s);
       slappstatus.Delete(0);
      end;
       if s='mqttconnect' then begin

       form1.showtr(s,0);
       slappstatus.Delete(0);
      end;

      timer1s.Enabled:=true;


end;

procedure TForm1.Timer5sTimer(Sender: TObject);
var
 s,sj,topic:string;
  jb: TJSONObject;
  jd: tjsondata;
begin
     timer5s.Enabled:=false;
     exit;
     jb := TJSONObject.Create(['cmd', 'bypass','dt',datetimetostr(now)]);
     sj := jb.AsJSON;
     topic:='tomain';
     dmmqt.mysend(topic,sj);
     FreeAndNil(jb);
     timer5s.Enabled:=true;
end;

procedure TForm1.timerchecksTimer(Sender: TObject);
begin
         timerchecks.Enabled:=false;
         checksubs;
         checkbase;
         timerchecks.Enabled:=true;
end;

procedure TForm1.timerinmqttTimer(Sender: TObject);
var
  s:string;
begin
   timerinmqtt.Enabled:=false;
   if slmqtbox.Count>0 then begin
       s:=slmqtbox[0] ;
       umain.substatus.lmqtt:=dateutils.DateTimeToUnix(now,false);
       razborinjs(s);
       slmqtbox.Delete(0);
      end;
      timerinmqtt.Enabled:=true;
end;

procedure TForm1.timerstartTimer(Sender: TObject);
begin
      timerstart.Enabled:=false;
      //showmessage('call prolog');
      prolog1;
end;

procedure TForm1.UniqueInstance1OtherInstance(Sender: TObject;
  ParamCount: Integer; const Parameters: array of String);
var
 i:integer;
begin
      beep;
      for i:=1 to 10 do begin
       log('w','UniqueInstance  ');
      end;
      beep;
end;

procedure TForm1.vstAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const CellRect: TRect);
begin

end;

procedure TForm1.vstBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
   Data: pvstrecord;
begin

    data:=vst.GetNodeData(node);
    if (data^.foncol>0)  then begin
     TargetCanvas.Brush.Color :=clblack;     //clskyblue;
     TargetCanvas.FillRect(CellRect);

   end;

end;

procedure TForm1.formirlocjs_todms(cnd: pvirtualnode; subcmd: string;sl:tstringlist);
var
  Data, dch: pvstrecord;
  ndch: pvirtualnode;
  ac,bidch,kto, komu, sj,s,target,topic: string;
  jb: TJSONObject;
  jd: tjsondata;
  idcmd: integer;
begin
  topic:='tomain';
  Data := vst.GetNodeData(cnd);
  s:=data^.nm0;
  bidch:=inttostr(data^.dbmyid);
  log('r','idkomu='+s);
  ndch := Data^.ndp;
  dch := vst.GetNodeData(ndch);
  bidch:=inttostr(dch^.dbmyid);
  ac := Data^.nm0;
  komu := Data^.idkomu;

  Data^.nm1 := datetimetostr(now) + zp + 'отправил  cmd=' +
    subcmd + zp + 'idcmd=' + IntToStr(idcmd);
  komu :='dms';
  target := 'dms' ;
  kto := umain.trclientid;

  jb := TJSONObject.Create(['cmd', 'todrv', 'kto', kto,
    //umain.trclientid,
    'idcmd', IntToStr(idcmd),

    'komu', komu, 'subcmd', subcmd,'target',target,
    'ac', ac, 'uxt',IntToStr(dateutils.DateTimeToUnix(now)),
    'bidch',bidch,
    'cds', datetimetostr(now)]);


  sj := jb.AsJSON;
  log('y', 'BEFORE SENDsj=' + sj);

  dmmqt.mysend(topic,sj);

  FreeAndNil(jb);



end;





procedure TForm1.formirjs_ac_mod(cnd: pvirtualnode; subcmd: string;sl:tstringlist);
var
  Data, dch: pvstrecord;
  ndch: pvirtualnode;
  ac,bidch,kto, komu, sj,s,target,topic: string;
  jb: TJSONObject;
  jd: tjsondata;
  idcmd: integer;
begin
  topic:='tomain';
  Data := vst.GetNodeData(cnd);
  s:=data^.nm0;
  bidch:=inttostr(data^.dbmyid);
  log('r','idkomu='+s);
  ndch := Data^.ndp;
  dch := vst.GetNodeData(ndch);
  bidch:=inttostr(dch^.dbmyid);
  ac := Data^.nm0;
  komu := Data^.idkomu;

  Data^.nm1 := datetimetostr(now) + zp + 'отправил  cmd=' +
    subcmd + zp + 'idcmd=' + IntToStr(idcmd);
  komu := mysysinfo.computername + 'drv209_' + dch^.nm0;
  target := mysysinfo.computername + 'drv209_' + dch^.nm0;
  kto := umain.trclientid;
  showmessage('kto='+kto);


  jb := TJSONObject.Create(['cmd', 'todrv', 'kto', kto,
    //umain.trclientid,
    'idcmd', IntToStr(idcmd),
    'n1',sl.Values['n1'],
    'n2',sl.Values['n2'],
    'komu', komu, 'subcmd', subcmd,'target',target,
    'ac', ac, 'uxt',IntToStr(dateutils.DateTimeToUnix(now)),
    'bidch',bidch,
    'cds', datetimetostr(now)]);


  sj := jb.AsJSON;
  log('y', 'BEFORE SENDsj=' + sj);

  dmmqt.mysend(topic,sj);

  FreeAndNil(jb);


end;



procedure TForm1.formirjs_ac(cnd: pvirtualnode; subcmd: string);
var
  Data, dch: pvstrecord;
  ndch: pvirtualnode;
  ac,bidch,kto, komu, sj,s,target,topic: string;
  jb: TJSONObject;
  jd: tjsondata;
  idcmd: integer;
begin
  topic:='tomain';
  kto:=umain.trclientid;
  Data := vst.GetNodeData(cnd);
  s:=data^.nm0;
  bidch:=inttostr(data^.dbmyid);
  log('r','idkomu='+s);
  ndch := Data^.ndp;
  dch := vst.GetNodeData(ndch);
  bidch:=inttostr(dch^.dbmyid);
  ac := Data^.nm0;
  komu := Data^.idkomu;

  Data^.nm1 := datetimetostr(now) + zp + 'отправил  cmd=' +
    subcmd + zp + 'idcmd=' + IntToStr(idcmd);
  komu := mysysinfo.computername + 'drv209_' + dch^.nm0;
  target := mysysinfo.computername + 'drv209_' + dch^.nm0;
  kto := umain.trclientid;

  jb := TJSONObject.Create(['cmd', 'setdrv', 'kto', kto,
    //umain.trclientid,
    'idcmd', IntToStr(idcmd),
    'komu', komu, 'subcmd', subcmd,'target',target,
    'ac', ac, 'uxt',IntToStr(dateutils.DateTimeToUnix(now)),
    'bidch',bidch,
    'cds', datetimetostr(now)]);


  sj := jb.AsJSON;
  log('y', 'BEFORE SENDsj=' + sj);

  dmmqt.mysend(topic,sj);

  FreeAndNil(jb);


end;

/////////////////////////////////////////////////////////////////////////////////////////////////


procedure TForm1.vstChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 nc,pid,pidch:integer;
 data,datandp:pvstrecord;
 nm,dbmyid,stag,s:string;
 ndp:pvirtualnode;
 f:boolean;
 abi,idx,ldm0:string;
begin

  currnd:=node;
  data:=vst.GetNodeData(node);
  if data=nil then begin
   log('w','vstchange data=nil');
   exit;
  end;
  //log('w','vstchange NNNNNNNNNNNNNNNNNNNNEXT');
  log('c','ch='+data^.ch+zp+'tag='+inttostr(data^.tag)+zp+'nm0='+data^.nm0+zp+'myid='+inttostr(data^.dbmyid)+zp+'bidch='+inttostr(data^.bidch)+zp+'ac='+data^.ac+zp+'bidac='+inttostr(data^.bidac));
 // datandp:=vst.GetNodeData(ndp);
  if data^.tag=-1 then begin
   log('y','popminus');
    vst.PopupMenu:=popminus;
  end;
  if data^.tag=-109 then begin
    vst.PopupMenu:=popm109;
  end;


  if data^.tag=0 then begin
   log('y','poptag0');
    vst.PopupMenu:=poptag0;
  end;
   if data^.tag=1 then begin
   vst.PopupMenu:=poptag1;

   end;
  if data^.tag=2 then begin
   vst.PopupMenu:=poptag2;
  end;
  if data^.tag=4 then begin
   vst.PopupMenu:=poptag4;
  end;


end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
     //formmdlog.show;
    log('c',datetimetostr(now));

end;

procedure TForm1.titlenode;
var
  sl:tstringlist;
begin
     vst.Clear;

     sl:=tstringlist.Create;
     sl.Values['nm0']:='ДЕРЕВО ОБЪЕКТОВ  ';
     //sl.Values['nm1']:='BASE postgreS='+VGLINK.state;
     sl.Values['sti']:='-1';
     sl.Values['sti1']:='-1';
     sl.Values['tag']:='-1';
     sl.Values['ndcheck']:='y';
     sl.Values['ndcheck_state']:='n';
     firstnd:=fnn(nil,sl);
     //log('l','titlenode AFTER FNN');
     //exit;

end;

function TForm1.findchckndtag(vt: TLazVirtualStringTree; ttg: integer
  ): pvirtualnode;
var
  dl: pvstrecord;
  nd: pvirtualnode;
  cc, mrn: integer;
  sl: TStringList;
  bp, s: string;
begin

  Result := nil;
  //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
  nd := vt.getfirst(True);
  dl := vt.getnodedata(nd);
  sl := TStringList.Create;
  //showmessage('findchcknd first nm='+dl^.nm0);
  if (dl^.chkstate) and (dl^.tag = ttg) then
  begin
    mrn := dl^.mrn;
    s := IntToStr(mrn);
    sl.Add(s + ',' + IntToStr(dl^.dbmyid));
  end;


  cc := vt.CheckedCount;
  form1.log('w', ' /cc=' + IntToStr(cc));
  if cc>1 then begin
    showmessage('ОТМЕЧЕНО  БОЛЕЕ 1 ПОРТА --> СНИМИТЕ ЛИШНИЕ ОТМЕТКИ И ПОВТОРИТЕ ');
   exit;
  end;
       {
        if cc=0 then begin
         showmessage('ВЫ НЕ ВЫБРАЛИ МАРШРУТ(ы). ПОВТОРИТЕ');
         exit;
        end;
       }
  //  sl:=tstringlist.Create;
  while True do
  begin
    application.ProcessMessages;
    nd := vt.getnext(nd);
    //form1.log('y','nm0='+data.nm0+'>');
    if not assigned(nd) then
    begin
      Result := nd;
      exit;
    end;
    dL := vt.getnodedata(nd);
    if dl^.chkstate then
    begin
      DL := vt.GetNodeData(ND);
      form1.log('l', 'SELECTED nm0=' + dl^.nm0 + ' /cc=' + IntToStr(cc));
      // s:=inttostr(mrn);
      // sl.Add(s+','+inttostr(dl^.dbmyid));
      bp := IntToStr(dl^.bp);
      mrn := dl^.mrn;
      s := IntToStr(mrn);
      sl.Add(s + ',' + IntToStr(dl^.dbmyid) + ',' + bp);
      //Vt.Refresh;
      result:=nd;
      log('l','findchckndtag FINDING OK');
      exit;
    end;
  end;
  //ShowMessage('text=' + sl.Text);
  Result := nd;

end;

function Tform1.doJSON2SL(sJSON: String): TStringList;
 var
   sl:tstringlist;
begin
  SL:= TStringList.Create;
  //sl.Delimiter:=',';
  sJSON:=Trim(sJSON);

  log('r','SJSON='+SJSON);
  log('r','DelimitedText='+sJSON.Substring(1,Length(sJSON)-2).Replace('"','').Replace(':','='));

  if(0=Length(sJSON)) then ShowMessage('Не задана строка объекта JSON!')
  else SL.DelimitedText:=sJSON.Substring(1,Length(sJSON)-2).Replace('"','').Replace(':','=');

  Result:= SL;

end; // function TfmMain.doJSON2SL(..): TStringList;

//////////
function Tform1.doSL2JSON(SL: TStringList): String;
var
  sRslt: String = '';
  sRow: String;
  saTmp: TStringArray;
begin
  for sRow in SL do begin
    saTmp:=sRow.Split('=');
    sRslt+=ifthen(0=Length(sRslt),'',',')+'"'+saTmp[0]+'"'+':'+'"'+saTmp[1]+'"';
  end; // for sRow in vleMain.Strings do
  Result:='{'+sRslt+'}';
end; // function TfmMain.doSL2JSON(..): String;

end.
 {
select *  from tss_syslog
where tscd>= cast( '2023-05-18  00:00:00'       as timestamp)
and    tscd<= cast( '2023-05-18   05:14:00'   as timestamp)
order by tscd

 }


 {
s='create  table '+tbn+'('+\
   ' (myid  integer      not null  primary key autoincrement unique,'+\
   ' f1     default - 1,'\
   ' f2     default - 1,'\
   ' tscd   DEFAULT   CURRENT_TIMESTAMP)'

alter  TABLE sys_20230622 rename to  t1

}



end.









