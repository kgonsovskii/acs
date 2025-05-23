unit udmpgs;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, PQConnection, SQLDB;

type

  { Tdmpggs }

  Tdmpggs = class(TDataModule)
    pgs1: TPQConnection;
    pgsdmsql: TSQLQuery;
    pgstr1: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  dmpggs: Tdmpggs;

implementation

{$R *.lfm}

{ Tdmpggs }


procedur  connect;



procedure Tdmpggs.DataModuleCreate(Sender: TObject);
begin

end;

end.

