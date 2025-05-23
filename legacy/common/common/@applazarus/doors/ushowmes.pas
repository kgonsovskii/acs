unit ushowmes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { Tformshowmes }

  Tformshowmes = class(TForm)
    lekomu: TLabeledEdit;
    lekto: TLabeledEdit;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
   procedure  showmes(sl:tstringlist);
  private

  public

  end;

var
  formshowmes: Tformshowmes;

implementation

{$R *.lfm}

{ Tformshowmes }
procedure Tformshowmes.showmes(sl:tstringlist);
var
  i:integer;
  s:ansistring;
begin

      lekto.text:=sl.Values['cid'];
      memo1.Clear;
      for i:=0 to sl.Count -1 do begin
        s:=sl.Strings[i];
       // s:=system.UTF8Decode(s);
        s:= Utf8ToAnsi(s);
        memo1.Lines.Add(s);
      end;
end;

procedure Tformshowmes.FormCreate(Sender: TObject);
begin

end;

procedure Tformshowmes.Panel1Click(Sender: TObject);
begin

end;

end.

