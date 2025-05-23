unit uformedittmz;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, ExtCtrls, Menus, rxclock, rxtooledit, RxTimeEdit, rxspin,SQLDB;

type

  { Tformedittmz }

  Tformedittmz = class(TForm)
    dbg: TDBGrid;
    ds1: TDataSource;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    md: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    pop1: TPopupMenu;
    RX1: TRxTimeEdit;
    RX2: TRxTimeEdit;
    RxSpinButton1: TRxSpinButton;
    ToggleBox1: TToggleBox;
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure RxSpinButton1BottomClick(Sender: TObject);
    procedure RxSpinButton1TopClick(Sender: TObject);
    procedure readalltmz;
    procedure clearmd;
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBox3Click(Sender: TObject);
  private

  public

  end;

var
  formedittmz: Tformedittmz;

implementation

{$R *.lfm}
uses umain,uglink;

{ Tformedittmz }

procedure Tformedittmz.clearmd;
begin
      md.First;
      md.DisableControls;
      while not md.EOF do begin;
       md.Edit;
       md.Delete;
      end;
      try
       md.post;
      except
      end;
      md.EnableControls;
end;

procedure Tformedittmz.ToggleBox1Change(Sender: TObject);
begin
       md.Insert;

       md.FieldByName('ntmz').AsInteger:=strtoint(edit1.text);
       md.FieldByName('t1').AsString  :=rx1.Text;
       md.FieldByName('t2').AsString :=rx2.text;
       md.post;
end;

procedure Tformedittmz.ToggleBox3Click(Sender: TObject);
begin


end;

procedure Tformedittmz.readalltmz;
var
qrz: TSQLQuery;
s:string;
begin
    qrz := TSQLQuery.Create(self);
     qrz.DataBase := formglink.pqc1;
      s := ' select *  from tss_tmz  order by ntmz,t1,t2';
      form1.log('l','readalltmz s='+s);
     qrz.SQL.Add(s);
     qrz.Active := True;
     if qrz.RecordCount=0 then begin

      exit;
     end;
     clearmd;
     md.open;
     while not qrz.eof do begin
       md.insert;
       md.FieldByName('myid').AsInteger:=qrz.FieldByName('myid').Asinteger;
       md.FieldByName('ntmz').AsInteger:=qrz.FieldByName('ntmz').Asinteger;
       md.FieldByName('t1').AsString  :=qrz.FieldByName('t1').Asstring;
       md.FieldByName('t2').AsString :=qrz.FieldByName('t2').Asstring;
       qrz.Next;
       md.post;

     end;

end;

procedure Tformedittmz.RxSpinButton1TopClick(Sender: TObject);
begin
       EDIT1.Text:=inttostr(strtoint(edit1.text)+1);
end;

procedure Tformedittmz.RxSpinButton1BottomClick(Sender: TObject);
begin
       EDIT1.Text:=inttostr(strtoint(edit1.text)-1);
       if strtoint(edit1.text)<=0 then begin
        edit1.text:='1';
       end;

end;

procedure Tformedittmz.MenuItem2Click(Sender: TObject);
var
  s,ntmz,t1,t2:string;

begin
      s:='delete from tss_tmz where ntmz='+edit1.text;
      form1.selfupd(s);
      try    md.Post; except end;
      ntmz:=edit1.text;
      md.First;
      while not md.EOF do begin;

       t1:=md.FieldByName('t1').Asstring;
       t2:=md.FieldByName('t2').Asstring;
       md.next;
       s:='insert into tss_tmz (ntmz,t1,t2)values('+
        ntmz+zp+
        ap+t1+ap+zp+
        ap+t2+ap+')';
        form1.log('l',s) ;
       form1.selfupd(s) ;

      end;


end;

procedure Tformedittmz.MenuItem1Click(Sender: TObject);
begin
       clearmd;
end;

end.

