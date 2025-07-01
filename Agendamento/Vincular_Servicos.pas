unit Vincular_Servicos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids,  System.DateUtils;

type
  TfrmAgendamentoServ = class(TForm)
    Label1: TLabel;
    Label8: TLabel;
    cbServicos: TComboBox;
    EdtNroAgen: TEdit;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    edtpreco: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    EdtDesconto: TEdit;
    EdtPrecoTotal: TEdit;
    Label4: TLabel;
    DBGrid1: TDBGrid;
    procedure btnNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure cbServicosChange(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure EdtDescontoChange(Sender: TObject);
  private
    procedure limpar;
    procedure habilitarCampos;
    procedure desabilitarCampos;

    procedure associarCampos;

    procedure listarServicos;

    procedure carregarCombobox;

  public
    procedure calcularTotal;

  end;

var
  frmAgendamentoServ: TfrmAgendamentoServ;
  totalGeral: Double = 0.0;
  precoOriginal: Double = 0.0;
  servicoVinc: string;
  proxSeq: Integer;
  FDataAgendamentoPrincipal: TDate;
  idAgendamento: Integer;

implementation

{$R *.dfm}

uses Modulo, Agendamento;


{ TfrmAgendamentoServ }

procedure TfrmAgendamentoServ.associarCampos;
var
  DuracaoMeses: Integer;
  ServicoId: Integer;

begin

  dm.tb_agendamentoserv.FieldByName('idAgendamento').AsInteger := StrToIntDef(EdtNroAgen.Text, 0);
  dm.tb_agendamentoserv.FieldByName('preco').AsFloat := StrToFloatDef(EdtPreco.Text, 0);
  dm.tb_agendamentoserv.FieldByName('desconto').AsFloat := StrToFloatDef(EdtDesconto.Text, 0);
  dm.tb_agendamentoserv.FieldByName('nomeServico').AsString := cbServicos.Text;
  dm.tb_agendamentoserv.FieldByName('seqServico').AsInteger := proxSeq;

    // Primeiro, encontre o ID do serviço selecionado no ComboBox
  ServicoId := 0; // Inicializa com 0
  if cbServicos.ItemIndex >= 0 then
  begin
    // A forma mais robusta é guardar o ID do serviço como Object no ComboBox.Items
    // No seu 'carregarCombobox', se você usa AddObject(nome, TObject(id)), pode pegar assim:
    // ServicoId := Integer(cbServicos.Items.Objects[cbServicos.ItemIndex]);
    // Se você só adiciona o nome, precisará buscar o ID pelo nome do serviço.
    // Usaremos a busca pelo nome por agora, como já fez em cbServicosChange.

    dm.query_servicos.Close;
    dm.query_servicos.SQL.Clear;
    dm.query_servicos.SQL.Add('SELECT id, duracao_meses FROM servico WHERE nome = :nome');
    dm.query_servicos.ParamByName('nome').AsString := cbServicos.Text;
    dm.query_servicos.Open;

    if not dm.query_servicos.IsEmpty then
      DuracaoMeses := dm.query_servicos.FieldByName('duracao_meses').AsInteger
    else
      DuracaoMeses := 0; // Padrão 0 se não encontrar a duração
    dm.query_servicos.Close;
  end
  else
    DuracaoMeses := 0; // Se nenhum serviço selecionado

  // Calcula a data de vencimento: Data de HOJE + DuracaoMeses
  dm.tb_agendamentoserv.FieldByName('data_vencimento').AsDatetime := IncMonth(Date, DuracaoMeses);
  // --- FIM NOVO ---
end;


procedure TfrmAgendamentoServ.btnEditarClick(Sender: TObject);
var
  idAgendamento: Integer;
  seqServico: Integer;
  DuracaoMeses: Integer;
  DataVencimentoCalculada: TDate;
begin
  try
    idAgendamento := dm.query_agendamentoserv.FieldByName('idAgendamento').AsInteger;
    seqServico := dm.query_agendamentoserv.FieldByName('seqServico').AsInteger;

    // --- NOVO: Lógica para recalcular data_vencimento na edição se o serviço mudar ---
    // Você pode pegar o ID do serviço selecionado no ComboBox e buscar a duração
    // OU apenas atualizar os campos que o usuário edita.
    // Para simplificar, vamos recalcular a data_vencimento com base no serviço atual do ComboBox.
    // Lógica similar à de associarCampos para DuracaoMeses.
    if cbServicos.ItemIndex >= 0 then
    begin
      dm.query_servicos.Close;
      dm.query_servicos.SQL.Clear;
      dm.query_servicos.SQL.Add('SELECT duracao_meses FROM servico WHERE nome = :nome');
      dm.query_servicos.ParamByName('nome').AsString := cbServicos.Text;
      dm.query_servicos.Open;

      if not dm.query_servicos.IsEmpty then
        DuracaoMeses := dm.query_servicos.FieldByName('duracao_meses').AsInteger
      else
        DuracaoMeses := 0;
      dm.query_servicos.Close;
    end
    else
      DuracaoMeses := 0;

    DataVencimentoCalculada := IncMonth(Date, DuracaoMeses); // Calcula com a data atual
    // --- FIM NOVO ---

    // Configurar query de UPDATE
    dm.query_agendamentoserv.Close;
    dm.query_agendamentoserv.SQL.Clear;
    dm.query_agendamentoserv.SQL.Add(
      'UPDATE agendamento_servicos ' +
      'SET nomeServico = :nomeServico, ' +
      '    desconto = :desconto, ' +
      '    preco = :preco, ' +
      '    data_vencimento = :data_vencimento ' + // <<< ADICIONE AQUI
      'WHERE idAgendamento = :idAgendamento AND seqServico = :seqServico'
    );

    // Parâmetros com tipagem explícita
    dm.query_agendamentoserv.ParamByName('nomeServico').Value := cbServicos.Text;
    dm.query_agendamentoserv.ParamByName('desconto').Value := StrToFloatDef(EdtDesconto.Text, 0); // Garante 0 se vazio
    dm.query_agendamentoserv.ParamByName('preco').Value := StrToFloatDef(edtpreco.Text, 0); // Garante 0 se vazio
    dm.query_agendamentoserv.ParamByName('data_vencimento').AsDate := DataVencimentoCalculada; // <<< ADICIONE AQUI

    // Parâmetros do WHERE
    dm.query_agendamentoserv.ParamByName('idAgendamento').AsInteger := idAgendamento;
    dm.query_agendamentoserv.ParamByName('seqServico').AsInteger := seqServico;

    dm.query_agendamentoserv.ExecSQL;

    // Atualizar interface
    MessageDlg('Editado com sucesso!', mtInformation, [mbOK], 0);
    dm.tb_agendamentoserv.Refresh; // Atualiza dataset
    listarServicos;
    calcularTotal;

    btnEditar.Enabled := False;
    btnExcluir.Enabled := False;
    limpar;
    desabilitarCampos;

  except
    on E: EConvertError do
      MessageDlg('Valores inválidos! Verifique os números digitados.', mtError, [mbOK], 0);
    on E: Exception do
      MessageDlg('Erro na edição: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmAgendamentoServ.btnExcluirClick(Sender: TObject);
var
  idAgendamento: Integer;
  seqServico: Integer;
begin
  if (MessageDlg('Deseja Excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    try
      // Obter valores diretamente do dataset ou grid
      idAgendamento := dm.query_agendamentoserv.FieldByName('idAgendamento').AsInteger;
      seqServico := dm.query_agendamentoserv.FieldByName('seqServico').AsInteger;


      // Executar exclusão
      dm.query_agendamentoserv.Close;
      dm.query_agendamentoserv.SQL.Clear;
      dm.query_agendamentoserv.SQL.Add(
        'DELETE FROM agendamento_servicos ' +
        'WHERE idAgendamento = :idAgendamento ' +
        'AND seqServico = :seqServico'
      );
      
      // Parâmetros com tipos explícitos
      dm.query_agendamentoserv.ParamByName('idAgendamento').DataType := ftInteger;
      dm.query_agendamentoserv.ParamByName('idAgendamento').Value := idAgendamento;
      
      dm.query_agendamentoserv.ParamByName('seqServico').DataType := ftInteger;
      dm.query_agendamentoserv.ParamByName('seqServico').Value := seqServico;

      dm.query_agendamentoserv.ExecSQL;

      // Atualizar interface
      MessageDlg('Deletado com sucesso!', mtInformation, [mbOK], 0);
      listarServicos;
      calcularTotal;
      btnEditar.Enabled := False;
      btnExcluir.Enabled := False;

    except
      on E: Exception do
        MessageDlg('Erro ao excluir: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmAgendamentoServ.btnNovoClick(Sender: TObject);
begin
  habilitarCampos;
  dm.tb_agendamentoserv.Insert;
  btnSalvar.Enabled := true;
  btnEditar.Enabled := False;
  btnExcluir.Enabled := False;
end;

procedure TfrmAgendamentoServ.btnSalvarClick(Sender: TObject);

begin
  // Busca o maior seqServico para esse agendamento
  dm.query_aux.Close;
  dm.query_aux.SQL.Clear;
  dm.query_aux.SQL.Add('SELECT MAX(seqServico) as seqServico FROM agendamento_servicos WHERE idAgendamento = :idAg');
  dm.query_aux.ParamByName('idAg').AsInteger := StrToIntDef(EdtNroAgen.Text, 0); // Pega o ID do Agendamento
  dm.query_aux.Open;

  // Define próximo valor
  if dm.query_aux.FieldByName('seqServico').IsNull then
    proxSeq := 1
  else
    proxSeq := dm.query_aux.FieldByName('seqServico').AsInteger + 1;

  dm.tb_agendamentoserv.Insert; // Coloca o dataset em modo de inserção
  associarCampos;             // Preenche os campos do dataset, incluindo data_vencimento

  // Garante que desconto seja salvo mesmo se campo estiver vazio
  // Esta lógica deve estar dentro de associarCampos para consistência.
  // Se 'associarCampos' já converte EdtDesconto.Text para AsFloat, esta parte pode ser removida.
  // if EdtDesconto.Text = '' then
  // dm.tb_agendamentoserv.FieldByName('desconto').Clear
  // else
  // dm.tb_agendamentoserv.FieldByName('desconto').Value := StrToFloatDef(EdtDesconto.Text, 0);

  dm.tb_agendamentoserv.Post; // Salva o novo registro

  MessageDlg('Serviço adicionado',mtInformation,mbOKCancel,0);
  limpar;
  desabilitarCampos;
  listarServicos; // Atualiza o DBGrid
  calcularTotal;
  btnSalvar.Enabled := false;
end;

procedure TfrmAgendamentoServ.calcularTotal;
var
  totalServicos, totalDescontos: Double;
begin
  totalServicos := 0;
  totalDescontos := 0;

  dm.query_agendamentoserv.Close;
  dm.query_agendamentoserv.SQL.Text := 'SELECT * FROM agendamento_servicos WHERE idAgendamento = :idAg';
  dm.query_agendamentoserv.ParamByName('idAg').Value := idAgendamento;
  dm.query_agendamentoserv.Open;

  // Soma preços e descontos
  while not dm.query_agendamentoserv.Eof do
  begin
    totalServicos := totalServicos + dm.query_agendamentoserv.FieldByName('preco').AsFloat;

    if not dm.query_agendamentoserv.FieldByName('desconto').IsNull then
      totalDescontos := totalDescontos + dm.query_agendamentoserv.FieldByName('desconto').AsFloat;

    dm.query_agendamentoserv.Next;
  end;

  // Calcula total líquido
  totalGeral := totalServicos - totalDescontos;
  EdtPrecoTotal.Text := FormatFloat('R$ #,##0.00', totalGeral);
end;



procedure TfrmAgendamentoServ.carregarCombobox;
begin
  dm.query_servicos.Close;
  dm.query_servicos.open;
  if not dm.query_servicos.IsEmpty then
  begin
    while not dm.query_servicos.Eof do
    begin
      cbServicos.items.add(dm.query_servicos.FieldByName('nome').AsString);
       dm.query_servicos.Next;
    end;

  end;

end;


procedure TfrmAgendamentoServ.cbServicosChange(Sender: TObject);
begin
  dm.query_servicos.First;
  while not dm.query_servicos.Eof do
  begin
    if dm.query_servicos.FieldByName('nome').AsString = cbServicos.Text then
    begin
      edtpreco.Text := FormatFloat('#0.00', dm.query_servicos.FieldByName('preco').AsFloat);
      Break;
    end;
    dm.query_servicos.Next;
  end;
end;

procedure TfrmAgendamentoServ.DBGrid1CellClick(Column: TColumn);
var
  DataVencimento: TDate; // Para armazenar a data de vencimento
begin
  habilitarCampos;
  btnEditar.Enabled := true;
  btnExcluir.Enabled := true;
  dm.tb_agendamentoserv.Edit; // Coloca o dataset em modo de edição

  EdtNroAgen.Text := dm.query_agendamentoserv.FieldByName('idAgendamento').Value;
  edtpreco.Text := dm.query_agendamentoserv.FieldByName('preco').Value;

  if dm.query_agendamentoserv.FieldByName('Desconto').Value <> null then
    EdtDesconto.Text := dm.query_agendamentoserv.FieldByName('Desconto').Value;

  cbServicos.Text := dm.query_agendamentoserv.FieldByName('nomeServico').Value;

  // --- NOVO: Carregar a data de vencimento (se você tiver um campo visual para ela) ---
  // Se você tiver um TDateTimePicker no formulário para 'data_vencimento', carregue aqui:
  // if not dm.query_agendamentoserv.FieldByName('data_vencimento').IsNull then
  //   dtpDataVencimento.Date := dm.query_agendamentoserv.FieldByName('data_vencimento').AsDate;
  // --- FIM NOVO ---
end;

procedure TfrmAgendamentoServ.desabilitarCampos;
begin
    EdtDesconto.Enabled := false;
    cbServicos.Enabled := false;
    edtpreco.Enabled := false;
    EdtPrecoTotal.Enabled :=false;
    EdtNroAgen.Enabled := false;

end;

procedure TfrmAgendamentoServ.EdtDescontoChange(Sender: TObject);
begin
  // Garante que o desconto não seja maior que o preço
  if StrToFloatDef(EdtDesconto.Text, 0) > StrToFloatDef(edtpreco.Text, 0) then
  begin
    MessageDlg('Desconto não pode ser maior que o preço!', mtWarning, [mbOK], 0);
    EdtDesconto.Text := '0,00';
  end;
end;

procedure TfrmAgendamentoServ.FormCreate(Sender: TObject);
begin
listarServicos;
end;

procedure TfrmAgendamentoServ.FormShow(Sender: TObject);
begin

  EdtNroAgen.Text := IntToStr(idAgendamento);

     calcularTotal;
     desabilitarCampos;
     dm.tb_agendamentoserv.Active := true;
     carregarCombobox;
     cbServicos.itemIndex := 0;
     listarServicos;
end;

procedure TfrmAgendamentoServ.habilitarCampos;
begin
    EdtDesconto.Enabled := true;
    cbServicos.Enabled := true;
end;

procedure TfrmAgendamentoServ.limpar;
begin

end;

procedure TfrmAgendamentoServ.listarServicos;
begin

  dm.query_agendamentopagto.sql.Clear;
  dm.query_agendamentopagto.sql.add('select * from agendamento_servicos where idagendamento = :idAg');
  dm.query_agendamentopagto.ParamByName('idAg').AsInteger := idAgendamento;
  dm.query_agendamentopagto.Open();

end;

end.
