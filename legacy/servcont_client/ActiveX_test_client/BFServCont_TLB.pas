unit BFServCont_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 25.01.2012 10:16:29 from Type Library described below.

// ************************************************************************  //
// Type Lib: c:\Program Files\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFServCont\AxBFServCont.dll (1)
// LIBID: {EC1EEF3B-2A90-47A8-936A-ED69BEA01769}
// LCID: 0
// Helpfile: 
// HelpString: BFServCont Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TTSSServContX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_TimetableSpecialDayListX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_TimetableItemListX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_ControllerChipListX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_ControllerKeyValueX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_ControllerPortsX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_ControllerKeyX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_ControllerChipX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_ControllerTimetableSpecialDayX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_ControllerTimetableItemX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_KeypadItemsX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_ServcontDateTimeX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
//   Error creating palette bitmap of (TTSSServCont_KeyListX) : Server c:\PROGRA~1\Borland\Delphi7\Addon\Redko\Lib\TSS2000\BFSERV~1\AXBFSE~1.DLL contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  BFServContMajorVersion = 1;
  BFServContMinorVersion = 0;

  LIBID_BFServCont: TGUID = '{EC1EEF3B-2A90-47A8-936A-ED69BEA01769}';

  IID_ITSSServCont_ControllerKeyValue: TGUID = '{C71A1305-72F1-4DD8-A53E-CFBDBA3A1818}';
  IID_ITSSServCont_ControllerPorts: TGUID = '{FC10B468-94DA-4427-8D8E-547E13FEE55A}';
  IID_ITSSServCont_ControllerKey: TGUID = '{109BC80F-15F4-41E2-B816-7212F16FE8D0}';
  IID_ITSSServCont_ControllerChip: TGUID = '{B9D99E34-35F6-475E-8BB1-23D2724D52DF}';
  IID_ITSSServCont_ControllerKeyAttr: TGUID = '{BF34024A-F9F5-45E0-973F-94AA101CCF64}';
  IID_ITSSServCont_ControllerTimetableSpecialDay: TGUID = '{5A4099DA-3E9D-42AE-A605-C6A73346AFDB}';
  IID_ITSSServCont_ControllerTimetableItem: TGUID = '{E32C040A-8100-4394-8CFE-C94331EB35EB}';
  IID_ITSSServCont_KeypadItems: TGUID = '{DD1A08AA-20F7-4D36-BCD5-E8A3F6839041}';
  IID_ITSSServCont_ServcontDateTime: TGUID = '{C53058D6-5F20-4C4E-8A78-1DA53F39999F}';
  IID_ITSSServCont_ControllerEvent: TGUID = '{4521B977-B1AD-428D-8839-FB282BF7CEA7}';
  IID_ITSSServCont_ControllerPortEvent: TGUID = '{28DE6AAA-D0A0-4BAB-A50A-F86A79F628F1}';
  IID_ITSSServCont_ControllerPortRelayEvent: TGUID = '{C9F72189-57D6-4269-AB72-E44D187DEA2B}';
  IID_ITSSServCont_ControllerKeyEvent: TGUID = '{22BCA0A5-9F33-484B-AE2D-D845BC14F100}';
  IID_ITSSServCont_ControllerStaticSensorEvent: TGUID = '{FBB17F4F-6362-4B98-AC33-267750EB86FB}';
  IID_ITSSServCont_ServcontChannel: TGUID = '{5C995F8D-624E-4A08-88E1-8CFEEF044F3F}';
  IID_ITSSServCont_ServcontController: TGUID = '{8D2F12CF-336B-4C4C-A83A-AC07C4FC4295}';
  IID_ITSSServCont_ServcontClient: TGUID = '{B0EF3B3F-198C-427B-966C-942BD77487C8}';
  IID_ITSSServCont_KeyList: TGUID = '{4D220FC3-3266-4177-A18E-3A9B295A42E0}';
  IID_ITSSServCont_TimetableSpecialDayList: TGUID = '{DFA6FC73-A3D3-4275-8A1A-917B6EDCC629}';
  IID_ITSSServCont_TimetableItemList: TGUID = '{FB63CC4D-4B7E-49B2-90DC-9F060A8B1CDC}';
  IID_ITSSServCont_ChannelList: TGUID = '{4E716EF1-2DD3-49CF-98C7-C3F6D52EEFEB}';
  IID_ITSSServCont_ControllerList: TGUID = '{29E0BA81-8517-49DD-892E-7E57FC962D76}';
  IID_ITSSServCont_ClientList: TGUID = '{915DA62E-A425-4945-A54E-7662226896FE}';
  IID_ITSSServCont_ControllerChipList: TGUID = '{E0933D72-57E7-44A5-A052-48BC7DD3A745}';
  IID_ITSSServCont: TGUID = '{A8781959-05F0-48B7-A7C6-96AFC048FE33}';
  DIID_ITSSServContEvents: TGUID = '{E9168480-8ABA-4016-9B21-A1C423C2E18A}';
  CLASS_TSSServContX: TGUID = '{EBB0D0A6-2779-4F08-9541-F33D5319FD8D}';
  CLASS_TSSServCont_TimetableSpecialDayListX: TGUID = '{E1E14735-9BDC-4E3D-ABF8-32BC767FA63C}';
  CLASS_TSSServCont_TimetableItemListX: TGUID = '{B73C3BC3-494D-44C0-9C89-8DF36924D168}';
  CLASS_TSSServCont_ControllerChipListX: TGUID = '{5DBEE5CF-6625-47AA-93DB-86414D6B6CD4}';
  CLASS_TSSServCont_ControllerKeyValueX: TGUID = '{6EA0CF2B-F13C-4D69-87FC-9D2A5570D030}';
  CLASS_TSSServCont_ControllerPortsX: TGUID = '{6AA7FE9B-C697-44BF-9BFB-197E87650D47}';
  CLASS_TSSServCont_ControllerKeyX: TGUID = '{114D3040-05FD-4BE8-BE1D-4655653DB408}';
  CLASS_TSSServCont_ControllerChipX: TGUID = '{23186999-1D20-49D9-8BEA-1490CFF4D8AE}';
  CLASS_TSSServCont_ControllerTimetableSpecialDayX: TGUID = '{D7C0B911-272B-4C75-914B-3A88CCD0E14A}';
  CLASS_TSSServCont_ControllerTimetableItemX: TGUID = '{29745400-E9D6-40E0-B5C7-87D43A7AB3CF}';
  CLASS_TSSServCont_KeypadItemsX: TGUID = '{6361E92A-3EF0-4CA5-A42F-ABBEC0854C25}';
  CLASS_TSSServCont_ServcontDateTimeX: TGUID = '{F544254C-CEDF-4641-A2FE-50BE40C6AB9A}';
  CLASS_TSSServCont_KeyListX: TGUID = '{8BD572B8-7BFE-4C43-94D9-28C4820DAC87}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TTSSServCont_ControllerState
type
  TTSSServCont_ControllerState = TOleEnum;
const
  csNone = $00000000;
  csStateless = $00000001;
  csAutonomicPolling = $00000002;
  csComplex = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITSSServCont_ControllerKeyValue = interface;
  ITSSServCont_ControllerKeyValueDisp = dispinterface;
  ITSSServCont_ControllerPorts = interface;
  ITSSServCont_ControllerPortsDisp = dispinterface;
  ITSSServCont_ControllerKey = interface;
  ITSSServCont_ControllerKeyDisp = dispinterface;
  ITSSServCont_ControllerChip = interface;
  ITSSServCont_ControllerChipDisp = dispinterface;
  ITSSServCont_ControllerKeyAttr = interface;
  ITSSServCont_ControllerKeyAttrDisp = dispinterface;
  ITSSServCont_ControllerTimetableSpecialDay = interface;
  ITSSServCont_ControllerTimetableSpecialDayDisp = dispinterface;
  ITSSServCont_ControllerTimetableItem = interface;
  ITSSServCont_ControllerTimetableItemDisp = dispinterface;
  ITSSServCont_KeypadItems = interface;
  ITSSServCont_KeypadItemsDisp = dispinterface;
  ITSSServCont_ServcontDateTime = interface;
  ITSSServCont_ServcontDateTimeDisp = dispinterface;
  ITSSServCont_ControllerEvent = interface;
  ITSSServCont_ControllerEventDisp = dispinterface;
  ITSSServCont_ControllerPortEvent = interface;
  ITSSServCont_ControllerPortEventDisp = dispinterface;
  ITSSServCont_ControllerPortRelayEvent = interface;
  ITSSServCont_ControllerPortRelayEventDisp = dispinterface;
  ITSSServCont_ControllerKeyEvent = interface;
  ITSSServCont_ControllerKeyEventDisp = dispinterface;
  ITSSServCont_ControllerStaticSensorEvent = interface;
  ITSSServCont_ControllerStaticSensorEventDisp = dispinterface;
  ITSSServCont_ServcontChannel = interface;
  ITSSServCont_ServcontChannelDisp = dispinterface;
  ITSSServCont_ServcontController = interface;
  ITSSServCont_ServcontControllerDisp = dispinterface;
  ITSSServCont_ServcontClient = interface;
  ITSSServCont_ServcontClientDisp = dispinterface;
  ITSSServCont_KeyList = interface;
  ITSSServCont_KeyListDisp = dispinterface;
  ITSSServCont_TimetableSpecialDayList = interface;
  ITSSServCont_TimetableSpecialDayListDisp = dispinterface;
  ITSSServCont_TimetableItemList = interface;
  ITSSServCont_TimetableItemListDisp = dispinterface;
  ITSSServCont_ChannelList = interface;
  ITSSServCont_ChannelListDisp = dispinterface;
  ITSSServCont_ControllerList = interface;
  ITSSServCont_ControllerListDisp = dispinterface;
  ITSSServCont_ClientList = interface;
  ITSSServCont_ClientListDisp = dispinterface;
  ITSSServCont_ControllerChipList = interface;
  ITSSServCont_ControllerChipListDisp = dispinterface;
  ITSSServCont = interface;
  ITSSServContDisp = dispinterface;
  ITSSServContEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TSSServContX = ITSSServCont;
  TSSServCont_TimetableSpecialDayListX = ITSSServCont_TimetableSpecialDayList;
  TSSServCont_TimetableItemListX = ITSSServCont_TimetableItemList;
  TSSServCont_ControllerChipListX = ITSSServCont_ControllerChipList;
  TSSServCont_ControllerKeyValueX = ITSSServCont_ControllerKeyValue;
  TSSServCont_ControllerPortsX = ITSSServCont_ControllerPorts;
  TSSServCont_ControllerKeyX = ITSSServCont_ControllerKey;
  TSSServCont_ControllerChipX = ITSSServCont_ControllerChip;
  TSSServCont_ControllerTimetableSpecialDayX = ITSSServCont_ControllerTimetableSpecialDay;
  TSSServCont_ControllerTimetableItemX = ITSSServCont_ControllerTimetableItem;
  TSSServCont_KeypadItemsX = ITSSServCont_KeypadItems;
  TSSServCont_ServcontDateTimeX = ITSSServCont_ServcontDateTime;
  TSSServCont_KeyListX = ITSSServCont_KeyList;


// *********************************************************************//
// Interface: ITSSServCont_ControllerKeyValue
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C71A1305-72F1-4DD8-A53E-CFBDBA3A1818}
// *********************************************************************//
  ITSSServCont_ControllerKeyValue = interface(IDispatch)
    ['{C71A1305-72F1-4DD8-A53E-CFBDBA3A1818}']
    function Get_B(Index: Integer): Byte; safecall;
    procedure Set_B(Index: Integer; Value: Byte); safecall;
    function Get_Count: Integer; safecall;
    property B[Index: Integer]: Byte read Get_B write Set_B;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerKeyValueDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C71A1305-72F1-4DD8-A53E-CFBDBA3A1818}
// *********************************************************************//
  ITSSServCont_ControllerKeyValueDisp = dispinterface
    ['{C71A1305-72F1-4DD8-A53E-CFBDBA3A1818}']
    property B[Index: Integer]: Byte dispid 1610743808;
    property Count: Integer readonly dispid 1610743810;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerPorts
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FC10B468-94DA-4427-8D8E-547E13FEE55A}
// *********************************************************************//
  ITSSServCont_ControllerPorts = interface(IDispatch)
    ['{FC10B468-94DA-4427-8D8E-547E13FEE55A}']
    function Get_P(Index: Integer): WordBool; safecall;
    procedure Set_P(Index: Integer; Value: WordBool); safecall;
    function Get_Count: Integer; safecall;
    property P[Index: Integer]: WordBool read Get_P write Set_P;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerPortsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FC10B468-94DA-4427-8D8E-547E13FEE55A}
// *********************************************************************//
  ITSSServCont_ControllerPortsDisp = dispinterface
    ['{FC10B468-94DA-4427-8D8E-547E13FEE55A}']
    property P[Index: Integer]: WordBool dispid 1610743808;
    property Count: Integer readonly dispid 1610743810;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerKey
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {109BC80F-15F4-41E2-B816-7212F16FE8D0}
// *********************************************************************//
  ITSSServCont_ControllerKey = interface(IDispatch)
    ['{109BC80F-15F4-41E2-B816-7212F16FE8D0}']
    function Get_Value: ITSSServCont_ControllerKeyValue; safecall;
    procedure Set_Value(const Value: ITSSServCont_ControllerKeyValue); safecall;
    function Get_Ports: ITSSServCont_ControllerPorts; safecall;
    procedure Set_Ports(const Value: ITSSServCont_ControllerPorts); safecall;
    function Get_PersCat: Byte; safecall;
    procedure Set_PersCat(Value: Byte); safecall;
    function Get_SuppressDoorEvent: WordBool; safecall;
    procedure Set_SuppressDoorEvent(Value: WordBool); safecall;
    function Get_OpenEvenComplex: WordBool; safecall;
    procedure Set_OpenEvenComplex(Value: WordBool); safecall;
    function Get_IsSilent: WordBool; safecall;
    procedure Set_IsSilent(Value: WordBool); safecall;
    property Value: ITSSServCont_ControllerKeyValue read Get_Value write Set_Value;
    property Ports: ITSSServCont_ControllerPorts read Get_Ports write Set_Ports;
    property PersCat: Byte read Get_PersCat write Set_PersCat;
    property SuppressDoorEvent: WordBool read Get_SuppressDoorEvent write Set_SuppressDoorEvent;
    property OpenEvenComplex: WordBool read Get_OpenEvenComplex write Set_OpenEvenComplex;
    property IsSilent: WordBool read Get_IsSilent write Set_IsSilent;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerKeyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {109BC80F-15F4-41E2-B816-7212F16FE8D0}
// *********************************************************************//
  ITSSServCont_ControllerKeyDisp = dispinterface
    ['{109BC80F-15F4-41E2-B816-7212F16FE8D0}']
    property Value: ITSSServCont_ControllerKeyValue dispid 1610743808;
    property Ports: ITSSServCont_ControllerPorts dispid 1610743810;
    property PersCat: Byte dispid 1610743812;
    property SuppressDoorEvent: WordBool dispid 1610743814;
    property OpenEvenComplex: WordBool dispid 1610743816;
    property IsSilent: WordBool dispid 1610743818;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerChip
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9D99E34-35F6-475E-8BB1-23D2724D52DF}
// *********************************************************************//
  ITSSServCont_ControllerChip = interface(IDispatch)
    ['{B9D99E34-35F6-475E-8BB1-23D2724D52DF}']
    function Get_Value: ITSSServCont_ControllerKeyValue; safecall;
    procedure Set_Value(const Value: ITSSServCont_ControllerKeyValue); safecall;
    function Get_Active: WordBool; safecall;
    procedure Set_Active(Value: WordBool); safecall;
    function Get_OpenEvenComplex: WordBool; safecall;
    procedure Set_OpenEvenComplex(Value: WordBool); safecall;
    function Get_CheckCount: Byte; safecall;
    procedure Set_CheckCount(Value: Byte); safecall;
    function Get_Port: Byte; safecall;
    procedure Set_Port(Value: Byte); safecall;
    property Value: ITSSServCont_ControllerKeyValue read Get_Value write Set_Value;
    property Active: WordBool read Get_Active write Set_Active;
    property OpenEvenComplex: WordBool read Get_OpenEvenComplex write Set_OpenEvenComplex;
    property CheckCount: Byte read Get_CheckCount write Set_CheckCount;
    property Port: Byte read Get_Port write Set_Port;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerChipDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9D99E34-35F6-475E-8BB1-23D2724D52DF}
// *********************************************************************//
  ITSSServCont_ControllerChipDisp = dispinterface
    ['{B9D99E34-35F6-475E-8BB1-23D2724D52DF}']
    property Value: ITSSServCont_ControllerKeyValue dispid 1610743808;
    property Active: WordBool dispid 1610743810;
    property OpenEvenComplex: WordBool dispid 1610743812;
    property CheckCount: Byte dispid 1610743814;
    property Port: Byte dispid 1610743816;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerKeyAttr
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF34024A-F9F5-45E0-973F-94AA101CCF64}
// *********************************************************************//
  ITSSServCont_ControllerKeyAttr = interface(IDispatch)
    ['{BF34024A-F9F5-45E0-973F-94AA101CCF64}']
    function Get_Ports: ITSSServCont_ControllerPorts; safecall;
    function Get_PersCat: Byte; safecall;
    function Get_SuppressDoorEvent: WordBool; safecall;
    function Get_OpenEvenComplex: WordBool; safecall;
    function Get_IsSilent: WordBool; safecall;
    property Ports: ITSSServCont_ControllerPorts read Get_Ports;
    property PersCat: Byte read Get_PersCat;
    property SuppressDoorEvent: WordBool read Get_SuppressDoorEvent;
    property OpenEvenComplex: WordBool read Get_OpenEvenComplex;
    property IsSilent: WordBool read Get_IsSilent;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerKeyAttrDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF34024A-F9F5-45E0-973F-94AA101CCF64}
// *********************************************************************//
  ITSSServCont_ControllerKeyAttrDisp = dispinterface
    ['{BF34024A-F9F5-45E0-973F-94AA101CCF64}']
    property Ports: ITSSServCont_ControllerPorts readonly dispid 1610743808;
    property PersCat: Byte readonly dispid 1610743809;
    property SuppressDoorEvent: WordBool readonly dispid 1610743810;
    property OpenEvenComplex: WordBool readonly dispid 1610743811;
    property IsSilent: WordBool readonly dispid 1610743812;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerTimetableSpecialDay
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5A4099DA-3E9D-42AE-A605-C6A73346AFDB}
// *********************************************************************//
  ITSSServCont_ControllerTimetableSpecialDay = interface(IDispatch)
    ['{5A4099DA-3E9D-42AE-A605-C6A73346AFDB}']
    function Get_Year: Byte; safecall;
    procedure Set_Year(Value: Byte); safecall;
    function Get_Month: Byte; safecall;
    procedure Set_Month(Value: Byte); safecall;
    function Get_Day: Byte; safecall;
    procedure Set_Day(Value: Byte); safecall;
    function Get_DayType: Byte; safecall;
    procedure Set_DayType(Value: Byte); safecall;
    property Year: Byte read Get_Year write Set_Year;
    property Month: Byte read Get_Month write Set_Month;
    property Day: Byte read Get_Day write Set_Day;
    property DayType: Byte read Get_DayType write Set_DayType;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerTimetableSpecialDayDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5A4099DA-3E9D-42AE-A605-C6A73346AFDB}
// *********************************************************************//
  ITSSServCont_ControllerTimetableSpecialDayDisp = dispinterface
    ['{5A4099DA-3E9D-42AE-A605-C6A73346AFDB}']
    property Year: Byte dispid 1610743808;
    property Month: Byte dispid 1610743810;
    property Day: Byte dispid 1610743812;
    property DayType: Byte dispid 1610743814;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerTimetableItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E32C040A-8100-4394-8CFE-C94331EB35EB}
// *********************************************************************//
  ITSSServCont_ControllerTimetableItem = interface(IDispatch)
    ['{E32C040A-8100-4394-8CFE-C94331EB35EB}']
    function Get_DayType: Byte; safecall;
    procedure Set_DayType(Value: Byte); safecall;
    function Get_StartHour: Byte; safecall;
    procedure Set_StartHour(Value: Byte); safecall;
    function Get_StartMinute: Byte; safecall;
    procedure Set_StartMinute(Value: Byte); safecall;
    function Get_FihishHour: Byte; safecall;
    procedure Set_FihishHour(Value: Byte); safecall;
    function Get_FihishMinute: Byte; safecall;
    procedure Set_FihishMinute(Value: Byte); safecall;
    function Get_PersCat: Byte; safecall;
    procedure Set_PersCat(Value: Byte); safecall;
    property DayType: Byte read Get_DayType write Set_DayType;
    property StartHour: Byte read Get_StartHour write Set_StartHour;
    property StartMinute: Byte read Get_StartMinute write Set_StartMinute;
    property FihishHour: Byte read Get_FihishHour write Set_FihishHour;
    property FihishMinute: Byte read Get_FihishMinute write Set_FihishMinute;
    property PersCat: Byte read Get_PersCat write Set_PersCat;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerTimetableItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E32C040A-8100-4394-8CFE-C94331EB35EB}
// *********************************************************************//
  ITSSServCont_ControllerTimetableItemDisp = dispinterface
    ['{E32C040A-8100-4394-8CFE-C94331EB35EB}']
    property DayType: Byte dispid 1610743808;
    property StartHour: Byte dispid 1610743810;
    property StartMinute: Byte dispid 1610743812;
    property FihishHour: Byte dispid 1610743814;
    property FihishMinute: Byte dispid 1610743816;
    property PersCat: Byte dispid 1610743818;
  end;

// *********************************************************************//
// Interface: ITSSServCont_KeypadItems
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DD1A08AA-20F7-4D36-BCD5-E8A3F6839041}
// *********************************************************************//
  ITSSServCont_KeypadItems = interface(IDispatch)
    ['{DD1A08AA-20F7-4D36-BCD5-E8A3F6839041}']
    function Get_KeyCount(Index: Integer): Byte; safecall;
    procedure Set_KeyCount(Index: Integer; Value: Byte); safecall;
    function Get_Timeout(Index: Integer): Byte; safecall;
    procedure Set_Timeout(Index: Integer; Value: Byte); safecall;
    function Get_Count: Integer; safecall;
    property KeyCount[Index: Integer]: Byte read Get_KeyCount write Set_KeyCount;
    property Timeout[Index: Integer]: Byte read Get_Timeout write Set_Timeout;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_KeypadItemsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DD1A08AA-20F7-4D36-BCD5-E8A3F6839041}
// *********************************************************************//
  ITSSServCont_KeypadItemsDisp = dispinterface
    ['{DD1A08AA-20F7-4D36-BCD5-E8A3F6839041}']
    property KeyCount[Index: Integer]: Byte dispid 1610743808;
    property Timeout[Index: Integer]: Byte dispid 1610743810;
    property Count: Integer readonly dispid 1610743812;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ServcontDateTime
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C53058D6-5F20-4C4E-8A78-1DA53F39999F}
// *********************************************************************//
  ITSSServCont_ServcontDateTime = interface(IDispatch)
    ['{C53058D6-5F20-4C4E-8A78-1DA53F39999F}']
    function Get_Year: Byte; safecall;
    function Get_Month: Byte; safecall;
    function Get_Day: Byte; safecall;
    function Get_Hour: Byte; safecall;
    function Get_Minute: Byte; safecall;
    function Get_Second: Byte; safecall;
    procedure Set_Year(Value: Byte); safecall;
    procedure Set_Month(Value: Byte); safecall;
    procedure Set_Day(Value: Byte); safecall;
    procedure Set_Hour(Value: Byte); safecall;
    procedure Set_Minute(Value: Byte); safecall;
    procedure Set_Second(Value: Byte); safecall;
    property Year: Byte read Get_Year write Set_Year;
    property Month: Byte read Get_Month write Set_Month;
    property Day: Byte read Get_Day write Set_Day;
    property Hour: Byte read Get_Hour write Set_Hour;
    property Minute: Byte read Get_Minute write Set_Minute;
    property Second: Byte read Get_Second write Set_Second;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ServcontDateTimeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C53058D6-5F20-4C4E-8A78-1DA53F39999F}
// *********************************************************************//
  ITSSServCont_ServcontDateTimeDisp = dispinterface
    ['{C53058D6-5F20-4C4E-8A78-1DA53F39999F}']
    property Year: Byte dispid 1610743808;
    property Month: Byte dispid 1610743809;
    property Day: Byte dispid 1610743810;
    property Hour: Byte dispid 1610743811;
    property Minute: Byte dispid 1610743812;
    property Second: Byte dispid 1610743813;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4521B977-B1AD-428D-8839-FB282BF7CEA7}
// *********************************************************************//
  ITSSServCont_ControllerEvent = interface(IDispatch)
    ['{4521B977-B1AD-428D-8839-FB282BF7CEA7}']
    function Get_Timestamp2: ITSSServCont_ServcontDateTime; safecall;
    function Get_Addr: Byte; safecall;
    function Get_No: Integer; safecall;
    function Get_IsAuto: WordBool; safecall;
    function Get_Timestamp1: ITSSServCont_ServcontDateTime; safecall;
    function Get_IsLast: WordBool; safecall;
    property Timestamp2: ITSSServCont_ServcontDateTime read Get_Timestamp2;
    property Addr: Byte read Get_Addr;
    property No: Integer read Get_No;
    property IsAuto: WordBool read Get_IsAuto;
    property Timestamp1: ITSSServCont_ServcontDateTime read Get_Timestamp1;
    property IsLast: WordBool read Get_IsLast;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4521B977-B1AD-428D-8839-FB282BF7CEA7}
// *********************************************************************//
  ITSSServCont_ControllerEventDisp = dispinterface
    ['{4521B977-B1AD-428D-8839-FB282BF7CEA7}']
    property Timestamp2: ITSSServCont_ServcontDateTime readonly dispid 1610743808;
    property Addr: Byte readonly dispid 1610743809;
    property No: Integer readonly dispid 1610743810;
    property IsAuto: WordBool readonly dispid 1610743811;
    property Timestamp1: ITSSServCont_ServcontDateTime readonly dispid 1610743812;
    property IsLast: WordBool readonly dispid 1610743813;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerPortEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28DE6AAA-D0A0-4BAB-A50A-F86A79F628F1}
// *********************************************************************//
  ITSSServCont_ControllerPortEvent = interface(IDispatch)
    ['{28DE6AAA-D0A0-4BAB-A50A-F86A79F628F1}']
    function Get_ControllerEvent: ITSSServCont_ControllerEvent; safecall;
    function Get_Port: Byte; safecall;
    property ControllerEvent: ITSSServCont_ControllerEvent read Get_ControllerEvent;
    property Port: Byte read Get_Port;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerPortEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28DE6AAA-D0A0-4BAB-A50A-F86A79F628F1}
// *********************************************************************//
  ITSSServCont_ControllerPortEventDisp = dispinterface
    ['{28DE6AAA-D0A0-4BAB-A50A-F86A79F628F1}']
    property ControllerEvent: ITSSServCont_ControllerEvent readonly dispid 1610743808;
    property Port: Byte readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerPortRelayEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C9F72189-57D6-4269-AB72-E44D187DEA2B}
// *********************************************************************//
  ITSSServCont_ControllerPortRelayEvent = interface(IDispatch)
    ['{C9F72189-57D6-4269-AB72-E44D187DEA2B}']
    function Get_ControllerPortEvent: ITSSServCont_ControllerPortEvent; safecall;
    function Get_IsOpen: WordBool; safecall;
    property ControllerPortEvent: ITSSServCont_ControllerPortEvent read Get_ControllerPortEvent;
    property IsOpen: WordBool read Get_IsOpen;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerPortRelayEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C9F72189-57D6-4269-AB72-E44D187DEA2B}
// *********************************************************************//
  ITSSServCont_ControllerPortRelayEventDisp = dispinterface
    ['{C9F72189-57D6-4269-AB72-E44D187DEA2B}']
    property ControllerPortEvent: ITSSServCont_ControllerPortEvent readonly dispid 1610743808;
    property IsOpen: WordBool readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerKeyEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22BCA0A5-9F33-484B-AE2D-D845BC14F100}
// *********************************************************************//
  ITSSServCont_ControllerKeyEvent = interface(IDispatch)
    ['{22BCA0A5-9F33-484B-AE2D-D845BC14F100}']
    function Get_ControllerPortRelayEvent: ITSSServCont_ControllerPortRelayEvent; safecall;
    function Get_Key: ITSSServCont_ControllerKeyValue; safecall;
    function Get_IsTimeRestrict: WordBool; safecall;
    function Get_IsTimeRestrictDone: WordBool; safecall;
    function Get_IsAccessGranted: WordBool; safecall;
    function Get_IsKeyFound: WordBool; safecall;
    function Get_IsKeySearchDone: WordBool; safecall;
    property ControllerPortRelayEvent: ITSSServCont_ControllerPortRelayEvent read Get_ControllerPortRelayEvent;
    property Key: ITSSServCont_ControllerKeyValue read Get_Key;
    property IsTimeRestrict: WordBool read Get_IsTimeRestrict;
    property IsTimeRestrictDone: WordBool read Get_IsTimeRestrictDone;
    property IsAccessGranted: WordBool read Get_IsAccessGranted;
    property IsKeyFound: WordBool read Get_IsKeyFound;
    property IsKeySearchDone: WordBool read Get_IsKeySearchDone;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerKeyEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22BCA0A5-9F33-484B-AE2D-D845BC14F100}
// *********************************************************************//
  ITSSServCont_ControllerKeyEventDisp = dispinterface
    ['{22BCA0A5-9F33-484B-AE2D-D845BC14F100}']
    property ControllerPortRelayEvent: ITSSServCont_ControllerPortRelayEvent readonly dispid 1610743808;
    property Key: ITSSServCont_ControllerKeyValue readonly dispid 1610743809;
    property IsTimeRestrict: WordBool readonly dispid 1610743810;
    property IsTimeRestrictDone: WordBool readonly dispid 1610743811;
    property IsAccessGranted: WordBool readonly dispid 1610743812;
    property IsKeyFound: WordBool readonly dispid 1610743813;
    property IsKeySearchDone: WordBool readonly dispid 1610743814;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerStaticSensorEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FBB17F4F-6362-4B98-AC33-267750EB86FB}
// *********************************************************************//
  ITSSServCont_ControllerStaticSensorEvent = interface(IDispatch)
    ['{FBB17F4F-6362-4B98-AC33-267750EB86FB}']
    function Get_ControllerEvent: ITSSServCont_ControllerEvent; safecall;
    function Get_Value: Byte; safecall;
    property ControllerEvent: ITSSServCont_ControllerEvent read Get_ControllerEvent;
    property Value: Byte read Get_Value;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerStaticSensorEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FBB17F4F-6362-4B98-AC33-267750EB86FB}
// *********************************************************************//
  ITSSServCont_ControllerStaticSensorEventDisp = dispinterface
    ['{FBB17F4F-6362-4B98-AC33-267750EB86FB}']
    property ControllerEvent: ITSSServCont_ControllerEvent readonly dispid 1610743808;
    property Value: Byte readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ServcontChannel
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5C995F8D-624E-4A08-88E1-8CFEEF044F3F}
// *********************************************************************//
  ITSSServCont_ServcontChannel = interface(IDispatch)
    ['{5C995F8D-624E-4A08-88E1-8CFEEF044F3F}']
    function Get_IsActive: WordBool; safecall;
    function Get_IsReady: WordBool; safecall;
    function Get_IsIP: WordBool; safecall;
    function Get_PortOrHost: WideString; safecall;
    function Get_SpeedOrPort: Integer; safecall;
    function Get_ResponseTimeout: Integer; safecall;
    function Get_AliveTimeout: Integer; safecall;
    function Get_DeadTimeout: Integer; safecall;
    function Get_PollSpeed: Integer; safecall;
    property IsActive: WordBool read Get_IsActive;
    property IsReady: WordBool read Get_IsReady;
    property IsIP: WordBool read Get_IsIP;
    property PortOrHost: WideString read Get_PortOrHost;
    property SpeedOrPort: Integer read Get_SpeedOrPort;
    property ResponseTimeout: Integer read Get_ResponseTimeout;
    property AliveTimeout: Integer read Get_AliveTimeout;
    property DeadTimeout: Integer read Get_DeadTimeout;
    property PollSpeed: Integer read Get_PollSpeed;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ServcontChannelDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5C995F8D-624E-4A08-88E1-8CFEEF044F3F}
// *********************************************************************//
  ITSSServCont_ServcontChannelDisp = dispinterface
    ['{5C995F8D-624E-4A08-88E1-8CFEEF044F3F}']
    property IsActive: WordBool readonly dispid 1610743808;
    property IsReady: WordBool readonly dispid 1610743809;
    property IsIP: WordBool readonly dispid 1610743810;
    property PortOrHost: WideString readonly dispid 1610743811;
    property SpeedOrPort: Integer readonly dispid 1610743812;
    property ResponseTimeout: Integer readonly dispid 1610743813;
    property AliveTimeout: Integer readonly dispid 1610743814;
    property DeadTimeout: Integer readonly dispid 1610743815;
    property PollSpeed: Integer readonly dispid 1610743816;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ServcontController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8D2F12CF-336B-4C4C-A83A-AC07C4FC4295}
// *********************************************************************//
  ITSSServCont_ServcontController = interface(IDispatch)
    ['{8D2F12CF-336B-4C4C-A83A-AC07C4FC4295}']
    function Get_Addr: Byte; safecall;
    function Get_State: Byte; safecall;
    property Addr: Byte read Get_Addr;
    property State: Byte read Get_State;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ServcontControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8D2F12CF-336B-4C4C-A83A-AC07C4FC4295}
// *********************************************************************//
  ITSSServCont_ServcontControllerDisp = dispinterface
    ['{8D2F12CF-336B-4C4C-A83A-AC07C4FC4295}']
    property Addr: Byte readonly dispid 1610743808;
    property State: Byte readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ServcontClient
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B0EF3B3F-198C-427B-966C-942BD77487C8}
// *********************************************************************//
  ITSSServCont_ServcontClient = interface(IDispatch)
    ['{B0EF3B3F-198C-427B-966C-942BD77487C8}']
    function Get_Id: TGUID; safecall;
    function Get_Addr: Integer; safecall;
    function Get_Port: Integer; safecall;
    property Id: TGUID read Get_Id;
    property Addr: Integer read Get_Addr;
    property Port: Integer read Get_Port;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ServcontClientDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B0EF3B3F-198C-427B-966C-942BD77487C8}
// *********************************************************************//
  ITSSServCont_ServcontClientDisp = dispinterface
    ['{B0EF3B3F-198C-427B-966C-942BD77487C8}']
    property Id: {??TGUID}OleVariant readonly dispid 1610743808;
    property Addr: Integer readonly dispid 1610743809;
    property Port: Integer readonly dispid 1610743810;
  end;

// *********************************************************************//
// Interface: ITSSServCont_KeyList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4D220FC3-3266-4177-A18E-3A9B295A42E0}
// *********************************************************************//
  ITSSServCont_KeyList = interface(IDispatch)
    ['{4D220FC3-3266-4177-A18E-3A9B295A42E0}']
    function Get_Count: Integer; safecall;
    procedure Set_Count(Value: Integer); safecall;
    function Get_Items(Index: Integer): ITSSServCont_ControllerKey; safecall;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerKey); safecall;
    property Count: Integer read Get_Count write Set_Count;
    property Items[Index: Integer]: ITSSServCont_ControllerKey read Get_Items write Set_Items;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_KeyListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4D220FC3-3266-4177-A18E-3A9B295A42E0}
// *********************************************************************//
  ITSSServCont_KeyListDisp = dispinterface
    ['{4D220FC3-3266-4177-A18E-3A9B295A42E0}']
    property Count: Integer dispid 1610743808;
    property Items[Index: Integer]: ITSSServCont_ControllerKey dispid 1610743810;
  end;

// *********************************************************************//
// Interface: ITSSServCont_TimetableSpecialDayList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DFA6FC73-A3D3-4275-8A1A-917B6EDCC629}
// *********************************************************************//
  ITSSServCont_TimetableSpecialDayList = interface(IDispatch)
    ['{DFA6FC73-A3D3-4275-8A1A-917B6EDCC629}']
    function Get_Count: Integer; safecall;
    procedure Set_Count(Value: Integer); safecall;
    function Get_Items(Index: Integer): ITSSServCont_ControllerTimetableSpecialDay; safecall;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerTimetableSpecialDay); safecall;
    property Count: Integer read Get_Count write Set_Count;
    property Items[Index: Integer]: ITSSServCont_ControllerTimetableSpecialDay read Get_Items write Set_Items;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_TimetableSpecialDayListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DFA6FC73-A3D3-4275-8A1A-917B6EDCC629}
// *********************************************************************//
  ITSSServCont_TimetableSpecialDayListDisp = dispinterface
    ['{DFA6FC73-A3D3-4275-8A1A-917B6EDCC629}']
    property Count: Integer dispid 1610743808;
    property Items[Index: Integer]: ITSSServCont_ControllerTimetableSpecialDay dispid 1610743810;
  end;

// *********************************************************************//
// Interface: ITSSServCont_TimetableItemList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FB63CC4D-4B7E-49B2-90DC-9F060A8B1CDC}
// *********************************************************************//
  ITSSServCont_TimetableItemList = interface(IDispatch)
    ['{FB63CC4D-4B7E-49B2-90DC-9F060A8B1CDC}']
    function Get_Count: Integer; safecall;
    procedure Set_Count(Value: Integer); safecall;
    function Get_Items(Index: Integer): ITSSServCont_ControllerTimetableItem; safecall;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerTimetableItem); safecall;
    property Count: Integer read Get_Count write Set_Count;
    property Items[Index: Integer]: ITSSServCont_ControllerTimetableItem read Get_Items write Set_Items;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_TimetableItemListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FB63CC4D-4B7E-49B2-90DC-9F060A8B1CDC}
// *********************************************************************//
  ITSSServCont_TimetableItemListDisp = dispinterface
    ['{FB63CC4D-4B7E-49B2-90DC-9F060A8B1CDC}']
    property Count: Integer dispid 1610743808;
    property Items[Index: Integer]: ITSSServCont_ControllerTimetableItem dispid 1610743810;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ChannelList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4E716EF1-2DD3-49CF-98C7-C3F6D52EEFEB}
// *********************************************************************//
  ITSSServCont_ChannelList = interface(IDispatch)
    ['{4E716EF1-2DD3-49CF-98C7-C3F6D52EEFEB}']
    function Get_Count: Integer; safecall;
    function Get_Items(Index: Integer): ITSSServCont_ServcontChannel; safecall;
    property Count: Integer read Get_Count;
    property Items[Index: Integer]: ITSSServCont_ServcontChannel read Get_Items;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ChannelListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4E716EF1-2DD3-49CF-98C7-C3F6D52EEFEB}
// *********************************************************************//
  ITSSServCont_ChannelListDisp = dispinterface
    ['{4E716EF1-2DD3-49CF-98C7-C3F6D52EEFEB}']
    property Count: Integer readonly dispid 1610743808;
    property Items[Index: Integer]: ITSSServCont_ServcontChannel readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29E0BA81-8517-49DD-892E-7E57FC962D76}
// *********************************************************************//
  ITSSServCont_ControllerList = interface(IDispatch)
    ['{29E0BA81-8517-49DD-892E-7E57FC962D76}']
    function Get_Count: Integer; safecall;
    function Get_Items(Index: Integer): ITSSServCont_ServcontController; safecall;
    property Count: Integer read Get_Count;
    property Items[Index: Integer]: ITSSServCont_ServcontController read Get_Items;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29E0BA81-8517-49DD-892E-7E57FC962D76}
// *********************************************************************//
  ITSSServCont_ControllerListDisp = dispinterface
    ['{29E0BA81-8517-49DD-892E-7E57FC962D76}']
    property Count: Integer readonly dispid 1610743808;
    property Items[Index: Integer]: ITSSServCont_ServcontController readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ClientList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {915DA62E-A425-4945-A54E-7662226896FE}
// *********************************************************************//
  ITSSServCont_ClientList = interface(IDispatch)
    ['{915DA62E-A425-4945-A54E-7662226896FE}']
    function Get_Count: Integer; safecall;
    function Get_Items(Index: Integer): ITSSServCont_ServcontClient; safecall;
    property Count: Integer read Get_Count;
    property Items[Index: Integer]: ITSSServCont_ServcontClient read Get_Items;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ClientListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {915DA62E-A425-4945-A54E-7662226896FE}
// *********************************************************************//
  ITSSServCont_ClientListDisp = dispinterface
    ['{915DA62E-A425-4945-A54E-7662226896FE}']
    property Count: Integer readonly dispid 1610743808;
    property Items[Index: Integer]: ITSSServCont_ServcontClient readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ITSSServCont_ControllerChipList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E0933D72-57E7-44A5-A052-48BC7DD3A745}
// *********************************************************************//
  ITSSServCont_ControllerChipList = interface(IDispatch)
    ['{E0933D72-57E7-44A5-A052-48BC7DD3A745}']
    function Get_Count: Integer; safecall;
    procedure Set_Count(Value: Integer); safecall;
    function Get_Items(Index: Integer): ITSSServCont_ControllerChip; safecall;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerChip); safecall;
    property Count: Integer read Get_Count write Set_Count;
    property Items[Index: Integer]: ITSSServCont_ControllerChip read Get_Items write Set_Items;
  end;

// *********************************************************************//
// DispIntf:  ITSSServCont_ControllerChipListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E0933D72-57E7-44A5-A052-48BC7DD3A745}
// *********************************************************************//
  ITSSServCont_ControllerChipListDisp = dispinterface
    ['{E0933D72-57E7-44A5-A052-48BC7DD3A745}']
    property Count: Integer dispid 1610743808;
    property Items[Index: Integer]: ITSSServCont_ControllerChip dispid 1610743810;
  end;

// *********************************************************************//
// Interface: ITSSServCont
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A8781959-05F0-48B7-A7C6-96AFC048FE33}
// *********************************************************************//
  ITSSServCont = interface(IDispatch)
    ['{A8781959-05F0-48B7-A7C6-96AFC048FE33}']
    function Get_Active: WordBool; safecall;
    procedure Set_Active(Value: WordBool); safecall;
    function Get_Ready: WordBool; safecall;
    function Get_Host: WideString; safecall;
    procedure Set_Host(const Value: WideString); safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Port(Value: Integer); safecall;
    function srvAddIPChannel(const Host: WideString; Port: Integer; ResponseTimeout: Integer; 
                             AliveTimeout: Integer; DeadTimeout: Integer): WideString; safecall;
    function srvAddChannel(const Port: WideString; Speed: Integer; ResponseTimeout: Integer; 
                           AliveTimeout: Integer; DeadTimeout: Integer): WideString; safecall;
    function srvAddDvRs422Channel(Speed: Integer; ResponseTimeout: Integer; AliveTimeout: Integer; 
                                  DeadTimeout: Integer): WideString; safecall;
    procedure srvRemoveChannel(const ChannelId: WideString); safecall;
    procedure srvActivateChannel(const ChannelId: WideString); safecall;
    procedure srvDeactivateChannel(const ChannelId: WideString); safecall;
    procedure srvAddController(ControllerAddr: Integer; const ChannelId: WideString); safecall;
    procedure srvRemoveController(ControllerAddr: Integer; const ChannelId: WideString); safecall;
    procedure srvChannelList(out Data: ITSSServCont_ChannelList); safecall;
    procedure srvControllerList(const ChannelId: WideString; out Data: ITSSServCont_ControllerList); safecall;
    procedure srvClientList(out Data: ITSSServCont_ClientList); safecall;
    procedure srvSwitchToAuto; safecall;
    procedure srvMainClient(LogControllerEvents: WordBool; qLimit: Integer); safecall;
    procedure srvCoEvtLogSend(const BeginInterval: ITSSServCont_ServcontDateTime; 
                              const EndInterval: ITSSServCont_ServcontDateTime; Limit: Integer; 
                              Offset: Integer; out Count: Integer); safecall;
    procedure srvCoEvtLogClear; safecall;
    procedure srvSetHostClock(const Value: ITSSServCont_ServcontDateTime); safecall;
    procedure cntRelayOn(const ChannelId: WideString; ControllerAddr: Integer; Port: Integer; 
                         SuppressDoorEvent: WordBool; Interval: Integer); safecall;
    procedure cntRelayOff(const ChannelId: WideString; ControllerAddr: Integer; Port: Integer; 
                          SuppressDoorEvent: WordBool); safecall;
    procedure cntPollOn(const ChannelId: WideString; ControllerAddr: Integer; IsAuto: WordBool; 
                        IsReliable: WordBool); safecall;
    procedure cntPollOff(const ChannelId: WideString; ControllerAddr: Integer; ForceAuto: WordBool); safecall;
    procedure cntTimerOff(const ChannelId: WideString; ControllerAddr: Integer); safecall;
    procedure cntTimerOn(const ChannelId: WideString; ControllerAddr: Integer; Interval: Integer); safecall;
    procedure cntWriteKey(const ChannelId: WideString; ControllerAddr: Integer; 
                          const Key: ITSSServCont_ControllerKey); safecall;
    procedure cntEraseKey(const ChannelId: WideString; ControllerAddr: Integer; 
                          const KeyValue: ITSSServCont_ControllerKeyValue); safecall;
    procedure cntKeyExist(const ChannelId: WideString; ControllerAddr: Integer; 
                          const KeyValue: ITSSServCont_ControllerKeyValue; out IsExist: WordBool; 
                          out KeyAttr: ITSSServCont_ControllerKeyAttr); safecall;
    procedure cntEraseAllKeys(const ChannelId: WideString; ControllerAddr: Integer); safecall;
    procedure cntProgId(const ChannelId: WideString; ControllerAddr: Integer; out Id: Integer); safecall;
    procedure cntProgVer(const ChannelId: WideString; ControllerAddr: Integer; out Ver: WideString); safecall;
    procedure cntSerNum(const ChannelId: WideString; ControllerAddr: Integer; out SerNum: Integer); safecall;
    procedure cntReadClock(const ChannelId: WideString; ControllerAddr: Integer; 
                           out Clock: ITSSServCont_ServcontDateTime); safecall;
    procedure cntWriteClockDate(const ChannelId: WideString; ControllerAddr: Integer; Date: Double); safecall;
    procedure cntWriteClockTime(const ChannelId: WideString; ControllerAddr: Integer; Time: Double); safecall;
    procedure cntReadAllKeys(const ChannelId: WideString; ControllerAddr: Integer; 
                             out KeyList: ITSSServCont_KeyList); safecall;
    procedure cntReadTimetable(const ChannelId: WideString; ControllerAddr: Integer; 
                               out SpecialDayList: ITSSServCont_TimetableSpecialDayList; 
                               out TimetableItemList: ITSSServCont_TimetableItemList); safecall;
    procedure cntWriteTimetable(const ChannelId: WideString; ControllerAddr: Integer; 
                                const SpecialDayList: ITSSServCont_TimetableSpecialDayList; 
                                const TimetableItemList: ITSSServCont_TimetableItemList); safecall;
    procedure cntTimetableErase(const ChannelId: WideString; ControllerAddr: Integer); safecall;
    procedure cntRestartProg(const ChannelId: WideString; ControllerAddr: Integer); safecall;
    procedure cntEraseAllEvents(const ChannelId: WideString; ControllerAddr: Integer); safecall;
    procedure cntEventsInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                            out Capacity: Integer; out Count: Integer); safecall;
    procedure cntKeysInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                          out Capacity: Integer; out Count: Integer); safecall;
    procedure cntPortsInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                           out Ports: ITSSServCont_ControllerPorts); safecall;
    procedure cntGenerateTimerEvents(const ChannelId: WideString; ControllerAddr: Integer; 
                                     Count: Integer); safecall;
    procedure cntReadKeypad(const ChannelId: WideString; ControllerAddr: Integer; 
                            out KeypadItems: ITSSServCont_KeypadItems); safecall;
    procedure cntWriteKeypad(const ChannelId: WideString; ControllerAddr: Integer; 
                             const KeypadItems: ITSSServCont_KeypadItems); safecall;
    procedure cntGenerateKeyBase(const ChannelId: WideString; ControllerAddr: Integer); safecall;
    procedure cntWriteAllKey(const ChannelId: WideString; ControllerAddr: Integer; 
                             const KeyList: ITSSServCont_KeyList); safecall;
    procedure cntReadAllChips(const ChannelId: WideString; ControllerAddr: Integer; 
                              out Ports: ITSSServCont_ControllerPorts; 
                              out ChipsList: ITSSServCont_ControllerChipList); safecall;
    procedure cntWriteAllChips(const ChannelId: WideString; ControllerAddr: Integer; 
                               const Ports: ITSSServCont_ControllerPorts; 
                               const ChipsList: ITSSServCont_ControllerChipList); safecall;
    procedure cntActivateChip(const ChannelId: WideString; ControllerAddr: Integer; 
                              const Chip: ITSSServCont_ControllerKeyValue); safecall;
    procedure cntDeactivateChip(const ChannelId: WideString; ControllerAddr: Integer; 
                                const Chip: ITSSServCont_ControllerKeyValue); safecall;
    procedure cntEraseAllChips(const ChannelId: WideString; ControllerAddr: Integer); safecall;
    property Active: WordBool read Get_Active write Set_Active;
    property Ready: WordBool read Get_Ready;
    property Host: WideString read Get_Host write Set_Host;
    property Port: Integer read Get_Port write Set_Port;
  end;

// *********************************************************************//
// DispIntf:  ITSSServContDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A8781959-05F0-48B7-A7C6-96AFC048FE33}
// *********************************************************************//
  ITSSServContDisp = dispinterface
    ['{A8781959-05F0-48B7-A7C6-96AFC048FE33}']
    property Active: WordBool dispid 1610743808;
    property Ready: WordBool readonly dispid 1610743810;
    property Host: WideString dispid 1610743811;
    property Port: Integer dispid 1610743813;
    function srvAddIPChannel(const Host: WideString; Port: Integer; ResponseTimeout: Integer; 
                             AliveTimeout: Integer; DeadTimeout: Integer): WideString; dispid 1610743815;
    function srvAddChannel(const Port: WideString; Speed: Integer; ResponseTimeout: Integer; 
                           AliveTimeout: Integer; DeadTimeout: Integer): WideString; dispid 1610743816;
    function srvAddDvRs422Channel(Speed: Integer; ResponseTimeout: Integer; AliveTimeout: Integer; 
                                  DeadTimeout: Integer): WideString; dispid 1610743817;
    procedure srvRemoveChannel(const ChannelId: WideString); dispid 1610743818;
    procedure srvActivateChannel(const ChannelId: WideString); dispid 1610743819;
    procedure srvDeactivateChannel(const ChannelId: WideString); dispid 1610743820;
    procedure srvAddController(ControllerAddr: Integer; const ChannelId: WideString); dispid 1610743821;
    procedure srvRemoveController(ControllerAddr: Integer; const ChannelId: WideString); dispid 1610743822;
    procedure srvChannelList(out Data: ITSSServCont_ChannelList); dispid 1610743823;
    procedure srvControllerList(const ChannelId: WideString; out Data: ITSSServCont_ControllerList); dispid 1610743824;
    procedure srvClientList(out Data: ITSSServCont_ClientList); dispid 1610743825;
    procedure srvSwitchToAuto; dispid 1610743826;
    procedure srvMainClient(LogControllerEvents: WordBool; qLimit: Integer); dispid 1610743827;
    procedure srvCoEvtLogSend(const BeginInterval: ITSSServCont_ServcontDateTime; 
                              const EndInterval: ITSSServCont_ServcontDateTime; Limit: Integer; 
                              Offset: Integer; out Count: Integer); dispid 1610743828;
    procedure srvCoEvtLogClear; dispid 1610743829;
    procedure srvSetHostClock(const Value: ITSSServCont_ServcontDateTime); dispid 1610743830;
    procedure cntRelayOn(const ChannelId: WideString; ControllerAddr: Integer; Port: Integer; 
                         SuppressDoorEvent: WordBool; Interval: Integer); dispid 1610743831;
    procedure cntRelayOff(const ChannelId: WideString; ControllerAddr: Integer; Port: Integer; 
                          SuppressDoorEvent: WordBool); dispid 1610743832;
    procedure cntPollOn(const ChannelId: WideString; ControllerAddr: Integer; IsAuto: WordBool; 
                        IsReliable: WordBool); dispid 1610743833;
    procedure cntPollOff(const ChannelId: WideString; ControllerAddr: Integer; ForceAuto: WordBool); dispid 1610743834;
    procedure cntTimerOff(const ChannelId: WideString; ControllerAddr: Integer); dispid 1610743835;
    procedure cntTimerOn(const ChannelId: WideString; ControllerAddr: Integer; Interval: Integer); dispid 1610743836;
    procedure cntWriteKey(const ChannelId: WideString; ControllerAddr: Integer; 
                          const Key: ITSSServCont_ControllerKey); dispid 1610743837;
    procedure cntEraseKey(const ChannelId: WideString; ControllerAddr: Integer; 
                          const KeyValue: ITSSServCont_ControllerKeyValue); dispid 1610743838;
    procedure cntKeyExist(const ChannelId: WideString; ControllerAddr: Integer; 
                          const KeyValue: ITSSServCont_ControllerKeyValue; out IsExist: WordBool; 
                          out KeyAttr: ITSSServCont_ControllerKeyAttr); dispid 1610743839;
    procedure cntEraseAllKeys(const ChannelId: WideString; ControllerAddr: Integer); dispid 1610743840;
    procedure cntProgId(const ChannelId: WideString; ControllerAddr: Integer; out Id: Integer); dispid 1610743841;
    procedure cntProgVer(const ChannelId: WideString; ControllerAddr: Integer; out Ver: WideString); dispid 1610743842;
    procedure cntSerNum(const ChannelId: WideString; ControllerAddr: Integer; out SerNum: Integer); dispid 1610743843;
    procedure cntReadClock(const ChannelId: WideString; ControllerAddr: Integer; 
                           out Clock: ITSSServCont_ServcontDateTime); dispid 1610743844;
    procedure cntWriteClockDate(const ChannelId: WideString; ControllerAddr: Integer; Date: Double); dispid 1610743845;
    procedure cntWriteClockTime(const ChannelId: WideString; ControllerAddr: Integer; Time: Double); dispid 1610743846;
    procedure cntReadAllKeys(const ChannelId: WideString; ControllerAddr: Integer; 
                             out KeyList: ITSSServCont_KeyList); dispid 1610743847;
    procedure cntReadTimetable(const ChannelId: WideString; ControllerAddr: Integer; 
                               out SpecialDayList: ITSSServCont_TimetableSpecialDayList; 
                               out TimetableItemList: ITSSServCont_TimetableItemList); dispid 1610743848;
    procedure cntWriteTimetable(const ChannelId: WideString; ControllerAddr: Integer; 
                                const SpecialDayList: ITSSServCont_TimetableSpecialDayList; 
                                const TimetableItemList: ITSSServCont_TimetableItemList); dispid 1610743849;
    procedure cntTimetableErase(const ChannelId: WideString; ControllerAddr: Integer); dispid 1610743850;
    procedure cntRestartProg(const ChannelId: WideString; ControllerAddr: Integer); dispid 1610743851;
    procedure cntEraseAllEvents(const ChannelId: WideString; ControllerAddr: Integer); dispid 1610743852;
    procedure cntEventsInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                            out Capacity: Integer; out Count: Integer); dispid 1610743853;
    procedure cntKeysInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                          out Capacity: Integer; out Count: Integer); dispid 1610743854;
    procedure cntPortsInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                           out Ports: ITSSServCont_ControllerPorts); dispid 1610743855;
    procedure cntGenerateTimerEvents(const ChannelId: WideString; ControllerAddr: Integer; 
                                     Count: Integer); dispid 1610743856;
    procedure cntReadKeypad(const ChannelId: WideString; ControllerAddr: Integer; 
                            out KeypadItems: ITSSServCont_KeypadItems); dispid 1610743857;
    procedure cntWriteKeypad(const ChannelId: WideString; ControllerAddr: Integer; 
                             const KeypadItems: ITSSServCont_KeypadItems); dispid 1610743858;
    procedure cntGenerateKeyBase(const ChannelId: WideString; ControllerAddr: Integer); dispid 1610743859;
    procedure cntWriteAllKey(const ChannelId: WideString; ControllerAddr: Integer; 
                             const KeyList: ITSSServCont_KeyList); dispid 1610743860;
    procedure cntReadAllChips(const ChannelId: WideString; ControllerAddr: Integer; 
                              out Ports: ITSSServCont_ControllerPorts; 
                              out ChipsList: ITSSServCont_ControllerChipList); dispid 1610743861;
    procedure cntWriteAllChips(const ChannelId: WideString; ControllerAddr: Integer; 
                               const Ports: ITSSServCont_ControllerPorts; 
                               const ChipsList: ITSSServCont_ControllerChipList); dispid 1610743862;
    procedure cntActivateChip(const ChannelId: WideString; ControllerAddr: Integer; 
                              const Chip: ITSSServCont_ControllerKeyValue); dispid 1610743863;
    procedure cntDeactivateChip(const ChannelId: WideString; ControllerAddr: Integer; 
                                const Chip: ITSSServCont_ControllerKeyValue); dispid 1610743864;
    procedure cntEraseAllChips(const ChannelId: WideString; ControllerAddr: Integer); dispid 1610743865;
  end;

// *********************************************************************//
// DispIntf:  ITSSServContEvents
// Flags:     (4096) Dispatchable
// GUID:      {E9168480-8ABA-4016-9B21-A1C423C2E18A}
// *********************************************************************//
  ITSSServContEvents = dispinterface
    ['{E9168480-8ABA-4016-9B21-A1C423C2E18A}']
    procedure OnCont220VEvent(const ChannelId: WideString; const Event: ITSSServCont_ControllerEvent); dispid 207;
    procedure OnContCaseEvent(const ChannelId: WideString; const Event: ITSSServCont_ControllerEvent); dispid 208;
    procedure OnContTimerEvent(const ChannelId: WideString; 
                               const Event: ITSSServCont_ControllerEvent); dispid 209;
    procedure OnContStartEvent(const ChannelId: WideString; 
                               const Event: ITSSServCont_ControllerEvent); dispid 210;
    procedure OnContRestartEvent(const ChannelId: WideString; 
                                 const Event: ITSSServCont_ControllerEvent); dispid 211;
    procedure OnContAutoTimeoutEvent(const ChannelId: WideString; 
                                     const Event: ITSSServCont_ControllerEvent); dispid 212;
    procedure OnContButtonEvent(const ChannelId: WideString; 
                                const Event: ITSSServCont_ControllerPortRelayEvent); dispid 213;
    procedure OnContDoorOpenEvent(const ChannelId: WideString; 
                                  const Event: ITSSServCont_ControllerPortRelayEvent); dispid 214;
    procedure OnContDoorCloseEvent(const ChannelId: WideString; 
                                   const Event: ITSSServCont_ControllerPortRelayEvent); dispid 215;
    procedure OnContKeyEvent(const ChannelId: WideString; 
                             const Event: ITSSServCont_ControllerKeyEvent); dispid 216;
    procedure OnContStaticSensorEvent(const ChannelId: WideString; 
                                      const Event: ITSSServCont_ControllerStaticSensorEvent); dispid 217;
    procedure OnContErrorEvent(const ChannelId: WideString; 
                               const Time: ITSSServCont_ServcontDateTime; const EClass: WideString; 
                               const EMessage: WideString; Addr: Integer); dispid 218;
    procedure OnContChannelErrorEvent(const ChannelId: WideString; 
                                      const Time: ITSSServCont_ServcontDateTime; 
                                      const EClass: WideString; const EMessage: WideString); dispid 219;
    procedure OnContChannelStateEvent(const ChannelId: WideString; 
                                      const Time: ITSSServCont_ServcontDateTime; IsReady: WordBool); dispid 220;
    procedure OnContChannelPollSpeedEvent(const ChannelId: WideString; 
                                          const Time: ITSSServCont_ServcontDateTime; Value: Integer); dispid 221;
    procedure OnContChangeStateEvent(const ChannelId: WideString; ControllerAddr: Integer; 
                                     const Time: ITSSServCont_ServcontDateTime; 
                                     State: TTSSServCont_ControllerState); dispid 222;
    procedure OnClientsChangedEvent(const Time: ITSSServCont_ServcontDateTime); dispid 223;
    procedure OnContChannelChangedEvent(const Time: ITSSServCont_ServcontDateTime); dispid 224;
    procedure OnContChangedEvent(const ChannelId: WideString; 
                                 const Time: ITSSServCont_ServcontDateTime); dispid 225;
    procedure OnReadyChangeEvent; dispid 226;
    procedure OnQueueFullEvent(const Time: ITSSServCont_ServcontDateTime); dispid 227;
  end;

// *********************************************************************//
// The Class CoTSSServContX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont exposed by              
// the CoClass TSSServContX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServContX = class
    class function Create: ITSSServCont;
    class function CreateRemote(const MachineName: string): ITSSServCont;
  end;

  TTSSServContXOnCont220VEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                             const Event: ITSSServCont_ControllerEvent) of object;
  TTSSServContXOnContCaseEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                             const Event: ITSSServCont_ControllerEvent) of object;
  TTSSServContXOnContTimerEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                              const Event: ITSSServCont_ControllerEvent) of object;
  TTSSServContXOnContStartEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                              const Event: ITSSServCont_ControllerEvent) of object;
  TTSSServContXOnContRestartEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                const Event: ITSSServCont_ControllerEvent) of object;
  TTSSServContXOnContAutoTimeoutEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                    const Event: ITSSServCont_ControllerEvent) of object;
  TTSSServContXOnContButtonEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                               const Event: ITSSServCont_ControllerPortRelayEvent) of object;
  TTSSServContXOnContDoorOpenEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                 const Event: ITSSServCont_ControllerPortRelayEvent) of object;
  TTSSServContXOnContDoorCloseEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                  const Event: ITSSServCont_ControllerPortRelayEvent) of object;
  TTSSServContXOnContKeyEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                            const Event: ITSSServCont_ControllerKeyEvent) of object;
  TTSSServContXOnContStaticSensorEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                     const Event: ITSSServCont_ControllerStaticSensorEvent) of object;
  TTSSServContXOnContErrorEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                              const Time: ITSSServCont_ServcontDateTime; 
                                                              const EClass: WideString; 
                                                              const EMessage: WideString; 
                                                              Addr: Integer) of object;
  TTSSServContXOnContChannelErrorEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                     const Time: ITSSServCont_ServcontDateTime; 
                                                                     const EClass: WideString; 
                                                                     const EMessage: WideString) of object;
  TTSSServContXOnContChannelStateEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                     const Time: ITSSServCont_ServcontDateTime; 
                                                                     IsReady: WordBool) of object;
  TTSSServContXOnContChannelPollSpeedEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                         const Time: ITSSServCont_ServcontDateTime; 
                                                                         Value: Integer) of object;
  TTSSServContXOnContChangeStateEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                    ControllerAddr: Integer; 
                                                                    const Time: ITSSServCont_ServcontDateTime; 
                                                                    State: TTSSServCont_ControllerState) of object;
  TTSSServContXOnClientsChangedEvent = procedure(ASender: TObject; const Time: ITSSServCont_ServcontDateTime) of object;
  TTSSServContXOnContChannelChangedEvent = procedure(ASender: TObject; const Time: ITSSServCont_ServcontDateTime) of object;
  TTSSServContXOnContChangedEvent = procedure(ASender: TObject; const ChannelId: WideString; 
                                                                const Time: ITSSServCont_ServcontDateTime) of object;
  TTSSServContXOnQueueFullEvent = procedure(ASender: TObject; const Time: ITSSServCont_ServcontDateTime) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServContX
// Help String      : TSSServCont Main object
// Default Interface: ITSSServCont
// Def. Intf. DISP? : No
// Event   Interface: ITSSServContEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServContXProperties= class;
{$ENDIF}
  TTSSServContX = class(TOleServer)
  private
    FOnCont220VEvent: TTSSServContXOnCont220VEvent;
    FOnContCaseEvent: TTSSServContXOnContCaseEvent;
    FOnContTimerEvent: TTSSServContXOnContTimerEvent;
    FOnContStartEvent: TTSSServContXOnContStartEvent;
    FOnContRestartEvent: TTSSServContXOnContRestartEvent;
    FOnContAutoTimeoutEvent: TTSSServContXOnContAutoTimeoutEvent;
    FOnContButtonEvent: TTSSServContXOnContButtonEvent;
    FOnContDoorOpenEvent: TTSSServContXOnContDoorOpenEvent;
    FOnContDoorCloseEvent: TTSSServContXOnContDoorCloseEvent;
    FOnContKeyEvent: TTSSServContXOnContKeyEvent;
    FOnContStaticSensorEvent: TTSSServContXOnContStaticSensorEvent;
    FOnContErrorEvent: TTSSServContXOnContErrorEvent;
    FOnContChannelErrorEvent: TTSSServContXOnContChannelErrorEvent;
    FOnContChannelStateEvent: TTSSServContXOnContChannelStateEvent;
    FOnContChannelPollSpeedEvent: TTSSServContXOnContChannelPollSpeedEvent;
    FOnContChangeStateEvent: TTSSServContXOnContChangeStateEvent;
    FOnClientsChangedEvent: TTSSServContXOnClientsChangedEvent;
    FOnContChannelChangedEvent: TTSSServContXOnContChannelChangedEvent;
    FOnContChangedEvent: TTSSServContXOnContChangedEvent;
    FOnReadyChangeEvent: TNotifyEvent;
    FOnQueueFullEvent: TTSSServContXOnQueueFullEvent;
    FIntf:        ITSSServCont;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServContXProperties;
    function      GetServerProperties: TTSSServContXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_Active: WordBool;
    procedure Set_Active(Value: WordBool);
    function Get_Ready: WordBool;
    function Get_Host: WideString;
    procedure Set_Host(const Value: WideString);
    function Get_Port: Integer;
    procedure Set_Port(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont);
    procedure Disconnect; override;
    function srvAddIPChannel(const Host: WideString; Port: Integer; ResponseTimeout: Integer; 
                             AliveTimeout: Integer; DeadTimeout: Integer): WideString;
    function srvAddChannel(const Port: WideString; Speed: Integer; ResponseTimeout: Integer; 
                           AliveTimeout: Integer; DeadTimeout: Integer): WideString;
    function srvAddDvRs422Channel(Speed: Integer; ResponseTimeout: Integer; AliveTimeout: Integer; 
                                  DeadTimeout: Integer): WideString;
    procedure srvRemoveChannel(const ChannelId: WideString);
    procedure srvActivateChannel(const ChannelId: WideString);
    procedure srvDeactivateChannel(const ChannelId: WideString);
    procedure srvAddController(ControllerAddr: Integer; const ChannelId: WideString);
    procedure srvRemoveController(ControllerAddr: Integer; const ChannelId: WideString);
    procedure srvChannelList(out Data: ITSSServCont_ChannelList);
    procedure srvControllerList(const ChannelId: WideString; out Data: ITSSServCont_ControllerList);
    procedure srvClientList(out Data: ITSSServCont_ClientList);
    procedure srvSwitchToAuto;
    procedure srvMainClient(LogControllerEvents: WordBool; qLimit: Integer);
    procedure srvCoEvtLogSend(const BeginInterval: ITSSServCont_ServcontDateTime; 
                              const EndInterval: ITSSServCont_ServcontDateTime; Limit: Integer; 
                              Offset: Integer; out Count: Integer);
    procedure srvCoEvtLogClear;
    procedure srvSetHostClock(const Value: ITSSServCont_ServcontDateTime);
    procedure cntRelayOn(const ChannelId: WideString; ControllerAddr: Integer; Port: Integer; 
                         SuppressDoorEvent: WordBool; Interval: Integer);
    procedure cntRelayOff(const ChannelId: WideString; ControllerAddr: Integer; Port: Integer; 
                          SuppressDoorEvent: WordBool);
    procedure cntPollOn(const ChannelId: WideString; ControllerAddr: Integer; IsAuto: WordBool; 
                        IsReliable: WordBool);
    procedure cntPollOff(const ChannelId: WideString; ControllerAddr: Integer; ForceAuto: WordBool);
    procedure cntTimerOff(const ChannelId: WideString; ControllerAddr: Integer);
    procedure cntTimerOn(const ChannelId: WideString; ControllerAddr: Integer; Interval: Integer);
    procedure cntWriteKey(const ChannelId: WideString; ControllerAddr: Integer; 
                          const Key: ITSSServCont_ControllerKey);
    procedure cntEraseKey(const ChannelId: WideString; ControllerAddr: Integer; 
                          const KeyValue: ITSSServCont_ControllerKeyValue);
    procedure cntKeyExist(const ChannelId: WideString; ControllerAddr: Integer; 
                          const KeyValue: ITSSServCont_ControllerKeyValue; out IsExist: WordBool; 
                          out KeyAttr: ITSSServCont_ControllerKeyAttr);
    procedure cntEraseAllKeys(const ChannelId: WideString; ControllerAddr: Integer);
    procedure cntProgId(const ChannelId: WideString; ControllerAddr: Integer; out Id: Integer);
    procedure cntProgVer(const ChannelId: WideString; ControllerAddr: Integer; out Ver: WideString);
    procedure cntSerNum(const ChannelId: WideString; ControllerAddr: Integer; out SerNum: Integer);
    procedure cntReadClock(const ChannelId: WideString; ControllerAddr: Integer; 
                           out Clock: ITSSServCont_ServcontDateTime);
    procedure cntWriteClockDate(const ChannelId: WideString; ControllerAddr: Integer; Date: Double);
    procedure cntWriteClockTime(const ChannelId: WideString; ControllerAddr: Integer; Time: Double);
    procedure cntReadAllKeys(const ChannelId: WideString; ControllerAddr: Integer; 
                             out KeyList: ITSSServCont_KeyList);
    procedure cntReadTimetable(const ChannelId: WideString; ControllerAddr: Integer; 
                               out SpecialDayList: ITSSServCont_TimetableSpecialDayList; 
                               out TimetableItemList: ITSSServCont_TimetableItemList);
    procedure cntWriteTimetable(const ChannelId: WideString; ControllerAddr: Integer; 
                                const SpecialDayList: ITSSServCont_TimetableSpecialDayList; 
                                const TimetableItemList: ITSSServCont_TimetableItemList);
    procedure cntTimetableErase(const ChannelId: WideString; ControllerAddr: Integer);
    procedure cntRestartProg(const ChannelId: WideString; ControllerAddr: Integer);
    procedure cntEraseAllEvents(const ChannelId: WideString; ControllerAddr: Integer);
    procedure cntEventsInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                            out Capacity: Integer; out Count: Integer);
    procedure cntKeysInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                          out Capacity: Integer; out Count: Integer);
    procedure cntPortsInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                           out Ports: ITSSServCont_ControllerPorts);
    procedure cntGenerateTimerEvents(const ChannelId: WideString; ControllerAddr: Integer; 
                                     Count: Integer);
    procedure cntReadKeypad(const ChannelId: WideString; ControllerAddr: Integer; 
                            out KeypadItems: ITSSServCont_KeypadItems);
    procedure cntWriteKeypad(const ChannelId: WideString; ControllerAddr: Integer; 
                             const KeypadItems: ITSSServCont_KeypadItems);
    procedure cntGenerateKeyBase(const ChannelId: WideString; ControllerAddr: Integer);
    procedure cntWriteAllKey(const ChannelId: WideString; ControllerAddr: Integer; 
                             const KeyList: ITSSServCont_KeyList);
    procedure cntReadAllChips(const ChannelId: WideString; ControllerAddr: Integer; 
                              out Ports: ITSSServCont_ControllerPorts; 
                              out ChipsList: ITSSServCont_ControllerChipList);
    procedure cntWriteAllChips(const ChannelId: WideString; ControllerAddr: Integer; 
                               const Ports: ITSSServCont_ControllerPorts; 
                               const ChipsList: ITSSServCont_ControllerChipList);
    procedure cntActivateChip(const ChannelId: WideString; ControllerAddr: Integer; 
                              const Chip: ITSSServCont_ControllerKeyValue);
    procedure cntDeactivateChip(const ChannelId: WideString; ControllerAddr: Integer; 
                                const Chip: ITSSServCont_ControllerKeyValue);
    procedure cntEraseAllChips(const ChannelId: WideString; ControllerAddr: Integer);
    property DefaultInterface: ITSSServCont read GetDefaultInterface;
    property Ready: WordBool read Get_Ready;
    property Active: WordBool read Get_Active write Set_Active;
    property Host: WideString read Get_Host write Set_Host;
    property Port: Integer read Get_Port write Set_Port;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServContXProperties read GetServerProperties;
{$ENDIF}
    property OnCont220VEvent: TTSSServContXOnCont220VEvent read FOnCont220VEvent write FOnCont220VEvent;
    property OnContCaseEvent: TTSSServContXOnContCaseEvent read FOnContCaseEvent write FOnContCaseEvent;
    property OnContTimerEvent: TTSSServContXOnContTimerEvent read FOnContTimerEvent write FOnContTimerEvent;
    property OnContStartEvent: TTSSServContXOnContStartEvent read FOnContStartEvent write FOnContStartEvent;
    property OnContRestartEvent: TTSSServContXOnContRestartEvent read FOnContRestartEvent write FOnContRestartEvent;
    property OnContAutoTimeoutEvent: TTSSServContXOnContAutoTimeoutEvent read FOnContAutoTimeoutEvent write FOnContAutoTimeoutEvent;
    property OnContButtonEvent: TTSSServContXOnContButtonEvent read FOnContButtonEvent write FOnContButtonEvent;
    property OnContDoorOpenEvent: TTSSServContXOnContDoorOpenEvent read FOnContDoorOpenEvent write FOnContDoorOpenEvent;
    property OnContDoorCloseEvent: TTSSServContXOnContDoorCloseEvent read FOnContDoorCloseEvent write FOnContDoorCloseEvent;
    property OnContKeyEvent: TTSSServContXOnContKeyEvent read FOnContKeyEvent write FOnContKeyEvent;
    property OnContStaticSensorEvent: TTSSServContXOnContStaticSensorEvent read FOnContStaticSensorEvent write FOnContStaticSensorEvent;
    property OnContErrorEvent: TTSSServContXOnContErrorEvent read FOnContErrorEvent write FOnContErrorEvent;
    property OnContChannelErrorEvent: TTSSServContXOnContChannelErrorEvent read FOnContChannelErrorEvent write FOnContChannelErrorEvent;
    property OnContChannelStateEvent: TTSSServContXOnContChannelStateEvent read FOnContChannelStateEvent write FOnContChannelStateEvent;
    property OnContChannelPollSpeedEvent: TTSSServContXOnContChannelPollSpeedEvent read FOnContChannelPollSpeedEvent write FOnContChannelPollSpeedEvent;
    property OnContChangeStateEvent: TTSSServContXOnContChangeStateEvent read FOnContChangeStateEvent write FOnContChangeStateEvent;
    property OnClientsChangedEvent: TTSSServContXOnClientsChangedEvent read FOnClientsChangedEvent write FOnClientsChangedEvent;
    property OnContChannelChangedEvent: TTSSServContXOnContChannelChangedEvent read FOnContChannelChangedEvent write FOnContChannelChangedEvent;
    property OnContChangedEvent: TTSSServContXOnContChangedEvent read FOnContChangedEvent write FOnContChangedEvent;
    property OnReadyChangeEvent: TNotifyEvent read FOnReadyChangeEvent write FOnReadyChangeEvent;
    property OnQueueFullEvent: TTSSServContXOnQueueFullEvent read FOnQueueFullEvent write FOnQueueFullEvent;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServContX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServContXProperties = class(TPersistent)
  private
    FServer:    TTSSServContX;
    function    GetDefaultInterface: ITSSServCont;
    constructor Create(AServer: TTSSServContX);
  protected
    function Get_Active: WordBool;
    procedure Set_Active(Value: WordBool);
    function Get_Ready: WordBool;
    function Get_Host: WideString;
    procedure Set_Host(const Value: WideString);
    function Get_Port: Integer;
    procedure Set_Port(Value: Integer);
  public
    property DefaultInterface: ITSSServCont read GetDefaultInterface;
  published
    property Active: WordBool read Get_Active write Set_Active;
    property Host: WideString read Get_Host write Set_Host;
    property Port: Integer read Get_Port write Set_Port;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_TimetableSpecialDayListX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_TimetableSpecialDayList exposed by              
// the CoClass TSSServCont_TimetableSpecialDayListX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_TimetableSpecialDayListX = class
    class function Create: ITSSServCont_TimetableSpecialDayList;
    class function CreateRemote(const MachineName: string): ITSSServCont_TimetableSpecialDayList;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_TimetableSpecialDayListX
// Help String      : 
// Default Interface: ITSSServCont_TimetableSpecialDayList
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_TimetableSpecialDayListXProperties= class;
{$ENDIF}
  TTSSServCont_TimetableSpecialDayListX = class(TOleServer)
  private
    FIntf:        ITSSServCont_TimetableSpecialDayList;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_TimetableSpecialDayListXProperties;
    function      GetServerProperties: TTSSServCont_TimetableSpecialDayListXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_TimetableSpecialDayList;
  protected
    procedure InitServerData; override;
    function Get_Count: Integer;
    procedure Set_Count(Value: Integer);
    function Get_Items(Index: Integer): ITSSServCont_ControllerTimetableSpecialDay;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerTimetableSpecialDay);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_TimetableSpecialDayList);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_TimetableSpecialDayList read GetDefaultInterface;
    property Items[Index: Integer]: ITSSServCont_ControllerTimetableSpecialDay read Get_Items write Set_Items;
    property Count: Integer read Get_Count write Set_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_TimetableSpecialDayListXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_TimetableSpecialDayListX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_TimetableSpecialDayListXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_TimetableSpecialDayListX;
    function    GetDefaultInterface: ITSSServCont_TimetableSpecialDayList;
    constructor Create(AServer: TTSSServCont_TimetableSpecialDayListX);
  protected
    function Get_Count: Integer;
    procedure Set_Count(Value: Integer);
    function Get_Items(Index: Integer): ITSSServCont_ControllerTimetableSpecialDay;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerTimetableSpecialDay);
  public
    property DefaultInterface: ITSSServCont_TimetableSpecialDayList read GetDefaultInterface;
  published
    property Count: Integer read Get_Count write Set_Count;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_TimetableItemListX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_TimetableItemList exposed by              
// the CoClass TSSServCont_TimetableItemListX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_TimetableItemListX = class
    class function Create: ITSSServCont_TimetableItemList;
    class function CreateRemote(const MachineName: string): ITSSServCont_TimetableItemList;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_TimetableItemListX
// Help String      : 
// Default Interface: ITSSServCont_TimetableItemList
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_TimetableItemListXProperties= class;
{$ENDIF}
  TTSSServCont_TimetableItemListX = class(TOleServer)
  private
    FIntf:        ITSSServCont_TimetableItemList;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_TimetableItemListXProperties;
    function      GetServerProperties: TTSSServCont_TimetableItemListXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_TimetableItemList;
  protected
    procedure InitServerData; override;
    function Get_Count: Integer;
    procedure Set_Count(Value: Integer);
    function Get_Items(Index: Integer): ITSSServCont_ControllerTimetableItem;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerTimetableItem);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_TimetableItemList);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_TimetableItemList read GetDefaultInterface;
    property Items[Index: Integer]: ITSSServCont_ControllerTimetableItem read Get_Items write Set_Items;
    property Count: Integer read Get_Count write Set_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_TimetableItemListXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_TimetableItemListX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_TimetableItemListXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_TimetableItemListX;
    function    GetDefaultInterface: ITSSServCont_TimetableItemList;
    constructor Create(AServer: TTSSServCont_TimetableItemListX);
  protected
    function Get_Count: Integer;
    procedure Set_Count(Value: Integer);
    function Get_Items(Index: Integer): ITSSServCont_ControllerTimetableItem;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerTimetableItem);
  public
    property DefaultInterface: ITSSServCont_TimetableItemList read GetDefaultInterface;
  published
    property Count: Integer read Get_Count write Set_Count;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_ControllerChipListX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_ControllerChipList exposed by              
// the CoClass TSSServCont_ControllerChipListX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_ControllerChipListX = class
    class function Create: ITSSServCont_ControllerChipList;
    class function CreateRemote(const MachineName: string): ITSSServCont_ControllerChipList;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_ControllerChipListX
// Help String      : 
// Default Interface: ITSSServCont_ControllerChipList
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_ControllerChipListXProperties= class;
{$ENDIF}
  TTSSServCont_ControllerChipListX = class(TOleServer)
  private
    FIntf:        ITSSServCont_ControllerChipList;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_ControllerChipListXProperties;
    function      GetServerProperties: TTSSServCont_ControllerChipListXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_ControllerChipList;
  protected
    procedure InitServerData; override;
    function Get_Count: Integer;
    procedure Set_Count(Value: Integer);
    function Get_Items(Index: Integer): ITSSServCont_ControllerChip;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerChip);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_ControllerChipList);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_ControllerChipList read GetDefaultInterface;
    property Items[Index: Integer]: ITSSServCont_ControllerChip read Get_Items write Set_Items;
    property Count: Integer read Get_Count write Set_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_ControllerChipListXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_ControllerChipListX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_ControllerChipListXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_ControllerChipListX;
    function    GetDefaultInterface: ITSSServCont_ControllerChipList;
    constructor Create(AServer: TTSSServCont_ControllerChipListX);
  protected
    function Get_Count: Integer;
    procedure Set_Count(Value: Integer);
    function Get_Items(Index: Integer): ITSSServCont_ControllerChip;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerChip);
  public
    property DefaultInterface: ITSSServCont_ControllerChipList read GetDefaultInterface;
  published
    property Count: Integer read Get_Count write Set_Count;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_ControllerKeyValueX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_ControllerKeyValue exposed by              
// the CoClass TSSServCont_ControllerKeyValueX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_ControllerKeyValueX = class
    class function Create: ITSSServCont_ControllerKeyValue;
    class function CreateRemote(const MachineName: string): ITSSServCont_ControllerKeyValue;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_ControllerKeyValueX
// Help String      : 
// Default Interface: ITSSServCont_ControllerKeyValue
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_ControllerKeyValueXProperties= class;
{$ENDIF}
  TTSSServCont_ControllerKeyValueX = class(TOleServer)
  private
    FIntf:        ITSSServCont_ControllerKeyValue;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_ControllerKeyValueXProperties;
    function      GetServerProperties: TTSSServCont_ControllerKeyValueXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_ControllerKeyValue;
  protected
    procedure InitServerData; override;
    function Get_B(Index: Integer): Byte;
    procedure Set_B(Index: Integer; Value: Byte);
    function Get_Count: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_ControllerKeyValue);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_ControllerKeyValue read GetDefaultInterface;
    property B[Index: Integer]: Byte read Get_B write Set_B;
    property Count: Integer read Get_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_ControllerKeyValueXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_ControllerKeyValueX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_ControllerKeyValueXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_ControllerKeyValueX;
    function    GetDefaultInterface: ITSSServCont_ControllerKeyValue;
    constructor Create(AServer: TTSSServCont_ControllerKeyValueX);
  protected
    function Get_B(Index: Integer): Byte;
    procedure Set_B(Index: Integer; Value: Byte);
    function Get_Count: Integer;
  public
    property DefaultInterface: ITSSServCont_ControllerKeyValue read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_ControllerPortsX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_ControllerPorts exposed by              
// the CoClass TSSServCont_ControllerPortsX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_ControllerPortsX = class
    class function Create: ITSSServCont_ControllerPorts;
    class function CreateRemote(const MachineName: string): ITSSServCont_ControllerPorts;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_ControllerPortsX
// Help String      : 
// Default Interface: ITSSServCont_ControllerPorts
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_ControllerPortsXProperties= class;
{$ENDIF}
  TTSSServCont_ControllerPortsX = class(TOleServer)
  private
    FIntf:        ITSSServCont_ControllerPorts;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_ControllerPortsXProperties;
    function      GetServerProperties: TTSSServCont_ControllerPortsXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_ControllerPorts;
  protected
    procedure InitServerData; override;
    function Get_P(Index: Integer): WordBool;
    procedure Set_P(Index: Integer; Value: WordBool);
    function Get_Count: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_ControllerPorts);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_ControllerPorts read GetDefaultInterface;
    property P[Index: Integer]: WordBool read Get_P write Set_P;
    property Count: Integer read Get_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_ControllerPortsXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_ControllerPortsX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_ControllerPortsXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_ControllerPortsX;
    function    GetDefaultInterface: ITSSServCont_ControllerPorts;
    constructor Create(AServer: TTSSServCont_ControllerPortsX);
  protected
    function Get_P(Index: Integer): WordBool;
    procedure Set_P(Index: Integer; Value: WordBool);
    function Get_Count: Integer;
  public
    property DefaultInterface: ITSSServCont_ControllerPorts read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_ControllerKeyX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_ControllerKey exposed by              
// the CoClass TSSServCont_ControllerKeyX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_ControllerKeyX = class
    class function Create: ITSSServCont_ControllerKey;
    class function CreateRemote(const MachineName: string): ITSSServCont_ControllerKey;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_ControllerKeyX
// Help String      : 
// Default Interface: ITSSServCont_ControllerKey
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_ControllerKeyXProperties= class;
{$ENDIF}
  TTSSServCont_ControllerKeyX = class(TOleServer)
  private
    FIntf:        ITSSServCont_ControllerKey;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_ControllerKeyXProperties;
    function      GetServerProperties: TTSSServCont_ControllerKeyXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_ControllerKey;
  protected
    procedure InitServerData; override;
    function Get_Value: ITSSServCont_ControllerKeyValue;
    procedure Set_Value(const Value: ITSSServCont_ControllerKeyValue);
    function Get_Ports: ITSSServCont_ControllerPorts;
    procedure Set_Ports(const Value: ITSSServCont_ControllerPorts);
    function Get_PersCat: Byte;
    procedure Set_PersCat(Value: Byte);
    function Get_SuppressDoorEvent: WordBool;
    procedure Set_SuppressDoorEvent(Value: WordBool);
    function Get_OpenEvenComplex: WordBool;
    procedure Set_OpenEvenComplex(Value: WordBool);
    function Get_IsSilent: WordBool;
    procedure Set_IsSilent(Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_ControllerKey);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_ControllerKey read GetDefaultInterface;
    property Value: ITSSServCont_ControllerKeyValue read Get_Value write Set_Value;
    property Ports: ITSSServCont_ControllerPorts read Get_Ports write Set_Ports;
    property PersCat: Byte read Get_PersCat write Set_PersCat;
    property SuppressDoorEvent: WordBool read Get_SuppressDoorEvent write Set_SuppressDoorEvent;
    property OpenEvenComplex: WordBool read Get_OpenEvenComplex write Set_OpenEvenComplex;
    property IsSilent: WordBool read Get_IsSilent write Set_IsSilent;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_ControllerKeyXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_ControllerKeyX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_ControllerKeyXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_ControllerKeyX;
    function    GetDefaultInterface: ITSSServCont_ControllerKey;
    constructor Create(AServer: TTSSServCont_ControllerKeyX);
  protected
    function Get_Value: ITSSServCont_ControllerKeyValue;
    procedure Set_Value(const Value: ITSSServCont_ControllerKeyValue);
    function Get_Ports: ITSSServCont_ControllerPorts;
    procedure Set_Ports(const Value: ITSSServCont_ControllerPorts);
    function Get_PersCat: Byte;
    procedure Set_PersCat(Value: Byte);
    function Get_SuppressDoorEvent: WordBool;
    procedure Set_SuppressDoorEvent(Value: WordBool);
    function Get_OpenEvenComplex: WordBool;
    procedure Set_OpenEvenComplex(Value: WordBool);
    function Get_IsSilent: WordBool;
    procedure Set_IsSilent(Value: WordBool);
  public
    property DefaultInterface: ITSSServCont_ControllerKey read GetDefaultInterface;
  published
    property Value: ITSSServCont_ControllerKeyValue read Get_Value write Set_Value;
    property Ports: ITSSServCont_ControllerPorts read Get_Ports write Set_Ports;
    property PersCat: Byte read Get_PersCat write Set_PersCat;
    property SuppressDoorEvent: WordBool read Get_SuppressDoorEvent write Set_SuppressDoorEvent;
    property OpenEvenComplex: WordBool read Get_OpenEvenComplex write Set_OpenEvenComplex;
    property IsSilent: WordBool read Get_IsSilent write Set_IsSilent;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_ControllerChipX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_ControllerChip exposed by              
// the CoClass TSSServCont_ControllerChipX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_ControllerChipX = class
    class function Create: ITSSServCont_ControllerChip;
    class function CreateRemote(const MachineName: string): ITSSServCont_ControllerChip;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_ControllerChipX
// Help String      : 
// Default Interface: ITSSServCont_ControllerChip
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_ControllerChipXProperties= class;
{$ENDIF}
  TTSSServCont_ControllerChipX = class(TOleServer)
  private
    FIntf:        ITSSServCont_ControllerChip;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_ControllerChipXProperties;
    function      GetServerProperties: TTSSServCont_ControllerChipXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_ControllerChip;
  protected
    procedure InitServerData; override;
    function Get_Value: ITSSServCont_ControllerKeyValue;
    procedure Set_Value(const Value: ITSSServCont_ControllerKeyValue);
    function Get_Active: WordBool;
    procedure Set_Active(Value: WordBool);
    function Get_OpenEvenComplex: WordBool;
    procedure Set_OpenEvenComplex(Value: WordBool);
    function Get_CheckCount: Byte;
    procedure Set_CheckCount(Value: Byte);
    function Get_Port: Byte;
    procedure Set_Port(Value: Byte);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_ControllerChip);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_ControllerChip read GetDefaultInterface;
    property Value: ITSSServCont_ControllerKeyValue read Get_Value write Set_Value;
    property Active: WordBool read Get_Active write Set_Active;
    property OpenEvenComplex: WordBool read Get_OpenEvenComplex write Set_OpenEvenComplex;
    property CheckCount: Byte read Get_CheckCount write Set_CheckCount;
    property Port: Byte read Get_Port write Set_Port;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_ControllerChipXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_ControllerChipX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_ControllerChipXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_ControllerChipX;
    function    GetDefaultInterface: ITSSServCont_ControllerChip;
    constructor Create(AServer: TTSSServCont_ControllerChipX);
  protected
    function Get_Value: ITSSServCont_ControllerKeyValue;
    procedure Set_Value(const Value: ITSSServCont_ControllerKeyValue);
    function Get_Active: WordBool;
    procedure Set_Active(Value: WordBool);
    function Get_OpenEvenComplex: WordBool;
    procedure Set_OpenEvenComplex(Value: WordBool);
    function Get_CheckCount: Byte;
    procedure Set_CheckCount(Value: Byte);
    function Get_Port: Byte;
    procedure Set_Port(Value: Byte);
  public
    property DefaultInterface: ITSSServCont_ControllerChip read GetDefaultInterface;
  published
    property Value: ITSSServCont_ControllerKeyValue read Get_Value write Set_Value;
    property Active: WordBool read Get_Active write Set_Active;
    property OpenEvenComplex: WordBool read Get_OpenEvenComplex write Set_OpenEvenComplex;
    property CheckCount: Byte read Get_CheckCount write Set_CheckCount;
    property Port: Byte read Get_Port write Set_Port;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_ControllerTimetableSpecialDayX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_ControllerTimetableSpecialDay exposed by              
// the CoClass TSSServCont_ControllerTimetableSpecialDayX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_ControllerTimetableSpecialDayX = class
    class function Create: ITSSServCont_ControllerTimetableSpecialDay;
    class function CreateRemote(const MachineName: string): ITSSServCont_ControllerTimetableSpecialDay;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_ControllerTimetableSpecialDayX
// Help String      : 
// Default Interface: ITSSServCont_ControllerTimetableSpecialDay
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_ControllerTimetableSpecialDayXProperties= class;
{$ENDIF}
  TTSSServCont_ControllerTimetableSpecialDayX = class(TOleServer)
  private
    FIntf:        ITSSServCont_ControllerTimetableSpecialDay;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_ControllerTimetableSpecialDayXProperties;
    function      GetServerProperties: TTSSServCont_ControllerTimetableSpecialDayXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_ControllerTimetableSpecialDay;
  protected
    procedure InitServerData; override;
    function Get_Year: Byte;
    procedure Set_Year(Value: Byte);
    function Get_Month: Byte;
    procedure Set_Month(Value: Byte);
    function Get_Day: Byte;
    procedure Set_Day(Value: Byte);
    function Get_DayType: Byte;
    procedure Set_DayType(Value: Byte);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_ControllerTimetableSpecialDay);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_ControllerTimetableSpecialDay read GetDefaultInterface;
    property Year: Byte read Get_Year write Set_Year;
    property Month: Byte read Get_Month write Set_Month;
    property Day: Byte read Get_Day write Set_Day;
    property DayType: Byte read Get_DayType write Set_DayType;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_ControllerTimetableSpecialDayXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_ControllerTimetableSpecialDayX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_ControllerTimetableSpecialDayXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_ControllerTimetableSpecialDayX;
    function    GetDefaultInterface: ITSSServCont_ControllerTimetableSpecialDay;
    constructor Create(AServer: TTSSServCont_ControllerTimetableSpecialDayX);
  protected
    function Get_Year: Byte;
    procedure Set_Year(Value: Byte);
    function Get_Month: Byte;
    procedure Set_Month(Value: Byte);
    function Get_Day: Byte;
    procedure Set_Day(Value: Byte);
    function Get_DayType: Byte;
    procedure Set_DayType(Value: Byte);
  public
    property DefaultInterface: ITSSServCont_ControllerTimetableSpecialDay read GetDefaultInterface;
  published
    property Year: Byte read Get_Year write Set_Year;
    property Month: Byte read Get_Month write Set_Month;
    property Day: Byte read Get_Day write Set_Day;
    property DayType: Byte read Get_DayType write Set_DayType;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_ControllerTimetableItemX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_ControllerTimetableItem exposed by              
// the CoClass TSSServCont_ControllerTimetableItemX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_ControllerTimetableItemX = class
    class function Create: ITSSServCont_ControllerTimetableItem;
    class function CreateRemote(const MachineName: string): ITSSServCont_ControllerTimetableItem;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_ControllerTimetableItemX
// Help String      : 
// Default Interface: ITSSServCont_ControllerTimetableItem
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_ControllerTimetableItemXProperties= class;
{$ENDIF}
  TTSSServCont_ControllerTimetableItemX = class(TOleServer)
  private
    FIntf:        ITSSServCont_ControllerTimetableItem;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_ControllerTimetableItemXProperties;
    function      GetServerProperties: TTSSServCont_ControllerTimetableItemXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_ControllerTimetableItem;
  protected
    procedure InitServerData; override;
    function Get_DayType: Byte;
    procedure Set_DayType(Value: Byte);
    function Get_StartHour: Byte;
    procedure Set_StartHour(Value: Byte);
    function Get_StartMinute: Byte;
    procedure Set_StartMinute(Value: Byte);
    function Get_FihishHour: Byte;
    procedure Set_FihishHour(Value: Byte);
    function Get_FihishMinute: Byte;
    procedure Set_FihishMinute(Value: Byte);
    function Get_PersCat: Byte;
    procedure Set_PersCat(Value: Byte);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_ControllerTimetableItem);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_ControllerTimetableItem read GetDefaultInterface;
    property DayType: Byte read Get_DayType write Set_DayType;
    property StartHour: Byte read Get_StartHour write Set_StartHour;
    property StartMinute: Byte read Get_StartMinute write Set_StartMinute;
    property FihishHour: Byte read Get_FihishHour write Set_FihishHour;
    property FihishMinute: Byte read Get_FihishMinute write Set_FihishMinute;
    property PersCat: Byte read Get_PersCat write Set_PersCat;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_ControllerTimetableItemXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_ControllerTimetableItemX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_ControllerTimetableItemXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_ControllerTimetableItemX;
    function    GetDefaultInterface: ITSSServCont_ControllerTimetableItem;
    constructor Create(AServer: TTSSServCont_ControllerTimetableItemX);
  protected
    function Get_DayType: Byte;
    procedure Set_DayType(Value: Byte);
    function Get_StartHour: Byte;
    procedure Set_StartHour(Value: Byte);
    function Get_StartMinute: Byte;
    procedure Set_StartMinute(Value: Byte);
    function Get_FihishHour: Byte;
    procedure Set_FihishHour(Value: Byte);
    function Get_FihishMinute: Byte;
    procedure Set_FihishMinute(Value: Byte);
    function Get_PersCat: Byte;
    procedure Set_PersCat(Value: Byte);
  public
    property DefaultInterface: ITSSServCont_ControllerTimetableItem read GetDefaultInterface;
  published
    property DayType: Byte read Get_DayType write Set_DayType;
    property StartHour: Byte read Get_StartHour write Set_StartHour;
    property StartMinute: Byte read Get_StartMinute write Set_StartMinute;
    property FihishHour: Byte read Get_FihishHour write Set_FihishHour;
    property FihishMinute: Byte read Get_FihishMinute write Set_FihishMinute;
    property PersCat: Byte read Get_PersCat write Set_PersCat;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_KeypadItemsX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_KeypadItems exposed by              
// the CoClass TSSServCont_KeypadItemsX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_KeypadItemsX = class
    class function Create: ITSSServCont_KeypadItems;
    class function CreateRemote(const MachineName: string): ITSSServCont_KeypadItems;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_KeypadItemsX
// Help String      : 
// Default Interface: ITSSServCont_KeypadItems
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_KeypadItemsXProperties= class;
{$ENDIF}
  TTSSServCont_KeypadItemsX = class(TOleServer)
  private
    FIntf:        ITSSServCont_KeypadItems;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_KeypadItemsXProperties;
    function      GetServerProperties: TTSSServCont_KeypadItemsXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_KeypadItems;
  protected
    procedure InitServerData; override;
    function Get_KeyCount(Index: Integer): Byte;
    procedure Set_KeyCount(Index: Integer; Value: Byte);
    function Get_Timeout(Index: Integer): Byte;
    procedure Set_Timeout(Index: Integer; Value: Byte);
    function Get_Count: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_KeypadItems);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_KeypadItems read GetDefaultInterface;
    property KeyCount[Index: Integer]: Byte read Get_KeyCount write Set_KeyCount;
    property Timeout[Index: Integer]: Byte read Get_Timeout write Set_Timeout;
    property Count: Integer read Get_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_KeypadItemsXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_KeypadItemsX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_KeypadItemsXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_KeypadItemsX;
    function    GetDefaultInterface: ITSSServCont_KeypadItems;
    constructor Create(AServer: TTSSServCont_KeypadItemsX);
  protected
    function Get_KeyCount(Index: Integer): Byte;
    procedure Set_KeyCount(Index: Integer; Value: Byte);
    function Get_Timeout(Index: Integer): Byte;
    procedure Set_Timeout(Index: Integer; Value: Byte);
    function Get_Count: Integer;
  public
    property DefaultInterface: ITSSServCont_KeypadItems read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_ServcontDateTimeX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_ServcontDateTime exposed by              
// the CoClass TSSServCont_ServcontDateTimeX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_ServcontDateTimeX = class
    class function Create: ITSSServCont_ServcontDateTime;
    class function CreateRemote(const MachineName: string): ITSSServCont_ServcontDateTime;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_ServcontDateTimeX
// Help String      : 
// Default Interface: ITSSServCont_ServcontDateTime
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_ServcontDateTimeXProperties= class;
{$ENDIF}
  TTSSServCont_ServcontDateTimeX = class(TOleServer)
  private
    FIntf:        ITSSServCont_ServcontDateTime;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_ServcontDateTimeXProperties;
    function      GetServerProperties: TTSSServCont_ServcontDateTimeXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_ServcontDateTime;
  protected
    procedure InitServerData; override;
    function Get_Year: Byte;
    function Get_Month: Byte;
    function Get_Day: Byte;
    function Get_Hour: Byte;
    function Get_Minute: Byte;
    function Get_Second: Byte;
    procedure Set_Year(Value: Byte);
    procedure Set_Month(Value: Byte);
    procedure Set_Day(Value: Byte);
    procedure Set_Hour(Value: Byte);
    procedure Set_Minute(Value: Byte);
    procedure Set_Second(Value: Byte);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_ServcontDateTime);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_ServcontDateTime read GetDefaultInterface;
    property Year: Byte read Get_Year write Set_Year;
    property Month: Byte read Get_Month write Set_Month;
    property Day: Byte read Get_Day write Set_Day;
    property Hour: Byte read Get_Hour write Set_Hour;
    property Minute: Byte read Get_Minute write Set_Minute;
    property Second: Byte read Get_Second write Set_Second;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_ServcontDateTimeXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_ServcontDateTimeX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_ServcontDateTimeXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_ServcontDateTimeX;
    function    GetDefaultInterface: ITSSServCont_ServcontDateTime;
    constructor Create(AServer: TTSSServCont_ServcontDateTimeX);
  protected
    function Get_Year: Byte;
    function Get_Month: Byte;
    function Get_Day: Byte;
    function Get_Hour: Byte;
    function Get_Minute: Byte;
    function Get_Second: Byte;
    procedure Set_Year(Value: Byte);
    procedure Set_Month(Value: Byte);
    procedure Set_Day(Value: Byte);
    procedure Set_Hour(Value: Byte);
    procedure Set_Minute(Value: Byte);
    procedure Set_Second(Value: Byte);
  public
    property DefaultInterface: ITSSServCont_ServcontDateTime read GetDefaultInterface;
  published
    property Year: Byte read Get_Year write Set_Year;
    property Month: Byte read Get_Month write Set_Month;
    property Day: Byte read Get_Day write Set_Day;
    property Hour: Byte read Get_Hour write Set_Hour;
    property Minute: Byte read Get_Minute write Set_Minute;
    property Second: Byte read Get_Second write Set_Second;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTSSServCont_KeyListX provides a Create and CreateRemote method to          
// create instances of the default interface ITSSServCont_KeyList exposed by              
// the CoClass TSSServCont_KeyListX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTSSServCont_KeyListX = class
    class function Create: ITSSServCont_KeyList;
    class function CreateRemote(const MachineName: string): ITSSServCont_KeyList;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTSSServCont_KeyListX
// Help String      : 
// Default Interface: ITSSServCont_KeyList
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTSSServCont_KeyListXProperties= class;
{$ENDIF}
  TTSSServCont_KeyListX = class(TOleServer)
  private
    FIntf:        ITSSServCont_KeyList;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTSSServCont_KeyListXProperties;
    function      GetServerProperties: TTSSServCont_KeyListXProperties;
{$ENDIF}
    function      GetDefaultInterface: ITSSServCont_KeyList;
  protected
    procedure InitServerData; override;
    function Get_Count: Integer;
    procedure Set_Count(Value: Integer);
    function Get_Items(Index: Integer): ITSSServCont_ControllerKey;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerKey);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITSSServCont_KeyList);
    procedure Disconnect; override;
    property DefaultInterface: ITSSServCont_KeyList read GetDefaultInterface;
    property Items[Index: Integer]: ITSSServCont_ControllerKey read Get_Items write Set_Items;
    property Count: Integer read Get_Count write Set_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTSSServCont_KeyListXProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTSSServCont_KeyListX
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTSSServCont_KeyListXProperties = class(TPersistent)
  private
    FServer:    TTSSServCont_KeyListX;
    function    GetDefaultInterface: ITSSServCont_KeyList;
    constructor Create(AServer: TTSSServCont_KeyListX);
  protected
    function Get_Count: Integer;
    procedure Set_Count(Value: Integer);
    function Get_Items(Index: Integer): ITSSServCont_ControllerKey;
    procedure Set_Items(Index: Integer; const Value: ITSSServCont_ControllerKey);
  public
    property DefaultInterface: ITSSServCont_KeyList read GetDefaultInterface;
  published
    property Count: Integer read Get_Count write Set_Count;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoTSSServContX.Create: ITSSServCont;
begin
  Result := CreateComObject(CLASS_TSSServContX) as ITSSServCont;
end;

class function CoTSSServContX.CreateRemote(const MachineName: string): ITSSServCont;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServContX) as ITSSServCont;
end;

procedure TTSSServContX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{EBB0D0A6-2779-4F08-9541-F33D5319FD8D}';
    IntfIID:   '{A8781959-05F0-48B7-A7C6-96AFC048FE33}';
    EventIID:  '{E9168480-8ABA-4016-9B21-A1C423C2E18A}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServContX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as ITSSServCont;
  end;
end;

procedure TTSSServContX.ConnectTo(svrIntf: ITSSServCont);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TTSSServContX.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TTSSServContX.GetDefaultInterface: ITSSServCont;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServContX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServContXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServContX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServContX.GetServerProperties: TTSSServContXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TTSSServContX.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    207: if Assigned(FOnCont220VEvent) then
         FOnCont220VEvent(Self,
                          Params[0] {const WideString},
                          IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerEvent {const ITSSServCont_ControllerEvent});
    208: if Assigned(FOnContCaseEvent) then
         FOnContCaseEvent(Self,
                          Params[0] {const WideString},
                          IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerEvent {const ITSSServCont_ControllerEvent});
    209: if Assigned(FOnContTimerEvent) then
         FOnContTimerEvent(Self,
                           Params[0] {const WideString},
                           IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerEvent {const ITSSServCont_ControllerEvent});
    210: if Assigned(FOnContStartEvent) then
         FOnContStartEvent(Self,
                           Params[0] {const WideString},
                           IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerEvent {const ITSSServCont_ControllerEvent});
    211: if Assigned(FOnContRestartEvent) then
         FOnContRestartEvent(Self,
                             Params[0] {const WideString},
                             IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerEvent {const ITSSServCont_ControllerEvent});
    212: if Assigned(FOnContAutoTimeoutEvent) then
         FOnContAutoTimeoutEvent(Self,
                                 Params[0] {const WideString},
                                 IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerEvent {const ITSSServCont_ControllerEvent});
    213: if Assigned(FOnContButtonEvent) then
         FOnContButtonEvent(Self,
                            Params[0] {const WideString},
                            IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerPortRelayEvent {const ITSSServCont_ControllerPortRelayEvent});
    214: if Assigned(FOnContDoorOpenEvent) then
         FOnContDoorOpenEvent(Self,
                              Params[0] {const WideString},
                              IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerPortRelayEvent {const ITSSServCont_ControllerPortRelayEvent});
    215: if Assigned(FOnContDoorCloseEvent) then
         FOnContDoorCloseEvent(Self,
                               Params[0] {const WideString},
                               IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerPortRelayEvent {const ITSSServCont_ControllerPortRelayEvent});
    216: if Assigned(FOnContKeyEvent) then
         FOnContKeyEvent(Self,
                         Params[0] {const WideString},
                         IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerKeyEvent {const ITSSServCont_ControllerKeyEvent});
    217: if Assigned(FOnContStaticSensorEvent) then
         FOnContStaticSensorEvent(Self,
                                  Params[0] {const WideString},
                                  IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ControllerStaticSensorEvent {const ITSSServCont_ControllerStaticSensorEvent});
    218: if Assigned(FOnContErrorEvent) then
         FOnContErrorEvent(Self,
                           Params[0] {const WideString},
                           IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime},
                           Params[2] {const WideString},
                           Params[3] {const WideString},
                           Params[4] {Integer});
    219: if Assigned(FOnContChannelErrorEvent) then
         FOnContChannelErrorEvent(Self,
                                  Params[0] {const WideString},
                                  IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime},
                                  Params[2] {const WideString},
                                  Params[3] {const WideString});
    220: if Assigned(FOnContChannelStateEvent) then
         FOnContChannelStateEvent(Self,
                                  Params[0] {const WideString},
                                  IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime},
                                  Params[2] {WordBool});
    221: if Assigned(FOnContChannelPollSpeedEvent) then
         FOnContChannelPollSpeedEvent(Self,
                                      Params[0] {const WideString},
                                      IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime},
                                      Params[2] {Integer});
    222: if Assigned(FOnContChangeStateEvent) then
         FOnContChangeStateEvent(Self,
                                 Params[0] {const WideString},
                                 Params[1] {Integer},
                                 IUnknown(TVarData(Params[2]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime},
                                 Params[3] {TTSSServCont_ControllerState});
    223: if Assigned(FOnClientsChangedEvent) then
         FOnClientsChangedEvent(Self, IUnknown(TVarData(Params[0]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime});
    224: if Assigned(FOnContChannelChangedEvent) then
         FOnContChannelChangedEvent(Self, IUnknown(TVarData(Params[0]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime});
    225: if Assigned(FOnContChangedEvent) then
         FOnContChangedEvent(Self,
                             Params[0] {const WideString},
                             IUnknown(TVarData(Params[1]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime});
    226: if Assigned(FOnReadyChangeEvent) then
         FOnReadyChangeEvent(Self);
    227: if Assigned(FOnQueueFullEvent) then
         FOnQueueFullEvent(Self, IUnknown(TVarData(Params[0]).VPointer) as ITSSServCont_ServcontDateTime {const ITSSServCont_ServcontDateTime});
  end; {case DispID}
end;

function TTSSServContX.Get_Active: WordBool;
begin
    Result := DefaultInterface.Active;
end;

procedure TTSSServContX.Set_Active(Value: WordBool);
begin
  DefaultInterface.Set_Active(Value);
end;

function TTSSServContX.Get_Ready: WordBool;
begin
    Result := DefaultInterface.Ready;
end;

function TTSSServContX.Get_Host: WideString;
begin
    Result := DefaultInterface.Host;
end;

procedure TTSSServContX.Set_Host(const Value: WideString);
  { Warning: The property Host has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Host := Value;
end;

function TTSSServContX.Get_Port: Integer;
begin
    Result := DefaultInterface.Port;
end;

procedure TTSSServContX.Set_Port(Value: Integer);
begin
  DefaultInterface.Set_Port(Value);
end;

function TTSSServContX.srvAddIPChannel(const Host: WideString; Port: Integer; 
                                       ResponseTimeout: Integer; AliveTimeout: Integer; 
                                       DeadTimeout: Integer): WideString;
begin
  Result := DefaultInterface.srvAddIPChannel(Host, Port, ResponseTimeout, AliveTimeout, DeadTimeout);
end;

function TTSSServContX.srvAddChannel(const Port: WideString; Speed: Integer; 
                                     ResponseTimeout: Integer; AliveTimeout: Integer; 
                                     DeadTimeout: Integer): WideString;
begin
  Result := DefaultInterface.srvAddChannel(Port, Speed, ResponseTimeout, AliveTimeout, DeadTimeout);
end;

function TTSSServContX.srvAddDvRs422Channel(Speed: Integer; ResponseTimeout: Integer; 
                                            AliveTimeout: Integer; DeadTimeout: Integer): WideString;
begin
  Result := DefaultInterface.srvAddDvRs422Channel(Speed, ResponseTimeout, AliveTimeout, DeadTimeout);
end;

procedure TTSSServContX.srvRemoveChannel(const ChannelId: WideString);
begin
  DefaultInterface.srvRemoveChannel(ChannelId);
end;

procedure TTSSServContX.srvActivateChannel(const ChannelId: WideString);
begin
  DefaultInterface.srvActivateChannel(ChannelId);
end;

procedure TTSSServContX.srvDeactivateChannel(const ChannelId: WideString);
begin
  DefaultInterface.srvDeactivateChannel(ChannelId);
end;

procedure TTSSServContX.srvAddController(ControllerAddr: Integer; const ChannelId: WideString);
begin
  DefaultInterface.srvAddController(ControllerAddr, ChannelId);
end;

procedure TTSSServContX.srvRemoveController(ControllerAddr: Integer; const ChannelId: WideString);
begin
  DefaultInterface.srvRemoveController(ControllerAddr, ChannelId);
end;

procedure TTSSServContX.srvChannelList(out Data: ITSSServCont_ChannelList);
begin
  DefaultInterface.srvChannelList(Data);
end;

procedure TTSSServContX.srvControllerList(const ChannelId: WideString; 
                                          out Data: ITSSServCont_ControllerList);
begin
  DefaultInterface.srvControllerList(ChannelId, Data);
end;

procedure TTSSServContX.srvClientList(out Data: ITSSServCont_ClientList);
begin
  DefaultInterface.srvClientList(Data);
end;

procedure TTSSServContX.srvSwitchToAuto;
begin
  DefaultInterface.srvSwitchToAuto;
end;

procedure TTSSServContX.srvMainClient(LogControllerEvents: WordBool; qLimit: Integer);
begin
  DefaultInterface.srvMainClient(LogControllerEvents, qLimit);
end;

procedure TTSSServContX.srvCoEvtLogSend(const BeginInterval: ITSSServCont_ServcontDateTime; 
                                        const EndInterval: ITSSServCont_ServcontDateTime; 
                                        Limit: Integer; Offset: Integer; out Count: Integer);
begin
  DefaultInterface.srvCoEvtLogSend(BeginInterval, EndInterval, Limit, Offset, Count);
end;

procedure TTSSServContX.srvCoEvtLogClear;
begin
  DefaultInterface.srvCoEvtLogClear;
end;

procedure TTSSServContX.srvSetHostClock(const Value: ITSSServCont_ServcontDateTime);
begin
  DefaultInterface.srvSetHostClock(Value);
end;

procedure TTSSServContX.cntRelayOn(const ChannelId: WideString; ControllerAddr: Integer; 
                                   Port: Integer; SuppressDoorEvent: WordBool; Interval: Integer);
begin
  DefaultInterface.cntRelayOn(ChannelId, ControllerAddr, Port, SuppressDoorEvent, Interval);
end;

procedure TTSSServContX.cntRelayOff(const ChannelId: WideString; ControllerAddr: Integer; 
                                    Port: Integer; SuppressDoorEvent: WordBool);
begin
  DefaultInterface.cntRelayOff(ChannelId, ControllerAddr, Port, SuppressDoorEvent);
end;

procedure TTSSServContX.cntPollOn(const ChannelId: WideString; ControllerAddr: Integer; 
                                  IsAuto: WordBool; IsReliable: WordBool);
begin
  DefaultInterface.cntPollOn(ChannelId, ControllerAddr, IsAuto, IsReliable);
end;

procedure TTSSServContX.cntPollOff(const ChannelId: WideString; ControllerAddr: Integer; 
                                   ForceAuto: WordBool);
begin
  DefaultInterface.cntPollOff(ChannelId, ControllerAddr, ForceAuto);
end;

procedure TTSSServContX.cntTimerOff(const ChannelId: WideString; ControllerAddr: Integer);
begin
  DefaultInterface.cntTimerOff(ChannelId, ControllerAddr);
end;

procedure TTSSServContX.cntTimerOn(const ChannelId: WideString; ControllerAddr: Integer; 
                                   Interval: Integer);
begin
  DefaultInterface.cntTimerOn(ChannelId, ControllerAddr, Interval);
end;

procedure TTSSServContX.cntWriteKey(const ChannelId: WideString; ControllerAddr: Integer; 
                                    const Key: ITSSServCont_ControllerKey);
begin
  DefaultInterface.cntWriteKey(ChannelId, ControllerAddr, Key);
end;

procedure TTSSServContX.cntEraseKey(const ChannelId: WideString; ControllerAddr: Integer; 
                                    const KeyValue: ITSSServCont_ControllerKeyValue);
begin
  DefaultInterface.cntEraseKey(ChannelId, ControllerAddr, KeyValue);
end;

procedure TTSSServContX.cntKeyExist(const ChannelId: WideString; ControllerAddr: Integer; 
                                    const KeyValue: ITSSServCont_ControllerKeyValue; 
                                    out IsExist: WordBool; 
                                    out KeyAttr: ITSSServCont_ControllerKeyAttr);
begin
  DefaultInterface.cntKeyExist(ChannelId, ControllerAddr, KeyValue, IsExist, KeyAttr);
end;

procedure TTSSServContX.cntEraseAllKeys(const ChannelId: WideString; ControllerAddr: Integer);
begin
  DefaultInterface.cntEraseAllKeys(ChannelId, ControllerAddr);
end;

procedure TTSSServContX.cntProgId(const ChannelId: WideString; ControllerAddr: Integer; 
                                  out Id: Integer);
begin
  DefaultInterface.cntProgId(ChannelId, ControllerAddr, Id);
end;

procedure TTSSServContX.cntProgVer(const ChannelId: WideString; ControllerAddr: Integer; 
                                   out Ver: WideString);
begin
  DefaultInterface.cntProgVer(ChannelId, ControllerAddr, Ver);
end;

procedure TTSSServContX.cntSerNum(const ChannelId: WideString; ControllerAddr: Integer; 
                                  out SerNum: Integer);
begin
  DefaultInterface.cntSerNum(ChannelId, ControllerAddr, SerNum);
end;

procedure TTSSServContX.cntReadClock(const ChannelId: WideString; ControllerAddr: Integer; 
                                     out Clock: ITSSServCont_ServcontDateTime);
begin
  DefaultInterface.cntReadClock(ChannelId, ControllerAddr, Clock);
end;

procedure TTSSServContX.cntWriteClockDate(const ChannelId: WideString; ControllerAddr: Integer; 
                                          Date: Double);
begin
  DefaultInterface.cntWriteClockDate(ChannelId, ControllerAddr, Date);
end;

procedure TTSSServContX.cntWriteClockTime(const ChannelId: WideString; ControllerAddr: Integer; 
                                          Time: Double);
begin
  DefaultInterface.cntWriteClockTime(ChannelId, ControllerAddr, Time);
end;

procedure TTSSServContX.cntReadAllKeys(const ChannelId: WideString; ControllerAddr: Integer; 
                                       out KeyList: ITSSServCont_KeyList);
begin
  DefaultInterface.cntReadAllKeys(ChannelId, ControllerAddr, KeyList);
end;

procedure TTSSServContX.cntReadTimetable(const ChannelId: WideString; ControllerAddr: Integer; 
                                         out SpecialDayList: ITSSServCont_TimetableSpecialDayList; 
                                         out TimetableItemList: ITSSServCont_TimetableItemList);
begin
  DefaultInterface.cntReadTimetable(ChannelId, ControllerAddr, SpecialDayList, TimetableItemList);
end;

procedure TTSSServContX.cntWriteTimetable(const ChannelId: WideString; ControllerAddr: Integer; 
                                          const SpecialDayList: ITSSServCont_TimetableSpecialDayList; 
                                          const TimetableItemList: ITSSServCont_TimetableItemList);
begin
  DefaultInterface.cntWriteTimetable(ChannelId, ControllerAddr, SpecialDayList, TimetableItemList);
end;

procedure TTSSServContX.cntTimetableErase(const ChannelId: WideString; ControllerAddr: Integer);
begin
  DefaultInterface.cntTimetableErase(ChannelId, ControllerAddr);
end;

procedure TTSSServContX.cntRestartProg(const ChannelId: WideString; ControllerAddr: Integer);
begin
  DefaultInterface.cntRestartProg(ChannelId, ControllerAddr);
end;

procedure TTSSServContX.cntEraseAllEvents(const ChannelId: WideString; ControllerAddr: Integer);
begin
  DefaultInterface.cntEraseAllEvents(ChannelId, ControllerAddr);
end;

procedure TTSSServContX.cntEventsInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                                      out Capacity: Integer; out Count: Integer);
begin
  DefaultInterface.cntEventsInfo(ChannelId, ControllerAddr, Capacity, Count);
end;

procedure TTSSServContX.cntKeysInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                                    out Capacity: Integer; out Count: Integer);
begin
  DefaultInterface.cntKeysInfo(ChannelId, ControllerAddr, Capacity, Count);
end;

procedure TTSSServContX.cntPortsInfo(const ChannelId: WideString; ControllerAddr: Integer; 
                                     out Ports: ITSSServCont_ControllerPorts);
begin
  DefaultInterface.cntPortsInfo(ChannelId, ControllerAddr, Ports);
end;

procedure TTSSServContX.cntGenerateTimerEvents(const ChannelId: WideString; 
                                               ControllerAddr: Integer; Count: Integer);
begin
  DefaultInterface.cntGenerateTimerEvents(ChannelId, ControllerAddr, Count);
end;

procedure TTSSServContX.cntReadKeypad(const ChannelId: WideString; ControllerAddr: Integer; 
                                      out KeypadItems: ITSSServCont_KeypadItems);
begin
  DefaultInterface.cntReadKeypad(ChannelId, ControllerAddr, KeypadItems);
end;

procedure TTSSServContX.cntWriteKeypad(const ChannelId: WideString; ControllerAddr: Integer; 
                                       const KeypadItems: ITSSServCont_KeypadItems);
begin
  DefaultInterface.cntWriteKeypad(ChannelId, ControllerAddr, KeypadItems);
end;

procedure TTSSServContX.cntGenerateKeyBase(const ChannelId: WideString; ControllerAddr: Integer);
begin
  DefaultInterface.cntGenerateKeyBase(ChannelId, ControllerAddr);
end;

procedure TTSSServContX.cntWriteAllKey(const ChannelId: WideString; ControllerAddr: Integer; 
                                       const KeyList: ITSSServCont_KeyList);
begin
  DefaultInterface.cntWriteAllKey(ChannelId, ControllerAddr, KeyList);
end;

procedure TTSSServContX.cntReadAllChips(const ChannelId: WideString; ControllerAddr: Integer; 
                                        out Ports: ITSSServCont_ControllerPorts; 
                                        out ChipsList: ITSSServCont_ControllerChipList);
begin
  DefaultInterface.cntReadAllChips(ChannelId, ControllerAddr, Ports, ChipsList);
end;

procedure TTSSServContX.cntWriteAllChips(const ChannelId: WideString; ControllerAddr: Integer; 
                                         const Ports: ITSSServCont_ControllerPorts; 
                                         const ChipsList: ITSSServCont_ControllerChipList);
begin
  DefaultInterface.cntWriteAllChips(ChannelId, ControllerAddr, Ports, ChipsList);
end;

procedure TTSSServContX.cntActivateChip(const ChannelId: WideString; ControllerAddr: Integer; 
                                        const Chip: ITSSServCont_ControllerKeyValue);
begin
  DefaultInterface.cntActivateChip(ChannelId, ControllerAddr, Chip);
end;

procedure TTSSServContX.cntDeactivateChip(const ChannelId: WideString; ControllerAddr: Integer; 
                                          const Chip: ITSSServCont_ControllerKeyValue);
begin
  DefaultInterface.cntDeactivateChip(ChannelId, ControllerAddr, Chip);
end;

procedure TTSSServContX.cntEraseAllChips(const ChannelId: WideString; ControllerAddr: Integer);
begin
  DefaultInterface.cntEraseAllChips(ChannelId, ControllerAddr);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServContXProperties.Create(AServer: TTSSServContX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServContXProperties.GetDefaultInterface: ITSSServCont;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServContXProperties.Get_Active: WordBool;
begin
    Result := DefaultInterface.Active;
end;

procedure TTSSServContXProperties.Set_Active(Value: WordBool);
begin
  DefaultInterface.Set_Active(Value);
end;

function TTSSServContXProperties.Get_Ready: WordBool;
begin
    Result := DefaultInterface.Ready;
end;

function TTSSServContXProperties.Get_Host: WideString;
begin
    Result := DefaultInterface.Host;
end;

procedure TTSSServContXProperties.Set_Host(const Value: WideString);
  { Warning: The property Host has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Host := Value;
end;

function TTSSServContXProperties.Get_Port: Integer;
begin
    Result := DefaultInterface.Port;
end;

procedure TTSSServContXProperties.Set_Port(Value: Integer);
begin
  DefaultInterface.Set_Port(Value);
end;

{$ENDIF}

class function CoTSSServCont_TimetableSpecialDayListX.Create: ITSSServCont_TimetableSpecialDayList;
begin
  Result := CreateComObject(CLASS_TSSServCont_TimetableSpecialDayListX) as ITSSServCont_TimetableSpecialDayList;
end;

class function CoTSSServCont_TimetableSpecialDayListX.CreateRemote(const MachineName: string): ITSSServCont_TimetableSpecialDayList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_TimetableSpecialDayListX) as ITSSServCont_TimetableSpecialDayList;
end;

procedure TTSSServCont_TimetableSpecialDayListX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{E1E14735-9BDC-4E3D-ABF8-32BC767FA63C}';
    IntfIID:   '{DFA6FC73-A3D3-4275-8A1A-917B6EDCC629}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_TimetableSpecialDayListX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_TimetableSpecialDayList;
  end;
end;

procedure TTSSServCont_TimetableSpecialDayListX.ConnectTo(svrIntf: ITSSServCont_TimetableSpecialDayList);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_TimetableSpecialDayListX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_TimetableSpecialDayListX.GetDefaultInterface: ITSSServCont_TimetableSpecialDayList;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_TimetableSpecialDayListX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_TimetableSpecialDayListXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_TimetableSpecialDayListX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_TimetableSpecialDayListX.GetServerProperties: TTSSServCont_TimetableSpecialDayListXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_TimetableSpecialDayListX.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

procedure TTSSServCont_TimetableSpecialDayListX.Set_Count(Value: Integer);
begin
  DefaultInterface.Set_Count(Value);
end;

function TTSSServCont_TimetableSpecialDayListX.Get_Items(Index: Integer): ITSSServCont_ControllerTimetableSpecialDay;
begin
    Result := DefaultInterface.Items[Index];
end;

procedure TTSSServCont_TimetableSpecialDayListX.Set_Items(Index: Integer; 
                                                          const Value: ITSSServCont_ControllerTimetableSpecialDay);
begin
  DefaultInterface.Items[Index] := Value;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_TimetableSpecialDayListXProperties.Create(AServer: TTSSServCont_TimetableSpecialDayListX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_TimetableSpecialDayListXProperties.GetDefaultInterface: ITSSServCont_TimetableSpecialDayList;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_TimetableSpecialDayListXProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

procedure TTSSServCont_TimetableSpecialDayListXProperties.Set_Count(Value: Integer);
begin
  DefaultInterface.Set_Count(Value);
end;

function TTSSServCont_TimetableSpecialDayListXProperties.Get_Items(Index: Integer): ITSSServCont_ControllerTimetableSpecialDay;
begin
    Result := DefaultInterface.Items[Index];
end;

procedure TTSSServCont_TimetableSpecialDayListXProperties.Set_Items(Index: Integer; 
                                                                    const Value: ITSSServCont_ControllerTimetableSpecialDay);
begin
  DefaultInterface.Items[Index] := Value;
end;

{$ENDIF}

class function CoTSSServCont_TimetableItemListX.Create: ITSSServCont_TimetableItemList;
begin
  Result := CreateComObject(CLASS_TSSServCont_TimetableItemListX) as ITSSServCont_TimetableItemList;
end;

class function CoTSSServCont_TimetableItemListX.CreateRemote(const MachineName: string): ITSSServCont_TimetableItemList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_TimetableItemListX) as ITSSServCont_TimetableItemList;
end;

procedure TTSSServCont_TimetableItemListX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B73C3BC3-494D-44C0-9C89-8DF36924D168}';
    IntfIID:   '{FB63CC4D-4B7E-49B2-90DC-9F060A8B1CDC}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_TimetableItemListX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_TimetableItemList;
  end;
end;

procedure TTSSServCont_TimetableItemListX.ConnectTo(svrIntf: ITSSServCont_TimetableItemList);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_TimetableItemListX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_TimetableItemListX.GetDefaultInterface: ITSSServCont_TimetableItemList;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_TimetableItemListX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_TimetableItemListXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_TimetableItemListX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_TimetableItemListX.GetServerProperties: TTSSServCont_TimetableItemListXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_TimetableItemListX.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

procedure TTSSServCont_TimetableItemListX.Set_Count(Value: Integer);
begin
  DefaultInterface.Set_Count(Value);
end;

function TTSSServCont_TimetableItemListX.Get_Items(Index: Integer): ITSSServCont_ControllerTimetableItem;
begin
    Result := DefaultInterface.Items[Index];
end;

procedure TTSSServCont_TimetableItemListX.Set_Items(Index: Integer; 
                                                    const Value: ITSSServCont_ControllerTimetableItem);
begin
  DefaultInterface.Items[Index] := Value;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_TimetableItemListXProperties.Create(AServer: TTSSServCont_TimetableItemListX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_TimetableItemListXProperties.GetDefaultInterface: ITSSServCont_TimetableItemList;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_TimetableItemListXProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

procedure TTSSServCont_TimetableItemListXProperties.Set_Count(Value: Integer);
begin
  DefaultInterface.Set_Count(Value);
end;

function TTSSServCont_TimetableItemListXProperties.Get_Items(Index: Integer): ITSSServCont_ControllerTimetableItem;
begin
    Result := DefaultInterface.Items[Index];
end;

procedure TTSSServCont_TimetableItemListXProperties.Set_Items(Index: Integer; 
                                                              const Value: ITSSServCont_ControllerTimetableItem);
begin
  DefaultInterface.Items[Index] := Value;
end;

{$ENDIF}

class function CoTSSServCont_ControllerChipListX.Create: ITSSServCont_ControllerChipList;
begin
  Result := CreateComObject(CLASS_TSSServCont_ControllerChipListX) as ITSSServCont_ControllerChipList;
end;

class function CoTSSServCont_ControllerChipListX.CreateRemote(const MachineName: string): ITSSServCont_ControllerChipList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_ControllerChipListX) as ITSSServCont_ControllerChipList;
end;

procedure TTSSServCont_ControllerChipListX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5DBEE5CF-6625-47AA-93DB-86414D6B6CD4}';
    IntfIID:   '{E0933D72-57E7-44A5-A052-48BC7DD3A745}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_ControllerChipListX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_ControllerChipList;
  end;
end;

procedure TTSSServCont_ControllerChipListX.ConnectTo(svrIntf: ITSSServCont_ControllerChipList);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_ControllerChipListX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_ControllerChipListX.GetDefaultInterface: ITSSServCont_ControllerChipList;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_ControllerChipListX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_ControllerChipListXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_ControllerChipListX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_ControllerChipListX.GetServerProperties: TTSSServCont_ControllerChipListXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_ControllerChipListX.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

procedure TTSSServCont_ControllerChipListX.Set_Count(Value: Integer);
begin
  DefaultInterface.Set_Count(Value);
end;

function TTSSServCont_ControllerChipListX.Get_Items(Index: Integer): ITSSServCont_ControllerChip;
begin
    Result := DefaultInterface.Items[Index];
end;

procedure TTSSServCont_ControllerChipListX.Set_Items(Index: Integer; 
                                                     const Value: ITSSServCont_ControllerChip);
begin
  DefaultInterface.Items[Index] := Value;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_ControllerChipListXProperties.Create(AServer: TTSSServCont_ControllerChipListX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_ControllerChipListXProperties.GetDefaultInterface: ITSSServCont_ControllerChipList;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_ControllerChipListXProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

procedure TTSSServCont_ControllerChipListXProperties.Set_Count(Value: Integer);
begin
  DefaultInterface.Set_Count(Value);
end;

function TTSSServCont_ControllerChipListXProperties.Get_Items(Index: Integer): ITSSServCont_ControllerChip;
begin
    Result := DefaultInterface.Items[Index];
end;

procedure TTSSServCont_ControllerChipListXProperties.Set_Items(Index: Integer; 
                                                               const Value: ITSSServCont_ControllerChip);
begin
  DefaultInterface.Items[Index] := Value;
end;

{$ENDIF}

class function CoTSSServCont_ControllerKeyValueX.Create: ITSSServCont_ControllerKeyValue;
begin
  Result := CreateComObject(CLASS_TSSServCont_ControllerKeyValueX) as ITSSServCont_ControllerKeyValue;
end;

class function CoTSSServCont_ControllerKeyValueX.CreateRemote(const MachineName: string): ITSSServCont_ControllerKeyValue;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_ControllerKeyValueX) as ITSSServCont_ControllerKeyValue;
end;

procedure TTSSServCont_ControllerKeyValueX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6EA0CF2B-F13C-4D69-87FC-9D2A5570D030}';
    IntfIID:   '{C71A1305-72F1-4DD8-A53E-CFBDBA3A1818}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_ControllerKeyValueX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_ControllerKeyValue;
  end;
end;

procedure TTSSServCont_ControllerKeyValueX.ConnectTo(svrIntf: ITSSServCont_ControllerKeyValue);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_ControllerKeyValueX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_ControllerKeyValueX.GetDefaultInterface: ITSSServCont_ControllerKeyValue;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_ControllerKeyValueX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_ControllerKeyValueXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_ControllerKeyValueX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_ControllerKeyValueX.GetServerProperties: TTSSServCont_ControllerKeyValueXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_ControllerKeyValueX.Get_B(Index: Integer): Byte;
begin
    Result := DefaultInterface.B[Index];
end;

procedure TTSSServCont_ControllerKeyValueX.Set_B(Index: Integer; Value: Byte);
begin
  DefaultInterface.B[Index] := Value;
end;

function TTSSServCont_ControllerKeyValueX.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_ControllerKeyValueXProperties.Create(AServer: TTSSServCont_ControllerKeyValueX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_ControllerKeyValueXProperties.GetDefaultInterface: ITSSServCont_ControllerKeyValue;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_ControllerKeyValueXProperties.Get_B(Index: Integer): Byte;
begin
    Result := DefaultInterface.B[Index];
end;

procedure TTSSServCont_ControllerKeyValueXProperties.Set_B(Index: Integer; Value: Byte);
begin
  DefaultInterface.B[Index] := Value;
end;

function TTSSServCont_ControllerKeyValueXProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

{$ENDIF}

class function CoTSSServCont_ControllerPortsX.Create: ITSSServCont_ControllerPorts;
begin
  Result := CreateComObject(CLASS_TSSServCont_ControllerPortsX) as ITSSServCont_ControllerPorts;
end;

class function CoTSSServCont_ControllerPortsX.CreateRemote(const MachineName: string): ITSSServCont_ControllerPorts;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_ControllerPortsX) as ITSSServCont_ControllerPorts;
end;

procedure TTSSServCont_ControllerPortsX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6AA7FE9B-C697-44BF-9BFB-197E87650D47}';
    IntfIID:   '{FC10B468-94DA-4427-8D8E-547E13FEE55A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_ControllerPortsX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_ControllerPorts;
  end;
end;

procedure TTSSServCont_ControllerPortsX.ConnectTo(svrIntf: ITSSServCont_ControllerPorts);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_ControllerPortsX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_ControllerPortsX.GetDefaultInterface: ITSSServCont_ControllerPorts;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_ControllerPortsX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_ControllerPortsXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_ControllerPortsX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_ControllerPortsX.GetServerProperties: TTSSServCont_ControllerPortsXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_ControllerPortsX.Get_P(Index: Integer): WordBool;
begin
    Result := DefaultInterface.P[Index];
end;

procedure TTSSServCont_ControllerPortsX.Set_P(Index: Integer; Value: WordBool);
begin
  DefaultInterface.P[Index] := Value;
end;

function TTSSServCont_ControllerPortsX.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_ControllerPortsXProperties.Create(AServer: TTSSServCont_ControllerPortsX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_ControllerPortsXProperties.GetDefaultInterface: ITSSServCont_ControllerPorts;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_ControllerPortsXProperties.Get_P(Index: Integer): WordBool;
begin
    Result := DefaultInterface.P[Index];
end;

procedure TTSSServCont_ControllerPortsXProperties.Set_P(Index: Integer; Value: WordBool);
begin
  DefaultInterface.P[Index] := Value;
end;

function TTSSServCont_ControllerPortsXProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

{$ENDIF}

class function CoTSSServCont_ControllerKeyX.Create: ITSSServCont_ControllerKey;
begin
  Result := CreateComObject(CLASS_TSSServCont_ControllerKeyX) as ITSSServCont_ControllerKey;
end;

class function CoTSSServCont_ControllerKeyX.CreateRemote(const MachineName: string): ITSSServCont_ControllerKey;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_ControllerKeyX) as ITSSServCont_ControllerKey;
end;

procedure TTSSServCont_ControllerKeyX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{114D3040-05FD-4BE8-BE1D-4655653DB408}';
    IntfIID:   '{109BC80F-15F4-41E2-B816-7212F16FE8D0}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_ControllerKeyX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_ControllerKey;
  end;
end;

procedure TTSSServCont_ControllerKeyX.ConnectTo(svrIntf: ITSSServCont_ControllerKey);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_ControllerKeyX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_ControllerKeyX.GetDefaultInterface: ITSSServCont_ControllerKey;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_ControllerKeyX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_ControllerKeyXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_ControllerKeyX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_ControllerKeyX.GetServerProperties: TTSSServCont_ControllerKeyXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_ControllerKeyX.Get_Value: ITSSServCont_ControllerKeyValue;
begin
    Result := DefaultInterface.Value;
end;

procedure TTSSServCont_ControllerKeyX.Set_Value(const Value: ITSSServCont_ControllerKeyValue);
begin
  DefaultInterface.Set_Value(Value);
end;

function TTSSServCont_ControllerKeyX.Get_Ports: ITSSServCont_ControllerPorts;
begin
    Result := DefaultInterface.Ports;
end;

procedure TTSSServCont_ControllerKeyX.Set_Ports(const Value: ITSSServCont_ControllerPorts);
begin
  DefaultInterface.Set_Ports(Value);
end;

function TTSSServCont_ControllerKeyX.Get_PersCat: Byte;
begin
    Result := DefaultInterface.PersCat;
end;

procedure TTSSServCont_ControllerKeyX.Set_PersCat(Value: Byte);
begin
  DefaultInterface.Set_PersCat(Value);
end;

function TTSSServCont_ControllerKeyX.Get_SuppressDoorEvent: WordBool;
begin
    Result := DefaultInterface.SuppressDoorEvent;
end;

procedure TTSSServCont_ControllerKeyX.Set_SuppressDoorEvent(Value: WordBool);
begin
  DefaultInterface.Set_SuppressDoorEvent(Value);
end;

function TTSSServCont_ControllerKeyX.Get_OpenEvenComplex: WordBool;
begin
    Result := DefaultInterface.OpenEvenComplex;
end;

procedure TTSSServCont_ControllerKeyX.Set_OpenEvenComplex(Value: WordBool);
begin
  DefaultInterface.Set_OpenEvenComplex(Value);
end;

function TTSSServCont_ControllerKeyX.Get_IsSilent: WordBool;
begin
    Result := DefaultInterface.IsSilent;
end;

procedure TTSSServCont_ControllerKeyX.Set_IsSilent(Value: WordBool);
begin
  DefaultInterface.Set_IsSilent(Value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_ControllerKeyXProperties.Create(AServer: TTSSServCont_ControllerKeyX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_ControllerKeyXProperties.GetDefaultInterface: ITSSServCont_ControllerKey;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_ControllerKeyXProperties.Get_Value: ITSSServCont_ControllerKeyValue;
begin
    Result := DefaultInterface.Value;
end;

procedure TTSSServCont_ControllerKeyXProperties.Set_Value(const Value: ITSSServCont_ControllerKeyValue);
begin
  DefaultInterface.Set_Value(Value);
end;

function TTSSServCont_ControllerKeyXProperties.Get_Ports: ITSSServCont_ControllerPorts;
begin
    Result := DefaultInterface.Ports;
end;

procedure TTSSServCont_ControllerKeyXProperties.Set_Ports(const Value: ITSSServCont_ControllerPorts);
begin
  DefaultInterface.Set_Ports(Value);
end;

function TTSSServCont_ControllerKeyXProperties.Get_PersCat: Byte;
begin
    Result := DefaultInterface.PersCat;
end;

procedure TTSSServCont_ControllerKeyXProperties.Set_PersCat(Value: Byte);
begin
  DefaultInterface.Set_PersCat(Value);
end;

function TTSSServCont_ControllerKeyXProperties.Get_SuppressDoorEvent: WordBool;
begin
    Result := DefaultInterface.SuppressDoorEvent;
end;

procedure TTSSServCont_ControllerKeyXProperties.Set_SuppressDoorEvent(Value: WordBool);
begin
  DefaultInterface.Set_SuppressDoorEvent(Value);
end;

function TTSSServCont_ControllerKeyXProperties.Get_OpenEvenComplex: WordBool;
begin
    Result := DefaultInterface.OpenEvenComplex;
end;

procedure TTSSServCont_ControllerKeyXProperties.Set_OpenEvenComplex(Value: WordBool);
begin
  DefaultInterface.Set_OpenEvenComplex(Value);
end;

function TTSSServCont_ControllerKeyXProperties.Get_IsSilent: WordBool;
begin
    Result := DefaultInterface.IsSilent;
end;

procedure TTSSServCont_ControllerKeyXProperties.Set_IsSilent(Value: WordBool);
begin
  DefaultInterface.Set_IsSilent(Value);
end;

{$ENDIF}

class function CoTSSServCont_ControllerChipX.Create: ITSSServCont_ControllerChip;
begin
  Result := CreateComObject(CLASS_TSSServCont_ControllerChipX) as ITSSServCont_ControllerChip;
end;

class function CoTSSServCont_ControllerChipX.CreateRemote(const MachineName: string): ITSSServCont_ControllerChip;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_ControllerChipX) as ITSSServCont_ControllerChip;
end;

procedure TTSSServCont_ControllerChipX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{23186999-1D20-49D9-8BEA-1490CFF4D8AE}';
    IntfIID:   '{B9D99E34-35F6-475E-8BB1-23D2724D52DF}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_ControllerChipX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_ControllerChip;
  end;
end;

procedure TTSSServCont_ControllerChipX.ConnectTo(svrIntf: ITSSServCont_ControllerChip);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_ControllerChipX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_ControllerChipX.GetDefaultInterface: ITSSServCont_ControllerChip;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_ControllerChipX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_ControllerChipXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_ControllerChipX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_ControllerChipX.GetServerProperties: TTSSServCont_ControllerChipXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_ControllerChipX.Get_Value: ITSSServCont_ControllerKeyValue;
begin
    Result := DefaultInterface.Value;
end;

procedure TTSSServCont_ControllerChipX.Set_Value(const Value: ITSSServCont_ControllerKeyValue);
begin
  DefaultInterface.Set_Value(Value);
end;

function TTSSServCont_ControllerChipX.Get_Active: WordBool;
begin
    Result := DefaultInterface.Active;
end;

procedure TTSSServCont_ControllerChipX.Set_Active(Value: WordBool);
begin
  DefaultInterface.Set_Active(Value);
end;

function TTSSServCont_ControllerChipX.Get_OpenEvenComplex: WordBool;
begin
    Result := DefaultInterface.OpenEvenComplex;
end;

procedure TTSSServCont_ControllerChipX.Set_OpenEvenComplex(Value: WordBool);
begin
  DefaultInterface.Set_OpenEvenComplex(Value);
end;

function TTSSServCont_ControllerChipX.Get_CheckCount: Byte;
begin
    Result := DefaultInterface.CheckCount;
end;

procedure TTSSServCont_ControllerChipX.Set_CheckCount(Value: Byte);
begin
  DefaultInterface.Set_CheckCount(Value);
end;

function TTSSServCont_ControllerChipX.Get_Port: Byte;
begin
    Result := DefaultInterface.Port;
end;

procedure TTSSServCont_ControllerChipX.Set_Port(Value: Byte);
begin
  DefaultInterface.Set_Port(Value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_ControllerChipXProperties.Create(AServer: TTSSServCont_ControllerChipX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_ControllerChipXProperties.GetDefaultInterface: ITSSServCont_ControllerChip;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_ControllerChipXProperties.Get_Value: ITSSServCont_ControllerKeyValue;
begin
    Result := DefaultInterface.Value;
end;

procedure TTSSServCont_ControllerChipXProperties.Set_Value(const Value: ITSSServCont_ControllerKeyValue);
begin
  DefaultInterface.Set_Value(Value);
end;

function TTSSServCont_ControllerChipXProperties.Get_Active: WordBool;
begin
    Result := DefaultInterface.Active;
end;

procedure TTSSServCont_ControllerChipXProperties.Set_Active(Value: WordBool);
begin
  DefaultInterface.Set_Active(Value);
end;

function TTSSServCont_ControllerChipXProperties.Get_OpenEvenComplex: WordBool;
begin
    Result := DefaultInterface.OpenEvenComplex;
end;

procedure TTSSServCont_ControllerChipXProperties.Set_OpenEvenComplex(Value: WordBool);
begin
  DefaultInterface.Set_OpenEvenComplex(Value);
end;

function TTSSServCont_ControllerChipXProperties.Get_CheckCount: Byte;
begin
    Result := DefaultInterface.CheckCount;
end;

procedure TTSSServCont_ControllerChipXProperties.Set_CheckCount(Value: Byte);
begin
  DefaultInterface.Set_CheckCount(Value);
end;

function TTSSServCont_ControllerChipXProperties.Get_Port: Byte;
begin
    Result := DefaultInterface.Port;
end;

procedure TTSSServCont_ControllerChipXProperties.Set_Port(Value: Byte);
begin
  DefaultInterface.Set_Port(Value);
end;

{$ENDIF}

class function CoTSSServCont_ControllerTimetableSpecialDayX.Create: ITSSServCont_ControllerTimetableSpecialDay;
begin
  Result := CreateComObject(CLASS_TSSServCont_ControllerTimetableSpecialDayX) as ITSSServCont_ControllerTimetableSpecialDay;
end;

class function CoTSSServCont_ControllerTimetableSpecialDayX.CreateRemote(const MachineName: string): ITSSServCont_ControllerTimetableSpecialDay;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_ControllerTimetableSpecialDayX) as ITSSServCont_ControllerTimetableSpecialDay;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D7C0B911-272B-4C75-914B-3A88CCD0E14A}';
    IntfIID:   '{5A4099DA-3E9D-42AE-A605-C6A73346AFDB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_ControllerTimetableSpecialDay;
  end;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayX.ConnectTo(svrIntf: ITSSServCont_ControllerTimetableSpecialDay);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_ControllerTimetableSpecialDayX.GetDefaultInterface: ITSSServCont_ControllerTimetableSpecialDay;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_ControllerTimetableSpecialDayX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_ControllerTimetableSpecialDayXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_ControllerTimetableSpecialDayX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_ControllerTimetableSpecialDayX.GetServerProperties: TTSSServCont_ControllerTimetableSpecialDayXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_ControllerTimetableSpecialDayX.Get_Year: Byte;
begin
    Result := DefaultInterface.Year;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayX.Set_Year(Value: Byte);
begin
  DefaultInterface.Set_Year(Value);
end;

function TTSSServCont_ControllerTimetableSpecialDayX.Get_Month: Byte;
begin
    Result := DefaultInterface.Month;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayX.Set_Month(Value: Byte);
begin
  DefaultInterface.Set_Month(Value);
end;

function TTSSServCont_ControllerTimetableSpecialDayX.Get_Day: Byte;
begin
    Result := DefaultInterface.Day;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayX.Set_Day(Value: Byte);
begin
  DefaultInterface.Set_Day(Value);
end;

function TTSSServCont_ControllerTimetableSpecialDayX.Get_DayType: Byte;
begin
    Result := DefaultInterface.DayType;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayX.Set_DayType(Value: Byte);
begin
  DefaultInterface.Set_DayType(Value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_ControllerTimetableSpecialDayXProperties.Create(AServer: TTSSServCont_ControllerTimetableSpecialDayX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_ControllerTimetableSpecialDayXProperties.GetDefaultInterface: ITSSServCont_ControllerTimetableSpecialDay;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_ControllerTimetableSpecialDayXProperties.Get_Year: Byte;
begin
    Result := DefaultInterface.Year;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayXProperties.Set_Year(Value: Byte);
begin
  DefaultInterface.Set_Year(Value);
end;

function TTSSServCont_ControllerTimetableSpecialDayXProperties.Get_Month: Byte;
begin
    Result := DefaultInterface.Month;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayXProperties.Set_Month(Value: Byte);
begin
  DefaultInterface.Set_Month(Value);
end;

function TTSSServCont_ControllerTimetableSpecialDayXProperties.Get_Day: Byte;
begin
    Result := DefaultInterface.Day;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayXProperties.Set_Day(Value: Byte);
begin
  DefaultInterface.Set_Day(Value);
end;

function TTSSServCont_ControllerTimetableSpecialDayXProperties.Get_DayType: Byte;
begin
    Result := DefaultInterface.DayType;
end;

procedure TTSSServCont_ControllerTimetableSpecialDayXProperties.Set_DayType(Value: Byte);
begin
  DefaultInterface.Set_DayType(Value);
end;

{$ENDIF}

class function CoTSSServCont_ControllerTimetableItemX.Create: ITSSServCont_ControllerTimetableItem;
begin
  Result := CreateComObject(CLASS_TSSServCont_ControllerTimetableItemX) as ITSSServCont_ControllerTimetableItem;
end;

class function CoTSSServCont_ControllerTimetableItemX.CreateRemote(const MachineName: string): ITSSServCont_ControllerTimetableItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_ControllerTimetableItemX) as ITSSServCont_ControllerTimetableItem;
end;

procedure TTSSServCont_ControllerTimetableItemX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{29745400-E9D6-40E0-B5C7-87D43A7AB3CF}';
    IntfIID:   '{E32C040A-8100-4394-8CFE-C94331EB35EB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_ControllerTimetableItemX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_ControllerTimetableItem;
  end;
end;

procedure TTSSServCont_ControllerTimetableItemX.ConnectTo(svrIntf: ITSSServCont_ControllerTimetableItem);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_ControllerTimetableItemX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_ControllerTimetableItemX.GetDefaultInterface: ITSSServCont_ControllerTimetableItem;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_ControllerTimetableItemX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_ControllerTimetableItemXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_ControllerTimetableItemX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_ControllerTimetableItemX.GetServerProperties: TTSSServCont_ControllerTimetableItemXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_ControllerTimetableItemX.Get_DayType: Byte;
begin
    Result := DefaultInterface.DayType;
end;

procedure TTSSServCont_ControllerTimetableItemX.Set_DayType(Value: Byte);
begin
  DefaultInterface.Set_DayType(Value);
end;

function TTSSServCont_ControllerTimetableItemX.Get_StartHour: Byte;
begin
    Result := DefaultInterface.StartHour;
end;

procedure TTSSServCont_ControllerTimetableItemX.Set_StartHour(Value: Byte);
begin
  DefaultInterface.Set_StartHour(Value);
end;

function TTSSServCont_ControllerTimetableItemX.Get_StartMinute: Byte;
begin
    Result := DefaultInterface.StartMinute;
end;

procedure TTSSServCont_ControllerTimetableItemX.Set_StartMinute(Value: Byte);
begin
  DefaultInterface.Set_StartMinute(Value);
end;

function TTSSServCont_ControllerTimetableItemX.Get_FihishHour: Byte;
begin
    Result := DefaultInterface.FihishHour;
end;

procedure TTSSServCont_ControllerTimetableItemX.Set_FihishHour(Value: Byte);
begin
  DefaultInterface.Set_FihishHour(Value);
end;

function TTSSServCont_ControllerTimetableItemX.Get_FihishMinute: Byte;
begin
    Result := DefaultInterface.FihishMinute;
end;

procedure TTSSServCont_ControllerTimetableItemX.Set_FihishMinute(Value: Byte);
begin
  DefaultInterface.Set_FihishMinute(Value);
end;

function TTSSServCont_ControllerTimetableItemX.Get_PersCat: Byte;
begin
    Result := DefaultInterface.PersCat;
end;

procedure TTSSServCont_ControllerTimetableItemX.Set_PersCat(Value: Byte);
begin
  DefaultInterface.Set_PersCat(Value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_ControllerTimetableItemXProperties.Create(AServer: TTSSServCont_ControllerTimetableItemX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_ControllerTimetableItemXProperties.GetDefaultInterface: ITSSServCont_ControllerTimetableItem;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_ControllerTimetableItemXProperties.Get_DayType: Byte;
begin
    Result := DefaultInterface.DayType;
end;

procedure TTSSServCont_ControllerTimetableItemXProperties.Set_DayType(Value: Byte);
begin
  DefaultInterface.Set_DayType(Value);
end;

function TTSSServCont_ControllerTimetableItemXProperties.Get_StartHour: Byte;
begin
    Result := DefaultInterface.StartHour;
end;

procedure TTSSServCont_ControllerTimetableItemXProperties.Set_StartHour(Value: Byte);
begin
  DefaultInterface.Set_StartHour(Value);
end;

function TTSSServCont_ControllerTimetableItemXProperties.Get_StartMinute: Byte;
begin
    Result := DefaultInterface.StartMinute;
end;

procedure TTSSServCont_ControllerTimetableItemXProperties.Set_StartMinute(Value: Byte);
begin
  DefaultInterface.Set_StartMinute(Value);
end;

function TTSSServCont_ControllerTimetableItemXProperties.Get_FihishHour: Byte;
begin
    Result := DefaultInterface.FihishHour;
end;

procedure TTSSServCont_ControllerTimetableItemXProperties.Set_FihishHour(Value: Byte);
begin
  DefaultInterface.Set_FihishHour(Value);
end;

function TTSSServCont_ControllerTimetableItemXProperties.Get_FihishMinute: Byte;
begin
    Result := DefaultInterface.FihishMinute;
end;

procedure TTSSServCont_ControllerTimetableItemXProperties.Set_FihishMinute(Value: Byte);
begin
  DefaultInterface.Set_FihishMinute(Value);
end;

function TTSSServCont_ControllerTimetableItemXProperties.Get_PersCat: Byte;
begin
    Result := DefaultInterface.PersCat;
end;

procedure TTSSServCont_ControllerTimetableItemXProperties.Set_PersCat(Value: Byte);
begin
  DefaultInterface.Set_PersCat(Value);
end;

{$ENDIF}

class function CoTSSServCont_KeypadItemsX.Create: ITSSServCont_KeypadItems;
begin
  Result := CreateComObject(CLASS_TSSServCont_KeypadItemsX) as ITSSServCont_KeypadItems;
end;

class function CoTSSServCont_KeypadItemsX.CreateRemote(const MachineName: string): ITSSServCont_KeypadItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_KeypadItemsX) as ITSSServCont_KeypadItems;
end;

procedure TTSSServCont_KeypadItemsX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6361E92A-3EF0-4CA5-A42F-ABBEC0854C25}';
    IntfIID:   '{DD1A08AA-20F7-4D36-BCD5-E8A3F6839041}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_KeypadItemsX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_KeypadItems;
  end;
end;

procedure TTSSServCont_KeypadItemsX.ConnectTo(svrIntf: ITSSServCont_KeypadItems);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_KeypadItemsX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_KeypadItemsX.GetDefaultInterface: ITSSServCont_KeypadItems;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_KeypadItemsX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_KeypadItemsXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_KeypadItemsX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_KeypadItemsX.GetServerProperties: TTSSServCont_KeypadItemsXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_KeypadItemsX.Get_KeyCount(Index: Integer): Byte;
begin
    Result := DefaultInterface.KeyCount[Index];
end;

procedure TTSSServCont_KeypadItemsX.Set_KeyCount(Index: Integer; Value: Byte);
begin
  DefaultInterface.KeyCount[Index] := Value;
end;

function TTSSServCont_KeypadItemsX.Get_Timeout(Index: Integer): Byte;
begin
    Result := DefaultInterface.Timeout[Index];
end;

procedure TTSSServCont_KeypadItemsX.Set_Timeout(Index: Integer; Value: Byte);
begin
  DefaultInterface.Timeout[Index] := Value;
end;

function TTSSServCont_KeypadItemsX.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_KeypadItemsXProperties.Create(AServer: TTSSServCont_KeypadItemsX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_KeypadItemsXProperties.GetDefaultInterface: ITSSServCont_KeypadItems;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_KeypadItemsXProperties.Get_KeyCount(Index: Integer): Byte;
begin
    Result := DefaultInterface.KeyCount[Index];
end;

procedure TTSSServCont_KeypadItemsXProperties.Set_KeyCount(Index: Integer; Value: Byte);
begin
  DefaultInterface.KeyCount[Index] := Value;
end;

function TTSSServCont_KeypadItemsXProperties.Get_Timeout(Index: Integer): Byte;
begin
    Result := DefaultInterface.Timeout[Index];
end;

procedure TTSSServCont_KeypadItemsXProperties.Set_Timeout(Index: Integer; Value: Byte);
begin
  DefaultInterface.Timeout[Index] := Value;
end;

function TTSSServCont_KeypadItemsXProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

{$ENDIF}

class function CoTSSServCont_ServcontDateTimeX.Create: ITSSServCont_ServcontDateTime;
begin
  Result := CreateComObject(CLASS_TSSServCont_ServcontDateTimeX) as ITSSServCont_ServcontDateTime;
end;

class function CoTSSServCont_ServcontDateTimeX.CreateRemote(const MachineName: string): ITSSServCont_ServcontDateTime;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_ServcontDateTimeX) as ITSSServCont_ServcontDateTime;
end;

procedure TTSSServCont_ServcontDateTimeX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F544254C-CEDF-4641-A2FE-50BE40C6AB9A}';
    IntfIID:   '{C53058D6-5F20-4C4E-8A78-1DA53F39999F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_ServcontDateTimeX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_ServcontDateTime;
  end;
end;

procedure TTSSServCont_ServcontDateTimeX.ConnectTo(svrIntf: ITSSServCont_ServcontDateTime);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_ServcontDateTimeX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_ServcontDateTimeX.GetDefaultInterface: ITSSServCont_ServcontDateTime;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_ServcontDateTimeX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_ServcontDateTimeXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_ServcontDateTimeX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_ServcontDateTimeX.GetServerProperties: TTSSServCont_ServcontDateTimeXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_ServcontDateTimeX.Get_Year: Byte;
begin
    Result := DefaultInterface.Year;
end;

function TTSSServCont_ServcontDateTimeX.Get_Month: Byte;
begin
    Result := DefaultInterface.Month;
end;

function TTSSServCont_ServcontDateTimeX.Get_Day: Byte;
begin
    Result := DefaultInterface.Day;
end;

function TTSSServCont_ServcontDateTimeX.Get_Hour: Byte;
begin
    Result := DefaultInterface.Hour;
end;

function TTSSServCont_ServcontDateTimeX.Get_Minute: Byte;
begin
    Result := DefaultInterface.Minute;
end;

function TTSSServCont_ServcontDateTimeX.Get_Second: Byte;
begin
    Result := DefaultInterface.Second;
end;

procedure TTSSServCont_ServcontDateTimeX.Set_Year(Value: Byte);
begin
  DefaultInterface.Set_Year(Value);
end;

procedure TTSSServCont_ServcontDateTimeX.Set_Month(Value: Byte);
begin
  DefaultInterface.Set_Month(Value);
end;

procedure TTSSServCont_ServcontDateTimeX.Set_Day(Value: Byte);
begin
  DefaultInterface.Set_Day(Value);
end;

procedure TTSSServCont_ServcontDateTimeX.Set_Hour(Value: Byte);
begin
  DefaultInterface.Set_Hour(Value);
end;

procedure TTSSServCont_ServcontDateTimeX.Set_Minute(Value: Byte);
begin
  DefaultInterface.Set_Minute(Value);
end;

procedure TTSSServCont_ServcontDateTimeX.Set_Second(Value: Byte);
begin
  DefaultInterface.Set_Second(Value);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_ServcontDateTimeXProperties.Create(AServer: TTSSServCont_ServcontDateTimeX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_ServcontDateTimeXProperties.GetDefaultInterface: ITSSServCont_ServcontDateTime;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_ServcontDateTimeXProperties.Get_Year: Byte;
begin
    Result := DefaultInterface.Year;
end;

function TTSSServCont_ServcontDateTimeXProperties.Get_Month: Byte;
begin
    Result := DefaultInterface.Month;
end;

function TTSSServCont_ServcontDateTimeXProperties.Get_Day: Byte;
begin
    Result := DefaultInterface.Day;
end;

function TTSSServCont_ServcontDateTimeXProperties.Get_Hour: Byte;
begin
    Result := DefaultInterface.Hour;
end;

function TTSSServCont_ServcontDateTimeXProperties.Get_Minute: Byte;
begin
    Result := DefaultInterface.Minute;
end;

function TTSSServCont_ServcontDateTimeXProperties.Get_Second: Byte;
begin
    Result := DefaultInterface.Second;
end;

procedure TTSSServCont_ServcontDateTimeXProperties.Set_Year(Value: Byte);
begin
  DefaultInterface.Set_Year(Value);
end;

procedure TTSSServCont_ServcontDateTimeXProperties.Set_Month(Value: Byte);
begin
  DefaultInterface.Set_Month(Value);
end;

procedure TTSSServCont_ServcontDateTimeXProperties.Set_Day(Value: Byte);
begin
  DefaultInterface.Set_Day(Value);
end;

procedure TTSSServCont_ServcontDateTimeXProperties.Set_Hour(Value: Byte);
begin
  DefaultInterface.Set_Hour(Value);
end;

procedure TTSSServCont_ServcontDateTimeXProperties.Set_Minute(Value: Byte);
begin
  DefaultInterface.Set_Minute(Value);
end;

procedure TTSSServCont_ServcontDateTimeXProperties.Set_Second(Value: Byte);
begin
  DefaultInterface.Set_Second(Value);
end;

{$ENDIF}

class function CoTSSServCont_KeyListX.Create: ITSSServCont_KeyList;
begin
  Result := CreateComObject(CLASS_TSSServCont_KeyListX) as ITSSServCont_KeyList;
end;

class function CoTSSServCont_KeyListX.CreateRemote(const MachineName: string): ITSSServCont_KeyList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TSSServCont_KeyListX) as ITSSServCont_KeyList;
end;

procedure TTSSServCont_KeyListX.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{8BD572B8-7BFE-4C43-94D9-28C4820DAC87}';
    IntfIID:   '{4D220FC3-3266-4177-A18E-3A9B295A42E0}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTSSServCont_KeyListX.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITSSServCont_KeyList;
  end;
end;

procedure TTSSServCont_KeyListX.ConnectTo(svrIntf: ITSSServCont_KeyList);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTSSServCont_KeyListX.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTSSServCont_KeyListX.GetDefaultInterface: ITSSServCont_KeyList;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTSSServCont_KeyListX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTSSServCont_KeyListXProperties.Create(Self);
{$ENDIF}
end;

destructor TTSSServCont_KeyListX.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTSSServCont_KeyListX.GetServerProperties: TTSSServCont_KeyListXProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTSSServCont_KeyListX.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

procedure TTSSServCont_KeyListX.Set_Count(Value: Integer);
begin
  DefaultInterface.Set_Count(Value);
end;

function TTSSServCont_KeyListX.Get_Items(Index: Integer): ITSSServCont_ControllerKey;
begin
    Result := DefaultInterface.Items[Index];
end;

procedure TTSSServCont_KeyListX.Set_Items(Index: Integer; const Value: ITSSServCont_ControllerKey);
begin
  DefaultInterface.Items[Index] := Value;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTSSServCont_KeyListXProperties.Create(AServer: TTSSServCont_KeyListX);
begin
  inherited Create;
  FServer := AServer;
end;

function TTSSServCont_KeyListXProperties.GetDefaultInterface: ITSSServCont_KeyList;
begin
  Result := FServer.DefaultInterface;
end;

function TTSSServCont_KeyListXProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

procedure TTSSServCont_KeyListXProperties.Set_Count(Value: Integer);
begin
  DefaultInterface.Set_Count(Value);
end;

function TTSSServCont_KeyListXProperties.Get_Items(Index: Integer): ITSSServCont_ControllerKey;
begin
    Result := DefaultInterface.Items[Index];
end;

procedure TTSSServCont_KeyListXProperties.Set_Items(Index: Integer; 
                                                    const Value: ITSSServCont_ControllerKey);
begin
  DefaultInterface.Items[Index] := Value;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TTSSServContX, TTSSServCont_TimetableSpecialDayListX, TTSSServCont_TimetableItemListX, TTSSServCont_ControllerChipListX, 
    TTSSServCont_ControllerKeyValueX, TTSSServCont_ControllerPortsX, TTSSServCont_ControllerKeyX, TTSSServCont_ControllerChipX, TTSSServCont_ControllerTimetableSpecialDayX, 
    TTSSServCont_ControllerTimetableItemX, TTSSServCont_KeypadItemsX, TTSSServCont_ServcontDateTimeX, TTSSServCont_KeyListX]);
end;

end.
