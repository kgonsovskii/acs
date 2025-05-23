unit ualfunc;

{$mode ObjFPC}{$H+}

interface

function   ExtractStr(Num:Integer; const s:String; const DelimStr:String):String;
Function   ZZdate(d:string):string;
function   Azerol(s:String; n:integer):String;
procedure  MyDelay(DelayTickCount: DWORD);
function   Trim(s:String):String;
function   LTrim(s:String):String;
function   RTrim(s:String):String;
function   vagoloapprun(line:string):string;
function   xkeytos(x:integer):string;
function   keytox(kl:string):int64;



implementation
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Unix,
   SQLite3Conn, SQLDB,base64,umain;



function ExtractStr(Num:Integer; const s:String; const DelimStr:String):String;
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




function CountChar(c:Char;s:String):Integer;
  var i:Integer;
begin
  Result:=0;
  if (Length(s)=0) then Exit;
  for i:=1 to Length(s) do if (s[i]=c) then Inc(Result);
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




function keytox(kl:string):int64;
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



function xkeytos(x:integer):string;
begin
     try
       result:=sysutils.inttohex(x,12);
      except
          on ee : Exception do begin
          // form1.log('e','xkeytos,ee= '+ee.Message);
          end;
       end;


end;



function vagoloapprun(line:string):string;
begin

 // result:=inttostr(fpsystem('aplay /home/astra/common/doors/alpy/wav/prolog.wav &'));
   result:=inttostr(fpsystem(line));
    // sample
    // line='aplay /home/astra/common/doors/alpy/wav/prolog.wav &'
    //return ok or errormessage
end;




function Trim(s:String):String;
begin
  Result:=LTrim(RTrim(s));
end;





procedure MyDelay(DelayTickCount: DWORD);
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




function Azerol(s:String; n:integer):String;
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


Function ZZdate(d:string):string;
var
day,month,y,dd,s:string;
n:integer;
begin

   s := FormatDateTime('yyyy-mm-dd, hh:nn:ss', now);
  // showmessage('zzdate s='+s);
   result:= ualfunc.ExtractStr(1,s,',');
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



end.

