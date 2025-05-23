unit uallog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, Menus;

type

  { Tformallog }

  Tformallog = class(TForm)
    MenuItem1: TMenuItem;
    pop1: TPopupMenu;
    sg: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure log(pr,txt:string);
    procedure MenuItem1Click(Sender: TObject);
    procedure sgPrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure totextlog(txt:string);
    procedure crlog;
  private

  public

  end;

var
  formallog: Tformallog;
   fOut: TextFile;
   fnx:string;

implementation

{$R *.lfm}
uses ualfunc,umain;

{ Tformallog }

procedure  Tformallog.crlog;
var
  d,mdir:string;


begin
      exit;
{
      d:=ualfunc.ZZdate(datetostr(now));

      mdir:=appdir+'redlog';
      CreateDir (mdir);
      mdir:=mdir+'\'+d;
      fnx:=mdir+'\'+app+'.log';
      //log('y','mdir='+mdir);
      CreateDir (mdir);
      if not fileexists(fnx) then begin
       AssignFile(fOut, fnx);
       REWRITE(fOut);
       CloseFile(fOut);
      end;
}
  end;

procedure Tformallog.totextlog(txt:string);
var
cd,d,mdir:string;
fOut: TextFile;
begin
      if flagexit then exit;
      crlog;
      AssignFile(fOut, fnx);
      append(fOut);
      cd:=datetimetostr(now);
      writeln(fOut,cd+' /  '+txt);
      CloseFile(fOut);

 end;

procedure tformallog.log(pr,txt:string);
var
row:integer;
x, y, w: integer;
s: string;
MaxWidth: integer;
begin
 // form1.Caption:='Tformmdlog= '+timetostr(time);
     if pr='r' then   totextlog(txt);
     with sg do
    ClientHeight := DefaultRowHeight * RowCount + 5;
    with sg do
    begin
     txt:=txt+'   ';
     for x := 0 to ColCount - 1 do
      begin
        MaxWidth := 0;
        for y := 0 to RowCount - 1 do
        begin
          w := Canvas.TextWidth(Cells[x,y]);
          if w > MaxWidth then
            MaxWidth := w;
        end;
        ColWidths[x] := MaxWidth + 5;
      end;
    end;

    if trim(txt)='' then exit;
    if sg.RowCount>500 then sg.clear;
    if pr='w'then sg.Canvas.Font.Color :=  clwhite;
     row := sg.RowCount;
     sg.RowCount:=sg.RowCount+1;
     sg.Cells[0,row]:=inttostr(row)+'   '+timetostr(time)+' ';
     sg.Cells[1,row]:=pr;
     sg.Cells[2,row]:=txt;
     //sg.RowCount:=sg.RowCount+1;
     if pr='w'then sg.Canvas.Font.Color :=  clwhite;
     sg.TopRow:=Sg.RowCount-sg.VisibleRowCount;

end;

procedure Tformallog.MenuItem1Click(Sender: TObject);
begin
  sg.clear;
end;

procedure Tformallog.sgPrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
begin
   if (Sender as TStringGrid).Cells[1, aRow] = 'e' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=  clred;
    end;
      if (Sender as TStringGrid).Cells[1, aRow] = 's' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=  clskyblue;
    end;


    if (Sender as TStringGrid).Cells[1, aRow] = 'r' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=  clred;
    end;
    if (Sender as TStringGrid).Cells[1, aRow] = 'w' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=  clwhite;
    end;
    if (Sender as TStringGrid).Cells[1, aRow] = 'l' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=  cllime;
    end;
    if (Sender as TStringGrid).Cells[1, aRow] = 'c' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=  claqua;
    end;
    if (Sender as TStringGrid).Cells[1, aRow] = 'y' then begin
     (Sender as TStringGrid).Canvas.Font.Color :=  clyellow;
    end;
    if (Sender as TStringGrid).Cells[1, aRow] = 'b' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=clblue;
    end;
    if (Sender as TStringGrid).Cells[1, aRow] = 'm' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=clpurple;
    end;
    if (Sender as TStringGrid).Cells[1, aRow] = 'g' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=clgray;
    end;
     if (Sender as TStringGrid).Cells[1, aRow] = 's' then begin
    (Sender as TStringGrid).Canvas.Font.Color :=clsilver;
    end;


end;






procedure Tformallog.FormCreate(Sender: TObject);
begin
   // sg.Columns[2].Width:=300;
    //sg.Font.Color:=clwhite;
end;

end.

