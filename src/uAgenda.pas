unit uAgenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus;

type
  Contato = record
    Nome: string[30];
    Idade: integer;
    Sexo: char;
    TelCel: string[14];
    TelRes: string[13];
    Endereco: string[40];
    Bairro: string[15];
    EstCivil: char;
    CEP: string[9];
    StatusReg: boolean;
  end;

type
  TfrmAgenda = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edIdade: TEdit;
    rgSexo: TRadioGroup;
    medTelCel: TMaskEdit;
    cbEstadoCivil: TComboBox;
    edEndereco: TEdit;
    edBairro: TEdit;
    medCEP: TMaskEdit;
    btOK: TButton;
    btCancelar: TButton;
    TabSheet2: TTabSheet;
    lbContato: TListBox;
    mmContatoBusca: TMemo;
    Label10: TLabel;
    edNome: TEdit;
    btDeletar: TButton;
    btMostrar: TButton;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    btMostrarFiltro: TButton;
    cbFiltroSexo: TComboBox;
    cbFiltroEstCivil: TComboBox;
    btLimparFiltro: TButton;
    btAtualizar: TButton;
    medTelRes: TMaskEdit;
    btCriar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btCriarClick(Sender: TObject);
    procedure btMostrarClick(Sender: TObject);
    procedure btDeletarClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btAtualizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCancelarClick(Sender: TObject);
    procedure btMostrarFiltroClick(Sender: TObject);
    procedure lbContatoClick(Sender: TObject);
    procedure btLimparFiltroClick(Sender: TObject);
    procedure btAtualizarListaClick(Sender: TObject);
  private
    { Private declarations }
    procedure Limpar;
    procedure Update;
    procedure Create;
    procedure Troca(var P1, P2: Contato);
    procedure Ordenar;
  public
    { Public declarations }
  end;

var
  frmAgenda: TfrmAgenda;
  Agenda: array [0..100] of Contato;
  Arquivo: file of Contato;
  nome: string;

implementation

{$R *.dfm}

function Comparar(const P1, P2: Contato): Integer;
begin
//Compara dois nomes por ordem alfabética
//Se igual, retorna 0
//Se P1 > P2, retorna inteiro maior que 0
//Se P1 < P2, retorna inteiro menor que 0

  Result := CompareText(P1.Nome, P2.Nome);
end;

function Sexo (radioGroup: TRadioGroup): Char;
begin
//Transforma o index do RadioGroup em um caracter respectivo ao sexo
//Utilizada nos botões Atualizar e Criar, para armazenar o dado

  case radioGroup.ItemIndex of
    0 : Sexo := 'M';
    1 : Sexo := 'F';
  end;
end;

function SexoReverso (i: integer): Integer;
begin
//Transforma o caracter representativo do sexo em index do RadioGroup
//Utilizada no botão Atualizar, para mostrar o dado do contato ao usuário

  case Agenda[i].Sexo of
    'M' : SexoReverso := 0;
    'F' : SexoReverso := 1;
  end;
end;

function MostrarSexo (i: integer): String;
begin
//Transforma o caracter representativo do sexo em uma String correspondente
//Utilizada no botão Buscar e na Lista de Contatos, para mostrar o dado ao usuário

  case Agenda[i].Sexo of
    'M' : MostrarSexo := 'Masculino';
    'F' : MostrarSexo := 'Feminino';
  end;
end;

function EstCivil (comboBox: TComboBox): Char;
begin
//Transforma o index do RadioGroup em um caracter respectivo ao estado civil
//Utilizada nos botões Atualizar e Criar, para armazenar o dado

  case comboBox.ItemIndex of
    0 : EstCivil := 'S';
    1 : EstCivil := 'C';
    2 : EstCivil := 'D';
    3 : EstCivil := 'V';
  end;
end;

function EstCivilReverso (i: integer): integer;
begin
//Transforma o caracter representativo do estado civil em index do RadioGroup
//Utilizada no botão Atualizar, para mostrar o dado do contato ao usuário

  case Agenda[i].EstCivil of
    'S' : EstCivilReverso := 0;
    'C' : EstCivilReverso := 1;
    'D' : EstCivilReverso := 2;
    'V' : EstCivilReverso := 3;
  end;
end;

function MostrarEstCivil (i: integer): String;
begin
//Transforma o caracter representativo do estado civil em uma String correspondente
//Utilizada no botão Buscar e na Lista de Contatos, para mostrar o dado ao usuário

  if Agenda[i].Sexo = 'M' then
    case Agenda[i].EstCivil of
      'S' : MostrarEstCivil := 'Solteiro';
      'C' : MostrarEstCivil := 'Casado';
      'D' : MostrarEstCivil := 'Divorciado';
      'V' : MostrarEstCivil := 'Viúvo';
    end;

  if Agenda[i].Sexo = 'F' then
    case Agenda[i].EstCivil of
      'S' : MostrarEstCivil := 'Solteira';
      'C' : MostrarEstCivil := 'Casada';
      'D' : MostrarEstCivil := 'Divorciada';
      'V' : MostrarEstCivil := 'Viúva';
    end;
end;

function Filtro (cb1, cb2: TComboBox): integer;
begin
//Retorna o valor correspondente a opção de filtro selecionada

  if (cb1.ItemIndex <> -1) and (cb2.ItemIndex = -1) then
    Filtro := 1
  else if (cb1.ItemIndex = -1) and (cb2.ItemIndex <> -1) then
    Filtro := 2
  else if (cb1.ItemIndex <> -1) and (cb2.ItemIndex <> -1) then
    Filtro := 3
  else if (cb1.ItemIndex = -1) and (cb2.ItemIndex = -1) then
    Filtro := 0;
end;

procedure TfrmAgenda.btAtualizarClick(Sender: TObject);
var i: integer;
begin
  if not (InputQuery('Digite um Nome', 'Nome: ', nome)) then //Se o botão 'Cancelar' for pressionado
    Exit;

  if nome = '' then //Se o botão 'OK' for pressiodado e o nome estiver vazio
  begin
    ShowMessage('Digite um nome!');
    Exit;
  end;

  for i := 0 to 100 do
    if Agenda[i].Nome = nome then //Se o contato for encontrado
    begin
      //Habilita o GroupBox de entrada de dados
      GroupBox1.Enabled := True;
      //Desabilita os botões de cadastro
      btMostrar.Enabled := False;
      btDeletar.Enabled := False;
      btAtualizar.Enabled := False;
      //Desabilita o filtro
      GroupBox2.Enabled := False;

      edNome.SetFocus;

      //Mostra ao usuário as informações armazenadas no contato
      edNome.Text := Agenda[i].Nome;
      edIdade.Text := Agenda[i].Idade.ToString;
      rgSexo.ItemIndex := SexoReverso(i);
      medTelCel.Text := Agenda[i].TelCel;
      medTelRes.Text := Agenda[i].TelRes;
      cbEstadoCivil.ItemIndex := EstCivilReverso(i);
      edEndereco.Text := Agenda[i].Endereco;
      edBairro.Text := Agenda[i].Bairro;
      medCEP.Text := Agenda[i].CEP;

      //O botão 'OK' recebe a tag respectiva a atualização
      btOK.Tag := 2;

      Exit;
    end;

  //Se o nome não entrar em nenhuma das opções anteriores, o contato não existe
  ShowMessage('Esse contato não existe!');
end;

procedure TfrmAgenda.btAtualizarListaClick(Sender: TObject);
var i: integer;
begin
  if lbContato.ItemIndex = -1 then //Se clicar em algo que não seja elemento
    Exit;

  for i := 0 to 100 do
    if lbContato.Items[lbContato.ItemIndex] = Agenda[i].Nome then //Se o contato for encontrado
    begin
      TabSheet1.Show;
      nome := Agenda[i].Nome;
    
      //Habilita o GroupBox de entrada de dados
      GroupBox1.Enabled := True;
      //Desabilita os botões de cadastro
      btCriar.Enabled := False;
      btMostrar.Enabled := False;
      btDeletar.Enabled := False;
      btAtualizar.Enabled := False;
      //Desabilita o filtro
      GroupBox2.Enabled := False;

      edNome.SetFocus;

      //Mostra ao usuário as informações armazenadas no contato
      edNome.Text := Agenda[i].Nome;
      edIdade.Text := Agenda[i].Idade.ToString;
      rgSexo.ItemIndex := SexoReverso(i);
      medTelCel.Text := Agenda[i].TelCel;
      medTelRes.Text := Agenda[i].TelRes;
      cbEstadoCivil.ItemIndex := EstCivilReverso(i);
      edEndereco.Text := Agenda[i].Endereco;
      edBairro.Text := Agenda[i].Bairro;
      medCEP.Text := Agenda[i].CEP;

      //O botão 'OK' recebe a tag respectiva a atualização
      btOK.Tag := 2;

      Exit;
    end;
end;

procedure TfrmAgenda.btCancelarClick(Sender: TObject);
var i: integer;
begin
// Cancela a operação de criação ou atualização
  Limpar;

  ShowMessage('Operação Cancelada');

  //Desabilita o GroupBox de entrada de dados
  GroupBox1.Enabled := False;
  //Habilita os botões de cadastro
  btCriar.Enabled := True;
  btMostrar.Enabled := True;
  btDeletar.Enabled := True;
  btAtualizar.Enabled := True;
  //Habilita o filtro
  GroupBox2.Enabled := True;
end;

procedure TfrmAgenda.btCriarClick(Sender: TObject);
var i, j, teste: integer;
begin
//Verifica se já existe um contato com o mesmo nome
//Torna o GroupBox com as entradas de dados habilitado
//Desabilita os botões de cadastro

  for i := 0 to 100 do
    if (Agenda[i].StatusReg = false) then //Verifica se a agenda está lotada
      break
    else
    if (i = 100) then
    begin
      ShowMessage('Agenda lotada!!');
      Exit;
    end;

    //Habilita o GroupBox de entrada de dados
    GroupBox1.Enabled := True;
    //Desabilita os botões de cadastro
    btCriar.Enabled := False;
    btMostrar.Enabled := False;
    btDeletar.Enabled := False;
    btAtualizar.Enabled := False;
    //Desabilita o filtro
    GroupBox2.Enabled := False;

    //O botão 'OK' recebe a tag respectiva a criação
    btOK.Tag := 1;

    edNome.SetFocus;
end;

procedure TfrmAgenda.btDeletarClick(Sender: TObject);
var i: integer;
begin
  if lbContato.ItemIndex = -1 then //Se clicar em algo que não seja elemento
    Exit;

  if MessageDlg('Deseja deletar o contato?', mtConfirmation, mbYesNo, 0) = mrNo then
    Exit;

  for i := 0 to 100 do
    if lbContato.Items[lbContato.ItemIndex] = Agenda[i].Nome then //Apague o contato selecionado
    begin
      lbContato.Clear;
      Agenda[i].Nome := '';
      Agenda[i].Idade := 0;
      Agenda[i].Sexo := '0';
      Agenda[i].TelCel := '';
      Agenda[i].TelRes := '';
      Agenda[i].EstCivil := '0';
      Agenda[i].Endereco := '';
      Agenda[i].Bairro := '';
      Agenda[i].CEP := '';
      Agenda[i].StatusReg := False;

      mmContatoBusca.Clear;
      lbContato.Clear;
      Update;
      Create;

      ShowMessage('Contato Deletado!');

      Exit;
    end;

  //Se o nome não entrar em nenhuma das opções anteriores, o contato não existe
  ShowMessage('Esse contato não existe!');
end;

procedure TfrmAgenda.btLimparFiltroClick(Sender: TObject);
begin
//Limpar a seleção do Filtro

  cbFiltroSexo.ItemIndex := -1;
  cbFiltroEstCivil.ItemIndex := -1;
end;

procedure TfrmAgenda.btMostrarClick(Sender: TObject);
var i, j: integer;
    sexo: char;
begin
    if lbContato.Items.Count = 0 then
    begin
      ShowMessage('Não há contatos cadastrados!');
      Exit;
    end;

    if not (InputQuery('Digite um Nome', 'Nome: ', nome)) then //Se o botão 'Cancelar' for pressionado
      Exit;

    if nome = '' then
    begin
      ShowMessage('Digite um nome!'); //Se o botão 'OK' for pressiodado e o nome estiver vazio
      Exit;
    end;

    for i := 0 to 100 do
      if nome = Agenda[i].Nome then //Se o contato for encontrado, mostre os dados ao usuário
      begin
        for j := 0 to (lbContato.Items.Count - 1) do //Selecionar o contato buscado na lista
        begin
          if nome = lbContato.Items[j] then
            lbContato.ItemIndex := j;
        end;

        mmContatoBusca.Clear;
        mmContatoBusca.Lines.Add('Nome: ' + Agenda[i].Nome);
        mmContatoBusca.Lines.Add('Idade: ' + (Agenda[i].Idade).ToString);
        mmContatoBusca.Lines.Add('Sexo: ' + MostrarSexo(i));
        mmContatoBusca.Lines.Add('Fone Celular: ' + Agenda[i].TelCel);
        mmContatoBusca.Lines.Add('Fone Residencial: ' + Agenda[i].TelRes);
        mmContatoBusca.Lines.Add('Estado Civil: ' + MostrarEstCivil(i));
        mmContatoBusca.Lines.Add('Endereço: ' + Agenda[i].Endereco);
        mmContatoBusca.Lines.Add('Bairro: ' + Agenda[i].Bairro);
        mmContatoBusca.Lines.Add('CEP: ' + Agenda[i].CEP);
        Exit;
      end;

  //Se o nome não entrar em nenhuma das opções anteriores, o contato não existe
  ShowMessage('Esse contato não existe!');
end;

procedure TfrmAgenda.btMostrarFiltroClick(Sender: TObject);
var i: integer;
    cont: boolean;
begin
  lbContato.Clear; //Limpar o ListBox
  cont := False; //Variável de controle da existência do contato

  if Filtro(cbFiltroSexo, cbFiltroEstCivil) = 1 then //Se o filtro for Sexo
  begin
    for i := 0 to 100 do
      if (SexoReverso(i) = cbFiltroSexo.ItemIndex) and
         (Agenda[i].StatusReg = True) then
      begin
        lbContato.Items.Add(Agenda[i].Nome);
        cont := True;
      end;
  end
  else if Filtro(cbFiltroSexo, cbFiltroEstCivil) = 2 then //Se o filtro for Estado Civil
  begin
    for i := 0 to 100 do
      if (EstCivilReverso(i) = cbFiltroEstCivil.ItemIndex) and
         (Agenda[i].StatusReg = True) then
      begin
        lbContato.Items.Add(Agenda[i].Nome);
        cont := True;
      end;
  end
  else if Filtro(cbFiltroSexo, cbFiltroEstCivil) = 3 then //Se o filtro for ambos
  begin
    for i := 0 to 100 do
      if (EstCivilReverso(i) = cbFiltroEstCivil.ItemIndex) and
         (SexoReverso(i) = cbFiltroSexo.ItemIndex) and
         (Agenda[i].StatusReg = True) then
      begin
        lbContato.Items.Add(Agenda[i].Nome);
        cont := True;
      end;
  end
  else if Filtro(cbFiltroSexo, cbFiltroEstCivil) = 0 then //Se nenhum filtro for selecionado
  begin
    for i := 0 to 100 do
      if (Agenda[i].StatusReg = True) then
      begin
        lbContato.Items.Add(Agenda[i].Nome);
        cont := True;
      end;
  end;

  if cont = False then //Se nenhum contato for encontrado
    lbContato.Items.Add('Nenhum contato encontrado!');
end;

procedure TfrmAgenda.btOKClick(Sender: TObject);
var i, verificaNome, j: integer;
    nome2: string;
begin
  verificaNome := 0;
  nome2 := edNome.Text;

  for i := 0 to 100 do
    if (Agenda[i].Nome = nome2) then
      verificaNome := 2;

  if edNome.Text = '' then
    verificaNome := 1;

  if btOK.Tag = 1 then //Se for para criar
  begin
    if verificaNome = 2 then
    begin
      ShowMessage('Esse contato já existe');
      Exit;
    end;

    for i := 0 to 100 do
      if Agenda[i].StatusReg = false then //Busca uma posição vazia
        break;
  end;

  if btOK.Tag = 2 then //Se for para atualizar
  begin
    for i := 0 to 100 do
      if Agenda[i].Nome = nome then //Busca o nome do contato
        break;

    for j := 0 to lbContato.Items.Count - 1 do
    begin

      if lbContato.Items[j] = nome2 then
      begin
        ShowMessage('Esse contato já existe');
        Exit;
      end;
    end;
  end;

  //Se todas as informações estiverem completas
  if (rgSexo.ItemIndex <> -1) and (edIdade.Text <> '') and (medTelCel.Text <> '(  )     -    ') and
     (medTelRes.Text <> '(  )    -    ') and (cbEstadoCivil.ItemIndex <> -1) and (edEndereco.Text <> '') and
     (edBairro.Text <> '') and (medCEP.Text <> '     -   ') and ((Length(medTelCel.Text) = 14) and
     (Length(medTelRes.Text) = 13) and (Length(medCEP.Text) = 9)) and (edNome.Text <> '') then
  begin
    if StrToInt(edIdade.Text) > 150 then //Se idade digitada for maior que 150
      begin
        ShowMessage('Número muito grande' + #13 + 'Máximo = 150');
        Exit;
      end;

    //Cadastra os dados no vetor
    Agenda[i].Nome := nome2;
    Agenda[i].Idade := StrToInt(edIdade.Text);
    Agenda[i].Sexo := Sexo(rgSexo);
    Agenda[i].TelCel := medTelCel.Text;
    Agenda[i].TelRes := medTelRes.Text;
    Agenda[i].EstCivil := EstCivil(cbEstadoCivil);
    Agenda[i].Endereco := edEndereco.Text;
    Agenda[i].Bairro := edBairro.Text;
    Agenda[i].CEP := medCEP.Text;
    Agenda[i].StatusReg := True;

    //Desabilita o GroupBox de entrada de dados
    GroupBox1.Enabled := False;
    //Habilita os botões de cadastro
    btCriar.Enabled := True;
    btDeletar.Enabled := True;
    btMostrar.Enabled := True;
    btAtualizar.Enabled := True;
    //Habilita o filtro
    GroupBox2.Enabled := True;
    //Limpa os campos de entrada de dados
    Limpar;

    mmContatoBusca.Clear;
    lbContato.Clear;
    Update;
    Create;

    tabsheet2.Show;
  end
  else //Se as informações estiverem incompletas
    ShowMessage('Faltam Informações');
end;

procedure TfrmAgenda.Create;
var i: integer;
begin
  for i := 0 to 100 do
    Agenda[i].StatusReg := False;

  AssignFile(Arquivo, 'Agenda.txt');

  if FileExists('Agenda.txt') then
    Reset(Arquivo) //Abre o arquivo
  else
    Rewrite(Arquivo); //Cria o arquivo

  Seek(Arquivo, 0); //Posiciona o ponteiro no início do arquivo
  i := 0;
  while not(eof(Arquivo)) do //Enquanto não chegar na última posição (eof)
  begin
    Read(Arquivo, Agenda[i]); //Lê as informações do arquivo e armazena no vetor
    Inc(i);
  end;

  Ordenar; //Ordena o vetor Agenda
  for i := 0 to 100 do
    if Agenda[i].StatusReg = True then
      lbContato.Items.Add(Agenda[i].Nome); //Mostra os nomes dos contatos no ListBox
end;

procedure TfrmAgenda.Limpar;
begin
//Procedimento para limpar as entradas de dados

  edNome.Text := '';
  edIdade.Text := '';
  rgSexo.ItemIndex := -1;
  medTelCel.Text := '';
  medTelRes.Text := '';
  cbEstadoCivil.ItemIndex := -1;
  edEndereco.Text := '';
  edBairro.Text := '';
  medCEP.Text := '';
end;

procedure TfrmAgenda.Ordenar;
var
  i, n: Integer;
  Trocado: Boolean;
begin
//Procedimento para ordenar o vetor Agenda em ordem alfabética

  n := Length(Agenda);
  repeat
    Trocado := False;
    for i := 1 to n-1 do begin
      if Comparar(Agenda[i-1], Agenda[i])>0 then begin
        Troca(Agenda[i-1], Agenda[i]);
        Trocado := True;
      end;
    end;
    dec(n);
  until not Trocado;
end;

procedure TfrmAgenda.Troca(var P1, P2: Contato);
var
  aux: Contato;
begin
//Pocedimento para trocar dois elementos

  aux := P1;
  P1 := P2;
  P2 := aux;
end;

procedure TfrmAgenda.Update;
var i: integer;
begin
  rewrite(Arquivo); //Cria o arquivo novamente

  for i := 0 to 100 do
    if Agenda[i].StatusReg = True then
      write(Arquivo, Agenda[i]); //Escreve os dados do vetor Agenda no arquivo;

  CloseFile(Arquivo); //Fecha o arquivo
end;

procedure TfrmAgenda.FormClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
begin
  Update;
end;

procedure TfrmAgenda.FormCreate(Sender: TObject);
var i: integer;
begin
  Create;
end;

procedure TfrmAgenda.lbContatoClick(Sender: TObject);
var i: integer;
begin
  if lbContato.ItemIndex = -1 then //Se clicar em algo que não seja elemento
    Exit;

  //Mostra as informações no Memo
  for i := 0 to 100 do
    if lbContato.Items[lbContato.ItemIndex] = Agenda[i].Nome then
    begin
      mmContatoBusca.Clear;
      mmContatoBusca.Lines.Add('Nome: ' + Agenda[i].Nome);
      mmContatoBusca.Lines.Add('Idade: ' + (Agenda[i].Idade).ToString);
      mmContatoBusca.Lines.Add('Sexo: ' + MostrarSexo(i));
      mmContatoBusca.Lines.Add('Fone Celular: ' + Agenda[i].TelCel);
      mmContatoBusca.Lines.Add('Fone Residencial: ' + Agenda[i].TelRes);
      mmContatoBusca.Lines.Add('Estado Civil: ' + MostrarEstCivil(i));
      mmContatoBusca.Lines.Add('Endereço: ' + Agenda[i].Endereco);
      mmContatoBusca.Lines.Add('Bairro: ' + Agenda[i].Bairro);
      mmContatoBusca.Lines.Add('CEP: ' + Agenda[i].CEP);
      Exit;
    end;
end;

end.
