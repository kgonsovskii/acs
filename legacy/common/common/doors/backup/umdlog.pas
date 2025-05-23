unit umdlog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, DBGrids,
  Grids, Menus;

type

  { Tformmdlog }

  Tformmdlog = class(TForm)
    MenuItem1: TMenuItem;
    pop1: TPopupMenu;
    sg: TStringGrid;

    procedure FormCreate(Sender: TObject);
   procedure  log(pr,txt:string);
   procedure  crlog;
   procedure MenuItem1Click(Sender: TObject);
   procedure sgPrepareCanvas(sender: TObject; aCol, aRow: Integer;
     aState: TGridDrawState);
   procedure  totextlog(txt:string);
  private


  public

  end;

var
  formmdlog: Tformmdlog;
    fnx:string;

implementation

{$R *.lfm}
uses umain,ulazfunc;

{ Tformmdlog }

procedure  Tformmdlog.crlog;
var
  d,mdir,sep:string;
  fOut: TextFile;
begin

     sep:=umain.mysysinfo.sep;
      d:=dmfunc.ZZdate(datetostr(now));
      mdir:=appdir+'redlog';
      CreateDir (mdir);
      mdir:=mdir+sep+d;
      fnx:=mdir+sep+app+'.log';
      //log('y','mdir='+mdir);
      CreateDir (mdir);
      if not fileexists(fnx) then begin
       AssignFile(fOut, fnx);
       REWRITE(fOut);
       CloseFile(fOut);
      end;

  end;

procedure Tformmdlog.MenuItem1Click(Sender: TObject);
begin
     log('l',timetostr(time));
end;

procedure Tformmdlog.sgPrepareCanvas(sender: TObject; aCol, aRow: Integer;
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

procedure Tformmdlog.totextlog(txt:string);
var
cd,d,mdir:string;
fOut: TextFile;
begin
      crlog;
      AssignFile(fOut, fnx);
      append(fOut);
      cd:=datetimetostr(now);
      writeln(fOut,cd+' /  '+txt);
      CloseFile(fOut);



end;

procedure Tformmdlog.log(pr,txt:string);
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
    if sg.RowCount>1000 then sg.clear;
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




procedure Tformmdlog.FormCreate(Sender: TObject);
begin

end;





end.

