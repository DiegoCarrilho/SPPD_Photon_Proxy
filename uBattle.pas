unit uBattle;

interface

uses
  Windows, Sysutils, ComCtrls, StdCtrls, Classes, ClipBrd, uCards, uClasses,
  Json,
  System.Generics.Collections;

type

  TToServer = class
  private

  public
    procedure AddSendDeckItem(Item: TSendDeckItem);
    procedure onDmg(Packet: PByteArray);
    procedure onKill(Packet: PByteArray);
    procedure DieEvent(Packet: PByteArray);
    procedure onCardStat(Packet: PByteArray);
    procedure onSpell(Packet: PByteArray);
    procedure onCardDrop(Packet: PByteArray);
    procedure onNewKidRecvHit(Packet: PByteArray);
    procedure onMypID(Packet: PByteArray);
    procedure UpdateTimeSync(Packet: PByteArray);
    procedure OnSendDeck(Packet: PByteArray);
    procedure ParseJson(Json: String);
  protected

  end;

  TToClient = class
  private

  public

    procedure ParseMeetCard(Packet: PByteArray);
    procedure onDmgConfirm(Packet: PByteArray);
    procedure onKill(Packet: PByteArray);
    procedure onOponentpID(Packet: PByteArray);
    procedure onRecvDmg(Packet: PByteArray);
    procedure onCardStat(Packet: PByteArray);
    procedure onCardSpell(Packet: PByteArray);
    procedure SpellByChar(Packet: PByteArray);
    procedure DieEvent(Packet: PByteArray);
    procedure UpdateTimeSync(Packet: PByteArray);
    procedure OnRecvDeck(Packet: PByteArray);
    procedure OnRecvDeck2(Packet: PByteArray);
    procedure ParseOponentDeck(Json: String);

  protected

  end;

var
  ToClient: TToClient;
  ToServer: TToServer;
  SendToClient : Boolean;
  SendToServer : Boolean;
  OponentInfo: TOponentInfo;
  MyBattleInfo: TMyBattleInfo;
  SendDeckItem: array [0 .. 20] of TSendDeckItem;
  SendDeckItemCount: Word = 0;

  SyncToServer: Tid;
  SyncToClient: Tid;

implementation

uses MainUnit, Helper, uFunc, uProxy;



procedure TToServer.AddSendDeckItem(Item: TSendDeckItem);
var
  K: integer;
  TempTid: Tid;
begin
  try
    if Form2.ChangeNameCheckBox.Checked and
      CompareMem(@Item.name, @EditDeckNameMask[0], 4) then
    begin
      WriteLog(Format('%s Changed From (%s) to (%s)',
        [HexToAsc(To_Hex(@Item.name, Item.nameSize)),
        HexToAsc(To_Hex(@Item.Info, Item.sizeInfo)),
        Form2.ChangeNameEdit.Text]));
      Item.sizeInfo := Length(Form2.ChangeNameEdit.Text);
      for K := 1 to Item.sizeInfo do
        Item.Info[K - 1] := Ord(Form2.ChangeNameEdit.Text[K]);
    end;

    if Form2.GoldenNameCheckBox.Checked and
      CompareMem(@Item.name, @GoldenNameMask[0], Length(GoldenNameMask)) then
    begin
      if Form2.GoldenNameCheckBox.Checked then
      begin
        PByte(@Item.Info)^ := $01;
        WriteLog(HexToAsc(To_Hex(@Item.name, Item.nameSize)) +
          ' Changed to True');
      end;
    end;

    if Form2.ChangerankCheckBox.Checked and
      (CompareMem(@Item.name, @EditRankMask[0], Length(EditRankMask)) or
      CompareMem(@Item.name, @EditRankMask2[0], Length(EditRankMask2))) then
    begin
      TempTid := InvDword(@Item.Info);
      TempTid := PID(@TempTid)^;
      WriteLog(Format('%s Changed From (%d) to (%d)',
        [HexToAsc(To_Hex(@Item.name, Item.nameSize)), TempTid,
        Form2.ChangeRankTrackBar.Position]));
      TempTid := Form2.ChangeRankTrackBar.Position;
      PID(@Item.Info)^ := InvDword(@TempTid);
    end;

    SendDeckItem[SendDeckItemCount] := Item;
    Inc(SendDeckItemCount);

    if (Form2.UpgradeCardsCheckBox.Checked) and
      (CompareMem(@Item.name[0], @DeckMask[0], 4)) then
      ParseJson(HexToAsc(To_Hex(@Item.Info, Item.sizeInfo)));

  except
    on E: Exception do
      WriteLog('AddDeckItem ' + E.Message);
  end;

end;

procedure TToServer.onDmg(Packet: PByteArray);
var
  HipID, LopID: Tid;
begin
  try
    HipID := PID(@Packet[43])^;
    LopID := PID(@Packet[22])^;

    if (Cards.IsMyCard(HipID)) and (Form2.OnehitKillCheckBox.Checked) then
    begin
      PID(@Packettest[29])^ := SyncToClient;
      PID(@Packettest[22])^ := LopID;
      PlayClient.Socket.SendBuf(Packettest, 37);

      PID(@Packettest2[23])^ := SyncToClient;
      PID(@Packettest2[30])^ := LopID;
      PlayServer.Socket.Connections[0].SendBuf(Packettest2, 40);

      Form2.OnehitKillCheckBox.Checked := not Form2.OnehitKillCheckBox.Checked;
    end;

    if (Form2.MyDmgLogCheckBox.Checked) then
      WriteLog2(Format('ToServer.onDmg %s hit (%d) %s, HP(%d)',
        [Cards.CardOwnerInf(HipID), InvDword(@Packet[48]),
        Cards.CardOwnerInf(LopID), InvDword(@Packet[53])]));

    if Form2.MyDmgPacketLogCheckBox.Checked then
      addpackettolog2(@Packet[0], 'ToServer.onDmg', true);

  except
    on E: Exception do
      WriteLog('TSonDmg ' + E.Message);
  end;
end;

procedure TToServer.onKill(Packet: PByteArray);
var
  LopID, HipID: Tid;
begin
  try
    HipID := PID(@Packet[43])^;
    LopID := PID(@Packet[22])^;

    if (Form2.KillEventLogCheckBox.Checked) then
      WriteLog2(Format('ToServer.OnKill: %s Killed %s',
        [Cards.CardOwnerInf(HipID), Cards.CardOwnerInf(LopID)]));

    if (Form2.KillEventPacketLogCheckBox.Checked) then
      addpackettolog2(@Packet[0], 'ToServer.OnKill', true);

  except
    on E: Exception do
      WriteLog('TToServer.onKill ' + E.Message);
  end;
end;

procedure TToServer.DieEvent(Packet: PByteArray);
var
  CurrDieEvent: TDieEventToServer;
begin
  try
    CurrDieEvent := PDieEventToServer(@Packet[0])^;
    Cards.RemoveCardFromBattle(CurrDieEvent.CardpID);

    if (Form2.DeathEventPacketLogCheckBox.Checked) then
      addpackettolog2(@Packet[0], 'ToServer.DieEvent', true);

    if (Form2.DeathEventLogCheckBox.Checked) then
      WriteLog2(Format('ToServer.DieEvent: %s Died',
        [Cards.CardOwnerInf(CurrDieEvent.CardpID)]));

  except
    on E: Exception do
      WriteLog('TSDieEvent ' + E.Message);
  end;
end;

procedure TToServer.onCardStat(Packet: PByteArray);
var
  I, J: integer;
  uCardStatNK: TCardStatUpdateNKToServer;
  uCardStat: TCardStatUpdate;
begin
  try
    J := 19;

    for I := 0 to Packet[18] - 3 do
    begin
      if (Packet[4 + J] = $05) then
      begin
        uCardStatNK := PCardStatUpdateNKToServer(@Packet[J])^;
        Cards.UpdateCardHP(uCardStatNK.CardpID,uCardStatNK.CardHP);
        Inc(J, 23);
      end
      else
      begin
        uCardStat := PCardStatUpdate(@Packet[J])^;

        if (not Cards.IsmyCard(uCardStat.CardpID) and
        Form2.InvincibleCheckBox.Checked) then begin
          if (swap(Pword(@Packet[J+21])^) > 0) then begin
           Packet[J +19] := $00;
           Packet[J +20] := $00;
           Packet[J +21] := $00;
           Packet[J +22] := $00;
          end;
        end;

        Cards.UpdateCardHP(uCardStat.CardpID, uCardStat.CardHP);
        Inc(J, 78);
      end;
    end;
  except
    on E: Exception do
      WriteLog('TS CardStat ' + E.Message);
  end;
end;

procedure TToServer.onSpell(Packet: PByteArray);
begin
  try

    WriteLog(Format('%s Spell (%s)', [Cards.CardOwnerInf(PID(@Packet[22])^),
      Rep00(To_Hex(@Packet[45], 4))]));
  except
    on E: Exception do
      WriteLog('TS OnSpell ' + E.Message);
  end;
end;

procedure TToServer.onCardDrop(Packet: PByteArray);
var
  OldLevel: Dword;
begin
  try

    if Form2.CardDropPacketCheckBox.Checked then
      addpackettolog2(@Packet[0], 'Card Drop', true);

    if (Packet[36] = $02) and (Packet[62] = $00) then
    begin
      if (Form2.ChangeCardTypeCheckBox.Checked) then begin
      PID(@Packet[43])^ := ListofCards[Form2.ComboBox1.ItemIndex,0].ToInteger();
      PID(@Packet[43])^ := InvDword(@Packet[43]);
      end;
      if Form2.UpgradeCardsCheckBox.Checked then begin
      PWord(@Packet[103 + (Packet[70] * 4)])^ := Swap(MAX_Bits);
      OldLevel := InvDword(@Packet[64]) + 1;

      case Cards.getCardType(PID(@Packet[43])^) of
        1:
          Begin
            if (InvDword(@LastCardDrop) = 2290) then
              Packet[67] := Form2.RareLevelTrackBar.Position - 1
            else
              Packet[67] := Form2.CommomLevelTrackBar.Position - 1
          end;
        2:
          Packet[67] := Form2.RareLevelTrackBar.Position - 1;
        3:
          Packet[67] := Form2.EpicLevelTrackBar.Position - 1;
        4:
          Packet[67] := Form2.LegendaryLevelTrackBar.Position - 1;
      end;
      LastCardDrop := PID(@Packet[43])^;
      if Form2.CardDropCheckBox.Checked then
        WriteLog2(Format('New Card Drop (%s), LVL (%d), Upgraded to LVL (%d)',
          [Cards.getCardName(PID(@Packet[43])^), OldLevel,
          InvDword(@Packet[64]) + 1]));
      end;
    end
    else if (Packet[36] = $05) then
    begin
      if Form2.CardDropCheckBox.Checked then
        WriteLog2(Format('New Spell Drop (%s), LVL (%d), Upgraded to LVL (%d)',
          [Cards.getCardName(PID(@Packet[43])^), 0, 0]));
    end
    else if Form2.CardDropCheckBox.Checked then
    begin
      WriteLog2('newKid ' + To_Hex(@Packet[0], (Packet[3] shl 8) or Packet[4]));
    end;

  except
    on E: Exception do
      WriteLog('TS OnCardDrop ' + E.Message);
  end;
end;

procedure TToServer.onNewKidRecvHit(Packet: PByteArray);
var
  HipID, LopID: Tid;
begin
  try

    HipID := PID(@Packet[43])^;
    LopID := PID(@Packet[22])^;

    if (Form2.RecvDmgNKLogCheckBox.Checked) then
      WriteLog2(Format('TToServer.onNewKidRecvHit %s hit (%d) %s, HP(%d)',
        [Cards.CardOwnerInf(HipID), InvDword(@Packet[48]),
        Cards.CardOwnerInf(LopID), InvDword(@Packet[53])]));

    if Form2.RecvDmgNKPacketLogCheckBox.Checked then
      addpackettolog2(@Packet[0], 'ToServer.onNewKidRecvHit', true);

  except
    on E: Exception do
      WriteLog('TToServer.OnNewKidRecvHit ' + E.Message);
  end;
end;

procedure TToServer.onMypID(Packet: PByteArray);
var
CurrCard : TCardInfo;
SecondpID : TID;
begin
  try
      MyBattleInfo.PID    := PID(@Packet[49])^;
      SecondpID           := PID(@Packet[53])^;
      CurrCard.CardID     := $02000000;
      CurrCard.CardLevel  := $00000000;
      CurrCard.CardpID    := MyBattleInfo.PID;
      CurrCard.CurrHP     := 0;
      CurrCard.MaxHP      := 0;
      CurrCard.OwnerPID   := MyBattleInfo.PID;
      CurrCard.CardName   := Cards.getCardName(CurrCard.CardID);
      CurrCard.Dead       := False;
      CurrCard.FirstHP    := false;
      CurrCard.CustomHP   := 0;
      Cards.AddCardToBattle(CurrCard);

      CurrCard.CardpID    := SecondpID;
      Cards.AddCardToBattle(CurrCard);

    if Form2.MeetMypIDCheckBox.Checked then
      WriteLog2('My Battle pID Found (' + Rep00(To_Hex(@MyBattleInfo.PID,
        4)) + ')');

    if Form2.MeetMypIDPacketCheckBox.Checked then
      addpackettolog2(@Packet[0], 'My Battle pID', true);

  except
    on E: Exception do
      WriteLog('TSOnMypID ' + E.Message);
  end;
end;

procedure TToServer.UpdateTimeSync(Packet: PByteArray);
begin
  try
    SyncToServer := PID(@Packet[1])^;
  except
    on E: Exception do
      WriteLog('TS UpdateSync ' + E.Message);
  end;
end;

procedure TToServer.OnSendDeck(Packet: PByteArray);
var
  I, J, K: integer;
  CurrItem: TSendDeckItem;
begin
  try
    { Parse Send Deck Info to TSendDeckItem }
    SendDeckItemCount := 0;
    ZeroMemory(@SendDeckItem, SizeOf(SendDeckItem));
    J := 16;
    for I := 0 to (Packet[14] shl 8) or Packet[15] do
    begin
      ZeroMemory(@CurrItem, SizeOf(CurrItem));
      case Packet[J] of
        $73:
          begin
            CurrItem.Header := $73;
            CurrItem.nameSize := (Packet[J + 1] shl 8) or Packet[J + 2];
            CopyMemory(@CurrItem.name[0], @Packet[J + 3], CurrItem.nameSize);
            Inc(J, 3 + CurrItem.nameSize);
          end;
        $FE:
          begin
            CurrItem.Header := $FE;
            CurrItem.sizeInfo := 8;
            CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
          end;
      end;

      CurrItem.Tipo := Packet[J];
      if (Packet[J] <> $FE) then
        case Packet[J] of
          $73:
            begin
              CurrItem.sizeInfo := (Packet[J + 1] shl 8) or Packet[J + 2];
              CopyMemory(@CurrItem.Info, @Packet[J + 3], CurrItem.sizeInfo);
              Inc(J, 3 + CurrItem.sizeInfo);
            end;
          $6C:
            begin
              CurrItem.sizeInfo := 8;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
          $69:
            begin
              CurrItem.sizeInfo := 4;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
          $6F:
            begin
              CurrItem.sizeInfo := 1;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
        end;

      AddSendDeckItem(CurrItem);

    end;
    { Parse Send Deck Info End }

    { Create New Send Deck Packet }

    K := 0;
    PByte(@Packet[K])^ := $FB;
    PID(@Packet[K + 1])^ := 0;
    PByte(@Packet[K + 5])^ := 0;
    PID(@Packet[K + 6])^ := $FC02F301;
    PID(@Packet[K + 10])^ := $68FB0300;
    PWord(@Packet[K + 14])^ := Swap(SendDeckItemCount - 1);
    Inc(K, 16);

    for I := 0 to SendDeckItemCount - 1 do
    begin

      case SendDeckItem[I].Header of
        $FE:
          Begin
            Packet[K] := PByte(@SendDeckItem[I].Tipo)^;
            Inc(K, 1);
            PTechTreebits(@Packet[K])^ := PTechTreebits(@SendDeckItem[I].Info)^;
            Inc(K, 8);
          End;
        $73:
          begin

            Packet[K] := PByte(@SendDeckItem[I].Header)^;
            Inc(K, 1);
            PWord(@Packet[K])^ := Swap(SendDeckItem[I].nameSize);
            Inc(K, 2);
            CopyMemory(@Packet[K], @SendDeckItem[I].name,
              SendDeckItem[I].nameSize); // Value
            Inc(K, SendDeckItem[I].nameSize);

            case SendDeckItem[I].Tipo of
              $73:
                begin
                  Packet[K] := PByte(@SendDeckItem[I].Tipo)^;
                  Inc(K, 1);
                  PWord(@Packet[K])^ := Swap(SendDeckItem[I].sizeInfo);
                  Inc(K, 2);
                  CopyMemory(@Packet[K], @SendDeckItem[I].Info,
                    SendDeckItem[I].sizeInfo);
                  Inc(K, SendDeckItem[I].sizeInfo);
                end;
              $6C:
                begin
                  Packet[K] := PByte(@SendDeckItem[I].Tipo)^;
                  Inc(K, 1);
                  PTechTreebits(@Packet[K])^ :=
                    PTechTreebits(@SendDeckItem[I].Info)^;
                  Inc(K, 8);
                end;
              $69:
                begin
                  Packet[K] := PByte(@SendDeckItem[I].Tipo)^;
                  Inc(K, 1);
                  PID(@Packet[K])^ := PID(@SendDeckItem[I].Info)^;
                  Inc(K, 4);
                end;
              $6F:
                begin
                  Packet[K] := PByte(@SendDeckItem[I].Tipo)^;
                  Inc(K, 1);
                  Packet[K] := PByte(@SendDeckItem[I].Info)^;
                  Inc(K, 1);
                end;
            end;
          end;
      end;

    end;
    PWord(@Packet[3])^ := Swap(K);
    { Create New Send Deck Packet End }

  except
    on E: Exception do
      WriteLog('TSOnSendDeck ' + E.Message);
  end;
end;

procedure TToServer.ParseJson(Json: String);
var
  CList: TStringlist;
  I, J: integer;
  NewDeck: String;
  PExp: String;
  DeckPos: integer;
begin
  try
    CList := TStringlist.Create;
    CList.Text := StringReplace(Json, ',', Char(13) + Char(10), [rfReplaceAll]);

    DeckPos := -1;
    for I := SendDeckItemCount - 1 downto 0 do
      if CompareMem(@SendDeckItem[I].name, @MetaDeckMask[0], 4) then
      begin
        DeckPos := I;
        break;
      end;

    if (DeckPos = -1) then
      Exit;

    PExp := Get_Data('"PlayerExperience": ', Char($0A),
      HexToAsc(To_Hex(@SendDeckItem[I].Info, SendDeckItem[I].sizeInfo)));

    WriteLog(Format('Your PlayerExperience is (%s)', [PExp]));
    if Form2.ChangePlayerExpCheckBox.Checked then
    begin
      WriteLog(Format('Player Exp Changed From (%s) To (%d)',
        [PExp, Form2.ChangePlayerExpTrackbar.Position]));
      PExp := IntToStr(Form2.ChangePlayerExpTrackbar.Position);
    end;

    NewDeck := Format(HexToAsc(To_Hex(@SendDeckStr, Length(SendDeckStr))),
      [CList[0], CList[1], CList[2], CList[3], CList[4], CList[5], CList[6],
      CList[7], CList[8], CList[9], CList[10], CList[11], CList[0],
      Cards.BitEdit(CList[0]), Cards.LevelEdit(CList[0]), CList[1],
      Cards.BitEdit(CList[1]), Cards.LevelEdit(CList[1]), CList[2],
      Cards.BitEdit(CList[2]), Cards.LevelEdit(CList[2]), CList[3],
      Cards.BitEdit(CList[3]), Cards.LevelEdit(CList[3]), CList[4],
      Cards.BitEdit(CList[4]), Cards.LevelEdit(CList[4]), CList[5],
      Cards.BitEdit(CList[5]), Cards.LevelEdit(CList[5]), CList[6],
      Cards.BitEdit(CList[6]), Cards.LevelEdit(CList[6]), CList[7],
      Cards.BitEdit(CList[7]), Cards.LevelEdit(CList[7]), CList[8],
      Cards.BitEdit(CList[8]), Cards.LevelEdit(CList[8]), CList[9],
      Cards.BitEdit(CList[9]), Cards.LevelEdit(CList[9]), CList[10],
      Cards.BitEdit(CList[10]), Cards.LevelEdit(CList[10]), CList[11],
      Cards.BitEdit(CList[11]), Cards.LevelEdit(CList[11]), PExp]);

    SendDeckItem[DeckPos].sizeInfo := Length(NewDeck);
    for J := 1 to SendDeckItem[DeckPos].sizeInfo do
      SendDeckItem[DeckPos].Info[J - 1] := Ord(NewDeck[J]);

  except
    on E: Exception do
      WriteLog('TsParseJson ' + E.Message);
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////


procedure TToClient.ParseMeetCard(Packet: PByteArray);
var
  MeetCardA: TMeetCardA;
  MeetCardB: TMeetCardB;
  PidList: TMeetCardPidList;
  MeetBStart: integer;
  CurrCard: TCardInfo;
  I: integer;
begin
  try
    if Form2.MeetCardLogPacketCheckBox.Checked then
      addpackettolog2(@Packet[0], 'Meet Card', False);

    MeetCardA := PMeetCardA(@Packet[20])^;
    MeetBStart := Swap(MeetCardA.CardCharQnt) * 4;
    PidList := PMeetCardPidList(@Packet[55])^;
    MeetCardB := PMeetCardB(@Packet[55 + MeetBStart])^;

    for I := 1 to Swap(MeetCardA.CardCharQnt) do
    begin
      CurrCard.CardID := MeetCardA.CardID;
      CurrCard.CardLevel := MeetCardA.CardLevel;
      CurrCard.CardpID := PidList.PID[I - 1];
      CurrCard.CurrHP := 0;
      CurrCard.MaxHP := 0;
      CurrCard.TechTreeBits := MeetCardB.TechTreeBits;
      CurrCard.OwnerPID := MeetCardB.OwnerPID;
      CurrCard.CardName := Cards.getCardName(MeetCardA.CardID);
      CurrCard.Dead := False;
      CurrCard.FirstHP := true;
      CurrCard.CustomHP := 0;
      Cards.AddCardToBattle(CurrCard);

    end;

  except
    on E: Exception do
      WriteLog('TCParseMeetCard ' + E.Message);
  end;


  if (CurrCard.CardID <> $01000000) then begin

      if (MeetCardB.OwnerPID = OponentInfo.PID) then begin
      if Form2.DowngradeOponentCardLVLCheckBox.Checked then begin
          Packet[50] := Packet[50] - Form2.DownGradeOpoenentCardLVLTrackBar.Position;
          if (Packet[50] > 6) then
           Packet[50] := 0;
          WriteLog(Format('ToClient.MeetCard: %s Downgraded to %d',
        [Cards.CardOwnerInf(CurrCard.CardpID),Packet[50] + 1]));
      end;
      end
      else begin

      if Form2.CheckBox3.Checked then begin
      Packet[50] := Packet[50] + Form2.DownGradeOpoenentCardLVLTrackBar.Position;
      if (Packet[50] > 6) then
      Packet[50] := 6;

          WriteLog(Format('ToClient.MeetCard: %s Upgraded to %d',
        [Cards.CardOwnerInf(CurrCard.CardpID),Packet[50] + 1]));
      end;
      end;

  end
  else begin
     if (MeetCardB.OwnerPID = OponentInfo.PID) then
     OponentInfo.NKpID := CurrCard.CardpID;

  end;

end;

procedure TToClient.DieEvent(Packet: PByteArray);
var
  CurrDieEvent: TDieEventFromServer;
begin
  try
    CurrDieEvent := PDieEventFromServer(@Packet[0])^;
    Cards.RemoveCardFromBattle(CurrDieEvent.CardpID);
    if (Form2.OponentCardDiedLogCheckBox.Checked) then
      WriteLog2(Format('ToClient.DieEvent: %s Died',
        [Cards.CardOwnerInf(CurrDieEvent.CardpID)]));
    if (Form2.OponentCardDiedPacketLogCheckBox.Checked) then
      addpackettolog2(@Packet[0], 'ToClient.DieEvent', False);

  except
    on E: Exception do
      WriteLog('TCDieEvent ' + E.Message);
  end;
end;

procedure TToClient.onKill(Packet: PByteArray);
var
  LopID, HipID: Tid;
begin
  try
    HipID := PID(@Packet[61])^;
    LopID := PID(@Packet[26])^;

    if Form2.KillEventLogCheckBox.Checked then
      WriteLog2(Format('ToClient.OnKill: %s Killed %s',
        [Cards.CardOwnerInf(LopID), Cards.CardOwnerInf(HipID)]));

    if Form2.KillEventPacketLogCheckBox.Checked then
      addpackettolog2(@Packet[0], 'ToClient.OnKill', False);

  except
    on E: Exception do
      WriteLog('TCOnkill ' + E.Message);
  end;
end;

procedure TToClient.onCardSpell(Packet: PByteArray);
var
  LopID, HipID: Tid;
begin
  try
    LopID := PID(@Packet[26])^;
    HipID := PID(@Packet[63])^;

          WriteLog2(Format('ToClient.onCardSpell: %s Card Spelled %s',
        [Cards.CardOwnerInf(HipID),Cards.getCardName(LopID)]));


    if ((Form2.BlockSpellsCheckBox.Checked) and not Cards.IsMyCard(HipID)) then
    begin
        SendToClient := False;
      WriteLog2('ToClient.onCardSpell Blocked: ' + Cards.getCardName(LopID));
      Form2.StatusBar1.Panels[0].Text := 'CardSpell Blocked: ' + Cards.getCardName(LopID);
    end;

  except
    on E: Exception do
      WriteLog('ToClient.onCardSpell ' + E.Message);
  end;
end;



procedure TToClient.SpellByChar(Packet: PByteArray);
//var
 // CurrCard: Tid;
begin
  try
    //CurrCard := PID(@Packet[56])^;
 //WriteLog2(Format('ToClient.SpellByChar %s Spell(%s)',
     //   [Cards.CardOwnerInf(CurrCard),To_Hex(@Packet[28],4)]));
  except
    on E: Exception do
      WriteLog('ToClient.SpellByChar ' + E.Message);
  end;
end;

procedure TToClient.onDmgConfirm(Packet: PByteArray);
var
  HipID, LopID: Tid;
begin
  try
    HipID := PID(@Packet[61])^;
    LopID := PID(@Packet[26])^;
    ///////////----------------------------------------------------------------

    ///////////----------------------------------------------------------------
    if (Form2.MyDmgConfirmLogCheckBox.Checked) then
      WriteLog2(Format('ToClient.onDmgConfirm %s hit (%d) %s, HP(%d)',
        [Cards.CardOwnerInf(LopID), InvDword(@Packet[31]),
        Cards.CardOwnerInf(HipID), InvDword(@Packet[36])]));

    if Form2.MyDmgConfirmPacketLogCheckBox.Checked then
      addpackettolog2(@Packet[0], 'My Dmg', true);
  except
    on E: Exception do
      WriteLog('TCOnDmgConfirm ' + E.Message);
  end;

end;

procedure TToClient.onRecvDmg(Packet: PByteArray);
var
  LopID, HipID: Tid;
begin
  try
    LopID := PID(@Packet[26])^;
    HipID := PID(@Packet[61])^;

    if (Form2.RecvDmgLogCheckBox.Checked) then
      WriteLog2(Format('ToClient.onRecvDmg %s hit (%d) %s, HP(%d)',
        [Cards.CardOwnerInf(LopID), InvDword(@Packet[31]),
        Cards.CardOwnerInf(HipID), InvDword(@Packet[36])]));

    if Form2.RecvDmgPacketLogCheckBox.Checked then
      addpackettolog2(@Packet[0], 'Recv Dmg', False);

  except
    on E: Exception do
      WriteLog('TCOnRecvDmg ' + E.Message);
  end;
end;

procedure TToClient.onOponentpID(Packet: PByteArray);
var
CurrCard : TCardInfo;
SecondpID : TID;
begin
  try
    OponentInfo.PID := PID(@Packet[36])^;
    SecondpID := PID(@Packet[40])^;

      CurrCard.CardID := $02000000;
      CurrCard.CardLevel := $00000000;
      CurrCard.CardpID := OponentInfo.PID;
      CurrCard.CurrHP := 0;
      CurrCard.MaxHP := 0;
      CurrCard.OwnerPID := OponentInfo.PID;
      CurrCard.CardName := Cards.getCardName(CurrCard.CardID);
      CurrCard.Dead := False;
      CurrCard.FirstHP := false;
      CurrCard.CustomHP := 0;
      Cards.AddCardToBattle(CurrCard);

      CurrCard.CardpID := SecondpID;
      Cards.AddCardToBattle(CurrCard);
    if Form2.MeetOponentpIDCheckBox.Checked then
      WriteLog2('Oponent Battle pID (' + Rep00(To_Hex(@OponentInfo.PID,
        4)) + ')');

    if Form2.MeetOponentpIDPacketCheckBox.Checked then
      addpackettolog2(@Packet[0], 'Oponent Battle pID', False);

  except
    on E: Exception do
      WriteLog('TCOnOponentpID ' + E.Message);
  end;
end;

procedure TToClient.onCardStat(Packet: PByteArray);
var
  I, J: integer;
  uCardStatNK: TCardStatUpdateNKToClient;
  uCardStat: TCardStatUpdate;
begin
  try
    J := 16;

    for I := 0 to Packet[15] - 3 do
    begin
      if (Packet[4 + J] = $05) then
      begin
        uCardStatNK := PCardStatUpdateNKToClient(@Packet[J])^;
        Cards.UpdateCardHP(uCardStatNK.CardpID,uCardStatNK.CardHP);
        Inc(J, 35);
      end
      else
      begin
        uCardStat := PCardStatUpdate(@Packet[J])^;

        if not Cards.IsmyCard(uCardStat.CardpID) and (Form2.InvincibleCheckBox.Checked)
        then begin
          if (swap(Pword(@Packet[J+21])^) > 0) then begin
           Packet[J +19] := $00;
           Packet[J +20] := $00;
           Packet[J +21] := $00;
           Packet[J +22] := $00;
          end;
        end;


        Cards.UpdateCardHP(uCardStat.CardpID, uCardStat.CardHP);
        Inc(J, 78);
      end;

    end;

  except
    on E: Exception do
      WriteLog('TcOnCardStat ' + E.Message);
  end;
end;

procedure TToClient.UpdateTimeSync(Packet: PByteArray);
begin
  try
    SyncToClient := PID(@Packet[1])^;
  except
    on E: Exception do
      WriteLog('TC UpdateSync ' + E.Message);
  end;
end;

procedure TToClient.OnRecvDeck(Packet: PByteArray);
var
  I, J, K: integer;
  CurrItem: TSendDeckItem;
begin
  try
    { Parse Recv Deck Info }
    K := (Packet[14] shl 8) or Packet[15];
    if K < 6 then
      Exit;
    J := 16;
    for I := 0 to K do
    begin
      ZeroMemory(@CurrItem, SizeOf(CurrItem));
      case Packet[J] of
        $73:
          begin
            CurrItem.Header := $73;
            CurrItem.nameSize := (Packet[J + 1] shl 8) or Packet[J + 2];
            CopyMemory(@CurrItem.name[0], @Packet[J + 3], CurrItem.nameSize);
            Inc(J, 3 + CurrItem.nameSize);
          end;
        $FE:
          begin
            CurrItem.Header := $FE;
            CurrItem.sizeInfo := 8;
            CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
          end;
      end;

      CurrItem.Tipo := Packet[J];
      if (Packet[J] <> $FE) then
        case Packet[J] of
          $73:
            begin
              CurrItem.sizeInfo := (Packet[J + 1] shl 8) or Packet[J + 2];
              CopyMemory(@CurrItem.Info, @Packet[J + 3], CurrItem.sizeInfo);
              Inc(J, 3 + CurrItem.sizeInfo);
            end;
          $6C:
            begin
              CurrItem.sizeInfo := 8;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
          $69:
            begin
              CurrItem.sizeInfo := 4;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
          $6F:
            begin
              CurrItem.sizeInfo := 1;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
        end;

      if (CompareMem(@CurrItem.name[0], @MetaDeckMask[0], 4)) then
        ParseOponentDeck(HexToAsc(To_Hex(@CurrItem.Info, CurrItem.sizeInfo)));

      if (CompareMem(@CurrItem.name[0], @EditDeckNameMask[0], 4)) then
        Form2.OponentNameStaticText.Caption :=
          HexToAsc(To_Hex(@CurrItem.Info, CurrItem.sizeInfo));

    end;
    { Parse Recv Deck Info End }

  except
    on E: Exception do
      WriteLog('TC OnRecvDeck ' + E.Message);
  end;
end;

procedure TToClient.OnRecvDeck2(Packet: PByteArray);
var
  I, J, K: integer;
  CurrItem: TSendDeckItem;
begin
  try
    { Parse Recv Deck Info }
    K := (Packet[31] shl 8) or Packet[32];
    if K < 6 then
      Exit;
    J := 33;
    for I := 0 to K do
    begin
      ZeroMemory(@CurrItem, SizeOf(CurrItem));
      case Packet[J] of
        $73:
          begin
            CurrItem.Header := $73;
            CurrItem.nameSize := (Packet[J + 1] shl 8) or Packet[J + 2];
            CopyMemory(@CurrItem.name[0], @Packet[J + 3], CurrItem.nameSize);
            Inc(J, 3 + CurrItem.nameSize);
          end;
        $FE:
          begin
            CurrItem.Header := $FE;
            CurrItem.sizeInfo := 8;
            CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
          end;
      end;

      CurrItem.Tipo := Packet[J];
      if (Packet[J] <> $FE) then
        case Packet[J] of
          $73:
            begin
              CurrItem.sizeInfo := (Packet[J + 1] shl 8) or Packet[J + 2];
              CopyMemory(@CurrItem.Info, @Packet[J + 3], CurrItem.sizeInfo);
              Inc(J, 3 + CurrItem.sizeInfo);
            end;
          $6C:
            begin
              CurrItem.sizeInfo := 8;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
          $69:
            begin
              CurrItem.sizeInfo := 4;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
          $6F:
            begin
              CurrItem.sizeInfo := 1;
              CopyMemory(@CurrItem.Info, @Packet[J + 1], CurrItem.sizeInfo);
              Inc(J, 1 + CurrItem.sizeInfo);
            end;
        end;

      if (CompareMem(@CurrItem.name[0], @MetaDeckMask[0], 4)) then
        ParseOponentDeck(HexToAsc(To_Hex(@CurrItem.Info, CurrItem.sizeInfo)));

      if (CompareMem(@CurrItem.name[0], @EditDeckNameMask[0], 4)) then
        Form2.OponentNameStaticText.Caption :=
          HexToAsc(To_Hex(@CurrItem.Info, CurrItem.sizeInfo));

    end;
    { Parse Recv Deck Info End }

  except
    on E: Exception do
      WriteLog('TC OnRecvDeck ' + E.Message);
  end;
end;

procedure TToClient.ParseOponentDeck(Json: String);
var
  jsonObj, jSubObj: TJSONObject;
  ja: TJSONArray;
  jv: TJSONValue;
  I: integer;
begin
  try
    jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Json), 0)
      as TJSONObject;
    jv := jsonObj.Get('Cards').JsonValue;
    ja := jv as TJSONArray;
    for I := 0 to ja.Count - 1 do
    begin
      jSubObj := (ja.Items[I] as TJSONObject);
      Form2.OponentDeckCard(I + 1, jSubObj.Values['Id'].Value.ToInteger,
        Cards.CardLevelAndBits(jSubObj.Values['Id'].Value.ToInteger,
        jSubObj.Values['StarLevel'].Value.ToInteger,
        jSubObj.Values['TechTreeBits'].Value.ToInteger));
    end;

  except
    on E: Exception do
      WriteLog('TcParseJson ' + E.Message);
  end;

end;

end.
