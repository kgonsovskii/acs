unit uformimportff;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Forms, Controls, Graphics, Dialogs, CheckBoxThemed;

type

  { Tformimportff }

  Tformimportff = class(TForm)
    CheckBoxThemed1: TCheckBoxThemed;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  formimportff: Tformimportff;

implementation

{$R *.lfm}

{ Tformimportff }

procedure Tformimportff.FormCreate(Sender: TObject);
begin

end;

end.

