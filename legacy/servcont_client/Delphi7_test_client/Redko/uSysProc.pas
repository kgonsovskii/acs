unit uSysProc;

interface
Uses Windows, SysUtils, Classes, SyncObjs;

Type
  TLogMessageType = (lmtMessage, lmtEvent, lmtWarning, lmtDebug, lmtError);
  TsLogMessageType = String[8];
const
  cLogMessageTypeNames : array[TLogMessageType] of TsLogMessageType =
  ('Message ',
   'Event   ',
   'Warning ',
   'Debug   ',
   'Error   ');

  cStartApplicationMessage = 'Start application';


function GetWindowsDir: string;
Function NetName : String;

//Это такая фича заменяющая собой ParamStr(0)
//С той лиш разницей что ее можно переопределить
Function MainAppFile : TFileName;
Procedure InitializeMainAppFile(Value : TFileName);


Type
  TFileVersionKey = (fvkCompanyName, fvkFileDescription, fvkFileVersion, fvkInternalName, fvkLegalCopyright, fvkLegalTradeMarks, fvkOriginalFileName, fvkProductName, fvkProductVersion, fvkComments);
function FileVersion(Key : TFileVersionKey; FileName : String = ''): string;


Function RenameToBakFile(const fName : TFileName) : TFileName;
Function RelativeToAbsPath(const RelativeFileName : String; AppPath : String = '') : String;
Function AbsToRelativePath(AbsFileName : String; AppPath : String = '') : String;


procedure DecodeLastException(out EClass : TClass; Out sClass, sMessage : String);

Function HandleOnException(const Note : String; EnableShowMessage : Boolean = True) : String;
Function FmtHandleOnException(const Note : String; const MesArgs: array of const; EnableShowMessage : Boolean = True) : String;
Procedure HandleLogMessage(const MessageType : TLogMessageType; const Mes : String);
Procedure FmtHandleLogMessage(const MessageType : TLogMessageType; const Mes : String; const MesArgs: array of const);
Procedure ShowException(Show : Boolean);
Procedure LoggedDebugMessage(Logged : Boolean);

Procedure GetLogProperty(Dest : TStrings);
Procedure SetLogProperty(Source : TStrings);


Function MemBufToHexStr(const MemBuf : String) : String;
Function HexStrToMemBuf(const RPCStr : String) : String;

Procedure StrSeparateToStrings(const Source : String; Dest : TStrings; Const Separator : Char = '|');
Function StringsToStrSeparate(Source : TStrings; Const Separator : Char = '|') : String;

Procedure SafeThread_InitFileOperation;
Function SafeThread_CreateUniqueFile(Out fName : TFileName; const Ext : String = '') : TStream;
Procedure SafeThread_DropFile(const fName : TFileName );
Procedure SafeThread_RenameFile(OldFileName, NewFileName : TFileName);
Procedure SafeThread_RenameToUniqueFile(OldFileName : TFileName; Out NewUniqueFileName : TFileName; const Ext : String = '');

Function CodePassword(Source : String) : String;
Function DecodePassword(Source : String) : String;

//Извлекает из ParamStr вида <Exe NAme> [/|-<Switch1>=<Value1> [...]] Value ключа
Function SwitchValue(const Switch : String; const Default : String = '') : String;

Type
  TOnExceptionProc = Procedure(const Note : String; Out sClass, cMessage : String);
  TLogMessageProc = Procedure(const MessageType : TLogMessageType; const Mes : String);
//  TOnBackgroundExceptionEvent = procedure(Sender : TObject; EClass : TClass; const EClassName, EMessage, SenderNote : String) Of Object;
  TShowExceptionProc = procedure(const sClass, sMessage, sNote : String);
  TGetSetLogPropertyProc = procedure(LogProperty : TStrings);


var _HandleOnExceptionProc : TOnExceptionProc;
    _HandleLogMessageProc : TLogMessageProc;
    _HandleShowException : TShowExceptionProc;
    _HandleGetLogProperty : TGetSetLogPropertyProc;
    _HandleSetLogProperty : TGetSetLogPropertyProc;

implementation
var _ShowException : Boolean;
    _LoggedDebugMessage : Boolean;
    //_FileOperationMutex : THAndle;
    _FileOperationCrit : TCriticalSection;
    //_FileOperationIndex : Integer;


Procedure ShowException(Show : Boolean);
Begin
  _ShowException := Show;
end;

Procedure LoggedDebugMessage(Logged : Boolean);
Begin
  _LoggedDebugMessage := Logged;
end;

Procedure GetLogProperty(Dest : TStrings);
Begin
  If Assigned(_HandleGetLogProperty) Then
    _HandleGetLogProperty(Dest);

  If _LoggedDebugMessage Then
    Dest.Values['LoggedDebugMessage'] := 'True'
  else
    Dest.Values['LoggedDebugMessage'] := 'False';
end;

Procedure SetLogProperty(Source : TStrings);
Begin
  If Assigned(_HandleSetLogProperty) Then
    _HandleSetLogProperty(Source);

  _LoggedDebugMessage := SameText(Source.Values['LoggedDebugMessage'], 'True');
end;

Procedure SafeThread_InitFileOperation;
Begin
  {
  Try
    If MainThreadID <> Windows.GetCurrentThreadId Then
      Raise Exception.Create('Инициализируйте SafeThread в секции Initialization');

    If _FileOperationMutex = 0 Then Begin
      _FileOperationMutex := Windows.CreateMutex(Nil, False, 'tss_SafeThreadOperationsMutex');
      _FileOperationIndex := 0;
    end;
    If _FileOperationMutex = 0 Then
      RaiseLastOSError;
  Except
    On E : Exception do
      Windows.MessageBox(0, PChar(E.Message), 'Ошибка инициализации', MB_OK)
    else
      Windows.MessageBox(0, 'Неизвестная ошибка при выполнении SafeThread_InitFileOperation' , 'Ошибка инициализации', MB_OK);
  end;
  If _FileOperationMutex = 0 Then
    Raise Exception.Create('Ошибка инициализации SafeThread functions!');
  }
  Try
    If MainThreadID <> Windows.GetCurrentThreadId Then
      Raise Exception.Create('Инициализируйте SafeThread в секции Initialization');

    If _FileOperationCrit = Nil Then
      _FileOperationCrit := TCriticalSection.Create;
  Except
    On E : Exception do
      Windows.MessageBox(0, PChar(E.Message), 'Ошибка инициализации', MB_OK)
    else
      Windows.MessageBox(0, 'Неизвестная ошибка при выполнении SafeThread_InitFileOperation' , 'Ошибка инициализации', MB_OK);
  end;
  If _FileOperationCrit = Nil Then
    Raise Exception.Create('Ошибка инициализации SafeThread functions!');

end;

Function InnerGenUniqueFileName(Ext : String) : TFileNAme;
var fPAth : String;
    I : Integer;
Begin
  If Ext = '' Then
    Ext := '.~Tmp';

  fPath := IncludeTrailingPathDelimiter(ExtractFilePath(uSysProc.MainAppFile));
  I := 0;
  Repeat
    Inc(I);
    //I := Windows.InterlockedIncrement( _FileOperationIndex );
    Result := fPath + 'Tmp'+IntToHex(GetCurrentProcessId, 8)+'_'+
                            IntToHex(GetCurrentThreadId, 8)+'_'+
                            IntToHex(I, 8) + Ext;
  until not FileExists( Result );
end;


Function SafeThread_CreateUniqueFile(Out fName : TFileName; const Ext : String = '') : TStream;
Begin
  If _FileOperationCrit = Nil Then
    Raise Exception.Create('SafeThread file function not Initialize.' );

  _FileOperationCrit.Enter;
  Try
    fName := InnerGenUniqueFileName(Ext);
    Result := TFileStream.Create(fNAme, fmCreate);
    Windows.FlushFileBuffers( TFileStream(Result).Handle );
  Finally
    _FileOperationCrit.Leave;
  end;
end;

Procedure SafeThread_DropFile(const fName : TFileName );
Begin
  If _FileOperationCrit = Nil Then
    Raise Exception.Create('SafeThread file function not Initialize.' );

  _FileOperationCrit.Enter;
  Try
    If FileExists( fName ) Then Begin
      If not SysUtils.DeleteFile(fName) Then
        RaiseLastOSError;
    end;
  Finally
    _FileOperationCrit.Leave;
  end;
end;

Procedure SafeThread_RenameToUniqueFile(OldFileName : TFileName; Out NewUniqueFileName : TFileName; const Ext : String = '');
Begin
  If _FileOperationCrit = Nil Then
    Raise Exception.Create('SafeThread file function not Initialize.' );

  _FileOperationCrit.Enter;
  Try
    NewUniqueFileName := InnerGenUniqueFileName(Ext);
    If not RenameFile(OldFileName, NewUniqueFileName) Then
      RaiseLastOSError;
  Finally
    _FileOperationCrit.Leave;
  end;
end;


Procedure SafeThread_RenameFile(OldFileName, NewFileName : TFileName);
Begin
  If _FileOperationCrit = Nil Then
    Raise Exception.Create('SafeThread file function not Initialize.' );

  _FileOperationCrit.Enter;
  Try
    If not RenameFile(OldFileName, NewFileName) Then
      RaiseLastOSError;
  Finally
    _FileOperationCrit.Leave;
  end;
end;

Function HandleOnException(const Note : String; EnableShowMessage : Boolean = True) : String;
var sClass, sMessage : String;
    Proc : TShowExceptionProc;
Begin
  If Assigned( _HandleOnExceptionProc ) Then Begin
    _HandleOnExceptionProc( Note, sClass, sMessage);

    If EnableShowMessage and
       _ShowException and
       (GetCurrentThreadID = System.MainThreadID) Then
      Try
        Proc := _HandleShowException;
        If Assigned(Proc) Then
          Proc(sClass, sMessage, Note);
      Except
      end;

  end else Begin
    If (System.MainThreadID = Windows.GetCurrentThreadId) and
        Assigned( Classes.ApplicationHandleException )
    Then
      Classes.ApplicationHandleException(Nil);

    Try
      sClass := ExceptObject.ClassName;
      if ExceptObject is Exception then
        sMessage := (ExceptObject as Exception).Message
      else
        sMessage := '';
    Except
      sClass := 'UnknownExceptionClass';
      sMessage := '';
    end;
  end;
  Result := sClass + #13 +'WithMessage:'+ #13 +sMessage;
end;

Function SwitchValue(const Switch : String; const Default : String = '') : String;
var I : Integer;
    S : String;
    NameStart, SepPos : Integer;
Begin
  Result := Default;
  For I := 1 to ParamCount do Begin
    S := ParamStr(I);
    If (Length(S) > 1) and ((S[1] = '/') or (S[1] = '-')) Then
      NameStart := 2
    else
      NameStart := 1;

    SepPos := Pos('=', S);
    If (SepPos > 0) and
       AnsiSameText(Copy(S, NameStart, SepPos - NameStart), Switch)
    Then Begin
      Result := Copy(S, SepPos+1, MaxInt);
      Break;
    end;
  end;
end;


Function FmtHandleOnException(const Note : String; const MesArgs: array of const; EnableShowMessage : Boolean = True) : String;
Begin
  Result := HandleOnException(Format(Note, MesArgs), EnableShowMessage);
end;

Procedure HandleLogMessage(const MessageType : TLogMessageType; const Mes : String);
Begin
  (*
  {$IFOPT D+}
    //Compiled with debugInfo
    If Assigned( _HandleLogMessageProc ) Then
    _HandleLogMessageProc( MessageType, Mes );
  {$ELSE}
    //Без
    If Assigned( _HandleLogMessageProc ) and (MessageType <> lmtDebug) Then
      _HandleLogMessageProc( MessageType, Mes );
  {$ENDIF}
  *)

  If _LoggedDebugMessage or (MessageType <> lmtDebug) Then Begin

    If Assigned( _HandleLogMessageProc ) Then
      _HandleLogMessageProc( MessageType, Mes );

  end;
end;

Procedure FmtHandleLogMessage(const MessageType : TLogMessageType; const Mes : String; const MesArgs: array of const);
Begin
  HandleLogMessage( MessageType, Format(Mes, MesArgs) );
end;

function GetWindowsDir: string;
var
  Buffer: array[0..1023] of Char;
begin
  SetString(Result, Buffer, GetWindowsDirectory(Buffer, SizeOf(Buffer)));
  Result := IncludeTrailingPathDelimiter(Result);
end;

Function NetName : String;
Var L : DWord;
begin
  SetLength(Result, MAX_COMPUTERNAME_LENGTH);
  L := Length(Result);
  if GetComputerName( @Result[1], L) then
    Result := Copy( Result, 1, L )
  else
    Result := 'UnknownNetName';
end;

procedure DecodeLastException(out EClass : TClass; Out sClass, sMessage : String);
var EObj : TObject;
Begin
  Try
    EClass := Nil;
    sClass := 'Nil';
    sMessage := 'Unknown Exception message';
    EObj := ExceptObject;
    If EObj <> Nil Then Begin
      EClass := EObj.ClassType;
      sClass := EObj.ClassName;
      if EObj is Exception then Begin
        sMessage := (EObj as Exception).Message;
      end;
    end;
  Except
  end;
end;

Function RenameToBakFile(const fName : TFileName) : TFileName;
var //BakName : TFileName;
    Ext : String;
Begin
  If FileExists(fName) Then Begin
    Ext := ExtractFileExt( fName );
    If Length(Ext) > 1 Then
      Ext := '.~'+Copy(Ext, 2, MaxInt)
    else
      Ext := '.~';

    Result := ChangeFileExt(fName, Ext);
    If FileExists(Result) Then Begin
      If not DeleteFile( Result ) Then
        RaiseLastOSError;
    end;

    If not RenameFile(fName, Result) Then
      RaiseLastOSError;
  end else
    ForceDirectories( ExtractFilePath(fName) );
end;

Function RelativeToAbsPath(const RelativeFileName : String; AppPath : String = '') : String;
var OldCurDir : String;
Begin
  If AppPath = '' Then
    AppPath := ExtractFilePath( uSysProc.MainAppFile );

  OldCurDir := GetCurrentDir;
  Try
    SetCurrentDir( AppPath );
    Result := ExpandFileName( RelativeFileName );
  Finally
    SetCurrentDir( OldCurDir );
  end;
end;

Function AbsToRelativePath(AbsFileName : String; AppPath : String = '') : String;
Begin
  If AppPath = '' Then
    AppPath := ExtractFilePath( uSysProc.MainAppFile );

  If (Length(AbsFileName) > 0) and (AbsFileName[1] = '"') Then
    AbsFileName := Copy(AbsFileName, 2, MaxInt);

  If (Length(AbsFileName) > 0) and (AbsFileName[Length(AbsFileName)] = '"') Then
    AbsFileName := Copy(AbsFileName, 1, Length(AbsFileName)-1);

  Result := ExtractRelativePath(AppPath, AbsFileName);
end;


Function MemBufToHexStr(const MemBuf : String) : String;
var I : Integer;
    P : Pointer;
Begin
  SetLength(Result, 2*Length(MemBuf));
  P := PChar(Result);

  For I := 1 to Length( MemBuf ) do Begin
    Move(PChar( IntToHex(Ord(MemBuf[I]), 2) )^, P^, 2);
    Inc(Cardinal(P), 2);
  end;
end;

Function HexStrToMemBuf(const RPCStr : String) : String;
var I : Integer;
    P : Pointer;
    B : Byte;
Begin
  SetLength(Result, Length(RPCStr) div 2 );
  P := PChar(Result);

  For I := 1 to Length( Result ) do Begin
    B := StrToInt( '$' + RPCStr[I*2-1] + RPCStr[I*2] );
    Move(B, P^, 1);
    Inc(Cardinal(P));
  end;
end;

Procedure StrSeparateToStrings(const Source : String; Dest : TStrings; Const Separator : Char = '|');
var Pred, i : Integer;
Begin
  Dest.Clear;
  Pred := 0;
  For I := 1 to Length(Source) Do
    If Source[I] = Separator Then Begin
      Dest.Add( Copy(Source, Pred+1, I - Pred - 1 ) );
      Pred := I;
    end;
  Dest.Add( Copy(Source, Pred+1, MaxInt));
end;

Function StringsToStrSeparate(Source : TStrings; Const Separator : Char = '|') : String;
var i : Integer;
    Len : Integer;
    P : Pointer;
Begin
  Len := 0;
  For I := 0 to Source.Count - 1 Do
    Len := Len + Length(Source[I]);

  SetLength(Result, Len + Source.Count - 1);
  P := PChar(Result);
  For I := 0 to Source.Count - 1 Do Begin
    If I > 0 Then Begin
      Move(Separator, P^, 1);
      Inc(Cardinal(P));
    end;
    Move(PChar(Source[I])^, P^, Length(Source[I]));
    Inc(Cardinal(P), Length(Source[I]));
  end;
end;

function FileVersion(Key : TFileVersionKey; FileName : String = ''): string;
const KeyValue: array[TFileVersionKey] of string = ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright', 'LegalTradeMarks', 'OriginalFileName', 'ProductName', 'ProductVersion', 'Comments');
var
  VerInfoSize: DWORD;
  Handle: DWORD;
  Data: Pointer;
  Buf: Pointer;
  BufLen: DWORD;
  StringFileInfo: string;
begin
  Result := '';
  If FileName = '' Then
    FileName := ParamStr(0);

  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Handle);
  if VerInfoSize > 0 then Begin
    GetMem(Data, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Handle, VerInfoSize, Data) and
        VerQueryValue(Data, PChar('\'+'VarFileInfo'+'\'+'Translation'), Buf, BufLen) then Begin
        if BufLen = SizeOf(DWORD) then Begin
          StringFileInfo := Format('StringFileInfo'+'\'+'0%x'+'0%x'+'\', [LOWORD(DWORD(Buf^)), HIWORD(DWORD(Buf^))]);
          if VerQueryValue(Data, PChar(StringFileInfo + KeyValue[Key]), Buf, BufLen) then
            Result := PChar(Buf);
        end;
      end;
    finally
      FreeMem(Data, VerInfoSize);
    end;
  end;
end;

var _MainAppFile : TFileName;
Function MainAppFile : TFileName;
Begin
  Result := _MainAppFile;
end;

Procedure InitializeMainAppFile(Value : TFileName);
Begin
  If GetCurrentThreadId <> MainThreadID Then
    Raise Exception.Create('По идее MainAppFile можно изменить один раз в Initialization первого модуля проекта!');
  _MainAppFile := Value;
  SetCurrentDir( ExtractFilePath(_MainAppFile) );
end;

Function CodePassword(Source : String) : String;
var I : Integer;
Begin
  SetLength(Result, Length(Source) + 1);
  Result[1] := '1';
  //Вот так тупо пока что
  For I := 1 to Length(Source) do
    Result[I+1] := Chr( Ord(Source[I]) xor $F0);
end;

Function DecodePassword(Source : String) : String;
var I : Integer;
Begin
  Result := '';
  If Length(Source) > 0 Then Begin
    If Source[1] = '1' Then Begin
      SetLength(Result, Length(Source) - 1);
      For I := 2 to Length(Source) do
        Result[I-1] := Chr( Ord(Source[I]) xor $F0);
    end else
      Raise Exception.Create('Unknown code function!');
  end;
end;

Initialization
  InitializeMainAppFile( ParamStr(0) );
  //_FileOperationMutex := 0;
Finalization
  If _FileOperationCrit <> Nil Then
    FreeAndNil( _FileOperationCrit );

  {If _FileOperationMutex <> 0 Then
    Try
      Windows.CloseHandle( _FileOperationMutex );
    Finally
      _FileOperationMutex := 0;
    end;}
end.
