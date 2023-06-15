unit uProxy2;

interface

uses
  Windows, SysUtils, ScktComp, Dialogs,uFunc, WinSock, uClasses;

type
  TProxy2 = class
  private
    Port: Word;
    PlayServer: TServerSocket;
    PlayClient: TClientSocket;
    aCurrPacket: TByteArray;
    aPacketLen : Integer;
    PacketQueueToServer: array [0 .. 9] of TByteArray;
    numOfPacketQueueToServer: Integer;
    CurrSock  : Integer;
    CurrServer: String;
    aCurrPacketLen : Integer;
    aQuebrado: TByteArray;
    aOndequebrou: integer;

    aSplitPacket: TByteArray;
    aSplitPos: integer;

    procedure OnClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OnError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OnConnect(Sender: TObject; Socket: TCustomWinSocket);
    function GetIP(const HostName: string): string;
  public
    State     : Boolean;
    ServerIP  : String;
    ServerPort : Word;
    procedure StopProxy;
    function StartProxy: Boolean;
    procedure DisconnectProxy;
    procedure WriteLog(S:String);
    procedure SetPort(CurrPort: Integer);
    constructor Create()overload;
    Destructor Destroy; Override;

  protected

  end;

  var
  ServerAddress: TIpV4;

implementation

uses MainUnit, uCards,Helper;

Destructor TProxy2.Destroy;
begin
  StopProxy;
  Self.Free;
  inherited;
end;

procedure TProxy2.WriteLog(S: string);
begin
  Form2.LogMemo.Lines.Add(Format('{%s} (%s:%d) %s',
  [TimeToStr(Time),CurrServer,Port,S]));
end;

constructor TProxy2.Create();
begin
  inherited;
   State := false;
   CurrServer := '0.0.0.0';

  PlayServer := TServerSocket.Create(nil);
  PlayServer.OnClientRead := OnClientRead;
  PlayServer.OnClientConnect := OnClientConnect;
  PlayServer.OnClientError := OnClientError;

  PlayClient := TClientSocket.Create(nil);
  PlayClient.OnRead := OnRead;
  PlayClient.OnDisconnect := OnDisconnect;
  PlayClient.OnError := OnError;
  PlayClient.OnConnect := OnConnect;

end;

procedure TProxy2.SetPort(CurrPort: Integer);
begin
  Port := CurrPort;
end;

{ Login Client -> Login Server }
procedure TProxy2.OnClientRead(Sender: TObject; Socket: TCustomWinSocket);
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

        //  if Form2.CheckBox1.Checked then
          //  addpackettolog(@aCurrPacket[I], aCurrPacketLen, 'Clear','4533', true);
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

          if (aCurrPacket[i + 8] = $06) then begin
             //FillMemory(@aCurrPacket[i + 18],aCurrPacketLen-18,$00);
          end;

          if (Form2.CheckBox1.Checked) then
            addpackettolog(@aCurrPacket[I], aCurrPacketLen, 'Clear',
              '4533', true);
        end;
                else
        WriteLog('PS2'+To_Hex(@aCurrPacket[I],1));
    end;

    if (aCurrPacketLen = 0) then
      Exit;

    if (Send) then
      if (PlayClient.Active) and (PlayClient.Socket.Connected) then
        PlayClient.Socket.SendBuf(aCurrPacket[I], aCurrPacketLen)
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
procedure TProxy2.OnRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I: integer;
  Send: Boolean;
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
       //   if Form2.CheckBox1.Checked then
            //addpackettolog(@aCurrPacket[I], aCurrPacketLen, 'Clear', '4533', false);
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
          if (aCurrPacket[i + 8] = $07) then begin
            // FillMemory(@aCurrPacket[i + 21],aCurrPacketLen-21,$00);
          end;
          { Packet Logger }
          if (Form2.CheckBox1.Checked) then
            addpackettolog(@aCurrPacket[I], aCurrPacketLen, 'Clear', '4533', false);
        end;
        else
         WriteLog('PC2'+To_Hex(@aCurrPacket[I],1));
    end;

    if (aCurrPacketLen = 0) then
      Exit;

    if Send then
      if (PlayServer.Socket.ActiveConnections > 0) and
        (PlayServer.Socket.Connections[0].Connected) then
        PlayServer.Socket.Connections[0].SendBuf(aCurrPacket[I], aCurrPacketLen);

    I := I + aCurrPacketLen;
  end;
end;

procedure TProxy2.OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  NumCon: Integer;
begin
  try
    CurrSock := Socket.SocketHandle;
      numOfPacketQueueToServer := 0;

      ServerAddress := Func.StrToIPv4(Socket.RemoteAddress);

    if PlayClient.Socket.Connected then
    begin
      WriteLog('PlayClient Socket Closed for a New Connection');
      PlayClient.Socket.Close;
    end;
     PlayClient.Open;
    if (PlayServer.Socket.ActiveConnections > 0) then
      for NumCon := 0 to PlayServer.Socket.ActiveConnections - 1 do
        if PlayServer.Socket.Connections[NumCon].SocketHandle <> CurrSock then
        begin
          WriteLog('Closed a Server Socket Not CurrSock');
          PlayServer.Socket.Connections[NumCon].Close;
        end;
  except
    on E: Exception do
      WriteLog(E.Message);

  end;

  WriteLog(Format('New Client Connected From (%s:%d)',
    [Socket.RemoteAddress,Socket.RemotePort]));
end;

procedure TProxy2.OnConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  J: Integer;
begin
  try
    aCurrPacket[0] := $FF;
  Pid(@aCurrPacket[1])^ := Pid(@ServerAddress[0])^;

  PWord(@aCurrPacket[5])^ := Pword(@Port)^;
 { CurrPacket[1] := ServerAddr[0];
  CurrPacket[2] := ServerAddr[1];
  CurrPacket[3] := ServerAddr[2];
  CurrPacket[4] := ServerAddr[3];   }

  PlayClient.Socket.SendBuf(aCurrPacket[0], 7);

    WriteLog(Format('Connected to Server (%s:%d)', [CurrServer, Port]));
    if (numOfPacketQueueToServer > 0) then
    begin
      for J := 0 to numOfPacketQueueToServer - 1 do
        PlayClient.Socket.SendBuf(PacketQueueToServer[J][0],
        (PacketQueueToServer[J][3] shl 8) or PacketQueueToServer[J][4]);
        numOfPacketQueueToServer := 0;
    end;
  except
    on E: Exception do
      WriteLog('OnConnect ' + E.Message);
  end;
end;

procedure TProxy2.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  WriteLog('PlayClient Disconnected');
end;

procedure TProxy2.OnClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  WriteLog('PlayServerError -> (' + IntToStr(ErrorCode) + ').');
  if ((ErrorCode = 10053) or (ErrorCode = 10054)) then
    ErrorCode := 0;
end;

procedure TProxy2.OnError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  WriteLog('PlayClientError -> (' + IntToStr(ErrorCode) + ').');
  if ((ErrorCode = 10053) or (ErrorCode = 10054)) then
    ErrorCode := 0;
end;

procedure TProxy2.StopProxy;
begin
  try
    DisconnectProxy;
    PlayServer.Close;
  except
    on E: Exception do
    begin
      Showmessage(E.Message);
      Exit;
    end;
  end;
  WriteLog('Proxy -> Stopped.');
end;

function TProxy2.StartProxy: Boolean;
begin
  Result := true;
  try
    PlayServer.Port := Port;
    PlayServer.Open;
    PlayClient.Address := GetIP(ServerIP);
    PlayClient.Port := ServerPort;
  except
    on E: Exception do
    begin
      Showmessage(E.Message);
      Result := False;
    end;
  end;
  State := true;
  if (Result) then
    WriteLog('Proxy -> Started (Listening : ' + IntToStr(Port) + ').');
end;

procedure TProxy2.DisconnectProxy;
var
I : integer;
begin
  PlayClient.Active := False;
  if (PlayServer.Socket.ActiveConnections > 0) then
  for I := 0 to PlayServer.Socket.ActiveConnections - 1 do
    PlayServer.Socket.Connections[I].Close;
  State := false;
  WriteLog('Proxy -> Disconnected.');
end;

function TProxy2.GetIP(const HostName: string): string;
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
    Result := WinSock.inet_ntoa(A);
  end;
end;

end.

