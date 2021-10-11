object Form2: TForm2
  Left = 212
  Top = 276
  BorderStyle = bsDialog
  Caption = #1054#1089#1086#1073#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 155
  ClientWidth = 220
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 38
    Height = 13
    Caption = #1042#1099#1089#1086#1090#1072
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 39
    Height = 13
    Caption = #1064#1080#1088#1080#1085#1072
  end
  object Label3: TLabel
    Left = 8
    Top = 80
    Width = 55
    Height = 13
    Caption = #1063#1080#1089#1083#1086' '#1084#1080#1085
  end
  object Button1: TButton
    Left = 136
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object SpinEdit1: TSpinEdit
    Left = 89
    Top = 13
    Width = 121
    Height = 22
    MaxValue = 40
    MinValue = 5
    TabOrder = 1
    Value = 5
  end
  object SpinEdit2: TSpinEdit
    Left = 89
    Top = 45
    Width = 121
    Height = 22
    MaxValue = 40
    MinValue = 5
    TabOrder = 2
    Value = 5
  end
  object SpinEdit3: TSpinEdit
    Left = 89
    Top = 77
    Width = 121
    Height = 22
    MaxValue = 100000
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
end
