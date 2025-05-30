unit UChannel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SIntProc2;

type
  TFormChannel = class(TForm)
    ChannelList: TListBox;
    BAddChannel: TButton;
    BDeleteChannel: TButton;
    BDeleteAllChannels: TButton;
    EChannel: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure BAddChannelClick(Sender: TObject);
    procedure BDeleteChannelClick(Sender: TObject);
    procedure BDeleteAllChannelsClick(Sender: TObject);
    function CheckChannel(S2 : string) : string;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormChannel: TFormChannel;
  ChFile : TextFile;

implementation

{$R *.DFM}

procedure TFormChannel.FormActivate(Sender: TObject);
begin

  if FileExists('Channels.txt') then ChannelList.Items.LoadFromFile('Channels.txt');

end;

procedure TFormChannel.BAddChannelClick(Sender: TObject);
var
  s:string;
begin
  if EChannel.Text <> '' then
   begin
    s:=Uppercase(EChannel.Text);
    if (CheckChannel(s) = 'IP') or (CheckChannel(s) = 'COM') then
     begin
      ChannelList.Items.Add(s);
     end
    else ShowMessage('Ошибка в описании канала');
   end;
  ChannelList.Items.SaveToFile('Channels.txt'); 
end;

procedure TFormChannel.BDeleteChannelClick(Sender: TObject);
var
 i : integer;
begin
  for i := ChannelList.Items.Count-1 downto 0 do
   begin
    if ChannelList.Selected[i] then
       ChannelList.Items.Delete(i);
   end;
  ChannelList.Items.SaveToFile('Channels.txt');
end;

procedure TFormChannel.BDeleteAllChannelsClick(Sender: TObject);
begin
  ChannelList.Items.Clear;
  ChannelList.Items.SaveToFile('Channels.txt');
end;

function TFormChannel.CheckChannel(S2 : string) : string;
var
  ComNum, S, S1 : string;
  i, k : integer;
begin
  Result := '';
 try
  S := S2;
  if Length(S) < 4 then exit;
  if AnsiUpperCase(Copy(S,1,3)) = 'COM' then
   begin
     ComNum := DCGetElement(S,1);
     ComNum := Copy(ComNum,4,Length(ComNum)-3);
     i := StrToInt(ComNum);
     ComNum := S+',';
     ComNum := DCGetElement(ComNum,2);
     i := StrToInt(ComNum);
     if (i <> 9600) and (i <> 9600) and (i <> 19200) and (i <> 38400) and
        (i <> 57600) and (i <> 115200) then exit;
     Result := 'COM';
   end
  else
   begin
    S1 := '';
    S := S + '.';
    for i := 1 to Length(S) do
     begin
      if (Ord(S[i]) >= $30) and (Ord(S[i]) <= $39) then S1 := S1 + S[i]
      else
       begin
        if S[i] <> '.' then exit;
        K := StrToInt(S1);
        S1 := '';
        if K > 255 then exit;
        Result := 'IP';
       end;
     end;
   end;
  except
   exit;
  end;
end;

procedure TFormChannel.FormCreate(Sender: TObject);
begin
  if FileExists('Channels.txt') then FormChannel.ChannelList.Items.LoadFromFile('Channels.txt');
end;

end.
