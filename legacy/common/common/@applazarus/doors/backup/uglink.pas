unit uglink;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, PQConnection, Forms, Controls, Graphics, Dialogs
  ;

type tglink  =record
      currn  :int64;
      t1     :qword;
      t2     :qword;
      d      :qword;
      kto    :string;
      alias  :string;
      rc     :integer;
      idoper :integer;
      state  :string;
      sqline :string;
      erm    : string;
      qrx    : TSQLQuery ;
      sl   :tstringlist;
    end;
  type tgnotch  =record
     name     :string;
     count     :qword;
     currv     :integer;
     avgv      :qword;
     summa     :qword;
     slin      :tstringlist;
     end;
 type tmyrcdb  =record
      fullmess  :string;
      rusmes    :string;
      rc        :string;
     end;

type tmystamp  =record
      full   :string;
      ms     :string;
     end;



type

  { Tformglink }

  Tformglink = class(TForm)
    pqc1: TPQConnection;
    qrx: TSQLQuery;
    tr1: TSQLTransaction;
    procedure FormCreate(Sender: TObject);
    procedure pqc1AfterConnect(Sender: TObject);
    procedure pqc1AfterDisconnect(Sender: TObject);
    procedure pqc1Log(Sender: TSQLConnection; EventType: TDBEventType;
      const Msg: String);
    function  xgconnect(vglink:tglink):tglink;
    procedure log(pr,txt:string);
    function  gsel(line:string):boolean;
    function  gselqr(line:string):TSQLQuery;


  private

  public

  end;

var
  formglink: Tformglink;

implementation

{$R *.lfm}
uses umain,ualfunc;

{ Tformglink }


function Tformglink.gselqr(line:string):TSQLQuery;
var
ap,s:string;
qrz: TSQLQuery;
rc:boolean;
begin
      try
      //  log('y','gselqr='+line);
        qrz:=TSQLQuery.Create(self);
        qrz.DataBase:=pqc1;
        qrz.SQL.clear;
        qrz.SQL.Add(line);
        qrz.Active:=true;
        vglink.qrx:=qrz;
        result:=qrz;
        //log('y','AFTER gselqr='+line);
      except
      on ee:exception DO BEGIN
       log('e','gseLQR ,ee='+ee.Message);

     end;
    end;


end;



function Tformglink.gsel(line:string):boolean;
var
ap,s:string;
qrz: TSQLQuery;
rc:boolean;
begin
      try
        log('y','gsel='+line);
        qrz:=TSQLQuery.Create(self);
        qrz.DataBase:=pqc1;
        qrz.SQL.clear;
        qrz.SQL.Add(line);
        qrz.Active:=true;
        vglink.qrx:=qrz;
        rc:=true;
       // qrz.Close;

      except
      on ee:exception DO BEGIN
       log('e','gsel ,ee='+ee.Message);
       vglink.rc:=-1;
       vglink.erm:=ee.Message;
       rc:=false;
     end;
    end;


end;




function Tformglink.xgconnect(vglink:tglink):tglink;
var
  sl:tstringlist;
begin
    try
    //showmessage(' CALL XGCONNECT ');
       pqc1.HostName:=mysysinfo.baseaddr;
       pqc1.DatabaseName:=mysysinfo.basename;
       pqc1.Password:=mysysinfo.basepsw;
       pqc1.Connected:=true;
       vglink.rc:=0;
       vglink.erm:='ok';
       vglink.state:='open';
       vglink.currn:=0;
         log('y','XGONNECT END EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ;
    except
     on ee:exception DO BEGIN
     log('e','xgconnect ,ee='+ee.Message);
     vglink.rc:=-1;
     vglink.erm:=ee.Message;
     vglink.state:='error';
     showmessage('formglink.xgconnect ee='+ee.Message);
     end;
    end;

    result:=vglink;

end;
procedure Tformglink.log(pr,txt:string);
begin
       form1.log(pr,txt);
end;

procedure Tformglink.FormCreate(Sender: TObject);
begin

end;

procedure Tformglink.pqc1AfterConnect(Sender: TObject);
begin
         umain.slappstatus.Add('pgconnect');


end;

procedure Tformglink.pqc1AfterDisconnect(Sender: TObject);
begin
   umain.slappstatus.Add('pgdisconnect');
end;

procedure Tformglink.pqc1Log(Sender: TSQLConnection; EventType: TDBEventType;
  const Msg: String);
begin
    //  log('pqc1Log','msg='+msg);
end;

end.

