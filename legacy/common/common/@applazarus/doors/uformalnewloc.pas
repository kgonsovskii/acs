unit uformalnewloc;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  laz.virtualtrees,
  SQLDB;

type

  { Tformalnewloc }

  Tformalnewloc = class(TForm)
    Button1: TButton;
    cbinside: TCheckBox;
    cmb: TComboBox;
    lename: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure alupd;
    procedure FormShow(Sender: TObject);
    procedure prepare;
  private

  public

  end;

var
  formalnewloc: Tformalnewloc;
  cnd   :pvirtualnode;
  flagoper,place:string;

  cqrz: TSQLQuery;
  slc:tstringlist;

implementation

{$R *.lfm}
uses umain,uglink;

{ Tformalnewloc }

procedure Tformalnewloc.alupd;
var
  s,ss,locinside:string;
  dl:pvstrecordloc;
begin
      dl:=form1.vstloc.GetNodeData(cnd);
      ss:=cmb.Text;
      ss:=slc.Values[ss];
      if place='first' then locinside:='True' else locinside:='False';
      if flagoper='insert' then begin
      s:='insert into tssloc_locations (locinside,loccode,tag,bp,name) values('+
      locinside+zp+
      ss+zp+
      '2'+zp+
      inttostr(dl^.dbmyid)+zp+
      ap+lename.text+ap+

      ')';
      end;
      ss:=cmb.Text;
      ss:=slc.Values[ss];
      if flagoper='update' then begin
      s:='update  tssloc_locations set name='+ap+lename.text+ap+zp+
      'loccode='+ss+
      ' where myid='+inttostr(dl^.dbmyid);
      form1.log('l','alupd='+s);
      end;
      form1.selfupd(s);
      form1.currrereadloc;


end;

procedure Tformalnewloc.prepare;
var
  s,sc:string;
begin
     //owmessage ('prepare start');

     cmb.Clear;
     s:='select * from tssloc_loccode order by loccode';
     cqrz:=formglink.gselqr(s);
     while not cqrz.EOF do begin
      s:=cqrz.FieldByName('name').AsString;
      sc:=cqrz.FieldByName('loccode').AsString;
      cmb.Items.Add(s);
      slc.Values[s]:=sc;
      cqrz.Next;;
     end;
    //howmessage('slc='+slc.text);
end;

procedure Tformalnewloc.FormShow(Sender: TObject);
begin
end;

procedure Tformalnewloc.FormCreate(Sender: TObject);
begin
      slc:=tstringlist.Create;
end;

procedure Tformalnewloc.Button1Click(Sender: TObject);
var
cf:tfillnd;
begin
     if cbinside.Checked then begin
     cf.place:='first';
     cf.sti:=-1;
     cf.sti1:=-1;
     cf.tag:=3;
     cf.nm0:=lename.text;
     form1.vstlocins(cnd,cf);
     end;
     alupd;
end;

end.

