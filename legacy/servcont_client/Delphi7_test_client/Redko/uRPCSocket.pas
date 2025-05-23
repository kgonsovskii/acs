unit uRPCSocket;

  {
  ------------------------------------------------------
  Формат низкоуровневых пакетов пересылаемых через сокет
  ------------------------------------------------------
  <8байт Постоянный префикс пакета>
  <1байт Тип пакета>
  <2байта Идентификатор пакета>
  [<2байта Идентификатор пакета><2байта длинна 1-го блока><Блок данных 1>]
  ...
  [<2байта Идентификатор пакета><2байта длинна N-го блока><Блок данных N>]
  <2байта Идентификатор пакета>
  <2байта Признак завершения пакета>
  <1байт Тип завершения пакета>

     - Постоянный префикс пакета : 'rpc_Sock'

     - Типа пакета : OnConnect|AppData
       OnConnect = 1 - Системный пакет от клиента серверу
                       сразу после установления или восстановления соединения
                         Данные пакета всегда состоят из одного блока
                       длинной 16 байт и содержат логический Handle канала
       AppData  >= 2 - Прикладной пакет от клиента серверу и наоборот.
                         Данные пакета могут состоять из любого числа
                       блоков длинной от 1 - $FFFF байт.

     - Идентификатор пакета :
       Псевдо случайное число в диапазоне 0 - $FFFF

     - длинна блока :
       Два байта указывают длинну следующего за ними блока

     - Блок данных :
       Последовательность байтов длинной равной <длинна блока>

     - Признак завершения пакета : 00
       Два нулевых байта (блок нулевой длинны)

     - Тип завершения пакета : Commit|Rollback
       Commit   = 'C' - Передача пакета успешно завершена
       Rollback = 'R' - Откат пакета


  ----------------------------------------------------------------
    Минимальная длинна пакета не несущего ни какой информации
    8 + 1 + 2 + 2 + 2 +1 = 16 байт;

    Накладные расходы при передаче пакета из одного блока составят
    16 + 4 = 20 байт
     + 4 баита на каждый следующий блок.
 }

interface
Uses Classes, SysUtils, SyncObjs, Messages, Windows,
     uThreadManage, uSysProc, WinSock, Types;

const
  rpcSocket_ChangeReady = WM_USER + 11;//wParam = Указатель на канал, в lPAram - Cocтояние готовности

Type

  TrpcSocketHandle = TGUID;
  PrpcSocketHandle = ^TrpcSocketHandle;

  ErpcSocketError = class(Exception);
  ErpcSocketWinSockError = class(ErpcSocketError);
  ErpcSocketPackRollBack = class(ErpcSocketError);
  ErpcSocketConnectionLost = class(ErpcSocketError);

  ErpcError = class(Exception);

  TrpcSocketCustomChannel = class;
  TrpcSocketReceiver = Class;
  TrpcSocketSender = class;

  TrpcSocketPackType = (sptUnknown,
    sptOnConnect,     //Системный пакет соединение
    sptAppDataQuery,  //Запрос с идентификатором PackID
    spt_AppDataAnswer, //Ответ на запрос с идентификатором PackID
    sptAppDataPost);  //Пакетная персылка абстрактных данных Тип пересылаемых данных можно зашифровать в PackId

  TrpcSocketOnReceive = Procedure( Receiver : TrpcSocketReceiver ) Of Object;

  TrpcSocketCheckValidIDProc = Procedure(Sender : TrpcSocketSender; NewPackID : Word; Out Valid : Boolean) Of Object;

  //Отправляльщик пакетов
  //Пакеты отправляются из любого внешнего потока
  //Но по очереди захватывая SocketSender
  TrpcSocketSender = Class(TObject)
  Private
    FSendCrit : TCriticalSection;
    FChannel: TrpcSocketCustomChannel;
    FPackIDIterator,
    FPackID : Word;
    FProgressSend : Boolean;

    FInnerBuf : Array[0..High(Word)] of Byte;
    FInnerBufFreePoint : Pointer; //Указатель на начало свободного места во внутреннем буфере

    Function InnerBufFreeTail : Integer;//Длинна свободного места во внутреннем буфере
    Function InnerBufDataLen : Integer; //Длинна данных во внутреннем буфере
    Procedure InnerBufReset; //Переставить указатель на начало внутреннего буфера

    Procedure CheckProgress;
  Protected
    Procedure BeginSend(const PackType : TrpcSocketPackType; const PackID : Word; CheckValidId : TrpcSocketCheckValidIDProc);
    Procedure Send(const pBlockData : Pointer; const BlockSize : Word);
  Public
    Constructor Create(Channel : TrpcSocketCustomChannel);
    Destructor Destroy; Override;
    Property Channel : TrpcSocketCustomChannel Read FChannel;

    Property PackID : Word Read FPackID;
    //Отправить Блок
    Procedure SendBuf(const Buf; BufLen : Integer);
    //Возвращают посылальщика в исходное состояние и разблокируют функцию BeginSend у канала
    //Завершить передачу пакета подтвердив его корректность
    Procedure CommitSend;
    //Завершить передачу пакета уведомив получателя в некорректности ранее переданных данных
    Procedure RollbackSend;
  end;

  //Задача этого потока пропускать мусор и отлавливать начало пакета
  //Далее он вызывает Event канала для получения пакета
  //По идее сокет читает только этот поток
  TrpcSocketReceiveThread = class(TtmCustomListenerHolder)
  Private
    FReceiver: TrpcSocketReceiver;
    FBuf : Array[1..11] Of Char; //Длинна заголовка пакета
    FBufDataLen : Integer; //Длиина необработанных данных в буфере
  Protected
    Procedure DoListen; Override;
  Public
    Constructor Create(Receiver : TrpcSocketReceiver);
    Property Receiver : TrpcSocketReceiver Read FReceiver;
  end;

  //Принималка пакетов работает исключительно в Receive потоке канала
  TrpcSocketReceiver = Class(TObject)
  Private
    FChannel: TrpcSocketCustomChannel;
    FReceiveThread : TrpcSocketReceiveThread;

    FPackType: TrpcSocketPackType;
    FEof: Boolean;
    FPackID : Word;

    FBlockTailLen : Word;

    Procedure InitNextBlock;
  Protected
    Procedure DoReceivePack(PackID : Word; PackType : TrpcSocketPackType);

    Procedure Thread_Stop; //Остановить принимающий поток
    Procedure Thread_Start; //Активировать принимающий поток
  Public
    Constructor Create(Channel : TrpcSocketCustomChannel);
    Destructor Destroy; Override;
    Property Channel : TrpcSocketCustomChannel Read FChannel;

    Property PackID : Word Read FPackID;
    //Тип Пакета, в прикладной Event попадают пакеты только типа sptAppData
    Property PackType : TrpcSocketPackType Read FPackType;
    //Получить часть пакета размером не более Size при этом в Result - реальное количество полученных байт
    //Если - оборвалась связь
    //     - получен признак отката блока
    //     - не верно инициализирован блок
    //функция завершится c cоответствующим Raise
    Function Receive(const pBuf : Pointer; const BufLen : Integer) : Integer;
    procedure ReceiveBuf(var Buf; BufLen: Integer);
    //Признак полного прочтения пакета возникает при завершении блока данных
    Property Eof : Boolean Read FEof;
  end;

//{$M+}
  TrpcSocketCustomChannel = class(TPersistent{TObject})
  Private
    FSock: TSocket;
    FHandle : TrpcSocketHandle;

    FReadyCrit: TCriticalSection;
    FSender : TrpcSocketSender;
    FReceiver : TrpcSocketReceiver;
    FKeepAliveInterval: Integer;
    FEventReceiver: HWND;

    FJob_Holder : TtmCustomJobHolder;
    FNagleAlgo: Boolean;


    function GetReady: Boolean;
    function GetHandle: TrpcSocketHandle;

    Procedure InitKeepAlive;
    procedure InnerSetNagleAlgo(s: TSocket; const Value: Boolean);
    procedure SetKeepAliveInterval(const Value: Integer);
    procedure SetNagleAlgo(const Value: Boolean);
  Protected
    Property Job_Holder : TtmCustomJobHolder Read FJob_Holder;
    Property Receiver : TrpcSocketReceiver Read FReceiver;
    Property ReadyCrit : TCriticalSection Read FReadyCrit;
    Procedure DoReceive; Virtual; // Для серверного канала добавить обработку Connect Disconnect

    Procedure SetHandle(const Value : TrpcSocketHandle);
    procedure SetSocket(const Value: TSocket);
    function GetSocket(Out S : TSocket) : Boolean; //Истина при валидности сокета


    Procedure DoConnectionLost;
    //Вызывается при потере связи
    // Для клиента активировать процесс восстановления связи
    // Для сервера разрушить канал
    Procedure Job_ConnectionLost(IsTerminate : TtmIsTerminateProc); Virtual;
    //Вызывается при изменении состояния готовности канала
    Procedure DoChangeState; Dynamic;
    //Вызывается при старте прикладного пакета
    Procedure DoReceiveApp; Virtual; Abstract;

    //Окно принимающее извещения о изменении состояния канала
    Property EventReceiver : HWND Read FEventReceiver Write FEventReceiver;

    Property KeepAliveInterval : Integer Read FKeepAliveInterval Write SetKeepAliveInterval;
    property NagleAlgo: Boolean read FNagleAlgo write SetNagleAlgo;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Property Handle : TrpcSocketHandle Read GetHandle;
    Property Ready : Boolean Read GetReady;

    Function BeginQuery(CheckValidId : TrpcSocketCheckValidIDProc = Nil) : TrpcSocketSender;
    Function BeginAnswer(const PackID : Word) : TrpcSocketSender;
    Function BeginPostData(const FormatID : Word) : TrpcSocketSender;

  end;
//{$M-}

  //Клиентский канал связи создается в явном виде приложением клиентом
  TrpcSocketClientChannel = class(TrpcSocketCustomChannel)
  Private
    FActive: Boolean;
    FPort: Word;
    FHost: String;
    FOnReceive: TrpcSocketOnReceive;
    FReconnectInterval: Integer;

    FJob_SockAdr : TSockAddr;
    FJob_WaitEvent : TEvent;

    procedure SetActive(const Value: Boolean);
    procedure SetHost(const Value: String);
    procedure SetPort(const Value: Word);

    Procedure CheckInactive;
    Procedure Job_DoConnect(IsTerminate : TtmIsTerminateProc);
    procedure SetReconnectInterval(const Value: Integer);//Процедура дочернего потока
  Protected
    Procedure Job_ConnectionLost(IsTerminate : TtmIsTerminateProc); Override;
    Procedure DoReceiveApp; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Property Active : Boolean Read FActive Write SetActive;
    Procedure Open;
    Procedure Close;

    Property OnReceive : TrpcSocketOnReceive Read FOnReceive Write FOnReceive;
    Property EventReceiver;
    property NagleAlgo;
  Published
    Property Port : Word Read FPort Write SetPort;
    Property Host : String Read FHost Write SetHost;
    Property KeepAliveInterval;

    //задержка повторной попытки восстановления связи ms
    Property ReconnectInterval : Integer Read FReconnectInterval Write SetReconnectInterval;
  end;

  TrpcSocketChannelsList = class(TObject) //Просто лист хандлов
  Private
    FList : TStringList;
    function GetItems(Index: Integer): TrpcSocketHandle;
    function GetAddress(Index: Integer): String;
  Protected
    Procedure Add(const Handle : TrpcSocketHandle; const Address : String);
    Procedure Clear;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Property Items[Index : Integer] : TrpcSocketHandle Read GetItems; Default;
    Property Address[Index : Integer] : String Read GetAddress;
    Function Count : Integer;
    Function ItemExists(const Handle : TrpcSocketHandle) : Boolean;
  end;

  TrpcCustomServerChannelHolder = class;
  //Серверный канал связи В явном виде НЕ создается
  TrpcSocketServerChannel = class(TrpcSocketCustomChannel)
  Private
    FRefCount: Integer;
    FHolder: TrpcCustomServerChannelHolder;
    FRemoteAddress: String;

    Procedure _AddRef;
  Protected
    Procedure DoReceive; Override; // добавлена обработка Connect
    Procedure DoReceiveApp; Override;
    Procedure Job_ConnectionLost(IsTerminate : TtmIsTerminateProc); Override;
  Public
    Constructor Create(Holder : TrpcCustomServerChannelHolder; Socket : TSocket);
    procedure BeforeDestruction; override;
    Property RemoteAddress : String Read FRemoteAddress;

    Property Holder : TrpcCustomServerChannelHolder Read FHolder;
    //Освободить канал после захвата из холдера функцией ChannelEnter(
    Procedure Leave;
  end;

  TrpcSocketServerChannelHolder = class;
  //Поток создающий серверные каналы
  TrpcSocketServerListener = class( TtmCustomListenerHolder )
  Private
    FListener : TSocket;
    FCrit : TCriticalSection;
    FChannelHolder: TrpcSocketServerChannelHolder;
    Function GetListener(Out Socket : TSocket) : Boolean;
  Protected
    Procedure DoListen; Override;
  Public
    Constructor Create(ChannelHolder : TrpcSocketServerChannelHolder);
    Destructor Destroy; Override;
    Property ChannelHolder : TrpcSocketServerChannelHolder Read FChannelHolder;
  end;

  //Поток разрушитель серверных каналов
  TrpcSocketServerDestroyer = class( TtmCustomQueueHolder )
  Private
  Protected
    Procedure DisposeItem(var Item : Pointer); Override;
    Procedure DoProcessItem(const Item : Pointer); Override;
  Public
    Destructor Destroy; Override;
    Procedure DestroyChannel( Channel : TrpcSocketServerChannel );
  end;

  //Серверный хранитель каналов
  TrpcCustomServerChannelHolder = class(TPersistent{Object})
  Private
    FActive: Boolean;
    FChannels : TList;
    FChannelsCrit : TMultiReadExclusiveWriteSynchronizer;
    FEventReceiver: HWND;
    FKeepAliveInterval: Integer;
    FOnReceive: TrpcSocketOnReceive;
    FDestroyer : TrpcSocketServerDestroyer;
    FNagleAlgo: Boolean;

    procedure SetEventReceiver(const Value: HWND);
    procedure SetKeepAliveInterval(const Value: Integer);
    procedure SetNagleAlgo(const Value: Boolean);
    procedure SetActive(const Value: Boolean);
  Protected
    Procedure InnerOpen; Virtual;
    Procedure InnerClose; Virtual;
  Public
    Constructor Create;
    Destructor Destroy; Override;


    Property Active : Boolean Read FActive Write SetActive;
    Procedure Open;
    Procedure Close;

    //Получить доступ к каналу после работы с каналом обязательно освободить его Leave
    Function ChannelEnter( Handle : TrpcSocketHandle ) : TrpcSocketServerChannel;
    // Получить список Хандлов каналов
    Procedure ChannelsList( Dest : TrpcSocketChannelsList );

    Property OnReceive : TrpcSocketOnReceive Read FOnReceive Write FOnReceive;
    Property EventReceiver : HWND Read FEventReceiver Write SetEventReceiver;
    property NagleAlgo: Boolean read FNagleAlgo write SetNagleAlgo;
  Published
    //Интервал проверки живучести соединения в ms
    Property KeepAliveInterval : Integer Read FKeepAliveInterval Write SetKeepAliveInterval;
  end;

  //Создается в явном виде серверным приложением открывающим порт на прослушку
  TrpcSocketServerChannelHolder = class(TrpcCustomServerChannelHolder)
  Private
    FPort: Integer;
    FListener : TrpcSocketServerListener;

    procedure SetPort(const Value: Integer);
  Protected
    Procedure InnerOpen; Override;
    Procedure InnerClose; Override;
  Public
    Constructor Create;
  Published
    //Порт прослушивания к которому будут цепляться клиенты
    Property Port : Integer Read FPort Write SetPort;
  end;




const
  MAX_PROTOCOL_CHAIN = 7;
  WSAPROTOCOL_LEN    = 255;

type
  TWSAProtocolChain = record
    ChainLen: Integer;  // the length of the chain,
    // length = 0 means layered protocol,
    // length = 1 means base protocol,
    // length > 1 means protocol chain
    ChainEntries: Array[0..MAX_PROTOCOL_CHAIN-1] of LongInt; // a list of dwCatalogEntryIds
  end;

  TWSAProtocol_Info = record
    dwServiceFlags1: LongInt;
    dwServiceFlags2: LongInt;
    dwServiceFlags3: LongInt;
    dwServiceFlags4: LongInt;
    dwProviderFlags: LongInt;
    ProviderId: TGUID;
    dwCatalogEntryId: LongInt;
    ProtocolChain: TWSAProtocolChain;
    iVersion: Integer;
    iAddressFamily: Integer;
    iMaxSockAddr: Integer;
    iMinSockAddr: Integer;
    iSocketType: Integer;
    iProtocol: Integer;
    iProtocolMaxOffset: Integer;
    iNetworkByteOrder: Integer;
    iSecurityScheme: Integer;
    dwMessageSize: LongInt;
    dwProviderReserved: LongInt;
    szProtocol: Array[0..WSAPROTOCOL_LEN+1-1] of Char;
  end;

  TTCPKeepAlive = record
    onoff,
    keepalivetime,
    keepaliveinterval: u_long;
  end;

	WSAOVERLAPPED   = TOverlapped;
	TWSAOverlapped  = WSAOverlapped;
	PWSAOverlapped  = ^WSAOverlapped;
	LPWSAOVERLAPPED = PWSAOverlapped;

	LPWSAOVERLAPPED_COMPLETION_ROUTINE = procedure ( const dwError, cbTransferred : DWORD; const lpOverlapped : LPWSAOVERLAPPED; const dwFlags : DWORD ); stdcall;

  Procedure rpcSocketCheck(ResultCode : Integer);
  function Host2IP(const Host: string): u_long;

  function WSAIoctl( s : TSocket; dwIoControlCode : DWORD; lpvInBuffer : Pointer; cbInBuffer : DWORD; lpvOutBuffer : Pointer; cbOutBuffer : DWORD;
	                   lpcbBytesReturned : LPDWORD; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ) : Integer; stdcall;

  function WSASocket( af, iType, protocol : Integer; var lpProtocolInfo : TWSAProtocol_Info; g : DWORD; dwFlags : DWORD ): TSocket; stdcall;
  function WSADuplicateSocket( s : TSocket; dwProcessId : DWORD; var lpProtocolInfo : TWSAProtocol_Info) : Integer; stdcall;

const
      SIO_KEEPALIVE_VALS = $80000000 or $18000000 or 4;

implementation

uses DateUtils, ComObj;

const CrpcSocketPackPrefix   = 'rpc_Sock';
      CrpcSocketPackCommit   = Ord('C');// - Передача пакета успешно завершена
      CrpcSocketPackRollBack = Ord('R');// - Откат пакета
      CrpcSocketInvalidHandle : TrpcSocketHandle = '{00000000-0000-0000-0000-000000000000}';


      WINSOCK_VERSION = $0202;
      WINSOCK2_DLL = 'ws2_32.dll';


      WSA_QOS_RECEIVERS          = WSABASEERR+1005; // at least one Reserve has arrived
      WSA_QOS_SENDERS            = WSABASEERR+1006; // at least one Path has arrived
      WSA_QOS_NO_SENDERS         = WSABASEERR+1007; // there are no senders
      WSA_QOS_NO_RECEIVERS       = WSABASEERR+1008; // there are no receivers
      WSA_QOS_REQUEST_CONFIRMED  = WSABASEERR+1009; // Reserve has been confirmed
      WSA_QOS_ADMISSION_FAILURE  = WSABASEERR+1010; // error due to lack of resources
      WSA_QOS_POLICY_FAILURE     = WSABASEERR+1011; // rejected for administrative reasons - bad credentials
      WSA_QOS_BAD_STYLE          = WSABASEERR+1012; // unknown or conflicting style
      WSA_QOS_BAD_OBJECT         = WSABASEERR+1013; // problem with some part of the filterspec or providerspecific buffer in general
      WSA_QOS_TRAFFIC_CTRL_ERROR = WSABASEERR+1014; // problem with some part of the flowspec
      WSA_QOS_GENERIC_ERROR      = WSABASEERR+1015; // general error
      WSA_QOS_ESERVICETYPE       = WSABASEERR+1016; // invalid service type in flowspec
      WSA_QOS_EFLOWSPEC          = WSABASEERR+1017; // invalid flowspec
      WSA_QOS_EPROVSPECBUF       = WSABASEERR+1018; // invalid provider specific buffer
      WSA_QOS_EFILTERSTYLE       = WSABASEERR+1019; // invalid filter style
      WSA_QOS_EFILTERTYPE        = WSABASEERR+1020; // invalid filter type
      WSA_QOS_EFILTERCOUNT       = WSABASEERR+1021; // incorrect number of filters
      WSA_QOS_EOBJLENGTH         = WSABASEERR+1022; // invalid object length
      WSA_QOS_EFLOWCOUNT         = WSABASEERR+1023; // incorrect number of flows
      WSA_QOS_EUNKOWNPSOBJ       = WSABASEERR+1024; // unknown object in provider specific buffer
      WSA_QOS_EPOLICYOBJ         = WSABASEERR+1025; // invalid policy object in provider specific buffer
      WSA_QOS_EFLOWDESC          = WSABASEERR+1026; // invalid flow descriptor in the list
      WSA_QOS_EPSFLOWSPEC        = WSABASEERR+1027; // inconsistent flow spec in provider specific buffer
      WSA_QOS_EPSFILTERSPEC      = WSABASEERR+1028; // invalid filter spec in provider specific buffer
      WSA_QOS_ESDMODEOBJ         = WSABASEERR+1029; // invalid shape discard mode object in provider specific buffer
      WSA_QOS_ESHAPERATEOBJ      = WSABASEERR+1030; // invalid shaping rate object in provider specific buffer
      WSA_QOS_RESERVED_PETYPE    = WSABASEERR+1031; // reserved policy element in provider specific buffer


     { WinSock 2 extension -- new error codes and type definition }
      WSA_IO_PENDING          = ERROR_IO_PENDING;
      WSA_IO_INCOMPLETE       = ERROR_IO_INCOMPLETE;
      WSA_INVALID_HANDLE      = ERROR_INVALID_HANDLE;
      WSA_INVALID_PARAMETER   = ERROR_INVALID_PARAMETER;
      WSA_NOT_ENOUGH_MEMORY   = ERROR_NOT_ENOUGH_MEMORY;
      WSA_OPERATION_ABORTED   = ERROR_OPERATION_ABORTED;
//      WSA_INVALID_EVENT       = WSAEVENT(nil);
      WSA_MAXIMUM_WAIT_EVENTS = MAXIMUM_WAIT_OBJECTS;
      WSA_WAIT_FAILED         = $ffffffff;
      WSA_WAIT_EVENT_0        = WAIT_OBJECT_0;
      WSA_WAIT_IO_COMPLETION  = WAIT_IO_COMPLETION;
      WSA_WAIT_TIMEOUT        = WAIT_TIMEOUT;
      WSA_INFINITE            = INFINITE;



    Procedure rpcSocketCheck(ResultCode : Integer);
    var ErrCode : Integer;
        ErrText : String;
    Begin
      If ResultCode {<> 0}= SOCKET_ERROR Then Begin
        ErrCode := WSAGetLastError;
        Case ErrCode Of
          WSAEACCES                  :ErrText := 'Permission denied. '+#13+'An attempt was made to access a socket in a way forbidden by its access permissions. '+
                                                 'An example is using a broadcast address for sendto without broadcast permission being set using setsockopt(SO_BROADCAST).';
          WSAEADDRINUSE              :ErrText := 'Address already in use.'+#13+'Only one usage of each socket address (protocol/IP address/port) is normally permitted.'+
                                                 ' This error occurs if an application attempts to bind a socket to an IP address/port that has already been used for an existing socket, or a socket that wasn`t closed properly, or one that is still in the process of closing. '+
                                                 'For server applications that need to bind multiple sockets to the same port number, consider using setsockopt(SO_REUSEADDR). Client applications usually need not call bind at all - connect will choose an unused port automatically.';
          WSAEADDRNOTAVAIL           :ErrText := 'Cannot assign requested address.'+#13+'The requested address is not valid in its context. Normally results from an attempt to bind to an address that is not valid for the local machine, or connect/sendto an address or port that is not valid for a remote machine (e.g. port 0).';
          WSAEAFNOSUPPORT            :ErrText := 'Address family not supported by protocol family.'+#13+'An address incompatible with the requested protocol was used. All sockets are created with an associated "address family" (i.e. AF_INET for Internet Protocols) and a generic protocol type (i.e. SOCK_STREAM). '+
                                                 'This error will be returned if an incorrect protocol is explicitly requested in the socket call, or if an address of the wrong family is used for a socket, e.g. in sendto.';
          WSAEALREADY                :ErrText := 'Operation already in progress.'+#13+'An operation was attempted on a non-blocking socket that already had an operation in progress - i.e. '+
                                                 'calling connect a second time on a non-blocking socket that is already connecting, or canceling an asynchronous request (WSAAsyncGetXbyY) that has already been canceled or completed.';
          WSAECONNABORTED            :ErrText := 'Software caused connection abort.'+#13+'An established connection was aborted by the software in your host machine, possibly due to a data transmission timeout or protocol error.';
          WSAECONNREFUSED            :ErrText := 'Connection refused.'+#13+'No connection could be made because the target machine actively refused it. This usually results from trying to connect to a service that is inactive on the foreign host - i.e. one with no server application running.';
          WSAECONNRESET              :ErrText := 'Connection reset by peer.'+#13+'A existing connection was forcibly closed by the remote host. '+
                                                 'This normally results if the peer application on the remote host is suddenly stopped, the host is rebooted, or the remote host used a "hard close" (see setsockopt for more information on the SO_LINGER option on the remote socket.)';
          WSAEDESTADDRREQ            :ErrText := 'Destination address required.'+#13+'A required address was omitted from an operation on a socket. For example, this error will be returned if sendto is called with the remote address of ADDR_ANY.';
          WSAEFAULT                  :ErrText := 'Bad address.'+#13+'The system detected an invalid pointer address in attempting to use a pointer argument of a call. This error occurs if an application passes an invalid pointer value, or if the length of the buffer is too small. '+
                                                 'For instance, if the length of an argument which is a struct sockaddr is smaller than sizeof(struct sockaddr).';
          WSAEHOSTDOWN               :ErrText := 'Host is down.'+#13+' socket operation failed because the destination host was down. A socket operation encountered a dead host. Networking activity on the local host has not been initiated. These conditions are more likely to be indicated by the error WSAETIMEDOUT.';
          WSAEHOSTUNREACH            :ErrText := 'No route to host.'+#13+'A socket operation was attempted to an unreachable host. See WSAENETUNREACH';
          WSAEINPROGRESS             :ErrText := 'Operation now in progress.'+#13+'A blocking operation is currently executing. '+
                                                 'Windows Sockets only allows a single blocking operation to be outstanding per task (or thread), and if any other function call is made (whether or not it references that or any other socket) the function fails with the WSAEINPROGRESS error.';
          WSAEINTR                   :ErrText := 'Interrupted function call.'+#13+'A blocking operation was interrupted by a call to WSACancelBlockingCall.';
          WSAEINVAL                  :ErrText := 'Invalid argument.'+#13+'Some invalid argument was supplied (for example, specifying an invalid level to the setsockopt function). In some instances, it also refers to the current state of the socket - for instance, calling accept on a socket that is not listening.';
          WSAEISCONN                 :ErrText := 'Socket is already connected.'+#13+'A connect request was made on an already connected socket. '+
                                                 'Some implementations also return this error if sendto is called on a connected SOCK_DGRAM socket (For SOCK_STREAM sockets, the to parameter in sendto is ignored), although other implementations treat this as a legal occurrence.';
          WSAEMFILE                  :ErrText := 'Too many open files.'+#13+'Too many open sockets. Each implementation may have a maximum number of socket handles available, either globally, per process or per thread.';
          WSAEMSGSIZE                :ErrText := 'Message too long.'+#13+'A message sent on a datagram socket was larger than the internal message buffer or some other network limit, or the buffer used to receive a datagram into was smaller than the datagram itself.';
          WSAENETDOWN                :ErrText := 'Network is down.'+#13+'A socket operation encountered a dead network. This could indicate a serious failure of the network system (i.e. the protocol stack that the WinSock DLL runs over), the network interface, or the local network itself.';
          WSAENETRESET               :ErrText := 'Network dropped connection on reset.'+#13+'The host you were connected to crashed and rebooted. May also be returned by setsockopt if an attempt is made to set SO_KEEPALIVE on a connection that has already failed.';
          WSAENETUNREACH             :ErrText := 'Network is unreachable.'+#13+'A socket operation was attempted to an unreachable network. This usually means the local software knows no route to reach the remote host.';
          WSAENOBUFS                 :ErrText := 'No buffer space available.'+#13+'An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.';
          WSAENOPROTOOPT             :ErrText := 'Bad protocol option.'+#13+'An unknown, invalid or unsupported option or level was specified in a getsockopt or setsockopt call.';
          WSAENOTCONN                :ErrText := 'Socket is not connected.'+#13+'A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using sendto) no address was supplied. '+
                                                 'Any other type of operation might also return this error - for example, setsockopt setting SO_KEEPALIVE if the connection has been reset.';
          WSAENOTSOCK                :ErrText := 'Socket operation on non-socket.'+#13+'An operation was attempted on something that is not a socket. Either the socket handle parameter did not reference a valid socket, or for select, a member of an fd_set was not valid.';
          WSAEOPNOTSUPP              :ErrText := 'Operation not supported.'+#13+'The attempted operation is not supported for the type of object referenced. Usually this occurs when a socket descriptor to a socket that cannot support this operation, for example, trying to accept a connection on a datagram socket.';
          WSAEPFNOSUPPORT            :ErrText := 'Protocol family not supported.'+#13+'The protocol family has not been configured into the system or no implementation for it exists. '+
                                                 'Has a slightly different meaning to WSAEAFNOSUPPORT, but is interchangeable in most cases, and all Windows Sockets functions that return one of these specify WSAEAFNOSUPPORT.';
          WSAEPROCLIM                :ErrText := 'Too many processes.'+#13+'A Windows Sockets implementation may have a limit on the number of applications that may use it simultaneously. WSAStartup may fail with this error if the limit has been reached.';
          WSAEPROTONOSUPPORT         :ErrText := 'Protocol not supported.'+#13+'The requested protocol has not been configured into the system, or no implementation for it exists. For example, a socket call requests a SOCK_DGRAM socket, but specifies a stream protocol.';
          WSAEPROTOTYPE              :ErrText := 'Protocol wrong type for socket.'+#13+'A protocol was specified in the socket function call that does not support the semantics of the socket type requested. For example, the ARPA Internet UDP protocol cannot be specified with a socket type of SOCK_STREAM.';
          WSAESHUTDOWN               :ErrText := 'Cannot send after socket shutdown.'+#13+'A request to send or receive data was disallowed because the socket had already been shut down in that direction with a previous shutdown call. '+
                                                'By calling shutdown a partial close of a socket is requested, which is a signal that sending or receiving or both has been discontinued.';
          WSAESOCKTNOSUPPORT         :ErrText := 'Socket type not supported.'+#13+'The support for the specified socket type does not exist in this address family. For example, the optional type SOCK_RAW might be selected in a socket call, and the implementation does not support SOCK_RAW sockets at all.';
          WSAETIMEDOUT               :ErrText := 'Connection timed out.'+#13+'A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.';
//          WSAEWOULDBLOCK             :ErrText := 'Resource temporarily unavailable.'+#13+'This error is returned from operations on non-blocking sockets that cannot be completed immediately, for example recv when no data is queued to be read from the socket. It is a non-fatal error, and the operation should be retried later. '+
//                                                 'It is normal for WSAEWOULDBLOCK to be reported as the result from calling connect on a non-blocking SOCK_STREAM socket, since some time must elapse for the connection to be established.';
          WSAHOST_NOT_FOUND          :ErrText := 'Host not found.'+#13+'No such host is known. The name is not an official hostname or alias, or it cannot be found in the database(s) being queried. '+
                                                 'This error may also be returned for protocol and service queries, and means the specified name could not be found in the relevant database.';

          WSA_INVALID_HANDLE         :ErrText := 'Specified event object handle is invalid.'+#13+'An application attempts to use an event object, but the specified handle is not valid.';
          WSA_INVALID_PARAMETER      :ErrText := 'One or more parameters are invalid.'+#13+'An application used a Windows Sockets function which directly maps to a Win32 function. The Win32 function is indicating a problem with one or more parameters.';
//          WSAINVALIDPROCTABLE :ErrText := 'Invalid procedure table from service provider.'+#13+'A service provider returned a bogus proc table to WS2_32.DLL. (Usually caused by one or more of the function pointers being NULL.)';
//          WSAINVALIDPROVIDER :ErrText := 'Invalid service provider version number.'+#13+'A service provider returned a version number other than 2.0.';
          WSA_IO_PENDING             :ErrText := 'Overlapped operations will complete later.'+#13+'The application has initiated an overlapped operation which cannot be completed immediately. A completion indication will be given at a later time when the operation has been completed.';
          WSA_IO_INCOMPLETE          :ErrText := 'Overlapped I/O event object not in signaled state.'+#13+'The application has tried to determine the status of an overlapped operation which is not yet completed. '+
                                                 'Applications that use WSAWaitForMultipleEvents in a polling mode to determine when an overlapped operation has completed will get this error code until the operation is complete.';
          WSA_NOT_ENOUGH_MEMORY      :ErrText := 'Insufficient memory available.'+#13+'An application used a Windows Sockets function which directly maps to a Win32 function. The Win32 function is indicating a lack of required memory resources.';

          WSANOTINITIALISED          :ErrText := 'Successful WSAStartup not yet performed.'+#13+'Either the application hasn`t called WSAStartup or WSAStartup failed. '+
                                                 'The application may be accessing a socket which the current active task does not own (i.e. trying to share a socket between tasks), or WSACleanup has been called too many times.';
          WSANO_DATA                 :ErrText := 'Valid name, no data record of requested type.'+#13+'The requested name is valid and was found in the database, but it does not have the correct associated data being resolved for. '+
                                                 'The usual example for this is a hostname -> address translation attempt (using gethostbyname or WSAAsyncGetHostByName) which uses the DNS (Domain Name Server), '+
                                                 'and an MX record is returned but no A record - indicating the host itself exists, but is not directly reachable.';
          WSANO_RECOVERY             :ErrText := 'This is a non-recoverable error.'+#13+'This indicates some sort of non-recoverable error occurred during a database lookup. '+
                                                 'This may be because the database files (e.g. BSD-compatible HOSTS, SERVICES or PROTOCOLS files) could not be found, or a DNS request was returned by the server with a severe error.';
//          WSAPROVIDERFAILEDINIT :ErrText := 'Unable to initialize a service provider.'+#13+'Either a service provider`s DLL could not be loaded (LoadLibrary failed) or the provider`s WSPStartup/NSPStartup function failed.';
//          WSASYSCALLFAILURE :ErrText := 'System call failure.'+#13+'Returned when a system call that should never fail does. For example, if a call to WaitForMultipleObjects fails or one of the registry functions fails trying to manipulate theprotocol/namespace catalogs.';
          WSASYSNOTREADY             :ErrText := 'Network subsystem is unavailable.'+#13+'This error is returned by WSAStartup if the Windows Sockets implementation cannot function at this time because the underlying system it uses to provide network services is currently unavailable. Users should check:'+#13+
                                                 '·	that the appropriate Windows Sockets DLL file is in the current path,'+#13+
                                                 '·	that they are not trying to use more than one Windows Sockets implementation simultaneously. If there is more than one WINSOCK DLL on your system, be sure the first one in the path is appropriate for the network subsystem currently loaded.'+#13+
                                                 '·	the Windows Sockets implementation documentation to be sure all necessary components are currently installed and configured correctly.';
          WSATRY_AGAIN               :ErrText := 'Non-authoritative host not found.'+#13+'This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server. A retry at some time later may be successful.';
          WSAVERNOTSUPPORTED         :ErrText := 'WINSOCK.DLL version out of range.'+#13+'The current Windows Sockets implementation does not support the Windows Sockets specification version requested by the application. Check that no old Windows Sockets DLL files are being accessed.';
          WSAEDISCON                 :ErrText := 'Graceful shutdown in progress.'+#13+'Returned by recv, WSARecv to indicate the remote party has initiated a graceful shutdown sequence.';
          WSA_OPERATION_ABORTED      :ErrText := 'Overlapped operation aborted.'+#13+'An overlapped operation was canceled due to the closure of the socket, or the execution of the SIO_FLUSH command in WSAIoctl.';

          WSA_QOS_RECEIVERS          :ErrText := 'at least one Reserve has arrived';
          WSA_QOS_SENDERS            :ErrText := 'at least one Path has arrived';
          WSA_QOS_NO_SENDERS         :ErrText := 'there are no senders';
          WSA_QOS_NO_RECEIVERS       :ErrText := 'there are no receivers';
          WSA_QOS_REQUEST_CONFIRMED  :ErrText := 'Reserve has been confirmed';
          WSA_QOS_ADMISSION_FAILURE  :ErrText := 'error due to lack of resources';
          WSA_QOS_POLICY_FAILURE     :ErrText := 'rejected for administrative reasons - bad credentials';
          WSA_QOS_BAD_STYLE          :ErrText := 'unknown or conflicting style';
          WSA_QOS_BAD_OBJECT         :ErrText := 'problem with some part of the filterspec or providerspecific buffer in general';
          WSA_QOS_TRAFFIC_CTRL_ERROR :ErrText := 'problem with some part of the flowspec';
          WSA_QOS_GENERIC_ERROR      :ErrText := 'general error';
          WSA_QOS_ESERVICETYPE       :ErrText := 'invalid service type in flowspec';
          WSA_QOS_EFLOWSPEC          :ErrText := 'invalid flowspec';
          WSA_QOS_EPROVSPECBUF       :ErrText := 'invalid provider specific buffer';
          WSA_QOS_EFILTERSTYLE       :ErrText := 'invalid filter style';
          WSA_QOS_EFILTERTYPE        :ErrText := 'invalid filter type';
          WSA_QOS_EFILTERCOUNT       :ErrText := 'incorrect number of filters';
          WSA_QOS_EOBJLENGTH         :ErrText := 'invalid object length';
          WSA_QOS_EFLOWCOUNT         :ErrText := 'incorrect number of flows';
          WSA_QOS_EUNKOWNPSOBJ       :ErrText := 'unknown object in provider specific buffer';
          WSA_QOS_EPOLICYOBJ         :ErrText := 'invalid policy object in provider specific buffer';
          WSA_QOS_EFLOWDESC          :ErrText := 'invalid flow descriptor in the list';
          WSA_QOS_EPSFLOWSPEC        :ErrText := 'inconsistent flow spec in provider specific buffer';
          WSA_QOS_EPSFILTERSPEC      :ErrText := 'invalid filter spec in provider specific buffer';
          WSA_QOS_ESDMODEOBJ         :ErrText := 'invalid shape discard mode object in provider specific buffer';
          WSA_QOS_ESHAPERATEOBJ      :ErrText := 'invalid shaping rate object in provider specific buffer';
          WSA_QOS_RESERVED_PETYPE    :ErrText := 'reserved policy element in provider specific buffer';
          else
            ErrText := '';
        end;
        If ErrCode <> WSAEWOULDBLOCK Then
          RAise ErpcSocketWinSockError.Create('Ошибка сокета ('+IntToStr(ErrCode)+') '+ErrText );
      end;
    end;

    Function rpcSocketPackEnd(const PackID : Word; EndType : Byte) : String;
    var P : Pointer;
        Nol : Word;
    Begin
    {<2байта Идентификатор пакета>
     <2байта Признак завершения пакета>
     <1байт Тип завершения пакета>}
      SetLength(Result, 2 + 2 + 1);
      P := PChar(Result);

      Move(PackID, P^, SizeOf(Word));
      Inc(Cardinal(P), SizeOf(Word));

      Nol := 0;
      Move(Nol, P^, SizeOf(Word));
      Inc(Cardinal(P), SizeOf(Word));

      Move(EndType, P^, SizeOf(Byte));
    end;

    Function rpcSocketBlockStart(const PackID : Word; const BlockSize : Word; const pBlockData : Pointer = Nil) : String;
    var P : Pointer;
    Begin
    {<2байта Идентификатор пакета><2байта длинна 1-го блока><Блок данных 1>}
      If pBlockData <> Nil Then
        SetLength(Result, 2 + 2 + BlockSize)
      else
        SetLength(Result, 2 + 2);

      P := PChar(Result);

      Move(PackID, P^, SizeOf(Word));
      Inc(Cardinal(P), SizeOf(Word));

      Move(BlockSize, P^, SizeOf(Word));
      Inc(Cardinal(P), SizeOf(Word));

      If pBlockData <> Nil Then
        Move(pBlockData^, P^, BlockSize);
    end;

    Function rpcSocketPackStart(const PackType : TrpcSocketPackType; const PackID : Word) : String;
    var P : Pointer;
        B : Byte;
    Begin
    {<8байт Постоянный префикс пакета>
     <1байт Тип пакета>
     <2байта Идентификатор пакета>}
      SetLength(Result, 8 + 1 + 2);
      P := PChar(Result);

      Move(PChar(CrpcSocketPackPrefix)^, P^, Length(CrpcSocketPackPrefix));
      Inc(Cardinal(P), Length(CrpcSocketPackPrefix));

      B := Integer(PackType);
      Move(B, P^, SizeOf(Byte));
      Inc(Cardinal(P), SizeOf(Byte));

      Move(PackID, P^, SizeOf(Word));
      //Inc(Cardinal(P), SizeOf(Word));
    end;

    function Host2IP(const Host: string): u_long;
    var he: PHostEnt;
        Res : Integer;
    begin
      Result := WinSock.inet_addr( PChar(Host) );
      If Result = WinSock.INADDR_NONE Then Begin

        he := WinSock.gethostbyname(PChar(Host));
        If Assigned(he) Then
          Result := PInAddr(he^.h_addr_list^)^.S_addr
        else
        If TryStrToInt(Host, Res) then
          Result := Res
        else
          Raise ErpcSocketError.Create('Не могу преобразовать "'+Host+'" в корректный IP адрес!');

      end;
    end;

    function WSAIoctl;	external WINSOCK2_DLL name 'WSAIoctl';

    function WSADuplicateSocket;  external WINSOCK2_DLL name 'WSADuplicateSocketA';
    function WSASocket; external WINSOCK2_DLL name 'WSASocketA';


{ TrpcSocketCustomChannel }

procedure TrpcSocketCustomChannel.Job_ConnectionLost(IsTerminate : TtmIsTerminateProc);
var S : TSocket;
begin
  If GetSocket(S) Then Begin
    Try
      Try
        rpcSocketCheck( WinSock.closesocket(S) );
      Except
        uSysProc.HandleOnException('Закрытие сокета при потере связи', false);
      end;
    Finally
      SetSocket( WinSock.INVALID_SOCKET );
    end;
  end;
end;

constructor TrpcSocketCustomChannel.Create;
begin
  Inherited Create;
  FJob_Holder := TtmCustomJobHolder.Create( 1000{INFINITE} );
  //FJob_Holder.DestroyTimeOut := 256000;
  FReadyCrit:= TCriticalSection.Create;
  FSock := WinSock.INVALID_SOCKET;
  FSender := TrpcSocketSender.Create(Self);
  FReceiver := TrpcSocketReceiver.Create(Self);
  FKeepAliveInterval := 10000;
  FNagleAlgo := False;//True;
end;

destructor TrpcSocketCustomChannel.Destroy;
var S : TSocket;
begin
  FReceiver.Free;
  FSender.Free;

  If GetSocket(S) Then Begin
    WinSock.shutdown(S, SD_BOTH);
    WinSock.closesocket(S);
  end;
  //uSysProc.HandleLogMessage(lmtMessage, 'Сокетный канал закрыт');

  FreeAndNil(FReadyCrit);
  FJob_Holder.Free;
  inherited;
end;

procedure TrpcSocketCustomChannel.DoChangeState;
begin
  If FEventReceiver <> 0 Then
    PostMessage(FEventReceiver, rpcSocket_ChangeReady, Integer(Self), Integer(Ready));
end;

procedure TrpcSocketCustomChannel.DoReceive;
begin
  //Начался новый Прикладной пакет пакет
  If FReceiver.PackType  In  [sptAppDataQuery, spt_AppDataAnswer, sptAppDataPost] Then Begin
    If not IsEqualGUID(Handle, CrpcSocketInvalidHandle) Then
      DoReceiveApp
    else
      Raise ErpcSocketError.Create('Прикладной пакет не авторизованного канала!');
  end else
    Raise ErpcSocketError.Create('Некорректный тип пакета '+IntToStr(Integer(FReceiver.PackType)));
end;

function TrpcSocketCustomChannel.GetHandle: TrpcSocketHandle;
begin
  ReadyCrit.Enter;
  Try
    Result := FHandle;
  Finally
    ReadyCrit.Leave;
  end;
end;

function TrpcSocketCustomChannel.GetReady: Boolean;
var S : TSocket;
begin
  ReadyCrit.Enter;
  Try
    Result := GetSocket(S) and
              (not IsEqualGUID(Handle, CrpcSocketInvalidHandle));
  Finally
    ReadyCrit.Leave;
  end;
end;

function TrpcSocketCustomChannel.GetSocket(Out S : TSocket) : Boolean;
begin
  ReadyCrit.Enter;
  Try
    Result := FSock <> WinSock.INVALID_SOCKET;
    S := FSock;
  Finally
    ReadyCrit.Leave;
  end;
end;

procedure TrpcSocketCustomChannel.InitKeepAlive;
var ka: TTCPKeepAlive;
    Len: DWORD;
    S : TSocket;
begin
  If GetSocket(S) Then Begin

    if FKeepAliveInterval <> 0 then begin
      ka.onoff := 1;
      ka.keepalivetime := FKeepAliveInterval;
      ka.keepaliveinterval := 1000;
    end else
      ka.onoff := 0;

    rpcSocketCheck( WSAIoctl(S, SIO_KEEPALIVE_VALS, @ka, sizeof(ka), nil, 0, @Len, nil, nil) );
  end;
end;

procedure TrpcSocketCustomChannel.SetHandle(const Value: TrpcSocketHandle);
var OldReady : Boolean;
begin
  ReadyCrit.Enter;
  Try
    OldReady := Ready;
    FHandle := Value;
  Finally
    ReadyCrit.Leave;
  end;
  If OldReady <> Ready Then
    DoChangeState;
end;

procedure TrpcSocketCustomChannel.SetKeepAliveInterval(const Value: Integer);
begin
  If Value < 1000 Then
    Raise ErpcSocketError.Create('Значение KeepAliveInterval не может быть меньше 1000ms');
  FKeepAliveInterval := Value;
  InitKeepAlive;
end;

procedure TrpcSocketCustomChannel.SetSocket(const Value: TSocket);
var OldReady : Boolean;
    S : TSocket;
    SocketBufSize : Integer;
begin
  ReadyCrit.Enter;
  Try
    OldReady := Ready;
    FSock := Value;
  Finally
    ReadyCrit.Leave;
  end;
  InitKeepAlive;
  If GetSocket(S) Then Begin
    InnerSetNagleAlgo(s, FNagleAlgo);
    SocketBufSize := High(Word);
    WinSock.setsockopt( S, SOL_SOCKET, SO_RCVBUF, @SocketBufSize, SizeOf(Integer));
    WinSock.setsockopt( S, SOL_SOCKET, SO_SNDBUF, @SocketBufSize, SizeOf(Integer));
    FReceiver.Thread_Start;
  end else
    FReceiver.Thread_Stop;

  If OldReady <> Ready Then
    DoChangeState;
end;

function TrpcSocketCustomChannel.BeginAnswer(
  const PackID: Word): TrpcSocketSender;
begin
  If not Ready Then
    Raise ERPCError.Create('Сокетный канал не готов к отправке сообщения');

  FSender.BeginSend(spt_AppDataAnswer, PackID, Nil);
  Result := FSender;
end;

function TrpcSocketCustomChannel.BeginQuery(CheckValidId : TrpcSocketCheckValidIDProc): TrpcSocketSender;
begin
  If not Ready Then
    Raise ERPCError.Create('Сокетный канал не готов к отправке сообщения');

  FSender.BeginSend(sptAppDataQuery, 0, CheckValidId);
  Result := FSender;
end;

procedure TrpcSocketCustomChannel.DoConnectionLost;
var I : Integer;
begin
  //uSysProc.HandleLogMessage(lmtDebug, 'Потеряна связь!');
  Job_Holder.DoJobOnDataUnExists(Job_ConnectionLost, 0, I);
end;

procedure TrpcSocketCustomChannel.SetNagleAlgo(const Value: Boolean);
var
  s: TSocket;
begin
  if FNagleAlgo <> Value then begin
    if GetSocket(s) then
      InnerSetNagleAlgo(s, Value);
    FNagleAlgo := Value;
  end;
end;

procedure TrpcSocketCustomChannel.InnerSetNagleAlgo(s: TSocket; const Value: Boolean);
var
  x: Integer;
begin
  if Value then
    x := 0
  else
    x := 1;
  rpcSocketCheck( WinSock.setsockopt(s, IPPROTO_TCP, TCP_NODELAY, PChar(@x), SizeOf(Integer)) );
end;

function TrpcSocketCustomChannel.BeginPostData(
  const FormatID: Word): TrpcSocketSender;
begin
  If not Ready Then
    Raise ERPCError.Create('Сокетный канал не готов к отправке сообщения');

  If FormatID = 0 Then
    Raise ERPCError.Create('Не верный идентификатор формата данных!');

  FSender.BeginSend(sptAppDataPost, FormatID, Nil);
  Result := FSender;
end;

{ TrpcSocketSender }

procedure TrpcSocketSender.BeginSend(const PackType : TrpcSocketPackType; const PackID : Word; CheckValidId : TrpcSocketCheckValidIDProc);

  Function _CheckValidId(const NewID : Word) : Boolean;
  Begin
    Result := True;
    If Assigned(CheckValidId) Then
      CheckValidId(Self, NewID, Result);
  end;

var Buf : String;
    S : TSocket;
    CheckCount : Word;
begin
  FSendCrit.Enter;
  Try
    If FProgressSend Then
      Raise ErpcSocketError.Create('Не закончена пересылка предыдущего пакета!');


    If Channel.GetSocket(S) Then Begin

      If PackID = 0 Then Begin
        CheckCount := High(Word) - 1;
        Repeat
          dec(CheckCount);
          If CheckCount = 0 Then
            Raise ErpcSocketError.Create('Не могу сгенерировать уникальный идентификатор пакета!');

          If FPackIDIterator = High(Word) Then
            FPackIDIterator := 1
          else
            Inc(FPackIDIterator);

        Until _CheckValidId( FPackIDIterator );
        FPackID := FPackIDIterator;

      end else
        FPackID := PackID;

      Buf := rpcSocketPackStart(PackType, FPackID);
      rpcSocketCheck( WinSock.send(S, PChar(Buf)^, Length(Buf), 0));
      FProgressSend := True;

    end else
      Raise ErpcSocketError.Create('Socket не готов к передаче пакета!');
  Except
    FSendCrit.Leave;
    raise;
  end;
end;

procedure TrpcSocketSender.CheckProgress;
begin
  If not FProgressSend Then
    Raise ErpcSocketError.Create('Пересылка данных пакета не стартовала!');
end;

procedure TrpcSocketSender.CommitSend;
var Buf : String;
    S : TSocket;
begin
  CheckProgress;

  Buf := rpcSocketPackEnd(FPackID, CrpcSocketPackCommit);
  If Channel.GetSocket(S) Then Begin
    If InnerBufDataLen > 0 Then Begin
      Send(@FInnerBuf, InnerBufDataLen); //Отправляю оставшиеся буферизованные данные
      InnerBufReset;
    end;

    rpcSocketCheck( WinSock.send(S, PChar(Buf)^, Length(Buf), 0));
    FProgressSend := False;
    FSendCrit.Leave;
  end else
    uSysProc.HandleLogMessage(lmtWarning, 'Socket не готов к передаче уведомления о завершении пакета!');
end;

constructor TrpcSocketSender.Create(Channel: TrpcSocketCustomChannel);
begin
  Inherited Create;
  FSendCrit := TCriticalSection.Create;
  FChannel := Channel;
  InnerBufReset;
  Randomize;
  FPackIDIterator := Random( High(Word) - 1 )+1;
end;

destructor TrpcSocketSender.Destroy;
begin
  FSendCrit.Free;
  inherited;
end;

function TrpcSocketSender.InnerBufDataLen: Integer;
begin
  Result := Cardinal(FInnerBufFreePoint) - Cardinal(@FInnerBuf);
end;

function TrpcSocketSender.InnerBufFreeTail: Integer;
begin
  Result := SizeOf(FInnerBuf) - InnerBufDataLen;
end;

procedure TrpcSocketSender.InnerBufReset;
begin
  FInnerBufFreePoint := @FInnerBuf;
end;

procedure TrpcSocketSender.RollbackSend;
var Buf : String;
    S : TSocket;
begin
  CheckProgress;
  Try
    Buf := rpcSocketPackEnd(FPackID, CrpcSocketPackRollBack);
    If Channel.GetSocket(S) Then
      rpcSocketCheck( WinSock.send(S, PChar(Buf)^, Length(Buf), 0))
    else
      uSysProc.HandleLogMessage(lmtWarning, 'Socket не готов к передаче уведомления об откате пакета!');
  Finally
    FProgressSend := False;
    InnerBufReset;
    FSendCrit.Leave;
  end;
end;

procedure TrpcSocketSender.Send(const pBlockData : Pointer; const BlockSize : Word);
var S : TSocket;
    Buf : String;
begin
  CheckProgress;
  Buf := rpcSocketBlockStart(FPackID, BlockSize, Nil);
  If Channel.GetSocket(S) Then Begin
    rpcSocketCheck( WinSock.send(S, PChar(Buf)^, Length(Buf), 0));
    rpcSocketCheck( WinSock.send(S, pBlockData^, BlockSize, 0))
  end else
    Raise ErpcSocketError.Create('Socket не готов к передаче даных пакета!');
end;

procedure TrpcSocketSender.SendBuf(const Buf; BufLen: Integer);
var P : Pointer;
begin
  If ((BufLen >= High(Word)) or (BufLen > InnerBufFreeTail)) and
     (InnerBufDataLen > 0)
  Then Begin //Отправляю буферизованные данные
    Send(@FInnerBuf, InnerBufDataLen);
    InnerBufReset;
  end;

  P := @Buf;
  While BufLen >= High(Word) do Begin
    //если я в этот цикл попал то внутренний буфер однозначно пуст
    Send(P, High(Word));
    Inc(Cardinal(P), High(Word));
    Dec(BufLen, High(Word));
  end;

  If (BufLen > 0) Then Begin
    If InnerBufFreeTail < BufLen Then
      Raise ErpcSocketError.Create('Какая то хрень с этим внутренним буфером сокета');

    //Буферизирую остаток данных
    Move(P^, FInnerBufFreePoint^, BufLen);
    Inc(Cardinal(FInnerBufFreePoint), BufLen);
  end;
end;

{ TrpcSocketReceiver }

constructor TrpcSocketReceiver.Create(Channel: TrpcSocketCustomChannel);
begin
  Inherited Create;
  FChannel := Channel;
  FPackType := sptUnknown;
  FEof := True;
  FBlockTailLen := 0;
  FPackID := 0;
end;

destructor TrpcSocketReceiver.Destroy;
begin
  Thread_Stop;
  inherited;
end;

procedure TrpcSocketReceiver.DoReceivePack(PackID: Word; PackType: TrpcSocketPackType);
begin
  If Eof Then
    Try
      FPackID := PackID;
      FPackType := PackType;
      FBlockTailLen := 0;
      Try
        InitNextBlock;
        Channel.DoReceive;
      Except
        uSysProc.HandleOnException('Прием сокетного пакета');
      end;
    Finally
      FEof := True;
    end
  else
    Raise ErpcSocketError.Create('Не завершен прием предыдущего пакета!');

end;

procedure TrpcSocketReceiver.InitNextBlock;

  Function _ReadWord(S : TSocket) : Word;
  var L : Integer;
      pBuf : Pointer;
      BufLen : Integer;
  Begin
    pBuf := @Result;
    BufLen := SizeOf(Word);
    Repeat
      L := WinSock.recv(S, pBuf^, BufLen, 0);
      If L = 0 Then Begin
        Channel.DoConnectionLost;
        Raise ErpcSocketConnectionLost.Create('Не могу прочитать заголовок блока. Диагностирован обрыв соединения.');
      end else
      If L > 0 Then  Begin
        Inc( Cardinal(pBuf), L);
        Dec( BufLen, L);
      end else
        rpcSocketCheck( L );

    Until BufLen <= 0;
  end;

var W : Word;
    B : Byte;
    S : TSocket;
    L : Integer;
begin
//<2байта Идентификатор пакета><2байта длинна N-го блока><Блок данных N>
//<2байта Идентификатор пакета><2байта Признак завершения пакета><1байт Тип завершения пакета>
  FEof := True;
  If Channel.GetSocket(S) Then Begin

    If FPackID <> _ReadWord(S) Then
      Raise ErpcSocketError.Create('Не корректный заголовок блока данных');

    W := _ReadWord(S);
    If W <> 0 Then Begin
      //Это блок данных длинной W
      FEof := False;
      FBlockTailLen := W
    end else Begin
      //По всей видимости это конец пакета
      L := WinSock.recv(S, B, SizeOf(Byte), 0);
      If L = 0 Then Begin
        Channel.DoConnectionLost;
        Raise ErpcSocketConnectionLost.Create('Не могу прочитать признак завершения пакета. Диагностирован обрыв соединения.');
      end else
      If L > 0 Then Begin
        //Проверяю корректность завершения пакета
        If B = CrpcSocketPackRollback Then
          Raise ErpcSocketPackRollBack.Create('Откат сокетного пакета по инициативе передающей стороны')
        else
        If B <> CrpcSocketPackCommit Then
          Raise ErpcSocketError.Create('Не верный идентификатор завершения пакета');
      end else
        rpcSocketCheck( L );
    end;

  end else
    Raise ErpcSocketError.Create('Не могу прочитать заголовок блока данных. Соединение уже закрыто!');
end;

Procedure TrpcSocketReceiver.ReceiveBuf(var Buf; BufLen : Integer);
var L : Integer;
    P : Pointer;
Begin
  P := @Buf;
  While (not Eof) and (BufLen > 0) do Begin
    L := Receive(P, BufLen);
    Inc(Cardinal(P), L);
    Dec(BufLen, L);
  end;
  If BufLen > 0 Then
    Raise ErpcSocketError.Create('Не могу прочитать оставшиеся '+IntToStr(BufLen)+' из принимаемого пакета!');
end;


function TrpcSocketReceiver.Receive(const pBuf : Pointer; const BufLen : Integer): Integer;
var S : TSocket;
    Len : Integer;
Begin
  If Eof Then
    Raise ErpcSocketError.Create('Сокетный пакет полностью принят');

  Result := 0;

  If FBlockTailLen > 0 Then Begin
    If BufLen > FBlockTailLen Then
      Len := FBlockTailLen
    else
      Len := BufLen;

    If Channel.GetSocket(S) Then Begin
      Result := WinSock.recv(S, pBuf^, Len, 0);

      If Result = 0 Then Begin
        FEof := True;
        Channel.DoConnectionLost;
        Raise ErpcSocketConnectionLost.Create('Не могу принять пакет. Диагностирован обрыв соединения.')
      end else
      If Result > 0 Then
        FBlockTailLen := FBlockTailLen - Result
      else Begin
        FEof := True;
        rpcSocketCheck(Result);
      end;

    end else Begin
      FEof := True;
      Raise ErpcSocketError.Create('Не могу принять пакет. Соединение уже закрыто!');
    end;
  end;


  If FBlockTailLen <= 0 Then
    InitNextBlock;
end;

procedure TrpcSocketReceiver.Thread_Start;
begin
  If FReceiveThread = Nil Then
    FReceiveThread := TrpcSocketReceiveThread.Create(Self);
end;

procedure TrpcSocketReceiver.Thread_Stop;
begin
  FreeAndNil(FReceiveThread);
end;

{ TrpcSocketReceiveThread }

constructor TrpcSocketReceiveThread.Create(Receiver : TrpcSocketReceiver);
Begin
  FReceiver := Receiver;
  Inherited Create(Nil);
end;

procedure TrpcSocketReceiveThread.DoListen;

  Procedure _Receive(S : TSocket);
  var L : Integer;
      I : Integer;
      P : Pointer;

      Prefix : String;
      PackType : Byte;
      PackID : Word;
  Begin
    P := @FBuf;
    Inc(Cardinal(P), FBufDataLen);
    L := WinSock.recv(S, P^, SizeOf(FBuf) - FBufDataLen, 0);

    If L <= 0 Then Begin
      Receiver.Channel.DoConnectionLost;
      Listener.Terminate;
    end else
    If L > 0 Then Begin
      L := L + FBufDataLen;

      FBufDataLen := 0;
      For I := 1 to L do
        If FBuf[I] = CrpcSocketPackPrefix[1] Then Begin
          P := @FBuf;
          If (i > 1) or (L < SizeOf(FBuf)) Then Begin
            //Даже если это и заголовок все равно он вычитался не до конца
            Inc(Cardinal(P), I-1);
            FBufDataLen := L - I + 1;
            Move(P^, FBuf, FBufDataLen);
          end else Begin
            //Вполне вероятно что в буфере заголовок пакета
            //<8байт Постоянный префикс пакета><1байт Тип пакета><2байта Идентификатор пакета>
            SetLength(Prefix, 8);
            Move(P^, PChar(Prefix)^, 8);
            Inc(Cardinal(P), 8);
            If Prefix = CrpcSocketPackPrefix Then Begin
              Move(P^, PackType, SizeOf(Byte));
              Inc(Cardinal(P), SizeOf(Byte));
              If (PackType >= Integer(Low(TrpcSocketPackType))+1) and
                 (PackType <= Integer(High(TrpcSocketPackType))) Then Begin
                Move(P^, PackID, SizeOf(Word));
                If PackID <> 0 Then Begin
                  //Похоже это действительно старт пакета
                  Receiver.DoReceivePack(PackID, TrpcSocketPackType(PackType));
                end;
              end;
            end;
          end;
          Break;
        end;

    end{ else
      rpcSocketCheck( L )};

  end;

var  TimeOut : Integer;
     S : TSocket;
     TV : TTimeVal;
     R, W, E : TFDSet;
begin
  If Receiver.Channel.GetSocket(S) Then  Begin
    WinSock.FD_ZERO(R);
    WinSock.FD_SET(S, R);
    WinSock.FD_ZERO(W);
    WinSock.FD_ZERO(E);

    TimeOut := DestroyTimeOut Div 10;
    If TimeOut > 1000 Then
      TimeOut := 100;
    TV.tv_sec := Trunc(TimeOut / 1000);
    TV.tv_usec := (TimeOut - TV.tv_sec) * 1000;

    While (not Listener.Terminated) and
          (WinSock.select(0, @R, @W, @E, @TV) > 0) Do //Можно читать
      _Receive(S);

  end else
    RAise ErpcSocketError.Create('Сокетный канал не готов к приему данных');
end;

{ TrpcClientChannel }

procedure TrpcSocketClientChannel.CheckInactive;
begin
  If Active Then
    RAise ErpcSocketError.Create('Соединение уже установлено!');
end;

procedure TrpcSocketClientChannel.Close;
var {Buf : String;}
    S : TSocket;
begin
  //Останавливаю поток соединения
  Try
    FJob_WaitEvent.SetEvent;
    Job_Holder.DropJobs(Job_DoConnect);
    {If FJob_Sock <> WinSock.INVALID_SOCKET Then
      Try //Этого можно и не делать при завершении потока FJob_Sock однозначно равен WinSock.INVALID_SOCKET
        rpcSocketCheck( WinSock.closesocket( FJob_Sock ) );
      Finally
        FJob_Sock := WinSock.INVALID_SOCKET;
      end;}
  Except
    uSysProc.HandleOnException('Завершение потока восстановления связи!');
  end;

  //Закрываю соединение
  Try
    If GetSocket(S) Then Begin
      Try
        SetSocket( WinSock.INVALID_SOCKET );
      Finally
        Try
          rpcSocketCheck( WinSock.shutdown(S, WinSock.SD_RECEIVE) );
        Finally
          rpcSocketCheck( WinSock.closesocket( S ) );
        end;
      end;
    end;
  Finally
    FActive := False;
    SetHandle( CrpcSocketInvalidHandle );
  end;
end;

procedure TrpcSocketClientChannel.Job_ConnectionLost(IsTerminate : TtmIsTerminateProc);
var JCount : Integer;
begin
  inherited;
  Job_Holder.DoJobOnDataUnExists(Job_DoConnect, IncMilliSecond(Now, ReconnectInterval), JCount);
end;

constructor TrpcSocketClientChannel.Create;
begin
  Inherited Create;
  FJob_WaitEvent := TSimpleEvent.Create;
  FHost := 'LocalHost';
  FReconnectInterval := 10000;
  FPort := 7777;
end;

destructor TrpcSocketClientChannel.Destroy;
begin
  Close;
  FJob_WaitEvent.Free;
  inherited;
end;

procedure TrpcSocketClientChannel.DoReceiveApp;
begin
  If Assigned(FOnReceive) Then
    FOnReceive( Receiver );
end;

procedure TrpcSocketClientChannel.Job_DoConnect(IsTerminate : TtmIsTerminateProc);
var SA :  TSockAddr;
    Connected, Excepted : Boolean;
    WaitResult : TWaitResult;
    Buf{, S} : String;
    H : TrpcSocketHandle;
    PackID : Word;
    FJob_Sock : TSocket;
    sReady, sExcept : TFDSet;
    TV : timeval;
    Block : u_long;
begin
  FJob_Sock := WinSock.INVALID_SOCKET;
  FJob_WaitEvent.ResetEvent;
  Connected := False;
  Try
    Repeat
      If IsTerminate Then
        Exit;

      Try
        If FJob_Sock = WinSock.INVALID_SOCKET Then
          FJob_Sock := WinSock.socket( PF_INET, SOCK_STREAM, IPPROTO_TCP );

        If (FJob_Sock <> WinSock.INVALID_SOCKET) Then Begin
          If IsTerminate Then
            Exit;

          ReadyCrit.Enter;
          Try
            SA := FJob_SockAdr;
          Finally
            ReadyCrit.Leave;
          end;
          //Connected := WinSock.connect(FJob_Sock, SA, SizeOf(TSockAddr)) = 0;
          Block := 1;
          WinSock.ioctlsocket(FJob_Sock, FIONBIO, Block);
          // WinSock.connect(FJob_Sock, SA, SizeOf(TSockAddr));
          Excepted := False;
          Connected := WinSock.connect(FJob_Sock, SA, SizeOf(TSockAddr)) = 0;
          If WinSock.WSAGetLastError = WSAEWOULDBLOCK Then
            Repeat
              WinSock.FD_Zero(sReady);
              WinSock.FD_Set(FJob_Sock, sReady);
              WinSock.FD_Zero(sExcept);
              WinSock.FD_Set(FJob_Sock, sExcept);
              TV.tv_sec := 0;
              TV.tv_usec := 100000; //0.1 секунды
              If WinSock.select(0, Nil, @sReady, @sExcept, @TV) > 0 Then Begin
                Connected := WinSock.FD_ISSET(FJob_Sock, sReady);
                Excepted := WinSock.FD_ISSET(FJob_Sock, sExcept);
              end;
            until IsTerminate or Connected or Excepted;
          Block := 0;
          WinSock.ioctlsocket(FJob_Sock, FIONBIO, Block);
        end;
      Except
        If FJob_Sock <> WinSock.INVALID_SOCKET Then
          Try
            WinSock.closesocket( FJob_Sock );
          Finally
            FJob_Sock := WinSock.INVALID_SOCKET;
          end;
      end;
      //CheckTerminate;
      If IsTerminate Then
        Exit;


      If Connected Then
        Try
          H := Handle; //Посылаю уведомление о восстановлении связи
          PackID := Random( High(Word)-1 )+1;
          //PackID := 99;
          Buf := rpcSocketPackStart( sptOnConnect, PackID) +
                 rpcSocketBlockStart(PackID, SizeOf(TrpcSocketHandle), @H) +
                 rpcSocketPackEnd(PackID, CrpcSocketPackCommit);
          { Buf := rpcSocketPackStart( sptOnConnect, PackID);
            S := rpcSocketBlockStart(PackID, SizeOf(TrpcSocketHandle), @H);
            Buf := Buf + S;
            S := rpcSocketPackEnd(PackID, CrpcSocketPackCommit);
            Buf := Buf + S;}

          rpcSocketCheck( WinSock.send(FJob_Sock, PChar(Buf)^, Length(Buf), 0));

          If not IsTerminate Then Begin
            SetSocket( FJob_Sock );
            FJob_Sock := WinSock.INVALID_SOCKET;
          end else
            Exit;
        Except
          uSysProc.HandleOnException('Пересылка HAndle клиентского сокетного канала',FAlse);
          Try
            Connected := False;
            Try
              WinSock.closesocket( FJob_Sock );
            Finally
              FJob_Sock := WinSock.INVALID_SOCKET;
            end;
          Except
            uSysProc.HandleOnException('Закрытие клиентского сокетного канала после неудачной пересылки Handle',FAlse);
          end;
        end;

      If IsTerminate Then
        Exit;

      If not Connected Then
        WaitResult := FJob_WaitEvent.WaitFor(FReconnectInterval)
      else
        WaitResult := wrSignaled;
    until IsTerminate or Connected or (WaitResult = wrSignaled);
  Finally
    If FJob_Sock <> WinSock.INVALID_SOCKET Then
    Try
      WinSock.shutdown(FJob_Sock, SD_BOTH);
    Finally
      WinSock.closesocket( FJob_Sock );
    end;
     {Try
      Finally
        FJob_Sock := WinSock.INVALID_SOCKET;
      end;}
  end;
end;

procedure TrpcSocketClientChannel.Open;
var JCount : Integer;
    H : TrpcSocketHandle;
    S : TSocket;
begin
  If GetSocket(S) Then
    Close;

  ReadyCrit.Enter;
  Try
    FillChar(FJob_SockAdr, SizeOf(TSockAddr), 0);
    FJob_SockAdr.sin_family := AF_INET;
    FJob_SockAdr.sin_addr.S_addr := Host2IP( Host );
    FJob_SockAdr.sin_port := HToNs( Port );
  Finally
    ReadyCrit.Leave;
  end;
  OleCheck( CreateGUID( H ) );
  SetHandle(H);
  Job_Holder.DoJobOnDataUnExists(Job_DoConnect, 0, JCount);

  FActive := True;
end;

procedure TrpcSocketClientChannel.SetActive(const Value: Boolean);
begin
  If Active <> Value Then Begin
    If Value Then
      Open
    else
      Close;
  end;
end;

procedure TrpcSocketClientChannel.SetHost(const Value: String);
begin
  If FHost <> Value Then Begin
    CheckInactive;
    FHost := Value;
  end;
end;

procedure TrpcSocketClientChannel.SetPort(const Value: Word);
begin
  If FPort <> Value Then Begin
    CheckInactive;
    FPort := Value;
  end;
end;

procedure TrpcSocketClientChannel.SetReconnectInterval(
  const Value: Integer);
begin
  If ReconnectInterval <> Value Then Begin
    CheckInactive;
    FReconnectInterval := Value;
  end;
end;

{ TrpcSocketChannelsList }

procedure TrpcSocketChannelsList.Add(const Handle: TrpcSocketHandle; const Address : String);
var P : PrpcSocketHandle;
begin
  New(P);
  P^ := Handle;
  FList.AddObject(Address, TObject(P));
end;

procedure TrpcSocketChannelsList.Clear;
var P : PrpcSocketHandle;
    I : Integer;
begin
  For I := Count - 1 DownTo 0 do Begin
    P := Pointer(FList.Objects[I]);
    FList.Delete(I);
    Dispose(P);
  end;
end;

function TrpcSocketChannelsList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TrpcSocketChannelsList.Create;
begin
  Inherited Create;
  FList := TStringList.Create;
end;

destructor TrpcSocketChannelsList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TrpcSocketChannelsList.GetAddress(Index: Integer): String;
begin
  Result := FList[Index];
end;

function TrpcSocketChannelsList.GetItems(Index: Integer): TrpcSocketHandle;
begin
  Result := PrpcSocketHandle( FList.Objects[Index] )^;
end;

function TrpcSocketChannelsList.ItemExists(const Handle: TrpcSocketHandle): Boolean;
var I : Integer;
begin
  I := Count - 1;
  While (I >= 0) and (Not IsEqualGUID(Handle, Items[I])) do Dec(I);
  Result := I >= 0;
end;

{ TrpcSocketServerChannelHolder }

function TrpcCustomServerChannelHolder.ChannelEnter(Handle: TrpcSocketHandle): TrpcSocketServerChannel;
var I : Integer;
begin
  FChannelsCrit.BeginRead;
  Try
    I := FChannels.Count - 1;
    While (I>=0) and (not IsEqualGUID(Handle, TrpcSocketServerChannel(FChannels[I]).Handle  )) do Dec(I);
    If I >= 0 Then Begin
      Result := TrpcSocketServerChannel(FChannels[I]);
      Result._AddRef;
    end else
      Result := Nil;
  Finally
    FChannelsCrit.EndRead;
  end;
end;

procedure TrpcCustomServerChannelHolder.ChannelsList(
  Dest: TrpcSocketChannelsList);
var I : Integer;
begin
  Dest.Clear;
  FChannelsCrit.BeginRead;
  Try
    For i := 0 to FChannels.Count - 1 do
      If TrpcSocketServerChannel(FChannels[i]).Ready Then
        Dest.Add( TrpcSocketServerChannel(FChannels[i]).Handle, TrpcSocketServerChannel(FChannels[i]).RemoteAddress);
  Finally
    FChannelsCrit.EndRead;
  end;
end;

procedure TrpcCustomServerChannelHolder.Close;
begin
  Try
    InnerClose;
  Finally
    FActive := False;
  end;
end;

constructor TrpcCustomServerChannelHolder.Create;
begin
  Inherited Create;
  FChannels := TList.Create;
  FChannelsCrit := TMultiReadExclusiveWriteSynchronizer.Create;
  FDestroyer := TrpcSocketServerDestroyer.Create;
  //////////////////////////////////////////FDestroyer.DestroyTimeOut := 7000;
  FKeepAliveInterval := 10000;
  FNagleAlgo := False;//True;
end;

destructor TrpcCustomServerChannelHolder.Destroy;
begin
  FDestroyer.Free;
  FChannels.Free;
  FChannelsCrit.Free;
  inherited;
end;

procedure TrpcCustomServerChannelHolder.InnerClose;
var C : TrpcSocketServerChannel;
begin
  Repeat
    //разрушаю каналы
    FChannelsCrit.BeginWrite;
    Try
      If FChannels.Count > 0 Then Begin
        C := TrpcSocketServerChannel(FChannels[FChannels.Count - 1]);
        FChannels.Delete(FChannels.Count - 1);
      end else
        C := Nil;
    Finally
      FChannelsCrit.EndWrite;
    end;
    If C <> Nil Then
      C.Leave;

  Until C = Nil;
end;

procedure TrpcCustomServerChannelHolder.InnerOpen;
begin
end;

procedure TrpcCustomServerChannelHolder.Open;
begin
  InnerOpen;
  FActive := True;
end;

procedure TrpcCustomServerChannelHolder.SetActive(const Value: Boolean);
begin
  If Active <> Value Then Begin
    If Value Then
      Open
    else
      Close;
  end;
end;

procedure TrpcCustomServerChannelHolder.SetEventReceiver(const Value: HWND);
var I : Integer;
begin
  If EventReceiver <> Value Then Begin
    FEventReceiver := Value;
    FChannelsCrit.BeginRead;
    Try
      For i := 0 to FChannels.Count - 1 do
        TrpcSocketCustomChannel(FChannels[i]).EventReceiver := Value;
    Finally
      FChannelsCrit.EndRead;
    end;
  end;
end;

procedure TrpcCustomServerChannelHolder.SetKeepAliveInterval(const Value: Integer);
var I : Integer;
begin
  If KeepAliveInterval <> Value Then Begin
    FKeepAliveInterval := Value;
    FChannelsCrit.BeginRead;
    Try
      For i := 0 to FChannels.Count - 1 do
        TrpcSocketCustomChannel(FChannels[i]).KeepAliveInterval := Value;
    Finally
      FChannelsCrit.EndRead;
    end;
  end;
end;

procedure TrpcCustomServerChannelHolder.SetNagleAlgo(const Value: Boolean);
var I : Integer;
begin
  If FNagleAlgo <> Value Then Begin
    FNagleAlgo := Value;
    FChannelsCrit.BeginRead;
    Try
      For i := 0 to FChannels.Count - 1 do
        TrpcSocketCustomChannel(FChannels[i]).NagleAlgo := Value;
    Finally
      FChannelsCrit.EndRead;
    end;
  end;
end;

{ TrpcSocketServerChannelHolder }

constructor TrpcSocketServerChannelHolder.Create;
begin
  Inherited Create;
  FPort := 7777;
end;

procedure TrpcSocketServerChannelHolder.InnerClose;
begin
  FreeAndNil(FListener); //Перестаю слушать
  Inherited;
end;

procedure TrpcSocketServerChannelHolder.InnerOpen;
begin
  If FListener <> Nil Then
    Close;

  FListener := TrpcSocketServerListener.Create(Self);
end;

procedure TrpcSocketServerChannelHolder.SetPort(const Value: Integer);
begin
  If Port <> Value Then Begin
    If Active Then
      Raise ErpcSocketError.Create('Не могу изменить порт. Сервер уже активирован');
    FPort := Value;
  end;
end;

{ TrpcSocketServerListener }

constructor TrpcSocketServerListener.Create(ChannelHolder: TrpcSocketServerChannelHolder);
var SA : TSockAddr;
begin
  FCrit := TCriticalSection.Create;
  FChannelHolder := ChannelHolder;
  FListener := WinSock.socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  If FListener = WinSock.INVALID_SOCKET Then
    rpcSocketCheck(FListener)
  else Begin
    FillChar(SA, SizeOf(TSockAddr), 0);
    SA.sin_family := AF_INET;
    SA.sin_addr.S_addr := WinSock.INADDR_ANY;
    SA.sin_port := WinSock.htons( ChannelHolder.Port );
    rpcSocketCheck( WinSock.bind(FListener, SA, SizeOf(TSockAddr)) );
    rpcSocketCheck( WinSock.listen(FListener, SOMAXCONN) );
  end;
  Inherited Create(Nil);
end;

destructor TrpcSocketServerListener.Destroy;
begin
  FCrit.Enter;
  Try
    If FListener <> WinSock.INVALID_SOCKET Then
      Try
        rpcSocketCheck(WinSock.closesocket(FListener) );
      Except
        uSysProc.HandleOnException('Закрытие сокета прослушивания', False);
      end;
    FListener := WinSock.INVALID_SOCKET
  Finally
    FCrit.Leave;
  end;
  inherited;
  FCrit.Free;
end;

procedure TrpcSocketServerListener.DoListen;
var SA : TSockAddr;
    L : Integer;
    S, NewSock : TSocket;
begin
  If GetListener(S) Then Begin
    FillChar(SA, SizeOf(TSockAddr), 0);
    L := SizeOf(TSockAddr);
    NewSock := WinSock.accept(S, @SA, @L);
    If NewSock = WinSock.INVALID_SOCKET Then
      Try
        If GetListener(S) Then
          rpcSocketCheck(NewSock); //если S = INVALID_SOCKET то сокет разрушен по дестрою
      Except
        uSysProc.HandleOnException('Операция прослушивания сокета сервером', False);
      end
    else
      TrpcSocketServerChannel.Create( ChannelHolder, NewSock );
  end;
end;

function TrpcSocketServerListener.GetListener(out Socket: TSocket): Boolean;
begin
  FCrit.Enter;
  Try
    Socket := FListener;
    Result := Socket <> WinSock.INVALID_SOCKET;
  Finally
    FCrit.Leave;
  end;
end;

{ TrpcSocketServerChannel }

procedure TrpcSocketServerChannel._AddRef;
begin
  InterlockedIncrement(FRefCount);
end;

procedure TrpcSocketServerChannel.BeforeDestruction;
begin
  if FRefCount <> 0 then
    ErpcSocketError.Create('Не могу разрушить серверный канал RefCount <> 0!');
  inherited;
end;

constructor TrpcSocketServerChannel.Create(Holder: TrpcCustomServerChannelHolder; Socket : TSocket);
var SockAddrIn: TSockAddrIn;
    Size: Integer;
begin
  Inherited Create;
  Holder.FChannelsCrit.BeginWrite;
  Try
    Holder.FChannels.Add(Self);
    _AddRef;
  Finally
    Holder.FChannelsCrit.EndWrite;
  end;
  Try
    FHolder := Holder;
    KeepAliveInterval := Holder.KeepAliveInterval;
    EventReceiver := Holder.EventReceiver;
    NagleAlgo := Holder.NagleAlgo;
    SetSocket( Socket );
    FRemoteAddress := 'Unknown';
    Try
      Size := SizeOf(SockAddrIn);
      If WinSock.getpeername(Socket, SockAddrIn, Size) = 0 Then
        FRemoteAddress := WinSock.inet_ntoa(SockAddrIn.sin_addr);
    except
      uSysProc.HandleOnException('Получение IP адреса клиента', false);
    end;
  Except
    FRefCount := 0;
    RAise;
  end;
end;

procedure TrpcSocketServerChannel.Leave;
var NeedRemove : Boolean;
begin

  if (InterlockedDecrement(FRefCount) <= 0) and (FHolder <> Nil) then
    Try
      Try
        Holder.FChannelsCrit.BeginRead;
        Try
          NeedRemove := Holder.FChannels.IndexOf(Self) > 0;
        Finally
          Holder.FChannelsCrit.EndRead;
        end;
        If NeedRemove Then Begin
          Holder.FChannelsCrit.BeginWrite;
          Try
            Holder.FChannels.Remove(Self);
          Finally
            Holder.FChannelsCrit.EndWrite;
          end;
        end;
      Finally
        Holder.FDestroyer.DestroyChannel(Self);
      end;
    Finally
      FHolder := Nil;
    end;

end;

procedure TrpcSocketServerChannel.DoReceiveApp;
begin
  If (Holder <> Nil) and Assigned(Holder.FOnReceive) Then
    _AddRef;
    Try
      Holder.FOnReceive(Self.Receiver);
    Finally
      Leave;
    end;
end;

procedure TrpcSocketServerChannel.Job_ConnectionLost(IsTerminate : TtmIsTerminateProc);
begin
  Try
    If Holder <> Nil Then Begin
      Holder.FChannelsCrit.BeginWrite;
      Try
        Holder.FChannels.Remove(Self);
      Finally
        Holder.FChannelsCrit.EndWrite;
      end;
    end;
    inherited;
  Finally
    Leave;
  end;
end;

procedure TrpcSocketServerChannel.DoReceive;
var H : TrpcSocketHandle;
    P : Pointer;
    ReceiveLen,
    L : Integer;
begin
  If Receiver.PackType = sptOnConnect Then Begin
    P := @H;
    ReceiveLen := SizeOf( TrpcSocketHandle );

    While not Receiver.Eof and (ReceiveLen > 0) do Begin
      L := Receiver.Receive(P, ReceiveLen );
      Inc(Cardinal(P), L);
      Dec(ReceiveLen, L);
    end;

    If ReceiveLen > 0 Then
      Raise ErpcSocketError.Create('Не корректный системный пакет типа OnConnect!');

    {
    Repeat
      L := Receiver.Receive(P, ReceiveLen );
      Inc(Cardinal(P), L);
      Dec(ReceiveLen, L);
    until ReceiveLen <= 0;
    }
    {CreateGUID(H);

    Receiver.Receive(@H, SizeOf(H) );}

    SetHandle( H );
  end else
    inherited;
end;

{ TrpcSocketServerDestroyer }

destructor TrpcSocketServerDestroyer.Destroy;
//var I : Integer;
begin
  // Не разрушаюсь пока  очередь не будет обработана
  {I := DestroyTimeOut div 10;
  While I > 0 do Begin
    If Queue.IsEmpty Then
      I := 0;
    If I > 0 Then Begin
      Sleep(10);
      Dec(I);
    end;
  end;}

  While not Queue.IsEmpty do Sleep(10);

  inherited;
end;

procedure TrpcSocketServerDestroyer.DestroyChannel(
  Channel: TrpcSocketServerChannel);
begin
  Queue.AddQueueItem( Channel );
end;

procedure TrpcSocketServerDestroyer.DisposeItem(var Item: Pointer);
begin
  Item := Nil;
end;

procedure TrpcSocketServerDestroyer.DoProcessItem(const Item: Pointer);
begin
  Try
    TrpcSocketServerChannel(Item).Free;
  Except
    uSysProc.HandleOnException('Разрушение сокетного канала сервера!');
  end;
end;

var WSAData: TWSAData;
Initialization

  If WinSock.WSAStartup( WINSOCK_VERSION, WSAData ) <> 0 Then
    MessageBox(0, 'Не могу инициализировать '+WINSOCK2_DLL, 'Error', MB_OK);

Finalization
  WinSock.WSACleanup;
end.
