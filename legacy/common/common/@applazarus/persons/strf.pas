unit StrF;
{$LONGSTRINGS ON}
  interface

    const TabChar = #9;

    function CountChar(c:Char;s:String):Integer;
    function DeleteChar(s:String; c:Char):String;
    function ReplaceText(s, SourceText, DestText: String):String;
    function LTrim(s:String):String;
    function RTrim(s:String):String;
    function Trim(s:String):String;
    function Ansi2Oem(AnsiStr:String):String;
    function Oem2Ansi(OemStr:String):String;
    function ExtractStr(Num:Integer; const s:String; const DelimStr:String):String;
    function Win2Dos(const S:String):String;
    function Dos2Win(const S:String):String;
    function DeleteFirstChar(const s:String; c:Char):String;
    function ExtractUNCResourceName(const S : String) : String;

  implementation

uses Windows, SysUtils;

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

function Dos2Win(const S:String):String;
var
  i: Word;
begin
  Result := S;
  for i := 1 to Length(S) do case Ord(S[i]) of
    128..175: Result[i] := chr(ord(S[i]) + 64);
    224..239: Result[i] := chr(ord(S[i]) + 16);
         240: Result[i] := chr(ord(S[i]) - 72);
         241: Result[i] := chr(ord(S[i]) - 57);
  end;
end;

function Win2Dos(const S:String):String;
var
  i: Word;
begin
  Result := S;
  for i := 1 to Length(S) do case Ord(S[i]) of
    192..239: Result[i] := chr(ord(S[i]) - 64);
    240..255: Result[i] := chr(ord(S[i]) - 16);
         168: Result[i] := chr(ord(S[i]) + 72);
         184: Result[i] := chr(ord(S[i]) + 57);
  end;
end;

function DeleteFirstChar(const s:String; c:Char):String;
  var i : Integer;
begin
  Result:=s;
  i := Pos(c,s);
  if (i > 0) then System.Delete(Result,i,1);
end;

function ExtractUNCResourceName(const S : String) : String;
  var i,c : Integer;
begin
  Result := '';
  c := 0;
  for i := 1 to Length(S) do begin
    if (S[i] = '\') then Inc(c);
    if (c = 4) then begin
      Result := System.Copy(S, 1, i - 1);
      Exit;
    end;
  end;
end;


end.