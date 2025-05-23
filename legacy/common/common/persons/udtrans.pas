unit udtrans;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Process, SysUtils, messages, Dialogs, forms, UTF8Process, uplaysound,
  TSSMQTTC, ctypes,
  dateutils;

type

  { Tdmmqt }

  Tdmmqt = class(TDataModule)
    pls: Tplaysound;
    pe8: TProcessUTF8;
    pe: TProcess;
    procedure DataModuleCreate(Sender: TObject);
    procedure mqttClntConnected(ReturnCode: Integer);
    procedure mqttClntSubscribed(MId: CInt; QoS_Count: CInt; const Granted_QoS: CInt);
    procedure mqttClntReceived(sTpc, sMsg: String);
    procedure mqttClntDisConnected(ReturnCode: Integer);
    procedure gsubscr(topic:string);
    procedure gconnect(cid,sHost:string);
    procedure mqttClntUnSubscribed(MId: CInt);
    procedure mqttClntPublished(const MId: CInt);
    procedure mqttClntLog(sMsg: String);
    procedure mysend(sj:string);
procedure     execommand(pte:string);



  private

  public

  end;

var
  dmmqt: Tdmmqt;
  issubscr:boolean;
   mqttClnt: TTSSMQTTC; // VVG

implementation

{$R *.lfm}
uses umain;

{ Tdmmqt }


procedure Tdmmqt.gconnect(cid,sHost:string);
begin
 try

      mqttClnt.ClientID:=cid;
      mqttClnt.host:=shost;
      mqttClnt.Port:=1883;
      mqttClnt.PingPeriod:=10;
      mqttClnt.doConnect; //sudavagolo

  except
    on e: Exception do
    begin
      form1.log('e', 'Tdmmqt.gconnect,e=' + e.message);
      SHowmessage('Tdmmqt.gconnect ee='+e.Message) ;
    end;
  end;

end;

procedure Tdmmqt.gsubscr(topic:string);
begin
      mqttClnt.doSubscribe(topic,0);

end;


procedure Tdmmqt.mqttClntConnected(ReturnCode: Integer);
begin
     // form1.log('y','mqttClntConnected !!!!!!!!!!!!!!!!');
      umain.slappstatus.Add('mqttconnect');
      umain.fmqtt:=TRUE;




end;


procedure Tdmmqt.mysend(sj:string);
begin
        try

         mqttClnt.doSendMsg('tss_mqtt',sj,False);
      except
        on e:exception do begin
         ctrerr:=ctrerr+1;
         //form1.pantrerr.caption:=inttostr(ctrerr);
         //form1.pantrerr.Visible:=true;
         form1.log('e','mysend, E='+e.Message);
       end;
      end;

end;

procedure Tdmmqt.mqttClntReceived(sTpc, sMsg: String);
begin
     // try
       slmqtbox.Add(smsg);
       umain.substatus.lmqtt:=dateutils.DateTimeToUnix(now,false);
       exit;
      {
       except
        on e:exception do begin
         umain.ctrerr:=umain.ctrerr+1;
         //form1.pantrerr.caption:=inttostr(ctrerr);
         //form1.pantrerr.Visible:=true;
         form1.logl('e','mqttClntReceived, E='+e.Message);
       end;
      end;

      }

       //razborjson(smsg);
end;

procedure Tdmmqt.mqttClntSubscribed(MId: CInt; QoS_Count: CInt; const Granted_QoS: CInt);
begin
       issubscr:=true;
       //form1.logl('l','mqttClntSubscribedSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS');
end;

procedure Tdmmqt.mqttClntUnSubscribed(MId: CInt);
begin
     //
end;


procedure Tdmmqt.mqttClntDisConnected(ReturnCode: Integer);
begin
         umain.slappstatus.Add('mqttdisconnect');
         umain.substatus.lmqtt:=0;
         umain.fmqtt:=FALSE;
end;



procedure Tdmmqt.mqttClntPublished(const MId: CInt);
begin
 //

end;

procedure Tdmmqt.mqttClntLog(sMsg: String);
begin
  //
end;

procedure Tdmmqt.DataModuleCreate(Sender: TObject);
begin
    issubscr:=false;
     mqttClnt:=TTSSMQTTC.Create(self);
     mqttClnt.OnConnected:=@mqttClntConnected;
     mqttClnt.OnDisConnected:=@mqttClntDisConnected;
    mqttClnt.OnSubscribed:=@mqttClntSubscribed;
    mqttClnt.OnUnSubscribed:=@mqttClntUnSubscribed;
     mqttClnt.OnReceived:=@mqttClntReceived;
     mqttClnt.OnPublished:=@mqttClntPublished;
     mqttClnt.OnLog:=@mqttClntLog;



end;

procedure Tdmmqt.execommand(pte:string);
begin

   pe8.CommandLine:=pte;
   pe8.ApplicationName:='htop';
   pe8.ConsoleTitle:='HTOP';
  form1.log('l','pe8='+pte);
   pe8.Active:=true;



end;



end.

