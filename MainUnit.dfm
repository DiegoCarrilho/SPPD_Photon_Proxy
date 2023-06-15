object Form2: TForm2
  Left = 110
  Top = 0
  Caption = 'SPPD Tools'
  ClientHeight = 459
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 779
    Height = 89
    Align = alTop
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object CurrTimeStampLabel: TLabel
      Left = 357
      Top = 12
      Width = 56
      Height = 13
      Caption = 'TimeStamp:'
    end
    object OponentLabel: TLabel
      Left = 355
      Top = 44
      Width = 46
      Height = 13
      Caption = 'Oponent:'
    end
    object Label2: TLabel
      Left = 200
      Top = 16
      Width = 24
      Height = 13
      Caption = '------'
    end
    object Label4: TLabel
      Left = 200
      Top = 38
      Width = 24
      Height = 13
      Caption = '------'
    end
    object Label5: TLabel
      Left = 200
      Top = 57
      Width = 24
      Height = 13
      Caption = '------'
    end
    object ProxyButton: TButton
      Left = 12
      Top = 11
      Width = 73
      Height = 19
      Caption = 'Start'
      TabOrder = 0
      OnClick = ProxyButtonClick
    end
    object ClearButton: TButton
      Left = 91
      Top = 11
      Width = 73
      Height = 19
      Caption = 'Clear'
      TabOrder = 1
      OnClick = ClearButtonClick
    end
    object PacketLogGroupBox: TGroupBox
      Left = 544
      Top = 8
      Width = 201
      Height = 75
      Caption = 'Commom Logger'
      TabOrder = 2
      object LogF0Checkbox: TCheckBox
        Left = 110
        Top = 12
        Width = 57
        Height = 17
        Caption = 'Log $F0'
        TabOrder = 0
      end
      object FullLogCheckBox: TCheckBox
        Left = 15
        Top = 12
        Width = 89
        Height = 17
        Caption = 'Full Log'
        TabOrder = 1
      end
      object FullLogLobbyCheckBox: TCheckBox
        Left = 15
        Top = 35
        Width = 89
        Height = 17
        Caption = 'Full Log Looby'
        TabOrder = 2
      end
      object FullLogLobbyF0CheckBox: TCheckBox
        Left = 110
        Top = 35
        Width = 88
        Height = 17
        Caption = 'Log $F0 Lobby'
        TabOrder = 3
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 56
        Width = 81
        Height = 17
        Caption = 'Log 4533'
        TabOrder = 4
      end
      object CheckBox2: TCheckBox
        Left = 104
        Top = 56
        Width = 89
        Height = 17
        Caption = 'Log Char Stat'
        TabOrder = 5
      end
    end
    object CurrTimeStampStaticText: TStaticText
      Left = 417
      Top = 11
      Width = 121
      Height = 17
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSunken
      TabOrder = 3
    end
    object OponentNameStaticText: TStaticText
      Left = 417
      Top = 43
      Width = 121
      Height = 17
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSunken
      TabOrder = 4
    end
    object CheckBox3: TCheckBox
      Left = 272
      Top = 32
      Width = 65
      Height = 17
      Caption = 'CheckBox3'
      TabOrder = 5
    end
    object Button1: TButton
      Left = 276
      Top = 55
      Width = 73
      Height = 25
      Caption = 'Button1'
      TabOrder = 6
      OnClick = Button1Click
    end
    object ComboBox1: TComboBox
      Left = 12
      Top = 36
      Width = 173
      Height = 21
      TabOrder = 7
      Text = 'ComboBox1'
      OnChange = ComboBox1Change
    end
    object ChangeCardTypeCheckBox: TCheckBox
      Left = 16
      Top = 64
      Width = 129
      Height = 17
      Caption = 'Change Card Type'
      TabOrder = 8
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 440
    Width = 779
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 89
    Width = 779
    Height = 351
    ActivePage = PacketsTabSheet
    Align = alClient
    TabOrder = 1
    object PacketsTabSheet: TTabSheet
      Caption = 'Packets'
      object PacketListView: TListView
        Left = 0
        Top = 0
        Width = 771
        Height = 323
        Align = alClient
        Columns = <
          item
            Caption = 'Number'
            Width = 52
          end
          item
            Caption = 'Size'
          end
          item
          end
          item
            Caption = 'State'
            Width = 130
          end
          item
            Caption = 'Type'
            Width = 40
          end
          item
            Caption = 'Packet'
            Width = 450
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenu1
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object LogsTabSheet: TTabSheet
      Caption = 'Commom Logs'
      ImageIndex = 1
      object LogMemo: TMemo
        Left = 0
        Top = 0
        Width = 771
        Height = 323
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Battle Cards'
      ImageIndex = 4
      OnResize = TabSheet2Resize
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 369
        Height = 309
        Caption = 'Panel2'
        TabOrder = 0
        object PlayerList: TListView
          Left = 1
          Top = 26
          Width = 367
          Height = 282
          Align = alClient
          Columns = <
            item
              Caption = 'Number'
              Width = 52
            end
            item
              Caption = 'Card ID'
              Width = 60
            end
            item
              Caption = 'Name'
              Width = 150
            end
            item
              Caption = 'HP'
              Width = 100
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          PopupMenu = PopupMenu1
          TabOrder = 0
          ViewStyle = vsReport
        end
        object Panel4: TPanel
          Left = 1
          Top = 1
          Width = 367
          Height = 25
          Align = alTop
          TabOrder = 1
          object ShowMyDeadCardsCheckBox: TCheckBox
            Left = 10
            Top = 2
            Width = 121
            Height = 17
            Caption = 'Show My Dead Cards'
            TabOrder = 0
          end
          object UpdateCardsCheckBox: TCheckBox
            Left = 184
            Top = 0
            Width = 113
            Height = 17
            Caption = 'Update Timer'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
        end
      end
      object Panel3: TPanel
        Left = 360
        Top = 0
        Width = 393
        Height = 309
        Caption = 'Panel3'
        TabOrder = 1
        object OponentList: TListView
          Left = 1
          Top = 26
          Width = 391
          Height = 282
          Align = alClient
          Columns = <
            item
              Caption = 'Number'
              Width = 52
            end
            item
              Caption = 'Card ID'
              Width = 60
            end
            item
              Caption = 'Name'
              Width = 150
            end
            item
              Caption = 'HP'
              Width = 100
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          PopupMenu = PopupMenu1
          TabOrder = 0
          ViewStyle = vsReport
        end
        object Panel5: TPanel
          Left = 1
          Top = 1
          Width = 391
          Height = 25
          Align = alTop
          TabOrder = 1
          object ShowOponentDeadCardsCheckBox: TCheckBox
            Left = 10
            Top = 2
            Width = 145
            Height = 17
            Caption = 'Show Oponent Dead Cards'
            TabOrder = 0
          end
        end
      end
    end
    object LogSelecttab: TTabSheet
      Caption = 'Hacks'
      ImageIndex = 3
      object GroupBox1: TGroupBox
        Left = 508
        Top = 3
        Width = 139
        Height = 317
        Caption = 'Packet Log'
        TabOrder = 0
        object MeetCardLogPacketCheckBox: TCheckBox
          Left = 16
          Top = 15
          Width = 97
          Height = 17
          Caption = 'Meet Card'
          TabOrder = 0
        end
        object MeetOponentpIDPacketCheckBox: TCheckBox
          Left = 16
          Top = 75
          Width = 129
          Height = 17
          Caption = 'Oponent Battle pID'
          TabOrder = 1
        end
        object RecvDmgPacketLogCheckBox: TCheckBox
          Left = 16
          Top = 35
          Width = 73
          Height = 17
          Caption = 'Recv Dmg'
          TabOrder = 2
        end
        object MyDmgPacketLogCheckBox: TCheckBox
          Left = 16
          Top = 55
          Width = 81
          Height = 17
          Caption = 'My Dmg'
          TabOrder = 3
        end
        object KillEventPacketLogCheckBox: TCheckBox
          Left = 16
          Top = 95
          Width = 105
          Height = 17
          Caption = 'Kill Event'
          TabOrder = 4
        end
        object DeathEventPacketLogCheckBox: TCheckBox
          Left = 16
          Top = 115
          Width = 81
          Height = 17
          Caption = 'Death Event'
          TabOrder = 5
        end
        object MeetMypIDPacketCheckBox: TCheckBox
          Left = 16
          Top = 135
          Width = 97
          Height = 17
          Caption = 'My Battle pID'
          TabOrder = 6
        end
        object CardDropPacketCheckBox: TCheckBox
          Left = 16
          Top = 155
          Width = 89
          Height = 17
          Caption = 'Card Drop'
          TabOrder = 7
        end
        object RecvDmgNKPacketLogCheckBox: TCheckBox
          Left = 16
          Top = 175
          Width = 121
          Height = 17
          Caption = 'NK Dmg Received'
          TabOrder = 8
        end
        object OponentCardDiedPacketLogCheckBox: TCheckBox
          Left = 16
          Top = 195
          Width = 113
          Height = 17
          Caption = 'Oponent Card Died'
          TabOrder = 9
        end
        object MyDmgConfirmPacketLogCheckBox: TCheckBox
          Left = 16
          Top = 216
          Width = 113
          Height = 17
          Caption = 'My Dmg Confirm'
          TabOrder = 10
        end
      end
      object GroupBox3: TGroupBox
        Left = 637
        Top = 3
        Width = 131
        Height = 317
        Caption = 'Commom Log'
        TabOrder = 1
        object MeetCardLogCheckBox: TCheckBox
          Left = 16
          Top = 15
          Width = 97
          Height = 17
          Caption = 'Meet Card'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object MeetOponentpIDCheckBox: TCheckBox
          Left = 16
          Top = 75
          Width = 113
          Height = 17
          Caption = 'Oponent Battle pID'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object RecvDmgLogCheckBox: TCheckBox
          Left = 16
          Top = 35
          Width = 113
          Height = 17
          Caption = 'Recv Dmg'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object MyDmgLogCheckBox: TCheckBox
          Left = 16
          Top = 55
          Width = 81
          Height = 17
          Caption = 'My Dmg'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object KillEventLogCheckBox: TCheckBox
          Left = 16
          Top = 95
          Width = 94
          Height = 17
          Caption = 'Kill event'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object DeathEventLogCheckBox: TCheckBox
          Left = 16
          Top = 115
          Width = 81
          Height = 17
          Caption = 'Death event'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object MeetMypIDCheckBox: TCheckBox
          Left = 16
          Top = 135
          Width = 97
          Height = 17
          Caption = 'My Battle pID'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object CardDropCheckBox: TCheckBox
          Left = 16
          Top = 155
          Width = 89
          Height = 17
          Caption = 'Card Drop'
          Checked = True
          State = cbChecked
          TabOrder = 7
        end
        object RecvDmgNKLogCheckBox: TCheckBox
          Left = 16
          Top = 175
          Width = 129
          Height = 17
          Caption = 'NK Dmg Received'
          Checked = True
          State = cbChecked
          TabOrder = 8
        end
        object OponentCardDiedLogCheckBox: TCheckBox
          Left = 16
          Top = 195
          Width = 113
          Height = 17
          Caption = 'Oponent Card Died'
          Checked = True
          State = cbChecked
          TabOrder = 9
        end
        object MyDmgConfirmLogCheckBox: TCheckBox
          Left = 16
          Top = 216
          Width = 113
          Height = 17
          Caption = 'My Dmg Confirm'
          Checked = True
          State = cbChecked
          TabOrder = 10
        end
        object UnCheckComomLogCheckBox: TCheckBox
          Left = 16
          Top = 240
          Width = 97
          Height = 17
          Caption = 'UnCheck All'
          TabOrder = 11
          OnClick = UnCheckComomLogCheckBoxClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 234
        Height = 197
        Caption = 'Card Level'
        TabOrder = 2
        object CommomLevelValueLabel: TLabel
          Left = 140
          Top = 20
          Width = 73
          Height = 13
          Caption = 'Commom LVL ()'
        end
        object RareLevelValueLabel: TLabel
          Left = 140
          Top = 40
          Width = 53
          Height = 13
          Caption = 'Rare LVL ()'
        end
        object EpicLevelValueLabel: TLabel
          Left = 140
          Top = 60
          Width = 49
          Height = 13
          Caption = 'Epic LVL ()'
        end
        object LegendaryLevelValueLabel: TLabel
          Left = 140
          Top = 80
          Width = 81
          Height = 13
          Caption = 'Legendary LVL ()'
        end
        object Label1: TLabel
          Left = 140
          Top = 120
          Width = 77
          Height = 13
          Caption = 'Upgrades (Max)'
        end
        object SpellLevelValueLabel: TLabel
          Left = 140
          Top = 100
          Width = 52
          Height = 13
          Caption = 'Spell LVL ()'
        end
        object CommomLevelTrackBar: TTrackBar
          Left = 3
          Top = 18
          Width = 130
          Height = 17
          Max = 7
          Min = 1
          Position = 1
          TabOrder = 0
          OnChange = CommomLevelTrackBarChange
        end
        object RareLevelTrackBar: TTrackBar
          Left = 3
          Top = 38
          Width = 130
          Height = 17
          Max = 7
          Min = 1
          Position = 1
          TabOrder = 1
          OnChange = RareLevelTrackBarChange
        end
        object EpicLevelTrackBar: TTrackBar
          Left = 3
          Top = 58
          Width = 130
          Height = 17
          Max = 7
          Min = 1
          Position = 1
          TabOrder = 2
          OnChange = EpicLevelTrackBarChange
        end
        object LegendaryLevelTrackBar: TTrackBar
          Left = 3
          Top = 78
          Width = 130
          Height = 17
          Max = 7
          Min = 1
          Position = 1
          TabOrder = 3
          OnChange = LegendaryLevelTrackBarChange
        end
        object TrackBar1: TTrackBar
          Left = 3
          Top = 118
          Width = 130
          Height = 17
          Max = 7
          Min = 1
          Position = 1
          TabOrder = 4
        end
        object SpellLevelTrackBar: TTrackBar
          Left = 3
          Top = 98
          Width = 130
          Height = 17
          Max = 7
          Min = 1
          Position = 1
          TabOrder = 5
          OnChange = SpellLevelTrackBarChange
        end
        object UpgradeCardsCheckBox: TCheckBox
          Left = 14
          Top = 141
          Width = 137
          Height = 17
          Caption = 'Upgrade Cards'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
      end
      object GroupBox4: TGroupBox
        Left = 243
        Top = 3
        Width = 257
        Height = 197
        Caption = 'Others'
        TabOrder = 3
        object Label3: TLabel
          Left = 132
          Top = 22
          Width = 31
          Height = 13
          Caption = 'Name:'
        end
        object GoldenNameCheckBox: TCheckBox
          Left = 10
          Top = 118
          Width = 81
          Height = 17
          Caption = 'Golden Name'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object OnehitKillCheckBox: TCheckBox
          Left = 10
          Top = 45
          Width = 110
          Height = 17
          Caption = 'One hit Kill'
          TabOrder = 1
          OnClick = OnehitKillCheckBoxClick
        end
        object ChangeNameEdit: TEdit
          Left = 176
          Top = 19
          Width = 73
          Height = 21
          TabOrder = 2
          Text = 'Pizaria'
        end
        object ChangeNameCheckBox: TCheckBox
          Left = 10
          Top = 20
          Width = 110
          Height = 17
          Caption = 'Change Name'
          TabOrder = 3
        end
        object ChangeRankTrackbar: TTrackBar
          Left = 130
          Top = 70
          Width = 122
          Height = 17
          Max = 9000
          Min = 1
          Position = 1
          TabOrder = 4
          OnChange = ChangeRankTrackbarChange
        end
        object ChangeRankCheckBox: TCheckBox
          Left = 10
          Top = 70
          Width = 110
          Height = 17
          Caption = 'Rank Level ()'
          TabOrder = 5
        end
        object ForceOponentCancelCheckBox: TCheckBox
          Left = 132
          Top = 45
          Width = 105
          Height = 17
          Caption = 'Cancel Battle Bug'
          TabOrder = 6
        end
        object ChangePlayerExpCheckBox: TCheckBox
          Left = 10
          Top = 95
          Width = 110
          Height = 17
          Caption = 'Player Exp ()'
          TabOrder = 7
        end
        object ChangePlayerExpTrackbar: TTrackBar
          Left = 130
          Top = 95
          Width = 122
          Height = 17
          Max = 100000
          Min = 1
          Position = 1
          TabOrder = 8
          OnChange = ChangePlayerExpTrackbarChange
        end
        object BlockSpellsCheckBox: TCheckBox
          Left = 10
          Top = 140
          Width = 89
          Height = 17
          Caption = 'Block Spells'
          TabOrder = 9
          OnClick = BlockSpellsCheckBoxClick
        end
        object InvincibleCheckBox: TCheckBox
          Left = 132
          Top = 140
          Width = 97
          Height = 17
          Caption = 'Invincible'
          TabOrder = 10
          OnClick = InvincibleCheckBoxClick
        end
        object DowngradeOponentCardLVLCheckBox: TCheckBox
          Left = 10
          Top = 163
          Width = 116
          Height = 17
          Caption = 'Down LVL (1)'
          TabOrder = 11
        end
        object DownGradeOpoenentCardLVLTrackBar: TTrackBar
          Left = 132
          Top = 163
          Width = 122
          Height = 17
          Max = 6
          Min = 1
          Position = 1
          TabOrder = 12
          OnChange = DownGradeOpoenentCardLVLTrackBarChange
        end
      end
      object LobbyGroupBox: TGroupBox
        Left = 3
        Top = 206
        Width = 234
        Height = 114
        Caption = 'Lobby'
        TabOrder = 4
        object LobbyLocalPortLabel: TLabel
          Left = 14
          Top = 87
          Width = 51
          Height = 13
          Caption = 'Local Port:'
        end
        object LobbyProxyPortLabel: TLabel
          Left = 14
          Top = 60
          Width = 55
          Height = 13
          Caption = 'Proxy Port:'
        end
        object LobbyProxyIpLabel: TLabel
          Left = 14
          Top = 33
          Width = 45
          Height = 13
          Caption = 'Proxy IP:'
        end
        object LobbyLocalPortEdit: TEdit
          Left = 80
          Top = 83
          Width = 81
          Height = 21
          TabOrder = 0
          Text = '4530'
        end
        object LobbyProxyPortEdit: TEdit
          Left = 80
          Top = 56
          Width = 81
          Height = 21
          TabOrder = 1
          Text = '4530'
        end
        object LobbyProxyIpEdit: TEdit
          Left = 80
          Top = 29
          Width = 81
          Height = 21
          TabOrder = 2
          Text = 'sppd.ddns.net'
        end
      end
      object GroupBox6: TGroupBox
        Left = 243
        Top = 206
        Width = 259
        Height = 114
        Caption = 'Battle'
        TabOrder = 5
        object BattleLocalPortLabel: TLabel
          Left = 14
          Top = 52
          Width = 51
          Height = 13
          Caption = 'Local Port:'
        end
        object BattleLocalIPLabel: TLabel
          Left = 14
          Top = 20
          Width = 41
          Height = 13
          Caption = 'Local IP:'
        end
        object BattleLocalPortEdit: TEdit
          Left = 80
          Top = 48
          Width = 81
          Height = 21
          TabOrder = 0
          Text = '4531'
        end
        object BattleLocalIPEdit: TEdit
          Left = 80
          Top = 21
          Width = 81
          Height = 21
          TabOrder = 1
          Text = '192.168.1.3'
        end
      end
    end
    object Packets2: TTabSheet
      Caption = 'Packet Functions'
      ImageIndex = 4
      object ListView1: TListView
        Left = 0
        Top = 0
        Width = 771
        Height = 323
        Align = alClient
        Columns = <
          item
            Caption = 'Number'
            Width = 52
          end
          item
            Caption = 'Size'
          end
          item
            Caption = 'State'
          end
          item
            Caption = 'Type'
            Width = 100
          end
          item
            Caption = 'Packet'
            Width = 450
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenu1
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object Log2: TTabSheet
      Caption = 'Log Functions'
      ImageIndex = 5
      object LogMemo2: TMemo
        Left = 0
        Top = 0
        Width = 771
        Height = 323
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Oponent Deck'
      ImageIndex = 8
      OnResize = TabSheet4Resize
      object OponentCardsAPanel: TPanel
        Left = 0
        Top = 0
        Width = 771
        Height = 165
        Align = alTop
        TabOrder = 0
        OnResize = OponentCardsAPanelResize
        object OponentCardsA1Panel: TPanel
          Left = 8
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 0
          OnResize = OponentCardsPanelResize
          object OponentCardsA1Image: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA1Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA1StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA2Panel: TPanel
          Left = 135
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 1
          OnResize = OponentCardsPanelResize
          object OponentCardsA2IMage: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA2Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA2StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA3Panel: TPanel
          Left = 264
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 2
          OnResize = OponentCardsPanelResize
          object OponentCardsA3IMage: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA3Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA3StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA4Panel: TPanel
          Left = 394
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 3
          OnResize = OponentCardsPanelResize
          object OponentCardsA4IMage: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA4Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA4StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA5Panel: TPanel
          Left = 527
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 4
          OnResize = OponentCardsPanelResize
          object OponentCardsA5IMage: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA5Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA5StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA6Panel: TPanel
          Left = 650
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 5
          OnResize = OponentCardsPanelResize
          object OponentCardsA6IMage: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA6Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA6StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
      end
      object OponentCardsbPanel: TPanel
        Left = 0
        Top = 171
        Width = 771
        Height = 152
        Align = alBottom
        TabOrder = 1
        OnResize = OponentCardsbPanelResize
        object OponentCardsA7Panel: TPanel
          Left = 8
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 0
          OnResize = OponentCardsPanelResize
          object OponentCardsA7Image: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA7Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA7StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA8Panel: TPanel
          Left = 135
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 1
          OnResize = OponentCardsPanelResize
          object OponentCardsA8Image: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA8Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA8StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA9Panel: TPanel
          Left = 264
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 2
          OnResize = OponentCardsPanelResize
          object OponentCardsA9Image: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA9Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA9StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA10Panel: TPanel
          Left = 394
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 3
          OnResize = OponentCardsPanelResize
          object OponentCardsA10Image: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA10Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA10StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA11Panel: TPanel
          Left = 527
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 4
          OnResize = OponentCardsPanelResize
          object OponentCardsA11Image: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA11Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA11StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object OponentCardsA12Panel: TPanel
          Left = 650
          Top = 0
          Width = 80
          Height = 150
          BorderStyle = bsSingle
          TabOrder = 5
          OnResize = OponentCardsPanelResize
          object OponentCardsA12Image: TImage
            Left = 10
            Top = 15
            Width = 50
            Height = 81
          end
          object OponentCardsA12Statictext: TStaticText
            Left = 1
            Top = 1
            Width = 74
            Height = 17
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object OponentCardsA12StatsStatictext: TStaticText
            Left = 1
            Top = 128
            Width = 74
            Height = 17
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            BorderStyle = sbsSunken
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ImageIndex = 7
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 771
        Height = 323
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 76
    Top = 145
    object ExporttoClipBoard1: TMenuItem
      Caption = 'Export to ClipBoard'
      OnClick = ExporttoClipBoard1Click
    end
    object CopyLine1: TMenuItem
      Caption = 'Copy Line'
      OnClick = CopyLine1Click
    end
    object ConvertToText1: TMenuItem
      Caption = 'Convert To Text'
      OnClick = ConvertToText1Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 32
    Top = 152
  end
end
