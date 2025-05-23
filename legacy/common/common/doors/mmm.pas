//unit umain;
unit mmm;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils, PQConnection, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, Menus, ExtendedTabControls, laz.VirtualTrees, ImgList, StdCtrls,
  Buttons, DBGrids, uglink, SQLDB, memds, DB, Grids, lcltype, rxswitch,
  UniqueInstance, Process, fpjson, jsonparser, dateutils, ShellApi, ActiveX,
  base64;

type
  tmaska = record
    rc: integer;
    maska: array[1..8] of string[1];
  end;

type
  tndmars = record
    rc: integer;
    ndsens: pvirtualnode;
    ndport: pvirtualnode;
  end;


type
  tcs2 = record
    Count: integer;
    line: string;
  end;


type
  tsqlauzel = record
    pnd: pvirtualnode;
    myid: integer;
    smrn: string;
    bp: integer;
    sti: integer;
    tag: integer;
    Name: string;
  end;



type
  tmyrcvtr = record
    nm0: string;
    nm1: string;
    app: string;
    Name: string;
    abi: integer;
    bp: integer;
    bpp: integer;
    dbmyid: integer;
    lastobs: int64;
    tag: integer;
    sti: integer;
    sti1: integer;
    myid: integer;
  end;


type
  tmyprd = record
    currid: integer;
    lastid: integer;
    sl: TStringList;
    rc: string;
  end;
{
type tmyrcdb  =record
      fullmess  :string;
      rusmes    :string;
      rc        :string;
     end;}
type
  tmysysinfo = record
    computername: string;
    ip: string;
    os: string;
    username: string;
    sep: string;
    traddr: string;
    baseaddr: string;
    basename: string;
    basepsw: string;
  end;


type
  pvstrecordloc = ^Tpvstrecordloc;

  Tpvstrecordloc = record
    ndp: pvirtualnode;
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
    ioflag: boolean;
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
    path: string;
    launchline: string;
    idkomu: string;
    comp: string;
    ch: string;
    ac: string;
    port: string;
    sensor: string;
    bidac: integer;
    act: boolean;
    ctyp: string;
    pidguard: integer;
    pidch: integer;
    chtype: string;
    chkstate: boolean;
    bp: integer;
    bploc: integer;
    bpsens: integer;
    mrn: integer;
    ndp: pvirtualnode;
    tag: integer;
    dbmyid: integer;
    lastobs: int64;
    idx_loc_1: integer;
    idx_loc_2: integer;
    src: string;
    nm0: string;
    nm1: string;
    nm2: string;
    nm3: string;
    nm4: string;
    nm5: string;
    sti: integer;
    sti0: integer;
    sti1: integer;
    keyname: string;  // составное имя=bp+','+dbmyid+'.'+nm0+'.'+tag;
    app: string;

    f2: string;
    Image: integer;
    Size: int64;
  end;

type
  tlinkloc = record
    rc: integer;
    aloc: array[1..4] of pvstrecordloc;
    asens: array[1..4] of pvstrecord;
  end;


type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    dsll: TDataSource;
    etscd: TEdit;
    LargeImages: TImageList;
    mdll: TMemDataset;
    MenuItem10: TMenuItem;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    MenuItem104: TMenuItem;
    MenuItem105: TMenuItem;
    MenuItem106: TMenuItem;
    MenuItem107: TMenuItem;
    MenuItem108: TMenuItem;
    MenuItem109: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem110: TMenuItem;
    MenuItem111: TMenuItem;
    MenuItem112: TMenuItem;
    MenuItem113: TMenuItem;
    MenuItem114: TMenuItem;
    MenuItem115: TMenuItem;
    MenuItem116: TMenuItem;
    MenuItem117: TMenuItem;
    MenuItem118: TMenuItem;
    MenuItem119: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem120: TMenuItem;
    MenuItem121: TMenuItem;
    MenuItem122: TMenuItem;
    MenuItem123: TMenuItem;
    MenuItem124: TMenuItem;
    MenuItem125: TMenuItem;
    MenuItem126: TMenuItem;
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
    MenuItem3: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4: TMenuItem;
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
    MenuItem5: TMenuItem;
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
    MenuItem6: TMenuItem;
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
    MenuItem7: TMenuItem;
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
    MenuItem8: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem85: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    MenuItem89: TMenuItem;
    MenuItem9: TMenuItem;
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
    Panel2: TPanel;
    Panel3: TPanel;
    popnil: TPopupMenu;
    popminus: TPopupMenu;
    poptag1: TPopupMenu;
    poptag0: TPopupMenu;
    poptag2: TPopupMenu;
    poptag3: TPopupMenu;
    poplocnil: TPopupMenu;
    poploctag0: TPopupMenu;
    poplog: TPopupMenu;
    PopupMenu1: TPopupMenu;
    poploctag1: TPopupMenu;
    poploctag3: TPopupMenu;
    PopupMenu2: TPopupMenu;
    poploctagm2: TPopupMenu;
    poptag4: TPopupMenu;
    xpoploc3: TPopupMenu;
    xpoploc2: TPopupMenu;
    selftr: TSQLTransaction;
    Splitter2: TSplitter;
    timer1s: TTimer;
    timerstart: TTimer;
    UniqueInstance1: TUniqueInstance;
    vst: TLazVirtualStringTree;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    vstloc: TLazVirtualStringTree;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cblChange(Sender: TObject);
    procedure cblClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure Edit1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure MenuItem100Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem104Click(Sender: TObject);
    procedure MenuItem107Click(Sender: TObject);
    procedure MenuItem109Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem110Click(Sender: TObject);
    procedure MenuItem112Click(Sender: TObject);
    procedure MenuItem113Click(Sender: TObject);
    procedure MenuItem114Click(Sender: TObject);
    procedure MenuItem115Click(Sender: TObject);
    procedure MenuItem117Click(Sender: TObject);
    procedure MenuItem118Click(Sender: TObject);
    procedure MenuItem119Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem120Click(Sender: TObject);
    procedure MenuItem121Click(Sender: TObject);
    procedure MenuItem122Click(Sender: TObject);
    procedure MenuItem123Click(Sender: TObject);
    procedure MenuItem124Click(Sender: TObject);
    procedure MenuItem125Click(Sender: TObject);
    procedure MenuItem126Click(Sender: TObject);
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
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
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
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem50Click(Sender: TObject);
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
    procedure MenuItem66Click(Sender: TObject);
    procedure MenuItem67Click(Sender: TObject);
    procedure MenuItem68Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem70Click(Sender: TObject);
    procedure MenuItem72Click(Sender: TObject);
    procedure MenuItem73Click(Sender: TObject);
    procedure MenuItem74Click(Sender: TObject);
    procedure MenuItem76Click(Sender: TObject);
    procedure MenuItem77Click(Sender: TObject);
    procedure MenuItem78Click(Sender: TObject);
    procedure MenuItem79Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem80Click(Sender: TObject);
    procedure MenuItem81Click(Sender: TObject);
    procedure MenuItem82Click(Sender: TObject);
    procedure MenuItem83Click(Sender: TObject);
    procedure MenuItem84Click(Sender: TObject);
    procedure MenuItem85Click(Sender: TObject);
    procedure MenuItem86Click(Sender: TObject);
    procedure MenuItem87Click(Sender: TObject);
    procedure MenuItem88Click(Sender: TObject);
    procedure MenuItem89Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem90Click(Sender: TObject);
    procedure MenuItem91Click(Sender: TObject);
    procedure MenuItem93Click(Sender: TObject);
    procedure MenuItem95Click(Sender: TObject);
    procedure MenuItem96Click(Sender: TObject);
    procedure MenuItem97Click(Sender: TObject);
    procedure MenuItem98Click(Sender: TObject);
    procedure MenuItem99Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure panpollbaseClick(Sender: TObject);
    procedure pantimer1sClick(Sender: TObject);
    procedure pqc1AfterConnect(Sender: TObject);
    procedure rblocChange(Sender: TObject);
    procedure rgfClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure timer1sTimer(Sender: TObject);

    procedure timerstartTimer(Sender: TObject);
    procedure log(pr, txt: string);
    procedure timertestTimer(Sender: TObject);
    procedure vstBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    function fnn(ndo: PVirtualNode; sl: TStringList): PVirtualNode;
    procedure vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: boolean);
    procedure vstDblClick(Sender: TObject);
    procedure vstGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: boolean;
      var ImageIndex: integer);
    procedure vstGetImageIndexEx(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: boolean;
      var ImageIndex: integer; var ImageList: TCustomImageList);

    procedure titlenode;
    procedure titlenodeloc;
    procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    function Inputsg(const Prompt: string; var Value: string): boolean;
    procedure newch(ndc: pvirtualnode; v: string);
    procedure newcomp;
    procedure reread;
    procedure read_comps;
    function getpnd(vt: TBaseVirtualTree; nd: pvirtualnode): pvirtualnode;
    procedure read_ch(bpbid: integer; ndc: pvirtualnode);
    function findndnm0tag(nm: string; tgg: integer): pvirtualnode;
    procedure newacl;
    procedure newport(ndcont: pvirtualnode);
    procedure read_acl(ndc: pvirtualnode);
    procedure read_ports(ndc: pvirtualnode);
    procedure vstLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure vstlocBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstlocChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    function fnnloc(ndo: PVirtualNode; sl: TStringList): PVirtualNode;
    procedure newlocterr;
    procedure vstlocCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstlocCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var Allowed: boolean);
    procedure vstlocDblClick(Sender: TObject);
    procedure vstlocDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      const Pt: TPoint; var Effect: longword; Mode: TDropMode);
    procedure vstlocGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: boolean;
      var ImageIndex: integer);
    procedure vstlocGetImageIndexEx(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: boolean; var ImageIndex: integer; var ImageList: TCustomImageList);
    procedure vstlocGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure newobjloc(titl: string; tg, sti, loctyp: integer);
    procedure clearmdll;
    procedure newsensor(ndport: pvirtualnode; code: integer);
    procedure read_sensors(ndp: pvirtualnode);
    function findbeforeinsert(s: string): integer;
    function selfupd(s: string): string;
    procedure vstlocLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure vstlocPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure vstlocSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure vstPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure vstStructureChange(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Reason: TChangeReason);
    procedure vstUpdating(Sender: TBaseVirtualTree; State: TVTUpdateState);
    function yesno(s: string): boolean;
    function getlastmyid(tbn: string): integer;
    procedure newlocat(slin: TStringList);
    function basenewlocat(ndo: pvirtualnode; slin: TStringList): integer;
    procedure readapplist;
    procedure rereadloc;
    procedure read_locations;
    procedure prdp;
    procedure readloctag1(slin: TStringList; ndo: pvirtualnode);
    function findndlockey(key: string): pvirtualnode;
    procedure setlocsensor(ev: string; sti: integer);
    procedure prolog;
    procedure readlocc(slin: TStringList; ndo: pvirtualnode);
    function fdeletend(vt: TLazVirtualStringTree; cnd: pvirtualnode): boolean;
    procedure readlocetaj(slin: TStringList; ndo: pvirtualnode);
    procedure onlyreadlocc(ndo: pvirtualnode);
    procedure read_locfloor(ndo: pvirtualnode);
    procedure newfloor(ndo: pvirtualnode);
    procedure toredlog(pr, txt: string);
    procedure zreadloctag1(ndo: pvirtualnode);
    procedure prdnext;
    procedure prdchild;
    function formirnd(ndo: pvirtualnode; slin: TStringList): pvirtualnode;
    function getndofabi(tree: TVirtualStringTree; abi: int64): PVirtualNode;
    procedure vtr_tobase(vt: TLazVirtualStringTree; node: pvirtualnode);
    function getvtrx(nm, apx: string; abi: integer): tmyrcvtr;
    procedure safevtr(vtx: TLazVirtualStringTree);
    procedure loadvtr(vtx: TLazVirtualStringTree);
    function fillinfoloc(abi: integer): tmyrcvtr;
    procedure filltreeloc;
    procedure xtag0;
    procedure xtag1(bp: integer; ndo: pvirtualnode);
    procedure xtag2(bp: integer; ndo: pvirtualnode);
    procedure rd_all_myid;
    procedure tree1(ndo: pvirtualnode; myid, bp: integer);
    function y_formirnode(myid: string): pvirtualnode;
    function y_getinfobymyid(myid: string): tmyrcvtr;
    procedure fillsqluzel;
    procedure showsqluzel;
    function findj(i: integer): integer;
    procedure face_ch_tsslife(bidcomp, bidch, spd, sumerr: string);
    function findvstndbymid(dbmyid, ttg: integer): pvirtualnode;
    function readtssparams(app, key: string): string;
    procedure showch_tsslife(ch_status, bidcomp, bidch, uxts, pidch: string;
      lastobs, vuxt: int64; launchline: string);
    procedure showch_chinfostart(ch_status, bidcomp, bidch, uxts, status, subcmd: string;
      lastobs: int64);
    procedure showch_chcurrinfo(ch_status, bidcomp, bidch, uxts, kpx,
      sumerr, speed, pidch: string;
      lastobs: int64);
    function findndofmyid(dbmyid: integer): pvirtualnode;
    function formirjb_toskud(kto, komu, subcmd, line: string): string;
    procedure show_guardlife(comp, kto, uxts, pid: string);
    procedure killonpid(pid: integer);
    procedure excmd(cmd: string; sl: TStringList);
    procedure exbat(fn: string);
    function fcrbat(sl: TStringList): string;
    procedure showsac209(js: string);
    procedure showsvc210(js: string);
    procedure launch210(Data: pvstrecord);
    function findndofbpbidnm(target_name: string;
      target_bpbid, target_tag: integer): pvirtualnode;
    function formirvirtsl(cnd: pvirtualnode): TStringList;
    function getprmtag3(dl: pvstrecordloc): pvstrecordloc;
    function getprmtag3nm(ndp: pvirtualnode; dl: pvstrecordloc): pvstrecordloc;
    // function  deleteloctagm3(ndp:pvirtualnode):integer;
    function deletechildloc(ndp: pvirtualnode; bp, tgg: integer): integer;
    procedure loctomarsrut(ndloc: pvirtualnode; sl: TStringList);
    function findchckndtag(vt: TLazVirtualStringTree; ttg: integer): TStringList;
    function findchckmarsnd: pvirtualnode;
    function findndportoflocsens(ndloc: pvirtualnode): tndmars;
    procedure formirmars(ndmars, ndloc, ndport, ndsens: pvirtualnode);
    function checklinkbploc(bploc: integer): boolean;
    function checklinkbps(bps: integer): boolean;
    procedure showdmslife(v: string);
    procedure formirndstarter(ndc: pvirtualnode);
    function calc_vstobstime(nd: pvirtualnode): integer;
    function getmarsforports(myid: integer): integer;
    procedure currreread;
    procedure currrereadloc;
    function x_linksens(nd: pvirtualnode): boolean;
    function findndlocofmyid(dbmyid: integer): pvirtualnode;
    procedure sensnodetostatevis(ndc: pvirtualnode; f: boolean);
    procedure formirjs_ac(cnd: pvirtualnode; subcmd: string);
    procedure show_acinfo(js: string);
    function addarmcmd(cmd: string): integer;
    function getlastidcmd: integer;
    function fidkomu(Data: pvstrecord): pvstrecord;
    procedure showtr(p: string; rc: integer);
    procedure showbase(p: string; rc: integer);
    function findndoftag(tgg: integer): pvirtualnode;
    procedure baseinfo(d: pvstrecord);




  private

  public

  end;

var
  Form1: TForm1;
  myos: string;
  ctrerr: int64;
  sltssparams: TStringList;
  mytmz: int64;
  trclientid: string;
  fmqttready: boolean;
  glbfmid: int64;
  mfiltr: string;
  currmtag: integer;
  auzel: array of tsqlauzel;
  sltree, sltrexe: TStringList;
  myprd: tmyprd;
  myrcvtr: tmyrcvtr;
  mysysinfo: tmysysinfo;
  filtr: string;
  osd, sysos: string;
  starttest, stoptest: qword;
  myrcdb: tmyrcdb;
  ap, app, appexe, appdir, zp: string;
  currnd, currndloc, firstnd, firstndloc: pvirtualnode;
  globalexit, fbroker: boolean;
  vglink: tglink;

implementation

{$R *.lfm}
uses unewloc, umdlog, ulazfunc, ueditcomp, ueditch, ubaselog, ueditacl, ueditport, ueditloc,
  ushowglink, uloccontrols, utunelocc, uformtest, uawarn, upgctr, uinfostart,
  usgevent, utestbox, usensedit, ulocedit,
  umars1, ureloadkeys, uformeditall, uformxtrans, uformstarter;

{ TForm1 }
{
Function TFORM1.GetLocalIP : String;
Var
   WSAData: TWSAData;
   P: PHostEnt;
   Name: array[0..$FF] of Char;
Begin
  WSAStartup($0101, WSAData);
  GetHostName(Name, $FF);
  P := GetHostByName(Name);
  Result := inet_ntoa(PInAddr(P.h_addr_list^)^);
  WSACleanup;
End;
}


function Tform1.findchckndtag(vt: TLazVirtualStringTree; ttg: integer): TStringList;
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
  form1.log('m', ' /cc=' + IntToStr(cc));
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
      Result := sl;
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
      Vt.Refresh;
    end;
  end;
  ShowMessage('text=' + sl.Text);
  Result := sl;

end;

function tform1.getpnd(vt: TBaseVirtualTree; nd: pvirtualnode): pvirtualnode;
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

function Tform1.fnnloc(ndo: PVirtualNode; sl: TStringList): PVirtualNode;
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

    if ndn = nil then
    begin
      ShowMessage('TUT NIL');
      exit;
    end;
    n := 2;
    Data := vstloc.GetNodeData(ndn);
    Data^.abi := vstloc.AbsoluteIndex(ndn)
  finally
  end;
  //  SHOWMESSAGE('================================================');
  //   SHOWMESSAGE('@@@@@='+sl.text);
  Data^.ndp := ndo;
  Data^.nm0 := sl.Values['nm0'];
  Data^.sti := StrToInt(sl.Values['sti']);
  n := 3;
  //log('m','n='+inttostr(n));
  // log('m','n='+inttostr(n)+' /sti1='+sl.Values['sti1']);
  Data^.sti1 := StrToInt(sl.Values['sti1']);
  //log('m','n='+inttostr(n));
  n := 4;
  Data^.tag := StrToInt(sl.Values['tag']);
  //log('m','n='+inttostr(n));
  // SHOWMESSAGE('FNNLOC NEW TAG='+INTTOSTR(data^.tag)+' stag='+sl.Values['tag']);
  n := 5;
  try
    Data^.smrn := sl.Values['smrn'];
    ;
  except
    Data^.smrn := '-1';
  end;

  try
    Data^.dbmyid := StrToInt(sl.Values['bpp']);
  except
    Data^.dbmyid := -1;
  end;
  n := 9;
  Data^.nm0 := sl.Values['nm0'];
  Data^.nm1 := sl.Values['nm1'];
  Data^.nm2 := sl.Values['nm2'];
  Data^.nm3 := sl.Values['nm3'];
  Data^.nm4 := sl.Values['nm4'];
  log('m', 'n=' + IntToStr(n));
  vstloc.Refresh;
  Result := ndn;



  //except
  // on ee:exception DO BEGIN
  //  form1.log('e','fnloc n='+inttostr(n)+' / eee='+ee.Message);
  // end;
  // end;

end;


function Tform1.fnn(ndo: PVirtualNode; sl: TStringList): PVirtualNode;
var
  ndn: PVirtualNode;
  Data: PVSTRecord;
  nm, s: string;
  i: integer;
begin

  try
    //VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions+[toCheckSupport];
    ndn := vst.AddChild(ndo);
    //  log('y','AFTER ADDCHILD ');
    if sl.Values['ndcheck'] = 'y' then
    begin
      ndn^.CheckType := ctTriStateCheckBox;
      if sl.Values['ndcheck_state'] = 'y' then
        vst.CheckState[ndn] := cscheckedNormal;
      if sl.Values['ndcheck_state'] <> 'y' then
        vst.CheckState[ndn] := csUncheckedNormal;

      if not (vsInitialized in ndn^.States) then  VST.ReinitNode(ndn, False);
      ndn^.CheckType := ctCheckBox;
      //Data := VST.GetNodeData(ndn);
    end;


    //if ndn=nil then begin
    // exit;
    //end;

    //log('y','fnn  NILLLLLLLLLLLLLLLLLLLLLL ?????????????????????????????????????????');;
    Data := vst.GetNodeData(ndn);
    Data^.ndp := ndo; //suda 1109
    Data^.nm0 := sl.Values['nm0'];
    Data^.sti := StrToInt(sl.Values['sti']);
    Data^.sti1 := StrToInt(sl.Values['sti1']);
    //log('c','sti='+sl.Values['sti']);
    Data^.tag := StrToInt(sl.Values['tag']);
    try
      Data^.dbmyid := StrToInt(sl.Values['myid']);
    except
      Data^.dbmyid := -1;
    end;
    Data^.nm1 := sl.Values['nm1'];
    Data^.nm2 := sl.Values['nm2'];
    Data^.nm3 := sl.Values['nm3'];
    Data^.nm4 := sl.Values['nm4'];
    vst.Refresh;
    Result := ndn;
    Data := vst.GetNodeData(ndn);
    // showmessage('fnn nm0='+data^.nm0);
  except
    on ee: Exception do
    begin
      // form1.log('e','fnewnode ,eee='+ee.Message);
    end;
  end;
end;

procedure TForm1.vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var NewState: TCheckState; var Allowed: boolean);
var
  dl: pvstrecord;
begin

  dl := vst.GetNodeData(node);
  // log('w','nm0='+dl^.nm0+' /dbmyid='+inttostr(dl^.dbmyid));
  if newstate = csCheckedNormal then  dl^.chkstate := True;
  if newstate = csUncheckedNormal then  dl^.chkstate := False;

  //  if dl^.chkstate=TRUE then form1.log('l','normal check')else form1.log('l','uncheck');
  // if newstate=csCheckedNormal then form1.log('l','normal');
  //form1.log('c','checking=');

end;

procedure TForm1.vstDblClick(Sender: TObject);
var
  d: pvstrecord;
begin
  d := vst.GetNodeData(currnd);
  showmessage('after d');
  if d^.tag = -1 then form1.currreread;
  xformedit.prepare(currnd);
  // if d^.tag=1 then begin  xformedit.pg1.ActivePageIndex:=0;  xformedit.Show; end;
  //if d^.tag=2 then begin  xformedit.pg1.ActivePageIndex:=1;  xformedit.Show; end;

end;

procedure TForm1.vstGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: boolean;
  var ImageIndex: integer);

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
  var Ghosted: boolean; var ImageIndex: integer; var ImageList: TCustomImageList);
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

procedure TForm1.toredlog(pr, txt: string);
var
  s: string;
begin
  exit;
  try
    s := 'insert into tss_redlog(app,oper,txt,tscd)values ( ' +
      ap + app + ap + zp + ap + pr + ap + zp + ap + txt + ap + zp +
      ' current_timestamp' + ');';
    log('w', 's=' + s);
    // exit;
    selfupd(s);
  except
    on e: Exception do
    begin

    end;
  end;

end;

procedure TForm1.log(pr, txt: string);
var
  oper, s: string;
begin
  FORMMDLOG.log(PR, TXT);
  exit;

  oper := 'u';
  mdll.DisableControls;
  mdll.Open;
  if mdll.RecordCount > 100 then
  begin
    //showmessage('log>100');
    mdll.First;
    while not mdll.EOF do
    begin
      mdll.edit;
      mdll.Delete;
    end;
  end;

  mdll.insert;
  mdll.FieldByName('nn').AsInteger := mdll.RecordCount + 1;
  mdll.FieldByName('pr').AsString := pr;
  mdll.FieldByName('txt').AsString := txt;
  mdll.post;
  s := 'insert into tss_redlog(tscd,app,oper,txt)values(' +
    ' current_timestamp ' + zp + ap + app + ap + zp + ap + oper + ap + zp +
    ap + txt + ap + ');';

  mdll.EnableControls;
  //formmdlog.show;
  if (pr = 'e') then  toredlog(pr, txt);
end;

procedure TForm1.timertestTimer(Sender: TObject);
begin

end;

procedure TForm1.vstBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PVSTRecord;
begin
  exit;
  Data := VST.GetNodeData(NODE);


  if node = vst.FocusedNode then
  begin
    targetcanvas.brush.Color := clAqua;
    targetcanvas.font.Color := clBlack;
    targetcanvas.rectangle(cellrect);

  end;
  if node = currnd then
  begin
    targetcanvas.brush.Color := clwhite;
    targetcanvas.font.Color := clBlack;
    targetcanvas.rectangle(cellrect);
  end;
end;



{
function tform1.getndofabi(Tree: TVirtualStringTree; abi: Integer): PVirtualNode;
var
   node: PVirtualNode;
begin
    Result := nil;

    node := tree.GetFirstChildNoInit(nil);
    while Assigned(node) do
    begin
       if node.AbsoluteIndex = abi then
       begin
          Result := node;
          Exit;
       end;
       node := Tree.GetNextNoInit(node);
    end;
end;

}



procedure TForm1.vstChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  nc, pid, pidch: integer;
  Data, datandp: pvstrecord;
  nm, dbmyid, stag, s: string;
  ndp: pvirtualnode;
  f: boolean;
  abi, idx, ldm0: string;
begin

  Data := vst.GetNodeData(node);
  if Data = nil then exit;
  CURRND := NODE;
  abi := IntToStr(vst.AbsoluteIndex(node));
  idx := IntToStr(node^.Index);
  ndp := form1.getpnd(vst, node);
  if ndp = nil then
  begin
    log('r', 'vstChange NDP=NIL');
    // EXIT;
  end;
  datandp := vst.GetNodeData(ndp);
  // oldm0:=datandp^.nm0;
  // log('c','oldnm0='+oldm0);
  //exit;

  log('y', 'tag=' + IntToStr(Data^.tag) + ' /abi=' + abi + ' /idx=' + idx);
  try
    datandp := vst.GetNodeData(node);
    ndp := Data^.ndp;
    nm := Data^.nm0;
    f := True;
  except
    f := False;
    log('e', 'error vstchange');
  end;


  if Data^.tag = -1 then
  begin
    //   log('y','popminus');
    vst.PopupMenu := popminus;
  end;
  if Data^.tag = 0 then
  begin
    // log('y','poptag0');
    vst.PopupMenu := poptag0;
  end;
  if Data^.tag = 1 then
  begin
    // log('y','poptag1');
    vst.PopupMenu := poptag1;
  end;
  if Data^.tag = 2 then
  begin
    // log('y','poptag1');
    vst.PopupMenu := poptag2;
  end;
  if Data^.tag = 3 then
  begin
    // log('y','poptag1');
    vst.PopupMenu := poptag3;
  end;

  if Data^.tag = 4 then
  begin
    s := 'myid=' + IntToStr(Data^.dbmyid) + zp + 'bploc=' + IntToStr(Data^.bploc);//suda0213
    Data^.nm1 := s;
    vst.PopupMenu := poptag4;
  end;

  stag := IntToStr(Data^.tag);
  dbmyid := IntToStr(Data^.dbmyid);
  if Data^.tag = 0 then pid := Data^.pidguard;
  if Data^.tag = 1 then pid := Data^.pidch;

  log('c', 'idkomu=' + Data^.idkomu + '/PID=' + IntToStr(pid) + ' /nd=' + Data^.nm0 +
    ' /tag= ' + stag + ' /dbmyid=' + dbmyid + ' /bp=' + IntToStr(Data^.bp) +
    ',chtype=' + Data^.chtype + ',ctyp=' + Data^.ctyp);

end;

function tform1.formirjb_toskud(kto, komu, subcmd, line: string): string;
var
  sj, s, cmd: string;
  jb: TJSONObject;
  jd: tjsondata;
begin

  log('y', 'formirjb_cmd');
  jb := TJSONObject.Create(['cmd', 'todrv', 'kto', kto,
    //umain.trclientid,
    'komu', komu, 'subcmd', subcmd,
    'line', line,
    'uxt', IntToStr(dateutils.DateTimeToUnix(now)),
    'cds', datetimetostr(now)]);

  sj := jb.AsJSON;
  log('r', 'time sj=' + sj);
  Result := sj;
  //formtrans.cltrans.doSendMsg('tss_mqtt',sj,false);  sudavagolo
  FreeAndNil(jb);

  // totrresurs(umain.trclientid,'all','tsslife',sj,8);

end;


procedure tform1.prolog;
var
  cn, FileDateTime, lint, s, s2: string;
  sl: TStringList;
  l, n, w: integer;
begin
{$IFDEF linux}
 myos:='linux';
{$ENDIF}
  if trim(myos) = '' then
  begin
    myos := 'windows';
    mysysinfo.os := myos;
    mysysinfo.sep := '\';
  end;
  if trim(myos) = 'linux' then
  begin
    myos := 'linux';
    mysysinfo.os := myos;
    mysysinfo.sep := '/';
  end;


  //showmessage('myos='+myos);
  appDir := ExtractFilePath(Forms.Application.ExeName);
  appExe := ExtractFileName(Forms.Application.ExeName);
  app := dmfunc.ExtractStr(1, appexe, '.');

  TIMERSTART.Enabled := False;
  form1.WindowState := wsMaximized;
  w := form1.Width;
  formmdlog.Top := 0;
  l := w - formmdlog.Width;
  formmdlog.Left := l;
  formmdlog.Show;
  formstarter.openstarter;
  formstarter.rereadstarter;
  cn := GetEnvironmentVariable('COMPUTERNAME');
  cn := lowercase(cn);
  //pancompname.caption:=cn;
  mysysinfo.computername := cn;
  //mysysinfo.os:=GetEnvironmentVariable('OS');
  mysysinfo.username := GetEnvironmentVariable('USERNAME');
  fbroker := False;

  log('y', 'alias=' + vglink.alias);
  log('y', 'state=' + vglink.state);
  formglink.xgconnect(vglink);
  //formmdlog.Top:=0;
  //formmdlog.left:=0;
  //formmdlog.show;
  log('y',
    'PROLOG ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  log('y',
    '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  log('y',
    '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  appDir := ExtractFilePath(Forms.Application.ExeName);
  appExe := ExtractFileName(Forms.Application.ExeName);
  app := dmfunc.ExtractStr(1, appexe, '.');
  if app = 'atss_guard' then fbroker := True;
  FileDateTime := FormatDateTime('YYYY.MM.DD hh:mm:ss',
    FileDateToDateTime(FileAge(appExe)));
  s := 'APP=' + appexe + ' VERSION=' + filedatetime + ' APPDIR=' + APPDIR;
  Caption := S;

  lint := readtssparams('comon', 'life_interval');
  //  showmessage('lint='+lint);
  log('y', 'lint=' + lint);
  n := StrToInt(lint);
  n := n * 1000;
  // showmessage('n='+inttostr(n));
  // formpgctr.timerlife.Interval:=n;
  // formpgctr.timerlife.Enabled:=true;
  //showmessage('prolog1');
    showmessage('p1');
  titlenode;
  reread;
  //showmessage('prolog 2');
  // readapplist;
  //titlenodeloc;
  fillsqluzel;
  showsqluzel;

  s2 := timetostr(time);
  s2 := dmfunc.ExtractStr(3, s2, ':');
  //s:=app+'_'+s2;
  s := app;

  log('w', 'BEFORE TRANSPORT GCONNECT');
  trclientid := GetEnvironmentVariable('COMPUTERNAME') + '#' + app;
  trclientid := LOWERCASE(trclientid);

  //sudavagolo
  formxtrans.gconnect(trclientid, mysysinfo.traddr);

  log('l', 'PROLOG ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  log('l', '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  log('l', '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  log('r', 'end  prolog');
  timer1s.Enabled := True;

end;

procedure TForm1.timerstartTimer(Sender: TObject);
begin
  timerstart.Enabled := False;
  prolog;

end;


procedure tform1.newlocat(slin: TStringList);
var
  sl: TStringList;
  abi, bpp: integer;
  s: string;
  dataloc: pvstrecordloc;
  nd: pvirtualnode;
begin
  // showmessage('newlocat='+slin.text);
  // sl:=tstringlist.Create;
  // sl.Values['nm0']:=slin.Values['name'];
  // sl.Values['sti']:=slin.Values['sti'];
  // sl.Values['tag']:=slin.Values['tag'];
  // showmessage('newlocat ='+slin.text);
  slin.Values['ndcheck'] := 'y';
  slin.Values['ndcheck_state'] := 'n';
  bpp := form1.basenewlocat(currndloc, slin);
  // showmessage('Newlocat='+slin.text+'  ///BPP='+inttostr(bpp));
  if bpp > 0 then
  begin
    slin.Values['bpp'] := IntToStr(bpp);
    nd := form1.fnnloc(currndloc, slin);
    dataloc := vstloc.GetNodeData(nd);
    abi := vstloc.AbsoluteIndex(nd);
    dataloc^.abi := abi;
    s := 'update tssloc_locations set abi=' + IntToStr(dataloc^.abi) +
      ' where myid=' + IntToStr(bpp);
    log('l', 'fnnloc s=' + s);
    //suda 1610
    selfupd(s);
    form1.safevtr(vstloc);
  end;

end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  //formmdlog.show;
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
var
  dataloc: pvstrecordloc;
  nd: pvirtualnode;
begin
  dataloc := vstloc.GetNodeData(currndloc);
  //showmessage('nm0='+dataloc^.nm0);
  //exit;
  ueditloc.cnd := currndloc;
  formeditloc.Show;
end;

procedure TForm1.MenuItem21Click(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to 1000 do
  begin
    application.ProcessMessages;
    form1.toredlog('r', 'testredlog ' + IntToStr(i));
  end;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin
  form1.fdeletend(vst, currnd);
     {
      sl:=tstringlist.Create;;
      for i:=1 to 100 do begin
        sl.Values['nm0']:=inttostr(i);
        sl.Values['nm1']:=inttostr(i)+' nm1';
        sl.Values['tag']:='5';
        sl.Values['sti']:='25';
        sl.Values['sti1']:='31';
        sl.Values['tag']:='5';
        sl.Values['ndcheck']:='y';
        sl.Values['ndcheck_state']:='n';
      fnn(currnd,sl);
      fnnloc(currndloc,sl);
      end;
      }
end;

procedure TForm1.MenuItem23Click(Sender: TObject);
begin
  fdeletend(vstloc, currndloc);
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
begin
  // showmessage('call newfloor');
  newfloor(currndloc);
end;

procedure tform1.newobjloc(titl: string; tg, sti, loctyp: integer);
var
  sl: TStringList;
  i: integer;
  nd: pvirtualnode;
  dataloc: pvstrecordloc;
begin
  sl := TStringList.Create;
  sl.Values['nm0'] := titl;
  sl.Values['nm1'] := titl;
  sl.Values['tag'] := IntToStr(tg);
  sl.Values['sti'] := IntToStr(sti);
  sl.Values['sti1'] := '31';
  sl.Values['ndcheck'] := 'y';
  sl.Values['ndcheck_state'] := 'n';
  nd := fnnloc(currndloc, sl);
  dataloc := vstloc.GetNodeData(nd);
  dataloc^.loctype := loctyp;
  VSTloc.Expanded[currnd] := True;  // suda22 no expand ; nado parent

end;

procedure TForm1.MenuItem25Click(Sender: TObject);
var
  dataloc: pvstrecordloc;
  nd: pvirtualnode;
begin
  dataloc := vstloc.GetNodeData(currndloc);
  ueditloc.cnd := currndloc;
  formeditloc.Show;

end;


procedure TForm1.MenuItem26Click(Sender: TObject);
begin
  form1.fdeletend(vst, currnd);
end;

procedure tform1.clearmdll;
begin

  mdll.DisableControls;
  mdll.Open;
  mdll.First;
  while not mdll.EOF do
  begin
    mdll.edit;
    mdll.Delete;
  end;
  mdll.EnableControls;

end;

procedure TForm1.MenuItem27Click(Sender: TObject);
begin
  clearmdll;
end;

procedure TForm1.MenuItem28Click(Sender: TObject);
var
  nm0, s: string;
  dataloc: pvstrecordloc;
begin
  dataloc := vstloc.GetNodeData(currndloc);
  nm0 := dataloc^.nm0;
  form1.fdeletend(vstloc, currndloc);


  //  showmessage('nm0='+nm0);
  vglink.sqline := 'delete from tssloc_floor where name=' + ap + nm0 + ap;
  //showmessage('s='+s);
  log('y', 's=' + s);
  log('l', 'line=' + vglink.sqline);
  myrcdb := formglink.gupd;
end;

procedure TForm1.MenuItem29Click(Sender: TObject);
begin
  newfloor(currndloc);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
var
  crdrs, crbw, i, cn: integer;
  nm: string;
begin
  crdrs := 10;
  crbw := 4;
  cn := 1;
  for i := 1 to crdrs do
  begin
    nm := 'WIN_' + IntToStr(cn);
    log('c', 'i=' + IntToStr(i) + ' / cn=' + IntToStr(cn) + '/ ' + nm);
    cn := cn + 1;
    if cn > crbw then
    begin
      cn := 1;
    end;
  end;

end;

procedure TForm1.MenuItem30Click(Sender: TObject);
begin
  form1.prdp;
end;

procedure TForm1.MenuItem31Click(Sender: TObject);
var
  fn: string;
begin

  fn := appdir + 'vtr' + osd + app + osd + 'vst.tree';
  log('y', 'fn=' + fn);
  vst.SaveToFile(fn);
  //vst.Clear;
  //vst.LoadFromFile(fn);

end;

procedure TForm1.MenuItem32Click(Sender: TObject);
begin
  ShowMessage('в работе');
end;

procedure TForm1.MenuItem33Click(Sender: TObject);
begin
  log('y', 'add sensors');

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

function TForm1.getlastidcmd: integer;
var
  qrz: TSQLQuery;
  cd, s: string;
begin
  try
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    selftr.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    cd := datetostr(now);
    cd := dmfunc.ZZdate(cd);
    s := 'select idcmd from tss_armcmd where cd=' + ap + cd + ap +
      ' order by myid desc limit 1';
    log('w', 'getlastidcmd=' + s);
    qrz.SQL.Add(s);
    qrz.Active := True;
    if qrz.RecordCount = 0 then Result := 1
    else
      Result := qrz.FieldByName('idcmd').AsInteger + 1;
    qrz.Close;
  except
    on e: Exception do
    begin
      log('e', 'getlastidcmd,e=' + e.Message);
    end;

  end;

end;

function TForm1.addarmcmd(cmd: string): integer;
var
  qrz: TSQLQuery;
  cd, s: string;
  idcmd: integer;
begin
  try
    Result := -1;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    selftr.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(' begin; ');
    cd := datetostr(now);
    cd := dmfunc.ZZdate(cd);
    idcmd := getlastidcmd;
    log('w', 'idcmd=' + IntToStr(idcmd));

    s := 'insert into tss_armcmd(idcmd,comp,cd,cmd,app,idoper) values (' +
      IntToStr(idcmd) + zp + ap + mysysinfo.computername + ap + zp +
      ap + cd + ap + zp + ap + cmd + ap + zp + ap + app + ap + zp + '6)';
    qrz.SQL.Add(s);
    log('l', 's=' + s);
    //qrz.SQL.Add(' commit;');
    qrz.Transaction := selftr;
    qrz.ExecSQL;
    // qrz.Close;
    selftr.Commit;
    Result := idcmd;
    exit;
    log('w', 'addarmcmd AFTER COMMIT');
    qrz.SQL.Clear;
    s := 'select idcmd  from tss_armcmd where cd=' + ap + cd + ap + ' order by myid desc limit 1';
    qrz.SQL.Add(s);
    qrz.Active := True;
    Result := qrz.FieldByName('idcmd').AsInteger;
    log('y', 'addarmcmd id=' + IntToStr(Result));
  except
    on e: Exception do
    begin
      log('e', 'adddarmcmd,e=' + e.Message);
    end;
  end;

end;



function TForm1.selfupd(s: string): string;
var
  qrz: TSQLQuery;
begin
  try
    Result := 'ok';
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    selftr.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(' begin; ');
    qrz.SQL.Add(s + ' ;');
    qrz.SQL.Add(' commit;');
    qrz.Transaction := selftr;
    qrz.ExecSQL;
    selftr.Commit;
    log('w', 'selfuppd AFTER COMMIT');
  except
    on e: Exception do
    begin
      log('e', 'selfuppd,e=' + e.Message);
      Result := e.Message;
    end;
  end;

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

procedure TForm1.vstlocPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  dataloc: pvstrecordloc;
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
  if (dataloc^.tag = -2) then
  begin
    TargetCanvas.Font.Color := clsilver;   //   suda fontcolor

  end;
  if (dataloc^.tag = 3) then
  begin
    TargetCanvas.Font.Color := clsilver;   //   suda fontcolor
  end;

  if (dataloc^.tag = -3) and (dataloc^.bps > 0) and (Column = 1) and
    (checklinkbps(dataloc^.bps)) then
  begin
    TargetCanvas.Font.Color := claqua;   //   suda0203 fontcolor
  end;

  if (dataloc^.tag = 3) and (dataloc^.bps > 0) and (Column = 2) then
  begin
    TargetCanvas.Font.Color := clred;   //   suda fontcolor
    TargetCanvas.Font.Size := 16;
  end;

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


function tform1.checklinkbps(bps: integer): boolean;
var
  s: string;
  qrz: TSQLQuery;
begin
  try
    Result := False;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    s := ' select bploc from tss_sensors where myid=' + IntToStr(bps) + ' and bploc>0';
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

function tform1.checklinkbploc(bploc: integer): boolean;
var
  s: string;
  qrz: TSQLQuery;
begin
  try
    Result := False;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    s := ' select count(*) from tssloc_locations where myid=' + IntToStr(bploc);
    qrz.SQL.Add(s);
    qrz.Active := True;
    if qrz.RecordCount > 0 then Result := True;
  except
    on e: Exception do
    begin
      log('e', 'checklinkbploc,e=' + e.message);
    end;
  end;

end;


procedure TForm1.vstPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: pvstrecord;
begin
  Data := vst.GetNodeData(node);
  //if column=1 then begin
  if (Data^.tag = -1) then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor
  end;
  if (Data^.tag = 1) then
  begin
    TargetCanvas.Font.Color := clsilver;   //   suda fontcolor
  end;

  if (Data^.tag = 4) and (Data^.bploc > 0) and checklinkbploc(Data^.bploc) then
  begin
    TargetCanvas.Font.Color := claqua;   //   suda0203 fontcolor
  end;

  if (Data^.tag = 0) and (Data^.sti = 42) then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor
  end;
  if (Data^.tag = 1) and (Data^.sti = 41) then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor
  end;
  if (Data^.tag = -100) and (Data^.sti = 42) and (column = 1) then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor
  end;
  if (Data^.tag = -101) and (Data^.sti = 42) and (column = 1) then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor
  end;
  if (Data^.tag = -109) and (Data^.sti = 42) and (column = 1) then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor
  end;
  if (Data^.tag = -111) and (Data^.sti = 42) and (column = 1) then
  begin
    TargetCanvas.Font.Color := cllime;   //   suda fontcolor
  end;
  if (Data^.tag = -111) and (Data^.sti = 44) and (column = 1) then
  begin
    TargetCanvas.Font.Color := clred;   //   suda fontcolor
  end;
  if (not Data^.act) and ((Data^.tag = 0) or (Data^.tag = 1) or (Data^.tag = 2)) then
  begin
    TargetCanvas.Font.Color := clskyblue;   //   suda vstfontcolor
  end;

end;

procedure tform1.vtr_tobase(vt: TLazVirtualStringTree; node: pvirtualnode);
var
  Data: pvstrecord;
  vtname, nm0, nm1, s: string;
  abi, bp, tgg, bpp, sti, loccode, myid: integer;
begin
  vtname := vt.Name;
  Data := vt.GetNodeData(node);
  abi := vt.AbsoluteIndex(node);
  bp := Data^.bp;
  tgg := Data^.tag;
  bp := Data^.sti;
  //bpp:=data^.bpp;
  //loccode:=data^.loccode;
  myid := Data^.dbmyid;
  nm0 := Data^.nm0;
  nm1 := Data^.nm1;
  s := 'insert into tss_vtr(abi,bp,tag,sti,name,app,nm0,nm1) values(' +
    IntToStr(abi) + zp + IntToStr(bp) + zp + IntToStr(tgg) + zp +
    IntToStr(sti) + zp + ap + vtname + ap + zp + ap + app + ap + zp +
    ap + nm0 + ap + zp + ap + nm1 + ap + ');';
  selfupd(s);
  log('c', 'vtr_tobase =' + s);

end;

procedure TForm1.vstSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Stream: TStream);
var
  Writer: TWriter;
  Data: pvstrecord;
  newnode: pvirtualnode;
  abi, nm: string;
  sz: integer;

begin
  sz := SizeOf(tpvstrecord);
  Data := vst.GetNodeData(node);
  abi := IntToStr(vst.AbsoluteIndex(node));
  nm := Data^.nm0 + abi;
  log('w', 'nmabi=' + nm);
  //  log('w','nm0='+nm+' /tag='+inttostr(data^.tag)+inttostr(data^.dbmyid)+' /abi='+abi);
  // log('y','nm0='+data^.nm0+' /nm1='+data^.nm1);
  //Writer:=TWriter.Create(Stream,8096);
  Writer := TWriter.Create(Stream, sz);
  Data := Sender.GetNodeData(Node);
  //Writer.WriteString(NewNode.NameNode);
  Writer.WriteString(nm);
  //   vtr_tobase(vst,node);
  FreeAndNil(Writer);

end;

procedure TForm1.vstStructureChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Reason: TChangeReason);
begin
  // log('r','vstStructureChange');
end;

procedure TForm1.vstUpdating(Sender: TBaseVirtualTree; State: TVTUpdateState);
begin
  //  log('r','vstUpdating');
end;

{
procedure TForm1.VirtualStringTree1SaveNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var
 Writer:TWriter;
begin
   Writer:=TWriter.Create(Stream,8096);
   NewNode:=Sender.GetNodeData(Node);
   Writer.WriteString(NewNode.NameNode);
   FreeAndNil(Writer);
end;
}
procedure TForm1.currreread;
begin
  titlenode;
  reread;
end;

procedure TForm1.MenuItem34Click(Sender: TObject);
var
  Data: pvstrecord;
  dbmyid: integer;
  s: string;
begin
  if yesno(
    ' Вы действительно хотите удалить порт и все дочерние элементы') then
  begin
    Data := vst.GetNodeData(currnd);
    dbmyid := Data^.dbmyid;
    // showmessage(inttostr(dbmyid));
    s := 'delete from tss_sensors where bp=' + IntToStr(dbmyid);
    selfupd(s);
    s := 'delete from tss_ports where myid=' + IntToStr(dbmyid);
    selfupd(s);
    currreread;

  end;

end;

procedure TForm1.MenuItem35Click(Sender: TObject);
var
  Reply: integer;
begin
  EXIT;

{
 BoxStyle := MB_ICONQUESTION + MB_YESNO;
 Reply := Application.MessageBox('Press either button', 'MessageBoxDemo', BoxStyle);
 if Reply = IDYES then Application.MessageBox('Yes       ', 'Reply',MB_ICONINFORMATION)
   else Application.MessageBox('No         ', 'Reply', MB_ICONHAND);
   //else Application.MessageBox('No         ', 'Reply', MB_YESNOCANCEL);
}
end;

procedure TForm1.MenuItem36Click(Sender: TObject);
begin
  formeditloc.Show;

end;

procedure TForm1.MenuItem37Click(Sender: TObject);
begin
  titlenode;
  reread;
end;

procedure TForm1.MenuItem38Click(Sender: TObject);
begin
  formshowglink.Show;
end;

procedure TForm1.MenuItem39Click(Sender: TObject);
begin
  readapplist;
end;

function tform1.readtssparams(app, key: string): string;
var
  k, s: string;
  qrz: TSQLQuery;
begin

  s := 'select * from tss_params where  app=' + ap + app + ap + ' and key=' +
    ap + key + ap + ' limit 1';
  log('l', 's=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.DataBase := formglink.pqc1;
  qrz.SQL.Add(s);
  qrz.Active := True;
  Result := trim(qrz.FieldByName('value').AsString);

end;

function tform1.getvtrx(nm, apx: string; abi: integer): tmyrcvtr;
var
  mx: tmyrcvtr;
  s: string;
  qrz: TSQLQuery;
begin
  s := 'select * from tss_vtr where name=' + ap + nm + ap + ' and app=' + ap + apx + ap +
    ' and abi=' + IntToStr(abi) + ' limit 1';
  // log('y','s='+s);
  qrz := TSQLQuery.Create(self);
  qrz := formglink.gselqr(s);
  mx.Name := qrz.FieldByName('name').AsString;
  mx.nm0 := qrz.FieldByName('nm0').AsString;
  mx.nm1 := qrz.FieldByName('nm1').AsString;
  mx.sti := qrz.FieldByName('sti').AsInteger;
  mx.tag := qrz.FieldByName('tag').AsInteger;
  Result := mx;

end;

procedure TForm1.readapplist;
var
  k, v, nm, s: string;
  qrz: TSQLQuery;
  i: integer;
begin

  s := 'select * from tssgls_applist order by name';
  qrz := TSQLQuery.Create(self);
  qrz := formglink.gselqr(s);
  while not qrz.EOF do
  begin
    nm := qrz.FieldByName('name').AsString;
    slpayload_life.Values[nm] := 'nm';
    slpayload_life.Values['mess'] := 'und';
    qrz.Next;
  end;

  for i := 0 to slpayload_life.Count - 1 do
  begin
    k := slpayload_life.Names[i];
    v := slpayload_life.values[k];
    log('l', 'k=' + k + ' /v=' + v);
  end;

  //showmessage(slpayload_life.text);

end;


procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  VST.FullCollapse(nil);
end;

procedure TForm1.MenuItem40Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem41Click(Sender: TObject);
var
  fn: string;
begin
  titlenode;
  reread;

end;

procedure TForm1.MenuItem42Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem43Click(Sender: TObject);
begin
  formtest.Show;
end;

procedure tform1.loadvtr(vtx: TLazVirtualStringTree);
var
  fn, nm, s: string;
begin
  try
    nm := vtx.Name;
    //  s:='delete from tssloc_sls';
    //  form1.selfupd(s);
    if nm = 'vst' then
    begin
      fn := appdir + 'vst\vsttree.tr';
      vst.LoadFromFile(fn);
    end;
    if nm = 'vstloc' then
    begin
      fn := appdir + 'vst\vstloctree.tr';
      if not fileexists(fn) then
      begin
        form1.titlenodeloc;
        exit;
      end;
      vstloc.LoadFromFile(fn);
      //dmfunc.MyDelay(50);
      filltreeloc;
      vstloc.Refresh;
    end;

  except
    on e: Exception do
    begin
      log('e', 'savevtr,e=' + e.message);
    end;
  end;
end;


procedure tform1.safevtr(vtx: TLazVirtualStringTree);
var
  fn, nm, s: string;
begin
  try
    nm := vtx.Name;
    //  s:='delete from tssloc_sls';
    //  form1.selfupd(s);
    if nm = 'vst' then
    begin
      fn := appdir + 'vst\vsttree.tr';
      vst.SaveToFile(fn);
    end;
    if nm = 'vstloc' then
    begin
      fn := appdir + 'vst\vstloctree.tr';
      vstloc.SaveToFile(fn);
    end;
  except
    on e: Exception do
    begin
      log('e', 'savevtr,e=' + e.message);
    end;
  end;
end;

procedure TForm1.MenuItem44Click(Sender: TObject);
var
  fn, s: string;
begin
  try
    s := 'delete from tssloc_sls';
    form1.selfupd(s);
    fn := appdir + 'vst\tree.tr';
    //  glbsls1.Clear;
    vstloc.SaveToFile(fn);
  except
    on e: Exception do
    begin
      log('e', 'MenuItem44Click,e=' + e.message);
    end;
  end;

end;

procedure TForm1.MenuItem45Click(Sender: TObject);
begin
  fdeletend(vstloc, currndloc);
end;

procedure TForm1.MenuItem46Click(Sender: TObject);
var
  dataloc: pvstrecordloc;
  nd: pvirtualnode;
begin
  unewloc.regim := 'new';
  unewloc.cnd := currndloc;
  formnewloc.addnewloc(currndloc, regim);
end;

procedure TForm1.MenuItem47Click(Sender: TObject);
var
  Data, datandp: pvstrecord;
  ndp: pvirtualnode;
begin
  Data := vst.GetNodeData(currnd);
  ndp := Data^.ndp;
  datandp := vst.GetNodeData(ndp);
  ShowMessage(datandp^.nm0);

end;

procedure TForm1.MenuItem48Click(Sender: TObject);
var
  Data, datandp: pvstrecordloc;
  nd, ndp: pvirtualnode;
begin

  Data := vstloc.GetNodeData(currndloc);
  //nd:=vstloc.AddChild(currnd);
  //nd:=currnd;
  //data:=vstloc.GetNodeData(nd);
  Data^.nm0 := 'test1';
  Data^.sti := 21;
  Data^.sti1 := -1;
  vstloc.CheckState[currndloc] := csUncheckedNormal;
  currndloc^.CheckType := ctCheckBox;
  vstloc.Refresh;
  exit;

  //nd^.CheckType := ctTriStateCheckBox;
      {
       vstloc.CheckState[nd]:= csUncheckedNormal;
       nd^.CheckType := ctCheckBox;
       vstloc.Refresh;
       dmfunc.MyDelay(2000);

       vstloc.CheckState[nd]:= cscheckedNormal;
       nd^.CheckType := ctCheckBox;
       vstloc.Refresh;
       dmfunc.MyDelay(2000);
       data:=data;

       }
  dmfunc.MyDelay(2000);
  beep;

  nd^.CheckType := ctCheckBox;
  vstloc.CheckState[nd] := cscheckedNormal;
  nd^.CheckType := ctCheckBox;
  vstloc.Refresh;
  dmfunc.MyDelay(2000);
  vstloc.CheckState[nd] := csUncheckedNormal;
  nd^.CheckType := ctCheckBox;
  vstloc.Refresh;



        {
        //showmessage(data^.nm0);
        ndp:=data^.ndp;
        datandp:=vstloc.GetNodeData(ndp);
       // showmessage(datandp^.nm0);
       }
       {

       vstloc.CheckState[currndloc]:= csUncheckedNormal;
       vstloc.CheckState[currndloc]:= csUncheckedNormal;
       vstloc.Refresh;
       log('l','csUncheckedNormal');
       }
end;

procedure tform1.newfloor(ndo: pvirtualnode);
var
  dataloc, datalocndp: pvstrecordloc;
  bp, rc, s, Value: string;
  sl: TStringList;
  ndp: pvirtualnode;
begin

  // exit;
  dataloc := vstloc.GetNodeData(ndo);
  bp := IntToStr(dataloc^.dbmyid);
  datalocndp := vstloc.GetNodeData(ndp);

  ShowMessage('nm0=' + datalocndp^.nm0);
  if Inputsg('Введите название этажа', Value) then
  begin
    ShowMessage('value=' + Value);
    s := 'insert into tssloc_floor(name,bp)values(' + ap + Value + ap +
      zp + bp + ')';
    log('y', 'newfloor s=' + s);
    rc := selfupd(s);
    if rc = 'ok' then
    begin

    end;

  end;
end;

procedure TForm1.MenuItem49Click(Sender: TObject);
var
  dataloc: pvstrecordloc;
begin
  dataloc := vstloc.GetNodeData(currndloc);
  ueditloc.cnd := currndloc;
  formeditloc.Show;
end;

{
procedure tform1.newac(v:string);
var
  sl:tstringlist;
  NDO,ND:PVIRTUALNODE;
  s:string;
begin

     sl:=tstringlist.Create;
     sl.Values['nm0']:=v;
     sl.Values['sti']:='3';
     sl.Values['sti1']:='31';
     sl.Values['tag']:='1';
     sl.Values['ndcheck']:='y';
     sl.Values['ndcheck_state']:='n';
     //s:='insert into tss_acl(actua;bp,ac,cp)'
     ND:=fnn(currnd,sl);;
     VST.Expanded[currnd]:=true;

end;
}


procedure tform1.newcomp;
var
  sl: TStringList;
  NDO, ND: PVIRTUALNODE;
  s: string;
  rc: boolean;
  act, acts: string;
  actb: boolean;
  myrcdb: tmyrcdb;
  n: integer;
begin

  sl := TStringList.Create;
  sl.Values['nm0'] := vglink.sl.Values['name'];
  sl.Values['sti'] := '-1'; //'24';
  sl.Values['sti1'] := '-1';
  sl.Values['tag'] := '0';
  sl.Values['ndcheck'] := 'n';
  sl.Values['ndcheck_state'] := 'n';

  vglink.sqline :=
    'insert into tss_comps(tscd,bp,actual,name,url,state,pctyp,adress,legenda)values(' +
    ' current_timestamp ' + ',' + '-1' + ',' + vglink.sl.Values['actual'] + ',' +
    ap + vglink.sl.Values['name'] + ap + ',' + ap + vglink.sl.Values['url'] + ap + ',' +
    ap + vglink.sl.Values['state'] + ap + ',' + ap + vglink.sl.Values['comtyp'] + ap + ',' +
    ap + vglink.sl.Values['adress'] + ap + ',' + ap + vglink.sl.Values['legenda'] + ap +
    ');';
  log('m', 'sqline =' + vglink.sqline);
  s := 'select * from tss_comps where name=' + ap + sl.Values['nm0'] + ap;
  n := findbeforeinsert(s);
  if n > 0 then
  begin
    log('r', 'n=' + IntToStr(n));
    ShowMessage(
      'Дубль. Такое значение уже есть в базе. Исправте и повторите !!!');
    exit;
  end;
  myrcdb := formglink.gupd;

  if myrcdb.fullmess <> 'ok' then ShowMessage(myrcdb.rusmes);
  if myrcdb.fullmess = 'ok' then
  begin
    fnn(currnd, sl);
    //VST.Expanded[currnd]:=true;
    //vst.refresh;
  end;
  titlenode;
  REREAD;

end;

procedure tform1.newlocterr;
var
  sl: TStringList;
  NDO, ND: PVIRTUALNODE;

  rc: boolean;
  act, acts, bp, ter: string;
  Data: pvstrecordloc;
  actb: boolean;
begin
  Data := vstloc.GetNodeData(firstndloc);
  bp := IntToStr(Data^.dbmyid);
  sl := TStringList.Create;
  inputsg('ВВЕДИТЕ НАЗВАНИЕ ТЕРРИТОРИИ', ter);
  sl.Values['nm0'] := ter;
  sl.Values['sti'] := '31';
  sl.Values['sti1'] := '31';
  sl.Values['tag'] := '0';
  sl.Values['ndcheck'] := 'y';
  sl.Values['ndcheck_state'] := 'n';
  ND := fnnloc(currndloc, sl);
  ;
  VSTLOC.Expanded[currnd] := True;

end;

procedure TForm1.vstlocCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  dl: pvstrecordloc;
begin
  dl := vstloc.GetNodeData(node);
  log('y', 'vstlocCollapsed=' + dl^.nm0);
end;

procedure TForm1.vstlocCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var Allowed: boolean);
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

procedure TForm1.vstlocDragDrop(Sender: TBaseVirtualTree; Source: TObject;
  DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
  const Pt: TPoint; var Effect: longword; Mode: TDropMode);
begin

  log('l', 'vstlocDragDrop');
end;

procedure TForm1.vstlocGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: boolean; var ImageIndex: integer);

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
  var Ghosted: boolean; var ImageIndex: integer; var ImageList: TCustomImageList);
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
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);

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



procedure tform1.newch(ndc: pvirtualnode; v: string);
var
  sl: TStringList;
  NDO, ND: PVIRTUALNODE;
  rc: boolean;
  act, acts, bp, s: string;
  Data: pvstrecord;
  actb: boolean;
  myrcdb: tmyrcdb;
  n: integer;
begin
  Data := vst.GetNodeData(ndc);
  bp := IntToStr(Data^.dbmyid);

  //SHOWMESSAGE('NEWCH='+vglink.sl.text);
  sl := TStringList.Create;
  sl.Values['nm0'] := v;
  sl.Values['sti'] := '-1';//'12';
  sl.Values['sti1'] := '-1';
  sl.Values['tag'] := '1';
  sl.Values['ndcheck'] := 'n';
  sl.Values['ndcheck_state'] := 'n';
  // ND:=fnn(currnd,sl);;
  VST.Expanded[currnd] := True;
  //showmessage('newch='+vglink.sl.text);
  act := vglink.sl.Values['actual'];
  if act = '0' then acts := 'false';
  if act = '-1' then acts := 'true';
    {
    vglink.sqline:='insert into tss_ch(tscd,bp,actual,ch,app)values('+
    ' current_timestamp '+zp+
    bp+','+
    vglink.sl.Values['actual']+','+ap+ vglink.sl.Values['ch']+ap+','+
      ap+vglink.sl.Values['app']+ap+
      ');';

      s:='select * from tss_ch where bp='+bp+' and  ch='+ap+sl.Values['ch']+ap;
      log('y','FFFFF s='+s);
      n:=findbeforeinsert(s);
      if n>0 then begin
       log('y','n='+inttostr(n));
       showmessage('Дубль. Такое значение уже есть в базе. Исправьте и повторите !!!');
       exit;
      end;
     }
  log('w', 'newch BEFORE =' + vglink.sqline);
  log('w', 'newch BEFORE =' + vglink.sqline);
  log('w', 'newch BEFORE =' + vglink.sqline);
  log('w', 'newch BEFORE =' + vglink.sqline);
  //showmessage('newch='+vglink.sqline);
  myrcdb := formglink.gupd;
  if myrcdb.fullmess <> 'ok' then ShowMessage(myrcdb.rusmes);
  if myrcdb.fullmess = 'ok' then
  begin
    fnn(currnd, sl);
    // VST.Expanded[currnd]:=true;
    titlenode;
    REREAD;
    vst.refresh;
  end;

end;

procedure tform1.titlenodeloc;
var
  sl: TStringList;
  i: integer;
begin
  try
    log('m', 'titlenodeloc start');
    vstloc.Clear;
    sl := TStringList.Create;
    i := 1;
    sl.Values['nm0'] := 'ДЕРЕВО ЛОКАЦИЙ ';
    //sl.Values['nm1']:='BASE postgreS='+VGLINK.state;
    sl.Values['sti'] := '25';
    sl.Values['sti1'] := '-1';
    sl.Values['tag'] := '-1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    i := 2;
    firstndloc := fnnloc(nil, sl);
    i := 3;
    rereadloc;
  except
    on e: Exception do
    begin
      log('e', 'titlenodeloc,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;

end;

procedure tform1.titlenode;
var
  sl: TStringList;
begin
  vst.Clear;

  sl := TStringList.Create;
  sl.Values['nm0'] := 'ДЕРЕВО ОБЪЕКТОВ  ';
  //sl.Values['nm1']:='BASE postgreS='+VGLINK.state;
  sl.Values['sti'] := '-1';
  sl.Values['sti1'] := '-1';
  sl.Values['tag'] := '-1';
  sl.Values['ndcheck'] := 'y';
  sl.Values['ndcheck_state'] := 'n';
  firstnd := fnn(nil, sl);
  //log('l','titlenode AFTER FNN');
  //exit;

end;

procedure TForm1.vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: pvstrecord;
begin
  Data := Sender.GetNodeData(node);
  CellText := '';

  if column = 0 then
  begin
    CellText := Data^.nm0;
  end;
  if column = 1 then
  begin
    CellText := Data^.nm1;
  end;
  if column = 2 then
  begin
    CellText := Data^.nm2;
  end;

end;


procedure TForm1.MenuItem4Click(Sender: TObject);
var
  sl: TStringList;
begin

  log('l', 'newnode ??????????????????');
  titlenode;
end;

procedure TForm1.MenuItem50Click(Sender: TObject);
var
  Data, datandp: pvstrecordloc;
  ndp: pvirtualnode;
begin
  Data := vstloc.GetNodeData(currndloc);
  ShowMessage(Data^.nm0);
  ndp := Data^.ndp;
  datandp := vstloc.GetNodeData(ndp);
  ShowMessage(datandp^.nm0);

end;

procedure TForm1.MenuItem51Click(Sender: TObject);
var
  Data, datandp: pvstrecord;
  ndp: pvirtualnode;
begin
  Data := vst.GetNodeData(currnd);
  ndp := Data^.ndp;
  datandp := vst.GetNodeData(ndp);
  ShowMessage(datandp^.nm0);

end;

procedure TForm1.MenuItem52Click(Sender: TObject);
begin
  formloccontrols.Show;
end;

procedure TForm1.MenuItem53Click(Sender: TObject);
var
  i: integer;
begin
  log('r', 'ttttttttttttttttttttttttttttttttttttt');
  log('s', 'clskyblue=' + datetimetostr(now));
  log('l', 'now=' + datetimetostr(now));
  log('y', 'now=' + datetimetostr(now));
  log('c', 'now=' + datetimetostr(now));
  log('b', 'now=' + datetimetostr(now));
  log('m', 'now=' + datetimetostr(now));
  log('g', 'now=' + datetimetostr(now));
  log('s', 'now=' + datetimetostr(now));
  log('w', 'now=' + datetimetostr(now) +
    'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
  for i := 1 to 5 do
  begin
    log('r', datetimetostr(now));
  end;
end;

procedure TForm1.MenuItem54Click(Sender: TObject);
begin
  log('y', 'test1');
end;

procedure TForm1.MenuItem55Click(Sender: TObject);
begin
  formloccontrols.Show;
  formloccontrols.pget1;
end;

procedure TForm1.MenuItem56Click(Sender: TObject);
var
  rc, s: string;
  Data: pvstrecord;
  nd: pvirtualnode;
  dataloc: pvstrecordloc;
  bpp, bps: integer;
begin
  //showmessage(inttostr(vst.SelectedCount));
  nd := vst.GetFirstSelected();
  Data := vst.GetNodeData(nd);
  dataloc := vstloc.GetNodeData(currndloc);
  //log('y','linksens='+inttostr(data^.dbmyid)+'/tag='+inttostr(data^.tag));
  if (Data^.tag = 4) and (dataloc^.tag = 3) then
  begin
    bps := Data^.dbmyid;
    bpp := Data^.bp;
    s := 'update tssloc_controls set bps=' + IntToStr(bps) + ',bpp=' + IntToStr(bpp) +
      ' where myid=' + IntToStr(dataloc^.dbmyid);
    log('y', 'LINKSENS s=' + s);
    rc := form1.selfupd(s);
    if rc <> 'ok' then ShowMessage('1  NOT OK');
    s := 'update tss_sensors set bploc=' + IntToStr(dataloc^.dbmyid) +
      ' where myid=' + IntToStr(Data^.dbmyid);
    rc := form1.selfupd(s);
    if rc <> 'ok' then ShowMessage('2  NOT OK');

    log('y', 'LINKSENS s=' + s);
    if rc = 'ok' then
    begin
      log('l', 'LINKSENS s=' + s + ' /rc=' + rc);
      log('l', 'LINKSENS bpp=' + IntToStr(Data^.bp) + ' /bps=' + IntToStr(bps));
      ShowMessage('СВЯЗЬ УСТАНОВЛЕНА !!!');
    end
    else
    begin
      ShowMessage('ОШИБКА В БАЗЕ ');
    end;
  end
  else
  begin
    ShowMessage('Выбрана пара без соответствия. Повторите !????');
  end;

end;

procedure TForm1.MenuItem57Click(Sender: TObject);
var
  dataloc: pvstrecordloc;
begin
  dataloc := vstloc.GetNodeData(currndloc);
  formtunelocc.tune(dataloc^.dbmyid);
  formtunelocc.Show;
  formtunelocc.top := 0;
  formtunelocc.left := 0;

end;

procedure TForm1.MenuItem58Click(Sender: TObject);
begin
  titlenodeloc;
end;

procedure TForm1.MenuItem59Click(Sender: TObject);
var
  dataloc: pvstrecordloc;
  nd: pvirtualnode;
begin
      {
          showmessage('call findndvstdbmyid');
       log('y','findndvstdbmyid Start');
       dataloc:=vstloc.GetNodeData(currndloc);
       nd:=form1.findndbps(dataloc^.bps,dataloc^.tag);
       log('y','after findndvstdbmyid bps='+inttostr(dataloc^.bps));
       if nd<>nil then begin
          dataloc:=vstloc.GetNodeData(nd);
          showmessage('nm0='+dataloc^.nm0);
          exit;
       end;
         showmessage('NILLLLLLLLLLLLLLLLLLLLLLLLL');
      }

end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  vst.Clear;
end;

procedure TForm1.MenuItem60Click(Sender: TObject);
var
  dataloc: pvstrecordloc;
  Data: pvstrecord;
  nd, pnd: pvirtualnode;
begin
      {
       //   showmessage('call findndvstdbmyid');
       log('y','findndvstdbmyid Start');
       dataloc:=vstloc.GetNodeData(currndloc);
       nd:=form1.findndbps(dataloc^.bps,4);
       log('y','after findbps='+inttostr(dataloc^.bps));
       if nd<>nil then begin
          pnd:=nd^.parent;
          vst.Expanded[pnd]:=true;
          pnd:=pnd^.parent;

          data:=vst.GetNodeData(nd);
          vst.Selected[nd]:=true;
          vst.Expanded[pnd]:=true;
          vst.Refresh;
       end;
       }

end;

function tform1.fdeletend(vt: TLazVirtualStringTree; cnd: pvirtualnode): boolean;
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

  end;

  vt.DeleteNode(cnd);
  vt.refresh;
  //log('l','fdeletend s='+s);

end;

procedure TForm1.MenuItem61Click(Sender: TObject);
var
  dataloc: pvstrecordloc;
begin

  fdeletend(vstloc, currndloc);

end;

procedure TForm1.MenuItem62Click(Sender: TObject);
begin
end;

procedure TForm1.MenuItem63Click(Sender: TObject);
begin

  form1.onlyreadlocc(currndloc);
end;

procedure TForm1.MenuItem64Click(Sender: TObject);
begin
  filtr := 'onlyloc';
  titlenodeloc;
end;

procedure TForm1.MenuItem65Click(Sender: TObject);
begin
  filtr := 'full';
  titlenodeloc;
end;

procedure TForm1.MenuItem66Click(Sender: TObject);
var
  fn: string;
begin
  loadvtr(vstloc);

end;

procedure TForm1.MenuItem67Click(Sender: TObject);
begin
  unewloc.regim := 'new';
  unewloc.cnd := currndloc;
  formnewloc.addnewloc(currndloc, regim);
end;

procedure TForm1.MenuItem68Click(Sender: TObject);
begin
  unewloc.regim := 'new';
  unewloc.cnd := currndloc;
  formnewloc.addnewloc(currndloc, regim);
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
var
  kl, kls, kl2: string;
  xkl: int64;
begin
{
CREATE OR REPLACE FUNCTION func1() RETURNS TRIGGER AS $$
       BEGIN
            update tsslink set line=old.line
            update tsslink set line=new.line
            RETURN NULL;
            end;
            $$ LANGUAGE plpgsql;

           //INSERT INTO AUDIT_HIS(EMP_ID,EMP_NAME,ENTRY_DATE) VALUES (OLD.ID,OLD.NAME,current_timestamp);
           //INSERT INTO AUDIT(EMP_ID,EMP_NAME,ENTRY_DATE) VALUES (NEW.ID,NEW.NAME,current_timestamp);
       RETURN NULL;
       END;
   $$ LANGUAGE plpgsql;

 }

{
CREATE TRIGGER example_trigger AFTER INSERT OR UPDATE ON COMPANY
FOR EACH ROW EXECUTE PROCEDURE auditlogfunc();
}


    {  GKEY -- НЕ РАБОТАЮТ
      kl:='000000828E34';
      kls:=dmfunc.GKEY12TO6(kl);
     // kl2:=dmfunc.GKEY6TO12(inttostr(xkl));
      log('y','kl='+kl+' /kls='+kls);

     }
end;

procedure TForm1.MenuItem70Click(Sender: TObject);
begin
  formsensedit.prolog(currndloc);    //suda
  formsensedit.Show;

end;

procedure TForm1.MenuItem72Click(Sender: TObject);
begin
  mfiltr := 'select distinct myid,bp,name,tag,sti,smrn from tssloc_locations  order by myid,bp';
  fillsqluzel;
  form1.showsqluzel;
end;

procedure tform1.currrereadloc;
begin
  mfiltr := 'select distinct myid,bp,name,tag,sti,smrn from tssloc_locations ' +
    'where tag<>3 ' + ' order by myid,bp';

  fillsqluzel;
  form1.showsqluzel;

end;

procedure TForm1.MenuItem73Click(Sender: TObject);
begin
  mfiltr := 'select distinct myid,bp,name,tag,sti,smrn from tssloc_locations ' +
    'where tag<>3 ' + ' order by myid,bp';

  fillsqluzel;
  form1.showsqluzel;
end;

procedure TForm1.MenuItem74Click(Sender: TObject);
var
  s: string;
  i, j, k: integer;
  SL: TStringList;
begin
  i := 1;
  j := 0;
  try
    k := i div j;
  except
    on e: Exception do
    begin
      SL := TStringList.Create;
      sl.Values['pr'] := 'a';
      sl.Values['where'] := ' ТЕСТ ';
      sl.Values['ee'] := e.message;
      formawarn.info(sl);
    end;
  end;
end;

procedure TForm1.MenuItem76Click(Sender: TObject);
var
  Data: pvstrecord;
  sl: TStringList;
  kto, komu, sj, subcmd, line: string;
begin

  Data := vst.GetNodeData(currnd);
  subcmd := 'set_ch_opros';
  //komu:=mysysinfo.computername+'#drv209_'+data^.nm0;
  komu := Data^.idkomu;
  kto := umain.trclientid;
  line := 'avr';
  sj := formirjb_toskud(kto, komu, subcmd, line);
  // formtrans.cltrans.doSendMsg('tss_mqtt',sj,false); sudavagolo
  EXIT;

end;

procedure TForm1.MenuItem77Click(Sender: TObject);
var
  Data: pvstrecord;
  sl: TStringList;
  kto, komu, sj, subcmd, line: string;
begin

  Data := vst.GetNodeData(currnd);
  subcmd := 'set_ch_opros';
  //komu:=mysysinfo.computername+'#drv209_'+data^.nm0;
  komu := Data^.idkomu;
  kto := umain.trclientid;
  line := 'kpx';
  sj := formirjb_toskud(kto, komu, subcmd, line);
  log('l', 'sj=' + sj);
  formxtrans.mysend(sj);

end;

procedure Tform1.exbat(fn: string);
var
  AProcess: TProcess;
  i: integer;
begin

  AProcess := TProcess.Create(nil);
  log('r', 'exbat=' + fn);
  AProcess.Executable := fn;
  AProcess.Execute;

  AProcess.Free;

end;

function Tform1.fcrbat(sl: TStringList): string;
var
  i: integer;
  fn, s: string;
  slx: TStringList;
begin
  s := '';
  fn := appdir + 'tbat.bat';
  for i := 0 to sl.Count - 1 do
  begin
    s := s + sl[i] + ' ';
  end;
  slx := TStringList.Create;
  slx.Add(s);
  slx.SaveToFile(fn);
  slx.Free;
  Result := fn;

end;

procedure Tform1.excmd(cmd: string; sl: TStringList);
var
  AProcess: TProcess;
  i: integer;
begin
  AProcess := TProcess.Create(nil);
  log('r', 'excmd=' + cmd);
  if sl <> nil then
  begin
    log('r', 'excmd SL<> NIL !!!!!!!!!!!!!!!!!!!!!!!!');
    AProcess.Executable := 'c:\windows\system32\cmd.exe';
    for i := 0 to sl.Count - 1 do
    begin
      AProcess.Parameters.Add(sl[i]);
      log('r', 'excmd ADD=' + sl[i]);
    end;
  end;
  if sl = nil then
  begin
    AProcess := TProcess.Create(nil);
    AProcess.Executable := cmd;
  end;
  AProcess.Execute;
  AProcess.Free;

end;


procedure TForm1.MenuItem78Click(Sender: TObject);
var
  Data: pvstrecord;
  sl: TStringList;
  kto, komu, sj, subcmd, line: string;
begin

  Data := vst.GetNodeData(currnd);
  subcmd := 'set_ch_opros';
  //komu:=mysysinfo.computername+'#drv209_'+data^.nm0;
  komu := Data^.idkomu;
  kto := umain.trclientid;
  line := 'avt';
  sj := formirjb_toskud(kto, komu, subcmd, line);
  formxtrans.mysend(sj);

end;

procedure TForm1.MenuItem79Click(Sender: TObject);
begin
  form1.fdeletend(vst, currnd);
end;

procedure TForm1.MenuItem7Click(Sender: TObject);

begin
  // showmessage('MenuItem7Click');
  formglink.Show;
  vglink.kto := 'женя';
  // vglink:=formglink.gconnect(vglink);
end;

procedure TForm1.MenuItem80Click(Sender: TObject);
var
  Data: pvstrecord;
  nd: pvirtualnode;
  pid: integer;
  kto, komu, sj, subcmd, line, fn: string;
  AProcess: TProcess;
  sl: TStringList;
begin
  sl := TStringList.Create;
  Data := vst.GetNodeData(currnd);
  if Data = nil then ShowMessage('nil');
  subcmd := 'cmdforexepython';
  LOG('r', 'line 0=');
  kto := umain.trclientid;
  sl.add('taskkill');
  sl.add('/pid');
  sl.add(IntToStr(Data^.pidch));
  sl.add(' /f  /T');
  fn := fcrbat(sl);
  //   line:='taskkill  /pid '+inttostr(data^.pidch)+'  /f  /T';
  line := 'taskkill ';
  //LOG('r','line 1='+line);
  exbat(fn);
  Data^.sti := 30;
  Data^.nm1 := ' демон канала завершен  ';
  vst.Refresh;
  EXIT;

end;

procedure TForm1.MenuItem81Click(Sender: TObject);
begin
  formpgctr.rereadcl;
  formpgctr.Show;
end;

procedure TForm1.MenuItem82Click(Sender: TObject);
begin
  FORMxtrans.Show;
end;

procedure TForm1.MenuItem83Click(Sender: TObject);
begin
  forminfostart.Show;
end;

procedure tform1.launch210(Data: pvstrecord);
begin

end;

procedure TForm1.MenuItem84Click(Sender: TObject);
var
  Data, datap: pvstrecord;
  nd, ndp: pvirtualnode;
  pid: integer;
  fn, dbname, oss, kto, komu, sj, s, subcmd, ch, host, line, chtype: string;
  AProcess: TProcess;
  sl, slp: TStringList;
begin
  sl := TStringList.Create;
  slp := TStringList.Create;
  slp := dmfunc.gonsparams;
  host := slp.Values['-host'];
  dbname := slp.Values['-dbname'];
  oss := slp.Values['-os'];

  Data := vst.GetNodeData(currnd);
  komu := Data^.idkomu;
  ch := Data^.nm0;
  chtype := Data^.chtype;
  log('r', 'chtype=' + chtype);
  // showmessage('chtype='+chtype);
  if chtype = '210' then
  begin
    launch210(Data);
    exit;
  end;

  if Data = nil then ShowMessage('nil');
  subcmd := 'cmdforexepython';
  komu := mysysinfo.computername + '#drv209_' + Data^.nm0;
  kto := umain.trclientid;
  s := 'start  python3 ' + appdir + 'atss_drv209\drv209.py -host ' + host +
    ' -os ' + oss + ' -dbname ' + dbname + ' -ch ' + ch;
  sl.add(s);
  fn := fcrbat(sl);
  exbat(fn);

  exit;

  line := 'python3.exe drv209.py -ch ' + ch + '  -host ' + host + '  -dbname postgres';
  line := appdir + 'atss_drv209\rt96.bat';
  LOG('r', 'line 1=' + line);
  LOG('b', 'line 1=' + line);
  //line 1=C:\@laz\@atss_units\drv209\rt96.bat

  sj := formirjb_toskud(kto, komu, subcmd, line);
  // formtrans.cltrans.doSendMsg('tss_mqtt',sj,false);sudavagolo
  Data^.sti := -1;
  Data^.nm1 := ' попытка запуска канала';
  vst.Refresh;

  EXIT;

end;

procedure TForm1.MenuItem85Click(Sender: TObject);
begin
  formsgevent.Show;
end;

function tform1.formirvirtsl(cnd: pvirtualnode): TStringList;
var
  Data, datap, dataac, datach, datacomp: pvstrecord;
  nd, ndp, ndac, ndch, ndcomp: pvirtualnode;
  ev, port, ac, ch, bidac, bidch, bidcomp, kto, komu: string;
  sl: TStringList;
begin
  Data := vst.GetNodeData(currnd);
  komu := Data^.idkomu;
  ev := trim(Data^.nm0);
  ndp := Data^.ndp;
  datap := vst.GetNodeData(ndp);
  port := datap^.nm0;
  // log('l','virt='+port+zp+ev);
  ndac := datap^.ndp;
  dataac := vst.GetNodeData(ndac);
  ac := dataac^.nm0;
  bidac := IntToStr(dataac^.dbmyid);
  ndch := dataac^.ndp;
  datach := vst.GetNodeData(ndch);
  bidch := IntToStr(datach^.dbmyid);
  ch := datach^.nm0;
  ndcomp := datach^.ndp;
  datacomp := vst.GetNodeData(ndcomp);
  bidcomp := IntToStr(datacomp^.dbmyid);

  kto := datacomp^.nm0 + '#drv209_' + datach^.nm0;

  sl := TStringList.Create;
  sl.Values['kto'] := kto;
  sl.Values['ev'] := ev;
  sl.Values['bidcomp'] := bidcomp;
  sl.Values['bidch'] := bidch;
  sl.Values['bidport'] := IntToStr(datap^.dbmyid);
  sl.Values['bidsens'] := IntToStr(Data^.dbmyid);
  sl.Values['bidac'] := bidac;
  sl.Values['ch'] := ch;
  sl.Values['port'] := port;
  sl.Values['ac'] := ac;
  sl.Values['typs'] := '209';
  sl.Values['kluch'] := '0000007716AA';   //kluch # 0000007716AA # code # ": 7804586,
  sl.Values['code'] := '7804586';
  sl.Values['ikluch'] := '000000828e34';
  sl.Values['cdc'] := '2022-12-13 00:00:00';
  sl.Values['no'] := '1';
  sl.Values['vuxt'] := IntToStr(dateutils.DateTimeToUnix(now));

  log('l', 'virt=' + port + zp + ev + zp + ac + zp + ch + zp + bidcomp);
  Result := sl;
end;

procedure TForm1.MenuItem86Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem87Click(Sender: TObject);
var
  sl: TStringList;
begin
  sl := formirvirtsl(currnd);
  formxtrans.genvirtsrc1(sl); //sudavagolo
end;

procedure TForm1.MenuItem88Click(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin
  // sl:=formirvirtsl(currnd);
  for i := 1 to 30000 do
  begin
    application.ProcessMessages;
    sl := formirvirtsl(currnd);
    formxtrans.genvirtsrc1(sl);
    dmfunc.MyDelay(100);
    log('y', 'seria=' + sl.Text);
  end;
end;

procedure TForm1.MenuItem89Click(Sender: TObject);
begin
  unewloc.regim := 'new';
  unewloc.cnd := currndloc;
  formnewloc.addnewloc(currndloc, regim);
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  formbaselog.Show;
end;

procedure TForm1.MenuItem90Click(Sender: TObject);
begin
  fdeletend(vstloc, currndloc);
end;

procedure TForm1.MenuItem91Click(Sender: TObject);
begin
  ulocedit.ccnd := currndloc;
  formlocedit.prepare;
  formlocedit.Show;
  // form1.currrereadloc;
end;

procedure TForm1.MenuItem93Click(Sender: TObject);
var
  dl: pvstrecordloc;
begin
  dl := vstloc.GetNodeData(currndloc);
  deletechildloc(currndloc, dl^.dbmyid, -3);
  // deletechildloc(currndloc,dl^.dbmyid,3);
  vstloc.Refresh;
end;



procedure TForm1.MenuItem95Click(Sender: TObject);
begin
  formsensedit.prolog(currndloc);    //suda
  formsensedit.Show;

end;

procedure TForm1.MenuItem96Click(Sender: TObject);
begin
  Formsensedit.readsensors(currndloc);
end;

procedure TForm1.MenuItem97Click(Sender: TObject);
var
  dl: pvstrecordloc;
begin
  dl := vstloc.GetNodeData(currndloc);
  dl := form1.getprmtag3nm(currndloc, dl);

end;

procedure TForm1.MenuItem98Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem99Click(Sender: TObject);
begin

end;

function tform1.Inputsg(const Prompt: string; var Value: string): boolean;
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



procedure TForm1.MenuItem9Click(Sender: TObject);
begin

end;

procedure TForm1.Panel2Click(Sender: TObject);
begin

end;

procedure TForm1.Panel3Click(Sender: TObject);
begin

end;

procedure TForm1.Panel4Click(Sender: TObject);
var
  p: tpanel;
  cl: int64;
  i: integer;
  f: boolean;
begin

  {
    f:=false;
    p:=sender as tpanel;
    cl:=p.color;
    p.Color:=cllime;
    p.BevelInner:=bvlowered;


    dmfunc.MyDelay(200);
    p.BevelInner:=bvraised;
    p.BevelOuter:=bvraised;
    p.Color:=cl;

}

end;

procedure TForm1.panpollbaseClick(Sender: TObject);
begin

end;

procedure TForm1.pantimer1sClick(Sender: TObject);
begin

end;

procedure TForm1.pqc1AfterConnect(Sender: TObject);
begin
  log('l', 'pqc1AfterConnect !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
end;

procedure TForm1.rblocChange(Sender: TObject);
begin

end;

procedure TForm1.rgfClick(Sender: TObject);
begin

end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin

end;

procedure TForm1.timer1sTimer(Sender: TObject);
var
  uxt: int64;
  dt: tdatetime;
  js, comp, kto, pid, pidch, vuxt, subcmd, points: string;
  jb, jbx: TJSONObject;
  jd, jdx, jdy: tjsondata;
  bidcomp, bidch, cd, cmd, sj, s, status, uxts, speed, kpx, sumerr, v, errcode,
  ch_status, launchline: string;
  lastobs, d: int64;

begin
  timer1s.Enabled := False;
  etscd.Text :=FormatDateTime('hh:nn:ss,zzz', Now);
  //etscd.text:=dmfunc.GetExactTime;
  if uformxtrans.slrc.Count > 0 then
  begin
    while uformxtrans.slrc.Count > 0 do
    begin
      s := uformxtrans.slrc[0];
      showtr(s, 0);
      uformxtrans.slrc.Delete(0);
    end;

    if uglink.slrc.Count > 0 then
    begin
      while uglink.slrc.Count > 0 do
      begin
        s := uglink.slrc[0];
        showbase(s, 0);
        uglink.slrc.Delete(0);
      end;
    end;
  end;
  if slinjson.Count > 0 then
  begin
    //  log('w',' slinjson.count='+inttostr(slinjson.Count));
    v := slinjson.Strings[0];
    jd := GETJSON(v);
    jb := tjsonobject(jd);
    js := jd.FormatJSON;
    cmd := jb.Get('cmd');
    // log('r','timer1 cmd='+cmd);
    //if cmd='ch_state' then begin
    // showmessage('cmd='+cmd);
    //end;
    slinjson.Delete(0);
    if cmd = 'vc210' then
    begin
      form1.showsvc210(v);
      timer1s.Enabled := True;
      exit;
    end;
    if cmd = 'dmslife' then
    begin
      //showmessage('DMSLIFEv='+v);
      form1.showdmslife(v);
    end;
    if cmd = 'ch_infostart' then
    begin
      // forminfostart.Show;
      // forminfostart.Memo1.Lines.Add(v);
      // log('c','timer1 cmd='+cmd);
      points := jb.Get('points');
      //log('c','timer1 cmd 3 ='+cmd);
      ch_status := jb.Get('ch_status');
      //showmessage('timer1 ch_status='+ch_status+' /SUBCMD='+subcmd);
      bidcomp := jb.Get('bidcomp');
      bidch := jb.Get('bidch');
      uxts := jb.Get('ms');
      //log('c','timer1 cmd 4 ='+cmd);
      status := jb.Get('status');
      errcode := jb.Get('status');

      pidch := jb.Get('pidch');
      subcmd := jb.Get('subcmd');
      //  log('l','timer1 cd='+uxts);
      //  dt:=strtodatetime(uxts);
      //log('c','timer1 cmd 5 ='+cmd);
      lastobs := dateutils.DateTimeToUnix(dt);
      //log('c','timer1 cmd 6 ='+cmd);
      //  showmessage('before showch_chinfostart  ch_status='+ch_status);
      form1.showch_chinfostart(ch_status, bidcomp, bidch, uxts, status, subcmd, lastobs);

    end;
    try
      if cmd = 'src1todms' then
      begin
        // log('c','timer1 cmd 7 ='+cmd);
        // showmessage('timer1='+js);

        //form1.showsac209(js);    //sudamemory засада видимо здесь
        formsgevent.jslog(js);
      end;
    except
      on e: Exception do
      begin
        form1.log('e', '???cmd_src1todms,e=' + e.message);
      end;
    end;

  end;
  //sudatimer1
  try
    if cmd = 'guardlife' then
    begin
      //  showmessage('GUARDLIFE='+v);
      pid := jb.Get('pid');
      // log('c','timer1 cmd 9 ='+cmd);
      uxts := jb.Get('mystamp');
      kto := jb.Get('kto');
      comp := dmfunc.ExtractStr(1, kto, '#');
      //log('c','timer1 cmd 10 ='+cmd);
      //log('r','comp='+comp+js);
      // showmessage('trans='+js);
      form1.show_guardlife(comp, kto, uxts, pid);
    end;
  except
    on e: Exception do
    begin
      form1.log('e', 'cmd_guardlife,e=' + e.message);
    end;
  end;
  try
    if cmd = 'ch_state' then
    begin
      log('y', 'ch_state=' + v);
      //SHOWMESSAGE('V='+V);
      bidcomp := jb.Get('bidcomp');
      bidch := jb.Get('bidch');
      pidch := jb.Get('pidch');
      uxts := jb.Get('ms');
      speed := jb.Get('speed');
      //log('c','timer1 cmd 12 ='+cmd);
      kpx := jb.Get('kpx');
      vuxt := jb.Get('vuxt');
      pidch := jb.Get('pidch');
      sumerr := jb.Get('sumerr');
      //log('c','timer1 cmd 13='+cmd);
      ch_status := jb.Get('ch_status');
      lastobs := StrToInt(vuxt);
      uxt := DateTimeToUnix(now);
      d := uxt - lastobs;
      //log('c','timer1 cmd 14 ='+cmd);
      dt := now;
      // showmessage('uxt='+inttostr(uxt)+' lastobs='+inttostr(lastobs) +'/dt='+datetimetostr(dt)+' / d='+inttostr(d));
      form1.showch_chcurrinfo(ch_status, bidcomp, bidch, uxts, kpx,
        sumerr, speed, pidch, lastobs);
    end;
  except
    on e: Exception do
    begin
      form1.log('e', 'cmd_ch_state,e=' + e.message);
    end;
  end;

  if cmd = 'getacinfo' then
  begin
    log('r', 'v===' + v);
    form1.show_acinfo(v);
    //showmessage('GETACINFO v='+v) ;
  end;

  try
    if cmd = 'tsslife' then
    begin
      // log('c','timer1 cmd 15='+cmd);
      subcmd := jb.Get('subcmd1');
      log('c', 'timer1 subcmd=' + subcmd);
      launchline := jb.Get('launchline');
      launchline := 'python ' + launchline;
      bidcomp := jb.Get('bidcomp');
      bidch := jb.Get('bidch');
      uxts := jb.Get('ms');
      vuxt := jb.Get('vuxt');
      //log('c','timer1 cmd 16 ='+cmd);
      ch_status := jb.Get('ch_status');
      pidch := jb.Get('pidch');
      lastobs := StrToInt(vuxt);
      log('c', 'LL=' + launchline);
      form1.showch_tsslife(ch_status, bidcomp, bidch, uxts, pidch,
        lastobs, StrToInt(vuxt), launchline);
      // LL=python c:\@laz\@atss_units\atss_drv209\drv209.py -host 127.0.0.1 -dbname postgres -os windows -ch 192.168.0.96 -regim real
    end;
  except
    on e: Exception do
    begin
      form1.log('e', 'cmd_tsslife,e=' + e.message);
    end;
  end;
  try
    if jb <> nil then jb.Free; //sudamemory
  except
  end;
  timer1s.Enabled := True;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  etscd.Text := datetimetostr(now);
  sltssparams := TStringList.Create;
  form1.color := $003C3C3C;
  mytmz := 3 * 3600;
  ap := chr(27);
  zp := ',';
  glbfmid := -1;
  fmqttready := False;
  mfiltr := 'select distinct myid,bp,name,tag,sti,smrn from tssloc_locations  where tag<>3 order by myid,bp';
  ap := '''';
  zp := ',';
  filtr := 'onlyloc';
  fbroker := False;
  sltree := TStringList.Create;
  sltrexe := TStringList.Create;
  vglink.sl := TStringList.Create;

  VST.NodeDataSize := SizeOf(tpvstrecord);
  VSTloc.NodeDataSize := SizeOf(tpvstrecordloc);

  VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions + [toCheckSupport];
  VSTloc.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions + [toCheckSupport];
  timerstart.Enabled := True;
  // showmessage('end of main.create');

end;

procedure TForm1.FormShow(Sender: TObject);
begin

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem100Click(Sender: TObject);
begin
  formmars1.reread;
  formmars1.Show;
end;

procedure TForm1.loctomarsrut(ndloc: pvirtualnode; sl: TStringList);
var
  ndp, ndn: pvirtualnode;
  dl: pvstrecordloc;
  i, dbmyid: integer;
  s, sm, bploc, rc, bpself, nm: string;
begin
  //sudabad
  dl := form1.vstloc.GetNodeData(ndloc);
  bploc := IntToStr(dl^.dbmyid);
  nm := dl^.nm0;
  for i := 0 to sl.Count - 1 do
  begin
    //suda14
    log('y', 'sl[i]=====' + sl[i]);
    sm := dmfunc.ExtractStr(1, sl[i], ',');
    bpself := dmfunc.ExtractStr(2, sl[i], ',');
    s := 'insert into tss_marsrut(bpself,bploc,mrn,tag)values(' +
      bpself + zp + bploc + zp + sm + zp + '3' + ');';
    rc := selfupd(s);
    if rc <> 'ok' then
    begin
      log('r', 's=' + s + '  /rc=' + rc);
    end
    else
    begin
      //  SHOWMESSAGE('CALL FIND');
      form1.log('c', '??? myid=' + bpself);
      form1.log('c', '??? CALL FIND=' + SM + '>');
      ndp := FORMMARS1.findndnm0tag(sm, 1);
      sl.Values['nm0'] := sm;
      sl.Values['dbmyid'] := bpself;
      sl.Values['myid'] := bpself;
      sl.Values['tag'] := '3';
      sl.Values['sti'] := '-1';
      sl.Values['sti1'] := '-1';
      sl.Values['ndcheck'] := 'n';
      sl.Values['ndcheck_state'] := 'n';
      ndn := formmars1.fnnmars(ndp, sl); // sudalast
      dl := formmars1.vstmars.GetNodeData(ndn);
      dl^.nm0 := sm;
      dl^.dbmyid := StrToInt(bpself);
      dl^.tag := 3;
      dl^.nm1 := nm;
      dl^.sti := -1;
      dl^.sti1 := -1;
      formmars1.vstmars.Expanded[ndp] := True;
      formmars1.vstmars.Refresh;
    end;
  end;
end;


procedure TForm1.MenuItem102Click(Sender: TObject);
var
  sl: TStringList;
  nd: pvirtualnode;
  dl: pvstrecordloc;
begin
  log('l', 'Node  ???????????????????????');
  dl := vstloc.GetNodeData(currndloc);

  sl := TStringList.Create;
  sl := formmars1.findchcknd(formmars1.vstmars);
  if (sl = nil) or (sl.Count = 0) then
  begin
    ShowMessage('ВЫ НЕ ВЫБРАЛИ МАРШРУТ(ы). ПОВТОРИТЕ');
    EXIT;
  end;
  // showmessage('call loctomarsrut');
  loctomarsrut(currndloc, sl);
end;


procedure TForm1.MenuItem103Click(Sender: TObject);
begin
  log('l', 'and subnodes  ???????????????????????');
end;

procedure TForm1.MenuItem104Click(Sender: TObject);
var
  nd: pvirtualnode;
  dl: pvstrecordloc;
  s: string;
begin
  dl := vstloc.GetNodeData(currndloc);
  nd := vstloc.GetFirstSelected();

end;

procedure TForm1.MenuItem107Click(Sender: TObject);
var
  dl: pvstrecordloc;
  sl: TStringList;
  i: integer;
  s, ss, bploc, myid: string;
begin
  //suda17
  dl := vstloc.GetNodeData(currndloc);
  bploc := IntToStr(dl^.dbmyid);

  sl := TStringList.Create;
  sl := findchckndtag(vst, 4);
  for i := 0 to sl.Count - 1 do
  begin
    log('y', 'sl[i]=' + sl[i]);
    myid := dmfunc.ExtractStr(2, sl[i], ',');
    s := 'update tss_sensors set bploc=' + bploc + ' where myid=' + myid;
    log('y', 's=' + s);
    form1.selfupd(s);
    s := 'update tssloc_locations set bpsens=' + myid + ' where myid=' + bploc;
    log('c', 's=' + s);
    form1.selfupd(s);

  end;

end;

function tform1.findchckmarsnd: pvirtualnode;
var
  dl: pvstrecord;
  nd: pvirtualnode;
begin
  Result := nil;
  nd := formmars1.vstmars.getfirst(True);
  dl := formmars1.vstmars.getnodedata(nd);
  if dl^.chkstate then
  begin
    Result := nd;
    exit;
  end;

  while True do
  begin
    application.ProcessMessages;
    nd := formmars1.vstmars.getnext(nd);
    //form1.log('y','nm0='+data.nm0+'>');
    if not assigned(nd) then
    begin
      Result := nil;
      exit;
    end;
    dl := formmars1.vstmars.getnodedata(nd);
    if dl^.chkstate then
    begin
      // dl:=formmars1.vstmars.GetNodeData(ND);
      // form1.log('l','SELECTED nm0='+dl^.nm0+' /cc='+inttostr(cc));
      Result := nd;
      exit;
    end;
  end;

end;

function tform1.findndportoflocsens(ndloc: pvirtualnode): tndmars;
var
  dl: pvstrecordloc;
  dun, dp: pvstrecord;
  ndsens, ndport: pvirtualnode;
  bpsens, dbmyid, bp, loccode, X: integer;
  rnd: tndmars;
begin
  try
    rnd.rc := -1;
    X := 0;
    dl := vstloc.GetNodeData(ndloc);
    log('r', 'findndportoflocsens nm0===================================================='
      +
      dl^.nm0);
    loccode := dl^.loccode;
    log('r', 'findndportoflocsens loccode=' + IntToStr(loccode));
    bpsens := dl^.bps;
    dbmyid := dl^.dbmyid;
    X := 1;
    log('r', 'findndportoflocsens nm0=' + dl^.nm0 + ' / bpsens=' + IntToStr(
      bpsens) + ' dbmyid=' + IntToStr(dbmyid));
    X := 11;
    ndsens := form1.findndofmyid(bpsens);
    if ndsens = nil then
    begin
      ShowMessage('ВЫ ЗАБЫЛИ ПРЕДВАРИТЕЛЬНО СДЕЛАТЬ ПРИВЯЗКУ !!!!!!!!!!!!! ');
      EXIT;
    end;
    X := 12;
    dun := vst.GetNodeData(ndsens);
    x := 121;
    log('l', 'findndportoflocsens bp=' + IntToStr(dun^.bp));
    x := 122;
    ndport := form1.findndofmyid(dun^.bp);
    x := 123;
    X := 13;
    dp := vst.GetNodeData(ndport);
    X := 2;
    log('l', 'findndportoflocsens dbmyid=' + IntToStr(dp^.dbmyid));
    rnd.ndsens := ndsens;
    X := 3;
    rnd.ndport := ndport;
    rnd.rc := 0;
    X := 4;

    Result := rnd;
  except
    on e: Exception do
    begin
      rnd.rc := -1;
      form1.log('e', 'findndportoflocsens,X=' + IntToStr(x) + ' /E=' + e.Message);
      Result := rnd;
    end;
  end;

end;

procedure TForm1.formirmars(ndmars, ndloc, ndport, ndsens: pvirtualnode);
var
  s: string;
  idmars, idsens, idloc, idport, idbploc, mrn: integer;
  dloc: pvstrecordloc;
  dsens, dport, dmars: pvstrecord;

begin
  log('y', 'formirmars @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
  dmars := formmars1.vstmars.GetNodeData(ndmars);
  dsens := vst.GetNodeData(ndsens);
  dport := vst.GetNodeData(ndport);
  dloc := vstloc.GetNodeData(ndloc);
  idmars := dmars^.dbmyid;
  idsens := dsens^.dbmyid;
  idloc := dloc^.dbmyid;
  idport := dport^.dbmyid;
  idbploc := dloc^.bp;
  s := ' idmars=' + IntToStr(dmars^.dbmyid) + ' idsens=' + IntToStr(dsens^.dbmyid) +
    ' idloc=' + IntToStr(dloc^.dbmyid) + ' idport=' + IntToStr(dport^.dbmyid) +
    ' idbploc=' + IntToStr(dloc^.bp);
  log('y', 's=' + s);
   {
    s:='update tss_marsrut set bprootloc='+inttostr(idbploc)+zp+
     ' bploc='+inttostr(idbploc);
    ' where myid='+inttostr(idmars)+zp+

    }
  s := 'insert into tss_marsrut(bpself,bploc,mrn,tag,bprootloc,bpport)values(' +
    IntToStr(idmars) + zp + IntToStr(idloc) + zp + IntToStr(dmars^.mrn) + zp +
    IntToStr(3) + zp + IntToStr(idbploc) + zp + IntToStr(idport) + ')';

  log('y', 's=' + s);
  form1.selfupd(s);

end;

procedure TForm1.MenuItem109Click(Sender: TObject);
var
  sl: TStringList;
  nd: pvirtualnode;
  dl, dm: pvstrecordloc;
  lc, dbmyid, bpsens: integer;
  ndloc, ndport, ndmars, ndsens: pvirtualnode;
  rnd: tndmars;
begin
  //  showmessage('MenuItem109Click START') ;
  ndloc := currndloc;
  dl := vstloc.GetNodeData(ndloc);
  dbmyid := dl^.dbmyid;
  bpsens := dl^.bps;
  if not checklinkbps(dl^.bps) then
  begin
    ShowMessage('НЕТ СВЯЗИ ???!!!!');
    EXIT;

  end;
  log('y', 'findndportoflocsens nm0=' + dl^.nm0 + ' / dbmyid=' + IntToStr(
    dbmyid) + ' / bpsens=' + IntToStr(bpsens));

  lc := dl^.loccode;
  log('l', 'keyTOMARS loccode=' + IntToStr(lc));
  if lc <> 1 then
  begin
    ShowMessage('НАДО ВЫБРАТЬ СЕНСОР "KEY"--> ПОВТОРИТЕ');
    exit;
  end;
  ndmars := findchckmarsnd;
  // showmessage('MenuItem109Click  POINT 1') ;
  if ndmars = nil then
  begin
    ShowMessage('ВЫ НЕ ОТМЕТИЛИ МАРШРУТ--> ПОВТОРИТЕ');
    EXIT;
  end;
  // showmessage('MenuItem109Click  POINT 2') ;
  dm := formmars1.vstmars.GetNodeData(ndmars);
  // showmessage('MenuItem109Click  POINT 3') ;
  rnd := findndportoflocsens(ndloc);
  //showmessage('MenuItem109Click  POINT 31 AFTER RND') ;
  //showmessage('MenuItem109Click  RND=NIL') ;
  // EXIT;
  if rnd.rc = 0 then
  begin
    ndsens := rnd.ndsens;
    ndport := rnd.ndport;
  end;
  //  showmessage('MenuItem109Click  POINT 4') ;
  if rnd.rc <> 0 then
  begin
    log('r', 'NILLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');
    EXIT;
  end;
  // showmessage('MenuItem109Click CALL FORMIRMARS') ;
  formirmars(ndmars, ndloc, ndport, ndsens);  //suda23
  // showmessage('MenuItem109Click BEFORE EXIT') ;
  EXIT;

  dl := vst.GetNodeData(ndsens);
  ndport := dl^.ndp;
  ShowMessage('AFTER');
  log('l', 'AFTER= ');
  dl := vst.GetNodeData(ndport);
  log('y', 'dbmyid= ' + IntToStr(dl^.dbmyid));

  EXIT;
  sl := TStringList.Create;
  sl := formmars1.findchcknd(formmars1.vstmars);
  if (sl = nil) or (sl.Count = 0) then
  begin
    ShowMessage('ВЫ НЕ ВЫБРАЛИ МАРШРУТ(ы). ПОВТОРИТЕ');
    EXIT;
  end;
  // showmessage('call loctomarsrut');
  loctomarsrut(currndloc, sl);
end;



procedure TForm1.rereadloc;
begin
  read_locations;
end;

procedure TForm1.reread;
begin
  read_comps;
end;

function Tform1.findndlockey(key: string): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecordloc;
begin
  // form1.log('y','start findndofnm0='+nm0+'>');
  try
    Result := nil;
    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := vstloc.getfirst(True);
    Data := vstloc.getnodedata(nd);
    //form1.log('y','start findndofnm1 2 nn1='+nm1+'>');
    while True do
    begin
      application.ProcessMessages;
      nd := vstloc.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vstloc.getnodedata(nd);
      if trim(Data^.nm0) = key then
      begin
        Result := nd;
        //form1.log('l','findndofnm1 FOUND FOUND ='+data.nm0);
        exit;
      end;
    end;
    ShowMessage('key=' + key);
    form1.log('y', 'findndlockey not found nkey=' + key);
    exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndlockey,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;



function Tform1.findvstndbymid(dbmyid, ttg: integer): pvirtualnode;
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

procedure tform1.showsvc210(js: string);
var
  nd, ndcp: pvirtualnode;
  Data, datap: pvstrecord;
  jb: TJSONObject;
  jd: tjsondata;
  cmd, pidch, bidcomp, bidch, bidac, es, ms, s: string;
  ch, av, ac, ev, kluch, ikluch, port, rst, no, cdc, vuxt, target_name, subcmd, pid: string;
  i, target_bpbid, target_tag: integer;
begin
  try
    jd := GETJSON(js);
    jb := tjsonobject(jd);
    cmd := jb.Get('cmd');
    subcmd := jb.Get('subcmd');

    ch := jb.Get('ch');
    ms := jb.Get('ms');
    pid := IntToStr(jb.Get('pid'));
    bidch := IntToStr(jb.Get('bidch'));

    nd := form1.findvstndbymid(StrToInt(bidch), 1);
    Data := vst.GetNodeData(nd);

    es := ms + '   pid=' + pid + ' ch=' + ch;
    Data^.pidch := StrToInt(pid);
    Data^.sti := 33;
    Data^.nm1 := es;
    vst.Expanded[nd] := True;
    vst.Refresh;


  except
    on e: Exception do
    begin
      form1.log('e', 'showac210,e=' + e.message);
    end;
  end;
end;



procedure tform1.show_acinfo(js: string);
var
  nd, ndcp: pvirtualnode;
  Data, datap: pvstrecord;
  jb: TJSONObject;
  jd: tjsondata;
  ac, cmd, prog_id, prog_ver, ser_num, keys_info, events_info, coderc, idcmd, s: string;
  bidac: integer;

begin

  log('y', 'show_acinfo=' + js);
  jd := GETJSON(js);
  jb := tjsonobject(jd);
  cmd := jb.Get('cmd');
  ac := IntToStr(jb.Get('ac'));
  bidac := jb.Get('bidac');
  idcmd := jb.Get('idcmd');
  s := 'update tss_armcmd set rcjss=' + ap + js + ap + ' where idcmd=' + idcmd;
  form1.selfupd(s);
  prog_id := jb.Get('prog_id');
  prog_ver := jb.Get('prog_ver');
  ser_num := jb.Get('ser_num');
  keys_info := jb.Get('keys_info');
  events_info := jb.Get('events_info');
  coderc := jb.Get('coderc');
  log('w', 'show_acinfo ac=' + ac + ' bidac=' + IntToStr(bidac));
  ND := FORM1.findndofmyid(bidac);
  Data := vst.GetNodeData(nd);
  Data^.nm1 := 'prog_id=' + prog_id + zp + 'prog_ver=' + prog_ver + zp + 'ser_num=' + ser_num + zp +
    'keys_info=' + keys_info + zp + 'events_info=' + events_info;
  Data^.nm2 := idcmd + zp + 'rc=' + coderc + zp + datetimetostr(now);
  vst.refresh;




  //SHOWMESSAGE('show_acinfo='+JS);

end;

procedure tform1.showsac209(js: string);
var
  nd, ndcp: pvirtualnode;
  Data, datap: pvstrecord;
  jb: TJSONObject;
  jd: tjsondata;
  cmd, pidch, bidcomp, bidch, bidac, es, s: string;
  ch, av, ac, ev, kluch, ikluch, port, rst, no, cdc, vuxt, target_name: string;
  i, target_bpbid, target_tag: integer;
begin
  try
    log('y', 'showac209=' + js);
    jd := GETJSON(js);
    jb := tjsonobject(jd);
    cmd := jb.Get('cmd');
    ac := IntToStr(jb.Get('ac'));
    port := IntToStr(jb.Get('port'));
    no := IntToStr(jb.Get('no'));
    //cdc   :=jb.Get('cdc');
    ch := jb.Get('ch');
    ev := jb.Get('ev');
    av := jb.Get('av');
    kluch := jb.Get('kluch');
    ikluch := jb.Get('ikluch');
    bidac := IntToStr(jb.Get('bidac'));
    es := cdc + zp + ch + zp + no + zp + ac + zp + port + zp + av + zp + ev + zp + kluch + zp + ikluch;
    log('c', 'showsac209 s=' + es);
    nd := findndofmyid(StrToInt(bidac));
    Data := vst.GetNodeData(nd);
    Data^.sti := 33;
    //data^.nm1:=es;
    Data^.bidac := StrToInt(bidac);
    // vst.Expanded[nd]:=true;    //SUDAMEMORY ворос
    vst.Refresh;
    target_bpbid := Data^.dbmyid;
    target_name := port;
    target_tag := 3;
    ndcp := findndofbpbidnm(target_name, target_bpbid, target_tag);
    if ndcp = nil then
    begin
      log('r', '???????????????????????????????????? nil');
    end;
    datap := vst.GetNodeData(ndcp);
    datap^.sti := 42;
    datap^.nm2 := es;
    //vst.Expanded[ndcp]:=true;  //SUDAMEMORY ворос
    vst.Refresh;
    jb.Free;
    form1.log('y', 'showac209,jb.FREE=');
    //jd.Free;


  except
    on e: Exception do
    begin
      form1.log('e', 'showac209,e=' + e.message);
    end;
  end;

end;

procedure tform1.show_guardlife(comp, kto, uxts, pid: string);
var
  nd: pvirtualnode;
  Data: pvstrecord;
  d: int64;
begin
  try
    nd := form1.findndnm0tag('sgrd', -101);
    Data := vst.GetNodeData(nd);
    // log('y','show_guardlife='+kto);
    // data^.lastobs:=DateTimeToUnix(now,false);
    Data^.pidguard := StrToInt(pid);
    Data^.pidguard := StrToInt(pid);
    Data^.sti := 42;
    d := form1.calc_vstobstime(nd);
    Data^.nm1 := uxts + ',pid=' + pid + ',delta=' + IntToStr(d);
    //vst.Selected[nd]:=true;
    // vst.Refresh;

  except
    on e: Exception do
    begin
      form1.log('e', 'show_guardlife,e=' + e.message);
    end;

  end;

end;

procedure tform1.showch_chcurrinfo(ch_status, bidcomp, bidch, uxts, kpx,
  sumerr, speed, pidch: string; lastobs: int64);
var
  nd: pvirtualnode;
  Data: pvstrecord;
  nlobs, delta: int64;
begin
{
       V={
  "cmd" : "tsslife",
  "ch_status" : "ok",
  "pidch" : "6220",
  "bidcomp" : "6",
  "bidch" : "89",
  "ch" : "192.168.0.96",
  "uxt" : "1676601347",
  "vuxt" : "1676601347",
  "kto" : "hp2020#drv209_192.168.0.96",
  "mystamp" : "2023-02-17 05:35:47",
  "ms" : "2023-02-17 05:35:47"
}
}
  //sudachannel
  if trim(ch_status) = '' then exit;

  nd := findndofmyid(StrToInt(bidch));
  if nd = nil then exit;
  Data := vst.GetNodeData(nd);
  if kpx = 'kpx' then  Data^.sti := 38;
  if kpx = 'avr' then  Data^.sti := 40;
  if kpx = 'avt' then  Data^.sti := 43;
  if ch_status = 'err' then
  begin
    Data^.sti := 44;
    Data^.nm1 := 'PID=' + pidch + ' / cd=' + uxts +
      ' фатальная ошибка канала';
    form1.vst.refresh;
    exit;
  end;
  nlobs := dateutils.DateTimeToUnix(now, False);
  delta := nlobs - lastobs;
  // data^.lastobs:=lastobs;
  delta := calc_vstobstime(nd);
  Data^.nm1 := 'PID=' + pidch + ' / cd=' + uxts + ' / kpx=' + kpx + ' / speed=' + speed +
    ' /ser=' + sumerr + ' / DELTA=' + IntToStr(delta);
  // data^.nm2:=status;
  form1.vst.refresh;

end;




procedure Tform1.showch_chinfostart(ch_status, bidcomp, bidch, uxts, status, subcmd: string;
  lastobs: int64);
var
  nd: pvirtualnode;
  Data: pvstrecord;
begin
  // showmessage('showch_chinfostart ch_status='+ch_status+' / SUBCMD='+subcmd);
  nd := findndofmyid(StrToInt(bidch));
  if nd = nil then
  begin
    log('r', 'showch_chinfostart nd=NIL');
    exit;
  end;
  Data := vst.GetNodeData(nd);
  Data^.sti := 43;
  Data^.lastobs := lastobs;
  Data^.nm1 := 'ch_status=' + ch_status + ' showch_chinfostart' + timetostr(time) +
    '???????';
  //data^.nm2:=status;
  form1.vst.refresh;

end;

procedure Tform1.baseinfo(d: pvstrecord);
var
  nd: pvirtualnode;
  qrz: TSQLQuery;
  s, v: string;
  //s:='SELECT datname,usename,client_addr,client_port FROM pg_stat_activity';

begin

  // sl:=tstringlist.Create;
  s := 'SELECT pg_size_pretty(pg_database_size(current_database()))';
  log('y', 'baseinfo=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.DataBase := formglink.pqc1;
  qrz.SQL.Clear;
  qrz.SQL.Add(s);
  qrz.Active := True;
  v := qrz.Fields.Fields[0].AsString;
  log('l', 'baseinfo=' + v);
  d^.NM1 := 'открыта ,size=' + v;

end;


procedure Tform1.showbase(p: string; rc: integer);
var
  d: pvstrecord;
  nd: pvirtualnode;
begin

  // showmessage('p='+p);
  nd := form1.findndnm0tag('base', -109);
  if nd = nil then
  begin
    log('r', 'showtr nd=NIL');
    EXIT;
  end;

  d := vst.GetNodeData(nd);
  d^.nm1 := p + '   ' + timetostr(time);
  if p = 'baseconnect' then
  begin
    d^.sti := 42;
    d^.nm1 := 'Открыта   ' + timetostr(time);
    form1.baseinfo(d);
  end;
  if p = 'basedisconnect' then
  begin
    d^.sti := 44;
    d^.nm1 := 'Отключена   ' + timetostr(time);

  end;

  vst.refresh;
end;


procedure Tform1.showtr(p: string; rc: integer);
var
  d: pvstrecord;
  nd: pvirtualnode;
begin

  nd := form1.findndnm0tag('transport', -111);
  if nd = nil then
  begin
    log('r', 'showtr nd=NIL');
    EXIT;
  end;

  d := vst.GetNodeData(nd);
  d^.nm1 := p + '   ' + timetostr(time);
  if p = 'ondisconnect' then
  begin
    d^.sti := 44;
  end;

  if p = 'onsubscribe' then
  begin
    d^.sti := 42;
    d^.nm1 := 'Работает  ' + timetostr(time);
  end;
  vst.refresh;
end;

procedure Tform1.showch_tsslife(ch_status, bidcomp, bidch, uxts, pidch: string;
  lastobs, vuxt: int64; launchline: string);
var
  nd: pvirtualnode;
  Data: pvstrecord;
begin
  try

    //EXIT;

    nd := findndofmyid(StrToInt(bidch));
    if nd = nil then exit;
    Data := vst.GetNodeData(nd);
    Data^.launchline := launchline;
    Data^.sti := 41;
    Data^.pidch := StrToInt(pidch);
    Data^.lastobs := DateTimeToUnix(now, False);
    if ch_status = 'err' then
    begin
      Data^.sti := 44;
      Data^.nm1 := 'tsslife ' + timetostr(time);
    end;
    if ch_status = 'ok' then
    begin
      //data^.sti:=42;
      //log('s','main showch_tsslife sti=42');
      //data^.nm1:='showch_tsslife='+timetostr(time);
    end;


  except
    on e: Exception do
    begin
      form1.log('e', 'showch_tsslife,e=' + e.message);
    end;
  end;

end;

function tform1.findndofbpbidnm(target_name: string;
  target_bpbid, target_tag: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecord;
begin
  Result := nil;
  nd := vst.getfirst(True);
  Data := vst.getnodedata(nd);
  while True do
  begin
    application.ProcessMessages;
    nd := vst.getnext(nd);
    //form1.log('y','nm0='+data.nm0+'>');
    if not assigned(nd) then exit;
    Data := vst.getnodedata(nd);
    if (Data^.tag = target_tag) then
    begin
      log('c', 'target_name=' + target_name + ' c_name=' + Data^.nm0 +
        ' target_cbid=' + IntToStr(target_bpbid) + ' ' + IntToStr(Data^.dbmyid));
      if (Data^.nm0 = target_name) and (Data^.bp = target_bpbid) then
      begin
        Result := nd;
        exit;
      end;
    end;

  end;

end;

procedure tform1.sensnodetostatevis(ndc: pvirtualnode; f: boolean);
var
  i, bp, ttg: integer;
  nd: pvirtualnode;
  Data: pvstrecordloc;
begin
  // form1.log('y','start findndofnm0 1 NM1='+nm0+'>');
  try

    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := ndc;
    Data := vstloc.getnodedata(ndc);
    bp := Data^.dbmyid;
    ttg := Data^.tag;
    log('y', 'start sensnodetovis bp==' + IntToStr(bp));
    while True do
    begin
      application.ProcessMessages;
      nd := vstloc.getnext(nd);
      log('y', 'nm0=' + Data^.nm0 + '>');
      if not assigned(nd) then exit;
      Data := vstloc.getnodedata(nd);
      if (Data^.bp = bp) and (Data^.tag = -3) then
      begin
        vstloc.IsVisible[nd] := f;
        log('l', 'findndofnm1 FOUND FOUND =' + Data^.nm0);
        // log('l','findndofnm1 FOUND FOUND ='+data^.nm0);
        //exit;
      end;
    end;
    //showmessage('nm='+nm);
    form1.log('r', 'findndvstdbmyid NOT FOUND');
    //exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndlocofmyid,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
  vstloc.Refresh;

end;


function Tform1.findndlocofmyid(dbmyid: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecordloc;
begin
  // form1.log('y','start findndofnm0 1 NM1='+nm0+'>');
  try
    Result := nil;
    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := vstloc.getfirst(True);
    Data := vstloc.getnodedata(nd);
    //form1.log('y','start findndofnm1 2 nn1='+nm1+'>');
    while True do
    begin
      application.ProcessMessages;
      nd := vstloc.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vstloc.getnodedata(nd);
      if Data^.dbmyid = dbmyid then
      begin
        Result := nd;
        // log('l','findndofnm1 FOUND FOUND ='+data^.nm0);
        // log('l','findndofnm1 FOUND FOUND ='+data^.nm0);
        exit;
      end;
    end;
    //showmessage('nm='+nm);
    form1.log('r', 'findndvstdbmyid NOT FOUND');
    //exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndlocofmyid,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;



function Tform1.findndofmyid(dbmyid: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecord;
begin
  // form1.log('y','start findndofnm0 1 NM1='+nm0+'>');
  try
    Result := nil;
    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := vst.getfirst(True);
    Data := vst.getnodedata(nd);
    //form1.log('y','start findndofnm1 2 nn1='+nm1+'>');
    while True do
    begin
      application.ProcessMessages;
      nd := vst.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vst.getnodedata(nd);
      if Data^.dbmyid = dbmyid then
      begin
        Result := nd;
        // log('l','findndofnm1 FOUND FOUND ='+data^.nm0);
        // log('l','findndofnm1 FOUND FOUND ='+data^.nm0);
        exit;
      end;
    end;
    //showmessage('nm='+nm);
    form1.log('r', 'findndvstdbmyid NOT FOUND');
    //exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndvstdbmyid,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;

function Tform1.getndofabi(tree: TVirtualStringTree; abi: int64): PVirtualNode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecord;
begin

  try
    Result := nil;
    nd := tree.getfirst(True);
    Data := vst.getnodedata(nd);
    //form1.log('y','start findndofnm1 2 nn1='+nm1+'>');
    while True do
    begin
      application.ProcessMessages;
      nd := tree.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := tree.getnodedata(nd);
      // vst.AbsoluteIndex(node)
      if tree.AbsoluteIndex(nd) = abi then
      begin
        Result := nd;
        //form1.log('l','findndofnm1 FOUND FOUND ='+data.nm0);
        exit;
      end;
    end;
    // showmessage('nm='+nm);
    // form1.log('y','findndofnm1 not found nm='+nm);
    exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndofnm1,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;

procedure tform1.xtag2(bp: integer; ndo: pvirtualnode);
var
  sl: TStringList;
  s: string;
  dataloc, dtn: pvstrecordloc;
  nd: pvirtualnode;
  mx: tmyrcvtr;
  qrz: TSQLQuery;
begin
  //showmessage('tag2 start');
  dataloc := vstloc.GetNodeData(ndo);
  s := 'select * from tssloc_locations where tag=2 ' +
    ' and bp>=' + IntToStr(dataloc^.dbmyid);
  log('y', 'xtag1 s=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.SQL.Clear;
  qrz.DataBase := formglink.pqc1;
  qrz.Transaction := formglink.tr1;
  qrz.sql.Add(s);
  qrz.Active := True;
  while not qrz.EOF do
  begin
    ;
    sl := TStringList.Create;
    sl.Values['myid'] := qrz.FieldByName('myid').AsString;
    sl.Values['nm0'] := qrz.FieldByName('name').AsString;
    sl.Values['tag'] := qrz.FieldByName('tag').AsString;
    sl.Values['sti'] := qrz.FieldByName('sti').AsString;
    sl.Values['sti1'] := '-1';
    sl.Values['bp'] := qrz.FieldByName('bp').AsString;
    //log('y','sl='+sl.text);
    dataloc := vstloc.GetNodeData(currnd);
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnnloc(ndo, sl);

    dtn := vstloc.GetNodeData(nd);
    dtn^.abi := vstloc.AbsoluteIndex(nd);
    dtn^.dbmyid := StrToInt(sl.Values['myid']);
    dtn^.tag := StrToInt(sl.Values['tag']);
    dtn^.bp := bp;
    //  showmessage('xtag2');
    //xtag2(bp,nd);
    qrz.Next;
    sl.Free;
  end;
end;



procedure tform1.xtag1(bp: integer; ndo: pvirtualnode);
var
  sl: TStringList;
  s: string;
  dataloc, dtn: pvstrecordloc;
  nd: pvirtualnode;
  mx: tmyrcvtr;
  qrz: TSQLQuery;
begin

  dataloc := vstloc.GetNodeData(ndo);
  s := 'select * from tssloc_locations where tag=1 and bp=' + IntToStr(bp) +
    ' and bp>=' + IntToStr(dataloc^.dbmyid);
  log('y', 'xtag1 s=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.SQL.Clear;
  qrz.DataBase := formglink.pqc1;
  qrz.Transaction := formglink.tr1;
  qrz.sql.Add(s);
  qrz.Active := True;
  while not qrz.EOF do
  begin
    ;
    sl := TStringList.Create;
    sl.Values['myid'] := qrz.FieldByName('myid').AsString;
    sl.Values['nm0'] := qrz.FieldByName('name').AsString;
    sl.Values['tag'] := qrz.FieldByName('tag').AsString;
    sl.Values['sti'] := qrz.FieldByName('sti').AsString;
    sl.Values['sti1'] := '-1';
    sl.Values['bp'] := qrz.FieldByName('bp').AsString;
    //log('y','sl='+sl.text);
    dataloc := vstloc.GetNodeData(currnd);
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnnloc(ndo, sl);
    // currnd:=nd;
    dtn := vstloc.GetNodeData(nd);
    dtn^.abi := vstloc.AbsoluteIndex(nd);
    dtn^.dbmyid := StrToInt(sl.Values['myid']);
    dtn^.tag := StrToInt(sl.Values['tag']);
    dtn^.bp := bp;
    xtag2(StrToInt(sl.Values['myid']), nd);
    qrz.Next;
    sl.Free;
  end;
end;

procedure tform1.tree1(ndo: pvirtualnode; myid, bp: integer);
var
  s, nm: string;
  dataloc, dtn: pvstrecordloc;
  nd: pvirtualnode;
  qrz: TSQLQuery;
begin
  currndloc := ndo;
  s := 'select myid,bp,name from tssloc_locations where bp>=' + IntToStr(bp);
  log('y', 'tree1 s=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.SQL.Clear;
  qrz.DataBase := formglink.pqc1;
  qrz.Transaction := formglink.tr1;
  qrz.sql.Add(s);
  qrz.Active := True;
  while not qrz.EOF do
  begin
    ;
    application.ProcessMessages;
    myid := qrz.FieldByName('myid').AsInteger;
    bp := qrz.FieldByName('bp').AsInteger;
    nm := qrz.FieldByName('name').AsString;
    log('c', 'tree1 nm=' + nm);
    nd := vstloc.AddChild(currndloc);
    dataloc := vstloc.GetNodeData(nd);
    dataloc^.nm0 := nm;
    dataloc^.bp := bp;
    dataloc^.dbmyid := myid;
    qrz.Next;
    //showmessage('exit tut');
    exit;
  end;

end;




procedure tform1.rd_all_myid;
var
  myid, bp: integer;
  sl: TStringList;
  s, nm: string;
  dataloc, dtn: pvstrecordloc;
  nd: pvirtualnode;
  mx: tmyrcvtr;
  qrz: TSQLQuery;
begin
  s := 'select myid,bp,name from tssloc_locations  order by bp';
  log('y', 'rd_all_myid s=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.SQL.Clear;
  qrz.DataBase := formglink.pqc1;
  qrz.Transaction := formglink.tr1;
  qrz.sql.Add(s);
  qrz.Active := True;
  while not qrz.EOF do
  begin
    ;
    application.ProcessMessages;
    myid := qrz.FieldByName('myid').AsInteger;
    bp := qrz.FieldByName('bp').AsInteger;
    nm := qrz.FieldByName('name').AsString;
    sltree.Values[IntToStr(myid)] := IntToStr(bp);
    qrz.Next;
      {
      if bp=-1 then begin
        nd:=vstloc.AddChild(currndloc);
        dataloc:=vstloc.GetNodeData(nd);
        dataloc^.nm0:=nm;
        dataloc^.bp:=bp;
        dataloc^.dbmyid:=myid;
       // tree1(nd,myid+1,bp);
       end;
       }
  end;
  log('y', 'sltree count=' + IntToStr(sltree.Count));

end;



procedure tform1.xtag0;
var
  sl: TStringList;
  s: string;
  dataloc, dtn: pvstrecordloc;
  nd: pvirtualnode;
  mx: tmyrcvtr;
  qrz: TSQLQuery;
begin

  s := 'select * from tssloc_locations where tag=0';
  log('y', 'xtag0 s=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.SQL.Clear;
  qrz.DataBase := formglink.pqc1;
  qrz.Transaction := formglink.tr1;
  qrz.sql.Add(s);
  qrz.Active := True;
  while not qrz.EOF do
  begin
    ;
    sl := TStringList.Create;
    sl.Values['myid'] := qrz.FieldByName('myid').AsString;
    sl.Values['nm0'] := qrz.FieldByName('name').AsString;
    sl.Values['tag'] := qrz.FieldByName('tag').AsString;
    sl.Values['sti'] := qrz.FieldByName('sti').AsString;
    sl.Values['sti1'] := '-1';
    sl.Values['bp'] := qrz.FieldByName('bp').AsString;
    //log('y','sl='+sl.text);
    dataloc := vstloc.GetNodeData(currnd);
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnnloc(currnd, sl);

    dtn := vstloc.GetNodeData(nd);
    dtn^.abi := vstloc.AbsoluteIndex(nd);
    dtn^.dbmyid := StrToInt(sl.Values['myid']);
    dtn^.tag := StrToInt(sl.Values['tag']);
    dtn^.bp := -1;
    xtag1(dtn^.dbmyid, nd);
    qrz.Next;
    sl.Free;
  end;
end;




function tform1.fillinfoloc(abi: integer): tmyrcvtr;
var
  sl: TStringList;
  s: string;
  mx: tmyrcvtr;
  qrz: TSQLQuery;
begin

  s := 'select * from tssloc_locations where abi=' + IntToStr(abi) + ' limit 1';
  // log('y','fillinfoloc s='+s);
  qrz := TSQLQuery.Create(self);
  qrz.SQL.Clear;
  qrz.DataBase := formglink.pqc1;
  qrz.Transaction := formglink.tr1;
  qrz.sql.Add(s);
  qrz.Active := True;
  mx.nm0 := qrz.FieldByName('name').AsString;
  mx.sti := -1; //qrz.FieldByName('sti').asinteger;
  mx.sti1 := -1;
  mx.tag := qrz.FieldByName('tag').AsInteger;
  mx.bp := qrz.FieldByName('bp').AsInteger;
  Result := mx;

end;

procedure Tform1.filltreeloc;
var
  i: integer;
  nd: pvirtualnode;
  dataloc: pvstrecordloc;
  abi, lmt: integer;
  sl: TStringList;
  mx: tmyrcvtr;
begin
  ShowMessage('FILLTREELOC START');
  // form1.log('y','start findndofnm0 1 NM1='+nm0+'>');
  try
    lmt := 100;
    i := 1;
    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := vstloc.getfirst(True);
    dataloc := vstloc.getnodedata(nd);
    //form1.log('y','start findndofnm1 2 nn1='+nm1+'>');
    while True do
    begin
      application.ProcessMessages;
      nd := vstloc.getnext(nd);
      i := i + 1;
      if i > lmt then exit;
      // if not assigned(nd) then exit;
      dataloc := vstloc.getnodedata(nd);
      abi := vstloc.AbsoluteIndex(nd);
      if abi = 0 then exit;
      mx := fillinfoloc(abi);
      dataloc^.nm0 := mx.nm0;
      dataloc^.tag := mx.tag;
      dataloc^.sti := mx.sti;
      dataloc^.sti1 := mx.sti1;
      // log('l','fffffffffffffff abi='+inttostr(abi));
      // vstloc.Refresh;
    end;
    // vstloc.Refresh;
  except
    on e: Exception do
    begin
      form1.log('e', 'filltreeloc,e=' + e.message);
    end;
  end;
  //vstloc.Refresh;
end;


function Tform1.deletechildloc(ndp: pvirtualnode; bp, tgg: integer): integer;
var
  i: integer;
  nd: pvirtualnode;
  dl, dlp: pvstrecordloc;
  n, limit: integer;
begin
  // form1.log('y','start findndofnm0 1 NM1='+nm0+'>');
  try
    Result := 0;
    n := 0;
    // dlp:=vstloc.getnodedata(ndp);
    // bp:=dlp^.bp;
    limit := vstloc.TotalCount;
    nd := vstloc.getfirst(True);
    dl := vstloc.getnodedata(nd);
    while True do
    begin
      n := n + 1;
      application.ProcessMessages;
      nd := vstloc.getnext(nd);
      // if not assigned(nd) then exit;
      if nd <> nil then
      begin
        dl := vstloc.getnodedata(nd);
        if dl^.tag = tgg then
          log('w', 'nm0=' + dl^.nm0 + ' /dbmyidx=' + IntToStr(dl^.dbmyid) + ' / bp=' +
            IntToStr(bp) + ' /bpx=' + IntToStr(dl^.bp));
        if (dl^.tag = tgg) and (dl^.bp = bp) then
        begin
          Result := Result + 1;
          vstloc.DeleteNode(nd);
          //showmessage('delete='+dl^.nm0);
        end;
      end;

      if n > limit then
      begin
        log('r', 'n=' + IntToStr(n));
        exit;
      end;
    end;

    //form1.log('y','findndofnm1 not found nm='+nm);
    //exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndofnm1,e=' + e.message + '/i=' + IntToStr(i));
    end;
  end;
end;


function Tform1.findndoftag(tgg: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecord;
begin
  log('l', 'findndoftag START SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS');
  try
    Result := nil;
    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := vst.getfirst(True);
    Data := vst.getnodedata(nd);
    //form1.log('y','start findndofnm1 2 nn1='+nm1+'>');
    while True do
    begin
      application.ProcessMessages;
      nd := vst.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vst.getnodedata(nd);
      if Data^.tag = tgg then
      begin
        Result := nd;
        log('l',
          'findndoftag FOUND FOUND @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22');
        exit;
      end;
    end;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndofTAG,e=' + e.message);
    end;
  end;
end;




function Tform1.findndnm0tag(nm: string; tgg: integer): pvirtualnode;
var
  i: integer;
  nd: pvirtualnode;
  Data: pvstrecord;
begin
  // form1.log('y','start findndofnm0 1 NM1='+nm0+'>');
  try
    Result := nil;
    //showmessage('findndnm0tag nm='+nm+' /tgg='+inttostr(tgg));
    nd := vst.getfirst(True);
    Data := vst.getnodedata(nd);
    Result := nil;
    while True do
    begin
      application.ProcessMessages;
      nd := vst.getnext(nd);
      //form1.log('y','nm0='+data.nm0+'>');
      if not assigned(nd) then exit;
      Data := vst.getnodedata(nd);
      if trim(Data^.nm0) = nm then
      begin
        Result := nd;
        //form1.log('l','findndofnm1 FOUND FOUND ='+data.nm0);
        exit;
      end;
    end;
    ShowMessage('nm=' + nm);
    form1.log('y', 'findndof not found nm=' + nm);
    exit;
  except
    on e: Exception do
    begin
      form1.log('e', 'findndof,e=' + e.message + '/i=' + IntToStr(i));
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
  act: boolean;
begin
  dataold := vst.GetNodeData(ndc);
  comp := dataold^.comp;
  ch := dataold^.ch;
  s := 'select * from tss_acl  where bp=' + IntToStr(dataold^.dbmyid);
  log('l', 's=' + s);
  //SHOWMESSAGE('ACl='+s);

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
    act := qrx.FieldByName('actual').AsBoolean;
    sl.Values['nm1'] := 'act=' + sl.Values['actual'] + ' contr. ACS ' +
      ',ctyp=' + sl.Values['ctyp'];
    s := sl.Values['nm1'] + ',' + sl.Values['actual'];
    sl.Values['sti'] := '-1';
    sl.Values['sti1'] := '-1';
    sl.Values['tag'] := '2';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnn(ndc, sl);
    Data := vst.GetNodeData(nd);
    Data^.ctyp := sl.Values['ctyp'];
    Data^.bp := dataold^.dbmyid;
    Data^.dbmyid := StrToInt(sl.Values['myid']);
    Data^.act := act;
    Data^.comp := comp;
    Data^.ch := ch;
    Data := fidkomu(Data);
    Data^.ac := sl.Values['nm0'];
    VST.Expanded[ndc] := True;
    log('c', 'sl=' + sl.Text);
    read_ports(nd);
    qrx.Next;
    sl.Clear;
  end;

end;

procedure TForm1.read_sensors(ndp: pvirtualnode);
var
  Data, dataold: pvstrecord;
  nd, pnd: pvirtualnode;
  nump, s, comp, ch, ac, port, sensor, sti: string;
  sl: TStringList;
  qrx: TSQLQuery;
begin
  dataold := vst.GetNodeData(ndp);
  comp := dataold^.comp;
  ch := dataold^.ch;
  ac := dataold^.ac;
  port := dataold^.port;
  ch := dataold^.ch;
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
    sl.Values['sti'] := qrx.FieldByName('sti').AsString;
    sl.Values['nm0'] := qrx.FieldByName('name').AsString;
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['actual'] := qrx.FieldByName('ignore').AsString;
    sl.Values['bp'] := qrx.FieldByName('bp').AsString;
    sl.Values['bploc'] := qrx.FieldByName('bploc').AsString;
    sl.Values['nm1'] := sl.Values['myid'] + zp + sl.Values['bploc'];
    s := sl.Values['nm1'] + ',' + sl.Values['actual'];
    sl.Values['sti'] := '-1';
    sl.Values['sti1'] := '-1';
    sl.Values['tag'] := '4';
    sl.Values['ndcheck'] := 'y';
    sl.Values['ndcheck_state'] := 'n';
    nd := form1.fnn(ndp, sl);
    Data := vst.GetNodeData(nd);

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
      Data^.sensor := sl.Values['nm0'];
      Data := fidkomu(Data);

    end;
    qrx.Next;
    sl.Clear;
  end;

end;

function tform1.getmarsforports(myid: integer): integer;
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

procedure TForm1.read_ports(ndc: pvirtualnode);
var
  Data, dataold: pvstrecord;
  nd, pnd: pvirtualnode;
  nump, s, comp, ch, ac, port: string;
  sl: TStringList;
  qrx: TSQLQuery;
  mrn: integer;
begin

  dataold := vst.GetNodeData(ndc);
  comp := dataold^.comp;
  ch := dataold^.ch;
  ac := dataold^.ac;
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
    sl.Values['ndcheck'] := 'n';
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
    Data := fidkomu(Data);

    Data^.nm1 := 'mrn=' + IntToStr(Data^.mrn);
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

procedure TForm1.vstLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Stream: TStream);
var
  Data: pvstrecord;
  abi: integer;
  mx: tmyrcvtr;
begin
  abi := vst.AbsoluteIndex(node);
  log('l', 'abi=' + IntToStr((abi)));
  Data := vst.GetNodeData(node);
  // mx:=getvtrx('vst',app,abi);
  // log('l','rc='+mx.nm0+' /abi='+inttostr((mx.abi)));
  //log('r','rc='+mx.nm0+' /abi='+inttostr((mx.abi)));
end;

procedure TForm1.vstlocBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  exit;
end;

procedure TForm1.vstlocChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  CC, nc: integer;
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
  // exit;
  currmtag := -1;
  dataloc := vstLOC.GetNodeData(node);
  if dataloc = nil then exit;

  CURRNDLOC := NODE;
  dataloc := vstLOC.GetNodeData(node);
  abi := vstloc.AbsoluteIndex(node);
  log('w', 'vstlocch nm0=' + dataloc^.nm0);
  log('w', 'vstlocch bp=' + IntToStr(dataloc^.bp));
  log('w', 'vstlocch abi=' + IntToStr(abi) + ' /tag=' + IntToStr(dataloc^.tag));
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
    //datandp:=vstLOC.GetNodeData(ndp);
    //nm:=datandp^.nm0;
    //log('l','nm='+nm);
    //exit;
    f := True;
  except
    f := False;
    log('e', 'error vstchange');
  end;


  if dataloc^.tag = 0 then
  begin
    currmtag := 0;
    vstloc.PopupMenu := poploctag0;
  end;

  if dataloc^.tag = 1 then
  begin
    currmtag := 1;
    cc := vstloc.ChildCount[currndloc];
    //dataloc^.nm1:=s;
    nm1 := s;
    s := 'ksens=' + IntToStr(cc);
    stag1 := s;
    log('y', 's=' + s);
    vstloc.PopupMenu := popLOCTAG1;
  end;

  if dataloc^.tag = 2 then
  begin
    currmtag := 2;
    // dataloc^.nm1:='MRN='+dataloc^.smrn;
    // vstloc.Refresh;
    //cs2 :=getsens(currnd);
    vstloc.PopupMenu := xpoploc2;

    //showmessage('nm1='+ dataloc^.nm1);
  end;
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
    vstloc.PopupMenu := xpoploc3;
  end;

  if dataloc^.tag = -1 then
  begin
    currmtag := -1;
    vstloc.PopupMenu := popLOCNIL;
  end;


  if dataloc^.tag = 1 then
  begin
    currmtag := 1;
    vstloc.PopupMenu := poploctag1;
    //dataloc^.nm1:=inttostr(dataloc^.mrn);
  end;
  if dataloc^.tag = 3 then
  begin
    currmtag := 3;
    vstloc.PopupMenu := poploctag3;
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
  stag := IntToStr(dataloc^.tag);
  dbmyid := IntToStr(dataloc^.dbmyid);
  log('c', 'VSTLOC / mrn=' + dataloc^.smrn + ' / abi=' +
    IntToStr(abi) + ' /tag= ' + stag + ' /dbmyid=' + dbmyid + '/ bp=' + IntToStr(
    dataloc^.bp) + ' /bpsens=' + IntToStr(dataloc^.bps) + '/loccode=' + IntToStr(
    dataloc^.loccode));

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
    sl.Values['nm1'] := 'act=' + acts + ',channel=' + sl.Values['chtype'];
    sl.Values['sti'] := '-1';
    sl.Values['sti1'] := '-1';
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

procedure tform1.setlocsensor(ev: string; sti: integer);
var
  nd: pvirtualnode;
  sl: TStringList;
  Data: pvstrecordloc;
begin
  sl := TStringList.Create;
  sl.Values['nm0'] := ev;
  //sl.Values['dbmyid']:=sl.Values['myid'];
  sl.Values['sti'] := IntToStr(sti);
  sl.Values['tag'] := IntToStr(2);
  sl.Values['sti1'] := '-1';
  sl.Values['ndcheck'] := 'y';
  sl.Values['ndcheck_state'] := 'n';
  //FIRSTNDLOC:=vstLOC.getfirst(true);
  nd := form1.fnnloc(currndloc, sl);
end;

procedure tform1.onlyreadlocc(ndo: pvirtualnode);
var
  dataloc: pvstrecordloc;
  nd, pnd: pvirtualnode;
  s, nm: string;
  myid, bp, keyname: string;
  sl: TStringList;
  qrx: TSQLQuery;
begin
  try
    dataloc := vstloc.GetNodeData(ndo);
    // showmessage('nm0='+dataloc^.nm0);
    //exit;
    //s:='select * from tssloc_controls where bp='+slin.Values['dbmyid'] ;
    s := 'select * from tssloc_controls where bp=' + IntToStr(dataloc^.dbmyid);
    log('l', 's=' + s);
    //   showmessage('s='+s);


    qrx := TSQLQuery.Create(self);
    qrx.DataBase := formglink.pqc1;
    qrx.SQL.Add(s);
    qrx.Active := True;
    sl := TStringList.Create;
    while not qrx.EOF do
    begin
      sl.Values['name'] := qrx.FieldByName('name').AsString;
      sl.Values['fckp'] := qrx.FieldByName('fckp').AsString;
      sl.Values['ioflag'] := qrx.FieldByName('ioflag').AsString;
      sl.Values['smrn'] := qrx.FieldByName('smrn').AsString;
      sl.Values['nm0'] := sl.Values['name'];
      sl.Values['sti'] := qrx.FieldByName('sti').AsString;
      sl.Values['tag'] := qrx.FieldByName('tag').AsString;
      sl.Values['bp'] := qrx.FieldByName('bp').AsString;
      sl.Values['dbmyid'] := qrx.FieldByName('myid').AsString;
      sl.Values['bps'] := qrx.FieldByName('bps').AsString;
      sl.Values['bpp'] := qrx.FieldByName('bpp').AsString;
      sl.Values['smrn'] := qrx.FieldByName('smrn').AsString;
      sl.Values['sti1'] := '-1';

      if sl.Values['nm0'] <> 'key' then
      begin
        sl.Values['ndcheck'] := 'n';
        sl.Values['ndcheck_state'] := 'n';
      end
      else
      begin
        sl.Values['ndcheck'] := 'y';
        sl.Values['ndcheck_state'] := 'n';

      end;


      nd := form1.fnnloc(ndo, sl);
      dataloc := vstloc.GetNodeData(nd);
      dataloc^.bp := StrToInt(sl.Values['bp']);
      dataloc^.bps := StrToInt(sl.Values['bps']);
      dataloc^.bpp := StrToInt(sl.Values['bpp']);
      dataloc^.dbmyid := StrToInt(sl.Values['dbmyid']);
      dataloc^.tag := StrToInt(sl.Values['tag']);
      dataloc^.sti := StrToInt(sl.Values['sti']);
      dataloc^.smrn := sl.Values['smrn'];
      dataloc^.sti := -1;
      dataloc^.keyname := sl.Values['bp'] + zp + sl.Values['dbmyid'] + zp +
        sl.Values['nm0'] + zp + sl.Values['tag'];
      qrx.Next;

    end;
  except
    on ee: Exception do
    begin
      log('e', 'readlocc ,ee=' + ee.Message);
    end;
  end;

end;

procedure tform1.readlocc(slin: TStringList; ndo: pvirtualnode);
var
  dataloc: pvstrecordloc;
  nd, pnd: pvirtualnode;
  s, nm: string;
  myid, bp, keyname: string;
  sl: TStringList;
  qrx: TSQLQuery;
  bpfloor: integer;
begin
  try
    dataloc := vstloc.GetNodeData(ndo);
    bpfloor := dataloc^.bpfloor;
    s := 'select * from tssloc_controls where bp=' + IntToStr(dataloc^.dbmyid);
    log('l', 's=' + s);
    //   showmessage('s='+s);


    qrx := TSQLQuery.Create(self);
    qrx.DataBase := formglink.pqc1;
    qrx.SQL.Add(s);
    qrx.Active := True;
    sl := TStringList.Create;
    while not qrx.EOF do
    begin
      sl.Values['name'] := qrx.FieldByName('name').AsString;
      sl.Values['fckp'] := qrx.FieldByName('fckp').AsString;
      sl.Values['ioflag'] := qrx.FieldByName('ioflag').AsString;
      sl.Values['smrn'] := qrx.FieldByName('smrn').AsString;
      sl.Values['nm0'] := sl.Values['name'];
      sl.Values['sti'] := qrx.FieldByName('sti').AsString;
      sl.Values['tag'] := qrx.FieldByName('tag').AsString;
      sl.Values['bp'] := qrx.FieldByName('bp').AsString;
      sl.Values['dbmyid'] := qrx.FieldByName('myid').AsString;
      sl.Values['bps'] := qrx.FieldByName('bps').AsString;
      sl.Values['bpp'] := qrx.FieldByName('bpp').AsString;
      sl.Values['smrn'] := qrx.FieldByName('smrn').AsString;
      sl.Values['sti1'] := '-1';

      if sl.Values['nm0'] <> 'key' then
      begin
        sl.Values['ndcheck'] := 'n';
        sl.Values['ndcheck_state'] := 'n';
      end
      else
      begin
        sl.Values['ndcheck'] := 'y';
        sl.Values['ndcheck_state'] := 'n';
      end;


      nd := form1.fnnloc(ndo, sl);
      dataloc := vstloc.GetNodeData(nd);
      dataloc^.bp := StrToInt(sl.Values['bp']);
      dataloc^.bps := StrToInt(sl.Values['bps']);
      dataloc^.bpp := StrToInt(sl.Values['bpp']);
      dataloc^.dbmyid := StrToInt(sl.Values['dbmyid']);
      dataloc^.tag := StrToInt(sl.Values['tag']);
      dataloc^.sti := StrToInt(sl.Values['sti']);
      dataloc^.smrn := sl.Values['smrn'];
      dataloc^.ioflag := strtobool(sl.Values['ioflag']);
      dataloc^.fckp := strtobool(sl.Values['fckp']);
      dataloc^.bpfloor := bpfloor;
      dataloc^.sti := -1;
      dataloc^.keyname := sl.Values['bp'] + zp + sl.Values['dbmyid'] + zp +
        sl.Values['nm0'] + zp + sl.Values['tag'];

      qrx.Next;

    end;
  except
    on ee: Exception do
    begin
      log('e', 'readlocc ,ee=' + ee.Message);
    end;
  end;

end;


procedure tform1.readlocetaj(slin: TStringList; ndo: pvirtualnode);
var
  dataloc: pvstrecordloc;
  nd, pnd: pvirtualnode;
  s, nm: string;
  myid, bp, keyname: string;
  sl: TStringList;
  qrx: TSQLQuery;
begin
  s := 'select * from tssloc_locations where tag=-2 and bp=' + slin.Values['dbmyid'];
  // where bp='+inttostr(data^.dbmyid);
  log('l', 's=' + s);
  //SHOWMESSAGE('READLOG1 ='+s);

  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  sl := TStringList.Create;
  while not qrx.EOF do
  begin
    sl.Values['name'] := qrx.FieldByName('name').AsString;
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['bp'] := qrx.FieldByName('bp').AsString;
    sl.Values['keyname'] := qrx.FieldByName('keyname').AsString;
    sl.Values['tag'] := qrx.FieldByName('tag').AsString;
    sl.Values['bpp'] := qrx.FieldByName('bpp').AsString;
    sl.Values['sti'] := qrx.FieldByName('sti').AsString;

    sl.Values['nm0'] := sl.Values['name'];
    sl.Values['dbmyid'] := sl.Values['myid'];
    sl.Values['sti1'] := '-1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    //FIRSTNDLOC:=vstLOC.getfirst(true);
    nd := form1.fnnloc(ndo, sl);
    dataloc := vstloc.GetNodeData(nd);
    dataloc^.bp := StrToInt(sl.Values['bp']);
    dataloc^.dbmyid := StrToInt(sl.Values['dbmyid']);
    dataloc^.tag := StrToInt(sl.Values['tag']);
    dataloc^.sti := -1;//strtoint(sl.Values['sti']);
    dataloc^.keyname := sl.Values['bp'] + zp + sl.Values['dbmyid'] + zp +
      sl.Values['nm0'] + zp + sl.Values['tag'];
    //showmessage('readtag1='+dataloc^.nm0+'/dbmyid='+inttostr(dataloc^.dbmyid));
    readlocc(sl, nd);
    readloctag1(sl, nd);

    //VSTloc.Expanded[nd]:=true;
    qrx.Next;
    sl.Clear;
  end;
  QRX.Free;
  SL.Free;
end;

{
function tform1.fcopyloc:boolean;
var
  s:string;
  myid:string;
  qrx,qry: TSQLQuery;
  slin,slo:tstringlist;
begin
     showmessage('fcopyloc');
     qrx:=TSQLQuery.Create(self);
     qrx.DataBase:=formglink.pqc1;
     qrx.SQL.Clear;
     qrx.sql.add('select * from tssloc_locations;');
     qrx.Active:=true;

     qry:=TSQLQuery.Create(self);
     qry.DataBase:=formglink.pqc1;
     qry.Transaction:=formglink.tr1;
     slo:=tstringlist.Create;
     while not qrx.EOF do begin;
      slo.Values['name']:=qrx.FieldByName('name').AsString;
      qry.Post;
      qrx.Next;
     end;
     qry.Close;
     formglink.tr1.commit;



      //showmessage('name='+ slo.Values['name']+'/exclude='+slex.text);
      slo.Values['myid']   :=qrx.FieldByName('myid').AsString;
      slo.Values['bp']     :=qrx.FieldByName('bp').AsString;

      slo.Values['keyname']:=qrx.FieldByName('keyname').AsString;
      slo.Values['tag']:=qrx.FieldByName('tag').AsString;
      slo.Values['bpp']:=qrx.FieldByName('bpp').AsString;
      slo.Values['sti']:=qrx.FieldByName('sti').AsString;
      slo.Values['nm0']:=sl.Values['name'];

end;
}



procedure tform1.zreadloctag1(ndo: pvirtualnode);
var
  dataloc, datando: pvstrecordloc;
  nd, pnd: pvirtualnode;
  s, nm: string;
  myid, keyname: string;
  sl: TStringList;
  qrx: TSQLQuery;
  bpfloor, bp, oldmyid, newmyid: integer;
begin
  //SHOWMESSAGE('READLOG1 ='+s);
  datando := vstloc.GetNodeData(ndo);
  bpfloor := datando^.bpfloor;
  bp := datando^.dbmyid;
  oldmyid := datando^.dbmyid;

  s := 'select * from tssloc_locations where tag=-2 or tag=1';
  log('l', 's=' + s);
  // exit;
  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  sl := TStringList.Create;
  while not qrx.EOF do
  begin
    sl.Values['name'] := qrx.FieldByName('name').AsString;
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['bp'] := qrx.FieldByName('bp').AsString;
    sl.Values['keyname'] := qrx.FieldByName('keyname').AsString;
    sl.Values['tag'] := qrx.FieldByName('tag').AsString;
    sl.Values['bpp'] := qrx.FieldByName('bpp').AsString;
    sl.Values['sti'] := qrx.FieldByName('sti').AsString;

    sl.Values['nm0'] := sl.Values['name'];
    sl.Values['dbmyid'] := sl.Values['myid'];
    sl.Values['sti1'] := '-1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    //FIRSTNDLOC:=vstLOC.getfirst(true);
    nd := form1.fnnloc(ndo, sl);
    dataloc := vstloc.GetNodeData(nd);
    dataloc^.bp := StrToInt(sl.Values['bp']);
    dataloc^.dbmyid := StrToInt(sl.Values['dbmyid']);
    newmyid := StrToInt(sl.Values['dbmyid']);
    dataloc^.tag := StrToInt(sl.Values['tag']);
    dataloc^.bpfloor := bpfloor;
    dataloc^.sti := -1;//strtoint(sl.Values['sti']);
    dataloc^.keyname := sl.Values['bp'] + zp + sl.Values['dbmyid'] + zp +
      sl.Values['nm0'] + zp + sl.Values['tag'];

    readlocc(sl, nd);
    // readloctag1(sl,nd);
    if oldmyid = newmyid then  ndo := nd;
    // VSTloc.Expanded[nd]:=true;
    qrx.Next;
    sl.Clear;
  end;
  QRX.Free;
  SL.Free;
end;


procedure tform1.readloctag1(slin: TStringList; ndo: pvirtualnode);
var
  dataloc, datando: pvstrecordloc;
  nd, pnd: pvirtualnode;
  s, nm: string;
  myid, bp, keyname: string;
  sl: TStringList;
  qrx: TSQLQuery;
  bpfloor: integer;
begin
  s := 'select * from tssloc_locations where tag=1 and bp=' + slin.Values['dbmyid'];
  log('l', 's=' + s);
  s := 'select * from tssloc_locations where tag=1 and bp=' + slin.Values['dbmyid'];
  //SHOWMESSAGE('READLOG1 ='+s);
  datando := vstloc.GetNodeData(ndo);
  bpfloor := datando^.bpfloor;
  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  sl := TStringList.Create;
  while not qrx.EOF do
  begin
    sl.Values['name'] := qrx.FieldByName('name').AsString;
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['bp'] := qrx.FieldByName('bp').AsString;
    sl.Values['keyname'] := qrx.FieldByName('keyname').AsString;
    sl.Values['tag'] := qrx.FieldByName('tag').AsString;
    sl.Values['bpp'] := qrx.FieldByName('bpp').AsString;
    sl.Values['sti'] := qrx.FieldByName('sti').AsString;

    sl.Values['nm0'] := sl.Values['name'];
    sl.Values['dbmyid'] := sl.Values['myid'];
    sl.Values['sti1'] := '-1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    //FIRSTNDLOC:=vstLOC.getfirst(true);
    nd := form1.fnnloc(ndo, sl);
    dataloc := vstloc.GetNodeData(nd);
    dataloc^.bp := StrToInt(sl.Values['bp']);
    dataloc^.dbmyid := StrToInt(sl.Values['dbmyid']);
    dataloc^.tag := StrToInt(sl.Values['tag']);
    dataloc^.bpfloor := bpfloor;
    dataloc^.sti := -1;//strtoint(sl.Values['sti']);
    dataloc^.keyname := sl.Values['bp'] + zp + sl.Values['dbmyid'] + zp +
      sl.Values['nm0'] + zp + sl.Values['tag'];

    readlocc(sl, nd);
    readloctag1(sl, nd);
    // VSTloc.Expanded[nd]:=true;
    qrx.Next;
    sl.Clear;
  end;
  QRX.Free;
  SL.Free;
end;


procedure tform1.read_locfloor(ndo: pvirtualnode);
var
  dataloc: pvstrecordloc;
  nd, pnd: pvirtualnode;
  s, nm: string;
  myid, bp, keyname: string;
  sl: TStringList;
  qrx: TSQLQuery;
begin
  // dataloc:=vstloc.GetNodeData(ndo);
  // log('m','read_locfloor START');
  s := 'select * from tssloc_locations where tag=-2';
  log('r', 's=' + s);

  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  log('r', 'rc=' + IntToStr(qrx.RecordCount));
  sl := TStringList.Create;
  //LOG('r','read_locfloor 0.1');
  while not qrx.EOF do
  begin
    sl.Values['name'] := qrx.FieldByName('name').AsString;
    // log('r','name='+ sl.Values['name']);
    sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    sl.Values['bp'] := qrx.FieldByName('bp').AsString;
    sl.Values['bpfloor'] := qrx.FieldByName('myid').AsString;
    sl.Values['tag'] := qrx.FieldByName('tag').AsString;
    sl.Values['sti'] := qrx.FieldByName('sti').AsString;
    sl.Values['nm0'] := sl.Values['name'];
    sl.Values['dbmyid'] := sl.Values['myid'];
    // LOG('r','read_locfloor 1');
    sl.Values['sti1'] := '-1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    //FIRSTNDLOC:=vstLOC.getfirst(true);
    nd := form1.fnnloc(ndo, sl);
    //showmessage('stop');

    ndo := nd;   //  sudafloor

    dataloc := vstloc.GetNodeData(nd);
    dataloc^.bp := StrToInt(sl.Values['bp']);
    dataloc^.dbmyid := StrToInt(sl.Values['dbmyid']);
    dataloc^.bpfloor := StrToInt(sl.Values['bpfloor']);
    //showmessage(sl.Values['nm0']);
    // dataloc^.keyname:=sl.Values['bp']+zp+ sl.Values['dbmyid']+zp+ sl.Values['nm0']+zp+ sl.Values['tag'];
    // showmessage('readtag0='+dataloc^.nm0+'/dbmyid='+inttostr(dataloc^.dbmyid));
    // readlocetaj(sl,nd);
    readloctag1(sl, nd);
    // LOG('r','read_locfloor next');
    // VSTloc.Expanded[FIRSTNDLOC]:=true;
    //VSTloc.Expanded[nd]:=true;
    qrx.Next;
    //sl.Clear;
  end;
end;


procedure tform1.prdchild;
var
  qrx: TSQLQuery;
  s: string;
begin
  s := 'select * from tssloc_locations where myid>' + IntToStr(myprd.currid) + ' and  bp=' +
    IntToStr(myprd.currid) + ' order by myid desc';
  log('c', ' prdchild s=' + s);
  qrx := TSQLQuery.Create(self);
  qrx.DataBase := formglink.pqc1;
  qrx.SQL.Add(s);
  qrx.Active := True;
  if qrx.RecordCount = 0 then
  begin
    myprd.lastid := -1;
    exit;
  end;
  while not qrx.EOF do
  begin
    myprd.sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    myprd.sl.Values['bp'] := qrx.FieldByName('bp').AsString;
    myprd.sl.Values['sti'] := qrx.FieldByName('sti').AsString;
    myprd.sl.Values['sti1'] := '-1';
    myprd.sl.Values['name'] := qrx.FieldByName('name').AsString;
    myprd.sl.Values['nm0'] := qrx.FieldByName('name').AsString;
    // myprd.currid:=strtoint(myprd.sl.Values['myid']);
    //showmessage('child='+ myprd.sl.text);
    form1.formirnd(nil, myprd.sl);
    qrx.Next;
  end;

end;

function tform1.formirnd(ndo: pvirtualnode; slin: TStringList): pvirtualnode;
var
  tgg: integer;
  nd: pvirtualnode;
begin
  ndo := nil;
  slin.Values['ndcheck'] := 'y';
  slin.Values['ndcheck_state'] := 'n';
  tgg := StrToInt(slin.Values['tag']);
  nd := fnnloc(ndo, slin);
  Result := nd;

end;

procedure tform1.prdnext;
var
  qrx: TSQLQuery;
  s: string;
  ndo: pvirtualnode;
begin
  try
    //  showmessage('prdnext START ');
    if myprd.sl = nil then myprd.sl := TStringList.Create;
    s := 'select * from tssloc_locations where myid>' + IntToStr(
      myprd.currid) + ' order by myid limit 1';
    log('y', 'prdnext s=' + s);
    //showmessage('prdnext s='+s);
    qrx := TSQLQuery.Create(self);
    qrx.DataBase := formglink.pqc1;
    qrx.SQL.Add(s);
    qrx.Active := True;
    //showmessage('prdnext P00');

    if qrx.RecordCount = 0 then
    begin
      myprd.lastid := -1;
      exit;
    end;
    myprd.sl.Values['myid'] := qrx.FieldByName('myid').AsString;
    myprd.sl.Values['bp'] := qrx.FieldByName('bp').AsString;
    myprd.sl.Values['tag'] := qrx.FieldByName('tag').AsString;
    myprd.sl.Values['nm0'] := qrx.FieldByName('name').AsString;
    myprd.sl.Values['sti'] := qrx.FieldByName('sti').AsString;
    myprd.sl.Values['sti1'] := '-1';
    myprd.currid := StrToInt(myprd.sl.Values['myid']);
    // showmessage('prdnext sl='+ myprd.sl.text);
    if StrToInt(myprd.sl.Values['tag']) = -1 then ndo := nil;
    formirnd(ndo, myprd.sl);
    //log('y','prdnext name='+ myprd.sl.Values['name']+ ' s='+s);
    prdchild;
    myprd.currid := myprd.currid + 1;
    prdnext;
    // qrx.Free;
  except
    on ee: Exception do
    begin
      log('e', 'prdnext ,ee=' + ee.Message);
    end;
  end;

end;

procedure tform1.prdp; //suda06
var
  i: integer;
begin
  myprd.lastid := 1;
  myprd.currid := 1;
  log('w', 'prdp START----------------------------------------------------------------------------');
  log('w', 'prdp START----------------------------------------------------------------------------');
  while myprd.lastid >= 0 do
  begin
    application.ProcessMessages;
    prdnext;
  end;

end;

procedure tform1.read_locations;
var
  dataloc: pvstrecordloc;
  nd, pnd: pvirtualnode;
  s, nm: string;
  sl: TStringList;
begin
  log('m', 'read_locations START');

  exit;
  prdp;

  //vstloc.Refresh;
  exit;

end;

procedure TForm1.read_comps;
var
  Data, datandp: pvstrecord;
  nd, ndp: pvirtualnode;
  s, nm: string;
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
    formirndstarter(firstnd);
    nd := form1.fnn(firstnd, sl);

    Data := vst.GetNodeData(nd);
    ndp := Data^.ndp;
    datandp := vst.GetNodeData(ndp);
    Data^.bp := datandp^.dbmyid;
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

procedure TForm1.BitBtn1Click(Sender: TObject);
begin

end;


procedure TForm1.killonpid(pid: integer);
var
  AProcess: TProcess;
  fn, s: string;
  sl: TStringList;

begin
  AProcess := TProcess.Create(nil);
  s := 'TASKKILL /PID ' + IntToStr(pid) + ' /f /T';
  sl := TStringList.Create;
  sl.Add(s);
  fn := appdir + 'kill' + IntToStr(pid) + '.bat';
  sl.SaveToFile(fn);
  AProcess.Executable := fn;
  log('l', 'fn=' + fn);
  log('y', 'fn=' + fn);
  log('r', 'fn=' + fn);
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  uxt1, uxt2, pid: int64;
  dt: tdatetime;
  AProcess: TProcess;
  s: string;
  sl: TStringList;
begin

  formmars1.Show;
  exit;
  s := 'c:\@laz\@atss_units\atss_drv209\rt96.bat';
  excmd(s, sl);
  exit;

  pid := 2284;
  AProcess := TProcess.Create(nil);
  s := 'TASKKILL /PID ' + IntToStr(pid) + ' /f /T';
  log('r', 's=' + s);
  AProcess.Executable := s;


{
dt:=Now;
//uxt1:=DateTimeToUnix(dt,True);
uxt2:=DateTimeToUnix(dt,False);
//log('r','uxt1='+inttostr(uxt1));
log('r','uxtf='+inttostr(uxt2));
exit;
}

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  s, s1, s2: string;
  nd: pvirtualnode;
  d: pvstrecord;
begin
  //  nd:=form1.findndnm0tag('transport',-111);
  nd := form1.findndoftag(-111);
  d := vst.GetNodeData(nd);
  log('y', 'test nm0=' + d^.nm0);
  d^.nm1 := datetimetostr(now);
  vst.refresh;

  exit;


  s := 'женя';
  s1 := base64.EncodeStringBase64(s);
  s2 := base64.DecodeStringBase64(s1);
  log('r', 's1=' + s1 + ' /s2=' + s2);
  //form1.addarmcmd('test20');

end;



function tform1.y_getinfobymyid(myid: string): tmyrcvtr;
var
  bp: integer;

  s, nm: string;
  dataloc, dtn: pvstrecordloc;
  nd: pvirtualnode;
  mx: tmyrcvtr;
  qrz: TSQLQuery;
begin
  s := 'select myid,bp,name,sti,tag from tssloc_locations where myid=' + myid +
    '  limit 1';
  log('y', 'y_getinfobymyid s=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.SQL.Clear;
  qrz.DataBase := formglink.pqc1;
  qrz.Transaction := formglink.tr1;
  qrz.sql.Add(s);
  qrz.Active := True;
  mx.myid := qrz.FieldByName('myid').AsInteger;
  mx.bp := qrz.FieldByName('bp').AsInteger;
  mx.sti := qrz.FieldByName('sti').AsInteger;
  mx.tag := qrz.FieldByName('tag').AsInteger;
  mx.nm0 := qrz.FieldByName('name').AsString;
  Result := mx;
  qrz.Close;
  qrz.Free;
end;


function TForm1.y_formirnode(myid: string): pvirtualnode;
var
  nd: pvirtualnode;
  dtl: pvstrecordloc;
  mx: tmyrcvtr;

begin
  nd := vstloc.AddChild(currndloc);
  mx := y_getinfobymyid(myid);
  dtl := vstloc.GetNodeData(nd);
  dtl^.dbmyid := mx.myid;
  dtl^.bp := mx.bp;
  dtl^.sti := mx.sti;
  dtl^.sti1 := -1;
  dtl^.nm0 := mx.nm0;
  Result := nd;
end;

function tform1.findj(i: integer): integer;
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

procedure TForm1.showsqluzel;
var
  dl: pvstrecordloc;
  i, j: integer;
  ndn: pvirtualnode;
  sl: TStringList;
begin
  sl := TStringList.Create;
  for i := 0 to length(auzel) - 1 do
  begin
    //ndn:=vstloc.AddChild(currndloc);
    //dl:=vstloc.GetNodeData(ndn);

    //dl^.nm0:=auzel[i].name;
    //dl^.tag:=auzel[i].tag;
    //dl^.sti:=auzel[i].sti;
    //dl^.sti1:=-1;

    sl.Values['nm0'] := auzel[i].Name;
    sl.Values['tag'] := IntToStr(auzel[i].tag);
    sl.Values['sti'] := IntToStr(auzel[i].sti);
    sl.Values['smrn'] := auzel[i].smrn;
    sl.Values['sti1'] := '-1';
    sl.Values['ndcheck'] := 'n';
    sl.Values['ndcheck_state'] := 'n';
    j := findj(i);
    //showmessage('j='+inttostr(j));
    if j = -1 then currnd := nil
    else
      currnd := auzel[j].pnd;
    ndn := form1.fnnloc(currnd, sl);
    auzel[i].pnd := ndn;
    dl := vstloc.GetNodeData(ndn);
    dl^.dbmyid := auzel[i].myid;
    dl^.sti := auzel[i].sti;
    dl^.tag := auzel[i].tag;
    //if auzel[i].tag=2 then showmessage(dl^.nm0);
    dl^.sti1 := -1;
    dl^.bp := auzel[i].bp;
    dl := getprmtag3(dl);

    // currndloc:=ndn;
  end;
end;

procedure tform1.formirndstarter(ndc: pvirtualnode);
var
  nd: pvirtualnode;
  d: pvstrecord;
  qrz: TSQLQuery;
  s, nmapp, ttg, spath: string;
  n: integer;
  sl: TStringList;
begin
  try
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
      //showmessage('');
      qrz.Next;
    end;

  finally
  end;
  vst.Refresh;

end;

function tform1.calc_vstobstime(nd: pvirtualnode): integer;
var
  Data: pvstrecord;
  d, oldt, newt: int64;
begin
  try
    Result := -999;
    Data := vst.GetNodeData(nd);
    oldt := Data^.lastobs;
    newt := dateutils.DateTimeToUnix(now, False);
    d := newt - oldt;
    Result := d;
    Data^.lastobs := newt;
    Result := d;
  except
    Result := -999;
  end;

end;

procedure tform1.showdmslife(v: string);
var
  jb, jbx: TJSONObject;
  jd: tjsondata;
  js, comp, cmd, kto, nm, ms, pid, vuxt: string;
  nd, ndc: pvirtualnode;
  dt, dtc: pvstrecord;
  sl: TStringList;
  d, nl, vx: int64;
begin
  try
    nm := 'dms';
    // log('l','showdmslife='+v);
    jd := GETJSON(v);
    jb := tjsonobject(jd);
    js := jd.FormatJSON;
    cmd := jb.Get('cmd');
    kto := jb.Get('kto');
    pid := IntToStr(jb.Get('pid'));
    vuxt := IntToStr(jb.Get('vuxt'));
    ms := jb.Get('mystamp');
    nd := form1.findndnm0tag(nm, -100);
    dtc := vst.GetNodeData(nd);
    comp := dmfunc.ExtractStr(1, kto, '#');
    dtc^.sti := 42;
    d := form1.calc_vstobstime(nd);
    // nl:= dtc^.lastobs;
    dtc^.nm1 := ms + ',pid=' + pid + ',delta=' + IntToStr(d);
    //nl:=dateutils.DateTimeToUnix(now,false);

    //dtc^.lastobs:=nl;
    //d:=nl-strtoint(vuxt);
    //dtc^.nm1:=ms+',pid='+pid+',delta='+inttostr(d);
    //nl:=dateutils.DateTimeToUnix(now,false);
    //dtc^.lastobs:=nl;


       {
       sl:=tstringlist.Create;
       sl.Values['nm0']:=nm;
       sl.Values['sti']:='19';
       sl.Values['sti1']:='-1';
       sl.Values['tag']:='-3';
       sl.Values['ndcheck']:='n';
       sl.Values['ndcheck_state']:='n';
       nd:=fnn(ndc,sl);
       dt:=vst.GetNodeData(nd);
       dt^.nm1:=kto;
       }
    jb.Free;
    //vst.Refresh;
  except
    on ee: Exception do
    begin
      log('e', 'showdmslife ,ee=' + ee.Message);
    end;
  end;

end;

function TForm1.getprmtag3nm(ndp: pvirtualnode; dl: pvstrecordloc): pvstrecordloc;
var
  bp, myid, fckp, ioflag, mpcl, nm, nmx, bpsens, loccode: string;
  k, s, ckp, iof: string;
  qrz: TSQLQuery;
  n: integer;
  sl: TStringList;
  nd: pvirtualnode;
  dl2: pvstrecordloc;
begin
  //  log('r','currndloc.dbmyid='+inttostr())
  deletechildloc(ndp, dl^.dbmyid, -3);
  deletechildloc(ndp, dl^.dbmyid, 3);
  // deletechildloc(currndloc,dl^.dbmyid,-3);
  //deletechildloc(currndloc,dl^.dbmyid,3);
  if dl^.tag <> 2 then
  begin
    Result := dl;
    exit;
  end;
  bp := IntToStr(dl^.dbmyid);
  nmx := dl^.nm0;
  s := 'select myid,NAME,fckp,ioflag,bpsens,loccode  from tssloc_locations  where tag=3  and bp='
    + bp + '  order by mpcl,loccode ';
  log('l', 's=' + s);
  qrz := TSQLQuery.Create(self);
  qrz.DataBase := formglink.pqc1;
  qrz.SQL.Add(s);
  qrz.Active := True;
  sl := TStringList.Create;
  while not qrz.EOF do
  begin
    myid := qrz.FieldByName('myid').AsString;
    nm := qrz.FieldByName('name').AsString;
    fckp := qrz.FieldByName('fckp').AsString;
    if qrz.FieldByName('fckp').AsBoolean = True then ckp := 'ckp'
    else
      ckp := 'door';
    ioflag := qrz.FieldByName('ioflag').AsString;
    if qrz.FieldByName('ioflag').AsBoolean = True then iof := 'вход'
    else
      iof := 'выход';
    bpsens := qrz.FieldByName('bpsens').AsString;
    loccode := qrz.FieldByName('loccode').AsString;
    log('l', 'nm=' + nm);
    sl.Values['nm0'] := nm;
    sl.Values['nm1'] := '';
    sl.Values['tag'] := '-3';
    sl.Values['sti'] := '-1';
    sl.Values['sti1'] := '-1';

    sl.Values['ndcheck'] := 'y';
    sl.Values['ndcheck_state'] := 'n';
    // showmessage('Newlocat='+slin.text+'  ///BPP='+inttostr(bpp));
    sl.Values['bpp'] := bp;
    nd := form1.fnnloc(currndloc, sl);
    dl2 := vstloc.GetNodeData(nd);
    dl2^.bp := StrToInt(bp);
    dl2^.bps := StrToInt(bpsens);
    dl2^.dbmyid := StrToInt(myid);
    dl2^.loccode := StrToInt(loccode);
    dl2^.nm1 := bpsens + ',' + nmx + ',' + ckp + ' ,' + iof + ',' + myid;
    qrz.Next;
  end;
  vstloc.Refresh;
  VSTloc.Expanded[ndp] := True;

end;


function TForm1.getprmtag3(dl: pvstrecordloc): pvstrecordloc;
var
  bp, myid, fckp, ioflag, mpcl: string;
  k, s: string;
  qrz: TSQLQuery;
  n: integer;
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
  dl^.nm1 := 'myid=' + IntToStr(dl^.dbmyid) + ',KГс=' + mpcl + ',bp=' + IntToStr(dl^.bp);
  //suda0212
  log('l', '??????????? mpcl=' + mpcl);
  dl^.mpcl := StrToInt(mpcl);
  Result := dl;
  s := 'select NAME  from tssloc_locations  where tag=3  and bp=' +
    bp + '  order by loccode ';

end;

procedure TForm1.fillsqluzel;
var
  Data: pvstrecord;
  s: string;
  nd, pnd: pvirtualnode;
  I, l: integer;
  qrz: TSQLQuery;
begin
  s := mfiltr;
  log('l', 'MFILTR=' + MFILTR);
  qrz := TSQLQuery.Create(self);
  qrz := formglink.gselqr(s);
  i := 0;
  SetLength(auzel, 0);
  vstloc.Clear;
  while not qrz.EOF do
  begin
    l := length(auzel);
    SetLength(auzel, l + 1);
    auzel[i].Name := qrz.FieldByName('name').AsString;
    auzel[i].myid := qrz.FieldByName('myid').AsInteger;
    auzel[i].bp := qrz.FieldByName('bp').AsInteger;
    auzel[i].tag := qrz.FieldByName('tag').AsInteger;
    auzel[i].sti := qrz.FieldByName('sti').AsInteger;
    auzel[i].smrn := qrz.FieldByName('smrn').AsString;
    auzel[i].pnd := nil;
    log('l', 'name=' + auzel[i].Name);
    qrz.Next;
    i := i + 1;
  end;
  qrz.Free;
end;



procedure TForm1.cblChange(Sender: TObject);
begin

end;

procedure TForm1.cblClick(Sender: TObject);
begin

end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin

end;

procedure TForm1.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: integer; Column: TColumn; State: TGridDrawState);
var
  pr: string;
begin
{
   pr:= Column.Field.Dataset.FieldbyName('pr').AsString;

   if pr = 'i' then
    begin
     dbgrid1.Canvas.Brush.Color:=clsilver;
     dbgrid1.Canvas.Font.Color:=clBlack;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

   if pr = 'r' then
    begin
     dbgrid1.Canvas.Brush.Color:=clred;
     dbgrid1.Canvas.Font.Color:=clBlack;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

   if pr = 'e' then
    begin
     dbgrid1.Canvas.Brush.Color:=clred;
     dbgrid1.Canvas.Font.Color:=clBlack;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;
    if pr = 'y' then
    begin
     dbgrid1.Canvas.Brush.Color:=clyellow;
     dbgrid1.Canvas.Font.Color:=clBlack;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'w' then
    begin
     dbgrid1.Canvas.Brush.Color:=clwhite;
     dbgrid1.Canvas.Font.Color:=clBlack;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'c' then
        begin
         dbgrid1.Canvas.Brush.Color:=claqua;
         dbgrid1.Canvas.Font.Color:=clBlack;
         dbgrid1.Canvas.FillRect(Rect);
         dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
         exit;
        end;

    if pr = 'b' then
    begin
     dbgrid1.Canvas.Brush.Color:=clblue;
     dbgrid1.Canvas.Font.Color:=clBlack;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'i' then
    begin
     dbgrid1.Canvas.Brush.Color:=clblack;
     dbgrid1.Canvas.Font.Color:=clwhite;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'm' then
    begin
     dbgrid1.Canvas.Brush.Color:=clpurple;
     dbgrid1.Canvas.Font.Color:=clwhite;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'l' then
    begin
     dbgrid1.Canvas.Brush.Color:=cllime;
     dbgrid1.Canvas.Font.Color:=clBlack;
     dbgrid1.Canvas.FillRect(Rect);
     dbgrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;
}

end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  globalexit := True;
  formpgctr.unregister;
  formpgctr.tostartstop('stop');
end;

procedure TForm1.newsensor(ndport: pvirtualnode; code: integer);
var
  Data, dataac: pvstrecord;
  bp, myid, nm, s: string;
  nd: pvirtualnode;
  rc: boolean;
  sti: integer;
  myrcdb: tmyrcdb;
begin
  // s:='select * from tss_ports where bp='+myid+' nump=vglink.sl.Values['nump'];
  // myidport:=getmyid(s);

  if code = 1 then
  begin
    sti := 37;
    nm := 'key';
  end;
  if code = 2 then
  begin
    sti := 27;
    nm := 'open';
  end;
  if code = 3 then
  begin
    sti := 23;
    nm := 'close';
  end;
  if code = 4 then
  begin
    sti := 28;
    nm := 'rte';
  end;

  Data := vst.GetNodeData(ndport);
  bp := IntToStr(Data^.dbmyid);


  s := 'insert into tss_sensors(name,bp,actual,code,sti,tscd)values(' +
    ap + nm + ap + zp + bp + ',' + 'true' + zp + IntToStr(code) + ',' +
    IntToStr(sti) + ',' + ' current_timestamp ' + ');';

  log('y', 'newsensor s=' + s);
  //exit;
  vglink.sqline := s;

  myrcdb := formglink.gupd;
  //showmessage('newsensor 2');

  if myrcdb.rusmes <> 'ok' then exit;
  vglink.sl.Values['nm0'] := nm;
  vglink.sl.Values['nm1'] := 'sensor of port';
  vglink.sl.Values['sti'] := '-1';//inttostr(sti);
  ;
  vglink.sl.Values['sti1'] := '-1';
  vglink.sl.Values['tag'] := '4';
  vglink.sl.Values['ndcheck'] := 'n';
  vglink.sl.Values['ndcheck_state'] := 'n';
  nd := form1.fnn(ndport, vglink.sl);

  if nd = nil then exit;

  // dataac:=vst.GetNodeData(nd);
  // log('c','s='+s);
  VST.Expanded[currnd] := True;
  vst.refresh;

end;

function TForm1.getlastmyid(tbn: string): integer;
var
  qrz: TSQLQuery;
  s: string;
  n: integer;
begin
  try
    s := 'select myid from ' + tbn + ' order by myid desc limit 1';
    log('y', 'gsel=' + s);
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


function TForm1.findbeforeinsert(s: string): integer;
var
  qrz: TSQLQuery;
  rc: integer;
begin
  try
    log('y', 'gsel=' + s);
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(s);
    qrz.Active := True;
    vglink.qrx := qrz;
    rc := qrz.RecordCount;
  except
    on ee: Exception do
    begin
      log('e', 'findbeforeinsert ,ee=' + ee.Message);
      rc := -1;
    end;
  end;
  Result := rc;
end;

function TForm1.basenewlocat(ndo: pvirtualnode; slin: TStringList): integer;
var
  Data, dataac: pvstrecord;
  myid, nm, s, K: string;
  nd: pvirtualnode;
  bpp: integer;
  myrcdb: tmyrcdb;
  xbp, xdbmyid, xnm0, xtag: string;
begin
  Result := -1;
  Data := vst.GetNodeData(ndo);

  //exit;
  xbp := slin.Values['bp'];
  xdbmyid := slin.Values['dbmyid'];
  xnm0 := slin.Values['nm0'];
  xtag := slin.Values['tag'];
  K := xbp + zp + xdbmyid + zp + xnm0 + zp + xtag;
  log('c', 'basenewlocat k=' + k);
  //showmessage('basenewlocat k='+k);
  s := 'insert into tssloc_locations(loccode,bp,keyname,name,tag,sti,tscd)values(' +
    slin.Values['loccode'] + zp + xbp + zp + AP + k + ap + zp +
    ap + slin.Values['nm0'] + ap + zp + slin.Values['tag'] + ',' +
    slin.Values['sti'] + ',' + ' current_timestamp ' + ');';
  log('c', 'basenewlocat s=' + s);

  vglink.sqline := s;
  myrcdb := formglink.gupd;
  bpp := getlastmyid('tssloc_locations');
  if myrcdb.fullmess = 'ok' then
  begin
    Result := bpp;
  end;

end;

procedure TForm1.newport(ndcont: pvirtualnode);
var
  Data, dataac: pvstrecord;
  bpp, myid, nm, s: string;
  nd: pvirtualnode;
  rc: boolean;
  myrcdb: tmyrcdb;
begin

  Data := vst.GetNodeData(ndcont);
  myid := IntToStr(Data^.dbmyid);

  s := 'insert into tss_ports(bp,actual,nump,tmr,tscd)values(' +
    myid + ',' + vglink.sl.Values['actual'] + ',' + vglink.sl.Values['nump'] + ',' +
    vglink.sl.Values['tmr'] + ',' + ' current_timestamp ' + ');';
  //log('m','newacl s='+s);
  //exit;
  vglink.sqline := s;
  myrcdb := formglink.gupd;
  if myrcdb.fullmess <> 'ok' then ShowMessage(myrcdb.rusmes);
  if myrcdb.fullmess = 'ok' then
  begin
    bpp := IntToStr(getlastmyid('tss_ports'));

    vglink.sl.Values['nm0'] := vglink.sl.Values['nump'];
    vglink.sl.Values['nm1'] := 'port of cont  ACS';
    vglink.sl.Values['sti'] := '-1'; //'26';
    vglink.sl.Values['sti1'] := '-1';
    vglink.sl.Values['tag'] := '3';
    vglink.sl.Values['ndcheck'] := 'n';
    vglink.sl.Values['ndcheck_state'] := 'n';


    // nd:=fnn(ndcont,VGLINK.sl);
    // data:=vst.GetNodeData(nd);

    //data^.tag:=3;
    // data^.dbmyid:=strtoint(bpp);
    // log('c','s='+s);
    //VST.Expanded[currnd]:=true;
    //vst.Refresh;

  end;



  vglink.sl.Values['nm0'] := vglink.sl.Values['nump'];
  vglink.sl.Values['nm1'] := 'port of cont  ACS';
  vglink.sl.Values['sti'] := '26';
  vglink.sl.Values['sti1'] := '31';
  vglink.sl.Values['tag'] := '3';
  vglink.sl.Values['ndcheck'] := 'y';
  vglink.sl.Values['ndcheck_state'] := 'n';
  nd := form1.fnn(currnd, vglink.sl);
  Data := vst.GetNodeData(nd);
  if nd = nil then exit;
  Data := vst.GetNodeData(nd);
  Data^.dbmyid := StrToInt(bpp);
  //titlenode;
  //reread;

  //showmessage('call newsensor');
  newsensor(nd, 1);
  newsensor(nd, 2);
  newsensor(nd, 3);
  newsensor(nd, 4);
  titlenode;
  reread;
  vst.refresh;

end;


procedure TForm1.newacl;
var
  n: integer;
  Data, dataac: pvstrecord;
  myid, s: string;
  nd: pvirtualnode;
  rc: boolean;
  myrcdb: tmyrcdb;
begin

  Data := vst.GetNodeData(currnd);
  myid := IntToStr(Data^.dbmyid);
  s := 'insert into tss_acl(bp,actual,ac,cp,ctyp,tscd)values(' +
    myid + ',' + vglink.sl.Values['actual'] + ',' + vglink.sl.Values['ac'] + ',' +
    vglink.sl.Values['cp'] + ',' + vglink.sl.Values['ctyp'] + ',' +
    ' current_timestamp ' + ');';
  log('m', 'newacl s=' + s);
  vglink.sqline := s;
  vglink.sl.Values['nm0'] := vglink.sl.Values['ac'];
  vglink.sl.Values['nm1'] := 'controller ACS';
  vglink.sl.Values['sti'] := '-1';//'18';
  vglink.sl.Values['sti1'] := '-1';
  vglink.sl.Values['tag'] := '2';
  vglink.sl.Values['ndcheck'] := 'n';
  vglink.sl.Values['ndcheck_state'] := 'n';


  s := 'select * from tss_acl where bp=' + myid + ' and  ac=' + vglink.sl.Values['ac'];
  log('y', 's=' + s);
  n := findbeforeinsert(s);
  if n > 0 then
  begin
    log('y', 'n=' + IntToStr(n));
    ShowMessage(
      'Дубль. Такое значение уже есть в базе. Исправте и повторите !!!');
    exit;
  end;


  myrcdb := formglink.gupd;
  if myrcdb.fullmess <> 'ok' then ShowMessage(myrcdb.fullmess);
  if myrcdb.fullmess = 'ok' then
  begin
    // SHOWMESSAGE('BEFORE FNN 1');
    nd := fnn(currnd, vglink.sl);
    if nd <> nil then
    begin
      dataac := vst.GetNodeData(nd);
      dataac^.tag := 2;
      log('c', 's=' + s);
    end;
    try
      titlenode;
      reread;
      vst.refresh;
    except
      on ee: Exception do
      begin
        log('e', 'newacl EPILOG ,ee=' + ee.Message);
      end;
    end;


    //VST.Expanded[currnd]:=true;
    //vst.refresh;
  end;
end;




procedure TForm1.MenuItem10Click(Sender: TObject);
var
  v: string;
begin
  // add acl
  formeditacl.showmodal;
  if vglink.sl.Count = 0 then exit;
  // SHOWMESSAGE('VGLINK.SL='+vglink.sL.TEXT);
  newacl;
end;

procedure TForm1.MenuItem110Click(Sender: TObject);
var
  myid, s: string;
  dt: pvstrecord;
begin
  dt := vst.GetNodeData(currnd);
  myid := IntToStr(dt^.dbmyid);
  s := 'update tss_sensors set bploc=-1 where bp=' + myid;
  log('y', 's=' + s);
  form1.selfupd(s);
end;

procedure TForm1.MenuItem112Click(Sender: TObject);
begin
  formirjs_ac(currnd, 'ac_deleteallkeys');
end;

procedure TForm1.MenuItem113Click(Sender: TObject);
var
  Data: pvstrecord;
begin
  formirjs_ac(currnd, 'ac_readallkeys');

end;

procedure TForm1.MenuItem114Click(Sender: TObject);
var
  dl: pvstrecordloc;
  nd: pvirtualnode;
  bp, s: string;
begin
  dl := vstloc.GetNodeData(currndloc);
  bp := IntToStr(dl^.bp);
  s := 'delete from tssloc_locations where bp=' + bp;
  log('y', 's=' + s);
  form1.selfupd(s);

end;

procedure TForm1.MenuItem115Click(Sender: TObject);
var
  dl: pvstrecordloc;
begin
  vstloc.FullCollapse(currndloc);

  // VSTloc.Expanded[currnd]:=true;
end;

function tform1.x_linksens(nd: pvirtualnode): boolean;
var
  dl: pvstrecordloc;
  sl: TStringList;
  i: integer;
  s, ss, bploc, myid: string;
begin
  //suda17
  dl := vstloc.GetNodeData(nd);
  bploc := IntToStr(dl^.dbmyid);

  sl := TStringList.Create;
  sl := findchckndtag(vst, 4);
  log('y', 'sl=================' + sl.Text);
  //exit;


  for i := 0 to sl.Count - 1 do
  begin
    log('y', 'sl[i]=' + sl[i]);
    myid := dmfunc.ExtractStr(2, sl[i], ',');
    s := 'update tss_sensors set bploc=' + bploc + ' where myid=' + myid;
    log('y', 's=' + s);
    form1.selfupd(s);
    s := 'update tssloc_locations set bpsens=' + myid + ' where myid=' + bploc;
    log('c', 's=' + s);
    form1.selfupd(s);

  end;
end;



procedure TForm1.MenuItem117Click(Sender: TObject);
var
  nd: pvirtualnode;
  dl: pvstrecordloc;
  ds: pvstrecord;
  i: integer;
  adl: tlinkloc;
  sl: TStringList;
  smyid, lmyid, s: string;
begin
  sl := TStringList.Create;
  sl := findchckndtag(vst, 4);
  //log('y','LINKQUE sl='+sl.Text);
  if trim(sl.Text) = '' then
  begin
    ShowMessage('НЕОТМЕЧЕН СЕНСОР');
    SL.Free;
    EXIT;
  end;

  nd := currndloc;
  dl := vstloc.GetNodeData(currndloc);
  log('w', 'loccode=' + IntToStr(dl^.loccode));
  if dl^.loccode <> 1 then
  begin
    ShowMessage('надо начинать с "KEY". ИСПРАВИТЬ И ПОВТОРИТЬ');
    exit;
  end;

  try
    for i := 1 to 4 do
    begin
      dl := vstloc.GetNodeData(nd);
      adl.aloc[i] := dl;
      if dl = nil then
      begin
        log('r', 'nm0=далее ничего нет');
        exit;
      end;
      x_linksens(nd);
      //log('y','nm0='+dl^.nm0);
      nd := vstloc.GetNext(nd);
      if nd = nil then break;
    end;

  except
    on ee: Exception do
    begin
      log('e', 'LINKQUE1 ,ee=' + ee.Message);
    end;
  end;
  nd := currnd;
  try
    for i := 1 to 4 do
    begin
      ds := vst.GetNodeData(nd);
      adl.asens[i] := ds;
      if ds = nil then
      begin
        log('r', 'nm0=далее ничего нет');
        exit;
      end;

      nd := vst.GetNext(nd);
      if nd = nil then break;
    end;
  except
    on ee: Exception do
    begin
      log('e', 'LINKQUE2 ,ee=' + ee.Message);
    end;
  end;
  sl.Free;
  for i := 1 to 4 do
  begin
    ds := adl.asens[i];
    dl := adl.aloc[i];
    // log('l','nm0='+ds^.nm0+','+dl^.nm0);
    smyid := IntToStr(ds^.dbmyid);
    lmyid := IntToStr(dl^.dbmyid);
    s := 'update tss_sensors set bploc=' + lmyid + ' where myid=' + smyid;
    log('y', 's=' + s);
    form1.selfupd(s);
    s := 'update tssloc_locations set bpsens=' + smyid + ' where myid=' + lmyid;
    log('c', 's=' + s);
    form1.selfupd(s);

  end;

end;

procedure TForm1.MenuItem118Click(Sender: TObject);
var
  dl: pvstrecordloc;
  myid, s: string;
  nd: pvirtualnode;
begin
  dl := vstloc.GetNodeData(currndloc);
  myid := IntToStr(dl^.dbmyid);
  vstloc.DeleteNode(currndloc);
  s := 'delete from tssloc_locations where myid=' + myid;
  form1.selfupd(s);
  currrereadloc;
end;




procedure TForm1.MenuItem119Click(Sender: TObject);
var
  dl: pvstrecordloc;
  ds: pvstrecord;
  nd: pvirtualnode;
begin
  ds := vst.GetNodeData(currnd);
  log('l', 'checklinkloc bploc=' + IntToStr(ds^.bploc) + ',tag=' + IntToStr(ds^.tag));
  nd := findndlocofmyid(ds^.bploc);
  if nd = nil then exit;
  dl := vstloc.GetNodeData(nd);
  dl^.sti := 38;
  vstloc.Refresh;
end;

procedure TForm1.face_ch_tsslife(bidcomp, bidch, spd, sumerr: string);
var
  Data: pvstrecord;
  nd: pvirtualnode;
  mid: integer;
begin
  mid := StrToInt(bidch);
  // log('w','bidch='+inttostr(mid)+'  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
  nd := form1.findvstndbymid(mid, 1);
  if nd = nil then
  begin
    log('r', 'AFTER NIL LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');
    log('r', 'AFTER NIL LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');
    EXIT;
  end;
  Data := vst.GetNodeData(nd);
  Data^.sti := 38;
  Data^.nm1 := ' Опрос=' + spd + ', err=' + sumerr + '  , ct=' + timetostr(time);
  vst.Refresh;

end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem120Click(Sender: TObject);
var
  dl: pvstrecordloc;
  nd: pvirtualnode;
  i: integer;
begin
  dl := vstloc.GetNodeData(currndloc);
  for i := 1 to 10 do
  begin
    application.ProcessMessages;
    dl^.sti := -1;
    vstloc.Refresh;
    dmfunc.MyDelay(500);
    dl^.sti := 38;
    vstloc.Refresh;
    log('l', 'i=' + IntToStr(i));
    dmfunc.MyDelay(1000);
  end;
end;

procedure TForm1.MenuItem121Click(Sender: TObject);
var
  dl: pvstrecordloc;
begin
  vstloc.IsVisible[currndloc] := False;
end;

procedure TForm1.MenuItem122Click(Sender: TObject);
var
  ds: pvstrecord;
  i: integer;
begin
  ds := vst.GetNodeData(currnd);
  for i := 1 to 10 do
  begin
    application.ProcessMessages;
    vst.Expanded[currnd] := True;
    //dmfunc.MyDelay(300);
    // vst.Expanded[currnd]:=false;
    log('w', 'ec   ???????????????????');
    vst.Refresh;
  end;

end;

procedure TForm1.MenuItem123Click(Sender: TObject);
var
  dl: pvstrecordloc;
begin
  sensnodetostatevis(currndloc, True);
end;

procedure TForm1.MenuItem124Click(Sender: TObject);
var
  dl: pvstrecordloc;
begin
  sensnodetostatevis(currndloc, False);
end;

procedure tform1.formirjs_ac(cnd: pvirtualnode; subcmd: string);
var
  Data, dch: pvstrecord;
  ndch: pvirtualnode;
  ac, kto, komu, sj: string;
  jb: TJSONObject;
  jd: tjsondata;
  idcmd: integer;
begin
  idcmd := addarmcmd(subcmd);
  Data := vst.GetNodeData(cnd);
  ndch := Data^.ndp;
  dch := vst.GetNodeData(ndch);
  ac := Data^.nm0;
  komu := Data^.idkomu;
  Data^.nm1 := datetimetostr(now) + zp + 'отправил  cmd=' +
    subcmd + zp + 'idcmd=' + IntToStr(idcmd);
  komu := mysysinfo.computername + '#drv209_' + dch^.nm0;
  kto := umain.trclientid;
  vst.Refresh;
  jb := TJSONObject.Create(['cmd', 'todrv', 'kto', kto,
    //umain.trclientid,
    'idcmd', IntToStr(idcmd),
    'komu', komu, 'subcmd', subcmd,
    'ac', ac, 'uxt',
    IntToStr(dateutils.DateTimeToUnix(now)), 'cds',
    datetimetostr(now)]);


  sj := jb.AsJSON;
  log('r', 'time sj=' + sj);
  // formtrans.cltrans.doSendMsg('tss_mqtt',sj,false); sudavagolo
  FreeAndNil(jb);

      {
      sj:=jb.AsJSON;
      log('r','time sj='+sj);
      formtrans.cltrans.doSendMsg('tss_mqtt',sj,false);
      FreeAndNil(jb);
      }

end;

procedure TForm1.MenuItem125Click(Sender: TObject);
begin
  formirjs_ac(currnd, 'get_getacinfo');
    {
      data:=vst.GetNodeData(currnd);
      ndch:=data^.ndp;
      dch:=vst.GetNodeData(ndch);
      ac:=data^.nm0;
      subcmd:='get_getacinfo';
      cmd:=subcmd;
      komu:=mysysinfo.computername+'#drv209_'+dch^.nm0;
      kto:=umain.trclientid;
      line:='kpx';
     // sj:=formirjb_toskud(kto,komu,subcmd,line);
     
      log('y','send get_getacinfo');
      jb:=TJSONObject.Create(['cmd','todrv',
                            'kto'  ,kto,                 //umain.trclientid,
                            'komu' ,komu,
                            'subcmd',subcmd,
                            'ac'    ,ac,
                           // 'line'  ,line,
                            'uxt',inttostr(dateutils.DateTimeToUnix(now)),
                            'cds',datetimetostr(now)]);

      sj:=jb.AsJSON;
      log('r','time sj='+sj);
      formtrans.cltrans.doSendMsg('tss_mqtt',sj,false);
      FreeAndNil(jb);
      //formtrans.cltrans.doSendMsg('tss_mqtt',sj,false);
    }

end;

procedure TForm1.MenuItem126Click(Sender: TObject);
begin
  formstarter.openstarter;
  formstarter.Show;
  formstarter.rereadstarter;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  formmdlog.WindowState := wsnormal;
  formmdlog.Show;

end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin

  if vglink.state <> 'open' then exit;
  vglink.sl.Clear;
  ;
  formeditcomp.showmodal;
  //showmessage('after editcomp='+vglink.sl.text);
  newcomp;

end;

procedure TForm1.MenuItem14Click(Sender: TObject);
var
  ap, act, ch, v, s: string;
  Data: pvstrecord;
begin
  Data := vst.GetNodeData(currnd);
  ueditch.bpc := Data^.dbmyid;
  vglink.sl.Clear;
  formeditch.mdch.Open;
  formeditch.showmodal;
  if vglink.sl.Count = 0 then exit;
  ;
  formeditch.dsch.AutoEdit := True;
  // if vglink.sl.values['actual']='-1' then act:='True';
  // if vglink.sl.values['actual']='0' then act:='False';
  Data := vst.GetNodeData(currnd);
  if Data = nil then exit;
  //s:=vglink.sl.values['ch']+',act='+ACT;
  //showmessage('umain='+vglink.sl.text);
  newch(currnd, vglink.sl.values['ch']);

  vst.Refresh;

end;

procedure TForm1.MenuItem15Click(Sender: TObject);
begin
  log('r', timetostr(time));
  //read_comps;
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
var
  pnd: pvirtualnode;
  Data: pvstrecord;
begin

  pnd := form1.getpnd(vst, currnd);

end;

procedure TForm1.MenuItem17Click(Sender: TObject);
var
  pnd: pvirtualnode;
  Data: pvstrecord;
begin
  formeditport.showmodal;
  if vglink.sl.Count = 0 then exit;
  //SHOWMESSAGE('addport VGLINK.SL='+vglink.sL.TEXT);
  newport(currnd);

end;

procedure TForm1.MenuItem18Click(Sender: TObject);
var
  myid, oldnump, s: string;
  Data: pvstrecord;

begin
  Data := vst.GetNodeData(currnd);
  oldnump := Data^.nm0;
  myid := IntToStr(Data^.dbmyid);
  formeditport.showMODAL;
  // showmessage('SL='+vglink.sl.text);
  if vglink.sl.Count = 0 then exit;
      {
      if vglink.sl.values['nump']<> oldnump then begin
         showmessage('вы изменили номер порта.ТАК НЕЛЬЗЯ. ПОВТОРИТЕ');
         EXIT;
      end;
     }
  s := 'update tss_ports set actual=' + vglink.sl.Values['actual'] + ',' +
    ' ckp=' + vglink.sl.Values['actual'] + ',' +
    ' iof=' + vglink.sl.Values['iof'] + ',' +
    ' tscd=' + ' current_timestamp' + ',' + ' tmr=' + vglink.sl.Values['tmr'] +
    '  where myid=' + myid;
  log('m', 's=' + s);
  vglink.sqline := s;
  formglink.gupd;
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
begin
  titlenodeLOC;
end;

//pg_dumpall -U  postgres > g:\pgbackup\all2.sql    dump на весь SQL
//pg_basebackup.exe  -D g:\basebackup\202209181 -Ft  -P  backup ВСЕГО


{ AC=7 PORT=1 name='key'  будет найдена строка в TSSLOC_CONTROLS  (fckp,ioflag,mrn);

select tssloc_controls.name,
tssloc_controls.myid,
tss_ports.nump,
tssloc_controls.mrn,
tssloc_controls.ioflag,
tssloc_controls.fckp,
tss_ch.myid,
tss_acl.myid,
tss_acl.ac,
tss_acl.bp,
tss_ports.myid

from tss_ch,tss_acl,tss_ports,tssloc_controls where
tss_ch.myid=tss_acl.bp and
tss_ports.bp=tss_acl.myid and
tss_acl.ac=7 and
tss_ports.nump=1 and
tssloc_controls.bpp=tss_ports.myid and
tssloc_controls.name='key'

//
select tscd from tss_redlog where tscd >= '2022-09-27 8:00:00':: timestamp
select tscd from tss_redlog where tscd between  '2022-09-27 8:40:50'
and'2022-09-27 8:59:59'
{
select  sumerr,code ,tscd  from tss_acerr   where
code=2 and
tscd >=   cast( '2022-11-02 00:00:00' as timestamp) order by tscd


select m.mrn ,p.nump,ss.code ,ss.name,ss.myid,acl.ac,p.nump,ss.bp,p.myid,loc.name
from  tss_marsrut as m,tss_ports  as p , tss_acl as acl,
tssloc_locations  as loc,
tss_sensors as  ss
where
ss.code=1
 and m.bpport=p.myid
 --and acl.ac=77
 and ss.bp =p.myid
and p.bp = acl.myid
and ss.bp = p.myid
 and ss.myid=loc.bpsens
 --and m.tag=3

 // d:\postgres\14\bin\pg_dump.exe -d postgres -h localhost -U postgres -f c:\@laz\@atss_units\@pgarc\2023_02_27.sql
 // https://stackoverflow.com/questions/2893954/how-to-pass-in-password-to-pg-dump

 https://stackoverflow.com/questions/2893954/how-to-pass-in-password-to-pg-dump

pg_dump "host=localhost port=5432 dbname=postgres user=postgres password=postgres" > d:\vvg\pg230228.sql -- без запроса пароля

d:\postgres\14\bin\pg_dump.exe "host=localhost port=5432 dbname=postgres user=postgres password=postgres" > c:\@laz\@atss_units\@pgarc\pg.sql



}
}

end.
