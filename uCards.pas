unit uCards;

interface

uses
  Windows, Sysutils, ComCtrls, StdCtrls, Classes, ClipBrd, uClasses;
  //Card Type for Card List
  const
    NEWKID    = 0;
    COMMOM    = 1;
    RARE      = 2;
    EPIC      = 3;
    LEGENDARY = 4;
    SPELL     = 5;
    CARD_QNT  = 154;
    MAX_Bits  = 32767;

ListofCards: array [0..CARD_QNT - 1, 0..2] of string =
(
('0', 'unknown', '0'),
('1', 'NEW KID', '0'),
('2', 'BattlepID', '0'),
('8', 'MEDICINE WOMAN SHARON', '2'),
('10', 'POCAHONTAS RANDY', '3'),
('12', 'STAN OF MANY MOONS', '4'),
('15', 'NATHAN', '2'),
('24', 'FIREBALL', '5'),
('27', 'DECKHAND BUTTERS', '1'),
('28', 'OUTLAW TWEEK', '1'),
('29', 'STAN THE GREAT', '1'),
('30', 'PROGRAM STAN', '3'),
('31', 'POSEIDON STAN', '1'),
('32', 'GRAND WIZARD CARTMAN', '4'),
('35', 'GUNSLINGER KYLE', '1'),
('37', 'PRINCESS KENNY', '1'),
('38', 'A.W.E.S.O.M.-O 4000', '3'),
('39', 'LITLE CHOIR BOY', '3'),
('40', 'FREEZE RAY', '5'),
('44', 'SEXY NUN RANDY', '3'),
('45', 'SHERIFF CARTMAN', '2'),
('46', 'WARBOY TWEEK', '2'),
('47', 'Robin TWEEK', '1'),
('48', 'INCAN CRAIG', '4'),
('50', 'HOOKHAND CLYDE', '3'),
('51', 'HERCULES CLYDE', '2'),
('52', 'ICE SNIPER WENDY', '2'),
('54', 'ROGUE TOKEN', '3'),
('55', 'ASTRONAUT BUTTERS', '1'),
('57', 'PALADIN BUTTERS', '1'),
('84', 'CHOIRBOY BUTTERS', '3'),
('85', 'HALLELUJAH', '5'),
('86', 'ANGEL WENDY', '1'),
('87', 'POPE TIMMY', '3'),
('88', 'MECHA TIMMY', '4'),
('89', 'KYLE OF THE DROW ELVES', '2'),
('91', 'CATAPULT TIMMY', '2'),
('92', 'PIRATE SHIP TIMMY', '2'),
('131', 'SMUGGLER IKE', '1'),
('132', 'SCOUT IKE', '1'),
('133', 'GIZMO IKE', '3'),
('134', 'INUIT KENNY', '4'),
('135', 'THE AMAZINGLY RANDY', '3'),
('137', 'SIXTH ELEMENT RANDY', '4'),
('138', 'HERMES KENNY', '3'),
('140', 'CAPTAIN WENDY', '2'),
('141', 'SHIELDMAIDEN WENDY', '4'),
('144', 'CANADIAN KNIGHT IKE', '2'),
('146', 'CYBORG KENNY', '3'),
('158', 'ZEN CARTMAN', '2'),
('176', 'WITCH GARRISON', '2'),
('179', 'DWARF KING CLYDE', '2'),
('186', 'LIGHTNING BOLT', '5'),
('193', 'ALIEN CLYDE', '1'),
('200', 'SHAMAN TOKEN', '1'),
('201', 'WITCH DOCTOR TOKEN', '4'),
('203', 'SPACE WARRIOR TOKEN', '2'),
('205', 'STORYTELLER JIMMY', '3'),
('206', 'LE BARD JIMMY', '1'),
('209', 'ENFORCER JIMMY', '2'),
('512', 'POISONED', '1'),
('1216', 'THE MASTER NINJEW', '4'),
('1218', 'YOUTH PASTOR CRAIG', '2'),
('1269', 'HYPERDRIVE', '5'),
('1272', 'MIND CONTROL', '5'),
('1273', 'PURIFY', '5'),
('1274', 'UNHOLY COMBUSTION', '5'),
('1276', 'ARROWSTORM', '5'),
('1277', 'REGENERATION', '5'),
('1286', 'POWER BIND', '5'),
('1288', 'BARREL DOUGIE', '2'),
('1307', 'ENERGY STAFF', '2'),
('1311', 'POWERFIST DOUGIE', '2'),
('1405', 'RAT TRANSMO 1', '1'),
('1406', 'RAT TRANSMO 2', '1'),
('1407', 'RAT SWARM', '1'),
('1441', 'INDIAN RAVE', '3'),
('1456', 'A COCK', '3'),
('1472', 'COCK MAGIC', '5'),
('1504', 'PROPHET DOUGIE', '2'),
('1506', 'DWARF ENGINEER DOUGIE', '2'),
('1509', 'ALIEN QUEEN RED', '2'),
('1655', 'TRANSMOGRIFY', '5'),
('1656', 'CHICKEN COOP', '3'),
('1657', 'POISON', '5'),
('1661', 'MIMSY', '1'),
('1665', 'TERRANCE MEPHESTO', '2'),
('1666', 'NELLY', '2'),
('1670', 'STARVIN MARVIN', '2'),
('1672', 'MANBEARPIG', '4'),
('1674', 'DOGPOO', '3'),
('1680', 'TERRANCE AND PHILLIP', '1'),
('1682', 'BIG GAY AL', '2'),
('1683', 'OFFICER BARBRADY', '2'),
('1684', 'PIGEON GANG', '1'),
('1686', 'UNDERPANTS GNOMES', '2'),
('1700', 'BANDITA SALLY', '1'),
('1701', 'CALAMITY HEIDI', '1'),
('1804', 'MEDUSA BEBE', '4'),
('1805', 'ROBO BEBE', '1'),
('1806', 'BLOOD ELF BEBE', '1'),
('1808', 'BUCCANEER BEBE', '2'),
('1813', 'VISITORS', '2'),
('1820', 'BEBE SNAKE', '4'),
('1824', 'FOUR-ASSED MONKEY', '2'),
('1869', 'MARCUS', '3'),
('1872', 'MR. HANKEY', '4'),
('1886', 'PC PRINCIPAL', '2'),
('1923', 'CUPID CARTMAN', '2'),
('1947', 'TOWELIE', '3'),
('1949', 'BOUNTY HUNTER KYLE', '3'),
('1972', 'DRAGONSLAYER RED', '4'),
('1973', 'CLASSI', '3'),
('1983', 'IMP TWEEK', '3'),
('2013', 'SWORDSMAN GARRISON', '2'),
('2030', 'PRESIDENT GARRISON', '3'),
('2035', 'MR. SLAVE EXECUTIONER', '3'),
('2042', 'ELVEN KING BRADLEY', '2'),
('2043', 'PRIEST MAXI', '1'),
('2044', 'SWASHBUCKLER RED', '3'),
('2074', 'MR. MACKEY', '1'),
('2080', 'SATAN', '4'),
('2081', 'SANTA CLAUS', '3'),
('2091', 'MOSQUITO', '2'),
('2093', 'MOSQUITO SWARM', '2'),
('2098', 'TUPPERWARE', '1'),
('2101', 'ALIEN DRONE', '3'),
('2102', 'AUTO VACUMM', '3'),
('2114', 'SHARPSHOOTER SHELLY', '3'),
('2117', 'SUPER FART', '5'),
('2130', 'CHOMPER', '2'),
('2132', 'FASTPASS', '3'),
('2136', 'CALL GIRL', '4'),
('2141', 'THE COON', '3'),
('2143', 'HUMAN KITE', '3'),
('2144', 'TOOLSHED', '3'),
('2147', 'MYSTERION', '4'),
('2190', 'LAVA!', '1'),
('2195', 'DOCTOR TIMOTHY', '2'),
('2200', 'CAPTAIN DIABETES', '1'),
('2202', 'PROFESSOR CHAOS', '3'),
('2209', 'BIG MESQUITE MURPH', '3'),
('2210', 'SORCERESS LIANE', '3'),
('2216', 'MINT-BERRY CRUNCH', '4'),
('2217', 'JESUS', '3'),
('2251', 'SIZZLER STUART', '4'),
('2258', 'MAYOR MCDANIELS', '2'),
('2261', 'WONDER TWEEK', '2'),
('2262', 'SUPER CRAIG', '1'),
('2266', 'THUNDERBIRD', '2'),
('2290', 'GENERAL DISARRAY', '2'),
('2295', 'CITY WOK GUY', '3'),
('2308', 'SPACE PILOT BRADLEY', '3'),
('54792', 'Super Kill', '2'));

type


 TCardList = record
    ID        : Dword;
    NAME      : String;
    aType     : integer;
 end;

  { Card info Class }
  TCardInfo = record
    CardID: Tid;
    CardLevel: Tid; // 47
    CardpID: Tid;
    CurrHP: Tid;
    MaxHP  : Tid;
    CustomHP  : Tid;
    FirstHP : Boolean;
    TechTreeBits: TTechTreeBits;
    OwnerPID: Tid;
    CardName: String;
    Dead    : Boolean;
  end;


   TCards = class
  private

  public
    procedure ClearCardInfo();
    procedure AddCardToBattle(CurrCard: TCardInfo);
    procedure LoadCardList();
    function  getCardName(aCardID: Dword): String;
    function  getCardType(aCardID: Tid): Byte;
    function  getCardIdbypID(aCardID: Tid): Tid;
    function  getCardTypeString(aCardID: Tid): String;
    procedure UpdateCardHP(CardpID, CardHP: Tid);
    function  GetCardCurrIndexBypID(CardpID: Tid): integer;
    function  IsMyCard(CardpID: Tid): Boolean;
    procedure RemoveCardFromBattle(aCardpID : Tid);
    function  CardOwnerInf(aCardpID:Tid) : String;
    function  BitEdit(CardStr : String) : String;
    function  LevelEdit(CardStr:String) : String;
    procedure ClearOponentDeckInfo();
    function CardLevelAndBits(CardID: Tid; LVL:Integer; Bits : Integer): String;
    function getOponentNKIndex(CardpID: Tid): Integer;
  protected

 end;

const
  MAX_CARD_ADD = 1000;

  var
  Cards         : TCards;
  CardList      : array[0..CARD_QNT - 1]  of TCardList;
  LastCardDrop  : Tid;

  CardInfo:     array [0 .. MAX_CARD_ADD] of TCardInfo;
  numOfCards: Integer = 0;


  implementation
   uses
    Helper,
    uFunc,
    uBattle,
    uProxy,
    MainUnit;

procedure TCards.ClearCardInfo();
begin
  ZeroMemory(@CardInfo,SizeOf(CardInfo));
  numOfCards := 0;
end;

procedure Tcards.AddCardToBattle(CurrCard: TCardInfo);
var
  LogMode: String;
begin

  CardInfo[numOfCards] := CurrCard;
  Inc(numOfCards);

  if (MyBattleInfo.PID = CurrCard.OwnerPID) then
    LogMode := 'ToClient.MeetCard You Droped card (%s), LVL (%d) with pID (%s)'
  else
    LogMode := 'ToClient.MeetCard Oponent Droped card (%s), LVL (%d) with pID (%s)';

  if Form2.MeetCardLogCheckBox.Checked then
    WriteLog2(Format(LogMode, [CurrCard.CardName,
      InvDword(@CurrCard.CardLevel) + 1,
      Rep00(To_Hex(@CurrCard.CardpID, 4))]));

end;

procedure TCards.UpdateCardHP(CardpID, CardHP: Tid);
var
  I: integer;
  Found: Boolean;
begin
  Found := False;
  if (numOfCards > 0) then
    for I := 0 to (numOfCards - 1) do
      if (CardInfo[I].CardpID = CardpID) then
      begin
        CardInfo[I].CurrHP := InvDword(@CardHP);
        if CardInfo[I].FirstHP then  begin
            CardInfo[I].FirstHP := false;
            CardInfo[I].MaxHP := InvDword(@CardHP);
          end;
        Found := true;
        break;
      end;
  if not Found then
    WriteLog('not FOund pID: ' + To_Hex(@CardpID, 4))

end;

function TCards.GetCardCurrIndexBypID(CardpID: Tid): integer;
var
  I: Integer;
begin
Result := -1;
  if (numOfCards > 0) then
    for I := 0 to (numOfCards - 1) do
      if (CardInfo[I].CardpID = CardpID) then
      begin
        Result := I;
        break;
      end;

end;


function TCards.getOponentNKIndex(CardpID: Tid): integer;
var
  I: Integer;
begin
Result := -1;
  if (numOfCards > 0) then
    for I := 0 to (numOfCards - 1) do
      if (CardInfo[I].OwnerPID = CardpID) then
      begin
        if (CardInfo[I].CardID = $01000000) then
        Result := I;
        break;
      end;

end;



function TCards.IsMyCard(CardpID: Tid): Boolean;
var
  I: Integer;
begin
Result := False;
  if (numOfCards > 0) then
    for I := 0 to (numOfCards - 1) do
      if (CardInfo[I].CardpID = CardpID) then
      begin
        Result := (MyBattleInfo.PID = CardInfo[I].OwnerPID);
        break;
      end;

end;

function TCards.getCardIdbypID(aCardID: Tid): Tid;
var
  I: Integer;
begin
Result := $0;
  if (numOfCards > 0) then
    for I := 0 to (numOfCards - 1) do
      if (CardInfo[I].CardpID = aCardID) then
      begin
        Result := CardInfo[I].CardID;
        break;
      end;

end;


procedure TCards.RemoveCardFromBattle(aCardpID: Tid);
var
  CardIndex: integer;
begin
  CardIndex := GetCardCurrIndexBypID(aCardpID);
  if (CardIndex > -1) then
  begin
    CardInfo[CardIndex].Dead := true;
  end
  else
    WriteLog(Format('RemoveCardFromBattle: Card id (%s) not found',
      [Rep00(To_Hex(@CardInfo[CardIndex].CardpID, 4))]));
end;

procedure TCards.LoadCardList();
var
  I : Integer;
  xCardID : Dword;
begin
  for I := 0 to CARD_QNT - 1 do begin
    xCardID :=  StrToInt(ListofCards[I,0]);
    CardList[I].ID := InvDword(@xCardID);
    CardList[I].NAME := ListofCards[I,1];
    CardList[I].aType := StrToInt(ListofCards[I,2]);
  end;
end;

function TCards.getCardName(aCardID: Tid): String;
var
  I: Integer;
begin
  Result := 'Unknown';
    for I := 0 to (CARD_QNT - 1) do
      if (CardList[I].ID = aCardID) then begin
        Result := CardList[I].NAME;
        Break;
      end;
      if (Result = 'Unknown') and (aCardID <> $00000000) then
      WriteLog('Card ID1 Not Found: ('+To_HEx(@aCardID,4)+')');
end;



function TCards.getCardType(aCardID: Tid): Byte;
var
  I: Integer;
begin
  Result := $00;
    for I := 0 to (CARD_QNT - 1) do
      if (CardList[I].ID = aCardID) then begin
        Result := CardList[I].aType;
        Break;
      end;
end;

function TCards.getCardTypeString(aCardID: Tid): String;
var
I : Integer;
CardCase  : Integer;
begin
    CardCase := -1;
    for I := 0 to (CARD_QNT - 1) do
      if (CardList[I].ID = aCardID) then begin
        CardCase := CardList[I].aType;
        Break;
      end;

  case CardCase of
    0 : Result := 'New Kid';
    1 : Result := 'Commom';
    2 : Result := 'Rare';
    3 : Result := 'Epic';
    4 : Result := 'Legendary';
    5 : Result := 'Spell';
    else
    Result := 'Not Found';
  end;
end;

function TCards.CardOwnerInf(aCardpID:Tid) : String;
var
  CardIndex : integer;
begin

  CardIndex := GetCardCurrIndexBypID(aCardpID);
  if (CardIndex > -1) then begin
    if IsMyCard(aCardpID) then
    Result := Format('Your (%s) id(%s)',
    [CardInfo[CardIndex].CardName,Rep00(To_Hex(@CardInfo[CardIndex].CardpID,4))])
    else
    Result := Format('Oponent (%s) id(%s)',
    [CardInfo[CardIndex].CardName,Rep00(To_Hex(@CardInfo[CardIndex].CardpID,4))])

  end
  else
  if ((aCardpID = $FFFFFFFF) or(aCardpID = $00000000)) then
    Result := 'A SPELL'
  else
    Result := Format('Card not Found id(%s)',
      [Rep00(To_Hex(@CardInfo[CardIndex].CardpID,4))]);
end;

function TCards.LevelEdit(CardStr:String) : String;
var
  IPD : Dword;
  CardID:Tid;
begin
      CardID := StrToInt(CardStr);
      IPD :=  InvDword(@CardID);
      CardID := PID(@IPD)^;
      case Cards.getCardType(CardID) of
      1 : Result := IntToStr(Form2.CommomLevelTrackBar.Position    - 1);
      2 : Result := IntToStr(Form2.RareLevelTrackBar.Position      - 1);
      3 : Result := IntToStr(Form2.EpicLevelTrackBar.Position      - 1);
      4 : Result := IntToStr(Form2.LegendaryLevelTrackBar.Position - 1);
      5 : Result := IntToStr(Form2.SpellLevelTrackBar.Position - 1);
    end;

    if Form2.UpgradeCardsCheckBox.Checked then
    Result := '6';
end;

function TCards.BitEdit(CardStr : String) : String;
var
  IPD     : Dword;
  CardID  :Tid;
begin
      CardID      := StrToInt(CardStr);
      IPD         :=  InvDword(@CardID);
      CardID      := PID(@IPD)^;
      case Cards.getCardType(CardID) of
      1 : Result  := '32767';
      2 : Result  := '32767';
      3 : Result  := '32767';
      4 : Result  := '32767';
      5 : Result  := '0';
    end;
end;

procedure TCards.ClearOponentDeckInfo();
var
  I : Integer;
begin
      for I := 1 to 12 do
  Form2.OponentDeckCard(I,0,'');
end;

function TCards.CardLevelAndBits(CardID: Tid; LVL:Integer; Bits : Integer): String;
var
CurrCount : Integer;
MaxBits : Integer;
begin
  CurrCount := 0;
  MaxBits := 0;
  case LVL of
    0 : CurrCount := 0;
    1 : CurrCount := 5;
    2 : CurrCount := 15;
    3 : CurrCount := 25;
    4 : CurrCount := 40;
    5 : CurrCount := 55;
    6 : CurrCount := 70;
  end;

    case LVL of
    0 : MaxBits := 5;
    1 : MaxBits := 15;
    2 : MaxBits := 25;
    3 : MaxBits := 40;
    4 : MaxBits := 55;
    5 : MaxBits := 70;
    6 : MaxBits := 85;
  end;

  case Bits of
      1:      Inc(CurrCount, 1);
      3:      Inc(CurrCount, 2);
      7:      Inc(CurrCount, 3);
      15:     Inc(CurrCount, 4);
      31:     Inc(CurrCount, 5);
      63:     Inc(CurrCount, 6);
      127:    Inc(CurrCount, 7);
      255:    Inc(CurrCount, 8);
      511:    Inc(CurrCount, 9);
      1023:   Inc(CurrCount, 10);
      2047:   Inc(CurrCount, 11);
      4095:   Inc(CurrCount, 12);
      8191:   Inc(CurrCount, 13);
      16383:  Inc(CurrCount, 14);
      32767:  Inc(CurrCount, 15);
  end;

  if (getCardType(InvDword(@CardID)) = 5) then
  Result := Format('Level (%d)',[LVL + 1])
  else
  Result := Format('Level (%d) Bits (%d/%d)',[LVL + 1,CurrCount,MaxBits]);

end;


end.
