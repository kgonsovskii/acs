unit Tssfunc2;
{ Общие Функции  в системе TSS-2000    }
interface

uses Windows, Forms, Classes, SysUtils , Db, DbTables, Dialogs, Controls,
     StdCtrls, ExtCtrls, StrF, ShlObj, FileCtrl,SHELLAPI,
     DateUtils,
     Registry;
TYPE
CONTP   = RECORD
FLAGDONE:STRING;
COMP    :STRING;
IPCOM   :STRING;
ADDRC   :STRING;
ACTIVE  :STRING;
STATE   :STRING;
CONTTYPE:STRING;
CPORTS  :STRING;
COMMENT :STRING;
FP      :STRING;
END;
TYPE CHP = RECORD
FLAGDONE:STRING;
ACTIVE  :STRING;
STATE   :STRING;
COMP    :STRING;
CHTYPE  :STRING;
IPCOM   :STRING;
COMSPEED:STRING;
PORT    :STRING;
END;

TYPE
 TGODMD= RECORD
 G     : INTEGER;
 M     : INTEGER;
 D     :INTEGER;
END;

TYPE
 TTMZ= RECORD
 DAY   : STRING;
 STARTS : STRING;
 STOPS  : STRING;
 STARTC : STRING;
 STOPC : STRING;
 NTMZ  : STRING;
END;





TYPE GT10_OFFSYS = RECORD
      ADRC        :INTEGER;
      PORT        :INTEGER;
      SOURCEL     :INTEGER;    // ДЛИНА ИСХОДНОГО КОДА  , ЕСЛИ 12 ТО 2 СОБЫТИЯ ,ЕСЛИ 15 ТО 3 СОБЫТИЯ, ЕСЛИ 5 ТО 1 СОБЫТИЕ
      COUNTEVENTS : INTEGER;
      SB          : ARRAY[1..3] OF STRING;  // SERVICES BYTS
      POSITION    :INTEGER;     // POSITION OF SERVICES BYT
      REVERSEFLAG :BOOLEAN;     // IF TRU THEN FINELY REVERS BYTS
      PEVENTS     :TSTRINGLIST;  //   EVENTS POOL
     END;

TYPE
  TTRPARAMS = RECORD
   SERVERTYPE :STRING;
   ERRS      :STRING;
   COUNT     :INTEGER;
   SERVICENAME:STRING;
   EXE       :STRING;
   SOCKADDR  :STRING;
   SOCKPORT  :STRING;
  END;

TYPE ATR = ARRAY[1..10] OF TTRPARAMS;





TYPE  FORMATTSS = RECORD
      AV         :STRING;
      SCADDR     :STRING;
      SPORT      :STRING;
      EVENT      :STRING;
      KLUCH      :STRING;
      NUMBEVENT  :STRING;
      CTIME      :STRING;
      NUMD       :STRING;
      NUMM       :STRING;
      GOD        :STRING;
      RST        :STRING;
      FNV        :STRING;
      ERR        :STRING;
      END;


type
  PEnumWindowParam = ^TEnumWindowParam;
  TEnumWindowParam = record
    s: PChar;
    isFound: Boolean;
  end;


Type
  TResultItem = record
    Who: string;
    IsAdded: Boolean;
  end;
  TResults = array of TResultItem;

    //procedure SetServerDate(const dt:TDateTime); // устанавливает дату/время на сервере
    //function  GetServerDate:TDateTime;           // читает дату/время сервера
    //procedure SetLocalDate(const dt:TDateTime);  // устанавливает дату/время на клиенте

  {  Function GetSystemModuleList(FullPath,Unique,IncludeData : boolean) : TStringList;
    Function IsAppUnique(AppName : string) : Boolean; //comment        }


    FUNCTION CONVERTBS(B:BOOLEAN):STRING;
    FUNCTION CONVERTSB(S:STRING):BOOLEAN;
    FUNCTION MYREPLTEXT(SHD,SR,V:STRING):STRING;
    FUNCTION GKEY6TO12(S:STRING):STRING;
    FUNCTION GKEY12TO6(S:STRING):STRING;
    function GetFileStamp(const path:string):string;
    function GetExactTime: string;

    Function Numtokenperc(p:string):word;
    Function Tokenperc(p:string;n:word):string;
    function Encrypt(const InString:string; StartKey,MultKey,AddKey:Integer): string;
    function Decrypt(const InString:string; StartKey,MultKey,AddKey:Integer): string;

    procedure GDelay(MSecs: Longint);
    Function ExtLogAdd(T:TTable;nmc,log,pgm,mes,oper:string):Boolean;
    Function ExtMailUpd(T:TTable;Q:TQuery;typ,nmc,pgm:string):Boolean;
    function NumToken(p:string):word;
    function NumTokennb(p:string):word;
    function NumToken9(p:string):word;

    function Token(p:string;n:word):string;
    function Token9(p:string;n:word):string;
    function Tokennb(p:string;n:word):string;
    Function SetNumPort(p,t:word):byte;
    function DeleteChar(s:String; c:Char):String;

    function Posrepl(s,s1:string;x:word):String;

    function ReplaceText(s, SourceText, DestText: String):String;
    function LTrim(s:String):String;
    function RTrim(s:String):String;
    function Trim(s:String):String;
    function Ansi2Oem(AnsiStr:String):String;
    function Oem2Ansi(OemStr:String):String;
    function Padr(s:String;iWidth:Integer;sFull:String):String;
    function RunProgramm(S : String) : Boolean;
    function TimeTosec(t:Tdatetime):longint;
    function SecToTime(t:longint):TDateTime;
    function Azerol(S:String;n:integer) : String;
    function Isbit(w,n:word):Boolean;
    function Setbit(w,n:word):word;
    function Zerobit(w,n:word):word;
    function SetRelay(p,t:word):byte;
    function Ctoh(s:string):string;
    function Cton(v:string):string;
    Function Qmbox(Q:Tquery;typ,nm:string):Boolean;
    Function CheckFioUser(Qpersonal:TQuery;s: string):string;
    Function Checkitime(p:string):string;
    Function GetStrDate(DT : TDateTime) : String;
    function Azeror(s:String; n:integer):String;
    Function ZZdate(d:string):string;
    FUNCTION GHSTOINT(S:STRING):INTEGER;
    //Function GetKeyFromCrdr(Q,Qt:Tquery;typ,nm:string):string;

    Function dbGetAliasPath(AliasName : String) : String;
    //Function Asrcr(RSA1:TRSA;pub,priv:TRSAKey;s:string):string;
    //Function Asrdcr(RSA1:TRSA;pub,priv:TRSAKey;s:string):string;

    function GetFileDateTime(const FileName : String) : TDateTime;

    function BrowseForFolder(var Directory: string): Boolean;
    Function Numtokencom(p:string):word;
    function Tokencom(p:string;n:word) : String;
    procedure GetChanges(OldList, NewList: TStrings; var Results: TResults);
    Function GUserName: string;
    FUNCTION GCOMPUTERNAME:STRING;
    FUNCTION GETFORMATTSS(EV:STRING):FORMATTSS;
    FUNCTION HEXTODIGMASK(H:STRING):STRING;
    FUNCTION GETSHORTCUT(FK:STRING):TSHORTCUT;
    procedure ReadTRPARAMS(VAR TRPARAMS:ATR);
    procedure KillProcess(const prcs: string);
    FUNCTION  FINDProcess(const prcs: string):BOOLEAN;
    function GlueDateAndTime(const ADate: TDateTime; const ATime: TDateTime): TDateTime;
    FUNCTION GETPGPRM(SL:TSTRINGLIST;NM:STRING):STRING;
    function EnumWindow(wnd: HWND; param: LPARAM): LongBool; stdcall;
    function WindowExists(const CaptionPart: string): Boolean;




Var
prl,prr,pul,pur:real;
implementation
USES  PsAPI;

FUNCTION GETPGPRM(SL:TSTRINGLIST;NM:STRING):STRING;
BEGIN
RESULT:='';
TRY
   RESULT:=uppercase(TRIM(SL.Values[NM]));

EXCEPT
END;

END;


function EnumWindow(wnd: HWND; param: LPARAM): LongBool; stdcall;
var
  Buf: array [0..$FF] of Char;
  EnumWindowParam: PEnumWindowParam;
begin
  EnumWindowParam := PEnumWindowParam(param);
  GetWindowText(wnd, Buf, SizeOf(Buf));
  EnumWindowParam.isFound := Pos(EnumWindowParam.s, Buf) <> 0;
  Result := not EnumWindowParam.isFound;
end;


function WindowExists(const CaptionPart: string): Boolean;
var
  EnumWindowParam: TEnumWindowParam;
begin
  EnumWindowParam.s := @CaptionPart[1];
  EnumWindowParam.isFound := False;
  EnumWindows(@EnumWindow, LPARAM(@EnumWindowParam));
  Result := EnumWindowParam.isFound;
end;




function GlueDateAndTime(const ADate: TDateTime; const ATime: TDateTime): TDateTime;
var
  y, m, d, h, n, s, z: Word;
begin
  DecodeDate(ADate, y, m, d);
  DecodeTime(ATime, h, n, s, z);
  Result := EncodeDateTime(y, m, d, h, n, s, z);
end;




FUNCTION CONVERTBS(B:BOOLEAN):STRING;
BEGIN
    IF B=TRUE THEN RESULT:='YES' ELSE RESULT:='NO';
END;

FUNCTION CONVERTSB(S:STRING):BOOLEAN;
BEGIN
     IF S='YES' THEN RESULT:=TRUE ELSE RESULT:=FALSE;
END;

FUNCTION MYREPLTEXT(SHD,SR,V:STRING):STRING;
BEGIN
// SHD - ШАБЛОН ПАРАМЕТРА  &KLUCH
// SR  - ИСХОДНИК SELECT * FROM BF_MAPCONT WHERE KLUCH=&KLUCH
// V   - ЗНАЧЕНИЕ ДЛЯ ЗАМЕНЫ
  // RESULT:=ReplaceText(SHD,SR,V);
   RESULT:=ReplaceText(SR,SHD,V);

END;

FUNCTION  FINDProcess(const prcs: string):BOOLEAN;
const
  MAX_PID = 1024;
var
  lpidProcess: array [0.. MAX_PID -1] of DWORD;
  cbNeeded: DWORD;
  i: Integer;
  hProcess: THandle;
  lpFileName: array [0..MAX_PATH] of AnsiChar;
begin
  RESULT:=FALSE;
  if not EnumProcesses(@lpidProcess, MAX_PID, cbNeeded) then
    Exit;
  for i:=0 to (cbNeeded div SizeOf(DWORD)) do begin
    hProcess := OpenProcess(PROCESS_QUERY_INFORMATION	OR PROCESS_VM_READ, False, lpidProcess[i]);
    if hProcess <> 0 then
    try
      if GetModuleBaseName(hProcess, 0, lpFileName, MAX_PATH) <> 0 then
        if SameText(ExtractFileName(lpFileName), prcs) then begin
          RESULT:=TRUE;
          Break;
        end;
    finally
      CloseHandle(hProcess);
    end;
  end;
end;


procedure getDebugPriv;
var
  hToken: THandle;
  sedebugnameValue: TLargeInteger;
  tkp: TTokenPrivileges;
  Len: DWORD;
begin
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken);
  try
    if not LookupPrivilegeValue(nil, 'SeDebugPrivilege', sedebugnameValue) then
      Exit;
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Luid := sedebugnameValue;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if not AdjustTokenPrivileges(hToken, False, tkp, SizeOf(tkp), nil, Len) then
      Exit;
  finally
    CloseHandle(hToken);
  end;
end;

procedure KillProcess(const prcs: string);
const
  MAX_PID = 1024;
var
  lpidProcess: array [0.. MAX_PID -1] of DWORD;
  cbNeeded: DWORD;
  i: Integer;
  hProcess: THandle;
  lpFileName: array [0..MAX_PATH] of AnsiChar;
begin
  getDebugPriv;
  if not EnumProcesses(@lpidProcess, MAX_PID, cbNeeded) then
    Exit;
  for i:=0 to (cbNeeded div SizeOf(DWORD)) do begin
    hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, lpidProcess[i]);
    if hProcess <> 0 then
    try
      if GetModuleBaseName(hProcess, 0, lpFileName, MAX_PATH) <> 0 then
        if SameText(ExtractFileName(lpFileName), prcs) then begin
          TerminateProcess(hProcess, 0);
          Break;
        end;
    finally
      CloseHandle(hProcess);
    end;
  end;
end;






procedure ReadTRPARAMS(VAR TRPARAMS:ATR);
var  i,j,l,c,ch,k  : integer;
       p,s,ss,mon,D,T,NM : String;
       f : TRegIniFile;
      // fi : TIniFile;
       SL:TSTRINGLIST;

begin
TRY
  //FORM1.SELFLOG('I,ReadTRPARAMS 1');
  SL:=TSTRINGLIST.Create;
  for j:=1 to 4 do begin
   trparams[j].count:=0;
   trparams[j].SERVERTYPE:='';
   TRPARAMS[J].EXE:='';
   TRPARAMS[J].SOCKADDR:='';
   TRPARAMS[J].SOCKPORT:='';
   TRPARAMS[J].SERVICENAME:='';
   TRPARAMS[J].ERRS:='';
  end;
  //FORM1.SELFLOG('I,ReadTRPARAMS 2');

  f              := TRegIniFile.Create;
  f.RootKey := HKEY_LOCAL_MACHINE;
  F.OpenKey('SOFTWARE\Seven Seals TSS\Transport\Server\Instances\', False);

  F.GetKeyNames(SL);
  for i:=0 to SL.Count - 1 do begin
    J:=I+1;
    TRPARAMS[J].SERVICENAME:=SL.Strings[I];
    TRPARAMS[J].SOCKADDR:=ANSIUPPERCASE(f.ReadString(SL[i], 'SOCKADDR', 'unknown'));
    TRPARAMS[J].SOCKPORT:=ANSIUPPERCASE(f.ReadString(SL[i], 'SOCKPORT', 'unknown'));
    TRPARAMS[J].EXE:=ANSIUPPERCASE(f.ReadString(SL[i], 'File', 'unknown'));
    IF TRPARAMS[J].SOCKADDR='UNKNOWN' THEN TRPARAMS[J].SOCKADDR:=GCOMPUTERNAME;
  end;
  //FORM1.SELFLOG('I,ReadTRPARAMS 3');
  //FORM1.SELFLOG('I,ReadTRPARAMS SLCOUNT='+INTTOSTR(SL.Count));
  FOR I:=0 TO SL.Count-1 DO BEGIN
   J:=I+1;
   TRPARAMS[J].COUNT:=SL.Count;
  END;
  //FORM1.SELFLOG('I,ReadTRPARAMS 4');

EXCEPT
 ON E:EXCEPTION DO BEGIN
 for j:=1 to length(trparams) do begin
   TRPARAMS[J].ERRS:=E.Message;
   //FORM1.SELFLOG('E,ReadTRPARAMS ,E='+E.Message);
 end;
END;
END;
END;





FUNCTION HEXTODIGMASK(H:STRING):STRING;
VAR
I,N:INTEGER;
C,S,S1:STRING;
BEGIN
 RESULT:='';
 S:='';
TRY
 N:=GHSTOINT(H);
 S:='';
 FOR I:=1 TO 8 DO BEGIN
  IF ISBIT(N,I) THEN BEGIN
   C:=INTTOSTR(I);
  END
  ELSE BEGIN
   C:='0';
  END;
  S:=S+C;
 END;
EXCEPT
END;

 RESULT:=S;
END;




FUNCTION GETSHORTCUT(FK:STRING):TSHORTCUT;
VAR
HK:TSHORTCUT;
BEGIN
      RESULT:=0;
      FK:=TRIM(FK);
      IF FK='F1' THEN  HK := VK_F1;
      IF FK='F2' THEN  HK := VK_F2;
      IF FK='F3' THEN  HK := VK_F3;
      IF FK='F4' THEN  HK := VK_F4;
      IF FK='F5' THEN  HK := VK_F5;
      IF FK='F6' THEN  HK := VK_F6;
      IF FK='F7' THEN  HK := VK_F7;
      IF FK='F8' THEN  HK := VK_F8;
      IF FK='F9' THEN  HK := VK_F9;
      IF FK='F10' THEN  HK := VK_F10;
      IF FK='F11' THEN  HK := VK_F11;
      IF FK='F12' THEN  HK := VK_F12;
      RESULT:=HK;

END;

FUNCTION GETFORMATTSS(EV:STRING):FORMATTSS;

VAR
R: FORMATTSS;
I,L,NM,NN,ND,CM,PM:INTEGER;
S,GOD,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11:STRING;
BEGIN
//K,238,8,KEY,0000007716DB,697,11:03:33,17,4,,NO
//K,49,1,DATA,,9448,11:03:42,17,4,,NO
//A,238,8,KEY,000000557B61,743,16:31:09,17,4,NOTKEY,NO
//1 2  3  4     5           6     7      8 9     10     11
//A,30,1,KEY,000002743666,23530,12:35:40,3,7:2007,NOTKEY,NO
//A,17,4,KEYA,00000346FF6C,32152,13:00:56,5,1,GO,NO
//                    5      6       7    8 9 10
TRY
 S:=EV;
 L:=LENGTH(S);
 R.ERR:='';
 R.AV:=EXTRACTSTR(1,S,',');
 R.SCADDR:=EXTRACTSTR(2,S,',');
 R.SPORT:=EXTRACTSTR(3,S,',');
 R.EVENT:=EXTRACTSTR(4,S,',');
 R.KLUCH:=EXTRACTSTR(5,S,',');
 R.NUMBEVENT:=EXTRACTSTR(6,S,',');
EXCEPT
 ON E:EXCEPTION DO BEGIN
  R.ERR:='P0/'+E.Message;
 END;
END;
TRY
 R.CTIME:=EXTRACTSTR(7,S,',');
 R.NUMD:=EXTRACTSTR(8,S,',');
 R.NUMD:=AZEROL((R.NUMD),2);
 R.NUMM:=AZEROL(EXTRACTSTR(9,S,','),2);
 R.RST:=EXTRACTSTR(10,S,',');
 R.FNV:=EXTRACTSTR(11,S,',');
 P9:=EXTRACTSTR(9,S,',');
 P9:=AZEROL(P9,2);
 PM:=POS(':',R.NUMM);
 IF PM >0 THEN BEGIN
  R.NUMM:=EXTRACTSTR(1,R.NUMM,':');
  R.NUMM:=AZEROL(R.NUMM,2);
 END;
TRY
 IF P9[2] =':' THEN BEGIN
  R.GOD:=COPY(P9,3,4);
 END;
EXCEPT

END;
{
IF LENGTH(P9)<2 THEN BEGIN
 R.ERR:='MISSING "CTIME"';
 RESULT:=R;
 EXIT;
END;
}
IF P9[2] <>':' THEN BEGIN
// CM - ТЕКУЩИЙ МЕСЯЦ
// NM - МЕСЯЦ ИЗ СОБЫТИЯ
 TRY
  NM:=STRTOINT(R.NUMM);
  EXCEPT END;
  //GOD:=INTTOSTR(YearOf(Date));
  CM:=MonthOfTheYear(DATE);
  IF CM=NM THEN BEGIN
   R.GOD:=INTTOSTR(YearOf(Date));
  END;
  IF CM-NM < 0   THEN BEGIN
   NN:=YearOf(Date);
   NN:=NN-1;
   R.GOD:=INTTOSTR(NN);
  END;
   IF CM-NM >=0   THEN BEGIN
   NN:=YearOf(Date);
   R.GOD:=INTTOSTR(NN);
  END;
 END;
EXCEPT
 ON E:EXCEPTION DO BEGIN
 R.ERR:=E.Message;
 END;
END;
 RESULT:=R;
END;






FUNCTION GCOMPUTERNAME:STRING;
VAR
COMPUTERNAME:STRING;
CCCCC : array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  lllll : DWord;
BEGIN
 ComputerName := 'UNKNOWN';
 FillChar(CCCCC,SizeOf(CCCCC),0);
 lllll := MAX_COMPUTERNAME_LENGTH + 1;
 if GetComputerName(CCCCC,lllll) then ComputerName := StrPas(CCCCC);
 RESULT:=ComputerName;
END;



Function GUserName: string;
var
  buf: array [0..255] of Char;
  Len: DWORD;
begin
  Len := SizeOf(buf);
  if GetUserName(@buf, Len) then
    Result := buf;
end;



FUNCTION GHSTOINT(S:STRING):INTEGER;
// CONVERT HEX STRING TO INTEGER
VAR
I,N:INTEGER;
BEGIN
  N:=POS('$',S);
  IF N <=0 THEN S:='$'+S;
  I := StrToInt(S);
  RESULT:=I;
END;



FUNCTION GKEY6TO12(S:STRING):STRING;
BEGIN
  TRY
  SETLENGTH(RESULT,12);
  //S:='000000828E34';
  BINTOHEX(PCHAR(s), PCHAR(RESULT), 12);
  EXCEPT
   RESULT:='';
  END;
END;

FUNCTION GKEY12TO6(S:STRING):STRING;
BEGIN
  TRY
  SETLENGTH(RESULT,6);

  HEXTOBIN(PCHAR(s), PCHAR(RESULT), 6);
  EXCEPT
   RESULT:='';
  END;
END;


Function ZZdate(d:string):string;
// Переворот даты
begin

   //12.12.1998
   Result:=Copy(d,7,4)+'.'+Copy(d,4,2)+'.'+Copy(d,1,2);

end;

function GetExactTime: string;
begin
 Result := FormatDateTime('hh:nn:ss,zzz', Now);
end;


Function dbGetAliasPath(AliasName : String) : String;
Var
  Q : TStringList;
  I : Integer;
begin
  Result := '';
  Q := TStringList.Create;
  Try
  Try
  Session.GetAliasParams(AliasName,Q);
  Except
  end;
  For I := 0 To Q.Count-1 do
  begin
  If Pos('PATH=',Q[i]) <> 0 Then
  begin
  Result := Copy(Q[i],6,Length(Q[i]));
  Break;
  end;
  end;
  Finally
  Q.Destroy;
  end;
end;  



{

procedure SetServerDate(const dt:TDateTime); // устанавливает дату/время на сервере
begin
  with TQuery.Create(Self) do try
    DatabaseName:=Self.Database.DatabaseName;
    SQL.Add('select f_SetServerDateTime("'+DateTimeToStr(dt)+'") from MAILBOX');
    Active:=True;
    Active:=False;
  finally
    Free;
  end;
end;


function GetServerDate:TDateTime;           // читает дату/время сервера
begin
  Result:=Now;
  with TQuery.Create(Self) do try
    DatabaseName:=Self.Database.DatabaseName;
    SQL.Add('select f_GetServerDateTime() from MAILBOX');
    Active:=True;
    if not (BOF and EOF) then Result:=Fields[0].AsDateTime;
    Active:=False;
  finally
    Free;
  end;
end;

procedure SetLocalDate(const dt:TDateTime);  // устанавливает дату/время на клиенте
  var t:TSystemTime;
      d,m,y,hh,mm,ss,ms:Word;
begin
  DecodeDate(dt,y,m,d);
  DecodeTime(dt,hh,mm,ss,ms);
  t.wYear:=y;
  t.wMonth:=m;
  t.wDay:=d;
  t.wHour:=hh;
  t.wMinute:=mm;
  t.wSecond:=ss;
  t.wMilliseconds:=ms;
  Windows.SetLocalTime(t);
end;

}

procedure GDelay(MSecs: Longint);
var
  FirstTickCount, Now: Longint;
begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
    Now := GetTickCount;
  until (Now - FirstTickCount >= MSecs) or (Now < FirstTickCount);
end;


Function Posrepl(s,s1:string;x:word):String;
begin
 Delete(s,x,1);
 Insert(s1,s,x);
 Result:=s;
end;

Function GetStrDate(DT : TDateTime) : String;
Var
  D  , M  , Y  : Word;
  Ds , Ms , Ys : String;
begin
  DecodeDate(DT , Y , M , D);

  DS := IntToStr(D);
  YS := IntToStr(Y);
  Case M of
    1  : Ms := 'января';
    2  : Ms := 'Февраля';
    3  : Ms := 'марта';
    4  : Ms := 'апреля';
    5  : Ms := 'мая';
    6  : Ms := 'июня';
    7  : Ms := 'июля';
    8  : Ms := 'августа';
    9  : Ms := 'сентября';
    10 : Ms := 'октября';
    11 : Ms := 'ноября';
    12 : Ms := 'декбря';
  end;
  Result := ' '+ Ds + '  ' + Ms + '  ' + Ys + '  ' + 'года';
end;




Function Checkitime(p:string):string;
Var
t1,t2:Tdatetime;
n:word;
s,s1,s2:string;
rc:string;
begin
t1:=Time;
t2:=Time;
n:=NumToken(p);
if n =1 then begin
 Result:='';
 Exit;
end;

if n > 2 then begin
 Result:='';
 Exit;
end;


s1:=Token(p,1);
s2:=Token(p,2);

if s2 = '24:00' then begin
 s2:='23:59';
end;

if s2 = '24:0' then begin
 s2:='23:59';
end;

if s2 = '24' then begin
 s2:='23:59';
end;

if s2 = '24:' then begin
 s2:='23:59';
end;

Try
 t1:=StrToTime(s1);
 rc:=s1;
Except
 rc:='';
end;
if rc = '' then  begin
 Result:='';
 Exit;
end;
Try
 t2:=StrToTime(s2);
 rc:=s2;
Except
 rc:='';
end;
if rc = '' then begin
 Result:=rc;
 Exit;
end;
s:=TimeToStr(t1);
s1:=Copy(s,1,5);

s:=TimeToStr(t2);
s2:=Copy(s,1,5);

if s2 < s1 then begin
 Result:='';
 Exit;
end;

if s2 = s1 then begin
 Result:='';
 Exit;
end;



Result:=s1+'-'+s2;
end;




Function CheckFioUser(Qpersonal:TQuery;s: string):string;
Var
f:string;
n:longint;
kkk:string;
begin
 kkk:=s;
 QPersonal.Close;
 QPersonal.SQL.Clear;
 s:='SELECT FIO from PERSONAL where KLUCH='+Chr(39)+s+Chr(39);

 QPersonal.SQL.Add(s);
 QPersonal.Open;
 f:=Trim(QPersonal.FieldByName('FIO').AsString);

 s:='SELECT Count(*) from PERSONAL where KLUCH='+Chr(39)+kkk+Chr(39);

 QPersonal.Close;
 QPersonal.SQL.Clear;
 QPersonal.SQL.Add(s);
 QPersonal.Open;
 n:=QPersonal.Fields[0].AsInteger;
 if n = 0 then begin
  Result:='';
 end
 else begin
  Result:=f;
 end;
end;

{
Function GetKeyFromCrdr(Q,Qt:Tquery;typ,nm:string):string;
//
//  поиск записи с типом typ и именем компьютера nm и чтение ключа
//
Var
i:word;
s:string;
f,s3,s1,s2:string;
begin

 Q.SQL.Clear;
 s:='SELECT * from MAILBOX where '+
 ' comptype ='+Chr(39)+typ+Chr(39)+ ' and compname ='+Chr(39)+nm+Chr(39);
 Q.SQL.Add(s);
 Q.Open;
 s1:=Q.FieldByName('COMPTYPE').AsString;
 s2:=Q.FieldByName('COMPNAME').AsString;
 s3:=Q.FieldByName('CRDRKLUCH').AsString;
 if (s1 = typ) and (s2 = nm) then begin
  Qt.DatabaseName:='TSS2000IDATA';
  f:='UPDATE  MAILBOX set CRDRKLUCH="" where COMPNAME='+
  Chr(39)+s2+Chr(39)+' and COMPTYPE='+Chr(39)+s1+Chr(39);
  For i:=1 To 10000 do begin
   Application.ProcessMessages;
   //if  not FormMain.Datab.Intransaction then begin
    Qt.Close;
    Qt.SQL.Clear;
    Qt.SQL.Add(f);
    Try
     Qt.ExecSQL;
     Qt.Close;
     Result:=s3;
     Exit;
    Except
     on E:Exception do begin
      Otl32.Otl('Ошибка :'+E.Message);
      Otl32.Otl('ERRROR*****************************');
     end;
    end;
    Otl32.Otl(IntTostr(i));
   end;
   //end;
  end;
 Otl32.Otl('^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
 Result:='';

end;

}




Function Qmbox(Q:Tquery;typ,nm:string):Boolean;
//
//  Поск записи с типом typ и именем компьютера nm
//
Var
s:string;
s1,s2:string;
begin

 Q.SQL.Clear;
 s:='SELECT * from MAILBOX where '+
 ' comptype ='+Chr(39)+typ+Chr(39)+ ' and compname ='+Chr(39)+nm+Chr(39);
 Q.SQL.Add(s);
 Q.Open;
 s1:=Q.FieldByName('COMPTYPE').AsString;
 s2:=Q.FieldByName('COMPNAME').AsString;
 if (s1 = typ) and (s2 = nm) then begin
  Result:=True;
  Exit;
 end;

 Result:=False;

end;







Function ExtLogAdd(T:TTable;nmc,log,pgm,mes,oper:string):Boolean;
// Добавление  в SYSLOG . Регистрация пользователя
begin
  Try
   T.Open;
   T.Append;
   T.FieldByName('COMPNAME').Asstring:=nmc;
   T.FieldByName('CURRUSER').Asstring:=log;
   T.FieldByName('Event_Date').AsDateTime:=Now;
   T.FieldByName('Event_Time').AsString:=Azerol(TimeToStr(Now),8);
   T.FieldByName('Event_Type').AsString  :=AnsiUppercase(mes);
   T.FieldByName('PGM').AsString  :=pgm;
   T.FieldByName('OPERATOR').AsString  :=oper;
   T.Post;
   T.Close;
  Except
   on E:Exception do begin
    Result:=False;
    Exit;
   end;
  end;
  Result:=True;

end;

Function ExtMailUpd(T:TTable;Q:Tquery;typ,nmc,pgm:string):Boolean;
// Обновление даты и времени  в MAILBOXe  по имени компьютера и типу процесса
Var
i:word;
rc:Boolean;
begin
 rc:=False;
 For i:=1 To 20 do begin
  TRY

   if Qmbox(Q,typ,nmc) then begin
    Q.Edit;
    Q.FieldByName('LASTTIME').AsString:=Azerol(TimeTostr(Time),8);
    Q.FieldByName('LASTDATE').AsDateTime:=Date;
    Q.FieldByName('PGM').Asstring:=pgm;
    Q.Post;
    Result:=True;
    Exit;
   end;
  Except

  end;
  Result:=rc;
 end;   // End of i:=

end;

Function Numtoken(p:string):word;
Var
i,n,l:word;
begin
 n:=1;
 l:=Length(p);
 For i:=1 To l do begin
  if p[i] <> ' '  then begin
   if (p[i]=',') or (p[i] = ' ') or (p[i] = '-') or (p[i] = '@')  then begin
    n:=n+1;
   end;
  end;

 end;
 Result:=n;
end;

function NumToken9(p:string):word;
  var i : word;
begin
  Result := 0;
  for i := 1 To Length(p) do if (p[i] = #9) then Inc(Result);
end;

Function Numtokennb(p:string):word;
Var
i,n,l:word;
begin
 n:=1;
 l:=Length(p);
 For i:=1 To l do begin
  if (p[i]=',') or (p[i] = '-') or (p[i] = '@')  then begin
    n:=n+1;
   end;
 end;
 Result:=n;
end;


Function Token(p:string;n:word):string;
Var
i,k,l:word;
s:string;
begin

 k:=1;
 s:='';
 l:=Length(p);
 For i:=1 To l do begin
  if p[i] <> ' '  then begin
   if (p[i]=',') or (p[i] = ' ') or (p[i] = '-') or (p[i] = '@') then begin
    k:=k+1;
   end
   else begin
    if k = n then begin
     s:=s+p[i];
    end;
   end;
  end;
  end;
 Result:=s;
end;

function Token9(p:string;n:word) : String;
  //var i,k,l : Word;
begin
  Result := Strf.ExtractStr(n,p,#9);
  {k:=1;
  Result:='';
  for i:=1 to Length(p) do begin
  if p[i] <> ' '  then begin
   if (p[i]=#9) then Inc(k)
    k:=k+1;
   end
   else begin
    if k = n then begin
      Result:=Result + p[i];
    end;
   end;
  end;
  end;
 Result:=s;}
end;


Function Tokennb(p:string;n:word):string;
Var
i,k,l:word;
s:string;
begin

 k:=1;
 s:='';
 l:=Length(p);
 For i:=1 To l do begin
   if (p[i]=',') or (p[i] = '-') or (p[i] = '@') then begin
    k:=k+1;
   end
   else begin
    if k = n then begin
     s:=s+p[i];
    end;
   end;

  end;
 Result:=s;
end;


Function Numtokenperc(p:string):word;
Var
i,n,l:word;
begin
 n:=1;
 l:=Length(p);
 For i:=1 To l do begin
  if (p[i]='%') then begin
    n:=n+1;
   end;
 end;
 Result:=n;
end;

Function Tokenperc(p:string;n:word):string;
Var
i,k,l:word;
s:string;
begin

 k:=1;
 s:='';
 l:=Length(p);
 For i:=1 To l do begin
   if (p[i]='%') then begin
    k:=k+1;
   end
   else begin
    if k = n then begin
     s:=s+p[i];
    end;
   end;

  end;
 Result:=s;
end;






Function Cton(v:string):string;
Var
bb:word;
i,j:word;
p:string;
s1,s2:string[6];

begin

 if Odd(Length(v)) then v:='0'+v;

 p:=''; j:=1;
 For i:=1 To Length(v) div 2 do begin
 s1:=Copy(v,j,1);
 s2:=Copy(v,j+1,1);
 bb:=0;
 if s1 = 'A' then bb:=bb or $A0;
 if s1 = 'B' then bb:=bb or $B0;
 if s1 = 'C' then bb:=bb or $C0;
 if s1 = 'D' then bb:=bb or $D0;
 if s1 = 'E' then bb:=bb or $E0;
 if s1 = 'F' then bb:=bb or $F0;

 if s2 = 'A' then bb:=bb or $0A;
 if s2 = 'B' then bb:=bb or $0B;
 if s2 = 'C' then bb:=bb or $0C;
 if s2 = 'D' then bb:=bb or $0D;
 if s2 = 'E' then bb:=bb or $0E;
 if s2 = 'F' then bb:=bb or $0F;

 if s1 = '0' then bb:=bb or $00;
 if s1 = '1' then bb:=bb or $10;
 if s1 = '2' then bb:=bb or $20;
 if s1 = '3' then bb:=bb or $30;
 if s1 = '4' then bb:=bb or $40;
 if s1 = '5' then bb:=bb or $50;
 if s1 = '6' then bb:=bb or $60;
 if s1 = '7' then bb:=bb or $70;
 if s1 = '8' then bb:=bb or $80;
 if s1 = '9' then bb:=bb or $90;

 if s2 = '0' then bb:=bb or $00;
 if s2 = '1' then bb:=bb or $01;
 if s2 = '2' then bb:=bb or $02;
 if s2 = '3' then bb:=bb or $03;
 if s2 = '4' then bb:=bb or $04;
 if s2 = '5' then bb:=bb or $05;
 if s2 = '6' then bb:=bb or $06;
 if s2 = '7' then bb:=bb or $07;
 if s2 = '8' then bb:=bb or $08;
 if s2 = '9' then bb:=bb or $09;
 p:=p+Chr(bb);
 j:=j+2
end;
Result:=p;
end;

Function Ctoh(s:string):string;
Var
i:longint;
ss:string;
 begin
   ss:='';
   For i:=1 To Length(s) do begin
    ss:=ss+IntToHex(Ord(s[i]),2);
   end;
  Result:=ss

end;
{
Function SecToTime(t:longint):TDateTime;
Var
 h,m,mm,s:longint;
 ss:string;
 begin

  h := (t div 3600) mod 25 ;
  m :=(t mod 3600) div 60;
  mm:=(t mod 3600) mod 60 ;
  s :=mm mod 60;

  if h >=24 then h:=0;

  Otl32.Otl('t='+IntTostr(t)+' h='+IntTostr(h)+' m='+IntToStr(m)+' s='+IntTostr(s));
  ss:=Azerol(IntTostr(h),2)+':'+Azerol(IntTostr(m),2)+':'+Azerol(IntTostr(s),2);
  Result:=StrToTime(ss);

end;
}

Function SecToTime(t:longint):TDateTime;
Var
 h,m,mm,s:longint;
 ss:string;
 begin

  h := (t mod 86400)div 3600 ;  // берем по модулю(сек в сутках)и делим на (сек в часах) получаем часов в остатке суток
  m :=(t mod 3600) div 60;      // берем по модулю(сек в часах) и делим на (сек в минутах) получаем минут в остатке часа
  mm:=(t mod 3600) mod 60 ;     // !!! лишнее результат определяется только по модулю 60 так как он меньше
                                // в нижней строке повторно берется модуль 60 что не меняет результат (a:=a AND 3 эквивалентно a:=a MOD 8, a:=a AND 3 AND 3... e.t.c. резултат не меняется)
                                // лучше обе строки заменить на s:=t mod 60
  s :=mm mod 60;                // берем по модулю(сек в минуте) получаем сек в остатке минуты

//  if h >=24 then h:=0; вобще не нужно так как никогда не выполняется в силу h := (t mod 86400)div 3600 ;

  {Otl32.Otl('t='+IntTostr(t)+' h='+IntTostr(h)+' m='+IntToStr(m)+' s='+IntTostr(s));}
  ss:=Azerol(IntTostr(h),2)+':'+Azerol(IntTostr(m),2)+':'+Azerol(IntTostr(s),2);
  Result:=StrToTime(ss);

end;

 



Function SetNumPort(p,t:word):byte;
Var
i,b:byte;
begin
  b:=0;
  
  For i:= 1 to  3  do begin
   if Isbit(p,i) then begin
    b:=SetBit(b,i);
   end;
  end;

  Result:=b
end;


Function SetRelay(p,t:word):byte;
Var
i,j,b:byte;
begin
  b:=0;
  
  For i:= 1 to  3  do begin
   if Isbit(p,i) then begin
    b:=SetBit(b,i);
   end;
  end;
  j:=3;
  For i:=1 To 5   do begin
   if Isbit(t,i) then begin
    b:=SetBit(b,i+j);
   end;
  end;
  Result:=b
end;


Function Isbit(w,n:word):Boolean;
Var
b:word;
begin
 b:=0;

 if n = 1 then b:= w and $01;
 if n = 2 then b:= w and $02;
 if n = 3 then b:= w and $04;
 if n = 4 then b:= w and $08;
 if n = 5 then b:= w and $10;
 if n = 6 then b:= w and $20;
 if n = 7 then b:= w and $40;
 if n = 8 then b:= w and $80;

 if b > 0 then  Result:=True else  Result:=False;
end;

function Setbit(w,n:word) : Word;
begin
  case n of
    1 : Result:= w or $01;
    2 : Result:= w or $02;
    3 : Result:= w or $04;
    4 : Result:= w or $08;
    5 : Result:= w or $10;
    6 : Result:= w or $20;
    7 : Result:= w or $40;
    8 : Result:= w or $80;
    else Result := w;
  end;
end;

function Zerobit(w,n:word):word;
begin
  case n of
    1 : Result:= w xor $01;
    2 : Result:= w xor $02;
    3 : Result:= w xor $04;
    4 : Result:= w xor $08;
    5 : Result:= w xor $10;
    6 : Result:= w xor $20;
    7 : Result:= w xor $40;
    8 : Result:= w xor $80;
    else Result := w;
  end;
end;

Function TimeTosec(t:Tdatetime):longint;
Var
 p: TdateTime;
 h,m,s,ms:word;
 begin
  p:=t;
  Decodetime(p,h,m,s,ms);
  Result:=3600*h+60*m+s;
end;


function Azerol(s:String; n:integer):String;
  var i,l:Integer;
     
begin
  S := Trim(S);
  l:=Length(s);
  For i:=l To n-1 do begin
   s:='0'+s;
  end;
  Result := S;
end;

function Azeror(s:String; n:integer):String;
  var i,l:Integer;

begin
  S := Trim(S);
  l:=Length(s);
  For i:=l To n-1 do begin
   s:=s+'0';
  end;
  Result := S;
end;



function DeleteChar(s:String; c:Char):String;
  var i:Integer;
      st:String;
begin
  DeleteChar:='';
  if (s='') then Exit;
  st:=s;
  i:=Pos(c,st);
  while (i>0) do
  begin
    Delete(st,i,1);
    i:=Pos(c,st);
  end;
  DeleteChar:=st;
end;

function ReplaceText(s, SourceText, DestText: String):String;
  var st,res:string;
      i:Integer;
begin
  ReplaceText:='';
  if ((s='') or (SourceText='')) then Exit;
  st:=s;
  res:='';
  i:=Pos(SourceText,s);
  while (i>0) do
  begin
    res:=res+Copy(st,1,i-1)+DestText;
    Delete(st,1,(i+Length(SourceText)-1));
    {if (DestText<>'') then Insert(DestText,st,i);}
    i:=Pos(SourceText,st);
  end;
  res:=res+st;
  ReplaceText:=res;
end;


function LTrim(s:String):String;
  var st:String;
begin
  LTrim:='';
  if (s='') then Exit;
  st:=s;
  while (Length(st)>0) do if (st[1]=' ') then Delete(st,1,1) else Break;
  LTrim:=st;
end;

function RTrim(s:String):String;
  var st:String;
begin
  RTrim:='';
  if (s='') then Exit;
  st:=s;
  while (Length(st)>0) do if (st[Length(st)]=' ') then Delete(st,Length(st),1) else Break;
  RTrim:=st;
end;

function Trim(s:String):String;
begin
  Result:=LTrim(RTrim(s));
end;

function Ansi2Oem(AnsiStr:String):String;
  var fs,ts:array[0..255] of char;
begin
  FillChar(fs,256,0);
  FillChar(ts,256,0);
  StrPCopy(fs,AnsiStr);
  AnsiToOem(fs,ts);
  Result:=StrPas(ts);
end;

function Oem2Ansi(OemStr:String):String;
  var fs,ts:array[0..255] of char;
begin
  FillChar(fs,256,0);
  FillChar(ts,256,0);
  StrPCopy(fs,OemStr);
  OemToAnsi(fs,ts);
  Result:=StrPas(ts);
end;

function RunProgramm(S : String) : Boolean;
begin
Result := True;
S := S + #0;
//If WinExec(@S[1] , SW_SHOWNORMAL) < 32 then result := False;
  IF ShellExecute(0, NIL, @S[1], NIL, NIL, SW_SHOWNORMAL) <= 32 THEN
    RaiseLastOSError;
end;

function Padr(s:String;iWidth:Integer;sFull:String):String;
var i,n: Integer;
begin
	n := Length(s);
  	IF n > iWidth then
    	Result	:= Copy(s,1,iWidth)
    Else Begin
    	Result := '';
    		for i:=1 to iWidth-n do	Result := Result + sFull;
  		Result	:= Copy(s+Result,1,iWidth);
    End
end;



{*******************************************************
 * Standard Encryption algorithm - Copied from Borland *
 *******************************************************}
function Encrypt(const InString:string; StartKey,MultKey,AddKey:Integer): string;
var
  I : Byte;
begin
 {
  StartKey        = 981;  	//Start default key
  MultKey	  = 12674;	//Mult default key
  AddKey	  = 35891;	//Add default key
 }
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey shr 8));
    StartKey := (Byte(Result[I]) + StartKey) * MultKey + AddKey;
  end;
end;
{*******************************************************
 * Standard Decryption algorithm - Copied from Borland *
 *******************************************************}
function Decrypt(const InString:string; StartKey,MultKey,AddKey:Integer): string;
var
  I : Byte;

begin
  {
  StartKey        = 981;  	//Start default key
  MultKey	  = 12674;	//Mult default key
  AddKey	  = 35891;	//Add default key
  }
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey shr 8));
    StartKey := (Byte(InString[I]) + StartKey) * MultKey + AddKey;
  end;
end;



{
Function Asrcr(RSA1:TRSA;pub,priv:TRSAKey;s:string):string;
  var i,k,il:Integer;
      buffer: array[0..1000] of char;
      OutBuf:Pointer;
      o:^TBigArray;
      ss,z:string;
begin
  ss:='';
  priv.m_16Bits:=2;
  priv.m_mod.FromStr(FloatTostr(prl));
  priv.m_a.FromStr(FloatTostr(prr));
  strpcopy(buffer,s);
  il := strlen(@buffer);
  RSA1.Encode(priv,@buffer,il,OutBuf,k);
  o:=OutBuf;
  for i:=1 to k do begin
   ss:=ss+IntTostr(o[i])+',';
  end;
  FreeMem(OutBuf);
  k:=Length(ss);
  ss:=Copy(ss,1,k-1);
  Result:=ss;
end;

Function Asrdcr(RSA1:TRSA;pub,priv:TRSAKey;s:string):string;
Var
i,k:Integer;
OutBuf:Pointer;
o:^TBigArray;
buffer: array[0..1000] of byte;
l,n:word;
il: Longint;
ss:string;
a:array[0..1000] of byte;
begin

  pub.m_16Bits:=2;
  pub.m_mod.FromStr(Floattostr(pul));
  pub.m_a.FromStr(Floattostr(pur));
  n:=Numtokennb(s);

  For i:=1 to n do begin
   a[i-1]:=StrToint(Tokennb(s,i));
  end;
  For i := 0 to n-1 do buffer[i] := a[i];
  il :=n;
  RSA1.Decode(pub,@buffer,il,OutBuf,k);
  o:=OutBuf;
  ss:='';
  For i:=1 to k do ss:=ss+Chr(o[i]);
  FreeMem(OutBuf);
  Result:=ss;
end;

}

function GetFileStamp(const path:string):string;
var
  sr: TSearchRec;
begin
  try
    FindFirst(path, faAnyFile, sr);
    Result := DateTimeToStr(FileDateToDateTime(sr.Time));
  finally
    FindClose(sr);
  end;
end;



function GetFileDateTime(const FileName : String) : TDateTime;
  var sr : TSearchRec;
begin
  Result := 0;
  if (FindFirst(FileName,faArchive,sr) = 0) then begin
    Result := FileDateToDateTime(sr.Time);
    FindClose(sr);
  end;  
end;

function BrowseCallbackProc(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
  result := 0;
end;

function BrowseForFolder(var Directory: string): Boolean;
var
  bi: TBrowseInfo;
  Res: array[0..MAX_PATH] of Char;
  pidl: PItemIDList;
begin
  Result := False;
  FillChar(bi, SizeOf(TBrowseInfo), 0);
  bi.hwndOwner := Application.Handle;
  bi.ulFlags := BIF_RETURNONLYFSDIRS;
  if DirectoryExists(Directory) then begin
    bi.lpfn := @BrowseCallbackProc;
    bi.lParam := Integer(PChar(Directory));
  end;
  pidl := SHBrowseForFolder(bi);
  if pidl <> nil then begin
    if SHGetPathFromIDList(pidl, Res) then begin
      Directory := Res;
      Result := True;
    end;
  end;
end;

Function Numtokencom(p:string):word;
Var
i,n,l:word;
begin
 n:=1;
 l:=Length(p);
 For i:=1 To l do begin
  if (p[i]=',') then begin
    n:=n+1;
   end;
 end;
 Result:=n;
end;

function Tokencom(p:string;n:word) : String;
  //var i,k,l : Word;
begin
  Result := Strf.ExtractStr(n,p,',');
end;


procedure GetChanges(OldList, NewList: TStrings; var Results: TResults);
var
  i, Len: Integer;
begin
  SetLength(Results, 0);
  if NewList is TStringList then
    TStringList(NewList).Sorted := True;
  if OldList is TStringList then
    TStringList(OldList).Sorted := True;

  for i:=0 to NewList.Count - 1 do begin
    if OldList.IndexOf(NewList[i]) = -1 then begin
      Len := Length(Results);
      SetLength(Results, Len + 1);
      Results[Len].Who := NewList[i];
      Results[Len].IsAdded := True;
    end;
  end;

  for i:=0 to OldList.Count - 1 do begin
    if NewList.IndexOf(OldList[i]) = -1 then begin
      Len := Length(Results);
      SetLength(Results, Len + 1);
      Results[Len].Who := OldList[i];
      Results[Len].IsAdded := False;
    end;
  end;
end;


Initialization
  prl:=8155452241.0;
  prr:=2108163483.0;
  pul:=8155452241.0;
  pur:=147.0;

end.
