unit uformxtrans;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,StrUtils, Forms, Controls, Graphics, Dialogs,
   TSSMQTTC,
   fpjson, jsonparser,ctypes;

type

  { Tformxtrans }

  Tformxtrans = class(TForm)
    mqttClnt: TTSSMQTTC; // VVG
    procedure FormCreate(Sender: TObject);
    procedure gconnect(cid,sHost:string);
    procedure log(pr,txt:string);
    procedure mqttClntConnected(ReturnCode: Integer);
    procedure mqttClntDisConnected(ReturnCode: Integer);
    procedure mqttClntSubscribed(MId: CInt; QoS_Count: CInt; const Granted_QoS: CInt);
    procedure mqttClntReceived(sTpc, sMsg: String);
    procedure mqttClntUnSubscribed(MId: CInt);
   // procedure mqttClntPublished(const MId: CInt);
    procedure mqttClntLog(sMsg: String);
    procedure gsubscr(topic:string);
    procedure razborjson(v:string);
    procedure gcrmqtt_old;
    procedure mysend(sj:string);
  private

  public

  end;

var
  formxtrans: Tformxtrans;
  slrc      :tstringlist;
  slinjson  :tstringlist;

implementation

{$R *.lfm}
uses umain,ualfunc;

{ Tformxtrans }

procedure Tformxtrans.mysend(sj:string);
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

procedure Tformxtrans.log(pr,txt:string);
begin
     form1.log(pr,txt);
end;

procedure Tformxtrans.gconnect(cid,sHost:string);
begin
      try
     log('c','START gconnect cid='+cid+' sHost='+sHost);
      //showmessage('start gconnect shost='+shost);
      mqttClnt.ClientID:=cid;
      mqttClnt.host:=shost;
      mqttClnt.Port:=1883;
      mqttClnt.PingPeriod:=10;


     //showmessage('gconnect mqtt start cid='+cid+' shost='+shost);
     //log('y',format('Tformtrans.gconnect -> 2 => %s ::: %s ::: %d',[mqttClnt.ClientID,mqttClnt.Host,mqttClnt.Port]));
     mqttClnt.doConnect; //sudavagolo
   //  showmessage('AFTER DOCONNECT gconnect mqtt');
     log('c',format('ПОСЛЕ -> mqttClnt.doConnect; mqttClnt.Connect: %s',[ifthen(mqttClnt.Connect,'T','F')]));
  except
    on e: Exception do
    begin
      log('e', 'gconnect,e=' + e.message);
    end;
  end;


end;


procedure Tformxtrans.mqttClntDisConnected(ReturnCode: Integer);
begin
       showmessage
       log('r','mqttClntDisConnected rc='+inttostr(returncode));
        umain.slappstatus.Add('mqttdisconnect');
       //form1.showtr('ondisconnect',returncode);
end;

procedure Tformxtrans.mqttClntSubscribed(MId: CInt; QoS_Count: CInt; const Granted_QoS: CInt);
begin
      //log('l','mqttClntSubscribed');
      slrc.Add('onsubscribe');
      //showmessage('mqttClntSubscribed');
end;


procedure Tformxtrans.mqttClntConnected(ReturnCode: Integer);
begin
      showmessage('mqttClntConnected') ;
      umain.slappstatus.Add('mqttconnect');


end;


//procedure Tformxtrans.mqttClntPublished(const MId: CInt);
//begin


//end;

procedure Tformxtrans.mqttClntUnSubscribed(MId: CInt);
begin

end;

procedure Tformxtrans.gsubscr(topic:string);
begin
      mqttClnt.doSubscribe(topic,0);

end;
procedure Tformxtrans.mqttClntReceived(sTpc, sMsg: String);
begin
       //log('c','rec='+smsg);
       //razborjson(smsg);
end;

procedure Tformxtrans.mqttClntLog(sMsg: String);
begin
     // log('y','mqttClntLog='+smsg)   sdabedaheer
end;


procedure Tformxtrans.razborjson(v:string);
var
 jb,jbx:TJSONObject;
jd,jdx,jdy:tjsondata;
bidcomp,bidch,cd,cmd,s,sj,uxts:string;
i:integer;
sl:tstringlist;

begin
      try
        jd:=GETJSON(v);
        jb:=tjsonobject(jd);
        sj:=jd.FormatJSON;
        cmd:=jb.Get('cmd');
        slinjson.Add(sj);
        jb.Free; //sudamemory
       except
      on ee:exception DO BEGIN
       log('e','razborjson ,ee='+ee.Message);
      end;
     end;


end;

procedure Tformxtrans.gcrmqtt_old;
begin


end;

procedure Tformxtrans.FormCreate(Sender: TObject);
begin


     mqttClnt:=TTSSMQTTC.Create(self);
     mqttClnt.OnConnected:=@mqttClntConnected;
    //mqttClnt.OnDisConnected:=@mqttClntDisConnected;
    mqttClnt.OnSubscribed:=@mqttClntSubscribed;
    mqttClnt.OnUnSubscribed:=@mqttClntUnSubscribed;
   // mqttClnt.OnReceived:=@mqttClntReceived;
    //mqttClnt.OnPublished:=@mqttClntPublished;
    //mqttClnt.OnLog:=@mqttClntLog;

end;

end.

