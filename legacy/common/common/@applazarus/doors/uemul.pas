unit uemul;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, Menus, DBCtrls, rxswitch, umain, ualfunc, memds, DB,SQLDB,uglink;

type

  { Tformemul }

  Tformemul = class(TForm)
    Button1: TButton;
    cb1: TCheckBox;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    ds: TDataSource;
    ekluch: TEdit;
    emars: TEdit;
    entmz: TEdit;
    lerepeat: TLabeledEdit;
    lecn: TLabeledEdit;
    lerint: TLabeledEdit;
    md: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    pop1: TPopupMenu;
    procedure Button1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure readpersons;
    procedure clearmd;
  private

  public

  end;

var
  formemul: Tformemul;
  fio,kluch,mrs,ntmz:string;


implementation

{$R *.lfm}



{ Tformemul }


procedure Tformemul.clearmd;
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

procedure  Tformemul.readpersons;
var
  qrz: TSQLQuery;
  s,keycode: string;
  n: integer;
  FF:boolean;
  fio,name1,name2,name3:string;
  sl:tstringlist;
begin
  try
   {
     select kl.kluch,ps.fio,ps.mrs,ps.ntmz,kl.code
     from  tss_persons as ps,
     tss_keys as kl
     where ps.bpkeys=kl.myid  order by fio
   }

     // showmessage('REdpersons EMUL rc='+inttostr(md.RecordCount));
      if md.RecordCount>1 then exit;

    s:='select kl.kluch,pinf.name3,pinf.name2,pinf.name1,pinf.mrs,'+
      ' pinf.tmzname,kl.code'+
      ' from   tss_persinfo  as pinf,  tss_keys  as kl'+
      ' where pinf.bidkeys =kl.myid'+
      ' order by pinf.name3';


    sl:=tstringlist.Create;
    sl.Add(s);
    form1.log('y', 'SNEW=========' + s);
    ff:=true;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(s);
    md.open;
    //CLEARMD;
    TRY
     qrz.Active := True;
     ff:=false;
    except
    on ee: Exception do
    begin
     ff:=false;
     form1.log('e', 'UEMUL readpersons 1 ,ee=' + ee.Message);
  //   SHOWMESSAGE('EMUL READPERSONS EE='+EE.Message);
     //HALT(0);
    end;
  end;
    while not qrz.eof do begin
     kluch := qrz.FieldByName('kluch').Asstring;
     name1 := qrz.FieldByName('name1').Asstring;
     name2 := qrz.FieldByName('name2').Asstring;
     name3 := qrz.FieldByName('name3').Asstring;
     fio:=name3+' '+name1+' '+name2;
     //form1.log('l','fio='+fio);
     mrs := qrz.FieldByName('mrs').Asstring;
     ntmz := qrz.FieldByName('tmzname').Asstring;
     keycode := qrz.FieldByName('code').Asstring;

     md.Insert;
     md.FieldByName('kluch').Asstring:=kluch;
     md.FieldByName('fio').Asstring:=fio;
     md.FieldByName('mrs').asstring:=mrs;
     md.FieldByName('ntmz').asstring:=ntmz;
     md.FieldByName('keycode').asstring:=keycode;

     qrz.Next;
    end;
    md.post;
    md.First;
    md.EnableControls;
    vglink.qrx := qrz;
    exit;
  except
    on ee: Exception do
    begin
     form1.log('e', 'UEMUL readpersons ,ee=' + ee.Message);
     //EXIT;
    end;
  end;
   md.EnableControls;
end;



procedure Tformemul.Button1Click(Sender: TObject);
begin

end;

procedure Tformemul.MenuItem1Click(Sender: TObject);
var
  fio:string;
begin
       try md.post; except end;

       fio:=md.FieldByName('fio').asstring;
       //showmessage('fio='+fio);
       form1.log('y','fio='+fio);
       ekluch.text:=trim(md.FieldByName('kluch').asstring);
       emars.text:=trim(md.FieldByName('mrs').asstring);
       entmz.text:=trim(md.FieldByName('ntmz').asstring);
       form1.log('c','kluch='+ekluch.text);
       vemuldata.kluch:=kluch;
       vemuldata.fio:=fio;
       vemuldata.mrs:=mrs;
       vemuldata.ntmz:=ntmz;
       vemuldata.codekey:=inttostr(ualfunc.keytox(vemuldata.kluch));
       close;

end;

procedure Tformemul.MenuItem2Click(Sender: TObject);
var
  kc,s:string;
begin
       // СБРОС APBOUT
       kc:=md.FieldByName('keycode').AsString;
       s:='delete from tss_passes where keycode='+kc+
          ' and fckp=true  and ioflag=false';
       form1.selfupd(s);



end;

procedure Tformemul.MenuItem3Click(Sender: TObject);
var
  kc,s:string;
begin
       // СБРОС APBin
        kc:=md.FieldByName('keycode').AsString;
       s:='delete from tss_passes where keycode='+kc+
          ' and fckp=true  and ioflag=true';
       form1.selfupd(s);


end;

end.

