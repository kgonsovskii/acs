unit ChannelsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls;

type
  TfrmChannels = class(TForm)
    Panel1: TPanel;
    sgdChannels: TStringGrid;
    cbxChannels: TComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbxChannelsChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  frmChannels: TfrmChannels;}

implementation

uses
  TSSServContAPI;

{$R *.dfm}

procedure TfrmChannels.FormCreate(Sender: TObject);
begin
  with sgdChannels do begin
    Cells[0,0] := 'Key';
    Cells[1,0] := 'Value';
    Cells[0, 1] := 'IsActive';
    Cells[0, 2] := 'IsReady';
    Cells[0, 3] := 'IsIP';
    Cells[0, 4] := 'PortOrHost';
    Cells[0, 5] := 'SpeedOrPort';
    Cells[0, 6] := 'ResponseTimeout';
    Cells[0, 7] := 'AliveTimeout';
    Cells[0, 8] := 'DeadTimeout';
    Cells[0, 9] := 'PollSpeed';
  end;
end;

procedure TfrmChannels.cbxChannelsChange(Sender: TObject);
var
  psc: PServcontChannel;
begin
  with TComboBox(Sender) do
    psc := PServcontChannel(Items.Objects[ItemIndex]);
  with sgdChannels, psc^ do begin
    Cells[1, 1] := BoolToStr(IsActive, True);
    Cells[1, 2] := BoolToStr(IsReady, True);
    Cells[1, 3] := BoolToStr(IsIP, True);
    Cells[1, 4] := PortOrHost;
    Cells[1, 5] := IntToStr(SpeedOrPort);
    Cells[1, 6] := IntToStr(ResponseTimeout);
    Cells[1, 7] := IntToStr(AliveTimeout);
    Cells[1, 8] := IntToStr(DeadTimeout);
    Cells[1, 9] := IntToStr(PollSpeed);
  end;
end;

end.
