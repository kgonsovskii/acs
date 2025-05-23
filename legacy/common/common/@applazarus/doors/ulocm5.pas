unit ulocm5;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ValEdit,
  DBGrids, ExtCtrls, StdCtrls, Buttons,laz.virtualtrees,SQLDB,
  umain;

type

  { Tformlocm5 }

  Tformlocm5 = class(TForm)
    BitBtn1: TBitBtn;
    cbactual: TCheckBox;
    cbioflag: TCheckBox;
    cmb_rdrtype: TComboBox;
    cmb_pdriver: TComboBox;
    ed_actual: TEdit;
    ed_ioflag: TEdit;
    ed_rdrtype: TEdit;
    ed_tmr: TEdit;
    ed_tmr1: TEdit;
    ed_tmr2: TEdit;
    ed_tmr3: TEdit;
    etag2: TEdit;
    etag3: TEdit;
    ev_actual: TEdit;
    ev_ioflag: TEdit;
    ev_rdrtype: TEdit;
    ev_code: TEdit;
    ev_tmr: TEdit;
    ev_smrn: TEdit;
    ev_listlink: TEdit;
    keyp1: TPanel;
    keyp2: TPanel;
    keyp3: TPanel;
    keyp4: TPanel;
    keyp5: TPanel;
    keyp6: TPanel;
    keyp7: TPanel;
    lb1: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    procedure ApplicationProperties1Activate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbactualChange(Sender: TObject);
    procedure cbioflagChange(Sender: TObject);
    procedure cmb_rdrtypeChange(Sender: TObject);
    procedure dbgCellClick(Column: TColumn);
    procedure dbgColEnter(Sender: TObject);
    procedure dbgEnter(Sender: TObject);
    procedure ds1DataChange(Sender: TObject; Field: TField);
    procedure ev_ioflagChange(Sender: TObject);
    procedure ev_codeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fillgrid;
    procedure prepare(dl:pvstrecordloc);
    procedure updloc5(myid:integer);
    procedure readandsave;
  private

  public

  end;

var
  formlocm5: Tformlocm5;
  dataloc  :pvstrecordloc;
  currmyid,currcode :integer;
  slc:tstringlist;

implementation

{$R *.lfm}
uses uglink;

{ Tformlocm5 }

procedure Tformlocm5.readandsave;
var
s:string;
myid:integer;
begin
     myid:=currmyid;
     slc.values['smrn']:=ev_smrn.text;
       IF ev_code.text='1' then begin
       if form1.yesno('Задать это состояния (CKP,IOFLAG) для всех сенслров этой группы ( ПОКА В ОТЛАДКЕ !!!!!!!!!!!!) ???') then begin
        showmessage('TUT') ;
       end;

      end;


     if  cbactual.Checked then  slc.Values['actual']:='True' else slc.Values['actual']:='False';
     if  cbioflag.Checked then  slc.Values['ioflag']:='True' else slc.Values['ioflag']:='False';

     slc.values['tmr']:=ev_tmr.text;
     slc.values['rdrtype']:=cmb_rdrtype.text;
     slc.values['pdriver']:=cmb_pdriver.text;
     slc.values['listlink']:=ev_listlink.text;
     if myid>0 then begin
      s:='update tssloc_locations set smrn='+ap+slc.Values['smrn']+ap+zp+
         ' actual='+slc.Values['actual']+zp+
         ' ioflag='+slc.Values['ioflag']+zp+

         ' tmr='+slc.Values['tmr']+zp+
         ' rdrtype='+ap+slc.Values['rdrtype']+ap+zp+
         ' listlink='+ap+slc.Values['listlink']+ap+
         ' where myid='+inttostr(myid);
         form1.log('w',s);
         s:=form1.selfupd(s);
         if s<>'ok'then begin
          lb1.Font.color:=clred;
          lb1.Items.Add(s +'       '+datetimetostr(now));
         end
         else begin
         lb1.Font.color:=cllime;
          lb1.Items.Add(s +'       '+datetimetostr(now));
         end;

     end;


     //form1.log('y','actual='+slc.Values['actual']);
     //form1.log('y','ioflag='+slc.Values['ioflag']);

end;
procedure Tformlocm5.updloc5(myid:integer);
var
  qrz: TSQLQuery;
  s: string;
  n: integer;

begin
 try
   currmyid:=myid;
   form1.log('c', 'myid=' + inttostr(myid));
   formlocm5.Show;
   formlocm5.left:=0;
   formlocm5.top:=0;
   if myid=-1 then begin
    readandsave;
   end;
    s := 'select * from  tssloc_locations where myid='+inttostr(myid) ;
    form1.log('y', 'gsel=' + s);
    qrz := TSQLQuery.Create(self);
    qrz.DataBase := formglink.pqc1;
    qrz.SQL.Clear;
    qrz.SQL.Add(s);
    qrz.Active:=true;
    slc.Values['code']:=qrz.FieldByName('code').asstring;
    ev_code.text:=qrz.FieldByName('code').asstring;
    currcode:=strtoint(ev_code.text);
    slc.Values['ioflag']:=qrz.FieldByName('ioflag').asstring;
    slc.Values['fckp']:=qrz.FieldByName('fckp').asstring;
    cbactual.Checked:=qrz.FieldByName('actual').asboolean;
    cbioflag.Checked:=qrz.FieldByName('ioflag').asboolean;
    slc.Values['tmr']:=qrz.FieldByName('tmr').asstring;
    slc.Values['tmr']:=qrz.FieldByName('tmr').asstring;
    slc.values['smrn']:=qrz.FieldByName('smrn').asstring;;
    slc.values['rdrtype']:=qrz.FieldByName('rdrtype').asstring;
    slc.values['pdriver']:=qrz.FieldByName('pdriver').asstring;
    slc.values['listlink']:=qrz.FieldByName('listlink').asstring;
    ev_listlink.text:=qrz.FieldByName('listlink').asstring;
    slc.values['smrn']:=qrz.FieldByName('smrn').asstring;
    ev_smrn.text:=qrz.FieldByName('smrn').asstring;
    cmb_rdrtype.text:=qrz.FieldByName('rdrtype').asstring;
    slc.values['rdrtype']:=qrz.FieldByName('rdrtype').asstring;
    if  slc.values['rdrtype']='rdrstd' then ev_rdrtype.text:='стандарт';
    if  slc.values['rdrtype']='rdrpad' then ev_rdrtype.text:='стандарт+пад';
    if  slc.values['rdrtype']='crdr'   then ev_rdrtype.text:='контрольный';
   exit;
  except
    on ee: Exception do
    begin
      form1.log('e', 'updloc5 ,ee=' + ee.Message);
    end;

 end;
end;

procedure Tformlocm5.prepare(dl:pvstrecordloc);
var
 pnd:pvirtualnode;
 dlp:pvstrecordloc;
 nm2,nm3:string;
begin
         pnd:=dl^.ndp;
         dlp:=form1.vstloc.GetNodeData(pnd);
         {
         nm2:=dlp^.NM0;
         etag2.text:=dlp^.NM0;
         etag3.Text:=dl^.nm0;
         nm3:= dl^.nm0;
         form1.log('r','nm2='+nm2);
         form1.log('r','nm3='+nm3);
         etag2.Text:=nm2;
         etag3.Text:=nm3;
         }
         formlocm5.Show;
end;

procedure Tformlocm5.fillgrid;
var
  i:integer;
begin
       {
         md.open;
         MD.Clear(FALSE);
         md.Insert;
         md.FieldByName('descr').AsString:='ПРОХОДНАЯ';
         md.FieldByName('fname').AsString:='fckp';
         md.FieldByName('vb').Asboolean:=false;
         md.Insert;
         md.FieldByName('descr').AsString:='ВХОД - ВЫХОД';
         md.FieldByName('fname').AsString:='ioflag';
         md.FieldByName('vb').Asboolean:=false;

         md.Post;
         MD.First;
         }

end;

procedure Tformlocm5.FormCreate(Sender: TObject);
begin
     slc:=tstringlist.Create;
end;

procedure Tformlocm5.ApplicationProperties1Activate(Sender: TObject);
begin

end;

procedure Tformlocm5.BitBtn1Click(Sender: TObject);
begin
      form1.log('l','oooooooooooooooooooooooook');
      readandsave;

end;

procedure Tformlocm5.Button1Click(Sender: TObject);
begin

end;

procedure Tformlocm5.cbactualChange(Sender: TObject);
begin
        if  cbactual.Checked then ev_actual.text:='Актуально' else ev_actual.text:='НЕ актуально';
end;

procedure Tformlocm5.cbioflagChange(Sender: TObject);
begin
      if  cbioflag.Checked then ev_ioflag.text:='Вход' else ev_ioflag.text:='Выход';

end;

procedure Tformlocm5.cmb_rdrtypeChange(Sender: TObject);
begin
    if  cmb_rdrtype.text='rdrstd' then ev_rdrtype.text:='стандарт';
    if  cmb_rdrtype.text='rdrpad' then ev_rdrtype.text:='стандарт+пад';
    if  cmb_rdrtype.text='crdr'   then ev_rdrtype.text:='контрольный';
end;

procedure Tformlocm5.dbgCellClick(Column: TColumn);
VAR
  fn,cn:string;
begin
       {
         fn:=md.FieldByName('fname').asstring ;
         cn:=column.FieldName ;
         form1.log('l','fn='+fn+'/cn='+cn);
         md.Edit;
         if (fn='fckp') and (cn='vb') and (md.FieldByName('vb').AsBoolean)=TRUE then begin

          md.FieldByName('comment').AsString:='ПРОХОДНАЯ';
         // MD.Refresh;
          form1.log('l','ttttttttttttttttttttttttttttttttttttttttttttttttt');
         end;
           if (fn='fckp') and (cn='vb') and (md.FieldByName('vb').AsBoolean)=FALSE then begin
          md.FieldByName('comment').AsString:='НЕТ ПРОХОДНОЙ';

          //MD.Refresh;
          form1.log('l','ttttttttttttttttttttttttttttttttttttttttttttttttt');
         end;
         MD.Post;

     }

end;

procedure Tformlocm5.dbgColEnter(Sender: TObject);
begin


end;

procedure Tformlocm5.dbgEnter(Sender: TObject);
begin

end;

procedure Tformlocm5.ds1DataChange(Sender: TObject; Field: TField);
begin

end;

procedure Tformlocm5.ev_ioflagChange(Sender: TObject);
begin

end;

procedure Tformlocm5.ev_codeChange(Sender: TObject);
begin

end;

end.

