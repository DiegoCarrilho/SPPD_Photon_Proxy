unit Helper;

interface

uses
  Windows, Sysutils, ComCtrls, StdCtrls, Classes, ClipBrd, uClasses,StrUtils;


function HexToAsc(strData: string): string;
function To_Hex(Buffer: PByteArray; Len: Integer): String;
procedure addpackettolog(PacketData: PByteArray; PacketSize: Integer;
  A, B: String; ToServer: Boolean);
procedure WriteLog(S: string);
function Get_Data(Arg1, Arg2, Texto: String): String;
function StrToAnsi(stringVar: string): PAnsiChar;
function HexTo(Source: String): TByteArray;
procedure ListViewToClipboard(theListView: TListView);
function WhatPacketIsToClient(Packet: PByteArray): String;
function WhatPacketisToServer(Packet: PByteArray): String;
procedure addpackettolog2(PacketData: PByteArray; Description: String;
  ToServer: Boolean);
function Rep00(Arg1: String): String;
procedure WriteLog2(S: string);
     function InvDWord(Packet:PbyteArray) : integer;
    function StrToIPv4(const S: String): TIPv4;
    function NewPacketInfo(Packet:PByteArray): String;

const
  ts01F30001 = $0100F301;
  ts01F30600 = $0006F301;
  ts01F302E6 = $E602F301;
  ts01F302E2 = $E202F301;
  ts01F302FC = $FC02F301;
  ts01F302FD = $FD02F301;
  ts00F302FD = $FD02F300;
  ts01F302E1 = $E102F301;
  ts01F302E5 = $E502F301;
  ts01F302E3 = $E302F301;

  tc01F30100 = $0001F301;
  tc01F30700 = $0007F301;
  tc01F303E6 = $E603F301;
  tc01F303E2 = $E203F301;
  tc01F304FF = $FF04F301;
  tc01F303FC = $FC03F301;
  tc01F304FD = $FD04F301;
  tc01F304CA = $CA04F301;
  tc01F304C8 = $C804F301;
  tc01F304D1 = $D104F301;
  tc01F304FE = $FE04F301;
  tc00F304C9 = $C904F300;
  tc01F304E5 = $E504F301;
  tc01F304E6 = $E604F301;
  tc01F303E1 = $E103F301;
  tc01F303E3 = $E303F301;
  tc01F303E5 = $E503F301;

implementation

uses MainUnit, uCards, uProxy;

function InvDWord(Packet:PbyteArray) : integer;
var
FDword  : Array [0..3] of byte;
begin
  FDword[0] := Packet[3];
  FDword[1] := Packet[2];
  FDword[2] := Packet[1];
  FDword[3] := Packet[0];
  Result := MakeLong(PWord(@FDword[0])^,PWord(@FDword[2])^);
end;


function StrToIPv4(const S: String): TIPv4;
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

function HexTo(Source: String): TByteArray;
var
  K, CharPtr: Integer;
  Tmp: String;
begin
  CharPtr := 1;
  for K := 0 to Length(Source) div 2 - 1 do
  begin
    Tmp := Copy(Source, CharPtr, 2);
    inc(CharPtr, 2);
    Result[K] := StrToInt('$' + Tmp);
  end;
end;

function Get_Data(Arg1, Arg2, Texto: String): String;
var
  Resultado: String;
  Pos_Ini, Pos_End: Integer;
begin
  Resultado := '';
  Pos_Ini := pos(Arg1, Texto) + Length(Arg1);
  Resultado := Copy(Texto, Pos_Ini);
  Pos_End := pos(Arg2, Resultado);
  Resultado := Copy(Resultado, 1, Pos_End - 1);
  Result := Resultado;
end;

function StrToAnsi(stringVar: string): PAnsiChar;
Var
  AnsString: AnsiString;
  InternalError: Boolean;
begin
  InternalError := false;
  Result := '';
  try
    if stringVar <> '' Then
    begin
      AnsString := AnsiString(stringVar);
      Result := PAnsiChar(PAnsiString(AnsString));
    end;
  Except
    InternalError := true;
  end;
  if InternalError or (String(Result) <> stringVar) then
  begin
    // Raise Exception.Create('Conversion from string to PAnsiChar failed!');
  end;
end;

function HexToAsc(strData: string): string;
var
  sresult: string;
  sfinal: string;
  hexc: cardinal;
  I: Integer;
  Car: string;
begin
  I := 1;
  strData := StringReplace(strData, ' ', '', [rfIgnoreCase, rfReplaceAll]);
  while I <= Length(strData) do
  begin
    Car := Copy(strData, I, 2);
    if Car <> '00' then
    begin
      hexc := StrToInt('$' + Car);
      sresult := inttostr(hexc);
      sresult := chr(StrToInt(sresult));
      sfinal := sfinal + sresult;
    end;

    I := I + 2;
  end;

  Result := sfinal
end;

function To_Hex(Buffer: PByteArray; Len: Integer): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Len - 1 do
  begin
    Result := Result + ' ' + IntToHex(Buffer[I], 2);
  end;
  Result := Trim(Result);
end;

function WhatPacketIsToClient(Packet: PByteArray): String;
begin
  Result := '';
  if Packet[0] = $F0 then
    Result := 'TimeStamp';
  case PID(@Packet[6])^ of

    // 4530 CASES
    tc01F304E5 :
     case PID(@Packet[10])^ of
        $68DE0100 :
          Result  := 'Lobby List';
        $002A0000 :
          Result  := 'Lobby List2';
      end;

     tc01F303E5 :
     case PID(@Packet[10])^ of
        $002A0000 :
          Result  := 'Lobby List3';
      end;
     tc01F304E6 :
     case PID(@Packet[10])^ of
        $68DE0100 :
          Result  := 'Lobby List4';
      end;
     tc01F303E1 :
     case PID(@Packet[10])^ of
        $0073F87F :
          Result := 'No Match Found';
        $002A0000 :
          Result := 'Ip Match 1';
      end;

      tc01F303E3 :
     case PID(@Packet[10])^ of
        $002A0000 :
        case Packet[14] of
         $03  : Result := 'Ip Match 2';
         $05  : Result := 'C0C1C2C3';
        end;

      end;
      // 4531 CASES
    tc00F304C9:
      Result := 'Char Stat';
    tc01F30100:
      Result := 'LoadBalance';

    tc01F30700:
      case PID(@Packet[10])^ of
        $002A0000:
          Result := 'Unk 0700';
      end;

    tc01F303E6:
      case PID(@Packet[10])^ of
        $002A0000:
          Result := 'Token Reply';
      end;

    tc01F303E2:
      case PID(@Packet[10])^ of
        $002A0000:
          Result := 'Oponent Deck 2';
      end;

    tc01F304FD:
      case PID(@Packet[10])^ of
        $68FB0300:
          Result := 'Oponent Deck';
      end;

    tc01F304FF:
      case PID(@Packet[10])^ of
        $68F90300:
          Result := 'Recv pID';
      end;

    tc01F303FC:
      case PID(@Packet[10])^ of
        $002A0000:
          Result := '';
      end;

    tc01F304CA:
      case PID(@Packet[10])^ of
        $68F50200:
          Result := 'Oponent pID';
      end;

    tc01F304C8:
      case PID(@Packet[10])^ of
        $68F50200:
          case Packet[19] of
            $00:
              Result := 'Spel By Char';
            $02:
              Result := 'Card Confirm';
            $03:
              Result := 'Oponent Card Died';
            $05:
              Result := 'Spel Dmg?';
            $06:
              Result := 'Emoji';
            $09:
              Result := 'After Animated hit?';
            $0A:
              Result := 'Recv Dmg';
            $0B:
              Result := 'Kill';
            $0C:
              Result := 'Battle Finish?';
          end;
      end;

    tc01F304D1:
      case PID(@Packet[10])^ of
        $68F50200:
          Result := '';
        $79F50200:
          Result := 'Confirm Transformation?';
      end;

    tc01F304FE:
      case PID(@Packet[10])^ of
        $79FC0300:
          Result := 'Finish Packet 03?';
        $79FC0200:
          Result := 'Finish Packet 02?';
      end;
  end;
  if (Result = '') then
    Result := Format('Unk opCode(%s), SubOpCode (%s)',
      [To_Hex(@Packet[6], 4), To_Hex(@Packet[10], 4)]);
end;

function WhatPacketisToServer(Packet: PByteArray): String;
begin
  Result := '';
  if Packet[0] = $F0 then
    Result := 'TimeStamp';

  if (Result = '') then;
  case PID(@Packet[6])^ of
    // 4530 CASES
    ts01F302E5:
       case PID(@Packet[10])^ of
        $73D50200 :
          Result := 'Lobby';
      end;
    ts01F302E3:
       case PID(@Packet[10])^ of
        $73D50200 :
          Result := 'Lobby';
      end;
    ts01F302E1:
           case PID(@Packet[10])^ of
        $68F80400 :
            Result := 'Lobby Req Info';
          end;
   //4531 CASES
    ts00F302FD:
      Result := 'Card Stat';

    ts01F30001:
      case PID(@Packet[10])^ of
        $01411E06:
          Result := 'LoadBalance';
      end;

    ts01F30600:
      case PID(@Packet[10])^ of
        $78010100:
          Result := 'Unk0600';
      end;

    ts01F302E6:
      case PID(@Packet[10])^ of
        $73DD0100:
          Result := 'Send Token';
      end;

    ts01F302E2:
      case PID(@Packet[10])^ of
        $73FF0300:
          Result := 'Send UbiID';
      end;

    ts01F302FC:
      case PID(@Packet[10])^ of
        $68FB0200:
          Result := '';
        $68FB0300:
          Result := 'Send Deck';
      end;

    ts01F302FD:
      case PID(@Packet[10])^ of
        $62F40200:
          case Packet[36] of
            $00:
              Result := 'Char Spell';
            $03:
              Result := 'Card Died';
            $06:
              Result := 'Emotion';
            $08:
              Result := 'Send Hit Checksum?';
            $0A:
              Result := 'Dmg';
            $0B:
              Result := 'Kill';
          end;

        $62F40300:
          case Packet[14] of
            $CA:
              Result := 'Send My pID';
            $C8:
              case Packet[36] of
                $08:
                  Result := 'Send Hit Checksum?';
                $09:
                  Result := 'NK Recv Hit';
              end;

            $D1:
              Result := 'Transformation?';
          end;

        $62F40400:
          Result := 'Drop Card';

      end;
  end;

  if (Result = '') then
    Result := Format('Unk opCode(%s), SubOpCode (%s)',
      [To_Hex(@Packet[6], 4), To_Hex(@Packet[10], 4)]);
end;

procedure addpackettolog2(PacketData: PByteArray; Description: String;
  ToServer: Boolean);
var
  PacketLength: Integer;
begin

  PacketLength := (PacketData[3] shl 8) or PacketData[4];

  with (Form2.ListView1.Items.Add) do
  begin
    Caption := inttostr(Form2.ListView1.Items.Count);
    SubItems.Add(inttostr(PacketLength));
    SubItems.Add(Description);
    if ToServer then
      SubItems.Add('>')
    else
      SubItems.Add('<');
    SubItems.Add(To_Hex(@PacketData[0], PacketLength));
  end;

  Form2.ListView1.Items.Item[Form2.ListView1.Items.Count - 1].MakeVisible(true);

end;

procedure addpackettolog(PacketData: PByteArray; PacketSize: Integer;
  A, B: String; ToServer: Boolean);
begin
  if (PacketData[6] <> $00) or (PacketData[0] = $F0) or Form2.CheckBox2.Checked then
  begin

    with (Form2.PacketListView.Items.Add) do
    begin
      Caption := inttostr(Form2.PacketListView.Items.Count);
      SubItems.Add(inttostr(PacketSize));
      SubItems.Add(B);
      if ToServer then
        SubItems.Add(NewPacketInfo(@PacketData[0]))
      else
        SubItems.Add(NewPacketInfo(@PacketData[0]));

      if ToServer then
        SubItems.Add('->')
      else
        SubItems.Add('<-');

      SubItems.Add(To_Hex(@PacketData[0], PacketSize));


    end;
    Form2.PacketListView.Items.Item[Form2.PacketListView.Items.Count - 1]
      .MakeVisible(true);

  end;
end;

procedure WriteLog(S: string);
begin
  Form2.LogMemo.Lines.Add('{' + TimeToStr(Time) + '} ' + S + '.');
end;

procedure WriteLog2(S: string);
begin
  Form2.LogMemo2.Lines.Add('{' + TimeToStr(Time) + '} ' + S + '.');
  // Form2.LogMemo2.Lines.Add('{' + TimeToStr(Time) + '}'+IntToStr(Form2.PacketListView.Items.Count)+' ' + S);
end;

procedure ListViewToClipboard(theListView: TListView);
var
  Item: TListItem;
  index, subIndex: Integer;
  Line: String;
  MyStringList: TStringList;
begin
  MyStringList := TStringList.Create;
  { Monta o header }
  Line := theListView.Columns[0].Caption;
  for subIndex := 1 to theListView.Columns.Count - 1 do
    Line := Line + #9 + theListView.Columns[subIndex].Caption;
  { Seleciona o ITEM }
  for index := 0 to theListView.Items.Count - 1 do
  begin
    Item := theListView.Items[index];
    Line := Item.Caption;
    { Insere o ITEM Tabulado na STRING }
    for subIndex := 0 to theListView.Columns.Count - 2 do
      Line := Line + #9 + Item.SubItems[subIndex];
    { Envia o ITEM para o TMemo }
    MyStringList.Add(Line);
  end;
  { Envia o ITEM para o TMemo }
  Clipboard.AsText := MyStringList.Text;
  MyStringList.Clear;
end;

function Rep00(Arg1: String): String;
begin
  Result := StringReplace(Arg1, '00 00 ', '', [rfIgnoreCase, rfReplaceAll]);
end;


function NewPacketInfo(Packet: PByteArray): String;
begin

  case PID(@Packet[5])^ of

    tc0000F304:
      Result := 'Card Stat to Client';

    tc0001F301:
      Result := 'Load Balance';

    tc0001F303:
      case Packet[9] of
        $E2: begin
        if Swap(PWord(@Packet[31])^) > 100 then
        Result :='Battle IP'
        else
          Result := Format('New Recv Deck (%d) items',
                [Swap(PWord(@Packet[31])^)]);
        end;
        $E3:
          Result := 'Battle Infos CX';
        $E6:
          Result := 'Token Reply';
        $FC:
          case Swap(PWord(@Packet[10])^) of
            $0000:
              Result := 'Send Deck Confirm';
            $FFFE: begin
              Result := 'Update Property Failed';

              WriteLog(HexToAsc(To_Hex(@Packet[15],Packet[14])));
            end;
          end;
      end;

    tc0001F304:
      case Packet[9] of
        $FF:
          Result := 'Recv UbiID';
        $FE:
          Result := 'Finish Packet';
        $FD:
          case Swap(PWord(@Packet[14])^) of
            3 .. 100:
              Result := Format('Recv Deck (%d) items',
                [Swap(PWord(@Packet[14])^)]);
          else
            Result := Format('Recv Deck (%d) items',
              [Swap(PWord(@Packet[14])^)]);
          end;

        $D1:
          Result := 'Confirm Trassformation?';
        $CA:
          Result := 'Oponent pID';
        $C8:
          case Packet[19] of
            $00:
              Result := 'Spel By Char';
            $02:
              Result := 'Card Confirm';
            $03:
              Result := 'Oponent Card Died';
            $04:
              Result := 'NK Infos?';
            $05:
              Result := 'Spel Dmg?';
            $06:
              Result := 'Emoji';
            $09:
              Result := 'After Animated hit?';
            $0A:
              Result := 'Recv Dmg';
            $0B:
              Result := 'Kill';
            $0C:
              Result := 'Battle Finish?';
          end;
      end;

    tc0001F307:
      Result := 'Unk F307';

    ts0000F302:
      Result := 'Send Card Stat';

    ts0001F300:
      Result := 'Load Balance';

    ts0001F302:
      case Packet[9] of
        $E2:
          Result := '2 UBI ID...';
        $E3:
          Result := 'Battle Infos CX';
        $E6:
          Result := 'Send Token';
        $FC:
          case Swap(PWord(@Packet[14])^) of
            3 .. 100:
              Result := Format('Send Deck (%d) items',
                [Swap(PWord(@Packet[14])^)]);
          else
            Result := Format('Send Deck (%d) items',
              [Swap(PWord(@Packet[14])^)]);
          end;
        $FD:
          case Packet[14] of
            $C8:
              case Packet[36] of
                $00:
                  Result := 'Char Spell';
                $02:
                  Result := 'Drop Card';
                $03:
                  Result := 'Card Died';
                $04:
                  Result := 'Drop Card NK?';
                $05:
                  Result := 'Drop Spell';
                $06:
                  Result := 'Emotion';
                $07:
                  Result := 'C8 - 37';
                $08:
                  Result := 'Send Hit Checksum?';
                $09:
                  Result := 'Nk Recv Hit?';
                $0A:
                  Result := 'Dmg';
                $0B:
                  Result := 'Kill';
                $0C:
                  Result := 'C8 - 0C';
              end;
            $D1:
              Result := 'TransFormation?';
            $CA:
              Result := 'Send My pID';
          end;
      end;
    ts0001F306:
      Result := 'Unk F306';

  end;

     if (Packet[0] = $F0) then
       Result := 'Ping';

end;

end.
