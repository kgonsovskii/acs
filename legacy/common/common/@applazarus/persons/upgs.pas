unit upgs;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, PQConnection, SQLDB, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { Tformpgs }

  Tformpgs = class(TForm)
    elink: TEdit;
    pgc1: TPQConnection;
    qrs: TSQLQuery;
    trc1: TSQLTransaction;
    procedure elinkChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure connect;
    procedure pgc1AfterConnect(Sender: TObject);
    //function  getqr(line:string):TSQLQuery;
    procedure pgc1AfterDisconnect(Sender: TObject);
    procedure pgc1Log(Sender: TSQLConnection; EventType: TDBEventType;
      const Msg: String);

  private

  public

  end;

var
  formpgs: Tformpgs;

implementation

{$R *.lfm}
uses umain;

{ Tformpgs }
{
function Tformpgs.getqr(line:string):TSQLQuery;
begin

       qrs.DataBase:=pgc1;
        qrs.Transaction:=trc1;
         pgc1.Open;
        qrs.SQL.Clear;
        qrs.SQL.add(line);
        qrs.Active:=true;
        form1.log('c','getqr line='+line);
        form1.log('c','getqr rc='+inttostr(qrs.RecordCount));
        //showmessage('getqr rc=='+inttostr(qrs.RecordCount));
        result:=qrs;
end;
}
procedure Tformpgs.pgc1AfterDisconnect(Sender: TObject);
begin
   form1.pgsconnect('disconnect');
end;

procedure Tformpgs.pgc1Log(Sender: TSQLConnection; EventType: TDBEventType;
  const Msg: String);
begin
      form1.log('w','pgc1Log='+msg);
end;

procedure Tformpgs.connect;
var
  xx:integer;
begin
      pgc1.HostName:=mysysinfo.baseaddr;

      pgc1.DatabaseName:=mysysinfo.basename;
      //showmessage('xgconnect BEFORE hostname='+pgc1.HostName);
      pgc1.Password:=mysysinfo.basepsw;
      pgc1.UserName:=mysysinfo.username;
      pgc1.CharSet:='utf-8';
      form1.log('y','formpgs.connect dbn='+mysysinfo.basename+'  baseaddr='+mysysinfo.baseaddr+zp+' psw='+mysysinfo.basepsw+'>');
      pgc1.Connected:=true;

end;

procedure Tformpgs.pgc1AfterConnect(Sender: TObject);
begin
      form1.pgsconnect('connect');
end;

procedure Tformpgs.FormCreate(Sender: TObject);
begin

end;

procedure Tformpgs.elinkChange(Sender: TObject);
begin
       form1.log('y','elinkchange='+elink.text);
end;

end.

