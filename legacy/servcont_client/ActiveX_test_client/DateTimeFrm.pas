unit DateTimeFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfrmDateTime = class(TForm)
    DateTimePicker: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init(IsTime: Boolean);
    function GetDate(): string;
    function GetTime(): string;
  end;

{
var
  frmDateTime: TfrmDateTime;
}
implementation

{$R *.dfm}

{ TfrmDateTime }

function TfrmDateTime.GetDate: string;
var
  y, m, d: Word;
begin
  DecodeDate(DateTimePicker.Date, y, m, d);
  SetLength(Result, 3);
  Result[1] := Char(y - 2000);
  Result[2] := Char(m);
  Result[3] := Char(d);
end;

function TfrmDateTime.GetTime: string;
var
  h, n, s, ms: Word;
begin
  ms := 0;
  DecodeTime(DateTimePicker.Time, h, n, s, ms);
  SetLength(Result, 3);
  Result[1] := Char(h);
  Result[2] := Char(n);
  Result[3] := Char(s);
end;

procedure TfrmDateTime.Init(IsTime: Boolean);
begin
  if IsTime then begin
    DateTimePicker.Kind := dtkTime;
    Caption := 'Time';
  end else begin
    DateTimePicker.Kind := dtkDate;
    Caption := 'Date';
  end;
  DateTimePicker.DateTime := Now;
end;

end.
