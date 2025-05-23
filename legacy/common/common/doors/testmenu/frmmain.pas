unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, LCLType;

type

  { TfmMain }

  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem1_1: TMenuItem;
    MenuItem1_2: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem2_1: TMenuItem;
    MenuItem2_2: TMenuItem;
    procedure MenuItem1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure MenuItem1_1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure MenuItem1_2DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure MenuItem2DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
  private
    procedure doMIClr(ACanvas: TCanvas; ARect: TRect; sTxt: String);

  public

  end;

var
  fmMain: TfmMain;

implementation

{$R *.lfm}

{ TfmMain }

procedure TfmMain.doMIClr(ACanvas: TCanvas; ARect: TRect; sTxt: String);
begin
  ACanvas.FillRect(ARect);
  ACanvas.TextOut(ARect.Left, ARect.Top, sTxt);
end;

procedure TfmMain.MenuItem1DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin
  with ACanvas do begin
    Brush.Color := clBlack;
    Font.Color := clYellow;
    Font.Style := [fsBold];
  end;
  doMIClr(ACanvas,ARect,'MI-1');
end;

procedure TfmMain.MenuItem1_1DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin
  with ACanvas do begin
    Brush.Color := clPurple;
    Font.Color := clLime;
    Font.Style := [fsUnderline];
    Font.Name:='Arial Black';
  end;
  doMIClr(ACanvas,ARect,'MI-1.1');
end;

procedure TfmMain.MenuItem1_2DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin
  with ACanvas do begin
    Brush.Color := clGreen;
    Font.Color := clWhite;
    Font.Style := [fsStrikeOut,fsItalic];
    Font.Name:='Courier New';
  end;
  doMIClr(ACanvas,ARect,'MI-1.2');
end;

procedure TfmMain.MenuItem2DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin
  with ACanvas do begin
    Brush.Color := clRed;
    Font.Color := clAqua;
    Font.Style := [fsItalic];
  end;
  doMIClr(ACanvas,ARect,'MI-2');
end;

end.

