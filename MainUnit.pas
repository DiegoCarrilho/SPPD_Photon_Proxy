unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  System.Win.ScktComp, Vcl.ExtCtrls, Helper, Vcl.Menus, PopUp,
  uCards, uFunc, UBattle, NewProxy, uProxy, uClasses, Jpeg, uProxy2,ClipBrd;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    ProxyButton: TButton;
    PageControl1: TPageControl;
    PacketsTabSheet: TTabSheet;
    LogsTabSheet: TTabSheet;
    LogMemo: TMemo;
    PacketListView: TListView;
    TabSheet2: TTabSheet;
    PopupMenu1: TPopupMenu;
    ExporttoClipBoard1: TMenuItem;
    ClearButton: TButton;
    PacketLogGroupBox: TGroupBox;
    LogF0Checkbox: TCheckBox;
    LogSelecttab: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    MeetCardLogPacketCheckBox: TCheckBox;
    MeetCardLogCheckBox: TCheckBox;
    MeetOponentpIDPacketCheckBox: TCheckBox;
    MeetOponentpIDCheckBox: TCheckBox;
    Packets2: TTabSheet;
    ListView1: TListView;
    RecvDmgPacketLogCheckBox: TCheckBox;
    RecvDmgLogCheckBox: TCheckBox;
    MyDmgPacketLogCheckBox: TCheckBox;
    MyDmgLogCheckBox: TCheckBox;
    Log2: TTabSheet;
    LogMemo2: TMemo;
    KillEventPacketLogCheckBox: TCheckBox;
    KillEventLogCheckBox: TCheckBox;
    DeathEventPacketLogCheckBox: TCheckBox;
    DeathEventLogCheckBox: TCheckBox;
    MeetMypIDPacketCheckBox: TCheckBox;
    MeetMypIDCheckBox: TCheckBox;
    CardDropPacketCheckBox: TCheckBox;
    CardDropCheckBox: TCheckBox;
    RecvDmgNKPacketLogCheckBox: TCheckBox;
    RecvDmgNKLogCheckBox: TCheckBox;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    FullLogCheckBox: TCheckBox;
    Panel2: TPanel;
    PlayerList: TListView;
    Panel3: TPanel;
    OponentList: TListView;
    Panel4: TPanel;
    Panel5: TPanel;
    ShowMyDeadCardsCheckBox: TCheckBox;
    ShowOponentDeadCardsCheckBox: TCheckBox;
    UpdateCardsCheckBox: TCheckBox;
    OponentCardDiedPacketLogCheckBox: TCheckBox;
    OponentCardDiedLogCheckBox: TCheckBox;
    MyDmgConfirmPacketLogCheckBox: TCheckBox;
    MyDmgConfirmLogCheckBox: TCheckBox;
    CurrTimeStampStaticText: TStaticText;
    CurrTimeStampLabel: TLabel;
    FullLogLobbyCheckBox: TCheckBox;
    FullLogLobbyF0CheckBox: TCheckBox;
    TabSheet4: TTabSheet;
    OponentCardsAPanel: TPanel;
    OponentCardsbPanel: TPanel;
    OponentCardsA1Panel: TPanel;
    OponentCardsA2Panel: TPanel;
    OponentCardsA3Panel: TPanel;
    OponentCardsA4Panel: TPanel;
    OponentCardsA5Panel: TPanel;
    OponentCardsA6Panel: TPanel;
    OponentCardsA1Image: TImage;
    OponentCardsA2IMage: TImage;
    OponentCardsA3IMage: TImage;
    OponentCardsA4IMage: TImage;
    OponentCardsA5IMage: TImage;
    OponentCardsA6IMage: TImage;
    OponentCardsA1Statictext: TStaticText;
    OponentCardsA2Statictext: TStaticText;
    OponentCardsA3Statictext: TStaticText;
    OponentCardsA4Statictext: TStaticText;
    OponentCardsA5Statictext: TStaticText;
    OponentCardsA6Statictext: TStaticText;
    OponentCardsA7Panel: TPanel;
    OponentCardsA7Image: TImage;
    OponentCardsA7Statictext: TStaticText;
    OponentCardsA8Panel: TPanel;
    OponentCardsA8Image: TImage;
    OponentCardsA8Statictext: TStaticText;
    OponentCardsA9Panel: TPanel;
    OponentCardsA9Image: TImage;
    OponentCardsA9Statictext: TStaticText;
    OponentCardsA10Panel: TPanel;
    OponentCardsA10Image: TImage;
    OponentCardsA10Statictext: TStaticText;
    OponentCardsA11Panel: TPanel;
    OponentCardsA11Image: TImage;
    OponentCardsA11Statictext: TStaticText;
    OponentCardsA12Panel: TPanel;
    OponentCardsA12Image: TImage;
    OponentCardsA12Statictext: TStaticText;
    GroupBox2: TGroupBox;
    CommomLevelValueLabel: TLabel;
    RareLevelValueLabel: TLabel;
    EpicLevelValueLabel: TLabel;
    LegendaryLevelValueLabel: TLabel;
    Label1: TLabel;
    SpellLevelValueLabel: TLabel;
    CommomLevelTrackBar: TTrackBar;
    RareLevelTrackBar: TTrackBar;
    EpicLevelTrackBar: TTrackBar;
    LegendaryLevelTrackBar: TTrackBar;
    TrackBar1: TTrackBar;
    SpellLevelTrackBar: TTrackBar;
    UpgradeCardsCheckBox: TCheckBox;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    GoldenNameCheckBox: TCheckBox;
    OnehitKillCheckBox: TCheckBox;
    ChangeNameEdit: TEdit;
    ChangeNameCheckBox: TCheckBox;
    ChangeRankTrackbar: TTrackBar;
    ChangeRankCheckBox: TCheckBox;
    ForceOponentCancelCheckBox: TCheckBox;
    ChangePlayerExpCheckBox: TCheckBox;
    ChangePlayerExpTrackbar: TTrackBar;
    LobbyGroupBox: TGroupBox;
    LobbyLocalPortLabel: TLabel;
    LobbyProxyPortLabel: TLabel;
    LobbyProxyIpLabel: TLabel;
    LobbyLocalPortEdit: TEdit;
    LobbyProxyPortEdit: TEdit;
    LobbyProxyIpEdit: TEdit;
    GroupBox6: TGroupBox;
    BattleLocalPortLabel: TLabel;
    BattleLocalIPLabel: TLabel;
    BattleLocalPortEdit: TEdit;
    BattleLocalIPEdit: TEdit;
    OponentCardsA1StatsStatictext: TStaticText;
    OponentCardsA2StatsStatictext: TStaticText;
    OponentCardsA3StatsStatictext: TStaticText;
    OponentCardsA4StatsStatictext: TStaticText;
    OponentCardsA5StatsStatictext: TStaticText;
    OponentCardsA6StatsStatictext: TStaticText;
    OponentCardsA7StatsStatictext: TStaticText;
    OponentCardsA8StatsStatictext: TStaticText;
    OponentCardsA9StatsStatictext: TStaticText;
    OponentCardsA10StatsStatictext: TStaticText;
    OponentCardsA11StatsStatictext: TStaticText;
    OponentCardsA12StatsStatictext: TStaticText;
    OponentNameStaticText: TStaticText;
    OponentLabel: TLabel;
    CopyLine1: TMenuItem;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    UnCheckComomLogCheckBox: TCheckBox;
    BlockSpellsCheckBox: TCheckBox;
    InvincibleCheckBox: TCheckBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DowngradeOponentCardLVLCheckBox: TCheckBox;
    DownGradeOpoenentCardLVLTrackBar: TTrackBar;
    CheckBox3: TCheckBox;
    ConvertToText1: TMenuItem;
    Button1: TButton;
    ComboBox1: TComboBox;
    ChangeCardTypeCheckBox: TCheckBox;

    procedure ProxyButtonClick(Sender: TObject);
    procedure ExporttoClipBoard1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CommomLevelTrackBarChange(Sender: TObject);
    procedure RareLevelTrackBarChange(Sender: TObject);
    procedure EpicLevelTrackBarChange(Sender: TObject);
    procedure LegendaryLevelTrackBarChange(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TabSheet2Resize(Sender: TObject);
    procedure ChangeRankTrackbarChange(Sender: TObject);
    procedure SpellLevelTrackBarChange(Sender: TObject);
    procedure ChangePlayerExpTrackbarChange(Sender: TObject);
    procedure TabSheet4Resize(Sender: TObject);
    procedure OponentCardsAPanelResize(Sender: TObject);
    procedure OponentCardsPanelResize(Sender: TObject);
    procedure OponentDeckCard(Pos:integer; CardID:TID; CardInfo:String);
    procedure OponentCardsbPanelResize(Sender: TObject);
    procedure CopyLine1Click(Sender: TObject);
    procedure UnCheckComomLogCheckBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BlockSpellsCheckBoxClick(Sender: TObject);
    procedure InvincibleCheckBoxClick(Sender: TObject);
    procedure OnehitKillCheckBoxClick(Sender: TObject);
    procedure DownGradeOpoenentCardLVLTrackBarChange(Sender: TObject);
    procedure ConvertToText1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    procedure WMHotkey( Var msg: TWMHotkey );message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  Proxy : Tproxy;
  Proxy2 : Tproxy2;

implementation

{$R *.dfm}

procedure TForm2.WMHotkey(var Msg: TWMHotkey);
begin
inherited;
  case msg.HotKey of
    1: Form2.OnehitKillCheckBox.Checked := not Form2.OnehitKillCheckBox.Checked;
    2: Form2.BlockSpellsCheckBox.Checked := not Form2.BlockSpellsCheckBox.Checked;
    3: Form2.InvincibleCheckBox.Checked := not Form2.InvincibleCheckBox.Checked;

  end;
end;

procedure TForm2.ExporttoClipBoard1Click(Sender: TObject);
begin
  ListViewToClipboard(PacketListView);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
      if Proxy = nil then
  exit;

      if Proxy2 = nil then
 exit;

   Proxy.StopProxy;
    StopProxy;
    Proxy2.StopProxy;


end;

procedure TForm2.FormCreate(Sender: TObject);
var
I:integer;
begin
  Cards.LoadCardList();
  Cards.ClearOponentDeckInfo();
  CommomLevelTrackBar.Position      :=  7;
  RareLevelTrackBar.Position        :=  6;
  EpicLevelTrackBar.Position        :=  5;
  LegendaryLevelTrackBar.Position   :=  5;
  SpellLevelTrackBar.Position       :=  7;
  Trackbar1.Position                :=  7;
  DownGradeOpoenentCardLVLTrackBar.Position := 1;
  ChangePlayerExpTrackbar.Position  :=  100;
  ChangeRankTrackBar.Position       :=  5000;
  RegisterHotKey(Form2.Handle, 1, 0, VK_F6);
    RegisterHotKey(Form2.Handle, 2, 0, VK_F7);
      RegisterHotKey(Form2.Handle, 3, 0, VK_F8);
      Form2.StatusBar1.Panels[0].Text := 'Loaded';
for I := 0 to CARD_QNT - 1 do begin
  ComboBox1.Items.add(ListofCards[I,1]);

end;


end;



procedure TForm2.InvincibleCheckBoxClick(Sender: TObject);
begin
if InvincibleCheckBox.Checked then
Label4.Caption := 'Invincible'
else
Label4.Caption := '';
end;

procedure TForm2.ProxyButtonClick(Sender: TObject);
begin

      if Proxy = nil then
  Proxy := Tproxy.Create;

      if Proxy2 = nil then
  Proxy2 := Tproxy2.Create;

  if proxy.State then begin
    Proxy.StopProxy;
    StopProxy;
    Proxy2.StopProxy;
  end
    else begin
      proxy.SetLobbyLocalPort(LobbyLocalPortEdit.Text);
      proxy.SetLobbyProxyIp(LobbyProxyIpEdit.text);
      proxy.SetLobbyProxyPort(LobbyProxyPortEdit.text);
      Proxy.SetBattleLocalIP(BattleLocalIPEdit.Text);
      Proxy.SetBattleLocalPort(BattleLocalPortEdit.Text);
      Proxy.StartProxy;
      StartProxy;
      Proxy2.SetPort(4533);
      Proxy2.ServerIP := LobbyProxyIpEdit.Text;
      Proxy2.ServerPort := 4533;
      Proxy2.StartProxy;
    end;
end;

procedure TForm2.OponentDeckCard(Pos:integer; CardID:TID; CardInfo:String);
var
jpg : TJpegImage;
bmp : TBitmap;
CurrIMg : TImage;
CurrPanel : TPanel;
CurrStaticText : TStaticText;
InfoStaticText : TStaticText;
Cardname : String;
begin
  Cardname :=  Cards.getCardName(InvDword(@CardID));
  jpg := TJpegImage.Create;
  jpg.Loadfromfile('Cards/'+Cardname+'.jpg');

  bmp := TBitmap.Create;
  bmp.Width := Round(425 / 5);
  bmp.Height:= Round(600/ 5);
  bmp.Canvas.StretchDraw(bmp.Canvas.Cliprect, jpg);
  CurrStaticText := FindComponent('OponentCardsA'+IntToStr(Pos)+'Statictext') as TStatictext;
  InfoStaticText := FindComponent('OponentCardsA'+IntToStr(Pos)+'StatsStatictext') as TStatictext;
  CurrIMg   := FindComponent('OponentCardsA'+IntToStr(Pos)+'Image') as Timage;
  CurrPanel := FindComponent('OponentCardsA'+IntToStr(Pos)+'Panel') as TPanel;
  CurrIMg.Height := bmp.Height;
  CurrIMg.Width   := bmp.Width;
  CurrIMg.Left :=  Round(CurrPanel.Width / 2) - Round(CurrIMg.Width / 2);

  CurrIMg.Picture.Assign(bmp);
  CurrStaticText.Caption := CardName;
  InfoStaticText.Caption := CardInfo;
end;

procedure TForm2.BlockSpellsCheckBoxClick(Sender: TObject);
begin

if BlockSpellsCheckBox.Checked then
Label2.Caption := 'Block Spell'
else
Label2.Caption := '';
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
      PID(@Packettest[29])^ := SyncToClient;
      PID(@Packettest[22])^ := OponentInfo.NKpID;
      PlayClient.Socket.SendBuf(Packettest, 37);

      PID(@Packettest2[23])^ := SyncToClient;
      PID(@Packettest2[30])^ := OponentInfo.NKpID;
      PlayServer.Socket.Connections[0].SendBuf(Packettest2, 40);
end;

procedure TForm2.ChangePlayerExpTrackbarChange(Sender: TObject);
begin
  ChangePlayerExpCheckBox.Caption :=
  'Player Exp ('+IntToStr(ChangePlayerExpTrackbar.Position)+')';
end;

procedure TForm2.ChangeRankTrackbarChange(Sender: TObject);
begin
  ChangeRankCheckBox.Caption :=
  'Rank Level ('+IntToStr(ChangeRankTrackBar.Position)+')';
end;

procedure TForm2.ClearButtonClick(Sender: TObject);
begin
 LogMemo.Clear;
 LogMemo2.Clear;
 PacketListView.Clear;
 Cards.ClearCardInfo();
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
WriteLog(ListofCards[ComboBox1.ItemIndex,1]);
end;

procedure TForm2.CommomLevelTrackBarChange(Sender: TObject);
begin
  CommomLevelValueLabel.Caption :=
    Format('Commom LVL (%d)',[CommomLevelTrackBar.Position]);
end;

procedure TForm2.ConvertToText1Click(Sender: TObject);
begin
   if (PacketListView.Selected <> nil) then begin
   Form4.Show;
   Form4.Memo1.Text := HexToAsc(PacketListView.Selected.SubItems[4]);
   end;
end;

procedure TForm2.CopyLine1Click(Sender: TObject);
begin
   if (PacketListView.Selected <> nil) then
   Clipboard.AsText := PacketListView.Selected.SubItems[4];
end;

procedure TForm2.DownGradeOpoenentCardLVLTrackBarChange(Sender: TObject);
begin
DowngradeOponentCardLVLCheckBox.Caption := 'Down LVL ('+IntToStr(DownGradeOpoenentCardLVLTrackBar.Position)+')';
end;

procedure TForm2.LegendaryLevelTrackBarChange(Sender: TObject);
begin
  LegendaryLevelValueLabel.Caption :=
    Format('Legendary LVL (%d)',[LegendaryLevelTrackBar.Position]);
end;

procedure TForm2.OponentCardsPanelResize(Sender: TObject);
var
  ObjectID : String;
  Image : TImage;
  StaticText : TStaticText;
  StaticText2 : TStaticText;

begin
  ObjectID    :=  Get_Data('','Panel',TPanel(Sender).Name);
  Image       :=  FindComponent(ObjectID+'Image') as TImage;
  StaticText  :=  FindComponent(ObjectID+'StaticText') as TStaticText;
  StaticText2 :=  FindComponent(ObjectID+'StatsStaticText') as TStaticText;

  Image.Left  :=  Round(TPanel(Sender).Width / 2) - Round(Image.Width / 2);
  StaticText.Left := 2;
  StaticText.Width := TPanel(Sender).Width - 10;

  StaticText2.Left := 2;
  StaticText2.Width := TPanel(Sender).Width - 10
end;

procedure TForm2.OnehitKillCheckBoxClick(Sender: TObject);
begin
if OnehitKillCheckBox.Checked then
Label5.Caption := 'One hit'
else
Label5.Caption := '';
end;

procedure TForm2.OponentCardsAPanelResize(Sender: TObject);
var
I : integer;
CurrPanel : Tpanel;
CurrWidth : integer;
begin
  CurrWidth := 0;
  for I := 1 to 6 do begin
    CurrPanel   := FindCOmponent('OponentCardsA'+IntToStr(I)+'Panel') as TPanel;
    CurrPanel.Width := Round(TPanel(Sender).Width / 6) - 1;
    CurrPanel.Left  := CurrWidth;
    CurrPanel.Height  := TPanel(Sender).Height;
    CurrWidth := Round(TPanel(Sender).Width / 6) * I
  end;
end;

procedure TForm2.OponentCardsbPanelResize(Sender: TObject);
var
I : integer;
CurrPanel : Tpanel;
CurrWidth : integer;
begin
  CurrWidth := 0;
  for I := 1 to 6 do begin
    CurrPanel   := FindCOmponent('OponentCardsA'+IntToStr(I + 6)+'Panel') as TPanel;
    CurrPanel.Width := Round(TPanel(Sender).Width / 6) - 1;
    CurrPanel.Left  := CurrWidth;
    CurrPanel.Height  := TPanel(Sender).Height;
    CurrWidth := Round(TPanel(Sender).Width / 6) * I
  end;

end;

procedure TForm2.RareLevelTrackBarChange(Sender: TObject);
begin
  RareLevelValueLabel.Caption :=
    Format('Rare LVL (%d)',[RareLevelTrackBar.Position]);
end;

procedure TForm2.SpellLevelTrackBarChange(Sender: TObject);
begin
  SpellLevelValueLabel.Caption :=
    Format('Spell LVL (%d)',[SpellLevelTrackBar.Position]);
end;

procedure TForm2.TabSheet2Resize(Sender: TObject);
begin
  Panel2.Width := Round(TabSheet2.Width / 2) - 1;
  Panel2.Height :=  TabSheet2.Height;
  Panel3.Width := Round(TabSheet2.Width / 2);
  Panel3.Height :=  TabSheet2.Height;
  Panel3.Left := Round(TabSheet2.Width / 2) + 1;
end;

procedure TForm2.TabSheet4Resize(Sender: TObject);
begin
  OponentCardsAPanel.Height :=  Round(TabSheet4.Height / 2) - 1;
  OponentCardsBPanel.Height :=  Round(TabSheet4.Height / 2) - 1;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var
I: integer;

begin

  CurrTimeStampStaticText.Caption := To_Hex(@SyncToClient,4);
  if not UpdateCardsCheckBox.Checked then
     exit;

  PlayerList.Clear;
  OponentList.Clear;
  for I := 0  to numOfCards -1 do begin
    if Cards.IsMyCard(CardInfo[I].CardpID) then begin
        if CardInfo[I].Dead and not ShowMyDeadCardsCheckBox.Checked then
       continue;
    with PlayerList.Items.Add do begin
      Caption := IntToStr(Form2.PlayerList.Items.Count);
      SubItems.Add(Rep00(To_Hex(@CardInfo[I].CardpID,4)));
      SubItems.Add(CardInfo[I].CardName);
      SubItems.Add(Format('%d/%d',[CardInfo[I].CurrHP,CardInfo[I].MaxHP]));
    end;
    end
    else begin
      if CardInfo[I].Dead and not ShowOponentDeadCardsCheckBox.Checked then
       continue;
      with OponentList.Items.Add do begin
        Caption := IntToStr(Form2.OponentList.Items.Count);
        SubItems.Add(Rep00(To_Hex(@CardInfo[I].CardpID,4)));
        SubItems.Add(CardInfo[I].CardName);
      SubItems.Add(Format('%d/%d',[CardInfo[I].CurrHP,CardInfo[I].MaxHP]));
      end;
    end;
  end;

end;

procedure TForm2.UnCheckComomLogCheckBoxClick(Sender: TObject);
begin
  MeetMypIDCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  MyDmgConfirmLogCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  OponentCardDiedLogCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  RecvDmgNKLogCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  CardDropCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  DeathEventLogCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  KillEventLogCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  MeetOponentpIDCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  MyDmgLogCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  MeetCardLogCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
  RecvDmgLogCheckBox.Checked := UnCheckComomLogCheckBox.Checked;
end;

procedure TForm2.EpicLevelTrackBarChange(Sender: TObject);
begin
  EpicLevelValueLabel.Caption :=
    Format('Epic LVL (%d)',[EpicLevelTrackBar.Position]);
end;
end.
