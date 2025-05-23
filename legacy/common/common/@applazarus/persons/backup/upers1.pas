unit upers1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, ComCtrls, EditBtn, DBGrids, Menus, Types, SQLDB, memds, DB,
  laz.virtualtrees;

type

  { Tform_pers1 }

  Tform_pers1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbactkey: TCheckBox;
    cb_name1: TCheckBox;
    cb_name2: TCheckBox;
    cb_name3: TCheckBox;
    cb_name4: TCheckBox;
    cb_name5: TCheckBox;
    cd1: TDateEdit;
    cd2: TDateEdit;
    DBGrid2: TDBGrid;
    dsmdks: TDataSource;
    DBGrid1: TDBGrid;
    dsmd: TDataSource;
    DBNavigator4: TDBNavigator;
    le_start: TLabeledEdit;
    lb1: TListBox;
    MenuItem3: TMenuItem;
    le_stop: TLabeledEdit;
    le_updcdts: TLabeledEdit;
    le_fio: TEdit;
    le_crcdts: TLabeledEdit;
    le_root: TEdit;
    le_name1: TLabeledEdit;
    le_name2: TLabeledEdit;
    le_name3: TLabeledEdit;
    md: TMemDataset;
    mdks: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PageControl1: TPageControl;
    panact1: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Pan_name2: TPanel;
    Pan_name3: TPanel;
    Pan_name4: TPanel;
    Pan_name5: TPanel;
    Pan_name6: TPanel;
    POP1: TPopupMenu;
    popks: TPopupMenu;
    sb2: TStatusBar;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    ustatus: TLabeledEdit;
    procedure btupClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cd1Change(Sender: TObject);
    procedure cd2Change(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure dsmdDataChange(Sender: TObject; Field: TField);
    procedure dsmdksDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure lercChange(Sender: TObject);
    procedure le_stopChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure TabSheet3ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure viborka;
    function  selpersonsfromnode(cnd:pvirtualnode):string;
    procedure readkeys(myid:string);
  private

  public

  end;

var
  form_pers1: Tform_pers1;

implementation

{$R *.lfm}
uses umain,ulazfunc;

{ Tform_pers1 }


function Tform_pers1.selpersonsfromnode(cnd:pvirtualnode):string;
var

  biddtree,myid,s:string;
  qr:tsqlquery;
  ds,dsn:pvstrecord;
  dsxx:tnewds;
  nd:pvirtualnode;
  actual,fadmin:boolean;
  name1,name2,name3,pmyid,pbpkeys,dep,root,kluch,crcdts,updcdts,dmyid:string;
begin
     ds:=form1.vst.GetNodeData(cnd);
     myid:=inttostr(ds^.myid);
     dmyid:=myid;
     result:='';
     root:=ds^.nm0;
     dsxx.nm0:=timetostr(time);
     dsxx.sti:=-1;
     dsxx.sti1:=-1;
     dsxx.tag:=3;
     dsxx.ndcheck_state:=false;
     //SHOWMESSAGE('selpersonsfromnode 1');
    // form1.vst.Clear;

    s:='select inf.name3 ,inf.name1,inf.name2, inf.myid ,inf.bidkeys,d.name,'+
       ' inf.cr_cdts,inf,upd_cdts,inf.actual,inf.tmzname,inf.fadmin '+
       ' from  '+
       ' tsspsh_datatree    as d,'+
       ' tss_persinfo       as inf '+
       ' where '+
       ' d.myid='+dmyid+
       ' and inf.bidtree=d.myid '+
       ' order by inf.name3';
        //showmessage('s='+s);
     form1.log('r',s);
     //exit;
     qr:=form1.calcqr(s);
     form_pers1.md.Open;
     form_pers1.md.DisableControls;
     form_pers1.md.Clear(false);
     //clearmd(md);
     //showmessage('selpersonsfromnode 1');
     while not qr.eof do begin
     // showmessage('selpersonsfromnode 2');
      name3:=qr.Fields[0].AsString;
      //log('r','name3='+name3);
      name1:=qr.Fields[1].AsString;
      name2:=qr.Fields[2].AsString;
      pmyid:=qr.Fields[3].AsString;
      pbpkeys:=qr.Fields[4].AsString;
      dep  :=qr.Fields[5].AsString;
      kluch  :=qr.Fields[6].AsString;
      crcdts  :=qr.Fields[7].AsString;
      updcdts  :=qr.Fields[8].AsString;
      actual  :=qr.Fields[9].Asboolean;
      fadmin  :=qr.Fields[10].Asboolean;
    //  log('y','FIO='+name3+' '+name1+' '+name2);
     // dsxx.nm1:=name3+' '+name1+' '+name2;
      nd:=form1.fnna(cnd,dsxx);
      dsn:=form1.vst.GetNodeData(nd);
      dsn^.root:=root;
      dsn^.nm0:=name3+' '+name1+' '+name2;
     // dsn^.nm1:=timetostr(time);
      form_pers1.md.Insert;
      form_pers1.md.FieldByName('nn').AsInteger:=md.RecordCount+1;
      form_pers1.md.FieldByName('myid').AsInteger:=strtoint(pmyid);
      form_pers1.md.FieldByName('bpkeys').AsInteger:=strtoint(pbpkeys);
      form_pers1.md.FieldByName('biddtree').Asinteger:=strtoint(pmyid);
     // showmessage('AFTER');
      form_pers1.md.FieldByName('FIO').asstring:=name3+' '+name1+' '+name2;
      form_pers1.md.FieldByName('name1').asstring:=qr.FieldByName('name1').asstring;
      form_pers1.md.FieldByName('name2').asstring:=qr.FieldByName('name2').aSSTRING;
      form_pers1.md.FieldByName('name3').asstring:=qr.FieldByName('name3').asstring;
      form_pers1.md.FieldByName('kluch').asstring:=kluch;
      form_pers1.md.FieldByName('root').asstring:=ROOT;
      form_pers1.md.FieldByName('crcdts').asstring:=crcdts;
      form_pers1.md.FieldByName('updcdts').asstring:=updcdts;
      form_pers1.md.FieldByName('actual').asboolean:=actual;
      form_pers1.md.FieldByName('fadmin').asboolean:=fadmin;
      form_pers1.md.Post;
      qr.next;
     end;
      form_pers1.md.EnableControls;
      form_pers1.md.First;

end;



procedure Tform_pers1.Button2Click(Sender: TObject);
begin
        viborka;
end;

procedure Tform_pers1.btupClick(Sender: TObject);
begin

end;

procedure Tform_pers1.Button1Click(Sender: TObject);
var
  kluch,myid,s:string;
begin
      kluch:=mdks.FieldByName('kluch').AsString;
      myid:=md.FieldByName('myid').AsString;
      s:='update tss_keys set bppers='+myid +' where kluch='+ap+kluch+ap ;
      form1.log('l','s='+s);
      form1.selfupd(s);

end;

procedure Tform_pers1.cd1Change(Sender: TObject);
begin
      if not fstart then exit;
      le_start.Text:=datetostr(cd1.Date);
      mdks.Edit;
      mdks.FieldByName('start').AsString:=datetostr(cd1.Date);
      mdks.post;
      {
      mdks.Edit;
      mdks.FieldByName('start').asstring:=datetostr(cd1.Date);
      mdks.post;
      }
end;

procedure Tform_pers1.cd2Change(Sender: TObject);
begin
    if not fstart then exit;
    le_stop.Text:=datetostr(cd2.Date);
    mdks.Edit;
    mdks.FieldByName('stop').AsString:=datetostr(cd2.Date);
    mdks.post;

end;

procedure Tform_pers1.DBGrid1CellClick(Column: TColumn);
begin
        // form1.log('y','cellclick nm='+column.FieldName);
end;

procedure Tform_pers1.DBGrid2CellClick(Column: TColumn);
VAR
  myid,nm,kluch,code:string;
  cc:int64;
begin
      nm:=column.FieldName;
      myid:=(mdks.FieldByName('myid').asstring);
      form1.log('y','KEYS cellclick nm='+column.FieldName);
       form1.log('l','KEYS cellclick myid='+myid);
      if nm='kluch' then begin
        kluch:=trim(mdks.FieldByName('kluch').asstring);
        if kluch<>'' then begin
          kluch:=dmfunc.Azerol(kluch,12);
          cc:=dmfunc.skeytox(kluch);
          form1.log('l','KEYS !!!!!!!!!!!!!!!! cc=='+inttostr(cc));
          code:=inttostr(cc);
          mdks.Edit;
          mdks.FieldByName('code').AsInteger:=strtoint(code);
          mdks.FieldByName('kluch').Asstring:=kluch;
          mdks.FieldByName('bppers').Asinteger:=md.FieldByName('myid').AsInteger;
          mdks.post;
        end;
      end;
      {
       if nm='start' then begin
        cd1.Button.Click;
       end;
     }
end;

procedure Tform_pers1.readkeys(myid:string);
var
    qr:tsqlquery;
    s:string;
begin
       if not fstart then EXIT;
       //showmessage('PERS1 readkeys START');
       s:='select * from tss_keys where myid='+myid;
       form1.log('w','s='+s);
       mdks.Clear(false);
       qr:=form1.calcqr(s);
       while not qr.EOF do begin
        mdks.Insert;
        mdks.FieldByName('nn').AsInteger:=mdks.RecordCount+1;
        mdks.FieldByName('myid').AsInteger:=qr.FieldByName('myid').AsInteger;
        mdks.FieldByName('bppers').AsInteger:=qr.FieldByName('bppers').AsInteger;
        mdks.FieldByName('code').AsInteger:=qr.FieldByName('code').AsInteger;
        mdks.FieldByName('keypad').AsInteger:=qr.FieldByName('keypad').AsInteger;
        mdks.FieldByName('actual').Asboolean:=qr.FieldByName('actual').Asboolean;
        mdks.FieldByName('zapret').Asboolean:=qr.FieldByName('zapret').Asboolean;
        mdks.FieldByName('cause').Asstring:=qr.FieldByName('cause').Asstring;
        mdks.FieldByName('start').Asstring:=qr.FieldByName('start').Asstring;
        mdks.FieldByName('stop').Asstring:=qr.FieldByName('stop').Asstring;
        mdks.FieldByName('kluch').Asstring:=qr.FieldByName('kluch').Asstring;
        mdks.Post;
        qr.next;
       end;
       IF qr.RecordCount=0 then begin
          mdks.insert;
          mdks.FieldByName('bppers').AsInteger:=md.FieldByName('myid').AsInteger;
          mdks.Post;
       end;

end;

procedure Tform_pers1.dsmdDataChange(Sender: TObject; Field: TField);
var
 bpkeys:string;
begin
        if not fstart then EXIT;


        sb2.Panels[0].text:=inttostr(md.RecNo);
        sb2.Panels[1].text:=inttostr(md.Recordcount);
        le_fio.text:=md.FieldByName('fio').asstring;
        le_name1.text:=md.FieldByName('name1').asstring;
        le_name2.text:=md.FieldByName('name2').asstring;
        le_name3.text:=md.FieldByName('name3').asstring;
       // le_kluch.text:=md.FieldByName('kluch').asstring;
        le_root.text:=md.FieldByName('root').asstring;
        le_crcdts.text:=md.FieldByName('crcdts').asstring;
        le_updcdts.text:=md.FieldByName('updcdts').asstring;
        readkeys(md.FieldByName('bpkeys').asstring);
        // mdk.FieldByName('actual').AsBoolean;
        //form1.sbk.Panels[2].text:=' ТАБЛИЦА  " КЛЮЧИ "   ';
        //form1.le_kluch.text:=mdk.FieldByName('kluch').asstring;
        //form1.le_stop.text:=mdk.FieldByName('stop').asstring;
        //form1.le_start.text:=mdk.FieldByName('start').asstring;
        //form1.cbact.Checked:=mdk.FieldByName('actual').AsBoolean;

end;

procedure Tform_pers1.dsmdksDataChange(Sender: TObject; Field: TField);
var
 myid:string;
begin
       if not fstart then exit;
       myid:=(mdks.FieldByName('myid').asstring);
       if mdks.RecordCount=0 then begin
        ustatus.text:=' НЕОБХОДИМО добавить ключ ';
        ustatus.Color:=clred;
         exit;
       end;
       {
       mdks.Edit;
       mdks.FieldByName('bppers').asinteger:=md.FieldByName('myid').asinteger;
       mdks.post;
       }
        if myid='' then ustatus.text:=' возможно добавить ключ ' else ustatus.text:=' возможно обновить ключ';
        ustatus.Color:=cllime;

end;

procedure Tform_pers1.FormCreate(Sender: TObject);
begin
  
     le_stop.text:='2100-12-31';
     le_start.text:=datetostr(date);
end;

procedure Tform_pers1.lercChange(Sender: TObject);
begin

end;

procedure Tform_pers1.le_stopChange(Sender: TObject);
begin

end;

procedure Tform_pers1.MenuItem1Click(Sender: TObject);
begin
  //
end;

procedure Tform_pers1.MenuItem2Click(Sender: TObject);
var
bppers,kluch,code,myid,actual,zapret,s,rc:string;
cc:int64;
begin
      bppers:=trim(mdks.FieldByName('bppers').AsString);
      myid:=trim(mdks.FieldByName('myid').AsString);
      kluch:=trim(mdks.FieldByName('kluch').AsString);
      code:=trim(mdks.FieldByName('code').AsString);
      if code='' then code:=inttostr(dmfunc.skeytox(kluch));
      actual:=trim(mdks.FieldByName('actual').AsString);
      zapret:=trim(mdks.FieldByName('zapret').AsString);
      if actual='' then actual:='true';
      if zapret='' then zapret:='false';

      //showmessage('actual='+actual+'/zapret='+zapret);
      if kluch<>'' then begin
          kluch:=dmfunc.Azerol(kluch,12);
          cc:=dmfunc.skeytox(kluch);
          form1.log('l','KEYS !!!!!!!!!!!!!!!! cc=='+inttostr(cc));
          code:=inttostr(cc);
          mdks.Edit;
          mdks.FieldByName('code').AsInteger:=strtoint(code);
          mdks.post;
        end;

       if myid='' then begin
        s:='insert into tss_keys(bppers,kluch,code,start,stop,actual,zapret)values('+
        mdks.FieldByName('bppers').AsString+zp+
        ap+mdks.FieldByName('kluch').AsString+ap+zp+
        code+zp+
        ap+mdks.FieldByName('start').AsString+ap+zp+
        ap+mdks.FieldByName('stop').AsString+ap+zp+
        actual+zp+
        zapret+')';
        form1.log('y','????s='+s);
        rc:=form1.selfupd(s);
        lb1.clear;
          if rc<>'ok' then begin
          lb1.font.Color:=clred;
          lb1.Items.Add(rc);
         end
         else begin
          lb1.font.Color:=cllime;
          lb1.Items.Add(rc);
         end;
        readkeys(bppers);
       end;
       if myid<>'' then begin
         s:='update tss_keys set bppers='+  mdks.FieldByName('bppers').AsString+zp+
         ' kluch='+ap+mdks.FieldByName('kluch').AsString+ap+zp+
         ' code='+ mdks.FieldByName('code').AsString+zp+
         ' start='+ap+mdks.FieldByName('start').AsString+ap+zp+
         ' stop='+ap+mdks.FieldByName('stop').AsString+ap+zp+
         ' actual='+mdks.FieldByName('actual').AsString+zp+
         ' zapret='+mdks.FieldByName('zapret').AsString+
         ' where myid='+myid;
         form1.log('y',s);
         rc:=form1.selfupd(s);

         if rc<>'ok' then begin
          lb1.font.Color:=clred;
          lb1.Items.Add(rc);
         end
         else begin
          lb1.font.Color:=cllime;
          lb1.Items.Add(rc);
         end;

         readkeys(bppers);

       end;
  end;

procedure Tform_pers1.MenuItem3Click(Sender: TObject);
var
s,myid:string;
begin
      myid:= mdks.FieldByName('myid').AsString;
      s:='delete from tss_keys where myid='+myid;
      form1.selfupd(s);
      readkeys(myid);

end;

procedure Tform_pers1.PageControl1Change(Sender: TObject);
begin

end;

procedure Tform_pers1.Panel5Click(Sender: TObject);
begin

end;



procedure Tform_pers1.viborka;
var
 da,s,bpkeys,MYID,n1,n2,n3,fio,biddtree,infmyid,crcdts,updcdts,root:string;
 qrz:tsqlquery;
 l,x:integer;
 actual,fadmin:boolean;
begin
      try
         x:=1;
         //showmessage('viborka start');
         s:='select inf.name3,inf.name1,inf.name2,inf.myid,inf.bidkeys,inf.bidtree, '+
         ' inf.myid,inf.actual,inf.fadmin, inf.cr_cdts,inf.upd_cdts, inf.mrs,inf.tmzname'+
         ' from   tss_persinfo as inf '+
         ' order by inf.name3,inf.name1,inf.name2';


         form1.log('c','s='+s);
         qrz:=form1.calcqr(s);
         form1.log('y','AFTER='+s);
         form1.log('l','RC='+inttostr(qrz.RecordCount)) ;
         md.open;
         x:=2;

     md.DisableControls;
     //dmfunc.MyDelay(500);
     md.Clear(false);

     while not qrz.EOF do begin
      n3:=qrz.Fields[0].AsString;
      n1:=qrz.Fields[1].AsString;
      n2:=qrz.Fields[2].AsString;
      myid:=qrz.Fields[3].AsString;
      bpkeys:=qrz.Fields[4].AsString;
      biddtree:=qrz.Fields[5].AsString;
      infmyid:=qrz.Fields[6].AsString;
      actual:=qrz.Fields[7].Asboolean;
      fadmin:=qrz.Fields[8].Asboolean;
      crcdts:=qrz.Fields[9].AsString;
      updcdts:=qrz.Fields[10].AsString;
      //if fadmin then showmessage('n1='+n1);
      //form1.log('y','updcdts='+updcdts);
      x:=3;
      fio:=n3+' '+n1+' '+n2;
      //n1:=trim(qrz.FieldByName('g1.name1').AsAnsiString);
      //myid:=trim(qrz.FieldByName('myid').AsAnsiString);
     // s:=StringReplace(s, da, '',[rfIgnoreCase, rfReplaceAll]);

     //s:=dmfunc.deleteda(s);

     //bpkeys:=trim(qrz.FieldByName('bpkeys').AsAnsiString);

   //   log('y',s);
      x:=4;
      md.insert;
      md.FieldByName('nn').AsInteger:=md.RecordCount+1;
      md.FieldByName('bpkeys').AsAnsiString:=bpkeys;
      md.FieldByName('fio').AsAnsiString:=fio;
      md.FieldByName('myid').AsAnsiString:=myid;
      x:=5;
      md.FieldByName('biddtree').Asinteger:=strtoint(biddtree);
      md.FieldByName('infmyid').Asstring:=infmyid;
      md.FieldByName('fadmin').AsBoolean:=fadmin;
      md.FieldByName('actual').AsBoolean:=actual;
      md.FieldByName('crcdts').AsString:=crcdts;
      md.FieldByName('updcdts').AsString:=updcdts;
      md.FieldByName('name1').AsString:=n1;
      md.FieldByName('name2').AsString:=n2;
      md.FieldByName('name3').AsString:=n3;
      x:=6;
      md.post;
      qrz.Next;
     end;
     md.first;
     md.EnableControls;
    except
     on e: Exception do
       begin
      form1.log('e', 'button5,e=' + e.message + '/x=' + IntToStr(x));
      end;
    end;
//end;

end;

procedure Tform_pers1.TabSheet3ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.

