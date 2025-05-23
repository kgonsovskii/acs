unit ushemanode;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, laz.virtualtrees,
  umain;

type

  { Tformshemanode }

  Tformshemanode = class(TForm)
    Button1: TButton;
    Cb1: TCheckBox;
    cbmain: TCheckBox;
    Cbinsert: TCheckBox;
    cbdatatree: TCheckBox;
    lename: TLabeledEdit;
   // procedure Button1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Cb1Change(Sender: TObject);
    procedure cbdatatreeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure  setprm(cnd:pvirtualnode);
    function  ndtobase:pvstrecord;
    function  newndtobase(nd:pvirtualnode):pvstrecord;
    function  formirdata(ds:pvstrecord):pvstrecord;
  private

  public

  end;

var
  formshemanode: Tformshemanode;
  dsx :pvstrecord;
  cndx :pvirtualnode;

implementation

{$R *.lfm}
//uses

{ Tformshemanode }

procedure Tformshemanode.setprm(cnd:pvirtualnode);
  begin
        cndx:=cnd;
        form1.log('y','setprm start 1');
        //dsx:=ds;
      //  button1.SetFocus;
        //form1.readtsspsh;
    //    showmessage('SETPRM ');

  end;

procedure Tformshemanode.FormCreate(Sender: TObject);
begin

end;

procedure Tformshemanode.FormShow(Sender: TObject);
begin
     //lename.SetFocus;
end;

function Tformshemanode.newndtobase(nd:pvirtualnode):pvstrecord;
var

  data,dsp:pvstrecord;
  a,s,lvl,bplast,nm0,bidshema:string;
  abi,n:integer;
  ndp:pvirtualnode;
  rc:umain.trcfld;

begin
     try
         n:=1;
         if autor then a:='true'else a:='false';
         s:='select myid from tsspsh_shema where name='+ap+form1.cmbtsspsh.text+ap;
         rc:=form1.readfld(s);
         bidshema:=rc.value;
         n:=2;
         //abi:=form1.vst.AbsoluteIndex(nd);
         //lvl:=inttostr(form1.vst.GetNodeLevel(nd)) ;
         //data:=form1.vst.GetNodeData(nd);
         if CNDX=nil then begin
          n:=21;
          //data^.bid:=0;
          //data^.myid:=0;
          abi:=-1;
          bplast:='0';
          nm0:=lename.text;
          form1.log('y','newndtobase ?????????????????????????????');
           s:='insert into tsspsh_datatree (autor,abi,level,tag,sti,bp,bpsh,name) values('+
           a+zp+
           inttostr(abi)+zp+
           '0'+zp+
           inttostr(-100)+zp+
           inttostr(-1)+zp+
            bplast+zp+
            bidshema +zp+
           ap+nm0+ap+')';
           form1.log('l','s='+s);
           form1.selfupd(s);
           EXIT;

         end;
        if cndx<> nil then begin
         data:=form1.vst.GetNodeData(nd);
        // showmessage('CNDX <> NIL  ????????????????????? nm0='+data^.nm0);
         dsp:=form1.vst.getnodedata(cndx);
         bplast:=inttostr(dsp^.myid);
        // showmessage('data.ndp  !!!!!!!!!!!!!!!!!!!!');
        // form1.log('y','newndnode bplast='+bplast);
         n:=3;
         abi:=form1.vst.AbsoluteIndex(nd);
         n:=31;
         lvl:=inttostr(form1.vst.GetNodeLevel(nd)) ;
         n:=32;
          //form1.log('r','NEWNDTOBASE NDPNM0='+dsp^.nm0+'sti='+inttostr(dsp^.sti));
           s:='insert into tsspsh_datatree (autor,abi,level,tag,sti,bp,bpsh,name) values('+
           a+zp+
           inttostr(abi)+zp+
           lvl+zp+
           inttostr(data^.tag)+zp+
           inttostr(data^.sti)+zp+
            bplast+zp+
            bidshema +zp+
           ap+lename.text+ap+')';
           n:=5;
           // showmessage('last s='+s);
           form1.log('c','newndtobase='+s);
           form1.selfupd(s);
          // form1.log('c','newndtobase='+s);
           bplast:=inttostr(form1.getlastmyid('tsspsh_datatree'));
           form1.log('c','bplast='+bplast);
           n:=51;
           data^.myid:=strtoint(bplast);
           n:=6;

        end;
    except
    on ee: Exception do
    begin
      form1.log('e','NNNewndtobase n='+inttostr(n)+' ,ee=' + ee.Message);
    end;
  end;
end;


function Tformshemanode.ndtobase:pvstrecord;
var
  nd:pvirtualnode;
  abi:integer;
  data:pvstrecord;
  bplast,bidshema,lvl,s:string;
  n:integer;
begin
     try
       n:=1;
       nd:=currnd;
       bidshema:='-1';
       if currnd=nil then begin
        form1.log('r','NILLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');

       end;
       dsx^.nm0:=lename.Text;
       //form1.log('w','nm0='+dsx^.nm0+' text=';//+lelevel.text);
       //dsx^.ndcheck_state:=formshemanode.cb1.checked;
       dsx^.sti:=12;
       dsx^.tag:=-1;
    // dsx^.ndcheck_state:=cb1.Checked;
     n:=2;
     if cbdatatree.Checked then begin
       dsx^.sti:=9;
       dsx^.tag:=1;
     end;
   n:=3;
   form1.log('c','ndtobase 0');
   abi:=form1.vst.AbsoluteIndex(nd);
     form1.log('c','ndtobase 1');
   Data := form1.vst.getnodedata(nd);
   form1.log('c','ndtobase 2');
   lvl:=inttostr(form1.vst.GetNodeLevel(nd)) ;
   n:=4;
   form1.log('c','ndtobase 21');
   form1.log('l','ndtobase nm0='+data^.nm0+zp+'tag='+inttostr(data^.tag)+zp+'level='+lvl);
   s:='insert into tsspsh_datatree (abi,level,tag,sti,bp,bpsh,name) values('+
   inttostr(abi)+zp+
   lvl+zp+
   inttostr(data^.tag)+zp+
   inttostr(data^.sti)+zp+
   '-1'+zp+
      '-1'+zp+
      ap+data^.nm0+ap+')';
      n:=5;
      form1.log('y',s);
      form1.selfupd(s);
      form1.log('c','ndtobase 3');
      bplast:=inttostr(form1.getlastmyid('tsspsh_datatree'));
       n:=51;
      dsx^.bid:=strtoint(bplast);
      dsx^.bpsh:=strtoint(bidshema);
      n:=6;
    except
    on ee: Exception do
    begin
      form1.log('e','ndtobase n='+inttostr(n)+' ,ee=' + ee.Message);
    end;
  end;



end;

function Tformshemanode.formirdata(ds:pvstrecord):pvstrecord;
begin
   result:=ds;
    ds^.nm0:=lename.Text;
    if cb1.Checked then begin
        ds^.ndcheck_state:=true;
      //dz^.ndcheck:=true;
     end;
    if  cbdatatree.Checked then  ds^.sti:=9;

    result:=ds;
end;
 {
procedure Tformshemanode.Button1Click(Sender: TObject);
var
  nd,ndp:pvirtualnode;
  ds,dx,dz:pvstrecord;
  x:integer;
begin
   try
     nd:=cndx;
     ndp:=nd;
     //showmessage('Button1Click 1');
     if nd =Nil then begin
     // showmessage('Button1Click 11');
      nd:=form1.vst.AddChild(nil,nil);
     //showmessage('Button1Click 2');
     dz:=form1.vst.getnodedata(nd);
     dz:=formirdata(dz);
     dz^.tag:=-10;
     dz^.sti:=--1;
     dz^.sti1:=-1;
     //showmessage('Button1Click 3');
     newndtobase(nd);
     dz:=form1.vst.getnodedata(nd);
     //dx^.sti:=dz.sti;
     //dx^.m0 :=dz.nm0;
     dx:=dz;
     //showmessage('close exit');
     close;  //=========================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     exit;
    end;
     x:=2;
     dz:=form1.vst.getnodedata(nd);
     //showmessage('Button1Click NOT NIL');
     //if not cbdatatree.Checked then  dz^.sti:=-1;
     if not cbinsert.Checked then begin
      nd:=form1.newnode('a',currnd,dz);
     end
     else begin
       x:=3;
       nd:=form1.newnode('i',currnd,dz);

     end;
     x:=4;

     ds:=form1.vst.getnodedata(nd) ;
     //showmessage('tut');
     ds^.sti:=-1;
     ds^.sti1:=-1;
     x:=5;
     ds^.nm0:=lename.text;
     ds^.ndp:=ndp;
     if cbmain.Checked then BEGIN
     ds^.tag:=-100;
     form1.LOG('l','main nnnnnnnnnnnnnnnnnnnnnn');
     end;
     if  cbdatatree.Checked then begin
       ds^.sti:=9; ds^.tag:=5;
       form1.log('w','9999999999999999999999999999999999999');
     end;
      if cb1.Checked then begin
       ds^.ndcheck_state:=true;

      //ds^.ndcheck:=true;
     end;
     //form1.vst.refresh;
     newndtobase(nd);
     form1.log('w','BUTTON1 nm0='+ds^.nm0);
     //form1.newnode(nil,ds);
     form1.vst.refresh;
   except
    on ee: Exception do
    begin
      form1.log('e', 'button1 x='+inttostr(x)+' ,ee=' + ee.Message);
    end;
  end;
end;

}

procedure Tformshemanode.Cb1Change(Sender: TObject);
begin

end;

procedure Tformshemanode.Button1Click(Sender: TObject);
var
  nd,ndp:pvirtualnode;
  ds,dx,dz:pvstrecord;
  dsn:tnewds;
  x:integer;
begin
   try
     nd:=cndx;
     ndp:=nd;
     //showmessage('Button1Click 1');
     if nd =Nil then begin

     dsn.sti:=-1;
     dsn.sti1:=-1;
     dsn.tag:=3;
     dsn.nm0:=lename.Text;
     dsn.ndcheck_state:=false;
      if  cbdatatree.Checked then  dsn.sti:=9;
     nd:=form1.fnna(nd,dsn);
     newndtobase(nd);

     close;  //=========================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     exit;
    end;
     x:=2;
     dz:=form1.vst.getnodedata(nd);
     //showmessage('Button1Click NOT NIL');
     //if not cbdatatree.Checked then  dz^.sti:=-1;
     if not cbinsert.Checked then begin
      nd:=form1.fnna(currnd,dsn);
     end
     else begin
       x:=3;
       nd:=form1.fnni(currnd,dsn);

     end;
     x:=4;

     ds:=form1.vst.getnodedata(nd) ;
     //showmessage('tut');
     ds^.sti:=-1;
     ds^.sti1:=-1;
     x:=5;
     ds^.nm0:=lename.text;
     ds^.ndp:=ndp;
     if cbmain.Checked then BEGIN
     ds^.tag:=-100;
     form1.LOG('l','main nnnnnnnnnnnnnnnnnnnnnn');
     end;
     if  cbdatatree.Checked then begin
       ds^.sti:=9; ds^.tag:=5;
       form1.log('w','9999999999999999999999999999999999999');
     end;
      if cb1.Checked then begin
       ds^.ndcheck_state:=true;

      //ds^.ndcheck:=true;
     end;
     //form1.vst.refresh;
     newndtobase(nd);
     form1.log('w','BUTTON1 nm0='+ds^.nm0);
     //form1.newnode(nil,ds);
     form1.vst.refresh;
   except
    on ee: Exception do
    begin
      form1.log('e', 'button1 x='+inttostr(x)+' ,ee=' + ee.Message);
    end;
  end;

end;

procedure Tformshemanode.cbdatatreeChange(Sender: TObject);
begin

end;

end.

