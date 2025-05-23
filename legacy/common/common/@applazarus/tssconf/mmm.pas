unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Buttons, Menus, UniqueInstance, base64, Types,
  SQLite3Conn, SQLDB;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    lebaseip: TLabeledEdit;
    lebasepsw: TLabeledEdit;
    letransip: TLabeledEdit;
    lebaseport: TLabeledEdit;
    lebasename: TLabeledEdit;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PageControl1: TPageControl;
    paninfo: TPanel;
    Splitter1: TSplitter;
    bsqlconfig: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    db3tr: TSQLTransaction;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    timerstart: TTimer;
    UniqueInstance1: TUniqueInstance;
    procedure BitBtn1Click(Sender: TObject);
    procedure bsqlconfigAfterConnect(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lebasepswChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    function  readconfig:string;
    procedure prolog;
    procedure timerstartTimer(Sender: TObject);
    procedure todb3(sl:tstringlist);
    function  fupd(s:string):string;
    procedure log(c,txt:string);
    procedure readtbl;
    function  getslle:tstringlist;
    procedure rewriteconf;

  private

  public

  end;

var
  Form1: TForm1;
  ap,zp,app,appdir,appexe:string;
  gslle  :tstringlist;

implementation

{$R *.lfm}
uses uallog,ualfunc;


{ TForm1 }



procedure tform1.log(c,txt:string);
begin
     formallog.log(c,txt);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
      gslle :=tstringlist.Create;
      timerstart.Enabled:=true;

end;

function TForm1.readconfig:string;
var
 i:integer;
 le:TLabeledEdit;
 k,v,nm,s:string;
 q:tsqlquery;
 sl:tstringlist;
 begin
     showmessage('readconfig');
     sl:=tstringlist.Create;
     q:=tsqlquery.Create(self);
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
      log('l','k='+k+' /v='+v);
      q.next;

     end;



end;

procedure tform1.prolog;
var
  FileDateTime,s,pt :string;
begin
          ap:='''';
          zp:=',';
          appDir     := ExtractFilePath(FORMS.Application.ExeName);
          appExe     := ExtractFileName(FORMS.Application.ExeName);
          app        := ualfunc.ExtractStr(1,appexe,'.');
          FileDateTime := FormatDateTime('YYYY.MM.DD hh:mm:ss', FileDateToDateTime(FileAge(appExe)));
          s:='APP='+appexe +' VERSION='+filedatetime+' APPDIR='+APPDIR+app;
          caption:=S;
          //formallog.WindowState:=wsmaximized;
          //formallog.show;
          //form1.BringToFront;
          //s:=' start  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
          s:=' start 123456789999999999999999999999999999999999999999999!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
          log('l',s);
          pt:=appdir+'/config/altssconfig.db3';
          bsqlconfig.DatabaseName:=pt;
          bsqlconfig.Open;
          readtbl;


end;

procedure TForm1.timerstartTimer(Sender: TObject);
begin
       timerstart.Enabled:=false;
       prolog;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  fn:string;
begin
       {
      fn:=appdir+'config/alconfig.conf';
      lscg.values['leiptrans']:=base64.EncodeStringBase64(letransip.Text);
      lscg.values['leipbase'] :=base64.EncodeStringBase64(lebaseip.Text);
      lscg.values['lebaseport']:=base64.EncodeStringBase64(lebaseport.Text);
      lscg.values['lebasename']:=base64.EncodeStringBase64(lebasename.Text);
      lscg.values['lebasepsw']:=base64.EncodeStringBase64(lebasepsw.Text);
      lscg.SaveToFile(fn);
       }

end;

procedure TForm1.bsqlconfigAfterConnect(Sender: TObject);
begin
      log('l','openbase ok');
      paninfo.Color:=cllime;
      paninfo.caption:='есть доступ для конфигурации';
      getslle;
      log('l',gslle.text);
end;

procedure TForm1.readtbl;
var
  i:integer;
  nm,v,s:string;
  q:tsqlquery;
  le:TLabeledEdit;
begin
     //showmessage('readtbl='+gslle.text);
     q:=tsqlquery.Create(self);
     q.DataBase:=bsqlconfig;
     q.Transaction:=db3tr;
     for i:=0 to gslle.Count-1do begin
      nm:=gslle[i];
      q.SQL.Clear;
      s:='select key,value from config where key='+ap+nm+ap;
      log('w','s='+s);
      q.SQL.Add(s);
      q.Active:=true;
      le:=form1.FindSubComponent(nm) as TLabeledEdit;
      le.Text     :=base64.DecodeStringBase64(q.FieldByName('value').asstring);
      //le.Name:=nm;
      log('l','le.text='+le.text);
      q.Close;
     end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  fn:string;
begin
     {
      fn:=appdir+'config/alconfig.conf';
      lscg.LoadFromFile(fn);
      letransip.Text     :=base64.DecodeStringBase64(lscg.values['leiptrans']);
      lebaseip.text      :=base64.decodeStringBase64(lscg.Values['leipbase']);
      lebaseport.text    :=base64.decodeStringBase64(lscg.values['lebaseport']);
      lebasename.text    :=base64.decodeStringBase64(lscg.Values['lebasename']);
      lebasepsw.text     :=base64.decodeStringBase64(lscg.Values['lebasepsw']);
      }

end;

function tform1.getslle:tstringlist;
var
  i:integer;
   le:TLabeledEdit;
   sl:tstringlist;
   nm:string;
begin
       gslle.Clear;
       gslle.Sorted:=true;
       for i:=0 to form1.ComponentCount-1 do begin
       if components[i] is TLabeledEdit then begin
        nm:=components[i].Name;
        le:=form1.FindSubComponent(nm) as TLabeledEdit ;
          log('y',components[i].Name+'='+le.Text);
          gslle.Add(le.Name);

       end;
      end;
      result:=sl;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     readconfig;



end;

procedure tform1.todb3(sl:tstringlist);
var
i:integer;
lop:string;
apx,myid,ttg,adrpath,dbn,psw,tscd,k,s,v:string;
begin
        lop:=ap;
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

function Tform1.fupd(s:string):string;
var
 qrx: TSQLQuery;
 i:integer;
 da,ax,dx:string;
begin
      try
        result:='';
        s:=s+';';
        ax:=char(10);
        dx:=char(13);
        da:=dx+ax;
        log('w',s);
        bsqlconfig.Open;
        qrx:=TSQLQuery.Create(self);
        qrx.DataBase:=bsqlconfig;
        qrx.Transaction:=db3tr;
        db3tr.Active:=true;
        qrx.SQL.clear;
       // qrx.sql.Add(' begin  ');
        qrx.SQL.Add(s);
       // qrx.sql.Add(' commit   ');
       // qrx.sql.Add(' commit   ');
         for i:=0 to qrx.SQL.Count-1 do begin
          log('y',qrx.SQL[i]);
         end;
        qrx.ExecSQL;
        db3tr.Commit;

        qrx.SQL.Clear;
       // qrx.SQL.Add('commit');
        //qrx.ExecSQL;
        qrx.Close;
       // db3tr.Commit;
        bsqlconfig.Close(true);

        qrx.Free;
        result:='ok';
     except
        on e:exception do begin
        log('e','fupd,e='+e.Message);
        result:=e.Message;
        end;
       end;


end;


procedure TForm1.lebasepswChange(Sender: TObject);
begin

end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
     //
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  readtbl;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
     formallog.WindowState:=wsmaximized;
     formallog.show;
     form1.BringToFront;
end;

procedure TForm1.rewriteconf;
var
 i:integer;
 le:TLabeledEdit;
 v,nm,s:string;
 q:tsqlquery;
 begin
     //showmessage('REWRITE='+GSLLE.TEXT); 
     q:=tsqlquery.Create(self);
     q.DataBase:=bsqlconfig;
     q.Transaction:=db3tr;
          s:='delete from config';
          fupd(s);
          db3tr.Commit;
          for i:=0 to gslle.Count-1 do begin
            nm:=gslle[i];
            le:=form1.FindSubComponent(nm) as TLabeledEdit ;
            v:=base64.EncodeStringBase64(le.text);
            log('l','le.Name='+le.name+'='+le.Text+' /v='+v);
            s:='insert into config(key,value)values('+
            ap+nm+ap+zp+
            ap+v+ap+')';
            log('w',s);
            form1.fupd(s);
            db3tr.Commit;
          end;
 end;


procedure TForm1.MenuItem5Click(Sender: TObject);
begin
      rewriteconf;
end;

procedure TForm1.Panel3Click(Sender: TObject);
begin

end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin

end;

procedure TForm1.TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.

