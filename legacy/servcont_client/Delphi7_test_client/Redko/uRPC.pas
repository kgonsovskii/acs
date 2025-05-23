unit uRPC;

{
Низкоуровневый протокол обмена. Работает поверх RPCSocket

---------------------------------------------------------------------
Запрос - начинается с BeginQuery
---------------------------------------------------------------------
  <1 Byte ProcNameLength><ProcName><Params>

  ProcNameLength - Длинна имени процедуры

  ProcName -   Имя вызываемой процедуры.

  Params   - Cодержит параметры вызванной процедуры
             в формате :
             <1 Byte ParamsCount>[Param1[ ... ParamN]]

             ParamsCount - Количество параметров

             Param - Параметр процедуры в формате
                     <1 Byte ParamType><1 Byte ParamNameLength><ParamName><ParamData>

                     ParamType - Integer|Boolean|Fload|DateTime|Guid|String|File
                                 Тип данных параметра

                     ParamNameLength - Длинна имени параметра

                     ParamName - Имя параметра

                     ParamData - Значение параметра
                                 Integer - 4 Byte
                                 Boolean - 1 Byte
                                 Fload   - 8 Byte
                                 DateTime- 8 Byte
                                 Guid    - 16 Byte
                                 String - <4 Byte StringLength><StringData>
                                 File - <4 Byte FileLength><FileData>

---------------------------------------------------------------------
Ответ - начинается с BeginAnswer(<PackID - идентификаьор пакета по инициативе которого была выполнена процедура>)
---------------------------------------------------------------------
  <1 Byte ResultType><Params>

  ResultType - T|F  указывает на успех или не успех
               выполнения процедуры переданной с <PackID>

  Params     - Cодержит возвращаемые параметры в том же формате
               что и входящие параметры.
                 В случае ошибки ResultType="F" параметры содержат два
               значения :
                 "ExceptionClass" - Типа String
                 "Message" - Типа String



---------------------------------------------------------------------
Не rpc пакет данных - начинается с DataPost (PackID > 0 и < High(Word) - идентификатор определенного прикладным програиимстом формата )
---------------------------------------------------------------------
формат  определяется прикладным програиимстом.
Может используется для пересылки через порт, используемый RPC, данных в произвольном формате,
задействовав механизм пакетирования из uRPCSocket


   ---------------------------------------------------------------------
   Уведомление - начинается с DataPost (PackID - Всегда равен CrpcNotifyPackFormatID = High(Word) )
   ---------------------------------------------------------------------
   Формат даенных в точности как у "Запрос"

}

interface
Uses Classes, SysUtils,
//     tssTransport,
     SyncObjs, uThreadManage, uSysProc,
     Messages, Windows,
     uRPCSocket, TypInfo,
     uPublishedOperations;

const
  RPC_TransportStop = WM_USER + 1;
  CrpcDefaultTimeout = 30000;

Type
  ErpcRemoteError = Class(ErpcError);
  ErpcTimeOutError = Class(ErpcError);

  TrpcParamType = (ptInteger, ptBoolean, ptFloat, ptDateTime, ptGuid, ptString, ptFile);

  PrpcParam = ^TrpcParam;
  TrpcParam = Record
    DataBuf : String;
    Name : String;
    ParamType: TrpcParamType;
  end;

  TrpcCustomParams = class(TObject)
  Private
    FItems : TList;
    function GetItems(Index: Integer): PrpcParam;
    Function InnerGetString(const ParamName : String; ParamType : TrpcParamType) : String;
  Protected
    Function GetInteger(const ParamName : String) : Integer;
    Function GetBoolean(const ParamName : String) : Boolean;
    Function GetFloat(const ParamName : String) : Double;
    Function GetDateTime(const ParamName : String) : TDateTime;
    Function GetGuid(const ParamName : String) : TGuid;
    Function GetString(const ParamName : String) : String;
    Function GetFile(const ParamName : String) : TFileName;
  Protected
    Property Items[Index : Integer] : PrpcParam Read GetItems;
    Function Count : Integer;
    Function IndexOf(const ParamName : String) : Integer;
    Procedure Delete(Index : Integer);
    Function Add : PrpcParam;

    Function ParamByName(const ParamName : String; NeedParamType: TrpcParamType) : PrpcParam;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Clear; Virtual;
  end;

  //Полученные параметры
  //вызывающая сторона в таком объекте получает возвращаемые параметры
  //Исполняющая сторона в таком объекте получает параметры процедуры
  TrpcParamsOnReceive = class(TrpcCustomParams)
  Private
  Protected
    Procedure ReadFrom( Receiver : TrpcSocketReceiver );
    Procedure ReadAsException(const ExceptionClass, ExceptionMessage : String);
  Public
    Procedure Clear; Override;

    Property vInteger[const ParamName : String] : Integer Read GetInteger;
    Property vBoolean[const ParamName : String] : Boolean Read GetBoolean;
    Property vFloat[const ParamName : String] : Double Read GetFloat;
    Property vDateTime[const ParamName : String] : TDateTime Read GetDateTime;
    Property vGuid[const ParamName : String] : TGuid Read GetGuid;
    Property vString[const ParamName : String] : String Read GetString;
    Property vFile[const ParamName : String] : TFileName Read GetFile;

    Procedure GetParamList(Dest : TStrings);
    //Чисто сервисная фича позволяет относительно быстро получить значение параметра
    //Function vAsInteger(const ParamIndex : Integer; var ParamName : String; Out Value : Integer) : Boolean;
  end;

  //Параметры для отправки
  //вызывающая сторона в таком объекте отправляет параметры процедуры
  //Исполняющая сторона в таком объекте отправляет возвращаемые параметры
  TrpcCustomParamsToSend = class(TrpcCustomParams)
  Private
    Procedure InnerSetString(const ParamName : String; ParamType : TrpcParamType; Const Value : String);
  Protected
    Procedure SetInteger(const ParamName : String; const Value : Integer);
    Procedure SetBoolean(const ParamName : String; const Value : Boolean);
    Procedure SetFloat(const ParamName : String; const Value : Double);
    Procedure SetDateTime(const ParamName : String; const Value : TDateTime);
    Procedure SetGuid(const ParamName : String; const Value : TGuid);
    Procedure SetString(const ParamName : String; const Value : String);
    Procedure SetFile(const ParamName : String; const Value : TFileName);
  Protected
    Function GetOrCreateByName(const ParamName : String; NeedParamType: TrpcParamType) : PrpcParam;
    Procedure WriteTo( Sender: TrpcSocketSender );
  Public
  end;

  TrpcParamsToCall = class(TrpcCustomParamsToSend)
  Private
  Protected
  Public
    Property vInteger[const ParamName : String] : Integer Write SetInteger;
    Property vBoolean[const ParamName : String] : Boolean Write SetBoolean;
    Property vFloat[const ParamName : String] : Double Write SetFloat;
    Property vDateTime[const ParamName : String] : TDateTime Write SetDateTime;
    Property vGuid[const ParamName : String] : TGuid Write SetGuid;
    Property vString[const ParamName : String] : String Write SetString;
    Property vFile[const ParamName : String] : TFileName Write SetFile;
  end;


  TrpcParamsToSend = class;
  //Эта процедура имеет смысл в основном только тогда,
  //когда имеется возвращаемый параметр типа File
  //В этом случае изменение этого файла надо заблокировать
  //на время пересылки а в теле этой процедуры разблокировать
  TrpcSendResultFinallyProc = Procedure(const ProcName : String; Sender : TrpcParamsToSend) Of Object;

  TrpcParamsToSend = class(TrpcCustomParamsToSend)
  Private
    FFinallyData : Pointer;
    FSendResultFinallyProc : TrpcSendResultFinallyProc;
  Protected
    Procedure DoSendResultFinallyProc(const ProcName : String);
  Public
    Property vInteger[const ParamName : String] : Integer Read GetInteger Write SetInteger;
    Property vBoolean[const ParamName : String] : Boolean Read GetBoolean Write SetBoolean;
    Property vFloat[const ParamName : String] : Double Read GetFloat Write SetFloat;
    Property vDateTime[const ParamName : String] : TDateTime Read GetDateTime Write SetDateTime;
    Property vGuid[const ParamName : String] : TGuid Read GetGuid Write SetGuid;
    Property vString[const ParamName : String] : String Read GetString Write SetString;
    Property vFile[const ParamName : String] : TFileName Read GetFile Write SetFile;
    Property SendResultFinallyProc : TrpcSendResultFinallyProc Read FSendResultFinallyProc Write FSendResultFinallyProc;
    Property FinallyData : Pointer Read FFinallyData Write FFinallyData; //Это некие данные которые могут понадобиться в завершающей процедуре
  end;

  TrpcCustomSide = Class;

  {TrpcCustomWorkPool = class( TtmCustomWorkPool)
  Private
    FRPC: TrpcCustomSide;
  Protected
    //Procedure rpcSyncronize(const Proc : TThreadMethod; const IsTerminate : TtmIsTerminateProc);
  Public
    Constructor Create(RPC : TrpcCustomSide);
    Property RPC : TrpcCustomSide Read FRPC;
  end;}

  TrpcProcExecuter = class(TObject)
  Private
    FCore : TtmCustomThreadHolder;
    FRPC: TrpcCustomSide;
  Protected
    Procedure OnBegin;
    Procedure OnEnd;
    Procedure DisposeData(var Data : Pointer);
    Procedure DoProcessData(const Data : Pointer; const IsTerminate : TtmIsTerminateProc);
  Public
    Constructor Create(RPC : TrpcCustomSide);
    Destructor Destroy; Override;
    Property RPC : TrpcCustomSide Read FRPC;
    Procedure ExecuteProc(const SocketChannel : TrpcSocketHandle; AnswerID : Word; const ProcName : String; Params : TrpcParamsOnReceive);
  end;

  TrpcProcExecuterAsWorkPool = class( TtmCustomWorkPool)
  Private
    FWrap: TrpcProcExecuter;
  Protected
    Procedure OnBegin; Override;
    Procedure OnEnd; Override;
    Procedure DisposeData(var Data : Pointer); Override;
    Procedure DoProcessData(const Data : Pointer; const IsTerminate : TtmIsTerminateProc); Override;
  Public
    Constructor Create(Wrap : TrpcProcExecuter);
    Property Wrap : TrpcProcExecuter Read FWrap;
  end;

  TrpcProcExecuterAsQueue = class( TtmCustomQueueHolder)
  Private
    FWrap: TrpcProcExecuter;
    Function IsTerminate : Boolean;
  Protected
    Procedure OnBegin; Override;
    Procedure OnEnd; Override;
    Procedure DisposeItem(var Item : Pointer); Override;
    Procedure DoProcessItem(const Item : Pointer); Override;
  Public
    Constructor Create(Wrap : TrpcProcExecuter);
    Property Wrap : TrpcProcExecuter Read FWrap;
  end;

  {Исполнитель процедур (на принимающей стороне)}
  {TrpcProcExecuter = class(TrpcCustomWorkPool)
  Private
    //FRPC: TrpcCustomSide;
  Protected
    Procedure OnBegin; Override;
    Procedure OnEnd; Override;

    Procedure DisposeData(var Data : Pointer); Override;
    Procedure DoProcessData(const Data : Pointer; const IsTerminate : TtmIsTerminateProc); Override;
  Public
    //Constructor Create(RPC : TrpcCustomSide);
    //Property RPC : TrpcCustomSide Read FRPC;
    Procedure ExecuteProc(const SocketChannel : TrpcSocketHandle; AnswerID : Word; const ProcName : String; Params : TrpcParamsOnReceive);
  end;}

  //Выполняет событие на любое асинхронное изменение сокетного канала RPC
  TrpcChangeListener = class(TtmCustomWinMassageDispatcher)
  Private     //utssRPC   CCClasses
    FRPC: TrpcCustomSide;
  Protected
    Procedure OnBegin; Override;
    Procedure OnEnd; Override;
    Procedure OnException; Override;
  Public
    Constructor Create(RPC : TrpcCustomSide);
    Property RPC : TrpcCustomSide Read FRPC;
  end;

  TrpcCallWaiter = class;

  //Вся эта ботва c подсчетом ссылок-FRefCount и списком ожиданий-FWaits
  //только ради асинхронного вызова процедуры у множества клинтов без копирования значения параметров
  TrpcProc = class(TObject)
  Private
    FWaits : TThreadList;
    FRefCount : Integer;
    FName: String;
    FParams: TrpcParamsToCall;
    FRPC: TrpcCustomSide;
    procedure SetName(const Value: String);
  protected
    Function GetWaitItem : TrpcCallWaiter;

    Procedure _Lock;
  Public
    Constructor Create(RPC : TrpcCustomSide);
    Destructor Destroy; Override;
    Property RPC : TrpcCustomSide Read FRPC;
    Property Name : String Read FName Write SetName;
    Property Params : TrpcParamsToCall Read FParams;
    Procedure Leave;
  end;


  //При успешном выполнении
  //     ResultParams - Assigned, ResultSuccessful = True
  //Если поизошла удаленная ошибка то
  //     ResultParams - Assigned, ResultSuccessful = False
  //Если поизошла ошибка вызова (локальная) то
  //     ResultParams = Nil, ResultSuccessful = False
  //     Получить информацию об ошибке можно через GetLastError
  TrpcAsynchronProcResult = Procedure(const AsyncronCallHandle : String; const ResultSuccessful : Boolean; ResultParams : TrpcParamsOnReceive) Of Object;

  //Не блокирующий вызывальщик процедур
  //Вообщето здесь лучше было бы применить механизм аналогичный ProcExecuter - у
  //Для уведомлений с ResultProc = Nil Ставить в очередь а не отправлять через пул 
  TrpcAsynchronCaller = Class(TtmCustomWorkPool)
  Private
    FRPC: TrpcCustomSide;
  Protected
    Procedure OnBegin; Override;
    Procedure OnEnd; Override;

    Procedure DisposeData(var Data : Pointer); Override;
    Procedure DoProcessData(const Data : Pointer; const IsTerminate : TtmIsTerminateProc); Override;
  Public
    Constructor Create(RPC : TrpcCustomSide);
    Property RPC : TrpcCustomSide Read FRPC;
    //ChannelHandle - Это произвольная строка по которой данный вызов можно будет идентифицировать в результирующей процедуре
    Procedure ExecuteProc(ChannelHandle : TrpcSocketHandle;
                         Proc : TrpcProc; TimeOut : Cardinal;
                         ResultProc : TrpcAsynchronProcResult;
                         const AsyncronCallHandle : String);
  end;

  //Ожидатель ответа на вызов Процедуры
  TrpcCallWaiter = class(TObject)
  Private
    FRefCount : Integer;
    FSuccessful: Boolean;
    FWaitEvent: TEvent;
    FResultParams: TrpcParamsOnReceive;
    FChannelHandle: TrpcSocketHandle;
    FCallID: Word;
    FRPC: TrpcCustomSide;
  protected
    Procedure _Lock;
    Procedure _Leave;
  Public
    Constructor Create(RPC : TrpcCustomSide);
    Destructor Destroy; Override;
    Property RPC : TrpcCustomSide Read FRPC;
    //Вызвавший поток стоит на этом Event-e
    Property  WaitEvent : TEvent Read FWaitEvent;
    //Эти два параметра идентифицируют вызов
    Property CallID : Word Read FCallID Write FCallID;
    Property ChannelHandle : TrpcSocketHandle Read FChannelHandle Write FChannelHandle;

    //Эти два параметра заполняются принимающим потоком
    Property ResultParams : TrpcParamsOnReceive Read FResultParams;
    Property Successful : Boolean Read FSuccessful Write FSuccessful;
  end;

  TrpcCustomSide = class( TComponent )
  Private
    FWaitList : TThreadList;
    FProcExecuter : TrpcProcExecuter;
    FAsynchronCaller : TrpcAsynchronCaller;
    FChangeListener : TrpcChangeListener;
    FpSocket: TStrings;
    FActive: Boolean;
    FOnEndExecuteThread: TNotifyEvent;
    FOnBeginExecuteThread: TNotifyEvent;
    FEventsInActivatingThread: Boolean;
    FOnRpcChange: TNotifyEvent;
    FProcPul : TThreadList;
    FCallWaiterPul : TThreadList;
    FTimeOut: Cardinal;
    FOnAsynchronResult: TrpcAsynchronProcResult;
    FWndChangeListener: HWND;
    FSyncronizeProcs : TThreadList;

    procedure SetpSocket(const Value: TStrings);
    procedure SetActive(const Value: Boolean);
    Procedure ClearWaitList;
    procedure SetEventsInActivatingThread(const Value: Boolean);
    Procedure CheckInactive;
    procedure SetOnRpcChange(const Value: TNotifyEvent);
    Procedure ClearProcPul;
    Procedure ClearCallWaiterPul;
    procedure SetTimeOut(const Value: Cardinal);
    procedure SetOnAsynchronResult(const Value: TrpcAsynchronProcResult);
    procedure CheckValidNewCallId(Sender: TrpcSocketSender; NewPackID: Word; out Valid: Boolean);
    Procedure WndProc(var Msg : TMessage);

    Procedure Syncronize(const Proc : TThreadMethod; const IsTerminate : TtmIsTerminateProc; Sender : TtmCustomThreadHolder);
  Protected
    //Создание и разрушение окна прослушивания изменений сокетных каналов
    Procedure CreateWnd;
    Procedure DestroyWnd;

    Procedure OnBeginThread; Dynamic;
    Procedure OnEndThread; Dynamic;

    Procedure InnerOpen; Virtual;
    Procedure InnerClose; Virtual;

    //Приход пакета из сокета
    Procedure _OnReceive( Receiver : TrpcSocketReceiver );
    //Вызывается при всяком изменении RPC
    Procedure DoRpcChange; Dynamic;
    //Сделать вызов Event-а
    Procedure DoRpcNeedExecute(const SenderSocket : TrpcSocketHandle; const ProcName : String; Params : TrpcParamsOnReceive; ResultParams : TrpcParamsToSend; AnswerID : Word; var Handled : Boolean); Virtual; Abstract;
    //Выполнить проседуру
    Procedure DoExec(const SocketChannel : TrpcSocketHandle; AnswerID : Word; const ProcName : String; Params : TrpcParamsOnReceive; Out ResultType : Boolean; ResultParams : TrpcParamsToSend);
    //Отправит квитированный запрос на выполнение
    Function DoQuery(const SocketChannel : TrpcSocketHandle; Proc : TrpcProc; CallTimeOut : Cardinal; const IsTerminate : TtmIsTerminateProc; Out Successful : Boolean) : TrpcParamsOnReceive;
    //Отправить уведомление
    procedure DoNotify(const SocketChannel: TrpcSocketHandle; Proc: TrpcProc; const IsTerminate: TtmIsTerminateProc);
    //Асинхронный отправляльщик запрос на выполнение
    Property AsynchronCaller : TrpcAsynchronCaller Read FAsynchronCaller;

    //Получить сокетный канал
    Function InnerEnterChannel(const SocketChannel : TrpcSocketHandle) : TrpcSocketCustomChannel; Virtual; Abstract;
    //Освободить сокетный канал
    Procedure InnerLeaveChannel(var Channel : TrpcSocketCustomChannel); Virtual; Abstract;
    //Назначить окно прослушивания изменений в канале связи
    procedure SetWndChangeListener(const Value: HWND); Virtual;
    Property WndChangeListener : HWND Read FWndChangeListener Write SetWndChangeListener;
  Public
    Constructor Create(AOwner : TComponent); Override;
    Destructor Destroy; Override;

    //Инициализировать параметры сокета значениями по умолчанию
    Procedure SetDefaultSocketParams; Virtual; Abstract;

    Property Active : Boolean Read FActive Write SetActive;
    Procedure Open;
    Procedure Close;
    {ТК при закрытии разрушаются потоки которые в том числе
     вызывают Event-ы Rpc то попытка закрыть Rpc из этих
     Event-ов приведет к блокировке на время DestroyThreadTimeOut.
     При этом блокированный поток будет разрушен не корректно.

     Поэтому ПОДОНОК БУДЬ НА ЧЕКУ !!!
     НЕ ЗАКРЫВАЙ Rpc ИЗ ЕГО Eventov Если не хочеш рано или поздно обосраться}

    //Получить процедуру из пула (С таким же успехом можно просто создать экземпляр TrpcProc)
    Function DoProc : TrpcProc;

    //Сервисные события позволяют провести дополнительную инициализацию потоков например CoInitialize
    Property OnBeginExecuteThread : TNotifyEvent Read FOnBeginExecuteThread Write FOnBeginExecuteThread;
    Property OnEndExecuteThread : TNotifyEvent Read FOnEndExecuteThread Write FOnEndExecuteThread;

    //Выполнять Event-ы в потоке который активировал RPC
    Property EventsInActivatingThread : Boolean Read FEventsInActivatingThread Write SetEventsInActivatingThread;
  Published
    //общий TimeOut ожидания завершения вызова удаленной процедуры
    Property TimeOut : Cardinal Read FTimeOut Write SetTimeOut default CrpcDefaultTimeout;
    //Параметры сокетного соединения
    Property pSocket : TStrings Read FpSocket Write SetpSocket;
    //Изменилось состояние сокетного соединения
    Property OnRpcChange : TNotifyEvent Read FOnRpcChange Write SetOnRpcChange;
    //Событие на завершение асинхронного вызова (если при вызове не указывалось другого Event-а)
    Property OnAsynchronResult : TrpcAsynchronProcResult Read FOnAsynchronResult Write SetOnAsynchronResult;
  end;

  TrpcOnNeedClientExecute = Procedure(const Sender : TObject; const ProcName : String; Params : TrpcParamsOnReceive; ResultParams : TrpcParamsToSend; var Handled : Boolean) Of Object;

  //Клиентский компонент
  TrpcClientSide = class( TrpcCustomSide )
  Private
    FClientChannel : TrpcSocketClientChannel;
    FOnRpcNeedExecute: TrpcOnNeedClientExecute;
    function GetReady: Boolean;
    function GetChannelHandle: TrpcSocketHandle;
  Protected
    Property ClientChannel : TrpcSocketClientChannel Read FClientChannel;
    Procedure DoRpcNeedExecute(const SenderSocket : TrpcSocketHandle; const ProcName : String; Params : TrpcParamsOnReceive; ResultParams : TrpcParamsToSend; AnswerID : Word; var Handled : Boolean); Override;

    Procedure InnerOpen; Override;
    Procedure InnerClose; Override;

    procedure SetWndChangeListener(const Value: HWND); Override;

    Function InnerEnterChannel(const SocketChannel : TrpcSocketHandle) : TrpcSocketCustomChannel; Override;
    Procedure InnerLeaveChannel(var Channel : TrpcSocketCustomChannel); Override;
  Public
    Procedure SetDefaultSocketParams; Override;

    Property Ready : Boolean Read GetReady;

    Property ChannelHandle : TrpcSocketHandle Read GetChannelHandle;

    //Синхронно вызвать поцедуру сервера
    Function Exec(Proc : TrpcProc; TimeOut: Cardinal = 0; const IsTerminate : TtmIsTerminateProc = Nil) : TrpcParamsOnReceive;
    //Асинхронно вызвать поцедуру сервера
    Procedure ExecA(Proc: TrpcProc; const AsyncronCallHandle : String = ''; ResultProc : TrpcAsynchronProcResult = Nil; TimeOut: Cardinal = 0);
  Published
    //Выполнить процедуру по запросу сервера
    Property OnRpcNeedExecute : TrpcOnNeedClientExecute Read FOnRpcNeedExecute Write FOnRpcNeedExecute;
  end;

  TrpcOnNeedServerExecute = Procedure(const Sender : TObject; const SenderSocket : TrpcSocketHandle; const ProcName : String; Params : TrpcParamsOnReceive; ResultParams : TrpcParamsToSend; var Handled : Boolean) Of Object;

  //Серверный компонент
  TrpcCustomServerSide = class( TrpcCustomSide )
  Private
    FServerHolder : TrpcCustomServerChannelHolder;
    FOnRpcNeedExecute: TrpcOnNeedServerExecute;
  Protected
    Property ServerHolder : TrpcCustomServerChannelHolder Read FServerHolder;
    Procedure DoRpcNeedExecute(const SenderSocket : TrpcSocketHandle; const ProcName : String; Params : TrpcParamsOnReceive; ResultParams : TrpcParamsToSend; AnswerID : Word; var Handled : Boolean); Override;

    Procedure InnerOpen; Override;
    Procedure InnerClose; Override;

    procedure SetWndChangeListener(const Value: HWND); Override;

    Function InnerEnterChannel(const SocketChannel : TrpcSocketHandle) : TrpcSocketCustomChannel; Override;
    Procedure InnerLeaveChannel(var Channel : TrpcSocketCustomChannel); Override;

    Function CreateHolder : TrpcCustomServerChannelHolder; Virtual; Abstract;
  Public
    Procedure SetDefaultSocketParams; Override;

    Procedure ChannelsList( Dest : TrpcSocketChannelsList );

    //Синхронно вызвать поцедуру клиента
    Function Exec(Proc : TrpcProc; Channel : TrpcSocketHandle; TimeOut: Cardinal = 0; const IsTerminate : TtmIsTerminateProc = Nil) : TrpcParamsOnReceive;
    //Асинхронно вызвать поцедуру клиента
    Procedure ExecA(Proc : TrpcProc; Channel : TrpcSocketHandle;  const AsyncronCallHandle: String = ''; ResultProc : TrpcAsynchronProcResult = Nil; TimeOut : Cardinal = 0);
  Published
    //Выполнить процедуру по запросу клиента
    Property OnRpcNeedExecute : TrpcOnNeedServerExecute Read FOnRpcNeedExecute Write FOnRpcNeedExecute;
  end;

  TrpcServerSide = class(TrpcCustomServerSide)
  Private
  Protected
    Function CreateHolder : TrpcCustomServerChannelHolder; Override;
  end;

Type TtssRPCCursorControlProc = Procedure;

  Procedure InitializeRPCCursorControl(const SetRPCCursor, RestoreCursor : TtssRPCCursorControlProc);
  procedure Register;

//  Function Thread_CreateUniqueFile(Out fName : TFileName ) : TStream;
//  Procedure Thread_DropFile(const fName : TFileName );

Const
  CrpcResultExceptionClass = 'ExceptionClass';
  CrpcResultExceptionMessage = 'Message';
  CrpcHostValueName = 'pSocket.Host';
  CrpcPortValueName = 'pSocket.Port';

  CrpcNotifyPackFormatID = High(Word);

  CrpcResultSuccessful = Ord('T');

implementation
//uses DateUtils, ComObj;

var _SetRPCCursor, _RestoreCursor : TtssRPCCursorControlProc;
    _DefaultSocketClientChannelProps : String = '';
    //_DefaultSocketServerChannelHolderProps : String = '';

  procedure Register;
  begin
    RegisterComponents('TSS RPC', [TrpcClientSide, TrpcServerSide]);
  end;


  {Function DefaultTransportProps : String;
  var T : TtssTransport;
  Begin
    If _DefaultTransportProps = '' Then Begin
      Try
      T := TtssTransport.Create(Nil);
      Try
        _DefaultTransportProps := uPublishedOperations.ObjectPropsToStr(T);
      Finally
        T.Free;
      end;
      Except
      end;
    end;
    Result := _DefaultTransportProps;
  end;}

  {function DefaultRPCProps: String;
  var T : TtssRPC;
  Begin
    If _DefaultRPCProps = '' Then Begin
      Try
      T := TtssRPC.Create(Nil);
      Try
        _DefaultRPCProps := uPublishedOperations.ObjectPropsToStr(T);
      Finally
        T.Free;
      end;
      Except
      end;
    end;
    Result := _DefaultRPCProps;
  end;}

  Procedure InitializeRPCCursorControl(const SetRPCCursor, RestoreCursor : TtssRPCCursorControlProc);
  Begin
    _SetRPCCursor := SetRPCCursor;
    _RestoreCursor := RestoreCursor;
  end;

  Procedure SetRPCCursor;
  Begin
    If Assigned(_SetRPCCursor) and (GetCurrentThreadId = MainThreadID) Then
      _SetRPCCursor;
  end;

  Procedure RestoreCursor;
  Begin
    If Assigned(_RestoreCursor) and (GetCurrentThreadId = MainThreadID) Then
      _RestoreCursor;
  end;

  Function InfoOfParams(Params : TStrings) : String;
  var I : Integer;
  Begin
    Result := '';
    For I := 0 to Params.Count - 1 do Begin
      If Result <> '' Then
        Result := Result+', ';

      If Length(Params.ValueFromIndex[I]) > 32 Then
        Result := Result + Params.Names[i] + '=' + Copy(Params.ValueFromIndex[I], 1, 8)+'...'
      else
        Result := Result + Params.Names[i] + '=' + Params.ValueFromIndex[I];
    end;
  end;

const
  CrpcResultException = Ord('F');

  CrpcMaxFileBufSize = $F000;

const
  Rpc_Syncronize = WM_USER + 2323;

Type
  PrpcSyncronizeRec = ^TrpcSyncronizeRec;
  TrpcSyncronizeRec = Record
    Proc : TThreadMethod;
    Event : TEvent;
  end;


{ TrpcParams }

function TrpcCustomParams.Add : PrpcParam;
begin
  New(Result);
  FItems.Add(Result);
end;

procedure TrpcCustomParams.Clear;
var I : Integer;
begin
  For I := Count - 1 DownTo 0 do
    Delete(I);
end;

function TrpcCustomParams.Count: Integer;
begin
  Result := FItems.Count;
end;

constructor TrpcCustomParams.Create;
begin
  Inherited Create;
  FItems := TList.Create;
end;

procedure TrpcCustomParams.Delete(Index: Integer);
var P : PrpcParam;
begin
  P := Items[Index];
  FItems.Delete(Index);
  Dispose(P);
end;

destructor TrpcCustomParams.Destroy;
begin
  Clear;
  FItems.Free;
  Inherited;
end;

function TrpcCustomParams.GetItems(Index: Integer): PrpcParam;
begin
  Result := PrpcParam(FItems[Index]);
end;

function TrpcCustomParams.IndexOf(const ParamName: String): Integer;
begin
  Result := Count - 1;
  While (Result >= 0 ) and (not {Ansi}SameText(ParamName, Items[Result].Name)) do Dec(Result);
end;

function TrpcCustomParams.GetBoolean(const ParamName: String): Boolean;
begin
  Move(PChar(ParamByName(ParamName, ptBoolean).DataBuf)^, Result, SizeOf(Boolean));
end;

function TrpcCustomParams.GetDateTime(const ParamName: String): TDateTime;
begin
  Move(PChar(ParamByName(ParamName, ptDateTime).DataBuf)^, Result, SizeOf(TDateTime));
end;

function TrpcCustomParams.GetFile(const ParamName: String): TFileName;
begin
  Result := InnerGetString(ParamName, ptFile);
end;

function TrpcCustomParams.GetFloat(const ParamName: String): Double;
begin
  Move(PChar(ParamByName(ParamName, ptFloat).DataBuf)^, Result, SizeOf(Double));
end;

function TrpcCustomParams.GetGuid(const ParamName: String): TGuid;
begin
  Move(PChar(ParamByName(ParamName, ptGuid).DataBuf)^, Result, SizeOf(TGUID));
end;

function TrpcCustomParams.GetInteger(const ParamName: String): Integer;
begin
  Move(PChar(ParamByName(ParamName, ptInteger).DataBuf)^, Result, SizeOf(Integer));
end;

function TrpcCustomParams.GetString(const ParamName: String): String;
Begin
  Result := InnerGetString(ParamName, ptString);
end;

function TrpcCustomParams.InnerGetString(const ParamName: String;
  ParamType: TrpcParamType): String;
{var Len : Integer;
    P : Pointer;
begin
  P := PChar(ParamByName(ParamName, ParamType).DataBuf);
  Move(P^, Len, SizeOf(Integer));
  Inc(Cardinal(P), SizeOf(Integer));
  SetLength(Result, Len);
  Move(P^, PChar(Result)^, SizeOf(Len));}
Begin
  Result := ParamByName(ParamName, ParamType).DataBuf;
end;

function TrpcCustomParams.ParamByName(const ParamName: String; NeedParamType: TrpcParamType): PrpcParam;
var I : Integer;
begin
  I := IndexOf( ParamName );
  If I >= 0 Then Begin

    If Items[i].ParamType <> NeedParamType Then
      Raise ErpcError.Create('Параметр "'+ParamName+'" имеет тип '+GetEnumName(TypeInfo(TrpcParamType), Integer(Items[i].ParamType))+' а не '+GetEnumName(TypeInfo(TrpcParamType), Integer(NeedParamType)))
    else
      Result := Items[i];

  end else
    RAise ErpcError.Create('RPC procedure param by name "'+ParamName+'" not found!');
end;

{ TrpcParamsIn }

procedure TrpcParamsOnReceive.Clear;
var I : Integer;
begin
  For I := 0 to Count - 1 do
    If (Items[I].ParamType = ptFile) Then
      SafeThread_DropFile(Items[I].DataBuf);
  inherited;
end;

procedure TrpcParamsOnReceive.GetParamList(Dest: TStrings);
var I : Integer;
begin
  Dest.Clear;
  For I := 0 to Count - 1 do
    Dest.AddObject(Items[I].Name, TObject( Items[I].ParamType ));
end;

procedure TrpcParamsOnReceive.ReadAsException(const ExceptionClass,
  ExceptionMessage: String);
var  P : PrpcParam;
begin
  Clear;
  P := Add;
  P.ParamType := ptString;
  P.Name := CrpcResultExceptionClass;
  P.DataBuf := ExceptionClass;

  P := Add;
  P.ParamType := ptString;
  P.Name := CrpcResultExceptionMessage;
  P.DataBuf := ExceptionMessage;
end;

procedure TrpcParamsOnReceive.ReadFrom(Receiver : TrpcSocketReceiver);

  Procedure _ReadString(var DataBuf : String);
  var L : Integer;
  Begin
    Receiver.ReceiveBuf(L, SizeOf(Integer));
    SetLength(DataBuf, L);
    Receiver.ReceiveBuf(PChar(DataBuf)^, L);
  end;

  Procedure _ReadFile(var DataBuf : String);
  var L : Integer;
      S : TStream;
      Buf : String;
      ReadingLen : Integer;
  Begin
    Receiver.ReceiveBuf(L, SizeOf(Integer));
    If L >= CrpcMaxFileBufSize Then
      SetLength(Buf, CrpcMaxFileBufSize)
    else
      SetLength(Buf, L);

    S := SafeThread_CreateUniqueFile(TFileName(DataBuf));
    Try
      Try
        S.Position := 0;
        While L > 0 do Begin
          If L >= Length(Buf) Then
            ReadingLen := Length(Buf)
          else
            ReadingLen := L;

          Receiver.ReceiveBuf(PChar(Buf)^, ReadingLen);
          S.WriteBuffer(PChar(Buf)^, ReadingLen);
          Dec(L, ReadingLen);
        end;
        S.Size := S.Position; //На всякий случай подрезаю
      Finally
        S.Free;
      end;
    Except
      SafeThread_DropFile(DataBuf);
      raise;
    end;
  end;

var Cnt : Integer;
    B : Byte;
    Itm : PrpcParam;
begin
{
<1 Byte ParamsCount>[Param1[ ... ParamN]]
<1 Byte ParamType><1 Byte ParamNameLength><ParamName><ParamData>
}
  Clear;
  Receiver.ReceiveBuf(B, SizeOf(Byte));
  Cnt := B;
  While Cnt > 0 do Begin
    Itm := Add;
    Receiver.ReceiveBuf(B, SizeOf(Byte));//Тип параметра
    Itm.ParamType := TrpcParamType(B);
    Receiver.ReceiveBuf(B, SizeOf(Byte)); //Длинна имени
    SetLength(Itm.Name, B);
    Receiver.ReceiveBuf(PChar(Itm.Name)^, B); //Имя


    If Itm.ParamType = ptFile Then
      _ReadFile( Itm.DataBuf )
    else
    If Itm.ParamType = ptString Then
      _ReadString( Itm.DataBuf )
    else Begin
      Case Itm.ParamType of
        ptInteger : SetLength(Itm.DataBuf, SizeOf(Integer));
        ptBoolean : SetLength(Itm.DataBuf, SizeOf(Boolean));
        ptFloat   : SetLength(Itm.DataBuf, SizeOf(Double));
        ptDateTime: SetLength(Itm.DataBuf, SizeOf(TDateTime));
        ptGuid    : SetLength(Itm.DataBuf, SizeOf(TGUID));
        else
          Raise ErpcError.Create('Не известный тип "'+IntToStr(Integer(Itm.ParamType))+'" параметра "'+Itm.Name+'"');
      end;
      Receiver.ReceiveBuf(PChar(Itm.DataBuf)^, Length(Itm.DataBuf));
    end;
    Dec(Cnt);
  end;
end;

{ TrpcParamsOut }

procedure TrpcCustomParamsToSend.InnerSetString(const ParamName: String;
  ParamType: TrpcParamType; const Value: String);
begin
  GetOrCreateByName(ParamName, ParamType).DataBuf := Value;
end;

function TrpcCustomParamsToSend.GetOrCreateByName(const ParamName: String; NeedParamType: TrpcParamType): PrpcParam;
var I : Integer;
begin
  I := IndexOf( ParamName );
  If I >= 0 Then Begin

    If Items[i].ParamType <> NeedParamType Then
      Raise ErpcError.Create('Параметр "'+ParamName+'" имеет тип '+GetEnumName(TypeInfo(TrpcParamType), Integer(Items[i].ParamType))+' а не '+GetEnumName(TypeInfo(TrpcParamType), Integer(NeedParamType)))
    else
      Result := Items[i];

  end else Begin
    Result := Add;
    Result.Name := ParamName;
    Result.ParamType := NeedParamType;
  end;
end;

procedure TrpcCustomParamsToSend.SetBoolean(const ParamName: String;
  const Value: Boolean);
var P : PrpcPAram;
begin
  P := GetOrCreateByName(ParamName, ptBoolean);
  SetLength(P.DataBuf, SizeOf(Boolean));
  Move(Value, PChar(P.DataBuf)^, Length(P.DataBuf));
end;

procedure TrpcCustomParamsToSend.SetDateTime(const ParamName: String;
  const Value: TDateTime);
var P : PrpcPAram;
begin
  P := GetOrCreateByName(ParamName, ptDateTime);
  SetLength(P.DataBuf, SizeOf(TDateTime));
  Move(Value, PChar(P.DataBuf)^, Length(P.DataBuf));
end;

procedure TrpcCustomParamsToSend.SetFile(const ParamName: String;
  const Value: TFileName);
begin
  InnerSetString(ParamName, ptFile, Value);
end;

procedure TrpcCustomParamsToSend.SetFloat(const ParamName: String;
  const Value: Double);
var P : PrpcPAram;
begin
  P := GetOrCreateByName(ParamName, ptFloat);
  SetLength(P.DataBuf, SizeOf(Double));
  Move(Value, PChar(P.DataBuf)^, Length(P.DataBuf));
end;

procedure TrpcCustomParamsToSend.SetGuid(const ParamName: String;
  const Value: TGuid);
var P : PrpcPAram;
begin
  P := GetOrCreateByName(ParamName, ptGuid);
  SetLength(P.DataBuf, SizeOf(TGUID));
  Move(Value, PChar(P.DataBuf)^, Length(P.DataBuf));
end;

procedure TrpcCustomParamsToSend.SetInteger(const ParamName: String; const Value: Integer);
var P : PrpcPAram;
begin
  P := GetOrCreateByName(ParamName, ptInteger);
  SetLength(P.DataBuf, SizeOf(Integer));
  Move(Value, PChar(P.DataBuf)^, Length(P.DataBuf));
end;

procedure TrpcCustomParamsToSend.SetString(const ParamName, Value: String);
begin
  InnerSetString(ParamName, ptString, Value);
end;

procedure TrpcCustomParamsToSend.WriteTo(Sender: TrpcSocketSender);

  Procedure _WriteFile(const fName : TFileName);
  var S : TFileStream;
      Buf : String;
      L, ReadingLen : Integer;
  Begin
    If FileExists(fName) Then Begin
      S := TFileStream.Create(fName, fmOpenRead);
      Try
        L := S.Size;
        Sender.SendBuf(L, SizeOf(Integer));
        If L >= CrpcMaxFileBufSize Then
          SetLength(Buf, CrpcMaxFileBufSize)
        else
          SetLength(Buf, L);

        S.Position := 0;
        While L > 0 do Begin
          ReadingLen := S.Read(PChar(Buf)^, Length(Buf));
          Sender.SendBuf(PChar(Buf)^, ReadingLen);
          Dec(L, ReadingLen);
        end;
      Finally
        S.Free;
      end;
    end else Begin
      L := 0;
      Sender.SendBuf(L, SizeOf(Integer));
    end;
      //Raise ErpcError.Create('RPC параметр файл "'+fName+'" не найден!');
  end;

  Procedure _WriteString(const S : String);
  var L : Integer;
  Begin
    L := Length(S);
    Sender.SendBuf(L, SizeOf(Integer));
    Sender.SendBuf(PChar(S)^, L);
  end;

var I : Integer;
    B : Byte;
begin
{
<1 Byte ParamsCount>[Param1[ ... ParamN]]
<1 Byte ParamType><1 Byte ParamNameLength><ParamName><ParamData>
}
  B := Count;
  Sender.SendBuf(B, SizeOf(Byte));
  For I := 0 to Count - 1 do Begin
    B := Byte( Items[i].ParamType );
    Sender.SendBuf(B, SizeOf(Byte)); // Тип
    B := Length( Items[i].Name );
    Sender.SendBuf(B, SizeOf(Byte)); //Длина имени
    Sender.SendBuf(PChar(Items[i].Name)^, B); // Имя

    If Items[i].ParamType = ptFile Then
      _WriteFile( Items[i].DataBuf )
    else
    If Items[i].ParamType = ptString Then
      _WriteString( Items[i].DataBuf )
    else Begin
      Sender.SendBuf(PChar(Items[i].DataBuf)^, Length(Items[i].DataBuf));
    end;
  end;
end;

{ TrpcCustomSide }

procedure TrpcCustomSide.CheckInactive;
begin
  If Active Then
    Raise ErpcError.Create('RPC уже активировано!');
end;

procedure TrpcCustomSide.ClearWaitList;
var I : Integer;
    L : TList;
    WI : TrpcCallWaiter;
begin
  L := FWaitList.LockList;
  Try
    For I := L.Count - 1 DownTo 0 do Begin
      WI := L[I];
      L.Delete(I);
      Try
        Try
          Try
            WI.Successful := False;
            WI.ResultParams.ReadAsException(ErpcError.ClassName, 'Выполнение процедуры прервано по закрытию RPC');
          Finally
            WI.WaitEvent.SetEvent;
          end;
        Finally
          WI._Leave;
        end;
      Except
        uSysProc.HandleOnException('RPC принудительная очистка листа ожидания', False);
      end;
    end;
  Finally
    FWaitList.UnlockList;
  end;
end;

procedure TrpcCustomSide.Close;
var OldActive : Boolean;
begin
  OldActive := Active;
  InnerClose;
  FActive := False;

  If OldActive <> Active Then Begin
    {If EventsInMainThread Then
      TThread.Synchronize(Nil, DoRpcChange)
    else}
    //Окно уведомлений уже развушено поэтому только синхронно
    DoRpcChange;
  end;
end;

constructor TrpcCustomSide.Create(AOwner : TComponent);
begin
  Inherited;
  FSyncronizeProcs := TThreadList.Create;
  FProcPul := TThreadList.Create;
  FCallWaiterPul := TThreadList.Create;
  FpSocket := TStringList.Create;
  FWaitList := TThreadList.Create;
  FTimeOut := CrpcDefaultTimeout;
  FEventsInActivatingThread := False;
  SetDefaultSocketParams;
end;

destructor TrpcCustomSide.Destroy;
begin
  Close;
  ClearProcPul;
  ClearCallWaiterPul;
  FWaitList.Free;
  FpSocket.Free;
  FCallWaiterPul.Free;
  FProcPul.Free;
  FSyncronizeProcs.Free;
  inherited;
end;

procedure TrpcCustomSide.DoRpcChange;
begin
  If Assigned(FOnRpcChange) Then
    FOnRpcChange(Self);
end;

procedure TrpcCustomSide.DoExec(const SocketChannel: TrpcSocketHandle;
  AnswerID : Word; const ProcName: String; Params: TrpcParamsOnReceive;
  Out ResultType : Boolean; ResultParams: TrpcParamsToSend);
var S, sClass, sMessage : String;
    //eClass : TClass;
    I : Integer;
    Handled : Boolean;
begin
  ResultType := False;
  If ResultParams <> Nil Then
    ResultParams.Clear;
  Try
    DoRpcNeedExecute(SocketChannel, ProcName, Params, ResultParams, AnswerID, Handled);
    If Handled Then
      ResultType := True
    else
    If ResultParams <> Nil Then Begin
      ResultParams.Clear;
      ResultParams.SetString(CrpcResultExceptionClass, ErpcError.ClassName);
      ResultParams.SetString(CrpcResultExceptionMessage, 'Вызов неизвестной процедуры '+ProcName);
    end;
  Except
    //uSysProc.DecodeLastException(eClass, sClass, sMessage);
    S := uSysProc.HandleOnException('Ошибка выполнения удаленной процедуры "'+ProcName+'" текст ошибки отослан вызывающей стороне!', False);
    //Вот такой ненавязчивый парсинг
    If ResultParams <> Nil Then Begin
      Try
        I := 1;
        While (I <= Length(S)) and (S[I] <> #13) do Inc(I);
        If I < Length(S) Then Begin
          sClass := Copy(S, 1, I-1);
          Inc(I);
          While (I <= Length(S)) and (S[I] <> #13) do Inc(I);
          If I < Length(S) Then
            sMessage := Copy(S, I+1, MaxInt)
          else
            sMessage := Copy(S, Length(sClass)+1, MaxInt);
        end else Begin
          sClass := '';
          sMessage := S;
        end;
      Except
        sClass := '';
        sMessage := S;
      end;

      ResultParams.Clear;
      ResultParams.SetString(CrpcResultExceptionClass, sClass);
      ResultParams.SetString(CrpcResultExceptionMessage, sMessage);
    end;
  end;
end;

procedure TrpcCustomSide.InnerClose;
begin
  Try
   FreeAndNil(FAsynchronCaller);
  Except
    uSysProc.HandleOnException('RPC разрушение пула вызывающих потоков' , False);
  end;

  Try
    FreeAndNil(FProcExecuter);
  Except
    uSysProc.HandleOnException('RPC разрушение пула исполняющих потоков' , False);
  end;
  ClearWaitList;

  Try
    FreeAndNil(FChangeListener);
    DestroyWnd;
  Except
    uSysProc.HandleOnException('RPC разрушение потока прослушивания изменений сокетного канала связи' , False);
  end;
end;

procedure TrpcCustomSide.InnerOpen;
begin
  If EventsInActivatingThread Then Begin

    If FChangeListener <> Nil Then
      Try
        FreeAndNil(FChangeListener);
      Except
      end;

    CreateWnd;
  end else Begin

    If FChangeListener = Nil Then Begin
      DestroyWnd;
      FChangeListener := TrpcChangeListener.Create(Self);
    end;

  end;

  If FProcExecuter = Nil Then
    FProcExecuter := TrpcProcExecuter.Create(Self);

  If FAsynchronCaller = Nil Then
    FAsynchronCaller := TrpcAsynchronCaller.Create(Self);
end;

procedure TrpcCustomSide.OnBeginThread;
begin
  If Assigned( FOnBeginExecuteThread ) Then
    FOnBeginExecuteThread(Self)
end;

procedure TrpcCustomSide.OnEndThread;
begin
  If Assigned( FOnEndExecuteThread ) Then
    FOnEndExecuteThread(Self)
end;

procedure TrpcCustomSide.Open;
begin
  If Active Then
    Close;

  InnerOpen;
  FActive := True;

  //PostMessage(WndChangeListener, uRpcSocket.rpcSocket_ChangeReady, 0, 0);
  DoRpcChange; //Можно и асинхронно послать но ради единообразия с Close

  {If EventsInMainThread Then
    TThread.Synchronize(Nil, DoRpcChange)
  else
    DoRpcChange;}
end;

procedure TrpcCustomSide.SetActive(const Value: Boolean);
begin
  If FActive <> Value Then Begin
    If VAlue Then
      Open
    else
      Close;
  end;
end;

procedure TrpcCustomSide.SetEventsInActivatingThread(const Value: Boolean);
begin
  CheckInactive;
  FEventsInActivatingThread := Value;
end;

procedure TrpcCustomSide.SetOnRpcChange(const Value: TNotifyEvent);
begin
  CheckInactive;
  FOnRpcChange := Value;
end;

procedure TrpcCustomSide.SetpSocket(const Value: TStrings);
begin
  CheckInactive;
  FpSocket.Assign( Value );
end;

procedure TrpcCustomSide._OnReceive(Receiver: TrpcSocketReceiver);

  Procedure _OnAnsver;
  var I : Integer;
      L : TList;
      WI : TrpcCallWaiter;
      B : Byte;
      eClass : TClass;
      sClass, sMessage : String;
      ReceiveChannelHandle : TrpcSocketHandle;
  Begin
    //<1 Byte ResultType><Params>
    ReceiveChannelHandle := Receiver.Channel.Handle;
    WI := Nil;
    //Try
    L := FWaitList.LockList;
    Try //Ищу в листе ожидания
      I := L.Count - 1;
      While (I>=0) and (WI = Nil) do
        If (TrpcCallWaiter(L[I]).CallID = Receiver.PackID) and
           IsEqualGUID(TrpcCallWaiter(L[I]).ChannelHandle, ReceiveChannelHandle)  Then Begin
          WI := L[I];
          WI._Lock;
          L.Delete(I); //В общем то я мог бы и не выкидывать его из листа все равно его выбросит вызвавший поток
        end else
          Dec(I);
    Finally
      FWaitList.UnlockList;
    end;
    If WI <> Nil Then
      Try
        Try
          Receiver.ReceiveBuf(B, SizeOf(Byte) );
          WI.ResultParams.ReadFrom(Receiver);
          WI.Successful := B = CrpcResultSuccessful;
        Except
          uSysProc.DecodeLastException(eClass, sClass, sMessage);
          WI.ResultParams.ReadAsException(sClass, sMessage);
        end;
      Finally
        WI.WaitEvent.SetEvent; //Активирую процесс который выполнял запрос
        WI._Leave;
      end
    else
      RAise ErpcError.Create('RPC Запрос с идентификатором "'+IntToStr(Receiver.PackID)+'" отсутствует в листе ожидания!');
    //Finally
    //  If WI <> Nil Then
    //    WI._Leave; //Вот теперь Разблокирую
    //end;
  end;

  Procedure _OnExec(const AnsverID : Word);
  var  B : Byte;
       ProcName : String;
       Params : TrpcParamsOnReceive;
  Begin
    //<1 Byte ProcNameLength><ProcName><Params>
    Receiver.ReceiveBuf(B, SizeOf(Byte) );
    SetLength(ProcName, B);
    Receiver.ReceiveBuf(PChar(ProcName)^, B);
    Params := TrpcParamsOnReceive.Create;
    Try
      Params.ReadFrom(Receiver);
      FProcExecuter.ExecuteProc(Receiver.Channel.Handle, AnsverID, ProcName, Params);
    Except
      Params.Free;
      Raise;
    end;
  end;

begin
  If Receiver.PackType = sptAppDataQuery Then  //Запрос
    _OnExec(Receiver.PackID)
  else
  If Receiver.PackType = spt_AppDataAnswer Then //Ответ на запрос
    _OnAnsver
  else
  If (Receiver.PackType = sptAppDataPost) Then Begin
    If Receiver.PackID = CrpcNotifyPackFormatID Then //Стандартное уведомление
      _OnExec(0);
  end;
end;

Procedure TrpcCustomSide.CheckValidNewCallId(Sender : TrpcSocketSender; NewPackID : Word; Out Valid : Boolean);
var L : TList;
    I : Integer;
    H : TrpcSocketHandle;
Begin
  Valid := True;
  H := Sender.Channel.Handle;
  L := FWaitList.LockList;
  try
    I := L.Count - 1;
    While (I>=0) and Valid do Begin
      Valid := not ( (TrpcCallWaiter(L[I]).CallID = NewPackID) and
        IsEqualGUID(TrpcCallWaiter(L[I]).ChannelHandle, H));
      Dec(I);
    end;
  finally
    FWaitList.UnlockList;
  end;
end;

Procedure TrpcCustomSide.DoNotify(const SocketChannel: TrpcSocketHandle; Proc: TrpcProc; const IsTerminate : TtmIsTerminateProc);
var C : TrpcSocketCustomChannel;
    S : TrpcSocketSender;
    B : Byte;
Begin
  C := InnerEnterChannel(SocketChannel);
  If C <> Nil Then
    Try
      If Assigned(IsTerminate) and IsTerminate Then
        Raise ErpcTimeOutError.Create('Удаленная процедура '+Proc.Name+' не вызывалась. Вызывающий поток был Terminated!');

      S := C.BeginPostData(CrpcNotifyPackFormatID);
      Try
        //<1 Byte ProcNameLength><ProcName><Params>
        B := Length(Proc.Name);
        S.SendBuf(B, SizeOf(Byte));
        S.SendBuf(PChar(Proc.Name)^, B);
        Proc.Params.WriteTo(S);
        S.CommitSend;
      Except
        S.RollbackSend;
        RAise;
      end;
    Finally
      InnerLeaveChannel(C);
    end
  else
    Raise ErpcError.Create('Не могу выполнить удаленную процедуру '+Proc.Name+' канал связи не готов!');
end;

function TrpcCustomSide.DoQuery(const SocketChannel: TrpcSocketHandle; Proc: TrpcProc; CallTimeOut : Cardinal; const IsTerminate : TtmIsTerminateProc; Out Successful : Boolean): TrpcParamsOnReceive;
var WI : TrpcCallWaiter;
    C : TrpcSocketCustomChannel;
    S : TrpcSocketSender;
    B : Byte;
    WaitRes : TWaitResult;
    I : Integer;
begin
  Successful := False;
  WI := Proc.GetWaitItem;
  WI.WaitEvent.ResetEvent;
  WI.Successful := False;
  WI.ResultParams.Clear;
  WI.ChannelHandle := SocketChannel;
  //WI.CallID := 0; //Пока намеренно присватваю Invalid-ный CallID
  Result := WI.ResultParams;
  Try
    C := InnerEnterChannel(SocketChannel);
    If C <> Nil Then
      Try
        If Assigned(IsTerminate) and IsTerminate Then
          Raise ErpcTimeOutError.Create('Удаленная процедура '+Proc.Name+' не вызывалясь. Вызывающий поток был Terminated!');

        S := C.BeginQuery(CheckValidNewCallId);
        Try
          //<1 Byte ProcNameLength><ProcName><Params>
          B := Length(Proc.Name);
          S.SendBuf(B, SizeOf(Byte));
          S.SendBuf(PChar(Proc.Name)^, B);
          Proc.Params.WriteTo(S);
          WI.CallID := S.PackID;
          FWaitList.Add(WI);
          S.CommitSend;
        Except
          S.RollbackSend;
          RAise;
        end;
      Finally
        InnerLeaveChannel(C);
      end
    else
      Raise ErpcError.Create('Не могу выполнить удаленную процедуру '+Proc.Name+' канал связи не готов!');

    If CallTimeOut <= 0 Then
      CallTimeOut := Self.TimeOut;

    If Assigned(IsTerminate) Then Begin
      //Не блокирующее ожидание
      If FAsynchronCaller.DestroyTimeOut < CallTimeOut Then Begin
        I := Round(CallTimeOut / (FAsynchronCaller.DestroyTimeOut / 100));
        CallTimeOut := Round(FAsynchronCaller.DestroyTimeOut / 100) + 1;
      end else Begin
        I := 100;
        CallTimeOut := Round(CallTimeOut / 100) + 1;
      end;
      Repeat
        WaitRes := WI.WaitEvent.WaitFor(CallTimeOut);
        Dec(I);
      until IsTerminate or (WaitRes <> wrTimeout) or (I<0);

    end else
      WaitRes := WI.WaitEvent.WaitFor(CallTimeOut);

    Case WaitRes of
      wrSignaled : Successful := WI.Successful;
      wrTimeout  :
        Raise ErpcTimeOutError.Create('Истекло время ожидания выполнения удаленной процедуры '+Proc.Name);
      else
        Raise ErpcError.Create('Ошибка ожидания выполнения удаленной процедуры '+Proc.Name);
    end;
  Finally
    FWaitList.Remove(WI);
  end;
end;

procedure TrpcCustomSide.ClearProcPul;
var L : TList;
    I : Integer;
    P : TrpcProc;
begin
  L := FProcPul.LockList;
  Try
    For I := L.Count - 1 DownTo 0 do Begin
      P := TrpcProc(L[I]);
      L.Delete(I);
      P.Free;
    end;
  Finally
    FProcPul.UnlockList;
  end;
end;

function TrpcCustomSide.DoProc: TrpcProc;
var L : TList;
begin
  Result := Nil;
  L := FProcPul.LockList;
  Try
    If L.Count > 0 Then Begin
      Result := TrpcProc(L[0]);
      L.Delete(0);
    end;
  Finally
    FProcPul.UnlockList;
  end;
  If Result = Nil Then
    Result := TrpcProc.Create(Self)
  else
    Result._Lock;
end;

procedure TrpcCustomSide.ClearCallWaiterPul;
var L : TList;
    I : Integer;
    CW : TrpcCallWaiter;
begin
  L := FCallWaiterPul.LockList;
  Try
    For I := L.Count - 1 DownTo 0 do Begin
      CW := TrpcCallWaiter(L[I]);
      L.Delete(I);
      CW.Free;
    end;
  Finally
    FCallWaiterPul.UnlockList;
  end;
end;

procedure TrpcCustomSide.SetTimeOut(const Value: Cardinal);
begin
  CheckInactive;
  FTimeOut := Value;
end;

procedure TrpcCustomSide.SetOnAsynchronResult(
  const Value: TrpcAsynchronProcResult);
begin
  CheckInactive;
  FOnAsynchronResult := Value;
end;

procedure TrpcCustomSide.WndProc(var Msg: TMessage);

  procedure _DoRpcSyncronize;
  var L : TList;
      P : PrpcSyncronizeRec;
  begin
    //Извлеч из очереди синхронную проседуру и выполнить ее
    L := FSyncronizeProcs.LockList;
    Try
      If L.Count > 0 Then Begin
        P := L[ L.Count - 1 ];
        L.Delete(L.Count - 1);
      end else
        P := Nil;
    Finally
      FSyncronizeProcs.UnlockList;
    end;
    If P <> Nil Then
      Try
        P.Proc;
      Finally
        P.Event.SetEvent;
      end;
  end;

begin
  with Msg do
    if Msg = uRpcSocket.rpcSocket_ChangeReady then
      try
        DoRpcChange;
      except
        uSysProc.HandleOnException('RPC Событие на измекнение состояния сокетного канала', False);
      end
    else
    if Msg = Rpc_Syncronize then
      try
        _DoRpcSyncronize;
      except
        uSysProc.HandleOnException('Синхронное выполнение RPC процедуры', False);
      end
    else
      Result := DefWindowProc(WndChangeListener, Msg, wParam, lParam);
end;

procedure TrpcCustomSide.CreateWnd;
begin
  If WndChangeListener = 0 Then
    WndChangeListener := AllocateHWnd( WndProc );
//  InnerSetChangeListener( FWnd );
end;

procedure TrpcCustomSide.DestroyWnd;
begin
  If WndChangeListener <> 0 Then
    Try
      DeallocateHWnd( FWndChangeListener );
    Finally
      WndChangeListener := 0;
    end;
  FSyncronizeProcs.Clear;
end;

procedure TrpcCustomSide.SetWndChangeListener(const Value: HWND);
begin
  FWndChangeListener := Value;
end;

procedure TrpcCustomSide.Syncronize(const Proc: TThreadMethod;
  const IsTerminate: TtmIsTerminateProc; Sender: TtmCustomThreadHolder);
var P : PrpcSyncronizeRec;
    WR : TWaitResult;
    L : TList;
    I : Integer;
    TimeOut : Cardinal;
begin
  New(P);
  Try
    P.Event := TSimpleEvent.Create;
    Try
      P.Event.ResetEvent;
      P.Proc := Proc;
      //Добавить в список синхронных процедур
      FSyncronizeProcs.Add(P);

      PostMessage(WndChangeListener, Rpc_Syncronize, 0, 0);

      If Sender.DestroyTimeOut < Self.TimeOut Then
        TimeOut := Sender.DestroyTimeOut
      else
        TimeOut := Self.TimeOut;
      Repeat
        WR := P.Event.WaitFor( TimeOut div 100 + 1 );
      Until IsTerminate or (WR = wrSignaled);


      If WR <> wrSignaled Then Begin
        L := FSyncronizeProcs.LockList;
        Try //Извлеч из списка синхронных процедур
          I := L.IndexOf(P);
          If I >= 0 Then
            L.Delete(I);
        Finally
          FSyncronizeProcs.UnlockList;
        end;
        //Если проседуры в списке нет значит она в процессе выполнения
        ////////////////////////////вот тогда я в мертвую жду ее завершения
        If I < 0 Then ///////////////////// на самом деле я жду не мертво а половину времени разрушения потому что не понятно что хуже некорректная работа потока или некоректная работа MainThread
          //P.Event.WaitFor( DestroyTimeOut div 2 );
        //Тогда я жертвую памятью ради корректного завершения
          P := Nil;

      end;
    Finally
      If P <> Nil Then
        FreeAndNil(P.Event);
    end;
  Finally
    If P <> Nil Then
      Dispose(P);
  end;
end;

{ TrpcProcExecuter }

{constructor TrpcProcExecuter.Create(RPC: TrpcCustomSide);
begin
  FRPC := RPC;
  Inherited Create;
end;}

{procedure TrpcProcExecuter.DisposeData(var Data: Pointer);
VAR p : PrpcExecItem;
begin
  P := Data;
  Data :=Nil;
  P.Params.Free;
  Dispose(P);
end;

procedure TrpcProcExecuter.DoProcessData(const Data: Pointer; const IsTerminate : TtmIsTerminateProc);

  Function _DoExec(P : PrpcExecItem; ResultParams : TrpcParamsToSend) : Boolean;
  var  MTE : TrpcProcExecuterInMainThread;
  Begin
    If RPC.EventsInActivatingThread Then Begin
      MTE := TrpcProcExecuterInMainThread.Create(RPC, P, ResultParams);
      Try
        RPC.Syncronize(MTE.Exe, IsTerminate, Self);
        //TThread.Synchronize(Nil, MTE.Exe);
        Result := MTE.ResultType;
      Finally
        MTE.Free;
      end;
    end else
      RPC.DoExec(P.SocketChannel, P.ProcName, P.Params, Result, ResultParams);
  end;

var P : PrpcExecItem;
    ResultParams : TrpcParamsToSend;
//    ResultType : Boolean;
    B : Byte;

    S : TrpcSocketSender;
    C : TrpcSocketCustomChannel;
begin
  P := Data;
  If P.AnswerID = 0 Then
    _DoExec(P, Nil)
  else Begin
    ResultParams := TrpcParamsToSend.Create;
    Try
      If _DoExec(P, ResultParams)  Then
        B := CrpcResultSuccessful
      else
        B := CrpcResultException;

      Try
        If IsTerminate Then
          Exit;

        //Пересылаю результат
        C := RPC.InnerEnterChannel(P.SocketChannel);
        If C <> Nil Then
          Try
            S := C.BeginAnswer(P.AnswerID);
            Try
              //  <1 Byte ResultType><Params>
              S.SendBuf(B, SizeOf(Byte) );
              ResultParams.WriteTo( S );
              S.CommitSend;
            Except
              S.RollbackSend;
              Raise
            end;
          Finally
            RPC.InnerLeaveChannel(C);
          end;
      Finally
        ResultParams.DoSendResultFinallyProc( P.ProcName );
      end;
    Finally
      ResultParams.Free;
    end;
  end;
end;

procedure TrpcProcExecuter.ExecuteProc(const SocketChannel: TrpcSocketHandle; AnswerID: Word;
  const ProcName: String; Params: TrpcParamsOnReceive);
var P : PrpcExecItem;
    PS : Integer;
begin
  New(P);
  Try
    P.SocketChannel := SocketChannel;
    P.AnswerID := AnswerID;
    P.ProcName := ProcName;
    P.Params := Params;
    DoWork(P, PS);
  Except
    Dispose(P);
    Raise;
  end;
end;

procedure TrpcProcExecuter.OnBegin;
begin
  inherited;
  RPC.OnBeginThread;
end;

procedure TrpcProcExecuter.OnEnd;
begin
  RPC.OnEndThread;
  inherited;
end;}

{ TrpcChangeListener }

constructor TrpcChangeListener.Create(RPC: TrpcCustomSide);
begin
  FRPC := RPC;
  Inherited Create;
end;

procedure TrpcChangeListener.OnBegin;
begin
  Inherited;
  RPC.OnBeginThread;
  RPC.CreateWnd;
end;

procedure TrpcChangeListener.OnEnd;
begin
  RPC.DestroyWnd;
  FRPC.OnEndThread;
  Inherited;
end;

procedure TrpcChangeListener.OnException;
begin
  uSysProc.HandleOnException('RPC Поток прослушивания измекнений состояния сокетного канала', False);
end;

{ TrpcClientSide }

procedure TrpcClientSide.DoRpcNeedExecute(
  const SenderSocket: TrpcSocketHandle; const ProcName: String;
  Params: TrpcParamsOnReceive; ResultParams: TrpcParamsToSend; AnswerID : Word;
  var Handled: Boolean);
begin
  If Assigned(FOnRpcNeedExecute) Then
    FOnRpcNeedExecute(Self, ProcName,
                      Params, ResultParams, Handled)
  else Begin
    ResultParams.SetString(CrpcResultExceptionClass, ErpcError.ClassName);
    ResultParams.SetString(CrpcResultExceptionMessage, 'Не определен обработчик удаленных процедур на клиентской стороне!');
  end;
end;

function TrpcClientSide.Exec(Proc: TrpcProc;
  TimeOut: Cardinal; const IsTerminate : TtmIsTerminateProc): TrpcParamsOnReceive;
var Sucessful : Boolean;
begin
  If FClientChannel <> Nil Then Begin
    SetRPCCursor;
    Try
      Result := DoQuery(FClientChannel.Handle, Proc, TimeOut, IsTerminate, Sucessful);
    Finally
      RestoreCursor;
    end;
    If not Sucessful Then
      Raise ErpcRemoteError.Create(Result.GetString(CrpcResultExceptionClass)+' с сообщением: '+Result.GetString(CrpcResultExceptionMessage) );
  end else
    Raise ErpcError.Create('RPC не готов!');
end;

procedure TrpcClientSide.ExecA(Proc: TrpcProc; const AsyncronCallHandle: String; ResultProc: TrpcAsynchronProcResult;
  TimeOut: Cardinal);
begin
  If FClientChannel <> Nil Then Begin
    AsynchronCaller.ExecuteProc(FClientChannel.Handle, Proc, TimeOut, ResultProc, AsyncronCallHandle);
  end else
    Raise ErpcError.Create('RPC не готов!');
end;

function TrpcClientSide.GetReady: Boolean;
begin
  Result := Active and FClientChannel.Ready;
end;

procedure TrpcClientSide.InnerClose;
begin
  If FClientChannel <> Nil Then
    FClientChannel.Close;
  inherited;
  Try
    FreeAndNil( FClientChannel );
  Except
    uSysProc.HandleOnException('Разрушение сокетного канала связи клиента', False);
  end;
end;

function TrpcClientSide.InnerEnterChannel(
  const SocketChannel: TrpcSocketHandle): TrpcSocketCustomChannel;
begin
  If IsEqualGUID(SocketChannel, FClientChannel.Handle) and
     FClientChannel.Ready Then
   Result := FClientChannel
 else
   Result := Nil;
end;

procedure TrpcClientSide.InnerLeaveChannel(
  var Channel: TrpcSocketCustomChannel);
begin
  Channel := Nil;
end;

procedure TrpcClientSide.InnerOpen;
begin
  If FClientChannel = Nil Then
    FClientChannel := TrpcSocketClientChannel.Create;
  uPublishedOperations.StringsToObjectProps(pSocket, FClientChannel, uSysProc.HandleOnException);
  uPublishedOperations.ObjectPropsToStrings(FClientChannel, pSocket);
  FClientChannel.EventReceiver := WndChangeListener;
  FClientChannel.OnReceive := _OnReceive;
  inherited;
  FClientChannel.Open;
end;

procedure TrpcClientSide.SetWndChangeListener(const Value: HWND);
begin
  Inherited;
  If FClientChannel <> Nil Then
    FClientChannel.EventReceiver := Value;
end;

procedure TrpcClientSide.SetDefaultSocketParams;
var T : TObject;
Begin
  If _DefaultSocketClientChannelProps = '' Then
    Try
      T := TrpcSocketClientChannel.Create;
      Try
        _DefaultSocketClientChannelProps := uPublishedOperations.ObjectPropsToStr(T);
      Finally
        T.Free;
      end;
    Except
    end;
  pSocket.CommaText := _DefaultSocketClientChannelProps;
end;

function TrpcClientSide.GetChannelHandle: TrpcSocketHandle;
begin
  Result := FClientChannel.Handle;
end;

{ TrpcServerSide }

procedure TrpcCustomServerSide.ChannelsList(Dest: TrpcSocketChannelsList);
begin
  If Active Then
    FServerHolder.ChannelsList(Dest);
end;

procedure TrpcCustomServerSide.DoRpcNeedExecute(
  const SenderSocket: TrpcSocketHandle; const ProcName: String;
  Params: TrpcParamsOnReceive; ResultParams: TrpcParamsToSend; AnswerID : Word;
  var Handled: Boolean);
begin
  If Assigned(FOnRpcNeedExecute) Then
    FOnRpcNeedExecute(Self, SenderSocket, ProcName,
                      Params, ResultParams, Handled)
  else Begin
    ResultParams.SetString(CrpcResultExceptionClass, ErpcError.ClassName);
    ResultParams.SetString(CrpcResultExceptionMessage, 'Не определен обработчик удаленных процедур на серверной стороне!');
  end;
end;

function TrpcCustomServerSide.Exec(Proc: TrpcProc; Channel: TrpcSocketHandle;
  TimeOut: Cardinal; const IsTerminate : TtmIsTerminateProc): TrpcParamsOnReceive;
var Sucessful : Boolean;
begin
  SetRPCCursor;
  Try
    Result := DoQuery(Channel, Proc, TimeOut, IsTerminate, Sucessful);
  Finally
    RestoreCursor;
  end;
  If not Sucessful Then
    Raise ErpcRemoteError.Create(Result.GetString(CrpcResultExceptionClass)+' с сообщением:'+Result.GetString(CrpcResultExceptionMessage) );
end;

procedure TrpcCustomServerSide.ExecA(Proc: TrpcProc; Channel: TrpcSocketHandle;
  const AsyncronCallHandle: String; ResultProc: TrpcAsynchronProcResult;
  TimeOut: Cardinal);
begin
  AsynchronCaller.ExecuteProc(Channel, Proc, TimeOut, ResultProc, AsyncronCallHandle);
end;

procedure TrpcCustomServerSide.InnerClose;
begin
  If FServerHolder <> Nil Then
    FServerHolder.Close;
  inherited;
  Try
    FreeAndNil(FServerHolder);
  Except
    uSysProc.HandleOnException('Разрушение сокетных каналов связи сервера', False);
  end;
end;

function TrpcCustomServerSide.InnerEnterChannel(
  const SocketChannel: TrpcSocketHandle): TrpcSocketCustomChannel;
begin
  If (FServerHolder <> Nil) Then
    Result := FServerHolder.ChannelEnter(SocketChannel)
  else
    Result := Nil;
end;

procedure TrpcCustomServerSide.InnerLeaveChannel(var Channel: TrpcSocketCustomChannel);
begin
  Try
    (Channel as TrpcSocketServerChannel).Leave;
  Finally
    Channel := Nil;
  end;
end;

procedure TrpcCustomServerSide.InnerOpen;
begin
  If FServerHolder = Nil Then
    FServerHolder := CreateHolder;
  uPublishedOperations.StringsToObjectProps(pSocket, FServerHolder, uSysProc.HandleOnException);
  uPublishedOperations.ObjectPropsToStrings(FServerHolder, pSocket);
  FServerHolder.EventReceiver := WndChangeListener;
  FServerHolder.OnReceive := _OnReceive;
  inherited;
  FServerHolder.Open;
end;

procedure TrpcCustomServerSide.SetWndChangeListener(const Value: HWND);
begin
  Inherited;
  If FServerHolder <> Nil Then
    FServerHolder.EventReceiver := Value;
end;

procedure TrpcCustomServerSide.SetDefaultSocketParams;
var T : TObject;
Begin
  //If _DefaultSocketServerChannelHolderProps = '' Then
    Try
      T := CreateHolder;
      Try
        //_DefaultSocketServerChannelHolderProps := uPublishedOperations.ObjectPropsToStr(T);
        pSocket.CommaText := uPublishedOperations.ObjectPropsToStr(T);
      Finally
        T.Free;
      end;
    Except
    end;
  //pSocket.CommaText := _DefaultSocketServerChannelHolderProps;
end;

{ TrpcServerSide }

function TrpcServerSide.CreateHolder: TrpcCustomServerChannelHolder;
begin
  Result := TrpcSocketServerChannelHolder.Create;
end;

{ TrpcAsynchronCaller }

Type
  PrpcAsyncronCallItem = ^TrpcAsyncronCallItem;
  TrpcAsyncronCallItem = Record
    ChannelHandle : TrpcSocketHandle;
    Proc : TrpcProc;
    TimeOut : Cardinal;
    ResultProc : TrpcAsynchronProcResult;
    CallHandle : String;
  end;

constructor TrpcAsynchronCaller.Create(RPC: TrpcCustomSide);
begin
  FRPC := RPC;
  Inherited Create;
end;

procedure TrpcAsynchronCaller.DisposeData(var Data: Pointer);
var P : PrpcAsyncronCallItem;
begin
  P := Data;
  P.Proc.Leave;
  P.Proc := Nil;
  Dispose(P)
end;

Type
  TrpcResultProcExecuterInMAinThread = class(TObject)
  Private
    FResultProc : TrpcAsynchronProcResult;
    FCallHandle : String;
    FSuccessful : Boolean;
    FRes : TrpcParamsOnReceive;
  Protected
  Public
    Constructor Create(ResultProc : TrpcAsynchronProcResult; const CallHandle : String; Successful : Boolean; Res : TrpcParamsOnReceive);
    Procedure ExecResult;
  end;

  constructor TrpcResultProcExecuterInMAinThread.Create(
    ResultProc: TrpcAsynchronProcResult; const CallHandle: String;
    Successful: Boolean; Res: TrpcParamsOnReceive);
  begin
    Inherited Create;
    FResultProc := ResultProc;
    FCallHandle := CallHandle;
    FSuccessful := Successful;
    FRes        := Res;
  end;

  procedure TrpcResultProcExecuterInMAinThread.ExecResult;
  begin
    FResultProc(FCallHandle, FSuccessful, FRes);
  end;


procedure TrpcAsynchronCaller.DoProcessData(const Data: Pointer; const IsTerminate : TtmIsTerminateProc);

  Procedure _CallResultProc(const ResultProc: TrpcAsynchronProcResult; const CallHandle: String;
    Successful: Boolean; Res: TrpcParamsOnReceive);
  var Obj : TrpcResultProcExecuterInMAinThread;
  Begin
    If not IsTerminate Then Begin
      If RPC.EventsInActivatingThread Then Begin
        Obj := TrpcResultProcExecuterInMAinThread.Create(ResultProc, CallHandle, Successful, Res);
        Try
          RPC.Syncronize(Obj.ExecResult, IsTerminate, Self);
          //TThread.Synchronize(Nil, Obj.ExecResult);
        Finally
          Obj.Free;
        end;
      end else
        ResultProc(CallHandle, Successful, Res);
    end;
  end;

var P : PrpcAsyncronCallItem;
    Res : TrpcParamsOnReceive;
    Successful : Boolean;
    ResultProc: TrpcAsynchronProcResult;
begin
  P := Data;
  ResultProc := P.ResultProc;
  If not Assigned(ResultProc) Then
    ResultProc := RPC.FOnAsynchronResult;
  If Assigned(ResultProc) Then Begin
    Successful := False;
    Try
      If not IsTerminate Then
        Res := RPC.DoQuery(P.ChannelHandle, P.Proc, P.TimeOut, IsTerminate, Successful)
      else
        Exit;
    Except
      _CallResultProc(ResultProc, P.CallHandle, False, Nil);
      RAise;
    end;
    _CallResultProc(ResultProc, P.CallHandle, Successful, Res);
  end else
  If not IsTerminate Then
    RPC.DoNotify(P.ChannelHandle, P.Proc, IsTerminate);
end;

procedure TrpcAsynchronCaller.ExecuteProc(ChannelHandle: TrpcSocketHandle;
                                       Proc : TrpcProc;  TimeOut : Cardinal;
           ResultProc: TrpcAsynchronProcResult; const AsyncronCallHandle: String);
var P : PrpcAsyncronCallItem;
    PS : Integer;
begin
  Proc._Lock;
  Try
    New(P);
    Try
      P.ChannelHandle := ChannelHandle;
      P.Proc := Proc;
      P.TimeOut := TimeOut;
      P.ResultProc := ResultProc;
      P.CallHandle := AsyncronCallHandle;
      DoWork(P, PS);
      // Хотя это и заманчиво но возвращать HAndle я не могу
      //тк теоретически его могут получить позже чем отработает удаленная процедура и вызовется результирующая процедура
      //AsyncronCallHandle := Integer(P);
    Except
      dispose(P);
      Raise;
    end;
  Except
    Proc.Leave;
    Raise
  end;
end;

procedure TrpcAsynchronCaller.OnBegin;
begin
  inherited;
  RPC.OnBeginThread;
end;

procedure TrpcAsynchronCaller.OnEnd;
begin
  RPC.OnEndThread;
  inherited;
end;

{ TrpcProc }

procedure TrpcProc._Lock;
begin
  Windows.InterlockedIncrement(FRefCount);
end;

constructor TrpcProc.Create(RPC : TrpcCustomSide);
begin
  Inherited Create;
  FRPC := RPC;
  FParams := TrpcParamsToCall.Create;
  FWaits := TThreadList.Create;

  _Lock;
end;

destructor TrpcProc.Destroy;
begin
  FWaits.Free;
  FParams.Free;
  Inherited;
end;

procedure TrpcProc.Leave;
var L : TList;
    I : Integer;
    WI : TrpcCallWaiter;
begin
  If Windows.InterlockedDecrement(FRefCount) <= 0 Then
    Try
      FParams.Clear;
      FName := '';
      L := FWaits.LockList;
      Try
        For I := L.Count - 1 DownTo 0 do Begin
          WI := TrpcCallWaiter(L[i]);
          L.Delete(I);
          WI._Leave;
        end;
      Finally
        FWaits.UnlockList;
      end;

      RPC.FProcPul.Add(Self);
    Except
      Destroy; //Если что то пошло не так просто разваливаю объект
      Raise;
    end;
end;

procedure TrpcProc.SetName(const Value: String);
begin
  FName := Value;
end;

function TrpcProc.GetWaitItem: TrpcCallWaiter;
var L : TList;
begin
  Result := Nil;
  L := RPC.FCallWaiterPul.LockList;
  Try
    If L.Count > 0 Then Begin
      Result := TrpcCallWaiter(L[0]);
      L.Delete(0);
    end;
  Finally
    RPC.FCallWaiterPul.UnlockList;
  end;
  If Result = Nil Then
    Result := TrpcCallWaiter.Create(RPC)
  else
    Result._Lock;

  FWaits.Add(Result);
end;

{ TrpcCallWaiter }

procedure TrpcCallWaiter._Lock;
begin
  InterlockedIncrement( FRefCount )
end;

constructor TrpcCallWaiter.Create(RPC : TrpcCustomSide);
begin
  Inherited Create;
  FRPC := RPC;
  FWaitEvent := TSimpleEvent.Create;
  FResultParams := TrpcParamsOnReceive.Create;
  _Lock;
end;

destructor TrpcCallWaiter.Destroy;
begin
  FResultParams.Free;
  FWaitEvent.Free;
  inherited;
end;

procedure TrpcCallWaiter._Leave;
begin
  If InterlockedDecrement( FRefCount )<=0 Then Begin
    Try
      ResultParams.Clear;
      RPC.FCallWaiterPul.Add(Self);
    Except
      Destroy;
      raise
    end;
  end;
end;

{ TrpcCustomWorkPool }

{constructor TrpcCustomWorkPool.Create(RPC: TrpcCustomSide);
begin
  FRPC := RPC;
  Inherited Create;
end;

procedure TrpcCustomWorkPool.rpcSyncronize(const Proc : TThreadMethod; const IsTerminate : TtmIsTerminateProc);
var P : PrpcSyncronizeRec;
    WR : TWaitResult;
    L : TList;
    I : Integer;
    TimeOut : Cardinal;
begin
  New(P);
  Try
    P.Event := TSimpleEvent.Create;
    Try
      P.Event.ResetEvent;
      P.Proc := Proc;
      //Добавить в список синхронных процедур
      RPC.FSyncronizeProcs.Add(P);

      PostMessage(RPC.WndChangeListener, Rpc_Syncronize, 0, 0);

      If DestroyTimeOut < RPC.TimeOut Then
        TimeOut := DestroyTimeOut
      else
        TimeOut := RPC.TimeOut;
      Repeat
        WR := P.Event.WaitFor( TimeOut div 100 + 1 );
      Until IsTerminate or (WR = wrSignaled);


      If WR <> wrSignaled Then Begin
        L := RPC.FSyncronizeProcs.LockList;
        Try //Извлеч из списка синхронных процедур
          I := L.IndexOf(P);
          If I >= 0 Then
            L.Delete(I);
        Finally
          RPC.FSyncronizeProcs.UnlockList;
        end;
        //Если проседуры в списке нет значит она в процессе выполнения
        ////////////////////////////вот тогда я в мертвую жду ее завершения
        If I < 0 Then ///////////////////// на самом деле я жду не мертво а половину времени разрушения потому что не понятно что хуже некорректная работа потока или некоректная работа MainThread
          //P.Event.WaitFor( DestroyTimeOut div 2 );
        //Тогда я жертвую памятью ради корректного завершения
          P := Nil;

      end;
    Finally
      If P <> Nil Then
        FreeAndNil(P.Event);
    end;
  Finally
    If P <> Nil Then
      Dispose(P);
  end;
end;}

{ TrpcParamsToSend }

procedure TrpcParamsToSend.DoSendResultFinallyProc(const ProcName: String);
begin
  If Assigned(FSendResultFinallyProc) Then
    Try
      FSendResultFinallyProc(ProcName, Self);
    Except
      uSysProc.HandleOnException('Выполнение завершающей операции после отсылки результата PRC процедуры "'+ProcName+'"');
    end;
end;

{ TrpcProcExecuter }

Type
  PrpcExecItem = ^TrpcExecItem;
  TrpcExecItem = Record
    SocketChannel : TrpcSocketHandle;
    AnswerID : Word;
    ProcName : String;
    Params : TrpcParamsOnReceive;
  end;

  TrpcProcExecuterInMainThread = class(TObject)
  private
    FResultParams : TrpcParamsToSend;
    FData : PrpcExecItem;
    FRPC : TrpcCustomSide;
    FResultType: Boolean;
  Public
    Constructor Create(RPC : TrpcCustomSide; Data : PrpcExecItem; ResultParams : TrpcParamsToSend);
    Procedure Exe;
    Property ResultType : Boolean Read FResultType;
  end;

  Procedure TrpcProcExecuterInMainThread.Exe;
  Begin
    FRPC.DoExec(FData.SocketChannel, FData.AnswerID, FData.ProcName, FData.Params, FResultType, FResultParams);
  end;

  Constructor TrpcProcExecuterInMainThread.Create(RPC : TrpcCustomSide; Data : PrpcExecItem; ResultParams : TrpcParamsToSend);
  Begin
    Inherited Create;
    FData := Data;
    FRPC := RPC;
    FResultParams := ResultParams;
  end;

constructor TrpcProcExecuter.Create(RPC: TrpcCustomSide);
begin
  Inherited Create;
  FRPC := RPC;
  If RPC.EventsInActivatingThread Then
    FCore := TrpcProcExecuterAsQueue.Create(Self)
  else
    FCore := TrpcProcExecuterAsWorkPool.Create(Self);
end;

destructor TrpcProcExecuter.Destroy;
begin
  FCore.Free;
  inherited;
end;

procedure TrpcProcExecuter.DisposeData(var Data: Pointer);
VAR p : PrpcExecItem;
begin
  P := Data;
  Data :=Nil;
  P.Params.Free;
  Dispose(P);
end;

procedure TrpcProcExecuter.DoProcessData(const Data: Pointer;
  const IsTerminate: TtmIsTerminateProc);

  Function _DoExec(P : PrpcExecItem; ResultParams : TrpcParamsToSend) : Boolean;
  var  MTE : TrpcProcExecuterInMainThread;
  Begin
    If RPC.EventsInActivatingThread Then Begin
      MTE := TrpcProcExecuterInMainThread.Create(RPC, P, ResultParams);
      Try
        RPC.Syncronize(MTE.Exe, IsTerminate, FCore);
        //TThread.Synchronize(Nil, MTE.Exe);
        Result := MTE.ResultType;
      Finally
        MTE.Free;
      end;
    end else
      RPC.DoExec(P.SocketChannel, P.AnswerID, P.ProcName, P.Params, Result, ResultParams);
  end;

var P : PrpcExecItem;
    ResultParams : TrpcParamsToSend;
//    ResultType : Boolean;
    B : Byte;

    S : TrpcSocketSender;
    C : TrpcSocketCustomChannel;
begin
  P := Data;
  If P.AnswerID = 0 Then
    _DoExec(P, Nil)
  else Begin
    ResultParams := TrpcParamsToSend.Create;
    Try
      If _DoExec(P, ResultParams)  Then
        B := CrpcResultSuccessful
      else
        B := CrpcResultException;

      Try
        If IsTerminate Then
          Exit;

        //Пересылаю результат
        C := RPC.InnerEnterChannel(P.SocketChannel);
        If C <> Nil Then
          Try
            S := C.BeginAnswer(P.AnswerID);
            Try
              //  <1 Byte ResultType><Params>
              S.SendBuf(B, SizeOf(Byte) );
              ResultParams.WriteTo( S );
              S.CommitSend;
            Except
              S.RollbackSend;
              Raise
            end;
          Finally
            RPC.InnerLeaveChannel(C);
          end;
      Finally
        ResultParams.DoSendResultFinallyProc( P.ProcName );
      end;
    Finally
      ResultParams.Free;
    end;
  end;
end;

procedure TrpcProcExecuter.ExecuteProc(
  const SocketChannel: TrpcSocketHandle; AnswerID: Word;
  const ProcName: String; Params: TrpcParamsOnReceive);
var P : PrpcExecItem;
    PS : Integer;
begin
  New(P);
  Try
    P.SocketChannel := SocketChannel;
    P.AnswerID := AnswerID;
    P.ProcName := ProcName;
    P.Params := Params;
    //DoWork(P, PS);

    If FCore Is TrpcProcExecuterAsQueue Then
      (FCore as TrpcProcExecuterAsQueue).Queue.AddQueueItem(P)
    else
    If FCore Is  TrpcProcExecuterAsWorkPool Then
      (FCore as TrpcProcExecuterAsWorkPool).DoWork(P, PS)
    else
      Raise ErpcError.Create('Unknown rpcProcExecuter.FCore type!');
  Except
    Dispose(P);
    Raise;
  end;
end;

procedure TrpcProcExecuter.OnBegin;
begin
  RPC.OnBeginThread;
end;

procedure TrpcProcExecuter.OnEnd;
begin
  RPC.OnEndThread;
end;

{ TrpcProcExecuterAsQueue }

constructor TrpcProcExecuterAsQueue.Create(Wrap: TrpcProcExecuter);
begin
  FWrap := Wrap;
  Inherited Create;
end;

procedure TrpcProcExecuterAsQueue.DisposeItem(var Item: Pointer);
begin
  Wrap.DisposeData(Item);
end;

procedure TrpcProcExecuterAsQueue.DoProcessItem(const Item: Pointer);
begin
  Wrap.DoProcessData(Item, IsTerminate);
end;

function TrpcProcExecuterAsQueue.IsTerminate: Boolean;
begin
  Result := Queue.Terminated;
end;

procedure TrpcProcExecuterAsQueue.OnBegin;
begin
  inherited;
  Wrap.OnBegin;
end;

procedure TrpcProcExecuterAsQueue.OnEnd;
begin
  inherited;
  Wrap.OnEnd;
end;

{ TrpcProcExecuterAsWorkPool }

constructor TrpcProcExecuterAsWorkPool.Create(Wrap: TrpcProcExecuter);
begin
  FWrap := Wrap;
  Inherited Create;
end;

procedure TrpcProcExecuterAsWorkPool.DisposeData(var Data: Pointer);
begin
  Wrap.DisposeData(Data);
end;

procedure TrpcProcExecuterAsWorkPool.DoProcessData(const Data: Pointer;
  const IsTerminate: TtmIsTerminateProc);
begin
  Wrap.DoProcessData(Data, IsTerminate);
end;

procedure TrpcProcExecuterAsWorkPool.OnBegin;
begin
  Inherited;
  Wrap.OnBegin;
end;

procedure TrpcProcExecuterAsWorkPool.OnEnd;
begin
  Inherited;
  Wrap.OnEnd;
end;

Initialization
  uSysProc.SafeThread_InitFileOperation;
end.
