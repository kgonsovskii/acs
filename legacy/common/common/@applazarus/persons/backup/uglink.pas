unit uglink;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, PQConnection, Forms, Controls, Graphics, Dialogs;


type tmysysinfo  =record
      mode         :string;   // work or config
      computername :string;
      trclientid   :string;
      ip           :string;
      os           :string;
      username     :string;
      sep          :string;
      traddr       :string;
      baseaddr     :string;
      basename     :string;
      basepsw      :string;
     end;


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
   // pqm: TPQTEventMonitor;
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
uses ualfunc,umain;

{ Tformglink }


function Tformglink.gselqr(line:string):TSQLQuery;
var
ap,s:string;
qrz: TSQLQuery;
rc:boolean;
begin
      try

        showmessage('gselqr')  ;
        qrz:=TSQLQuery.Create(self);
        qrz.DataBase:=pqc1;
        qrz.SQL.clear;
        qrz.SQL.Add(line);
        qrz.Active:=true;
       // umain.vglink.qrx:=qrz;
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
qrz: TSQLQuery;                                               k
rc:boolean;
begin
      try
        showmessage('gsel')  ;
        log('y','gsel='+line);
        qrz:=TSQLQuery.Create(self);
        qrz.DataBase:=pqc1;
        qrz.SQL.clear;
        qrz.SQL.Add(line);
        qrz.Active:=true;
        //vglink.qrx:=qrz;
        rc:=true;
       // qrz.Close;

      except
      on ee:exception DO BEGIN
       log('e','gsel ,ee='+ee.Message);
       umain.vglink.rc:=-1;
       umain.vglink.erm:=ee.Message;
       rc:=false;
     end;
    end;


end;




function Tformglink.xgconnect(vglink:tglink):tglink;
var
  xx:integer;
begin
    try

       xx:=1;
       //showmessage('xgconnect baseaddr='+mysysinfo.baseaddr);
       //showmessage('xgconnect basename='+mysysinfo.basename);
       //showmessage('xgconnect basepsw='+mysysinfo.basepsw);
       pqc1.HostName:=mysysinfo.baseaddr;
       xx:=11;
       pqc1.DatabaseName:=mysysinfo.basename;
         xx:=2;
       //showmessage('xgconnect BEFORE PSW');
       pqc1.Password:=mysysinfo.basepsw;
         xx:=3;
      // showmessage('xgconnect start 1');
       pqc1.Connected:=true;
        //   showmessage('xgconnect after connect');
       vglink.rc:=0;
       vglink.erm:='ok';
         xx:=4;
       vglink.state:='open';
         //showmessage('xgconnect start 2');
           xx:=5;
         vglink.currn:=0;
         //log('y','XGONNECT END EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ;
    except
     on ee:exception DO BEGIN
     log('e','xgconnect NEW ,ee='+ee.Message+' XX='+inttostr(xx));
     vglink.rc:=-1;
     vglink.erm:=ee.Message;
     vglink.state:='error';
     //showmessage('formglink.xgconnect ee='+ee.Message +' XX='+inttostr(xx));
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
       showmessage('pqc1AfterConnect');
   //umain.slappstatus.Add('pgconnect');


end;

procedure Tformglink.pqc1AfterDisconnect(Sender: TObject);
begin
      showmessage('pqc1AfterDisconnect');
   //umain.slappstatus.Add('pgdisconnect');
end;

procedure Tformglink.pqc1Log(Sender: TSQLConnection; EventType: TDBEventType;
  const Msg: String);
begin
    //  log('pqc1Log','msg='+msg);
end;

end.

