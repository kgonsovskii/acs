unit URelay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, SIntProc2;

type
  TFRelay = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Label1: TLabel;
    Edit1: TMaskEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  
var
  FRelay: TFRelay;

implementation
uses UNTest;

{$R *.DFM}

procedure TFRelay.Button1Click(Sender: TObject);
var
 S : string;
begin

  S := Edit1.Text;
  if Pos(S,' ') = 1 then S := Copy(Edit1.Text,2,1);
  if Pos(S
  ,' ') = 2 then S := Copy(Edit1.Text,1,1);
  if StrToInt(S)>31 then S := '31';

  Cnt.RelayON(StrToInt(Form1.BoxCntr.Text),(Sender as TButton).Tag,StrToInt(S));
  
end;

procedure TFRelay.Button9Click(Sender: TObject);
var
 S : string;
begin
  Cnt.RelayOFF(StrToInt(Form1.BoxCntr.Text),1);
  Cnt.RelayOFF(StrToInt(Form1.BoxCntr.Text),2);
  Cnt.RelayOFF(StrToInt(Form1.BoxCntr.Text),3);
  Cnt.RelayOFF(StrToInt(Form1.BoxCntr.Text),4);
  Cnt.RelayOFF(StrToInt(Form1.BoxCntr.Text),5);
  Cnt.RelayOFF(StrToInt(Form1.BoxCntr.Text),6);
  Cnt.RelayOFF(StrToInt(Form1.BoxCntr.Text),7);
  Cnt.RelayOFF(StrToInt(Form1.BoxCntr.Text),8);
end;

end.
