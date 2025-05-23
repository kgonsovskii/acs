unit uPublishedOperations;

interface
Uses TypInfo, Classes, SysUtils, uSysProc;

Type
  THandleOnException = Function(const Note : String; EnableShowMessage : Boolean = True) : String;

Procedure StrToObjectProps(const Source : String; Dest : TObject; OnException : THandleOnException);
Procedure StringsToObjectProps(Source : TStrings; Dest : TObject; OnException : THandleOnException);


Function ObjectPropsToStr(Source : TObject) : String;
Procedure ObjectPropsToStrings(Source : TObject; Dest : TStrings);



implementation

Procedure PropValueAsStringToObject(PropName, PropValue : String; Dest : TObject);
var PropInfo: PPropInfo;
    I : Integer;
    Obj : TObject;
    ObjPropName : String;
Begin
  I := Pos('.', PropName);
  If I > 0 Then Begin
    ObjPropName := Copy(PropName, I+1, MaxInt);
    PropName := Copy(PropName, 1, I-1);
  end;

  PropInfo := GetPropInfo(Dest, PropName);
  If PropInfo = nil Then
    raise EPropertyError.Create('Неизвестное свойство "'+PropName+'"')
  else
    case PropInfo.PropType^^.Kind of
      tkClass : Begin
        Obj := GetObjectProp(Dest, PropInfo);
        If Obj is TStrings Then
          (Obj as TStrings).Values[ ObjPropName ] := PropValue;
      end;
      tkInteger :
        SetOrdProp(Dest, PropInfo, StrToInt(PropValue) );
      tkChar, tkWChar:
        SetOrdProp(Dest, PropInfo, Ord( PropValue[1] ) );
      tkEnumeration:
         SetOrdProp(Dest, PropInfo, GetEnumValue( PropInfo.PropType^ ,PropValue));
      tkSet:
         SetSetProp(Dest, PropInfo, PropValue);
      tkFloat:
        SetFloatProp(Dest, PropInfo, StrToFloat(PropValue));
      tkString, tkLString:
        SetStrProp(Dest, PropInfo, PropValue);
      tkWString:
        SetWideStrProp(Dest, PropInfo, PropValue);
      tkInt64:
        SetInt64Prop(Dest, PropInfo, StrToInt(PropValue));
      else
        raise EPropertyError.Create('Не поддерживаемый тип свойства "'+PropName+'"')
    end;
end;

Procedure StrToObjectProps(const Source : String; Dest : TObject; OnException : THandleOnException);
var S : TStringList;
Begin
  S := TStringList.Create;
  Try
    S.CommaText := Source;
    StringsToObjectProps(S, Dest, OnException);
  Finally
    S.Free;
  end;
end;

Procedure StringsToObjectProps(Source : TStrings; Dest : TObject; OnException : THandleOnException);
var I : Integer;
Begin
  For I := 0 to Source.Count - 1 do
    If Source.ValueFromIndex[I] <> '' Then
      Try
        PropValueAsStringToObject( Source.Names[I], Source.ValueFromIndex[I], Dest);
      Except
        If Assigned(OnException) Then
          OnException('Установка Published свойства '+Dest.ClassName+'.'+Source.Names[I]+' в "'+Source.ValueFromIndex[I]+'"!', True)
        else
          Raise;
      end;
end;

Procedure ObjectPropsToStrings(Source : TObject; Dest : TStrings);

   Procedure AddStringList(pName : String; sL : TObject);
   var I : Integer;
   Begin
     If sL Is TStrings Then
       For I := 0 to (sL as TStrings).Count - 1 do
         Dest.Add(pName+'.'+ (sL as TStrings)[I] );
   end;

var I : Integer;
    PropList: PPropList;
    PropInfo: PPropInfo;
    PropCount : Integer;
    sProp : String;
    NeedSet : Boolean;
Begin
  Dest.Clear;
  PropCount := GetPropList(Source, PropList);
  Try
    For I := 0 to PropCount - 1 do Begin
      PropInfo := PropList^[I];
      If  (not (Source Is TComponent))
           or
          (
          (not SameText(PropInfo^.Name, 'Name')) and
          (not SameText(PropInfo^.Name, 'Tag'))
          )
      Then Begin
        NeedSet := True;
        case PropInfo^.PropType^^.Kind of
          tkClass : Begin
            AddStringList(Trim(PropInfo^.Name), GetObjectProp(Source, PropInfo) );
            NeedSet := False;
          end;
          tkInteger:
            sProp := IntToStr(GetOrdProp(Source, PropInfo));
          tkChar, tkWChar:
            sProp := Chr(GetOrdProp(Source, PropInfo));
          tkEnumeration:
            sProp := GetEnumName(GetTypeData(PropInfo^.PropType^)^.BaseType^, GetOrdProp(Source, PropInfo));
          tkSet:
            sProp := GetSetProp(Source, PropInfo);
          tkFloat:
            sProp := FloatToStr( GetFloatProp(Source, PropInfo) );
          tkString, tkLString:
            sProp := GetStrProp(Source, PropInfo);
          tkWString:
            sProp := GetWideStrProp(Source, PropInfo);
          tkInt64:
            sProp := IntToStr(GetInt64Prop(Source, PropInfo));
          else
            NeedSet := False;
        end;
        If NeedSet Then
          Dest.Add(Trim(PropInfo^.Name) + '=' + sProp);
      end;
    end;
  finally
    FreeMem(PropList);
  end;
end;

Function ObjectPropsToStr(Source : TObject) : String;
var S : TStringList;
Begin
  S := TStringList.Create;
  Try
    ObjectPropsToStrings(Source, S);
    Result := S.CommaText;
  Finally
    S.Free;
  end;
end;

end.
