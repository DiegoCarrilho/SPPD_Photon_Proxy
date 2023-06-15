unit uFunc;

interface
uses
  Windows, Sysutils, ComCtrls, StdCtrls, Classes, ClipBrd, StrUtils, uClasses;


type

  TFunc = class
  private

  public
    function InvDWordToInt(Packet:PbyteArray) : integer;
    function StrToIPv4(const S: String): TIPv4;
  protected

 end;

 Var
 Func : TFunc;
 ServerAddr: TIpV4;
implementation

function TFunc.InvDWordToInt(Packet:PbyteArray) : integer;
var
FDword  : Array [0..3] of byte;
begin
  FDword[0] := Packet[3];
  FDword[1] := Packet[2];
  FDword[2] := Packet[1];
  FDword[3] := Packet[0];
  Result := MakeLong(PWord(@FDword[0])^,PWord(@FDword[2])^);
end;

function TFunc.StrToIPv4(const S: String): TIPv4;
var
  SIP: String;
  Start: Integer;

  Index, I: Integer;
  Count: Integer;
  SGroup: String;
begin
  SIP := S + '.';
  Start := 1;
  for I := 0 to 3 do
  begin
    Index := PosEx('.', SIP, Start);
    Count := Index - Start + 1;
    SGroup := Copy(SIP, Start, Count - 1);
    Result[I] := StrToInt(SGroup);
    Inc(Start, Count);
  end;
end;


end.
