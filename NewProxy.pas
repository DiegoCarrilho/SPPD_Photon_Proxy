unit NewProxy;

interface

uses
  Windows, SysUtils, ScktComp, Dialogs,uFunc, WinSock, uClasses;

type
  TProxy = class
  private
    { Lobby (Game Client - > Proxy) }
    LobbyLocalPort  : Word;
    LobbyLocalIP    : TIpv4;

    {Lobby (Proxy -> Proxy2)  }
    LobbyProxyIp   : String;
    LobbyProxyPort :  Word;

    { Battle (Game Client - > Proxy)  }
    BattleLocalPortStr  : String;
    BattleLocalPort     : Word;
    BattleLocalIP       : String;

    { Battle (Proxy - > Game) }
    PlayPort      : Word;
    PlayIP        :  String;


    aQuebrado: TByteArray;
    aOndequebrou: integer;

    aSplitPacket: TByteArray;
    aSplitPos: integer;

    aCurrPacketLen : Integer;
    PServer: TServerSocket;
    PClient: TClientSocket;
    aCurrPacket: TByteArray;
    aPacketLen : Integer;
    PacketQueueToServer: array [0 .. 9] of TByteArray;
    numOfPacketQueueToServer: Integer;
    CurrSock  : Integer;
    procedure OnClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OnError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OnConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure BattleIp(Packet:PByteArray);
    procedure WriteLog(S:String);
    procedure SetPlayIP(aPlayIP:String);
    procedure SetPlayPort(aPlayPort:String);
    function GetIP(const HostName: string): string;
  public
    State     : Boolean;
    procedure StopProxy;
    function  StartProxy: Boolean;
    procedure DisconnectProxy;
    procedure SetLobbyLocalPort(aLobbyLocalPort:String);
    procedure SetBattleLocalIP(aBattleLocalIP:String);
    procedure SetBattleLocalPort(aBattleLocalPort:String);
    function  GetBattleLocalPort() : Word;
    function  GetPlayIP() : String;
    function  GetPlayPort() : Word;
    procedure SetLobbyProxyIp(aLobbyProxyIp:String);
    function  GetLobbyProxyIp() : String;
    procedure SetLobbyProxyPort(aLobbyProxyPort:String);
    function  GetLobbyProxyPort() : Word;
    function  GetLobbyLocalPort() : Word;
    constructor Create()overload;
  protected

  end;

  implementation

uses MainUnit, uCards,Helper, uBattle;



constructor TProxy.Create();
begin
  inherited;
   Self.State := false;

  Self.PServer := TServerSocket.Create(nil);
  Self.PServer.OnClientRead := Self.OnClientRead;
  Self.PServer.OnClientConnect := Self.OnClientConnect;
  Self.PServer.OnClientError := Self.OnClientError;

  Self.PClient := TClientSocket.Create(nil);
  Self.PClient.OnRead := Self.OnRead;
  Self.PClient.OnDisconnect := Self.OnDisconnect;
  Self.PClient.OnError := Self.OnError;
  Self.PClient.OnConnect := Self.OnConnect;

end;


{ Login Client -> Login Server }
procedure TProxy.OnClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I: integer;
  Send: Boolean;
begin

  aPacketLen := Socket.ReceiveBuf(aCurrPacket, SizeOf(aCurrPacket));
  if (aPacketLen < 3) then
    Exit;

  if (aSplitPos > 0) then
  begin
    CopyMemory(@aSplitPacket[aSplitPos], @aCurrPacket[0], aPacketLen);
    aPacketLen := aPacketLen + aSplitPos;
    CopyMemory(@aCurrPacket[0], @aSplitPacket[0], aPacketLen);
    aSplitPos := 0;
  end;

  I := 0;
  while (I < (aPacketLen - 1)) do
  begin
    aCurrPacketLen := 0;
    Send := true;

    Case aCurrPacket[I] of
      $F0:
        Begin
          aCurrPacketLen := 5;

          if Form2.FullLogLobbyF0CheckBox.Checked then
            addpackettolog(@aCurrPacket[I], aCurrPacketLen, 'Clear',
              'Lobby', true);
        end;
      $FB:
        Begin
          aCurrPacketLen := (aCurrPacket[I + 3] shl 8) or aCurrPacket[I + 4];

          If (I + aCurrPacketLen > aPacketLen) then
          begin
            CopyMemory(@aSplitPacket[0], @aCurrPacket[I], (aPacketLen - I));
            aSplitPos := aPacketLen - I;
            Exit;
          end;

          if (Form2.FullLogLobbyCheckBox.Checked) then
            addpackettolog(@aCurrPacket[I], aCurrPacketLen, 'Clear',
              'Lobby', true);
        end;
    end;

    if (aCurrPacketLen = 0) then
      Exit;

    if (Send) then
      if (PClient.Active) and (PClient.Socket.Connected) then
        PClient.Socket.SendBuf(aCurrPacket[I], aCurrPacketLen)
      else
      begin
        CopyMemory(@PacketQueueToServer[numOfPacketQueueToServer][0],
          @aCurrPacket[I], aCurrPacketLen);
        inc(numOfPacketQueueToServer);
      end;

    I := I + aCurrPacketLen;
  end;

end;

{ Login Server -> Login Client }
procedure TProxy.OnRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I: integer;
  Send: Boolean;
  TempPacket  : TByteArray;
begin

  aPacketLen := Socket.ReceiveBuf(aCurrPacket, SizeOf(aCurrPacket));
  if (aPacketLen < 3) then
    Exit;

  if (aOndequebrou > 0) then
  begin
    CopyMemory(@aQuebrado[aOndequebrou], @aCurrPacket[0], aPacketLen);
    aPacketLen := aPacketLen + aOndequebrou;
    CopyMemory(@aCurrPacket[0], @aQuebrado[0], aPacketLen);
    aOndequebrou := 0;
  end;

  I := 0;
  while (I < (aPacketLen - 1)) do
  begin
    aCurrPacketLen := 0;
    Send := true;
    Case aCurrPacket[I] of
      $F0:
        Begin
          aCurrPacketLen := 9;
          if Form2.FullLogLobbyF0CheckBox.Checked then
            addpackettolog(@aCurrPacket[I], aCurrPacketLen, 'Clear', 'Lobby', false);
        end;
      $FB:
        Begin
          aCurrPacketLen := (aCurrPacket[I + 3] shl 8) or aCurrPacket[I + 4];

          If (I + aCurrPacketLen > aPacketLen) then
          begin
            CopyMemory(@aQuebrado[0], @aCurrPacket[I], (aPacketLen - I));
            aOndequebrou := aPacketLen - I;
            Exit;
          end;

            case PID(@aCurrPacket[I + 6])^ of
                    tc01F303E3,tc01F303E1,tc01F303E2 :
             case PID(@aCurrPacket[I + 10])^ of
                $002A0000 :
                     case aCurrPacket[I + 14] of
                      $03, $04  :
                      begin

                        CopyMemory(@TempPacket[0],@aCurrPacket[I + 0],aPacketLen);
                        Send := false;
                          BattleIp(@TempPacket[0]);

                          if (PServer.Socket.ActiveConnections > 0) then
                            if (PServer.Socket.Connections[0].Connected) then
                              PServer.Socket.Connections[0].SendBuf(TempPacket[0],
                              (TempPacket[3] shl 8) or  TempPacket[4]);
                      end;
                    end;
              end;
            end;
          { Packet Logger }
          if (Form2.FullLogLobbyCheckBox.Checked) then
            addpackettolog(@aCurrPacket[I], aCurrPacketLen, 'Clear', 'Lobby', false);
        end;
    end;

    if (aCurrPacketLen = 0) then
      Exit;

    if Send then
      if (PServer.Socket.ActiveConnections > 0) and
        (PServer.Socket.Connections[0].Connected) then
        PServer.Socket.Connections[0].SendBuf(aCurrPacket[I], aCurrPacketLen);

    I := I + aCurrPacketLen;
  end;

end;

procedure TProxy.OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  NumCon: Integer;
begin
  try
    CurrSock := Socket.SocketHandle;
      numOfPacketQueueToServer := 0;

      LobbyLocalIP := StrToIPv4(Socket.RemoteAddress);

    if PClient.Socket.Connected then
    begin
      WriteLog('Client Socket Closed for a New Connection');
      PClient.Socket.Close;
    end;
    PClient.Address := GetLobbyProxyIp;
    PClient.Port :=    GetLobbyProxyPort;
    PClient.Open;

    if (PServer.Socket.ActiveConnections > 0) then
      for NumCon := 0 to PServer.Socket.ActiveConnections - 1 do
        if PServer.Socket.Connections[NumCon].SocketHandle <> CurrSock then
        begin
          WriteLog('Closed a ServerSocket Not CurrSock');
          PServer.Socket.Connections[NumCon].Close;
        end;
  except
    on E: Exception do
      WriteLog(E.Message);

  end;

  WriteLog(Format('Game Connected From (%s:%d)',
    [Socket.RemoteAddress,Socket.RemotePort]));
end;

procedure TProxy.OnConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  J: Integer;
begin
  try
    aCurrPacket[0]           := $FF;
    Pid(@aCurrPacket[1])^    := Pid(@LobbyLocalIP[0])^;
    PWord(@aCurrPacket[5])^  := Pword(@LobbyLocalPort)^;

    PClient.Socket.SendBuf(aCurrPacket[0], 7);

    WriteLog(Format('Connected to Proxy (%s:%d)', [LobbyProxyIp,LobbyProxyPort]));
    if (numOfPacketQueueToServer > 0) then
    begin
      for J := 0 to numOfPacketQueueToServer - 1 do
        PClient.Socket.SendBuf(PacketQueueToServer[J][0],
        (PacketQueueToServer[J][3] shl 8) or PacketQueueToServer[J][4]);
        numOfPacketQueueToServer := 0;
    end;
  except
    on E: Exception do
      WriteLog('OnConnect ' + E.Message);
  end;
end;

procedure TProxy.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  WriteLog('Client Disconnected');
end;

procedure TProxy.OnClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  WriteLog('Lobby ServerError -> (' + IntToStr(ErrorCode) + ').');
  if ((ErrorCode = 10053) or (ErrorCode = 10054)) then  begin
  Self.DisconnectProxy;
    ErrorCode := 0;
  end;
end;

procedure TProxy.OnError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  WriteLog('Lobby ClientError -> (' + IntToStr(ErrorCode) + ').');
  if ((ErrorCode = 10053) or (ErrorCode = 10054)) then begin
  Self.DisconnectProxy;
    ErrorCode := 0;
  end;
end;

procedure TProxy.StopProxy;
begin
  try
    Self.DisconnectProxy;
    PServer.Close;
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      Exit;
    end;
  end;
  WriteLog('Proxy -> Stopped.');
end;

function TProxy.StartProxy: Boolean;
begin
  Result := true;
  try
    PServer.Port := LobbyLocalPort;
    PServer.Open;
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      Result := False;
    end;
  end;
  State := true;
  if (Result) then
    WriteLog('Proxy -> Started (Listening : ' + IntToStr(LobbyLocalPort) + ').');
end;

procedure TProxy.DisconnectProxy;
var
I : integer;
begin
  PClient.Active := False;
  if (PServer.Socket.ActiveConnections > 0) then begin
  for I := 0 to PServer.Socket.ActiveConnections - 1 do
    PServer.Socket.Connections[I].Close;
    WriteLog('Proxy -> Disconnected.');
  end;
  State := false;

end;

procedure TProxy.BattleIp(Packet:PByteArray);
var
I, PacketLen: Integer;
IpStart : Integer;
pIDStart: Integer;

TempPacket  : TByteArray;
TempPos     : Integer;
NewSize     : Word;
begin

  PacketLen := (Packet[3] shl 8) or Packet[4];

  IpStart := 0;
  for I := PacketLen - 3 downto 0 do
    if CompareMem(@Packet[I], @PlayIpMask[0], 3) then
    begin
      IpStart := I + 1; // == 73 00
      break;
    end;

    SetPlayIP(HexToAsc(To_Hex(@Packet[IpStart + 3],Packet[IpStart + 2] - 5)));
    SetPlayPort(HexToAsc(To_Hex(@Packet[IpStart + 2 + Packet[IpStart + 2] - 3],4)));
  pIDStart := 0;

  for I := PacketLen - 3 downto 0 do
    if (PWord(@Packet[I])^ = $0073) then
    begin
      pIDStart := I; // == 73 00
      break;
    end;

    TEmpPos := 0;
    TempPacket[TempPos] := $73;
    Inc(TempPos);
    TempPacket[TempPos] := $00;
    Inc(TempPos);
    TempPacket[TempPos] := Length(BattleLocalIP) + 5;
    Inc(TempPos);
      for I := 0 to Length(BattleLocalIP) - 1 do
     TempPacket[TempPOs + I] := Ord(BattleLocalIP[I + 1]);
    Inc(TempPos,Length(BattleLocalIP));

    TempPacket[TempPos] := $3A;
    Inc(TempPos);

    for I := 0 to Length(BattleLocalPortStr) - 1 do
     TempPacket[TempPOs + I] := Ord(BattleLocalPortStr[I + 1]);
    Inc(TempPos,Length(BattleLocalPortStr));

    TempPacket[TempPos] := $FF;
    Inc(TempPos);
    CopyMemory(@TempPacket[TempPos],@Packet[pIDStart],Packet[pIDStart +2] + 3);
    Inc(TempPos,Packet[pIDStart +2] + 3);



  if (Packet[14] = $04) then begin

    TempPacket[TempPos] := $DB;
    Inc(TempPos);

    TempPacket[TempPos] := $62;
    Inc(TempPos);

    TempPacket[TempPos] := $00;
    Inc(TempPos);

    NewSize :=  TempPos + IpStart;
    Packet[3] := HiByte(NewSize);
    Packet[4] := LoByte(NewSize);
    CopyMemory(@Packet[IpStart],@TempPacket[0],TempPos);
  end else begin
    NewSize :=  TempPos + IpStart;
    Packet[3] := HiByte(NewSize);
    Packet[4] := LoByte(NewSize);
    CopyMemory(@Packet[IpStart],@TempPacket[0],TempPos);
  end;
end;

procedure TProxy.SetLobbyLocalPort(aLobbyLocalPort:String);
begin
  Self.LobbyLocalPort :=  StrToInt(aLobbyLocalPort);
  WriteLog(Format('LobbyLocalPort Set to (%s)',[aLobbyLocalPort]));
end;

function TProxy.GetLobbyLocalPort() : Word;
begin
  Result :=  Self.LobbyLocalPort;
end;

procedure TProxy.SetBattleLocalPort(aBattleLocalPort:String);
begin
  Self.BattleLocalPort :=  StrToInt(aBattleLocalPort);
  Self.BattleLocalPortStr :=  aBattleLocalPort;
  WriteLog(Format('BattleLocalPort Set to (%s)',[aBattleLocalPort]));
end;
function TProxy.GetBattleLocalPort() : Word;
begin
  Result  := Self.BattleLocalPort;
end;

procedure TProxy.SetBattleLocalIP(aBattleLocalIP:String);
begin
  Self.BattleLocalIP :=  aBattleLocalIP;
  WriteLog(Format('BattleLocalIP Set to (%s)',[aBattleLocalIP]));
end;

procedure TProxy.SetPlayIP(aPlayIP:String);
begin
  Self.PlayIP :=  aPlayIP;
  WriteLog(Format('PlayIP Set to (%s)',[aPlayIP]));
end;

function TProxy.GetPlayIP() : String;
begin
  Result  := Self.PlayIP;
end;


procedure TProxy.SetPlayPort(aPlayPort:String);
begin
  Self.PlayPort :=  StrToint(aPlayPort);
  WriteLog(Format('PlayPort Set to (%s)',[aPlayPort]));
end;

function TProxy.GetPlayPort() : Word;
begin
  Result  := Self.PlayPort;
end;

procedure TProxy.SetLobbyProxyIp(aLobbyProxyIp:String);
begin
  Self.LobbyProxyIp  := aLobbyProxyIp;
  WriteLog(Format('LobbyProxyIp Set to (%s)',[aLobbyProxyIp]));
end;

function TProxy.GetLobbyProxyIp() : String;
begin
  Result  := GetIp(Self.LobbyProxyIp);
end;

procedure TProxy.SetLobbyProxyPort(aLobbyProxyPort:String);
begin
  Self.LobbyProxyPort  := StrToint(aLobbyProxyPort);
  WriteLog(Format('LobbyProxyPort Set to (%s)',[aLobbyProxyPort]));
end;

function TProxy.GetLobbyProxyPort() : Word;
begin
  Result  := Self.LobbyProxyPort;
end;



procedure TProxy.WriteLog(S: string);
begin
  Form2.LogMemo.Lines.Add(Format('{%s} %s %s',
  [TimeToStr(Time),'Lobby',S]));
end;

function TProxy.GetIP(const HostName: string): string;
var
  WSAData: TWSAData;
  R: PHostEnt;
  A: TInAddr;
begin
  Result := '0.0.0.0'; // '0.0.0.0'
  WSAStartup($101, WSAData);
  R := Winsock.GetHostByName(PAnsiChar(AnsiString(HostName)));
  if Assigned(R) then
  begin
    A := PInAddr(r^.h_Addr_List^)^;
    Result := String(WinSock.inet_ntoa(A));
  end;
end;

end.
