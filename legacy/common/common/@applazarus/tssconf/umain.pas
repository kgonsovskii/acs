unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, DBGrids, Menus, Buttons, DBCtrls, ComboEx, Types,
  base64, SQLite3Conn, SQLDB, PQConnection, memds, DB;


type tsabl=record
     descr:string;
     nmf  :string;
     tag  :string;
    end;

type tarcfile=record
     nn:integer;
     nm:string;
     sz:string;
    end;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    cmb: TComboBox;
    dbg: TDBGrid;
    DBNavigator2: TDBNavigator;
    ds1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    dsmdbr: TDataSource;
    enmf: TEdit;
    etag: TEdit;
    edescr: TEdit;
    efn: TEdit;
    learcpath: TLabeledEdit;
    lebasepsw: TLabeledEdit;
    letransip: TLabeledEdit;
    lebaseip: TLabeledEdit;
    lebasename: TLabeledEdit;
    lebaseuser: TLabeledEdit;
    lebaseport: TLabeledEdit;
    mdbr: TMemDataset;
    md: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    pgc1: TPageControl;
    Panel1: TPanel;
    Panel4: TPanel;
    panshab1: TPanel;
    paninfo: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    popmdbr: TPopupMenu;
    postgc: TPQConnection;
    sd: TSelectDirectoryDialog;
    Splitter1: TSplitter;
    bsqlconfig: TSQLite3Connection;
    db3tr: TSQLTransaction;
    sb1: TStatusBar;
    tr1: TSQLTransaction;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    timerstart: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure bsqlconfigAfterConnect(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure cmbChange(Sender: TObject);
    procedure cmbClick(Sender: TObject);

    procedure cmbDblClick(Sender: TObject);
    procedure dsmdbrDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure pgc1Change(Sender: TObject);
    procedure postgcAfterConnect(Sender: TObject);
    procedure postgcAfterDisconnect(Sender: TObject);


    procedure prolog;
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure timerstartTimer(Sender: TObject);
    procedure log(c,txt:string);
    function  getslle:tstringlist;
    procedure readtbl;
    procedure todb3(sl:tstringlist);
    function  fupd(s:string):string;
    procedure rewriteconf;
    function  readconfig:string;
    function  fcrfn:string;
    function  formirarcl(s:string):tarcfile;
    procedure rereadarclist;
    procedure pdump;
    function  freadfld(line:string):string;
    function  getqr(line:string):TSQLQuery;
    function  selfupd(s: string): string;
    procedure readshb;
    procedure readtblsablons;
    procedure openpgc;
  //private

  public

  end;

var
  Form1: TForm1;
  sabl   :tsabl;
  gslle  :tstringlist;
  ptbase,ap,app,appexe,appdir,zp:string;


implementation

{$R *.lfm}
uses uallog,ualfunc,ueditnewshab;

{ TForm1 }


function TForm1.selfupd(s: string): string;
var
  qrz: TSQLQuery;
  f:boolean;
begin
  try
    Result := 'ok';
    f:=false;
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := postgc;
    tr1.DataBase := postgc;
    qrz.SQL.Clear;
    qrz.SQL.Add(' begin; ');
    qrz.SQL.Add(s + ' ;');
    qrz.SQL.Add(' commit;');
    qrz.Transaction :=tr1;
    try
      qrz.ExecSQL;
      f:=true;
      tr1.Commit;
    except
     on e: Exception do
      begin
       tr1.Rollback;
       log('e', 'selfuppd 1,e=' + e.Message);
       Result := e.Message;
       exit;
     end;
    end;
    if f then tr1.Commit;
    log('w', 'selfuppd AFTER COMMIT');
  except
    on e: Exception do
    begin
      log('e', 'selfuppd,e=' + e.Message);
      Result := e.Message;
    end;
  end;

end;



function  tform1.freadfld(line:string):string;
var
  qrz: TSQLQuery;
  s: string;
begin
   try
    qrz := TSQLQuery.Create(nil);
    qrz.DataBase := postgc;
    qrz.SQL.Clear;
    qrz.SQL.Add(line);
    qrz.Active := True;
    result:=qrz.Fields[0].AsString;
   except
       on ee: Exception do
       begin
        log('e', 'freadfld ,ee=' + ee.Message);
        result:='?';
      end;
    end;


end;



function  tform1.getqr(line:string):TSQLQuery;
var
  qrz: TSQLQuery;
  s: string;
begin
   try
    qrz := TSQLQuery.Create(nil);
    qrz.DataBase := postgc;
    qrz.SQL.Clear;
    qrz.SQL.Add(line);
    qrz.Active := True;
    result:=qrz
   except
       on ee: Exception do
       begin
        log('e', 'freadfld ,ee=' + ee.Message);
        result:=nil;
      end;
    end;


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
     result:=sl.text;



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




procedure tform1.log(c,txt:string);
begin
        formallog.log(c,txt);
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
     // SHOWMESSAGE(LE.TEXT);
      log('l','le.text='+le.text);
      q.Close;
     end;

end;

function tform1.formirarcl(s:string):tarcfile;
var
  add,sn,sz,nm,ss:string;
  af:tarcfile;
begin


 //   -rw-r--r-- 1 root root 304K ноя 20 08:03 pg2023_11_20__08:03:34.backup

    // af.nn:=strtoint(ualfunc.ExtractStr(2,s,' '));
     af.sz:=ualfunc.ExtractStr(5,s,' ');
     af.nm:=ualfunc.ExtractStr(9,s,' ');
   //  add:=ualfunc.ExtractStr(11,s,' ');
  //log('l','sn='+sn+zp+''sz+zp+nm);
    // ss:='NN='+sn+zp+'nm='+nm+zp+'sz='+sz;
     result:=af;
end;

procedure tform1.prolog;
var
  i:integer;
  FileDateTime,s,pt,ts,cmd,ss :string;
  DataInf   : TSearchRec;
  sl:tstringlist;
  af:tarcfile;
begin

         // showmessage('ts='+ts);
          timerstart.Enabled:=false;
          ap:='''';
          zp:=',';
          appDir     := ExtractFilePath(FORMS.Application.ExeName);
          appExe     := ExtractFileName(FORMS.Application.ExeName);
          app        := 'tssconf';

          FindFirst(appdir,faAnyfile,DataInf);
          ualfunc.MyDelay(500);

          ts:= FormatDateTime('yyyy-mm-dd   hh:mm',datainf.TimeStamp );

          ///showmessage('ts='+ts);
          //fileage(appexe);
          //ts:= FormatDateTime('dd.mm.yyyy hh:mm',FileDateToDateTime(DataInf.Time));
          s:=' ВЕРСИЯ ОТ ='+ts;
          caption:=s;
          //formallog.WindowState:=wsmaximized;
          //formallog.show;
          form1.BringToFront;

          log('l',s );
          log('l',s+' ' );
          ptbase:=appdir+'/config/altssconfig.db3';

          bsqlconfig.DatabaseName:=ptbase;
          bsqlconfig.Open;

          readtbl;
           form1.openpgc;



end;

procedure tform1.rereadarclist;
var
i:integer;
 FileDateTime,s,pt,ts,cmd,ss :string;
 DataInf   : TSearchRec;
 sl:tstringlist;
 af:tarcfile;
begin
          mdbr.Clear(false);
         {
          for i:=1 to 10 do begin
           mdbr.Insert;
           mdbr.FieldByName('nn').AsInteger:=mdbr.RecordCount+1;
           mdbr.post;
          end;
         }
          mdbr.First;
          pt:=appdir+'lsarc.txt';
          cmd:='ls -l -h '+learcpath.Text+'/*.backup '+'>'+pt;
          ualfunc.vagoloapprun(cmd);
          log('r','cmd='+cmd);
          sl:=tstringlist.Create;
          sl.LoadFromFile(pt);
          for i:=0 to sl.Count-1 do begin;
           if length(trim(sl[i]))>20 then begin
            af:=formirarcl(sl[i]);
            if length(trim(af.nm))>20 then begin

             mdbr.Insert;
             mdbr.FieldByName('nn').AsInteger:=mdbr.RecordCount+1;
             mdbr.FieldByName('fn').Asstring:=af.nm;
             mdbr.FieldByName('sz').Asstring:=af.sz;
             mdbr.post;
            end;


           end;
          end;

end;

procedure TForm1.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.timerstartTimer(Sender: TObject);
begin
      timerstart.enabled:=false;
      prolog;
end;



procedure TForm1.Button1Click(Sender: TObject);
begin
    formallog.Show;
    formallog.WindowState:=wsmaximized;
    form1.BringToFront;
end;

procedure TForm1.bsqlconfigAfterConnect(Sender: TObject);
begin
log('l','openbase ok');
      paninfo.Color:=cllime;
      paninfo.caption:='есть доступ для конфигурации';
      log('l','есть доступ для конфигурации');
      getslle;
      log('l',gslle.text);
end;

procedure TForm1.readtblsablons;
var
 i:integer;
pt:string;
sl:tstringlist;
begin
    sl:=tstringlist.Create;
    pt:=appdir+'/config/tblsablons.txt';
    sl.LoadFromFile(pt);
    cmb.Items.Clear;
    cmb.Items.LoadFromFile(pt);
    cmb.ItemIndex:=-1;

end;

procedure TForm1.Button10Click(Sender: TObject);
begin
   readtblsablons;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
tbl,ttg,myid:string;
begin
       formeditnewshab.Show;
       tbl:=trim(enmf.Text);
       ttg:=trim(etag.Text);
       myid:='';
       if myid='' then  formeditnewshab.prepare(tbl,ttg,0)
       else  formeditnewshab.prepare(tbl,ttg,4174);



end;

function tform1.fcrfn:string;
var
  cd,ct:string;
begin
     cd:=FormatDateTime('yyyy_mm_dd', now);
     ct:=FormatDateTime('hh:mm:ss', now);
     efn.text:='pg'+cd+'__'+ct+'.backup';
     result:=efn.Text;

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin


     sd.Execute;
     learcpath.Text:=sd.FileName;
     //ct:=FormatDateTime('hh_mm', now);
     //learclastfile.text:='pg'+cd+'__'+ct+'.backup';

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
      form1.rewriteconf;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
       readtbl;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  sl:tstringlist;
begin
      sl:=tstringlist.Create;
      sl.Text:=readconfig;
      showmessage('rf='+sl.text);
end;

procedure tform1.pdump;
var
cmd,s,sn,sz,nm,add,fc:string;
n:integer;
sl:tstringlist;
begin
// pg_dump  --dbname=postgresql://postgres:postgres@127.0.0.1:5432/postgres -c -Fc>/home/gonso/common/@arc/lastgonso.backup
efn.text:=form1.fcrfn;
cmd:='pg_dump  --dbname=postgresql://'+trim(lebasename.Text)+':'+trim(lebasepsw.text)+'@'+
trim(lebaseip.text)+':'+trim(lebaseport.text)+'/postgres -c -Fc>'+learcpath.text+'/'+efn.text;
sl:=tstringlist.Create;
sl.Add(cmd);
log('y','cmd='+cmd);
fc:=appdir+'arcb.sh';
log('y','fc='+fc);
sl.SaveToFile(fc);
s:='chmod +x '+fc;
ualfunc.vagoloapprun(s);
//ualfunc.MyDelay(100);
ualfunc.vagoloapprun(fc);

// s:='-rw-r--r-- 1 root root 243K ноя  5 03:35 base-2023-11-05 нояour.zip';
sn:=ualfunc.ExtractStr(2,s,' ');
sz:=ualfunc.ExtractStr(5,s,' ');
nm:=ualfunc.ExtractStr(10,s,' ');
add:=ualfunc.ExtractStr(11,s,' ');
//log('l','sn='+sn+zp+''sz+zp+nm);
log('l','NN='+sn+zp+'nm='+nm+add+zp+'sz='+sz);
rereadarclist;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
s,ss:string;
 begin
     s:='\xd0\xb6\xd0\xb5\xd0\xbd\xd1\x8f';
     s:='женя';
     ss:=system.UTF8Encode(s);
     log('l','ss='+ss);
end;

procedure TForm1.readshb;
var
s,cname,descr,tbl,tbln,ttg,typ,pcl,dflt:string;
qrx:TSQLQuery;
begin

     md.open;
     tbl:=trim(enmf.text);
     ttg:=trim(etag.text);
     if ttg='' then s:='select * from tss_tblpatterns';
     if ttg<>'' then s:='select * from tss_tblpatterns where tblname='+ap+tbl+ap+' and tag='+ttg;
     log('l','s='+s);
     //showmessage('s='+s);


       qrx:=form1.getqr(s);
       md.Clear(false);
       while not qrx.EOF do begin
        tbln:=qrx.FieldByName('tblname').AsString;
        cname:=qrx.FieldByName('cname').AsString;
        descr:=qrx.FieldByName('descr').AsString;
        ttg:=qrx.FieldByName('tag').AsString;
        typ:=qrx.FieldByName('typ').AsString;
        pcl:=qrx.FieldByName('picklist').AsString;
        dflt:=qrx.FieldByName('dflt').AsString;

        md.Insert;
        md.FieldByName('nn').Asinteger:=md.RecordCount+1;
        md.FieldByName('cname').AsString:=cname;
        md.FieldByName('descr').AsString:=descr;
        md.FieldByName('typ').AsString:=typ;
        md.FieldByName('pcl').AsString:=pcl;
        md.FieldByName('dflt').AsString:=dflt;
        try
         md.FieldByName('tag').Asinteger:=strtoint(ttg);
        except
        end;
        md.post;
        log('y','cname='+cname+' ,descr='+descr);
        qrx.next;
       end;




end;

procedure TForm1.openpgc;
var
s,cname,descr,ttg:string;
qrx:TSQLQuery;
begin

       postgc.CharSet:='utf8';
       postgc.HostName:=trim(lebaseip.text);
       postgc.DatabaseName:=trim(lebasename.text);
       postgc.UserName:=trim(lebaseuser.Text);
       postgc.Password:=trim(lebasepsw.Text);
       postgc.Connected:=true;
 end;


procedure TForm1.Button6Click(Sender: TObject);
begin
     openpgc;


end;

procedure TForm1.Button7Click(Sender: TObject);
var
s,cname,descr,typ,pcl,dflt,tbl,ttg:string;
begin

      md.Open;
      md.First;

      tbl:=trim(enmf.text);
      ttg:=trim(etag.text);
      showmessage('tbl='+tbl);
      if ttg='' then  s:='delete from tss_tblpatterns where tblname='+ap+tbl+ap;
      if ttg<>'' then s:='delete from tss_tblpatterns where tblname='+ap+tbl+ap +' and tag='+ttg;
      selfupd(s);
      while not md.EOF do begin;
       cname:=md.FieldByName('cname').AsString;
       descr:=md.FieldByName('descr').AsString;
       typ  :=md.FieldByName('typ').AsString;
       pcl  :=md.FieldByName('pcl').AsString;
       dflt :=md.FieldByName('dflt').AsString;
       if ttg='' then  begin
        s:='insert into tss_tblpatterns(typ,picklist,dflt,tblname,cname,descr)values('+
        ap+typ+ap+zp+
        ap+pcl+ap+zp+
        ap+dflt+ap+zp+
        ap+tbl+ap+zp+
        ap+cname+ap+zp+
        ap+descr+ap+')';
        log('y','s='+s);
       end;
       if ttg<>'' then  begin
        s:='insert into tss_tblpatterns(typ,picklist,dflt,tblname,cname,descr,tag)values('+
        ap+typ+ap+zp+
        ap+pcl+ap+zp+
        ap+dflt+ap+zp+
        ap+tbl+ap+zp+
        ap+cname+ap+zp+
        ap+descr+ap+zp+
        ttg+
        ')';
       end;
       selfupd(s);
       md.Next;
      end;

end;

procedure TForm1.Button8Click(Sender: TObject);
begin
      readshb;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
n:integer;
c:tcolumn;
begin
     //n:=(dbg.Columns.ColumnByFieldname('cname');


     formeditnewshab.show;
     //dbg.Columns[1].PickList:=tstringlist.Create;
     //dbg.Columns[1].PickList.Add('true');
     //dbg.Columns[1].PickList.Add('false');
end;

procedure TForm1.cmbChange(Sender: TObject);
var
s:string;
begin
        log('y','cmbONCHANGE  '+cmb.text);


     edescr.text:=' ';
     enmf.text  :=' ';
     etag.text  :=' ';

     s:=cmb.text;
     edescr.text:=trim(ualfunc.ExtractStr(1,s,','));
     enmf.text  :=trim(ualfunc.ExtractStr(2,s,','));
     etag.text  :=trim(ualfunc.ExtractStr(3,s,','));

end;

procedure TForm1.cmbClick(Sender: TObject);
var
s,s1,s2,s3:string;
begin
     showmessage('cmbclick TEXT====='+cmb.text);
     log('y','cmbclick  ');
     edescr.text:=' ';
     enmf.text  :=' ';
     etag.text  :=' ';

     s:=cmb.text;
     edescr.text:=trim(ualfunc.ExtractStr(1,s,','));
     enmf.text  :=trim(ualfunc.ExtractStr(2,s,','));
     etag.text  :=trim(ualfunc.ExtractStr(3,s,','));


end;



procedure TForm1.cmbDblClick(Sender: TObject);
var
s,s1,s2,s3:string;
begin
     showmessage('cmDBLbclick');
     log('y','cmbChange  ');
     edescr.text:=' ';
     enmf.text  :=' ';
     etag.text  :=' ';

     s:=cmb.text;
     edescr.text:=trim(ualfunc.ExtractStr(1,s,','));
     enmf.text  :=trim(ualfunc.ExtractStr(2,s,','));
     etag.text  :=trim(ualfunc.ExtractStr(3,s,','));

end;

procedure TForm1.dsmdbrDataChange(Sender: TObject; Field: TField);
begin

        sb1.panels[0].text:=inttostr(mdbr.RecNo);
        sb1.panels[1].Text:=inttostr(mdbr.Recordcount);
        sb1.Panels[2].text:=mdbr.FieldByName('fn').asstring;

end;

procedure TForm1.FormCreate(Sender: TObject);

begin
     gslle  :=tstringlist.create;
     timerstart.enabled:=true;

     efn.text:=fcrfn;

end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
      pdump;

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
      form1.rereadarclist;
end;

procedure TForm1.pgc1Change(Sender: TObject);
var
n:integer;
acp:string;
begin
      n:=pgc1.ActivePageIndex;
      acp:=trim(pgc1.ActivePage.Caption);
      //if acp='Шаблоны' then showmessage('acp='+acp);
      log('l','PageControl1Change acp='+acp+',n='+inttostr(n));



end;

procedure TForm1.postgcAfterConnect(Sender: TObject);
begin
     panshab1.Color:=cllime;
     readtblsablons;
end;

procedure TForm1.postgcAfterDisconnect(Sender: TObject);
begin

end;

end.

