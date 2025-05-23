unit uThreadManage;

interface
Uses Classes, Windows, SysUtils, SyncObjs, Messages;

  {

  В этом модуле я худо бедно реализовал три (теперь уже пять),
  на мой взгляд основных,
  конструкций многопоточной обработки.

  1 Очередь данных последовательно разгребаемая потоком.
  2 Пул потоков наперегонки обрабатывающих поступающие данные.
  3 Плановые задачи, каждая из которых в нужное время, будет обработана
    своим потоком, который умрет после выполнения задачи.
  4 Поток который просто занят все время своим делом. Например
    поток прослушивающий ком порт или сокет на предмет появления
    свежих данных во входящем буфере. Такой поток большую часть
    времени стоит на Event-е оживая по инициативе из вне дабы
    обработать внешнюю ситуацию, и регулярно оживающий по тайм ауту
    чтобы провериться на предмет Terminate.
  5 Поток разгребальщик очереди Win Massage.

  P.S.
  третью конструкцию наверное лучше было бы реализовать при помощи
  пула и однорангового списка задач
  }

Type
  TtmCustomThreadHolder = class;

  TtmCustomSelfDestroyThread = class(TThread)
  private
    FWaitEvent : TEvent;
    FHolder: TtmCustomThreadHolder;
  Protected
    Procedure Drop;
    Property WaitEvent : TEvent Read FWaitEvent;
  Public
    Constructor Create(Holder : TtmCustomThreadHolder);
    Destructor Destroy; Override;
    Property Holder : TtmCustomThreadHolder Read FHolder;
    property Terminated;
  end;

  TtmCustomThreadHolder = class(TObject)
  Private
    FThreadCrit : TCriticalSection;
    FDestroyTimeOut: Cardinal;
  Protected
    Procedure InsertThread(Thread : TtmCustomSelfDestroyThread); Virtual; Abstract;
    Procedure RemoveThread(Thread : TtmCustomSelfDestroyThread); Virtual; Abstract;

    Procedure DropThreads; Virtual; Abstract;
    Function ThreadExist : Boolean; Virtual; Abstract;
    //Пространное описание для записи в лог
    Function Description : String; Virtual;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    {TimeOut Ожидания завершения потоков в mSec}
    Property DestroyTimeOut : Cardinal Read FDestroyTimeOut Write FDestroyTimeOut;
  end;

  TtmSingleThreadHolder = class(TtmCustomThreadHolder)
  Private
    FThread : TtmCustomSelfDestroyThread;
  Protected
    Property Thread : TtmCustomSelfDestroyThread Read FThread;

    Procedure InsertThread(Thread : TtmCustomSelfDestroyThread); Override;
    Procedure RemoveThread(Thread : TtmCustomSelfDestroyThread); Override;
    Procedure DropThreads; Override;
    Function ThreadExist : Boolean; Override;

    Procedure CreateThread; Virtual; Abstract;
  Public
    Constructor Create;
  end;

  TtmListThreadHolder = class(TtmCustomThreadHolder)
  Private
    FThreads : TList;
  Protected
    Procedure InsertThread(Thread : TtmCustomSelfDestroyThread); Override;
    Procedure RemoveThread(Thread : TtmCustomSelfDestroyThread); Override;
    Procedure DropThreads; Override;
    Function ThreadExist : Boolean; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  end;

  {---------- очередь -------------}

  TtmCustomQueueHolder = class;

  {Получает данные
   кладет их в очередь,
   оживает
   обрабатывает очередь
   переходит в режим ожидания до поступления новых данных}
  TtmQueue = class(TtmCustomSelfDestroyThread)
  Private
    FQueue : TThreadList;
    Procedure Clear;
    function GetHolder: TtmCustomQueueHolder;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(Holder : TtmCustomQueueHolder);
    Destructor Destroy; Override;
    Property Holder : TtmCustomQueueHolder Read GetHolder;

    Procedure AddQueueItem(const Item : Pointer);
    Function Length : Integer;
    Function IsEmpty : Boolean;
  end;

  {Наследника делать из холдера. Очередь универсальная.
    Напрямую к Queue не обращаются обращение всегда идет через
   наследника QueueHolder - а }
  TtmCustomQueueHolder = class(TtmSingleThreadHolder)
  Private
    function GetQueue: TtmQueue;
  Protected
    Procedure OnBegin; Virtual;
    Procedure OnEnd; Virtual;

    Procedure CreateThread; Override;
    Property Queue : TtmQueue Read GetQueue;

    Procedure DisposeItem(var Item : Pointer); Virtual; Abstract;
    Procedure DoProcessItem(const Item : Pointer); Virtual; Abstract;
  Public
    {в потомках добавить метод постановки в очередь
     внутри под параметры этого метода выделить память скопировать туда параметры
     и вызвать метод Queue.AddQueueItem(<указатель на выделенную память>)}
  end;



  TtmIsTerminateProc = Function : Boolean Of Object;
  {---------- пул -------------}

  TtmCustomWorkPool = class;

  { В случае если свободна
    принимкает данные и оживает
    по завершении обработки
    выставляет флаг свободна и переходит в режим ожидания

    Напрямую к Work не обращаются обращение всегда идет через пул
   }

  TtmWork = class(TtmCustomSelfDestroyThread)
  Private
    FDataCrit : TCriticalSection;
    FData : Pointer;
    function GetHolder: TtmCustomWorkPool;
    Function IsTerminate : Boolean;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(Holder : TtmCustomWorkPool);
    Destructor Destroy; Override;
    Property Holder : TtmCustomWorkPool Read GetHolder;
    Function TryDoProcess(const Data : Pointer) : Boolean;
  end;

  TtmCustomWorkPool = class(TtmListThreadHolder)
  Private
    FLimitPoolSize: Integer;
    FFreeWaitOnRaise: Cardinal;
  Protected
    Procedure OnBegin; Virtual;
    Procedure OnEnd; Virtual;
    {PoolSize - информативный параметр если произошло расширение пула
     (произошло создание нового TtmWork)
     возвращает размер пула
     в противном случае возвращает -1}
    Procedure DoWork(const Data : Pointer; out PoolSize : Integer);

    Procedure DisposeData(var Data : Pointer); Virtual; Abstract;
    Procedure DoProcessData(const Data : Pointer; const IsTerminate : TtmIsTerminateProc); Virtual; Abstract;
  Public
    Constructor Create(LimitPoolSize : Integer = -1; FreeWaitOnRaise : Cardinal = 7000);
    {<=0 безразмерный}
    Property LimitPoolSize : Integer Read FLimitPoolSize;

    {TimeOut - ожидания освобождения потока при ограниченном размере пула}
    Property FreeWaitOnRaise : Cardinal Read FFreeWaitOnRaise;
    {в потомках добавить метод активации работы
     внутри под параметры этого метода выделить память скопировать туда параметры
     и вызвать метод DoWork(<указатель на выделенную память>)}
  end;

  {---------- расписание -------------}


  {запускается по времени активации
   выполняя переданную в качестве параметра процедуру
   после отработки умирает
  }

  TtmCustomJobHolder = class;

  TtmJobData = procedure(IsTerminate : TtmIsTerminateProc) Of Object;

//  EtmJobTerminate = Class(Exception);

  TtmJob = class(TtmCustomSelfDestroyThread)
  Private
    FData : TtmJobData;
    FStartTime : TDateTime;
    function GetHolder: TtmCustomJobHolder;
    Function IsTerminate : Boolean;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(Holder : TtmCustomJobHolder; const Data : TtmJobData; const StartTime : TDateTime);
    Property Holder : TtmCustomJobHolder Read GetHolder;
  end;

  TtmCustomJobHolder = class(TtmListThreadHolder)
  Private
    FWaitCheckTime: Cardinal;
  Protected
  Public
    Constructor Create( WaitCheckTime : Cardinal );
    Property WaitCheckTime : Cardinal Read FWaitCheckTime;
    //Удалить все работы с связанные с этой проседурой
    Procedure DropJobs(const Data : TtmJobData);

    Procedure DoJob(const Data : TtmJobData; StartTime : TDateTime; out JobCount : Integer);
    {стартует только в том случае если в режиме ожидания нет Job-ов c идентичным методом Data}
    Function DoJobOnDataUnExists(Data : TtmJobData; StartTime : TDateTime; out JobCount : Integer) : Boolean;

    {в потомках МОЖНО добавить метод активации Job
     и вызвать метод DoJob(<выполняемый метод>, <дата и время активации>)}
  end;


  {--------------- Прослушка -------------------- }

  {Все время стоит на Event-e,

   Когда внешнее воздействие взведет Event
   Сбрасывается Event
   Однократно выполняется процедура холдера ThreadExecute
   после чего снова ждем Eventa
   }
  TtmCustomListenerHolder = class;

  TtmListener = class(TtmCustomSelfDestroyThread)
  Private
    function GetHolder: TtmCustomListenerHolder;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(Holder : TtmCustomListenerHolder);
    Property Holder : TtmCustomListenerHolder Read GetHolder;
    //property Terminated;
  end;

  {Наследника делать из холдера. Слушатель универсальный на
   прямую к нему не обращаются все управление через Holder.}
  TtmCustomListenerHolder = class(TtmSingleThreadHolder)
  Private
    FEventOwner : Boolean;
    FListenEvent: TEvent;
    function GetListener: TtmListener;
  Protected
    Procedure OnBegin; Virtual;
    Procedure OnEnd; Virtual;

    Procedure CreateThread; Override;
    Property Listener : TtmListener Read GetListener;

    Function WaitListenEvent : Boolean;
    Function DelayOnListenEvent( Delay : Cardinal ) : Boolean;

    Procedure DoListen; Virtual; Abstract;
    Property ListenEvent : TEvent Read FListenEvent;
  Public
    Constructor Create(ListenEvent : TEvent = Nil);
    Destructor Destroy; Override;

    {в потомках прописать DoListen
     ListenEvent - событие взводимое внешним прикладным воздействием

      WaitListenEvent должно вызываться из DoListen.
      Эта функция  ждет взведения события ListenEvent и в случае успеха
      возвращает True

      DelayOnListenEvent - просто не блокирующая задержка на Delay милисекунд
      применяется когда поток используют для опроса какого либо устройства по
      таймеру.

      обе функции возвращают False если в процессе ожидания
      поток стал Terminated
     }
  end;


  {------------ Разгребалка Win Massage -------------}
  TtmCustomWinMassageDispatcher = class;

  TtmWinMassageDispatcher = class(TtmCustomSelfDestroyThread)
  Private
    function GetHolder: TtmCustomWinMassageDispatcher;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(Holder : TtmCustomWinMassageDispatcher);
    Property Holder : TtmCustomWinMassageDispatcher Read GetHolder;
    property Terminated;
  end;

  TtmCustomWinMassageDispatcher = class(TtmSingleThreadHolder)
  Private
    function GetTerminated: Boolean;
  Protected
    Procedure CreateThread; Override;
    Procedure DropThreads; Override;

    Procedure OnBegin; Virtual;
    Procedure OnEnd; Virtual;
    Procedure OnException; Virtual;
    property Terminated : Boolean Read GetTerminated;
    Procedure PostThreadMessage(Msg : Cardinal; wParam, lParam : Integer);
  Public
    { В потомках OnBegin - Инициализировать окно
                 OnEnd - при необходимости деинициализировать окно
                 OnException - прописать обработчик исключений
    }
  end;


implementation
uses uSysProc;

{const
  TM_SyncronizeOnWnd = WM_USER + 2323;

Type
  PtmSyncronizeOnWndRec = ^TtmSyncronizeOnWndRec;
  TtmSyncronizeOnWndRec = Record
    Proc : TThreadMethod;
    Event : TEvent;
  end;

  //Процедура синхронного выполнения метода Proc в потоке окна Wnd
  //без мертвого блокирования
  Procedure tmSyncronizeOnWnd(const Proc : TThreadMethod; const IsTerminate : TtmIsTerminateProc; Wnd : HWnd);
  var P  : PtmSyncronizeOnWndRec;
      WR : TWaitResult;
  Begin
    New(P);
    P.Proc := Proc;
    P.Event := TSimpleEvent.Create;

    PostMessage(Wnd, TM_SyncronizeOnWnd, Integer(P), 0);

    WR := wrTimeout;
    While (not IsTerminate) and (WR = wrTimeout) do
      WR := P.Event.WaitFor(1);



  end;
}

{ TCustomSelfDestroyThread }

constructor TtmCustomSelfDestroyThread.Create(Holder : TtmCustomThreadHolder);
begin
  FHolder := Holder;
  Holder.FThreadCrit.Enter;
  Try
    Holder.InsertThread(Self);
  Finally
    Holder.FThreadCrit.Leave;
  end;
  FWaitEvent := TSimpleEvent.Create;
  FreeOnTerminate := True;
  Inherited Create(False);
end;

destructor TtmCustomSelfDestroyThread.Destroy;
begin
  Drop;
  inherited;
  Try
    Holder.FThreadCrit.Enter;
    Try
      Holder.RemoveThread(Self);
    Finally
      Holder.FThreadCrit.Leave;
    end;
  Except
    uSysProc.HandleOnException('Разрушение потока '+Holder.Description+'!');
  end;
  FWaitEvent.Free;
end;

procedure TtmCustomSelfDestroyThread.Drop;
begin
  Terminate;
  FWaitEvent.SetEvent;
end;

{ TCustomQueue }

function TtmQueue.IsEmpty: Boolean;
var L : TList;
begin
  L := FQueue.LockList;
  Try
    Result := L.Count <= 0;
  Finally
    FQueue.UnlockList;
  end;
end;

procedure TtmQueue.AddQueueItem(const Item: Pointer);
var L : TList;
begin
  L := FQueue.LockList;
  Try
    L.Add(Item);
    FWaitEvent.SetEvent;
  Finally
    FQueue.UnlockList;
  end;
end;

function TtmQueue.Length: Integer;
var L : TList;
begin
  L := FQueue.LockList;
  Try
    Result := L.Count;
  Finally
    FQueue.UnlockList;
  end;
end;

procedure TtmQueue.Clear;
var L : TList;
    I : Integer;
    P : Pointer;
begin
  L := FQueue.LockList;
  Try
    For I := L.Count-1 Downto 0 do Begin
      P := L[I];
      L.Delete(I);
      Try
        Holder.DisposeItem(P);
      except
        uSysProc.HandleOnException('Освобождение памяти от элемента очереди '+Holder.Description);
      end;
    end;
  Finally
    FQueue.UnlockList;
  end;
end;

constructor TtmQueue.Create(Holder : TtmCustomQueueHolder);
begin
  FQueue := TThreadList.Create;
  Inherited Create(Holder);
end;

destructor TtmQueue.Destroy;
begin
  inherited;
  Clear;
  FQueue.Free;
end;

procedure TtmQueue.Execute;
var L : TList;
    P : Pointer;
begin
  Holder.OnBegin;
  Try
    While not Terminated do
      Try
        L := FQueue.LockList;
        Try
          If L.Count > 0 Then Begin
            P := L[0];
            L.Delete(0);
            FWaitEvent.SetEvent;
          end else Begin
            P := Nil;
            FWaitEvent.ResetEvent;
          end;
        Finally
          FQueue.UnlockList;
        end;
        If P <> Nil Then Begin
          Try
            Holder.DoProcessItem(P);
          Finally
            Holder.DisposeItem(P);
          end;
        end;

        If not Terminated Then
          FWaitEvent.WaitFor( INFINITE );
      Except
        uSysProc.HandleOnException('Ожидание активации очереди '+Holder.Description+'!')
      end;
  Finally
    Holder.OnEnd;
  end;
end;

{ TSingleThreadHolder }

constructor TtmSingleThreadHolder.Create;
begin
  Inherited Create;
  CreateThread;
end;

procedure TtmSingleThreadHolder.DropThreads;
begin
  If FThread <> Nil Then
    FThread.Drop;
end;

procedure TtmSingleThreadHolder.InsertThread(
  Thread: TtmCustomSelfDestroyThread);
begin
  FThread := Thread;
end;

procedure TtmSingleThreadHolder.RemoveThread(
  Thread: TtmCustomSelfDestroyThread);
begin
  If FThread = Thread Then
    FThread := Nil;
end;

function TtmSingleThreadHolder.ThreadExist: Boolean;
begin
  Result := FThread <> Nil;
end;

{ TCustomThreadHolder }

constructor TtmCustomThreadHolder.Create;
begin
  Inherited Create;
  FThreadCrit := TCriticalSection.Create;
  If FDestroyTimeOut = 0 Then //Чтобы можно было его инициализировать в потомках до вызова Inherited Create
    FDestroyTimeOut := 1000;

  FDestroyTimeOut := INFINITE;
end;

function TtmCustomThreadHolder.Description: String;
begin
  Result := '';
end;

destructor TtmCustomThreadHolder.Destroy;
var I : Integer;
begin
  If FThreadCrit <> Nil Then Begin
    FThreadCrit.Enter;
    Try
      DropThreads;
    Finally
      FThreadCrit.Leave;
    end;

    {жду секунду завершения}
    I := DestroyTimeOut div 10;
    While I > 0 do Begin
      FThreadCrit.Enter;
      Try
        If not ThreadExist Then
          I := 0;
      Finally
        FThreadCrit.Leave;
      end;

      If I > 0 Then Begin
        Sleep(10);
        Dec(I);
      end;
    end;

    FThreadCrit.Free;
  end;
  inherited;
end;

{ TListThreadHolder }

constructor TtmListThreadHolder.Create;
begin
  FThreads := TList.Create;
  Inherited Create;
end;

destructor TtmListThreadHolder.Destroy;
begin
  inherited;
  FThreads.Free;
end;

procedure TtmListThreadHolder.DropThreads;
var I : Integer;
begin
  If FThreads <> Nil Then
    For I := FThreads.Count - 1 DownTo 0 do
      TtmCustomSelfDestroyThread(FThreads[I]).Drop;
end;

procedure TtmListThreadHolder.InsertThread(
  Thread: TtmCustomSelfDestroyThread);
begin
  FThreads.Add(Thread);
end;

procedure TtmListThreadHolder.RemoveThread(Thread: TtmCustomSelfDestroyThread);
begin
  FThreads.Remove(Thread);
end;

function TtmListThreadHolder.ThreadExist: Boolean;
begin
  Result := FThreads.Count > 0;
end;

function TtmQueue.GetHolder: TtmCustomQueueHolder;
begin
  Result := (Inherited Holder) as TtmCustomQueueHolder;
end;

{ TCustomQueueHolder }

procedure TtmCustomQueueHolder.CreateThread;
begin
  TtmQueue.Create(Self);
end;

function TtmCustomQueueHolder.GetQueue: TtmQueue;
begin
  Result := FThread as TtmQueue;
end;

{ TtmCustomWorkPool }

constructor TtmCustomWorkPool.Create(LimitPoolSize: Integer; FreeWaitOnRaise : Cardinal);
begin
  FLimitPoolSize := LimitPoolSize;
  FFreeWaitOnRaise := FreeWaitOnRaise;
  Inherited Create;
end;

procedure TtmCustomWorkPool.DoWork(const Data: Pointer; out PoolSize : Integer);
var I : Integer;
    TryTime, TryStart : Cardinal;
    NeedRepeat : Boolean;
begin
  PoolSize := -1;
  TryTime := 0;
  TryStart := GetTickCount;

  Repeat
    NeedRepeat := False;
    FThreadCrit.Enter;
    Try

      I := FThreads.Count-1;
      While (I>=0) and (not TtmWork(FThreads[I]).TryDoProcess(Data)) do Dec(I);

      If (I < 0) Then Begin
        If (LimitPoolSize<=0) or  (LimitPoolSize < FThreads.Count) Then Begin
          If not TtmWork.Create(Self).TryDoProcess(Data) Then
            raise Exception.Create('Ну вот! Свеже созданный поток оказался занятым');
          PoolSize := FThreads.Count;
        end else Begin
          {повторить попытку}
          NeedRepeat := True;
          TryTime := GetTickCount - TryStart;
        end;
      end;

    Finally
      FThreadCrit.Leave;
    end;

  Until (not NeedRepeat) or (TryTime > FreeWaitOnRaise);

  If NeedRepeat Then
    raise Exception.Create('Work pool of class '+ClassName+' Не могу получить свободный поток для обработки данных');
end;

procedure TtmCustomWorkPool.OnBegin;
begin
end;

procedure TtmCustomWorkPool.OnEnd;
begin
end;

{ TtmWork }

constructor TtmWork.Create(Holder: TtmCustomWorkPool);
begin
  FDataCrit := TCriticalSection.Create;
  FData := Nil;
  Inherited Create(Holder)
end;

destructor TtmWork.Destroy;
begin
  inherited;
  FDataCrit.Enter;
  Try
    If FData <> Nil Then
      Try
        Holder.DisposeData(FData);
      except
        uSysProc.HandleOnException('Освобождение памяти от данных пула при разрушении потока '+Holder.Description+'!')
      end;
  finally
    FDataCrit.Leave;
  end;
  FDataCrit.Free;
end;

procedure TtmWork.Execute;
var P : Pointer;
begin
  Holder.OnBegin;
  Try
  While not Terminated do
    Try
      FDataCrit.Enter;
      Try
        P := FData;
        FWaitEvent.ResetEvent;
      Finally
        FDataCrit.Leave;
      end;

      If (P <> Nil) and (not Terminated) Then Begin
        Try
          Holder.DoProcessData(P, IsTerminate);
        Finally
          FDataCrit.Enter;
          Try
            Try
              Holder.DisposeData(FData);
            except
              uSysProc.HandleOnException('Освобождение памяти от данных пула '+Holder.Description+'!')
            end;
            FData := Nil;
          Finally
            FDataCrit.Leave;
          end;
        end;
      end;

      If Not Terminated Then
        FWaitEvent.WaitFor( INFINITE );
    Except
      uSysProc.HandleOnException('Ожидание активации потока пула '+Holder.Description+'!')
    end;
  Finally
    Holder.OnEnd;
  end;
end;

function TtmWork.GetHolder: TtmCustomWorkPool;
begin
  Result := (Inherited Holder) as TtmCustomWorkPool;
end;

function TtmWork.IsTerminate: Boolean;
begin
  Result := Terminated;
end;

function TtmWork.TryDoProcess(const Data: Pointer): Boolean;
begin
  FDataCrit.Enter;
  Try
    If (FData = Nil) and (not Terminated) Then Begin
      FData := Data;
      FWaitEvent.SetEvent;
      Result := True;
    end else
      Result := False;
  Finally
    FDataCrit.Leave;
  end;

end;

{ TtmJob }

Function TtmJob.IsTerminate : Boolean;
begin
  Result := Terminated;
//    RAise EtmJobTerminate.Create(ClassName + ' Принудительное внешнее прерывание');
end;

constructor TtmJob.Create(Holder: TtmCustomJobHolder; const Data: TtmJobData; const StartTime: TDateTime);
begin
  FData := Data;
  FStartTime := StartTime;
  Inherited Create(Holder);
end;

procedure TtmJob.Execute;
Begin
  FWaitEvent.ResetEvent;
  While (not Terminated) do
    If Now >= FStartTime Then Begin
      Try
        FData( IsTerminate );
      Finally
        Terminate;
      end;
    end else
      FWaitEvent.WaitFor( Holder.WaitCheckTime );
end;

function TtmJob.GetHolder: TtmCustomJobHolder;
begin
  Result := (inherited Holder) as TtmCustomJobHolder;
end;

{ TtmCustomJobHolder }

constructor TtmCustomJobHolder.Create(WaitCheckTime: Cardinal);
begin
  FWaitCheckTime := WaitCheckTime;
  Inherited Create;
end;

procedure TtmCustomJobHolder.DoJob(const Data: TtmJobData; StartTime: TDateTime; out JobCount: Integer);
begin
  FThreadCrit.Enter;
  Try
    JobCount := FThreads.Count + 1;
  finally
    FThreadCrit.Leave;
  end;
  TtmJob.Create(Self, Data, StartTime);
end;

function TtmCustomJobHolder.DoJobOnDataUnExists(Data: TtmJobData; StartTime: TDateTime; out JobCount: Integer): Boolean;
var I : Integer;
    M1, M2 : TMethod;
begin
  Result := True;
  FThreadCrit.Enter;
  Try
    I := FThreads.Count - 1;
    While (I>=0) and Result Do Begin
      M1 := TMethod(Data);
      M2 := TMethod( TtmJob(FThreads[i]).FData );

      Result := (M1.Data <> M2.Data) or (M1.Code <> M2.Code);
      dec(I);
    end;
  finally
    FThreadCrit.Leave;
  end;
  If Result Then
    DoJob(Data, StartTime, JobCount);
end;

procedure TtmCustomJobHolder.DropJobs(const Data: TtmJobData);
var I : Integer;
    Index : Integer;
    M1, M2 : TMethod;
begin
  M1 := TMethod(Data);
  FThreadCrit.Enter;
  Try
    For I := FThreads.Count - 1 DownTo 0 do Begin
      M2 := TMethod( TtmJob(FThreads[i]).FData );
      If (M1.Data = M2.Data) and (M1.Code = M2.Code) Then
        TtmJob(FThreads[I]).Drop;
    end;
  finally
    FThreadCrit.Leave;
  end;

  {жду  завершения}
  I := DestroyTimeOut div 10;
  While I > 0 do Begin
    FThreadCrit.Enter;
    Try
      Index := FThreads.Count - 1;
      While (Index>=0) do Begin
        M2 := TMethod( TtmJob(FThreads[Index]).FData );
        If (M1.Data = M2.Data) and (M1.Code = M2.Code) Then
          Break
        else
          dec(Index);
      end;

      If Index < 0 Then
        I := 0;
    Finally
      FThreadCrit.Leave;
    end;

    If I > 0 Then Begin
      Sleep(10);
      Dec(I);
    end;
  end;
end;

{ TtmCustomListenerHolder }

constructor TtmCustomListenerHolder.Create(ListenEvent: TEvent);
begin
  FEventOwner := ListenEvent = Nil;
  If FEventOwner Then
    FListenEvent := TSimpleEvent.Create
  else
    FListenEvent := ListenEvent;
  Inherited Create;
end;

destructor TtmCustomListenerHolder.Destroy;
begin
  inherited;
  If FEventOwner Then
    FListenEvent.Free;
  FListenEvent := Nil;
end;

procedure TtmCustomListenerHolder.CreateThread;
begin
  TtmListener.Create(Self);
end;

function TtmCustomListenerHolder.GetListener: TtmListener;
begin
  Result := FThread as TtmListener;
end;

function TtmCustomListenerHolder.WaitListenEvent: Boolean;
{var Interval : Cardinal;
begin
  Result := False;
  Interval := DestroyTimeOut div 10;
  If Interval > 1000 Then
    Interval := 100;
  While ListenEvent.WaitFor( Interval ) = wrTimeout do
    If Listener.Terminated Then
      exit;
  Result := True;}

const cHandlesCount = 2;
var Handles: array [0..cHandlesCount-1] of THandle;
begin
  Result := False;
  Handles[0] := Thread.WaitEvent.Handle;
  Handles[1] := ListenEvent.Handle;

  Case WaitForMultipleObjects(cHandlesCount, @Handles, False, Infinite) of
    WAIT_TIMEOUT,
    WAIT_OBJECT_0     : Result := False;
    WAIT_OBJECT_0 + 1 : Result := not Thread.Terminated;
    else RaiseLastOSError;
  end;
end;

function TtmCustomListenerHolder.DelayOnListenEvent(Delay: Cardinal): Boolean;
{var Dlt : Cardinal;
begin
  Result := False;
//  ListenEvent.ResetEvent;
  Dlt := DestroyTimeOut div 10;
  If Dlt > Delay Then
    Dlt := Delay;

  While (Delay > 0) and (ListenEvent.WaitFor( Dlt ) = wrTimeout) do
    If Listener.Terminated Then
      exit
    else
    If Dlt > Delay Then
      Delay := 0
    else
      Dec(Delay, Dlt);

  Result := True;}
const cHandlesCount = 2;
var Handles: array [0..cHandlesCount-1] of THandle;
begin
  Result := False;
  Handles[0] := Thread.WaitEvent.Handle;
  Handles[1] := ListenEvent.Handle;

  Case WaitForMultipleObjects(cHandlesCount, @Handles, False, Delay) of
    WAIT_TIMEOUT,      //: Result := True;
    WAIT_OBJECT_0 + 1 : Result := not Thread.Terminated;
    WAIT_OBJECT_0     : Result := False;
    else RaiseLastOSError;
  end;
end;

procedure TtmCustomListenerHolder.OnBegin;
begin
end;

procedure TtmCustomListenerHolder.OnEnd;
begin
end;

{ TtmListener }

constructor TtmListener.Create(Holder: TtmCustomListenerHolder);
begin
  Inherited Create(Holder);
end;

procedure TtmListener.Execute;
begin
  Holder.OnBegin;
  Try
  While not Terminated do
    Try
      Holder.DoListen;
    except
      uSysProc.HandleOnException('поток прослушивания '+Holder.Description+'!', False)
    end;
  Finally
    Holder.OnEnd;
  end;
end;

function TtmListener.GetHolder: TtmCustomListenerHolder;
begin
  Result := (Inherited Holder) as TtmCustomListenerHolder;
end;

{ TtmCustomWinMassageDispatcher }

procedure TtmCustomWinMassageDispatcher.CreateThread;
begin
  TtmWinMassageDispatcher.Create(Self);
end;

procedure TtmCustomWinMassageDispatcher.DropThreads;
begin
  PostThreadMessage(WM_Quit, 0 ,0);
  inherited;
end;

function TtmCustomWinMassageDispatcher.GetTerminated: Boolean;
begin
  Result := (FThread = Nil) or FThread.Terminated;
end;

procedure TtmCustomWinMassageDispatcher.OnBegin;
begin
end;

procedure TtmCustomWinMassageDispatcher.OnEnd;
begin
end;

procedure TtmCustomWinMassageDispatcher.OnException;
begin
  uSysProc.HandleOnException('Поток '+Description+' обработки оконных сообщений!');
end;

procedure TtmCustomWinMassageDispatcher.PostThreadMessage(Msg : Cardinal; wParam,
  lParam: Integer);
begin
  If FThread <> Nil Then
    Windows.PostThreadMessage(FThread.ThreadID, Msg, wParam, lParam);
end;

{ TtmWinMassageDispatcher }

constructor TtmWinMassageDispatcher.Create(
  Holder: TtmCustomWinMassageDispatcher);
begin
  Inherited Create(Holder);
end;

procedure TtmWinMassageDispatcher.Execute;
var AMessage : Windows.TMsg;
begin
  Holder.OnBegin;
  Try
    While (not Terminated) and Windows.GetMessage(AMessage, 0, 0, 0) do
      Try
        // GetMessage возвращает false на WM_QUIT
        {if aMessage.Message = WM_QUIT Then //Можно было и не писать
          Terminate
        else}
        If (aMessage.hwnd = 0) and
           (aMessage.Message > WM_USER)
        Then
          Holder.Dispatch( aMessage.Message )
        else Begin
          TranslateMessage(AMessage);
          DispatchMessage(AMessage);
        end;
      Except
        Holder.OnException;
      end;
  Finally
    Holder.OnEnd;
  end;
end;

function TtmWinMassageDispatcher.GetHolder: TtmCustomWinMassageDispatcher;
begin
  Result := (Inherited Holder) as TtmCustomWinMassageDispatcher;
end;

procedure TtmCustomQueueHolder.OnBegin;
begin
end;

procedure TtmCustomQueueHolder.OnEnd;
begin
end;

end.
