unit TimetableFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls, ExtCtrls, BFServCont_TLB;

type
  TfrmTimetable = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    edtFromHour: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtFromMinute: TEdit;
    edtToHour: TEdit;
    Label4: TLabel;
    edtToMinute: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    chbPersCat1: TCheckBox;
    chbPersCat2: TCheckBox;
    chbPersCat3: TCheckBox;
    chbPersCat4: TCheckBox;
    chbPersCat5: TCheckBox;
    chbPersCat6: TCheckBox;
    chbPersCat7: TCheckBox;
    chbPersCat8: TCheckBox;
    chbPersCat9: TCheckBox;
    chbPersCat10: TCheckBox;
    chbPersCat11: TCheckBox;
    chbPersCat12: TCheckBox;
    chbPersCat13: TCheckBox;
    chbPersCat14: TCheckBox;
    chbPersCat15: TCheckBox;
    chbPersCat16: TCheckBox;
    GroupBox3: TGroupBox;
    cbxDays2: TComboBox;
    Button5: TButton;
    Button6: TButton;
    Button4: TButton;
    sgdItems: TStringGrid;
    DateTimePicker: TDateTimePicker;
    Label1: TLabel;
    cbxDays1: TComboBox;
    sgdSpecialsDays: TStringGrid;
    Button2: TButton;
    Button3: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    function MakeHHMM(const h, m: string): string;
  public
    { Public declarations }
    procedure Timetable2Controls(SpecialDays : ITSSServCont_TimetableSpecialDayList;
                                 Items: ITSSServCont_TimetableItemList);
    procedure Controls2Timetable(SpecialDays : ITSSServCont_TimetableSpecialDayList;
                                 Items: ITSSServCont_TimetableItemList);
  end;

{
var
  frmTimetable: TfrmTimetable;
}

implementation

uses
  MainFrm;

const
  cPersCatCount = 16;


{$R *.dfm}

procedure TfrmTimetable.Button5Click(Sender: TObject);
var
  i, y: Integer;
  chb: TCheckBox;
begin
  for i:=1 to cPersCatCount do begin
    chb := FindComponent('chbPersCat' + IntToStr(i)) as TCheckBox;
    Assert(chb <> nil);
    if chb.Checked then begin
      y := AddGridRow(sgdItems);
      sgdItems.Cells[0, y] := IntToStr(cbxDays2.ItemIndex + 1);
      sgdItems.Cells[1, y] := MakeHHMM(edtFromHour.Text, edtFromMinute.Text);
      sgdItems.Cells[2, y] := MakeHHMM(edtToHour.Text, edtToMinute.Text);
      sgdItems.Cells[3, y] := IntToStr(i);
    end;
  end;
end;

procedure TfrmTimetable.FormCreate(Sender: TObject);
begin
  DateTimePicker.DateTime := Now;
  sgdSpecialsDays.Cells[0, 0] := 'Date';
  sgdSpecialsDays.Cells[1, 0] := 'Day';
  sgdItems.Cells[0, 0] := 'Day';
  sgdItems.Cells[1, 0] := 'From';
  sgdItems.Cells[2, 0] := 'To';
  sgdItems.Cells[3, 0] := 'PersCat';
end;

procedure TfrmTimetable.Button6Click(Sender: TObject);
begin
  RemoveGridRow(sgdItems, sgdItems.Row);
end;

procedure TfrmTimetable.Button2Click(Sender: TObject);
var
  y: Integer;
begin
  y := AddGridRow(sgdSpecialsDays);
  sgdSpecialsDays.Cells[0, y] := FormatDateTime('yyyy-mm-dd', DateTimePicker.Date);
  sgdSpecialsDays.Cells[1, y] := IntToStr(cbxDays1.ItemIndex + 1);
end;

procedure TfrmTimetable.Button3Click(Sender: TObject);
begin
  RemoveGridRow(sgdSpecialsDays, sgdSpecialsDays.Row);
end;

procedure TfrmTimetable.Timetable2Controls(SpecialDays : ITSSServCont_TimetableSpecialDayList;
                                 Items: ITSSServCont_TimetableItemList);
var
  i{, Count}, y: Integer;
  pDay: ITSSServCont_ControllerTimetableSpecialDay;
  pItem: ITSSServCont_ControllerTimetableItem;
begin
  //Count := Length(SpecialDays) div SizeOf(TControllerTimetableSpecialDay);
  //if Count <> 0 then begin
 //   pDay := PControllerTimetableSpecialDay(@SpecialDays[1]);
    for i:=0 to SpecialDays.Count - 1 do begin
      y := AddGridRow(sgdSpecialsDays);
      pDay := SpecialDays.Items[I];
      sgdSpecialsDays.Cells[0, y] := Format('%.2d-%.2d-%.2d', [pDay.Year + 2000, pDay.Month, pDay.Day]);
      sgdSpecialsDays.Cells[1, y] := IntToStr(pDay.DayType);
      //Inc(pDay);
    end;
//  end;

//  Count := Length(Items) div SizeOf(TControllerTimetableItem);
//  if Count <> 0 then begin
//    pItem := PControllerTimetableItem(@Items[1]);
    for i:=0 to Items.Count - 1 do begin
      y := AddGridRow(sgdItems);
      pItem := Items.Items[I];
      sgdItems.Cells[0, y] := IntToStr(pItem.DayType);
      sgdItems.Cells[1, y] := Format('%.2d:%.2d', [pItem.StartHour, pItem.StartMinute]);
      sgdItems.Cells[2, y] := Format('%.2d:%.2d', [pItem.FihishHour, pItem.FihishMinute]);
      sgdItems.Cells[3, y] := IntToStr(pItem.PersCat);
      //Inc(pItem);
    end;
//  end;
end;

procedure TfrmTimetable.Controls2Timetable(SpecialDays : ITSSServCont_TimetableSpecialDayList;
                                 Items: ITSSServCont_TimetableItemList);
var
  i{, Count}: Integer;
  s: string;
  pDay: ITSSServCont_ControllerTimetableSpecialDay;
  pItem: ITSSServCont_ControllerTimetableItem;
begin
  SpecialDays.Count := sgdSpecialsDays.RowCount - 2;
  //i := SizeOf(TControllerTimetableSpecialDay) * Count;
  //SetLength(SpecialDays, i);
  for i:= 1 to SpecialDays.Count do begin
    pDay := SpecialDays.Items[I-1];
    pDay.Year := StrToInt(Copy(sgdSpecialsDays.Cells[0, i], 1, 4)) - 2000;
    pDay.Month := StrToInt(Copy(sgdSpecialsDays.Cells[0, i], 6, 2));
    pDay.Day := StrToInt(Copy(sgdSpecialsDays.Cells[0, i], 9, 2));
    pDay.DayType := StrToInt(sgdSpecialsDays.Cells[1, i]);
    //Move(Day, SpecialDays[SizeOf(TControllerTimetableSpecialDay) * (i - 1) + 1], SizeOf(TControllerTimetableSpecialDay));
  end;

  Items.Count := sgdItems.RowCount - 2;
//  i := SizeOf(TControllerTimetableItem) * Count;
//  SetLength(Items, i);
  for i:=1 to SpecialDays.Count do begin
    pItem := Items.Items[I-1];
    pItem.DayType := StrToInt(sgdItems.Cells[0, i]);

    s := sgdItems.Cells[1, i];
    pItem.StartHour := StrToInt(Copy(s, 1, Pos(':', s) - 1));
    pItem.StartMinute := StrToInt(Copy(s, Pos(':', s) + 1, MaxInt));

    s := sgdItems.Cells[2, i];
    pItem.FihishHour := StrToInt(Copy(s, 1, Pos(':', s) - 1));
    pItem.FihishMinute := StrToInt(Copy(s, Pos(':', s) + 1, MaxInt));

    pItem.PersCat := StrToInt(sgdItems.Cells[3, i]);

    //Move(Item, Items[SizeOf(TControllerTimetableItem) * (i - 1) + 1], SizeOf(TControllerTimetableItem));
  end;
end;

function TfrmTimetable.MakeHHMM(const h, m: string): string;
begin
  Result := Format('%.2d:%.2d', [StrToInt(Trim(h)), StrToInt(Trim(m))]);
end;

end.
