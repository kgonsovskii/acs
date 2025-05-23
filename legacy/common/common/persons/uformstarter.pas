unit uformstarter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, memds, DB, Forms, Controls, Graphics,
  Dialogs, DBGrids, Menus,
  base64;

type

  { Tformstarter }

  Tformstarter = class(TForm)
    bsqlstarter: TSQLite3Connection;
    db3tr: TSQLTransaction;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    ds1: TDataSource;
    mds: TMemDataset;
    MenuItem1: TMenuItem;
    pop1: TPopupMenu;
    procedure bsqlstarterAfterConnect(Sender: TObject);
    procedure ds1DataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
   procedure  openstarter;
   procedure  rereadstarter;
    procedure log(pr,txt:string);
    procedure myclear;
    procedure rdandsave;
    procedure todb3(sl:tstringlist);
    function  fupd(s:string):string;
    function  getqrz(s:string):TSQLQuery;
  private

  public

  end;

var
  formstarter: Tformstarter;

implementation

{$R *.lfm}
uses umain, ualfunc;

{ Tformstarter }

function Tformstarter.getqrz(s:string):TSQLQuery;
var
 qrz: TSQLQuery;
begin
      result:=nil;
      qrz:=TSQLQuery.Create(self);
      qrz.DataBase:=bsqlstarter;
      qrz.Transaction:=db3tr;
      qrz.SQL.clear;
      log('w','getqrz='+s);
      qrz.SQL.Add(s);
      qrz.Active:=true;
      result:=qrz;

end;

procedure Tformstarter.rdandsave;
var
sl:tstringlist;
begin
        mds.First;
        sl:=tstringlist.Create;
        while not mds.EOF do begin;
         sl.Values['myid']:=mds.FieldByName('myid').asstring;
         sl.Values['tag']:=mds.FieldByName('tag').asstring;
         sl.Values['app']:=trim(mds.FieldByName('app').asstring);
         sl.Values['dbn']:=trim(mds.FieldByName('dbn').asstring);
         sl.Values['psw']:=trim(mds.FieldByName('psw').asstring);
         sl.Values['adrpath']:=trim(mds.FieldByName('adrpath').asstring);
         sl.Values['tscd']:=datetimetostr(now);
         todb3(sl);
         sl.Clear;
         mds.next;
        end;
        mds.First;
        sl.free;
end;


 procedure Tformstarter.log(pr,txt:string);
 begin
      form1.log(pr,txt);
 end;

 
procedure Tformstarter.myclear;
begin

     mds.DisableControls;
     mds.open;
     mds.First;
      while not mds.EOF do begin
        mds.edit;
        mds.Delete;
      end;
      mds.EnableControls;



end;

procedure Tformstarter.todb3(sl:tstringlist);
var
i:integer;
lop:string;
apx,myid,ttg,adrpath,dbn,psw,tscd,k,s,v:string;
begin
        lop:='''';
        apx:=sl.Values['app'];
        adrpath:=sl.Values['adrpath'];
        myid:=trim(sl.Values['myid']);
        ttg :=sl.Values['tag'];
        dbn :=sl.Values['dbn'];
        psw :=sl.Values['psw'];
        tscd :=sl.Values['tscd'];
        //if apx='base' then begin
         dbn:=base64.EncodeStringBase64(dbn);
         psw:=base64.EncodeStringBase64(psw);
        //end;
        if myid ='' then begin
         s:='insert into starter(app,adrpath,tag,dbn,psw)values('+
          lop+apx+lop+zp+
          lop+adrpath+lop+zp+
          ttg+zp+
          lop+dbn+lop+zp+
          lop+psw+lop+')';
          fupd(s);
            log('l','s='+s);
          exit;
        end;
        s:='update starter set app='+lop+apx+lop+zp+
           'adrpath='+lop+adrpath+lop+zp+
           'tag='+ttg+zp+
           'dbn='+lop+dbn+lop+zp+
           'psw='+lop+psw+lop+zp+
           'tscd='+lop+tscd+lop+
           ' where myid='+myid;


        log('l','s='+s);
        fupd(s)

end;

function Tformstarter.fupd(s:string):string;
var
 qrx: TSQLQuery;
begin
      try
        result:='';
        log('y','fupd='+s);
        qrx:=TSQLQuery.Create(self);
        qrx.DataBase:=bsqlstarter;
        qrx.Transaction:=db3tr;
        qrx.SQL.clear;
        qrx.SQL.Add(s);
        qrx.ExecSQL;
        db3tr.Commit;
        result:='ok';
     except
        on e:exception do begin
        log('e','fupd,e='+e.Message);
        result:=e.Message;
        end;
       end;


end;


procedure Tformstarter.rereadstarter;
var
 qrz: TSQLQuery;
 s,apx,bname,bpsw,baddr:string;
begin
        log('y','rereadstarter start');
        mds.open;
        qrz:=TSQLQuery.Create(self);
        qrz.DataBase:=bsqlstarter;
        qrz.Transaction:=db3tr;
        qrz.SQL.clear;
        s:='select * from starter order by myid  ';
        log('w','findstarter='+s);
        log('y','rereadstarter start 1 ');
        qrz.SQL.Add(s);
        qrz.Active:=true;
        log('c','s='+s);
         myclear;
       //  show;
          log('y','rereadstarter start 2 ');
        qrz.First;
        while not qrz.eof do begin
         mds.Insert;
         mds.FieldByName('myid').AsInteger:=qrz.FieldByName('myid').asinteger;
         mds.FieldByName('tag').AsInteger:=qrz.FieldByName('tag').asinteger;
         mds.FieldByName('app').Asstring:=qrz.FieldByName('app').asstring;
        // showmessage('app='+qrz.FieldByName('app').asstring);
         apx:=qrz.FieldByName('app').asstring;
         mds.FieldByName('adrpath').Asstring:=qrz.FieldByName('adrpath').asstring;
         s:=trim(qrz.FieldByName('dbn').asstring);
         if s<>'' then s:=base64.DecodeStringBase64(s);
         bname:=s;
         mds.FieldByName('dbn').Asstring:=s;
         s:=trim(qrz.FieldByName('psw').asstring);
         if s<>'' then  s:=base64.DecodeStringBase64(s);
         bpsw:=s;
         mds.FieldByName('psw').Asstring:=s;
         if apx='transport' then begin
           umain.mysysinfo.traddr:=qrz.FieldByName('adrpath').asstring;

         end;
         if apx='base' then begin
           umain.mysysinfo.baseaddr:=qrz.FieldByName('adrpath').asstring;
           umain.mysysinfo.basename:=bname;
           umain.mysysinfo.basepsw:=bpsw;
         end;

         mds.post;
         qrz.next;
        end;
        log('c','umain.mysysinfo.baseaddr='+umain.mysysinfo.baseaddr);
        log('c','umain.mysysinfo.basename='+umain.mysysinfo.basename);
        log('c','umain.mysysinfo.baspsw ='+umain.mysysinfo.basepsw);




end;


procedure Tformstarter.openstarter;
var
dbp:string;
begin
   log('y','openstarter start');
  //formstarter.top:=0;
  //formstarter.left:=0;
  //showmodal;
  dbp:=appdir+'starter/starter.db3';
     log('y','openstarter dbp='+dbp);
  bsqlstarter.DatabaseName:=dbp;
  bsqlstarter.Connected:=true;




end;



procedure Tformstarter.FormCreate(Sender: TObject);
begin

end;

procedure Tformstarter.MenuItem1Click(Sender: TObject);
begin
    log('y','изменить');
    rdandsave;
end;

procedure Tformstarter.bsqlstarterAfterConnect(Sender: TObject);
begin
     log('y','bsqlstarterAfterConnect !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
end;

procedure Tformstarter.ds1DataChange(Sender: TObject; Field: TField);
begin

end;

end.

