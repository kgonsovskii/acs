unit usyslog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, memds, Forms, Controls, Graphics, Dialogs, DBGrids,
  Grids, Menus, fpjson, jsonparser;

type

  { Tformsyslog }

  Tformsyslog = class(TForm)
    dbg: TDBGrid;
    ds1: TDataSource;
    mdl: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    pop1: TPopupMenu;
    procedure dbgDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
   //procedure  log(pr,comp,ch,kluch:string);
   procedure  log(v:string);
   procedure  clearlog;
   procedure MenuItem1Click(Sender: TObject);
   procedure MenuItem2Click(Sender: TObject);
  private

  public

  end;

var
  formsyslog: Tformsyslog;

implementation


{$R *.lfm}
uses umain,uemul;

{ Tformsyslog }
procedure Tformsyslog.clearlog;
begin
      mdl.First;
      mdl.DisableControls;
      while not mdl.EOF do begin;
       mdl.Edit;
       mdl.Delete;
      end;
      try
       mdl.post;
      except
      end;
      mdl.EnableControls;
end;



procedure Tformsyslog.MenuItem1Click(Sender: TObject);
begin
       formsyslog.top:=0;
       formsyslog.left:=0;
       formsyslog.show;
       formsyslog.BringToFront;
       formsyslog.FormStyle:=fsSystemStayOnTop;

end;

procedure Tformsyslog.MenuItem2Click(Sender: TObject);
begin
       formsyslog.show;
       //formsyslog.BringToFront;
       formsyslog.FormStyle:=fsnormal;
end;

procedure Tformsyslog.log(v:string);
var
jb:TJSONObject;
jd:tjsondata;
  pt,pr,sj,sens,iof,bidlocparent:string;
  sl:tstringlist;
begin
        try
         form1.log('c','SYSLOG V='+v);
         jd:=GETJSON(v);
         jb:=tjsonobject(jd);
         sj:=jd.FormatJSON;

         sl:=tstringlist.Create;
         try sl.Values['sens']  :=jb.Get('sens') except end;
         sens:=sl.Values['sens'] ;

         caption:=sl.Values['sens']+timetostr(time);
         try sl.Values['ch']    :=jb.Get('rpcchname') except end;
         try sl.Values['bidlocparent']    :=jb.Get('bidlocparent') except end;
         form1.log('l','BIDLOCPARENT='+sl.Values['bidlocparent']);
         try sl.Values['ac']    :=jb.Get('ac'); except end;
         try sl.Values['port']  :=jb.Get('port'); except end;
         try sl.values['duralg']:= jb.Get('duralg') except end;
         try sl.values['cerr']:= jb.Get('cerr') except end;
         try sl.values['abrv']:= jb.Get('abrv') except end;
         try sl.values['locat']:= jb.Get('locat') except end;
         try sl.values['delta']:= jb.Get('delta') except end;
         try sl.values['bidsens']:= jb.Get('bidsens') except end;
         try sl.values['ioflag']:= jb.Get('ioflag') except end;
         try sl.values['kpx']:= jb.Get('kpx') except end;

         try
          sl.Values['kluch'] :=jb.Get('kluch');
         except end;
          pr:='w';
          if sl.Values['sens']='key'   then begin
           pr:='l';
            sl.Values['fio']  :=jb.Get('fio');
          end;
          if sl.Values['sens']='open'  then pr:='y';
          if sl.Values['sens']='close' then pr:='c';
          if sl.Values['sens']='rte'   then pr:='m';
          if sl.Values['locat']='undef'   then pr:='w';
           if (sl.Values['sens']='key')  and (sl.Values['cerr']<>'0') then begin
           pr:='r';
           end;

          FORM1.log('w','ABRV=----------------------------'+  sl.Values['abrv']);
          mdl.open;
          mdl.Insert;
          if mdl.RecordCount>= 100 then Clearlog;
          mdl.FieldByName('nn').asinteger:=mdl.RecordCount+1;
          mdl.FieldByName('pr').asstring:=pr;
         // mdl.FieldByName('comp').asstring:=comp;
          mdl.FieldByName('ch').asstring:=sl.Values['ch'];
          mdl.FieldByName('kpx').asstring:=sl.Values['kpx'];
          mdl.FieldByName('kluch').asstring:=sl.Values['kluch'];
          mdl.FieldByName('ac').asstring:=sl.Values['ac'];
          mdl.FieldByName('port').asstring:=sl.Values['port'];
          mdl.FieldByName('sens').asstring:=sl.Values['sens'];
          mdl.FieldByName('fio').asstring:=sl.Values['fio'];
          mdl.FieldByName('locat').asstring:=sl.Values['locat'];
          mdl.FieldByName('delta').asstring:=sl.Values['delta'];
          mdl.FieldByName('cerr').asstring:=sl.Values['cerr'];
          sl.Values['ioflag']:=lowercase(sl.Values['ioflag']);
          if sl.Values['ioflag']='true' then iof:='вход' else iof:='выход';
          mdl.FieldByName('ioflag').asstring:=iof;
          mdl.FieldByName('duralg').asstring:=sl.Values['duralg'];
          if sens<>'key' then mdl.FieldByName('abrv').asstring:=sl.Values['cerr']+zp+ sl.Values['abrv'];
          if sens='key'  then mdl.FieldByName('abrv').asstring:=sl.Values['cerr']+zp+ sl.Values['abrv'];

          mdl.post;
          if sens='key' then begin
           {
           formsyslog.top:=0;
           formsyslog.left:=0;
           formsyslog.show;
           formsyslog.BringToFront;
           }
           form1.log('y','LASTKEY CERR='+sl.Values['cerr']);
           if  sl.Values['cerr']<>'0' then begin ;
             pt:=appdir+'wav/ping1.wav';
             if  formemul.cb1.Checked then   form1.playwav(pt);
           end;

           if  sl.Values['cerr']='0' then begin  ;
              form1.showentryexit(sl,2) ;
              pt:=appdir+'wav/pass1.wav';
              if  formemul.cb1.Checked then   form1.playwav(pt);
           end;
          end;

          form1.showsens(sl);
          jb.free;
          sl.Free;
        except
          on ee: Exception do
           begin
           form1.log('e', 'syslog ,ee=' + ee.Message);
           end;
        end;


end;

procedure Tformsyslog.dbgDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  pr:string;

begin
   pr:= Column.Field.Dataset.FieldbyName('pr').AsString;

   if pr = 'i' then
    begin
     dbg.Canvas.Brush.Color:=clsilver;
     dbg.Canvas.Font.Color:=clBlack;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

   if pr = 'r' then
    begin
     dbg.Canvas.Brush.Color:=clred;
     dbg.Canvas.Font.Color:=clBlack;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

   if pr = 'e' then
    begin
     dbg.Canvas.Brush.Color:=clred;
     dbg.Canvas.Font.Color:=clBlack;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;
    if pr = 'y' then
    begin
     dbg.Canvas.Brush.Color:=clyellow;
     dbg.Canvas.Font.Color:=clBlack;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'w' then
    begin
     dbg.Canvas.Brush.Color:=clwhite;
     dbg.Canvas.Font.Color:=clBlack;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'c' then
        begin
         dbg.Canvas.Brush.Color:=claqua;
         dbg.Canvas.Font.Color:=clBlack;
         dbg.Canvas.FillRect(Rect);
         dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
         exit;
        end;

    if pr = 'b' then
    begin
     dbg.Canvas.Brush.Color:=clblue;
     dbg.Canvas.Font.Color:=clBlack;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'i' then
    begin
     dbg.Canvas.Brush.Color:=clblack;
     dbg.Canvas.Font.Color:=clwhite;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;


    if pr = 'm' then
    begin
     dbg.Canvas.Brush.Color:=clpurple;
     dbg.Canvas.Font.Color:=clwhite;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;

    if pr = 'l' then
    begin
     dbg.Canvas.Brush.Color:=cllime;
     dbg.Canvas.Font.Color:=clBlack;
     dbg.Canvas.FillRect(Rect);
     dbg.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
     exit;
    end;



end;

end.

