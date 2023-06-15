unit uProxy;

interface

uses
  Windows, SysUtils, ScktComp, Dialogs, Strutils, uClasses;

var
  PlayServer: TServerSocket;
  PlayClient: TClientSocket;

procedure StopProxy;
function StartProxy: Boolean;
procedure DisconnectProxy;

implementation

uses MainUnit, Helper, uCards, uBattle, uFunc,NewProxy;

type
  TEventObject = object
    procedure OnClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure OnError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure OnConnect(Sender: TObject; Socket: TCustomWinSocket);
  end;

var
  EventObject: TEventObject;
  CurrPacket: TByteArray;
  PacketLen: integer;
  PacketQueueToServer: array [0 .. 9] of TByteArray;
  numOfPacketQueueToServer: integer = 0;
  CurrPacketLen: integer;

  SplitPacket2: TByteArray;
  SplitPos2: integer;

  SplitPacket: TByteArray;
  SplitPos: integer;

  TempPacket  : TByteArray;

  DeckCount: integer = 0;
  CurrSock: integer;

  { Login Client -> Login Server }
procedure TEventObject.OnClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I: integer;
begin
   try
  //ZeroMemory(@CurrPacket,SizeOf(CurrPacket));

  PacketLen := Socket.ReceiveBuf(CurrPacket, SizeOf(CurrPacket));
  if (PacketLen < 3) then
    Exit;

  if (SplitPos > 0) then
  begin
    CopyMemory(@SplitPacket[SplitPos], @CurrPacket[0], PacketLen);
    PacketLen := PacketLen + SplitPos;
    CopyMemory(@CurrPacket[0], @SplitPacket[0], PacketLen);
    SplitPos := 0;
  end;

  I := 0;
  while (I < (PacketLen - 1)) do
  begin
    CurrPacketLen := 0;
    SendToServer := true;

    Case CurrPacket[I] of
      $F0:
        Begin
          CurrPacketLen := 5;
          ToServer.UpdateTimeSync(@CurrPacket[I]);
          if Form2.LogF0Checkbox.Checked then
            addpackettolog(@CurrPacket[I], CurrPacketLen, 'Clear', 'Battle1', true);
        end;
      $FB:
        Begin
          CurrPacketLen := (CurrPacket[I + 3] shl 8) or CurrPacket[I + 4];

          If (I + CurrPacketLen > PacketLen) then
          begin
            CopyMemory(@SplitPacket[0], @CurrPacket[I], (PacketLen - I));
            SplitPos := PacketLen - I;
            Exit;
          end;

          case PID(@CurrPacket[6 + I])^ of
            ts00F302FD:
              ToServer.onCardStat(@CurrPacket[I]);

            ts01F30001:
              case PID(@CurrPacket[10 + I])^ of
                $01411E06:
                  begin
                  End;
              end;

            ts01F30600:
              case PID(@CurrPacket[10 + I])^ of
                $78010100:
                  begin
                  End;
              end;

            ts01F302E6:
              case PID(@CurrPacket[10 + I])^ of
                $73DD0100:
                  begin
                  End;
              end;

            ts01F302E2:
              case PID(@CurrPacket[10 + I])^ of
                $73FF0300:
                  begin
                  End;
              end;

            ts01F302FC:
              case PID(@CurrPacket[10 + I])^ of
                $68FB0200:
                  begin
                  End;
                $68FB0300:
                  begin
                    if CurrPacket[I + 15] > 5 then
                    begin
                      SendToServer := false;
                      CopyMemory(@TempPacket[0], @CurrPacket[I], CurrPacketLen);
                      ToServer.OnSendDeck(@TempPacket[0]);
        if (Form2.FullLogCheckBox.Checked) then
        addpackettolog(@TempPacket[0], ((TempPacket[3] shl 8) or TempPacket[4]), 'Deck', 'Battle', true);

                      if (PlayClient.Active) then
                        PlayClient.Socket.SendBuf(TempPacket[0],
                          ((TempPacket[3] shl 8) or TempPacket[4]));
                    end;

                  end;
              end;

            ts01F302FD:
              case PID(@CurrPacket[10 + I])^ of
                $62F40200:
                  case CurrPacket[36 + I] of
                    $00:
                      ToServer.onSpell(@CurrPacket[I]);
                    $03:
                      ToServer.DieEvent(@CurrPacket[I]);
                    $0A:
                      ToServer.onDmg(@CurrPacket[I]);
                    $0B:
                      ToServer.OnKill(@CurrPacket[I]);

                  end;

                $62F40300:
                  case CurrPacket[14 + I] of
                    $CA:
                      ToServer.onMypID(@CurrPacket[I]);
                    $C8:
                      case CurrPacket[36 + I] of
                        $08:
                          begin
                          End;
                        $09:
                          ToServer.onNewKidRecvHit(@CurrPacket[I]);
                      end;

                    $D1:
                      begin
                      End;
                  end;

                $62F40400:
                  ToServer.OnCardDrop(@CurrPacket[I]);

              end;
          end;

          if ((Form2.FullLogCheckBox.Checked) and SendToServer) then
            addpackettolog(@CurrPacket[I], CurrPacketLen, 'Clear', 'Battle', true);
        end;
        else
        WriteLog('PC'+To_Hex(@CurrPacket[I],1));
    end;


    if (CurrPacketLen = 0) then
      Exit;

    if (SendToServer) then
      if (PlayClient.Active) and (PlayClient.Socket.Connected) then
        PlayClient.Socket.SendBuf(CurrPacket[I], CurrPacketLen)
      else
      begin
        CopyMemory(@PacketQueueToServer[numOfPacketQueueToServer][0],
          @CurrPacket[I], CurrPacketLen);
        inc(numOfPacketQueueToServer);
      end;

     I := I + CurrPacketLen;
   end;
    except
    on E: Exception do
      WriteLog('ToServer ' + E.Message);
  end;
end;


{ Login Server -> Login Client }
procedure TEventObject.OnRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I: integer;
begin
try
  PacketLen := Socket.ReceiveBuf(CurrPacket, SizeOf(CurrPacket));
  if (PacketLen < 3) then
    Exit;

  if (SplitPos2 > 0) then
  begin
    CopyMemory(@SplitPacket2[SplitPos2], @CurrPacket[0], PacketLen);
    PacketLen := PacketLen + SplitPos2;
    CopyMemory(@CurrPacket[0], @SplitPacket2[0], PacketLen);
    SplitPos2 := 0;
  end;

  I := 0;
  while (I < (PacketLen - 1)) do
  begin
    CurrPacketLen := 0;
    SendToClient := true;
    Case CurrPacket[I] of
      $F0:
        Begin
          CurrPacketLen := 9;
          ToClient.UpdateTimeSync(@CurrPacket[I]);
          if Form2.LogF0Checkbox.Checked then
            addpackettolog(@CurrPacket[I], CurrPacketLen, 'Clear', 'Battle', false);
        end;
      $FB:
        Begin
          CurrPacketLen := (CurrPacket[I + 3] shl 8) or CurrPacket[I + 4];

          If (I + CurrPacketLen > PacketLen) then
          begin
            CopyMemory(@SplitPacket2[0], @CurrPacket[I], (PacketLen - I));
            SplitPos2 := PacketLen - I;
            Exit;
          end;

          case PID(@CurrPacket[I + 6])^ of
            tc00F304C9: ToClient.onCardStat(@CurrPacket[I]);

            tc01F303E2: ToClient.OnRecvDeck2(@CurrPacket[I]);
            tc01F304FD:
              case PID(@CurrPacket[I + 10])^ of
                $68FB0300:  ToClient.OnRecvDeck(@CurrPacket[I]);
              end;
            tc01F304CA: ToClient.onOponentpID(@CurrPacket[I]);
            tc01F304C8:
              case PID(@CurrPacket[I + 10])^ of
                $68F50200:
                  case CurrPacket[I + 19] of
                    $00:  ToClient.SpellByChar(@CurrPacket[I]);
                    $02:  ToClient.ParseMeetCard(@CurrPacket[I]);
                    $03:  ToClient.DieEvent(@CurrPacket[I]);
                    $05:  ToCLient.onCardSpell(@CurrPacket[I]);
                    $09:  ToClient.OnDmgConfirm(@CurrPacket[I]);
                    $0A:  ToClient.onRecvDmg(@CurrPacket[I]);
                    $0B:  ToClient.OnKill(@CurrPacket[I]);
                  end;
              end;
          end;
          { Packet Logger }
          if (Form2.FullLogCheckBox.Checked) and SendToClient then
            addpackettolog(@CurrPacket[I], CurrPacketLen, 'Clear', 'Battle', false);
        end;
        else
         WriteLog('PS'+To_Hex(@CurrPacket[I],1));
    end;


    if (CurrPacketLen = 0) then
      Exit;

    if SendToClient then
      if (PlayServer.Socket.ActiveConnections > 0) and
        (PlayServer.Socket.Connections[0].Connected) then
        PlayServer.Socket.Connections[0].SendBuf(CurrPacket[I], CurrPacketLen);

    I := I + CurrPacketLen;
  end;
    except
    on E: Exception do
      WriteLog('ToCLient ' + E.Message);
  end;
end;

procedure TEventObject.OnClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  NumCon: integer;
begin
  CurrSock := Socket.SocketHandle;
  numOfPacketQueueToServer := 0;

  if PlayClient.Socket.Connected then
  begin
    WriteLog('PlayClient Socket Closed for a New Connection');
    PlayClient.Socket.Close;
  end;
  PlayClient.Port     := Proxy.GetPlayPort();
  PlayClient.Address  := Proxy.GetPlayIP();
  PlayClient.open;

  if (PlayServer.Socket.ActiveConnections > 0) then
    for NumCon := 0 to PlayServer.Socket.ActiveConnections - 1 do
      if PlayServer.Socket.Connections[NumCon].SocketHandle <> CurrSock then
      begin
        WriteLog('Closed a Server Socket Not CurrSock');
        PlayServer.Socket.Connections[NumCon].Close;
      end;

  ZeroMemory(@OponentInfo,sizeof(OponentInfo));
  Cards.ClearCardInfo();
  Cards.ClearOponentDeckInfo;
  numOfCards := 0;
  Form2.StatusBar1.Panels[0].Text := '';


  WriteLog('Game to Proxy-> (' + Socket.RemoteAddress + ') Now Connected');

end;

procedure TEventObject.OnConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  J, CurrSiz: integer;
begin
  WriteLog('Proxy to Server-> Connected ('+Proxy.GetPlayIP+')');

  if (numOfPacketQueueToServer > 0) then
  begin
    for J := 0 to numOfPacketQueueToServer - 1 do
    begin
      CurrSiz := (PacketQueueToServer[J][3] shl 8) or PacketQueueToServer[J][4];
      PlayClient.Socket.SendBuf(PacketQueueToServer[J][0], CurrSiz);
    end;
    numOfPacketQueueToServer := 0;
  end;

end;

procedure TEventObject.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  // Stopproxy;
end;

procedure TEventObject.OnClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin

  if ((ErrorCode = 10053) or (ErrorCode = 10054)) then
    DisconnectProxy
    else
    WriteLog('PlayServer -> Error (' + IntToStr(ErrorCode) + ')');

  ErrorCode := 0;
end;

procedure TEventObject.OnError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  if ((ErrorCode = 10053) or (ErrorCode = 10054)) then
    DisconnectProxy
    else
    WriteLog('PlayClient -> Error (' + IntToStr(ErrorCode) + ')');
  ErrorCode := 0;
end;

procedure StopProxy;
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
  Form2.ProxyButton.Caption := 'Start';
end;

function StartProxy: Boolean;
begin
  Result := true;

  try
    PlayServer.Port := Proxy.GetBattleLocalPort();
    PlayServer.open;
  except
    on E: Exception do
    begin
      Showmessage(E.Message);
      Result := false;
    end;
  end;
  if (Result) then
    WriteLog('Proxy -> Started (Local port : ' + IntToStr(Proxy.GetBattleLocalPort) + ')');
  if (Result) then
    Form2.ProxyButton.Caption := 'Stop';

end;

procedure DisconnectProxy;
begin
  PlayClient.Active := false;
  if (PlayServer.Socket.ActiveConnections > 0) then
    PlayServer.Socket.Connections[0].Close;
  WriteLog('Proxy -> Disconnected');
end;

begin
  PlayServer := TServerSocket.Create(nil);
  PlayClient := TClientSocket.Create(nil);
  PlayServer.OnClientRead := EventObject.OnClientRead;
  PlayServer.OnClientConnect := EventObject.OnClientConnect;
  PlayServer.OnClientError := EventObject.OnClientError;

  PlayClient.OnRead := EventObject.OnRead;
  PlayClient.OnDisconnect := EventObject.OnDisconnect;
  PlayClient.OnError := EventObject.OnError;
  PlayClient.OnConnect := EventObject.OnConnect;

end.
