unit upersdata;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ExtDlgs, memds, DB,SQLDB, Forms;

type

  { Tpersdata }

  Tpersdata = class(TDataModule)
    cd1: TCalendarDialog;
    cd2: TCalendarDialog;
    dsnametmz: TDataSource;
    dstmz: TDataSource;
    dsk: TDataSource;
    mdk: TMemDataset;
    mdtmz: TMemDataset;
    mdnamrtmz: TMemDataset;
    procedure cd1CanClose(Sender: TObject; var CanClose: Boolean);
    procedure cd1Change(Sender: TObject);
    procedure cd2Change(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure dskDataChange(Sender: TObject; Field: TField);
    procedure dsnametmzDataChange(Sender: TObject; Field: TField);
    procedure mdkBeforeDelete(DataSet: TDataSet);
  private

  public

  end;

var
  persdata: Tpersdata;

implementation

{$R *.lfm}
uses umain;

{ Tpersdata }

procedure Tpersdata.cd2Change(Sender: TObject);
var
 s:string;
 sd:tdate;
begin
    {
      s:=datetostr(cd1.date);
      le_sTOP.text:=s;
      form1.log('l','STOP='+s);
      }

end;

procedure Tpersdata.DataModuleCreate(Sender: TObject);
begin
     cd1.Date:=date;
     cd2.date:=date;
end;

procedure Tpersdata.dskDataChange(Sender: TObject; Field: TField);
begin
       {
        form1.SBK.Panels[0].text:=inttostr(mdk.RecNo);
        form1.sbk.Panels[1].text:=inttostr(mdk.Recordcount);
        form1.sbk.Panels[2].text:=' ТАБЛИЦА  " КЛЮЧИ "   ';
        form1.le_kluch.text:=mdk.FieldByName('kluch').asstring;
        form1.le_stop.text:=mdk.FieldByName('stop').asstring;
        form1.le_start.text:=mdk.FieldByName('start').asstring;
        form1.cbact.Checked:=mdk.FieldByName('actual').AsBoolean;
        }
end;

procedure Tpersdata.dsnametmzDataChange(Sender: TObject; Field: TField);
var
 myidnm,s,t1,t2:string;
 qrx:tsqlquery;
begin
       IF NOT FSTART THEN EXIT;
       //mdnamrtmz.DisableControls;
       myidnm:=TRIM(mdnamrtmz.FieldByName('myid').asstring);
       // mdnamrtmz.enableControls;
       IF MYIDNM='' THEN EXIT;
       form1.readtmz(myidnm);
      // mdnamrtmz.enableControls;
       exit;

end;

procedure Tpersdata.mdkBeforeDelete(DataSet: TDataSet);
var
 s,myid:string;

begin
        myid:=mdk.FieldByName('myid').AsString;

        s:='delete  from tss_keys where myid='+myid ;
        form1.log('y',s);
        form1.selfupd(s);
end;

procedure Tpersdata.cd1Change(Sender: TObject);
var
 s:string;
 sd:tdate;

begin
      {
      s:=datetostr(cd1.date);
      form1.le_start.text:=s;
      form1.log('l','STart='+s);
      }


end;

procedure Tpersdata.cd1CanClose(Sender: TObject; var CanClose: Boolean);

begin
end;

end.

