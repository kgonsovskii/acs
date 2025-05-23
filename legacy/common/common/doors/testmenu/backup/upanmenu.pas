unit upanmenu;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,UMAIN,UALFUNC;

type

  { Tformpanmenu }

  Tformpanmenu = class(TForm)
    p_05: TPanel;
    p_04: TPanel;
    p_03: TPanel;
    p_02: TPanel;
    p_10: TPanel;
    p_06: TPanel;
    p_07: TPanel;
    p_08: TPanel;
    p_09: TPanel;
    panlb: TPanel;
    p_01: TPanel;
    procedure p_01Click(Sender: TObject);
    function  mmpan(nm,nmsens:string):integer;
    procedure prepare1;
  private

  public

  end;

var
  formpanmenu: Tformpanmenu;
  rcc:integer;

implementation

{$R *.lfm}

{ Tformpanmenu }

procedure  Tformpanmenu.prepare1;
var
i,l:integer;
s,txt,min,max,nmc:string;
sl:tstringlist;
p:tpanel;
begin
     sl:=tstringlist.Create;
     for i:=1 to 9 do begin
     s:=inttostr(i);
     s:=ualfunc.Azerol(s,2);
     nmc:='p_'+s;
     p:=formpanmenu.findcomponent(nmc) as tpanel;
     s:=trim(p.Caption);
     txt:=s;
     l:=length(s);
     s:=inttostr(l);
     s:=ualfunc.Azerol(s,3);
     sl.Add(s);
     form1.log('r','txt='+txt+' /lengh='+s);
    end;
    sl.Sort;
    l:=sl.Count;
    min:=sl[0];
    max:=sl[l-1];
    formpanmenu.Width:=strtoint(max)*8+20;
    form1.log('r','min='+min+' / max='+max+' /width='+inttostr(formpanmenu.Width));


end;

function  Tformpanmenu.mmpan(nm,nmsens:string):integer;
var
  i:integer;
  nmc,s:string;
  p:tpanel;
begin
     formpanmenu.Left:=0;
    formpanmenu.BringToFront;


    rcc:=-1;
    show;
    //panlb.Font.Color:=clyellow;
    panlb.Caption:='МЕНЮ  для сенсора ='+nmsens;
    form1.log('l','mmpan.nm='+nm+zp+'nmsens='+nmsens);

     case NM of

      'lt2'  : begin
           panlb.Caption:='МЕНЮ  для локации ='+nmsens;
           form1.log('l','mmpan.nm='+nm+zp+'nmsens='+nmsens);

           p_01.Caption:=' y1. РЕДАКТОР';                        p_01.Visible:=true;
           p_02.Caption:=' 2. Включить режим конфигурации';     p_02.Visible:=true;
           p_03.Caption:=' 3. Добавить локацию';                p_03.Visible:=true;
           p_04.Caption:=' 4. Изменить локацию';                p_04.Visible:=true;
           p_05.Caption:='y 5. Добавить  группу сенсоров';       p_05.Visible:=true;
           p_06.Caption:='y 6. Прочитать группы сенсоров';       p_06.Visible:=true;
           p_07.Caption:='y 7. Добавить сенсор';                 p_07.Visible:=true;
           p_08.Caption:=' 8. Удалить локацию';                 p_08.Visible:=true;
           p_08.Color:=clred;
           p_08.Font.Color:=clblack;
           p_08.Font.Size:=12;
          form1.log('l','???? mmpan.nm='+nm);
         // p_09.Caption:='A01234567777777777777777777777777F'; p_09.Visible:=true;
        //  prepare1;
      end;



      'ltm5'  : begin
           panlb.Caption:='МЕНЮ  для сенсора ='+nmsens;
           form1.log('l','mmpan.nm='+nm+zp+'nmsens='+nmsens);

           p_01.Caption:=' 1. РЕДАКТОР';                        p_01.Visible:=true;
           p_02.Caption:=' 2. Связать с сенсором контроллера';  p_02.Visible:=true;
           p_03.Caption:=' 3. Эмуляция события';                p_03.Visible:=true;
           p_04.Caption:=' 4. Показать только один сенсор';     p_04.Visible:=true;
          form1.log('l','???? mmpan.nm='+nm);
      end;

     end;
     prepare1;
     for i:=1 to 10 do begin
      caption:=inttostr(i);
      application.ProcessMessages;
      ualfunc.MyDelay(1000);
      if rcc<>-1 then break;
     end;
     result:=rcc;
     p_10.Caption:='ВЫХОД';


end;

procedure Tformpanmenu.p_01Click(Sender: TObject);
var
p:tpanel;
cl:int64;
i,rc:integer;
f:boolean;
nm,s:string;
begin

    f:=false;
    p:=sender as tpanel;
    cl:=p.color;
    nm:=p.Name;
    if nm='p_10' then close;

    s:=ualfunc.ExtractStr(2,nm,'_');
    rcc:=strtoint(s);
    p.Color:=clskyblue;
    p.BevelInner:=bvlowered;
    close;
    ualfunc.MyDelay(200);
    p.BevelInner:=bvraised;
    p.BevelOuter:=bvraised;
    p.Color:=cl;
    exit;




end;

end.

