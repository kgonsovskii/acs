unit TSSServContAPI;

interface

const
  cKeySize = 6;
  cPortCount = 8;
  cPersCatCount = 16;
  cMaxChipCount = 127;

type
  TControllerState = (csNone, csStateless, csAutonomicPolling, csComplex);

  PServcontDate = ^TServcontDate;
  TServcontDate = packed record
    Year, // (��� ����)
    Month, Day: Byte;
  end;

  PServcontTime = ^TServcontTime;
  TServcontTime = packed record
    Hour, Minute, Second: Byte;
  end;

  PServcontDateTime = ^TServcontDateTime;
  TServcontDateTime = packed record
    Year, // (��� ����)
    Month, Day, Hour, Minute, Second: Byte;
  end;

  PControllerKeyValue = ^TControllerKeyValue;
  TControllerKeyValue = packed array [0..cKeySize-1] of Byte;

  PControllerPorts = ^TControllerPorts;
  TControllerPorts = packed array [0..cPortCount-1] of Boolean;

  PControllerKey = ^TControllerKey;
  TControllerKey = packed record
    Value: TControllerKeyValue;
    Ports: TControllerPorts;
    PersCat: Byte; // 1..16
    SuppressDoorEvent,
    OpenEvenComplex,
    IsSilent: Boolean;
  end;

  PControllerChip = ^TControllerChip;
  TControllerChip = packed record
    Value: TControllerKeyValue;
    Active: Boolean;
    OpenEvenComplex: Boolean;
    CheckCount: Byte;
    Port: Byte;
    //BitCount: Byte; � ������ 1.10
  end;

  PControllerChips = ^TControllerChips;
  TControllerChips = packed record
    Ports: TControllerPorts;
    Chips: packed array [0.. cMaxChipCount-1] of TControllerChip;
  end;

  PControllerKeyAttr = ^TControllerKeyAttr;
  TControllerKeyAttr = packed record
    Ports: TControllerPorts;
    PersCat: Byte; // 1..16
    SuppressDoorEvent,
    OpenEvenComplex,
    IsSilent: Boolean;
  end;

  PControllerTimetableSpecialDay = ^TControllerTimetableSpecialDay;
  TControllerTimetableSpecialDay = packed record
    Year, // (��� ����)
    Month, Day: Byte;
    DayType: Byte;
  end;

  TControllerTimetableTime = packed record
    Hour,
    Minute: Byte;
  end;

  PControllerTimetableItem = ^TControllerTimetableItem;
  TControllerTimetableItem = packed record
    DayType: Byte;
    Start,
    Fihish: TControllerTimetableTime;
    PersCat: Byte;
  end;

  TKeypadItem = packed record
    KeyCount: Byte;
    Timeout: Byte;  // max 15 sec
  end;

  PKeypadItems = ^TKeypadItems;
  TKeypadItems = packed record
    Items: packed array [0..cPortCount-1] of TKeypadItem;
  end;

  // ����� �������
  PControllerEvent = ^TControllerEvent;
  TControllerEvent = packed record
    Timestamp2: TServcontDateTime; // ����� ����������� ������� �������� ������������ �� �����������
    Addr: Byte;      // ����� �����������
    No: Word;        // ����� �������
    IsAuto: Boolean; // ������� ��� ��������
    Timestamp1: TServcontDateTime; // ����� �������, ������������� ������������
    IsLast: Boolean; // ������� ���������� �������
  end;

  // �������� �������
  PControllerPortEvent = ^TControllerPortEvent;
  TControllerPortEvent = packed record
    ControllerEvent: TControllerEvent;
    Port: Byte;      // ���� �����������
  end;

  // �������� �������, ������� ����� �������� ���� (KEY, RTE)
  PControllerPortRelayEvent = ^TControllerPortRelayEvent;
  TControllerPortRelayEvent = packed record
    ControllerPortEvent: TControllerPortEvent;
    //������������� ���������� ��������� ������ ��� ����������� �������, � ��������� - �����.
    IsOpen: Boolean;
  end;

  // ������� ����
  PControllerKeyEvent = ^TControllerKeyEvent;
  TControllerKeyEvent = packed record
    ControllerPortRelayEvent: TControllerPortRelayEvent;
    Key: TControllerKeyValue;
    //������������� ���������� ��������� ������ ��� ����������� �������, � ��������� - �����.
    IsTimeRestrict: Boolean; //������ �� ��������� ������������
    IsTimeRestrictDone: Boolean; //���� ������� ��������� ��������� �����������
    IsAccessGranted: Boolean; //������ �� ����� �����
    IsKeyFound: Boolean; //���� � �� ������ | �� ������
    IsKeySearchDone: Boolean; //��� ���������� ����� � ���� ������; | ����� � �� �� ������������ (��������, ��� ������ ���� ���� ������ �����, ���� ������� ������������� � ��������� � ��� ��������� ������ � ���� ������ �� ���� ������)
  end;

  //
  PControllerStaticSensor = ^TControllerStaticSensor;
  TControllerStaticSensor = packed record
    ControllerEvent: TControllerEvent;
    Value: Byte;
  end;

  PServcontChannel = ^TServcontChannel;
  TServcontChannel = packed record
    IsActive: Boolean;
    IsReady: Boolean;
    IsIP: Boolean;
    PortOrHost: array [0..31] of Char;
    SpeedOrPort: Integer;
    ResponseTimeout: Integer;
    AliveTimeout: Integer;
    DeadTimeout: Integer;
    PollSpeed: Integer;
  end;

  PServcontController = ^TServcontController;
  TServcontController = packed record
    Addr: Byte;
    State: Byte;//TControllerState
    //IsReliable: Boolean;
  end;

  PServcontClient = ^TServcontClient;
  TServcontClient = packed record
    Id: TGUID;
    // net order.
    Addr: Integer;
    Port: Word;
  end;

implementation

end.
