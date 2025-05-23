unit uvdtmenu;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  laz.virtualtrees,umain, Menus;

type

  { Tformvdtmenu }

  Tformvdtmenu = class(TForm)
    vstm: TLazVirtualStringTree;
    ToggleBox1: TToggleBox;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure vdtBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstmBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstmGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstmPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);

  private

  public

  end;

var
  formvdtmenu: Tformvdtmenu;

implementation

{$R *.lfm}
uses ualfunc;

{ Tformvdtmenu }

procedure Tformvdtmenu.ToggleBox1Change(Sender: TObject);
var
  ndn:pvirtualnode;
  d:pvstrecord;
begin
   ndn:=vstm.AddChild(nil); //.AddChild(nil);
   d:=vstm.GetNodeData(ndn);
   d^.nm1:=timetostr(time);
   d^.idxmenu:=-1;

  // ndn:=Vstm.InsertNode(Vstm.FocusedNode,amAddChildlast);
end;

procedure Tformvdtmenu.vdtBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
   Data: pvstrecord;
begin

    data:=vstm.GetNodeData(node);
    if (data^.foncol>0)  then begin
     TargetCanvas.Brush.Color :=data^.foncol;    // clskyblue;        //clblack;     //clskyblue;
     TargetCanvas.FillRect(CellRect);

    end;


end;

procedure Tformvdtmenu.vstmBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
   Data: pvstrecord;
begin
    data:=vstm.GetNodeData(node);
     TargetCanvas.Brush.Color := clskyblue;
     TargetCanvas.FillRect(CellRect);

   // end;


end;

procedure Tformvdtmenu.vstmGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);

var data : pvstrecord;
begin
    Data := Sender.GetNodeData(node);
    CellText := '';

    if column = 0 then begin
        CellText :=  data^.nm0;
    end;
     if column = 1 then begin
        CellText := data^.nm1;
    end;
      if column = 2 then begin
        CellText := data^.nm2;
    end;

end;

procedure Tformvdtmenu.vstmPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
data :pvstrecord;
rc:boolean;
begin
   exit;
   data:=vstm.GetNodeData(node);
  //if column=1 then begin
   if (data^.tag=-1)   then begin
   TargetCanvas.Font.Color :=cllime;   //   suda fontcolor
 end;
  if (data^.tag=1)   then begin
   //TargetCanvas.Font.Color :=clsilver;   //   suda fontcolor
 end;

 // if (data^.tag=4) and (data^.bploc>0) and checklinkbploc(data^.bploc)   then begin  //suda07
  //if data^.tag=4 then begin

   TargetCanvas.Font.Color :=clskyblue;
  //end;

end;


procedure Tformvdtmenu.FormCreate(Sender: TObject);
begin
       vstm.NodeDataSize := SizeOf(tpvstrecord);

end;

end.

