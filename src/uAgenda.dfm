object frmAgenda: TfrmAgenda
  Left = 0
  Top = 0
  Caption = 'Agenda'
  ClientHeight = 362
  ClientWidth = 523
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 523
    Height = 362
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Criar Contato'
      object GroupBox1: TGroupBox
        Left = 46
        Top = 3
        Width = 419
        Height = 286
        Caption = 'Contato'
        Enabled = False
        TabOrder = 0
        object Label2: TLabel
          Left = 218
          Top = 59
          Width = 82
          Height = 13
          Caption = 'Telefone Celular:'
        end
        object Label3: TLabel
          Left = 206
          Top = 91
          Width = 102
          Height = 13
          Caption = 'Telefone Residencial:'
        end
        object Label4: TLabel
          Left = 210
          Top = 130
          Width = 59
          Height = 13
          Caption = 'Estado Civil:'
        end
        object Label1: TLabel
          Left = 19
          Top = 59
          Width = 32
          Height = 13
          Caption = 'Idade:'
        end
        object Label5: TLabel
          Left = 19
          Top = 176
          Width = 49
          Height = 13
          Caption = 'Endere'#231'o:'
        end
        object Label6: TLabel
          Left = 19
          Top = 208
          Width = 32
          Height = 13
          Caption = 'Bairro:'
        end
        object Label7: TLabel
          Left = 306
          Top = 208
          Width = 23
          Height = 13
          Caption = 'CEP:'
        end
        object Label10: TLabel
          Left = 19
          Top = 27
          Width = 31
          Height = 13
          Caption = 'Nome:'
        end
        object edIdade: TEdit
          Left = 57
          Top = 56
          Width = 40
          Height = 21
          MaxLength = 3
          NumbersOnly = True
          TabOrder = 1
        end
        object rgSexo: TRadioGroup
          Left = 19
          Top = 83
          Width = 117
          Height = 73
          Caption = 'Sexo'
          Items.Strings = (
            'Masculino'
            'Feminino')
          TabOrder = 4
          TabStop = True
        end
        object medTelCel: TMaskEdit
          Left = 306
          Top = 56
          Width = 87
          Height = 21
          EditMask = '!\(99\)99999-9999;1;_'
          MaxLength = 14
          TabOrder = 2
          Text = '(  )     -    '
        end
        object cbEstadoCivil: TComboBox
          Left = 275
          Top = 127
          Width = 121
          Height = 21
          Style = csDropDownList
          TabOrder = 5
          Items.Strings = (
            'Solteiro'
            'Casado'
            'Divorciado'
            'Vi'#250'vo')
        end
        object edEndereco: TEdit
          Left = 74
          Top = 173
          Width = 322
          Height = 21
          MaxLength = 40
          TabOrder = 6
        end
        object edBairro: TEdit
          Left = 57
          Top = 205
          Width = 120
          Height = 21
          MaxLength = 15
          TabOrder = 7
        end
        object medCEP: TMaskEdit
          Left = 335
          Top = 205
          Width = 58
          Height = 21
          EditMask = '99999\-999;1;_'
          MaxLength = 9
          TabOrder = 8
          Text = '     -   '
        end
        object btOK: TButton
          Left = 225
          Top = 248
          Width = 75
          Height = 25
          Caption = 'OK'
          TabOrder = 9
          OnClick = btOKClick
        end
        object btCancelar: TButton
          Left = 322
          Top = 248
          Width = 75
          Height = 25
          Caption = 'Cancelar'
          TabOrder = 10
          OnClick = btCancelarClick
        end
        object edNome: TEdit
          Left = 56
          Top = 24
          Width = 340
          Height = 21
          MaxLength = 30
          TabOrder = 0
        end
        object medTelRes: TMaskEdit
          Left = 314
          Top = 88
          Width = 81
          Height = 21
          EditMask = '!\(99\)9999-9999;1;_'
          MaxLength = 13
          TabOrder = 3
          Text = '(  )    -    '
        end
      end
      object btCriar: TButton
        Left = 46
        Top = 295
        Width = 419
        Height = 36
        Caption = 'Clique aqui para criar um novo contato'
        TabOrder = 1
        OnClick = btCriarClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Lista de Contatos'
      ImageIndex = 1
      object lbContato: TListBox
        Left = 3
        Top = 3
        Width = 190
        Height = 326
        ItemHeight = 13
        TabOrder = 0
        OnClick = lbContatoClick
      end
      object mmContatoBusca: TMemo
        Left = 199
        Top = 3
        Width = 309
        Height = 142
        Enabled = False
        TabOrder = 1
      end
      object btDeletar: TButton
        Left = 199
        Top = 151
        Width = 149
        Height = 25
        Caption = 'Deletar'
        TabOrder = 2
        OnClick = btDeletarClick
      end
      object btMostrar: TButton
        Left = 199
        Top = 183
        Width = 309
        Height = 25
        Caption = 'Buscar por Nome'
        TabOrder = 3
        OnClick = btMostrarClick
      end
      object GroupBox2: TGroupBox
        Left = 199
        Top = 214
        Width = 309
        Height = 115
        Caption = 'Filtro'
        TabOrder = 4
        object Label8: TLabel
          Left = 178
          Top = 21
          Width = 28
          Height = 13
          Caption = 'Sexo:'
        end
        object Label9: TLabel
          Left = 36
          Top = 21
          Width = 59
          Height = 13
          Caption = 'Estado Civil:'
        end
        object btMostrarFiltro: TButton
          Left = 36
          Top = 77
          Width = 78
          Height = 25
          Caption = 'Mostrar'
          TabOrder = 2
          OnClick = btMostrarFiltroClick
        end
        object cbFiltroSexo: TComboBox
          Left = 178
          Top = 40
          Width = 95
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          Items.Strings = (
            'Masculino'
            'Feminino')
        end
        object cbFiltroEstCivil: TComboBox
          Left = 36
          Top = 40
          Width = 94
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Solteiro'
            'Casado'
            'Divorciado'
            'Vi'#250'vo')
        end
        object btLimparFiltro: TButton
          Left = 195
          Top = 77
          Width = 78
          Height = 25
          Caption = 'Limpar'
          TabOrder = 3
          OnClick = btLimparFiltroClick
        end
      end
      object btAtualizar: TButton
        Left = 360
        Top = 151
        Width = 148
        Height = 25
        Caption = 'Atualizar'
        TabOrder = 5
        OnClick = btAtualizarListaClick
      end
    end
  end
end
