unit ualdb3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,forms,Dialogs, SysUtils, SQLite3Conn, SQLDB,base64;

type

  { TDmdb3 }

  TDmdb3 = class(TDataModule)
    bsqlconfig: TSQLite3Connection;
    db3tr: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    function  readconfig:tstringlist;
  private

  public

  end;

var
  Dmdb3: TDmdb3;

implementation

{$R *.lfm}
uses umain;

{ TDmdb3 }

function  TDmdb3.readconfig:tstringlist;
var
 i:integer;
 k,v,nm,s,pt:string;
 q:tsqlquery;
 sl:tstringlist;

 begin

     pt:=appdir+'/config/altssconfig.db3';
     showmessage('pt='+pt);
     bsqlconfig.HostName:=pt;
     bsqlconfig.DatabaseName:=pt;
     sl:=tstringlist.Create;
     q:=tsqlquery.Create(nil);
     q.DataBase:=bsqlconfig;
     q.Transaction:=db3tr;
     s:='select * from config order by key';
     q.sql.Add(s);
     q.Active:=true;
     while not q.eof do begin
      k:=q.FieldByName('key').AsString;
      v:=q.FieldByName('value').AsString;
      v:=base64.DecodeStringBase64(v);
      sl.values[k]:=v;
      form1.log('l','k='+k+' /v='+v);
      q.next;
     end;
     result:=sl;
end;




procedure TDmdb3.DataModuleCreate(Sender: TObject);
begin

end;

end.

