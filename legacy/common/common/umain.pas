unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;


type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    lsb: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure  LOG(TXT:STRING);
    procedure Panel1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.LOG(TXT:STRING);
begin
     lsb.Items.Add(txt+' '+timetostr(time));
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
      log('privet ');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  s:string;
begin
      s:=datetimetostr(now);
      log(s)
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
       sysutils.ShortDateFormat:='yyyy-mm-dd';
       sysutils.longDateFormat :='yyyy-mm-dd';
       log('formcreate ok');

end;



end.

