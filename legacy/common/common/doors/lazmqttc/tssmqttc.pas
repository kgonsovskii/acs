unit TSSMQTTC;

{$mode ObjFPC}{$H+}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  CTypes, // needed by mosquitto
  Classes, SysUtils, DateUtils, StrUtils, Math, LResources, BrokerUnit, MQTTClass, Mosquitto;

type

  TLogEvent = procedure(sMsg: String) of Object;
  //TConnectedEvent = procedure(Sender: TObject; ReturnCode: Integer) of Object;
  TConnectedEvent = procedure(ReturnCode: Integer) of Object;
  TDisConnectedEvent = procedure(ReturnCode: Integer) of Object;
  TSubscribedEvent = procedure(MId: CInt; QoS_Count: CInt; const Granted_QoS: CInt) of Object;
  TUnSubscribedEvent = procedure(MId: CInt) of Object;
  TReceivedEvent = procedure(sTpc,sMsg: String) of Object;
  TPblshEvent = procedure(const MId: CInt) of Object;


  { TTSSMQTTC }

  TTSSMQTTC = class(TComponent)
  private
    FLogLevel: LongInt; // log levels of MqttClient and the underlying mosquitto lib
    FCnnct: Boolean;
    FHost: String;
    //FPblsh: TPblshEvent;
    FPort: Integer;
    FPngPrd: LongInt; // FPngPrd: UInt16;
    FClntID: String;
    //FslTpcsInit: TStringList; // Список имен топиков для первоначальной подписки
    //// Список имен подписанных топиков
    ////   Формат: <ID-сообщения>=<наименование_топика>
    //FslTpcsSbscrbd: TStringList;
    //FslTpcsUnSbscrb: TStringList; // Список имен отписываемых топиков

    FLogEvent: TLogEvent;
    FConnectedEvent: TConnectedEvent;
    FDisConnectedEvent: TDisConnectedEvent; // VVG
    //FPingResponsedEvent: TPingResponsedEvent; // VVG
    FSubscribedEvent: TSubscribedEvent; // VVG
    FUnSubscribedEvent: TUnSubscribedEvent; // VVG
    //FOnRcvdMsg: TRcvdMsgEvent; // VVG
    FReceivedEvent: TReceivedEvent;
    //FOnPblsh: TPblshEvent; // VVG
    FPblshEvent: TPblshEvent;
    //FOnError: TErrEvent; // VVG

    //procedure SetCnnct(AValue: Boolean);
    //procedure doSbscrbInit;
    procedure SetHost(AValue: String);
    procedure SetPort(AValue: Integer);
    procedure SetPngPrd(AValue: LongInt); // procedure SetPngPrd(AValue: UInt16);
    procedure SetClntID(AValue: String);

    function ConnectBroker(aBroker: TBroker): Boolean;
    //procedure doCmbFill;
    //procedure doIntrfcEnbl(isEnbl: Boolean);
    //procedure doneConnect(const Rc: LongInt);
    //procedure doneDisConnect(const Rc: LongInt);
    //procedure doneSbscrb(mid: LongInt; qos_count: LongInt; const granted_qos: LongInt);
    //procedure doneUnSbscrb(mid: LongInt);
    //procedure doneLog(Level: LongInt; Str: AnsiString);
    //procedure logShow(sMsg: String);
    //procedure UpdateConnectionState;
    function ClientState: TMQTTConnectionState;

  protected

  public
    constructor Create(AOwner: TComponent); override;
    //constructor Create; override;
    destructor Destroy; override;

    procedure doConnect;
    procedure doDisConnect;

    // Запрос на подписку топика
    //* Returns:
    //* -1: Not Connected
    //*  0: MOSQ_ERR_SUCCESS -        on success.
    //*  1: MOSQ_ERR_NOMEM -          if an out of memory condition occurred.
    //*  3: MOSQ_ERR_INVAL -          if the input parameters were invalid.
    //*  4: MOSQ_ERR_NO_CONN -        if the client isn't connected to a broker.
    //* 18: MOSQ_ERR_MALFORMED_UTF8 - if the topic is not valid UTF-8
    function doSubscribe(sTopic: String; iQoS: CInt): Integer;
    // Получение (TStringList) списка подписанных топиков
    function doGetTopicNames: TStringList;
    // Запрос на отписку топика
    //*  Returns:
    //* -2: Topic is not Found
    //* -1: Not Connected
    //*  0: MOSQ_ERR_SUCCESS -        on success.
    //*  3: MOSQ_ERR_INVAL -          if the input parameters were invalid.
    //*  1: MOSQ_ERR_NOMEM -          if an out of memory condition occurred.
    //*  4: MOSQ_ERR_NO_CONN -        if the client isn't connected to a broker.
    //* 18: MOSQ_ERR_MALFORMED_UTF8 - if the topic is not valid UTF-8
    function doUnSubscribe(sTopic: String): Integer;
    // Публикация сообщения в указанный топик
    //* Returns:
    //* -2: Topic is not Found
    //* -1: Not Connected
    //*	 0: MOSQ_ERR_SUCCESS -        on success.
    //*  1: MOSQ_ERR_NOMEM -          if an out of memory condition occurred.
    //*  2: MOSQ_ERR_PROTOCOL -       if there is a protocol error communicating with the broker.
    //*  3: MOSQ_ERR_INVAL -          if the input parameters were invalid.
    //*  4: MOSQ_ERR_NO_CONN -        if the client isn't connected to a broker.
    //*  9: MOSQ_ERR_PAYLOAD_SIZE -   if payloadlen is too large.
    //* 18: MOSQ_ERR_MALFORMED_UTF8 - if the topic is not valid UTF-8
    function doSendMsg(sTpc, sMsg: String; bRetain: Boolean): Integer;

    procedure rcvdClntLog(sMsg: String);
    procedure rcvdClntConnAck(const Rc: LongInt);
    procedure rcvdClntDisConnAck(const Rc: LongInt);
    procedure rcvdClntSbscrbAck(MId: CInt; QoS_Count: CInt; const Granted_QoS: PCInt);
    procedure rcvdClntUnSbscrbAck(MId: CInt);
    procedure rcvdClntMessage(const Payload: Pmosquitto_message);
    procedure rcvdClntPblshAck(const MId: CInt);

    // Соединение с брокером
    //property Connect: Boolean read FCnnct write SetCnnct;
    property Connect: Boolean read FCnnct ;

  published
    // IP или наименование устройства MQTT-брокера
    property Host: String read FHost write SetHost{ default DEFAULT_HOST};
    // Порт MQTT-брокера (по умолчанию: 1833)
    property Port: Integer read FPort write SetPort{ default DEFAULT_PORT};
    // Период запроса пинга к MQTT-брокеру, сек. 5..65535
    property PingPeriod: LongInt read FPngPrd write SetPngPrd; // property PingPeriod: UInt16 read FPngPrd write SetPngPrd;
    // Уникальный идентификатор клиента
    property ClientID: String read FClntID write SetClntID;

    property OnLog: TLogEvent read FLogEvent write FLogEvent;
    // Событие соединения с MQTT-брокером
    property OnConnected: TConnectedEvent read FConnectedEvent write FConnectedEvent;
    // Событие рассоединения с MQTT-брокером
    property OnDisConnected: TDisConnectedEvent read FDisConnectedEvent write FDisConnectedEvent;
    // Событие подписки на топик
    property OnSubscribed: TSubscribedEvent read FSubscribedEvent write FSubscribedEvent;
    // Событие отписки от топика
    property OnUnSubscribed: TUnSubscribedEvent read FUnSubscribedEvent write FUnSubscribedEvent;
    // Полученное сообщение
    property OnReceived: TReceivedEvent read FReceivedEvent write FReceivedEvent;
    // Событие публикации
    property OnPublished: TPblshEvent read FPblshEvent write FPblshEvent;
    //// Событие ошибки
    //property OnError: TErrEvent read FOnError write FOnError;
    //// Событие подтверждения пинга от MQTT-брокера
    //property OnPingResponsed: TPingResponsedEvent read FPingResponsedEvent write FPingResponsedEvent; // VVG

  end;

//procedure Register;

implementation

uses
  {Mosquitto,}Stringres;

//procedure Register;
//begin
//  {$I tssmqttc_icon.lrs}
//  RegisterComponents('TSS',[TTSSMQTTC]);
//end;

const
  DEFAULT_LOG_LEVEL = MOSQ_LOG_NODEBUG; // defined in mqttclass
  //DEFAULT_HOST = '127.0.0.1';
  //DEFAULT_PORT = 1883;
  //DEFAULT_PING = 60;

type
  { TThisMQTTConnection }

  TThisMQTTConnection = class(TMQTTConnection)
    FRc: LongInt;
    FMId: LongInt;
    FQoS_Count: LongInt;
    FGranted_QoS: LongInt;
    FLevel: CInt;
    FStr: AnsiString;
  private
    //FThisMessage: String;
    //procedure syncDisCnnct;
    //procedure syncCnnct;
    //procedure syncLog;
    //procedure syncSbscrb;
    //procedure syncUnSbscrb;
    //procedure UpdateGUI;
    //procedure MessageHandler(const Payload: Pmosquitto_message);
    //procedure CnnctHandler(const Rc: LongInt);
    //procedure DisCnnctHandler(const Rc: LongInt);
    //procedure SbscrbHandler(mid: LongInt; qos_count: LongInt; const granted_qos: PCint);
    //procedure UnSbscrbHandler(mid: LongInt);
    procedure LogHandler(const Level: CInt; const Str: String);
  end;

var
  MqttClient: TThisMQTTConnection = Nil;
  MqttConfig: TMQTTConfig;

//////////
//procedure TThisMQTTConnection.MessageHandler(const Payload: Pmosquitto_message);
//var
//  Msg:String;
//begin
//   //msg := '';
//   //with payload^ do begin
//   //   { Note that MQTT messages can be binary, but for this test case we just
//   //     assume they're printable text, as a test
//   //     Károly Balogh (chainq) }
//   //   if (payloadlen > 0) then begin
//   //     SetLength(msg,payloadlen);
//   //     Move(payload^,msg[1],payloadlen);
//   //   end;
//   //   if gvShowTopics then
//   //     FThisMessage := Format(sMsgFormatWithTopic, [Options.SubMsgHeader, topic, msg])
//   //   else
//   //     FThisMessage := Format(sMsgFormatNoTopic, [Options.SubMsgHeader, msg]);
//   //   Synchronize(@UpdateGui);
//   //end;
//
//  //fmMain.logShow('TThisMQTTConnection.MessageHandler -> EMPTY!!!');
//  Msg:='';
//  with Payload^ do begin
//    // Note that MQTT messages can be binary,
//    //   but for this test case we just assume they're printable text, as a test Károly Balogh (chainq) }
//
//    if (Payloadlen > 0) then begin
//      SetLength(Msg,Payloadlen);
//      Move(Payload^,Msg[1],Payloadlen);
//    end;
//    //   if gvShowTopics then
//    //     FThisMessage := Format(sMsgFormatWithTopic, [Options.SubMsgHeader, topic, msg])
//    //   else
//    //     FThisMessage := Format(sMsgFormatNoTopic, [Options.SubMsgHeader, msg]);
//    //fmMain.logShow(format('TThisMQTTConnection.MessageHandler -> Options.SubMsgHeader: %s; Topic: %s;  Msg: %s;',[Options.SubMsgHeader, Topic, Msg]));
//
//    //Synchronize(@UpdateGui);
//  end; // with Payload^ do
//
//end; // procedure TThisMQTTConnection.MessageHandler(..);

//////////
//procedure TThisMQTTConnection.CnnctHandler(const Rc: LongInt);
//begin
//  FRc:=Rc;
//  // !!! Выдать событие коннекта
//  //Synchronize(@syncCnnct);
//  TTSSMQTTC(Self.ClassParent).rcvdClntConnAck(Rc);
//
//end; // procedure TThisMQTTConnection.CnnctHandler(..);

//////////
//procedure TThisMQTTConnection.DisCnnctHandler(const Rc: LongInt);
//begin
//  FRc:=Rc;
//  // !!! Выдать событие дисконнекта
//  //Synchronize(@syncDisCnnct);
//end; // procedure TThisMQTTConnection.DisCnnctHandler(..);

//////////
//procedure TThisMQTTConnection.SbscrbHandler(mid: LongInt; qos_count: LongInt; const granted_qos: PCint);
//begin
//  FMId:= mid;
//  FQoS_Count:= qos_count;
//  FGranted_QoS:= granted_qos^; // OK
//  // !!! Выдать событие подписки
//  //Synchronize(@syncSbscrb);
//end; // procedure TThisMQTTConnection.SbscrbHandler(..);

//////////
//procedure TThisMQTTConnection.UnSbscrbHandler(mid: LongInt);
//begin
//  FMId:=mid;
//  // !!! Выдать событие отписки
//  //Synchronize(@syncUnSbscrb);
//end; // procedure TThisMQTTConnection.UnSbscrbHandler(..);

//////////
procedure TThisMQTTConnection.LogHandler(const Level: CInt; const Str: String);
begin
  FLevel:= Level;
  FStr:= Str;
  // !!! Выдать событие лога
  //Synchronize(@syncLog);
end; // procedure TThisMQTTConnection.LogHandler(..);

{ TTSSMQTTC }

//////////
// Срабатывает и во время разработки при размещении на форме
constructor TTSSMQTTC.Create(AOwner: TComponent);
//constructor TTSSMQTTC.Create;
begin
  inherited Create(AOwner);
  //inherited Create(Nil);

  Broker:= BrokerUnit.Broker;
  Broker.ClearSubTopics; // !!! Без очистки выполняется подписка #!!!

  FLogLevel:= DEFAULT_LOG_LEVEL;

  FCnnct:=False;
  FHost:=DEFAULT_MQTT_HOST; // DEFAULT_HOST;
  FPort:=DEFAULT_MQTT_PORT; // DEFAULT_PORT;
  FPngPrd:=DEFAULT_KEEPALIVES; // 60sec->1min // second delay between keep alive pings - min 5 secs
  //FslTpcsInit:=TStringList.Create; FslTpcsInit.Delimiter:=',';
  //FslTpcsSbscrbd:=TStringList.Create; FslTpcsSbscrbd.Delimiter:=',';
  //FslTpcsUnSbscrb:=TStringList.Create; FslTpcsUnSbscrb.Delimiter:=',';
  FClntID:=format('mqtt%d',[DateTimeToUnix(Now)]);

end; // constructor TTSSMQTTC.Create;

//////////
destructor TTSSMQTTC.Destroy;
begin
  // ORIG: FreeAndNil(MqttClient);

  inherited Destroy;
end; // destructor TTSSMQTTC.Destroy;

//////////
procedure TTSSMQTTC.rcvdClntLog(sMsg: String);
begin
  if Assigned(OnLog) then OnLog(sMsg);
end; // procedure TTSSMQTTC.rcvdClntLog(..);

{
!!! Заменено на doConnect и doDisConnect
!!! Присвоение FCnnct перенесено в соответствующие события
//////////
procedure TTSSMQTTC.SetCnnct(AValue: Boolean);
begin

  if(FCnnct=AValue) then Exit;

  rcvdClntLog('TTSSMQTTC.SetCnnct -> ...');

  FCnnct:=AValue;
  if(FCnnct) then begin // connect
    Broker.Host:=FHost;
    Broker.Port:=FPort;
    Broker.KeepAlives:=FPngPrd;

    //rcvdClntLog(format('TTSSMQTTC.SetCnnct -> Broker:%s   Host: %s%s   Port: %d%s   KeepAlives: %d',[
    //  LineEnding,Broker.Host
    //  ,LineEnding,Broker.Port
    //  ,LineEnding,Broker.KeepAlives
    //]));

    if(ConnectBroker(Broker)) then begin
      rcvdClntLog('TTSSMQTTC.SetCnnct -> ConnectBroker(Broker): TRUE');
    end // if(ConnectBroker(Broker))
    else begin
      rcvdClntLog('TTSSMQTTC.SetCnnct -> ConnectBroker(Broker): FALSE');
    end; // else: if(ConnectBroker(Broker))

  end // if(FCnnct)
  else begin // disconnect
    FreeAndNil(MqttClient);
  end; // else: if(FCnnct)

end; // procedure TTSSMQTTC.SetCnnct(..);
}

//////////
procedure TTSSMQTTC.doConnect;
begin
  Broker.Host:=FHost;
  Broker.Port:=FPort;
  //Broker.KeepAlives:=FPngPrd;
  Broker.KeepAlives:=ifthen(FPngPrd<5,5,FPngPrd); // second delay between keep alive pings - min 5 secs

  if(ConnectBroker(Broker)) then begin
    rcvdClntLog('TTSSMQTTC.doConnect -> ConnectBroker(Broker): TRUE');
  end // if(ConnectBroker(Broker))
  else begin
    rcvdClntLog('TTSSMQTTC.doConnect -> ConnectBroker(Broker): FALSE');
  end; // else: if(ConnectBroker(Broker))
end; // procedure TTSSMQTTC.doConnect;

//////////
procedure TTSSMQTTC.doDisConnect;
begin
  FreeAndNil(MqttClient);
end; // procedure TTSSMQTTC.doDisConnect;

//////////
procedure TTSSMQTTC.SetHost(AValue: String);
begin
  if (0<Trim(AValue).Length) and (CompareStr(AValue,FHost)<>0) then FHost:=AValue;
end; // procedure TTSSMQTTC.SetHost(..);

//////////
procedure TTSSMQTTC.SetPort(AValue: Integer);
begin
  if FPort=AValue then Exit;
  FPort:=AValue;
end; // procedure TTSSMQTTC.SetPort(..);

//////////
procedure TTSSMQTTC.SetPngPrd(AValue: LongInt);
begin
  if FPngPrd=AValue then Exit;
  // UInt16 - Диапазон: 0..65535 => 65535seconds -> 1092minutes -> 18hours;
  //if (4<AValue) and (65536>AValue) then FPngPrd:=AValue;
  // second delay between keep alive pings - min 5 secs
  if(5>AValue) then FPngPrd:=5
  else if(65536<AValue) then FPngPrd:=65535 // 65535seconds -> 1092minutes -> 18hours
  else FPngPrd:=AValue;
end; // procedure TTSSMQTTC.SetPngPrd(..);

//////////
procedure TTSSMQTTC.SetClntID(AValue: String);
begin
  if (0<Trim(AValue).Length) and (CompareStr(AValue,FClntID)<>0) then FClntID := Trim(AValue);
end; // procedure TTSSMQTTC.SetClntID(..);

//////////
function TTSSMQTTC.ConnectBroker(aBroker: TBroker): Boolean;
var
  iRsltCode: CInt;
begin
  FillChar(MqttConfig, sizeof(MqttConfig), 0);

  with MqttConfig do begin
    ssl:= aBroker.SSL;
    ssl_cacertfile:= aBroker.SSLCert;
    hostname:= aBroker.host;
    port:= aBroker.port;
    username:= aBroker.user;
    password:= aBroker.password;
    keepalives:= FPngPrd; // keepalives:= 60;
    reconnect_delay:= 1; // reconnect_delay:= aBroker.ReconnectDelay;
    reconnect_backoff:= aBroker.ReconnectBackoff;
  end; // with MqttConfig do

  Result:= False;
  FreeAndNil(MqttClient);

  MqttClient:= TThisMQTTConnection.Create('mqttClient', MqttConfig, FLogLevel);

  try

    //{* Log types *}
    //const
    //    MOSQ_LOG_NONE = $00;
    //    MOSQ_LOG_INFO = $01;
    //    MOSQ_LOG_NOTICE = $02;
    //    MOSQ_LOG_WARNING = $04;
    //    MOSQ_LOG_ERR = $08;
    //    MOSQ_LOG_DEBUG = $10;
    //    MOSQ_LOG_SUBSCRIBE = $20;
    //    MOSQ_LOG_UNSUBSCRIBE = $40;
    //    MOSQ_LOG_WEBSOCKETS = $80;
    //    MOSQ_LOG_ALL = $FFFF;
    MqttClient.MQTTLogLevel:=MOSQ_LOG_DEBUG;

    MqttClient.AutoReconnect:= aBroker.AutoReconnect;

    //MqttClient.OnMessage:= @MqttClient.MessageHandler;
    MqttClient.OnMessage:= @rcvdClntMessage;

    //ORIG: MqttClient.OnConnect:= @MqttClient.ConnectionHandler;
    //MqttClient.OnConnect:= @MqttClient.CnnctHandler;
    MqttClient.OnConnect:= @rcvdClntConnAck;

    //ORIG: MqttClient.OnDisconnect:= @MqttClient.ConnectionHandler;
    //MqttClient.OnDisconnect:= @MqttClient.DisCnnctHandler;
    MqttClient.OnDisconnect:= @rcvdClntDisConnAck;

    //MqttClient.OnSubscribe:= @MqttClient.SbscrbHandler;
    MqttClient.OnSubscribe:= @rcvdClntSbscrbAck;

    //MqttClient.OnUnsubscribe:= @MqttClient.UnSbscrbHandler;
    MqttClient.OnUnsubscribe:= @rcvdClntUnSbscrbAck;

    MqttClient.OnPublish:=@rcvdClntPblshAck;

    MqttClient.OnLog:= @MqttClient.LogHandler;

    iRsltCode:=MqttClient.Connect;
    rcvdClntLog(format('TTSSMQTTC.ConnectBroker -> Connect Request Sent Successfully! Result Code: %d',[iRsltCode]));
  //  PublishTopicEdit.Text := aBroker.PubTopic;
  //  TopicsGrid.Broker := aBroker;
  //  TopicsGrid.UpdateGridSize;
  //  TopicsGrid.Invalidate;
    Result:= True;
  except
    Result:= False;
  end;

end; // function TTSSMQTTC.ConnectBroker(..): Boolean;

//////////
function TTSSMQTTC.ClientState: TMQTTConnectionState;
begin
  if Assigned(MqttClient) then Result:= MqttClient.State
  else Result:= mqttNone;
end; // function TTSSMQTTC.ClientState: TMQTTConnectionState;

//////////
procedure TTSSMQTTC.rcvdClntConnAck(const Rc: LongInt);
var
  i,iRsltCd: Integer;
begin

  FCnnct:=True;

  rcvdClntLog(format('TTSSMQTTC.rcvdClntConnAck -> Broker.SubTopicsCount: %d;',[Broker.SubTopicsCount]));

  //EXAMPLE:
  //Broker.AddSubTopic(sTopic,iQoS,True);
  //cint:=MqttClient.Subscribe(sTopic,iQoS);
  // Срабатывает при разрыве связи, а затем восстановлении связи
  // При первичном соединении Broker.SubTopicsCount = 0
  // При повтороном соединении Broker.SubTopicsCount > 0
  // При повтороном соединении надо восстановить подписки!
  if(0<Broker.SubTopicsCount) then begin
    for i:= 0 to Broker.SubTopicsCount-1 do begin
      // EXAMPLE:
      //if Broker.SubTopics[i].Use then begin
      //  slTpcs.Append(Broker.SubTopics[i].Topic);
      //end;

      iRsltCd:=MqttClient.Subscribe(Broker.SubTopics[i].Topic,Broker.SubTopics[i].QoS);
      rcvdClntLog(format('TTSSMQTTC.rcvdClntConnAck -> ReSubscribe Request Sent Successfully: Topic: %s; iQoS: %d; Result Code: %d;',[Broker.SubTopics[i].Topic,Broker.SubTopics[i].QoS,iRsltCd]));
      Sleep(500);

    end; // for i:= 0 to Broker.SubTopicsCount-1 do
  end; // if(0<Broker.SubTopicsCount)

  ////doErrMsg(format('TTSSMQTTClient.rcvdClntConnAck -> Assigned(OnConnected): %s; iReturnCode: %d;',[IfThen(Assigned(OnConnected),'T','F'),iReturnCode]));
  //doErrMsg(format('!!! TTSSMQTTClient.rcvdClntConnAck -> Assigned(OnConnected): %s; iReturnCode: %d;',[IfThen(Assigned(OnConnected),'T','F'),iReturnCode]));
  //
  //if Assigned(OnConnected) then OnConnected(Sender,iReturnCode);
  //if Assigned(OnConnected) then OnConnected(iReturnCode);
  if Assigned(OnConnected) then OnConnected(Rc);

  //if(0=iReturnCode) then begin
  //
  //  thrdPingRqst:=TPingRqstThread.Create(False,MQTTClient,FPngPrd);
  //  thrdPingRqst.OnPRTRcvdMsg:=@rcvdClntRcvdMsg;
  //  thrdPingRqst.OnPRTErrMsg:=@rcvdClntErr;
  //
  //  doSbscrbInit;
  //end;
end; // procedure TTSSMQTTC.rcvdClntConnAck(..);

//////////
procedure TTSSMQTTC.rcvdClntDisConnAck(const Rc: LongInt);
begin
  FCnnct:=False;

  if Assigned(OnDisConnected) then OnDisConnected(Rc);
end; // procedure TTSSMQTTC.rcvdClntDisConnAck(..);

//////////
procedure TTSSMQTTC.rcvdClntSbscrbAck(MId: CInt; QoS_Count: CInt; const Granted_QoS: PCInt);
begin
  if Assigned(OnSubscribed) then OnSubscribed(MId,QoS_Count,Granted_QoS^);
end; // procedure TTSSMQTTC.rcvdClntSbscrbAck(..);

//////////
procedure TTSSMQTTC.rcvdClntUnSbscrbAck(MId: CInt);
begin
  if Assigned(OnUnSubscribed) then OnUnSubscribed(MId);
end; // procedure TTSSMQTTC.rcvdClntUnSbscrbAck(..);

//////////
procedure TTSSMQTTC.rcvdClntMessage(const Payload: Pmosquitto_message);
var
  sMsg: String;
begin
  sMsg:='';
  with Payload^ do begin
    // Note that MQTT messages can be binary,
    //   but for this test case we just assume they're printable text, as a test Károly Balogh (chainq) }
    if (Payloadlen > 0) then begin
      SetLength(sMsg,Payloadlen);
      Move(Payload^,sMsg[1],Payloadlen);
    end;
    if Assigned(OnReceived) then OnReceived(String(topic),sMsg); // BAD!!!
  end; // with Payload^ do
end; // procedure TTSSMQTTC.rcvdClntMessage(..);

//////////
procedure TTSSMQTTC.rcvdClntPblshAck(const MId: CInt);
begin
  if Assigned(OnPublished) then OnPublished(MId);
end; // procedure TTSSMQTTC.rcvdClntPblshAck(..);

//////////
function TTSSMQTTC.doSubscribe(sTopic: String; iQoS: CInt): Integer;
var
  newState: TMQTTConnectionState;
  cint: Integer;
begin
  newState:= ClientState;
  if(mqttConnected=newState) then begin
    Broker.AddSubTopic(sTopic,iQoS,True);
    cint:=MqttClient.Subscribe(sTopic,iQoS);
    rcvdClntLog(format('TTSSMQTTC.doSubscribe -> sTopic: %s; iQoS: %d; cint: %d;',[sTopic,iQoS,cint]));
    //* Returns:
    //*  0: MOSQ_ERR_SUCCESS -        on success.
    //*  1: MOSQ_ERR_NOMEM -          if an out of memory condition occurred.
    //*  3: MOSQ_ERR_INVAL -          if the input parameters were invalid.
    //*  4: MOSQ_ERR_NO_CONN -        if the client isn't connected to a broker.
    //* 18: MOSQ_ERR_MALFORMED_UTF8 - if the topic is not valid UTF-8
    Result:=cint;
  end // if(mqttConnected=newState)
  else begin
    rcvdClntLog(format('TTSSMQTTC.doSubscribe -> Client State: %s',[sDisconnect]));
    Result:=-1; // Not Connected
  end; // else: if(mqttConnected=newState)

end; // function TTSSMQTTC.doSubscribe(..): Boolean;

//////////
function TTSSMQTTC.doGetTopicNames: TStringList;
var
  slTpcs: TStringList;
  i: Integer;
begin
  slTpcs:= TStringList.Create;
  for i:= 0 to Broker.SubTopicsCount-1 do begin
    if Broker.SubTopics[i].Use then begin
      slTpcs.Append(Broker.SubTopics[i].Topic);
    end;
  end; // for i:= 0 to Broker.SubTopicsCount-1 do
  Result:= slTpcs;
end; // function TTSSMQTTC.doGetTopicNames: TStringList;

//////////
function TTSSMQTTC.doUnSubscribe(sTopic: String): Integer;
var
  newState: TMQTTConnectionState;
begin

  newState:= ClientState;
  if(mqttConnected=newState) then begin

    if(Broker.DeleteSubTopic(sTopic)) then begin
      //*  Returns:
      //*  0: MOSQ_ERR_SUCCESS -        on success.
      //*  3: MOSQ_ERR_INVAL -          if the input parameters were invalid.
      //*  1: MOSQ_ERR_NOMEM -          if an out of memory condition occurred.
      //*  4: MOSQ_ERR_NO_CONN -        if the client isn't connected to a broker.
      //* 18: MOSQ_ERR_MALFORMED_UTF8 - if the topic is not valid UTF-8
      Result:= MqttClient.UnSubscribe(sTopic);
    end // if(Broker.DeleteSubTopic(sTopic))
    else begin
      // -2: sTopic is not found
      Result:=-2;
    end; // else: if(Broker.DeleteSubTopic(sTopic))

  end // if(mqttConnected=newState)
  else begin
    rcvdClntLog(format('TTSSMQTTC.doUnSubscribe -> Client State: %s',[sDisconnect]));
    Result:=-1; // Not Connected
  end; // else: if(mqttConnected=newState)
end; // function TTSSMQTTC.doUnSubscribe(..): Integer;

//////////
function TTSSMQTTC.doSendMsg(sTpc,sMsg: String; bRetain: Boolean): Integer;
var
  newState: TMQTTConnectionState;
  //bRslt: Boolean;
  i,iQoS: Integer;
begin
  newState:= ClientState;
  if(mqttConnected=newState) then begin

    iQoS:=-1;
    for i:= 0 to Broker.SubTopicsCount-1 do begin
      if(sTpc=Broker.SubTopics[i].Topic) then begin
        iQoS:=Broker.SubTopics[i].QoS;
        Break;
      end;
    end; // for cInt:= 0 to Broker.SubTopicsCount-1 do

    if(-1<iQoS) then begin
    //  cInt:=MqttClient.Publish(sTpc,sMsg,iQoS,bRetain);
    //  if(0=cInt) then begin
    //    rcvdClntLog(format('TTSSMQTTC.doSendMsg -> Published OK! sTpc: %s; QoS: %d; Retain: %s; sMsg: %s;',[sTpc,iQoS,IfThen(bRetain,'T','F'),sMsg]));
    //  end
    //  else begin
    //    // ORIG: Format(sMQTTErrorFormat, [res])
    //    rcvdClntLog(format('TTSSMQTTC.doSendMsg -> Error: %d;',[cInt]));
    //  end;
      Result:=MqttClient.Publish(sTpc,sMsg,iQoS,bRetain);
    end // if(-1<iQoS)
    else begin
      //rcvdClntLog(format('TTSSMQTTC.doSendMsg -> Topic "%s" not found!',[sTpc]));
      Result:=-2;
    end; // else: if(-1<iQoS)
  end // if(mqttConnected=newState)
  else begin
    //rcvdClntLog(format('TTSSMQTTC.doSendMsg -> Client State: %s',[sDisconnect]));
    Result:=-1; // Not Connected
  end; // else: if(mqttConnected=newState)
end; // function TTSSMQTTC.doSendMsg(..): Boolean;


end.
