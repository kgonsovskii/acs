unit ulazfunc;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,base64,crc;

type

  { Tdmfunc }

  Tdmfunc = class(TForm)
    procedure FormCreate(Sender: TObject);
    function  ExtractStr(Num:Integer; const s:String; const DelimStr:String):String;
    procedure MyDelay(DelayTickCount: DWORD);
    Function  ZZdate(d:string):string;
   function   Azerol(s:String; n:integer):String;
   function  Replt(s, SourceText, DestText:String):String;
   function  deleteda(p:string):string;
   function  xkeytos(x:integer):string;
   function  skeytox(kl:string):int64;
   function  CountChar(c:Char;s:String):Integer;
   function  mycrypt(s:string):string;
   function  mydecrypt(s:string):string;
   function  crc32(p:string):longword;



  private

  public

  end;

var
  dmfunc: Tdmfunc;

implementation

{$R *.lfm}

{ Tdmfunc }
function tdmfunc.crc32(p:string):longword;
var
  crcvalue,lwCRC: longword;
  sTxt: String;
begin
  //ShowMessage('OK');
  //sTxt:= 'Simple Text!';
  sTxt:=Trim(p);
  crcvalue := crc.crc32(0,nil,0);
  //result := crc32(crcvalue, @mystring[1], length(mystring));
  lwCRC := crc.crc32(crcvalue, @sTxt[1], length(sTxt));
  result:=lwcrc;
  //ShowMessage(sTxt+' => '+IntToStr(lwCRC));
end;




  function tdmfunc.CountChar(c:Char;s:String):Integer;
  var i:Integer;
begin
  Result:=0;
  if (Length(s)=0) then Exit;
  for i:=1 to Length(s) do if (s[i]=c) then Inc(Result);
end;




function tdmfunc.skeytox(kl:string):int64;
var
 HexStr:string;
 Value:int64;
begin
 try
  result:=0;
  HexStr:=kl;
  Value := StrToInt64('$' + kl);
  result:= value
 except
   result:=0;
 end;
end;



function tdmfunc.mydecrypt(s:string):string;
begin
     result:=base64.DecodeStringBase64(s);

end;


function tdmfunc.mycrypt(s:string):string;
begin
      result:=base64.EncodeStringBase64(s);

end;

function tdmfunc.xkeytos(x:integer):string;
begin
     try
       result:=sysutils.inttohex(x,12);
      except
          on ee : Exception do begin
           //form1.log('e','xkeytos,ee= '+ee.Message);
          end;
       end;


end;


function tdmfunc.deleteda(p:string):string;
var
a,d:char;
da:string;
begin
        d:=chr(13);
        a:=chr(10);
        da:=d+a;
        result:=StringReplace(p, da, '',[rfIgnoreCase, rfReplaceAll]);
end;


function tdmfunc.Replt(s, SourceText, DestText:String):String;
  var st,res,rpt:string;
      i:Integer;
begin
  rpt:='';
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
  result:=res+st;
  //ReplaceText:=res;
end;


function tdmfunc.Azerol(s:String; n:integer):String;
var
  i,l:integer;

begin
  S := Trim(S);
  l:=Length(s);
  For i:=l To n-1 do begin
   s:='0'+s;
  end;
  Result := S;
end;


Function Tdmfunc.ZZdate(d:string):string;
var
day,month,y,dd,s:string;
n:integer;
begin

   s := FormatDateTime('yyyy-mm-dd, hh:nn:ss', now);
  // showmessage('zzdate s='+s);
   result:= dmfunc.ExtractStr(1,s,',');
    // showmessage('zzdate result='+result);
   exit;

   dd:=datetostr(date);
   //showmessage('zzdate d='+d+'> dd='+dd);
   day:=Copy(d,1,2) ;
   month:=Copy(d,4,2);
   y:=Copy(d,7,4);
  // showmessage('y='+y+'>');
   day:=azerol(day,2);
   month:=azerol(month,2);
   n:=strtoint(y);
   n:=n+2000;
   y:=inttostr(n);
   //showmessage('zzdate d='+d);
   y:=inttostr(n);
   Result:=y+'-'+month+'-'+day;

end;


procedure tdmfunc.MyDelay(DelayTickCount: DWORD);
  var
    StartTickCount,n : DWORD;
    r:real;
  begin
  // n:=floattoineger(DelayTickCount);
   //n:=r*0.9;
    StartTickCount := GetTickCount;
    while (GetTickCount < StartTickCount + DelayTickCount) and (not Application.Terminated) do
      Application.ProcessMessages;
  end;


function tdmfunc.ExtractStr(Num:Integer; const s:String; const DelimStr:String):String;
  var st,res:String;
      i,n:Integer;
begin
  Result:='';
  res:='';
  n:=0;
  st:=s;
  while ((n<Num) and (st<>'')) do begin
    i:=Pos(DelimStr,st);
    if (i=0) then i:=Length(st)+1;
    res:=System.Copy(st,1,i-1);
    if st='' then res:='';
    System.Delete(st,1,i);
    Inc(n);
  end;
  if (n < Num) and  (st='') then res:='';
  Result:=res;
end;


procedure Tdmfunc.FormCreate(Sender: TObject);
begin
 //
end;

end.

