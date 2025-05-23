unit ulazfunc;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { Tdmfunc }

  Tdmfunc = class(TForm)
    procedure FormCreate(Sender: TObject);
    function  ExtractStr(Num:Integer; const s:String; const DelimStr:String):String;
    procedure MyDelay(DelayTickCount: DWORD);
    Function  ZZdate(d:string):string;
   function   Azerol(s:String; n:integer):String;

  private

  public

  end;

var
  dmfunc: Tdmfunc;

implementation

{$R *.lfm}

{ Tdmfunc }


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

