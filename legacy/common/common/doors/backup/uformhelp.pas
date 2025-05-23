unit uformhelp;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tforhelp }

  Tforhelp = class(TForm)
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  forhelp: Tforhelp;

implementation

{$R *.lfm}

{ Tforhelp }

procedure Tforhelp.FormCreate(Sender: TObject);
begin

end;

end.

