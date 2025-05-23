unit ueditnewshab;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls, Types;

type

  { Tformeditnewshab }

  Tformeditnewshab = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
   procedure prepare(tbl,ttg:string;myid:integer);

  private

  public

  end;

var
  formeditnewshab: Tformeditnewshab;

implementation

{$R *.lfm}

{ Tformeditnewshab }

procedure Tformeditnewshab.prepare(tbl,ttg:string;myid:integer);
begin
      //showmessage('prepare')
end;

procedure Tformeditnewshab.TabSheet2ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

end.

