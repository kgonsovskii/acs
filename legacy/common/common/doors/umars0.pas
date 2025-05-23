unit umars0;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;


type

  { Tformmars0 }

  Tformmars0 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  formmars0: Tformmars0;

implementation

{$R *.lfm}
uses umain,umdlog,ulazfunc,uglink;

{ Tformmars0 }

procedure Tformmars0.FormCreate(Sender: TObject);
begin


  // vstmars.NodeDataSize := SizeOf(tpvstrecordloc);
  // VSTmars.TreeOptions.MiscOptions := VSTmars.TreeOptions.MiscOptions+[toCheckSupport];
  // VSTmars.TreeOptions.MiscOptions := form1.VST.TreeOptions.MiscOptions+[toCheckSupport];
end;

end.

