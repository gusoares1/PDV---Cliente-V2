unit Agendamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Buttons, Vcl.StdCtrls, Vcl.WinXPickers, Vcl.ComCtrls, IdHTTP, IdSSLOpenSSL, System.JSON,
  Vcl.Samples.Spin, Vcl.ExtCtrls,DateUtils;

type
  TfrmAgendamento = class(TForm)
    Label2: TLabel;
    EdtCliente: TEdit;
    btnBuscarFuncionario: TSpeedButton;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    DBGrid1: TDBGrid;
    DateAgendamento: TDateTimePicker;
    TimeAgendamento: TTimePicker;
    Label1: TLabel;
    EdtFuncionario: TEdit;
    btnBuscarCliente: TSpeedButton;
    EdtDescricao: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpinHorasTrabalhadas: TSpinEdit;
    Label7: TLabel;
    Button1: TButton;
    Label3: TLabel;
    btnPagamento: TButton;
    ChkAtivar: TCheckBox;
    procedure btnBuscarClienteClick(Sender: TObject);
    procedure btnBuscarFuncionarioClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1DblClick(Sender: TObject);

    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPagamentoClick(Sender: TObject);
  private
   procedure limpar;
    procedure habilitarCampos;
    procedure desabilitarCampos;
    procedure associarCampos;
  public
   procedure filtrarAgendamentos(cliente, funcionario: string; data: TDate; usarData: Boolean);
   procedure listar;
   procedure EnviarMensagemWhatsApp(const Numero, Mensagem: string);
  end;

var
  frmAgendamento: TfrmAgendamento;
  id: Integer;
  idSelecionado: Integer;

implementation

{$R *.dfm}

uses Cliente, Funcionario, Modulo, Vincular_Servicos, Filtrar, pagto_agend;

procedure TfrmAgendamento.associarCampos;
begin
  dm.tb_agendamento.FieldByName('cliente').value :=EdtCliente.Text;
  dm.tb_agendamento.FieldByName('funcionario').value :=EdtFuncionario.Text;
  dm.tb_agendamento.FieldByName('data').value :=DateAgendamento.date;
  dm.tb_agendamento.FieldByName('hora').value :=TimeAgendamento.time;
  dm.tb_agendamento.FieldByName('Descricao').value :=EdtDescricao.text;
  dm.tb_agendamento.FieldByName('horas_trabalhadas').AsInteger := SpinHorasTrabalhadas.Value;
  dm.tb_agendamento.FieldByName('ConfirmacaoCliente').AsInteger := 0;
  dm.tb_agendamento.FieldByName('Realizado').AsInteger := 0;

end;

procedure TfrmAgendamento.btnBuscarClienteClick(Sender: TObject);
begin
  chamada2 :='Cliente';
  FrmCliente := TFrmCliente.Create(self);
  FrmCliente.Show;
end;

procedure TfrmAgendamento.btnBuscarFuncionarioClick(Sender: TObject);
begin
  chamada :='func';
  FrmFuncionarios := TFrmFuncionarios.Create(self);
  FrmFuncionarios.Show;
end;

procedure TfrmAgendamento.btnEditarClick(Sender: TObject);
begin
  // Verifica se já existe outro agendamento com essa data/hora
  dm.query_agendamentos.Close;
  dm.query_agendamentos.SQL.Clear;
  dm.query_agendamentos.SQL.Text :=
    'SELECT * FROM agendamentos WHERE data = :data AND hora = :hora AND id <> :id';
  dm.query_agendamentos.ParamByName('data').AsDate := DateAgendamento.Date;
  dm.query_agendamentos.ParamByName('hora').AsTime := TimeAgendamento.Time;
  dm.query_agendamentos.ParamByName('id').AsInteger := id;
  dm.query_agendamentos.Open;

  if not dm.query_agendamentos.IsEmpty then
  begin
    MessageDlg('Já existe um agendamento para essa data e horário.', mtWarning, [mbOK], 0);
    Exit;
  end;

  // Realiza o UPDATE
  dm.query_agendamentos.Close;
  dm.query_agendamentos.SQL.Clear;
  dm.query_agendamentos.SQL.add(
            'UPDATE agendamentos '+
            'SET cliente = :cliente, funcionario = :funcionario, descricao = :descricao,' +
            'data = :data, hora = :hora, horas_trabalhadas = :horas_trabalhadas , ConfirmacaoCliente = :ConfirmacaoCliente  '+
            'WHERE id = :id'
            );

  dm.query_agendamentos.ParamByName('cliente').AsString := EdtCliente.Text;
  dm.query_agendamentos.ParamByName('funcionario').AsString := EdtFuncionario.Text;
  dm.query_agendamentos.ParamByName('descricao').AsString := EdtDescricao.Text;
  dm.query_agendamentos.ParamByName('data').AsDate := DateAgendamento.Date;
  dm.query_agendamentos.ParamByName('hora').AsTime := TimeAgendamento.Time;
  dm.query_agendamentos.ParamByName('horas_trabalhadas').AsInteger := SpinHorasTrabalhadas.Value;
  dm.query_agendamentos.ParamByName('id').AsInteger := id;
  dm.query_agendamentos.ParamByName('ConfirmacaoCliente').AsBoolean := ChkAtivar.Checked;

  dm.query_agendamentos.ExecSQL;

  btnEditar.Enabled := false;
  btnExcluir.Enabled := false;
  MessageDlg('Editado com sucesso!', mtInformation, [mbOK], 0);
  limpar;
  desabilitarCampos;
  listar;
end;

procedure TfrmAgendamento.btnExcluirClick(Sender: TObject);
begin
  if MessageDlg('Deseja Excluir o registro?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
    begin
      associarCampos;
      dm.query_usuarios.close;
      dm.query_usuarios.sql.Clear;
      dm.query_usuarios.sql.add('DELETE FROM agendamentos WHERE id = :id');
      dm.query_usuarios.ParamByName('id').Value := id;
      dm.query_usuarios.ExecSQL;
      MessageDlg('Deletado com sucesso', TMsgDlgType.mtInformation, mbOKCancel, 0);
      btnEditar.Enabled := false;
      btnExcluir.Enabled := false;
      limpar;
      listar;

    end;
end;



procedure TfrmAgendamento.btnNovoClick(Sender: TObject);
begin
  habilitarCampos;
  dm.tb_agendamento.Insert;
  btnSalvar.Enabled := true;
  btnEditar.Enabled := false;
  btnExcluir.Enabled := false;
  limpar;

  TimeAgendamento.Time := Time; // define hora atual do PC
  DateAgendamento.time := time;
  SpinHorasTrabalhadas.Value := 0;
end;

procedure TfrmAgendamento.btnPagamentoClick(Sender: TObject);
begin
  if not dm.query_agendamentos.IsEmpty then
  begin
    idAgendamento := dm.query_agendamentos.FieldByName('id').AsInteger;
    Application.CreateForm(TfrmPagtoAgendamento, frmPagtoAgendamento);
    idAgendamento := idSelecionado;
    frmPagtoAgendamento.ShowModal;
  end;
end;

procedure TfrmAgendamento.btnSalvarClick(Sender: TObject);
var
  Mensagem: string;
  HoraInicioNova, HoraFinalNova: TTime;
  DuracaoHoras: Integer;
begin
  try
    if Trim(EdtCliente.Text) = '' then
      raise Exception.Create('Preencha o Cliente.');

    if Trim(EdtFuncionario.Text) = '' then
      raise Exception.Create('Preencha o Funcionário.');

    // Cálculo da hora inicial e final do novo agendamento
    HoraInicioNova := StrToTime(FormatDateTime('hh:nn', TimeAgendamento.Time));
    DuracaoHoras := SpinHorasTrabalhadas.Value;
    HoraFinalNova := IncHour(HoraInicioNova, DuracaoHoras);

    // Validação de sobreposição de horários
    dm.query_agendamentos.Close;
    dm.query_agendamentos.SQL.Clear;
    dm.query_agendamentos.SQL.Text :=
      'SELECT * FROM agendamentos ' +
      'WHERE data = :data AND funcionario = :funcionario ' +
      'AND (hora < :HoraFinalNova) ' +
      'AND (ADDTIME(hora, SEC_TO_TIME(horas_trabalhadas * 3600)) > :HoraInicioNova)';

    dm.query_agendamentos.ParamByName('data').AsDate := DateAgendamento.Date;
    dm.query_agendamentos.ParamByName('funcionario').AsString := EdtFuncionario.Text;
    dm.query_agendamentos.ParamByName('HoraInicioNova').AsTime := HoraInicioNova;
    dm.query_agendamentos.ParamByName('HoraFinalNova').AsTime := HoraFinalNova;
    dm.query_agendamentos.Open;

    if not dm.query_agendamentos.IsEmpty then
      raise Exception.Create('Já existe um agendamento nesse intervalo de tempo para esse funcionário.');

    // Salva
    associarCampos;
    dm.tb_agendamento.Post;

    MessageDlg('Salvo com sucesso!', mtInformation, [mbOK], 0);

    limpar;
    btnSalvar.Enabled := false;
    desabilitarCampos;
    listar;

    // Enviar WhatsApp Cliente
    if (telefoneFunc <> '') and (nomeCliente <> '') and (nomeFunc <> '') then
    begin
      Mensagem := Format('Olá %s! Seu agendamento está confirmado para %s às %s com %s.',
        [nomeCliente,
         FormatDateTime('dd/mm/yyyy', DateAgendamento.Date),
         FormatDateTime('hh:nn', TimeAgendamento.Time),
         nomeFunc]);

      EnviarMensagemWhatsApp(telefoneCliente, Mensagem);
    end;

    if (telefoneCliente <> '') and (nomeCliente <> '') and (nomeFunc <> '') then
    begin
      Mensagem := Format('Olá %s! Você tem um serviço agendado para %s às %s com Cliente %s.',
        [nomeFunc,
         FormatDateTime('dd/mm/yyyy', DateAgendamento.Date),
         FormatDateTime('hh:nn', TimeAgendamento.Time),
         nomeCliente]);

      EnviarMensagemWhatsApp(telefoneFunc, Mensagem);
    end;

  except
    on E: Exception do
      MessageDlg('Erro: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmAgendamento.Button1Click(Sender: TObject);
begin
  if FrmFiltroAgendamento = nil then
    Application.CreateForm(TFrmFiltroAgendamento, FrmFiltroAgendamento);

  if FrmFiltroAgendamento.ShowModal = mrOk then
  begin
    filtrarAgendamentos(
      FrmFiltroAgendamento.EdtClienteFiltro.Text,
      FrmFiltroAgendamento.EdtFuncionarioFiltro.Text,
      FrmFiltroAgendamento.DateFiltro.Date,
      FrmFiltroAgendamento.ChkUsarData.Checked
    );
  end;
end;

procedure TfrmAgendamento.DBGrid1CellClick(Column: TColumn);
begin
  try
    // Habilita edição apenas se for o campo "Realizado"
    if (Column.Field.FieldName = 'ConfirmacaoCliente') then
    begin
      if not (dm.query_agendamentos.State in [dsEdit, dsInsert]) then
        dm.query_agendamentos.Edit;

      // Tenta alterar o valor usando tratamento numérico
      if Column.Field.AsInteger = 1 then
        Column.Field.AsInteger := 0
      else
        Column.Field.AsInteger := 1;
    end;

    // Restante do código existente...
    habilitarCampos;
    btnEditar.Enabled := true;
    btnExcluir.Enabled := true;
    btnPagamento.Enabled := true;

    dm.tb_agendamento.Edit;
    id := dm.query_agendamentos.FieldByName('id').AsInteger;
    idSelecionado := id;

    EdtCliente.Text := dm.query_agendamentos.FieldByName('cliente').AsString;
    EdtFuncionario.Text := dm.query_agendamentos.FieldByName('funcionario').AsString;
    EdtDescricao.Text := dm.query_agendamentos.FieldByName('descricao').AsString;
    DateAgendamento.Date := dm.query_agendamentos.FieldByName('data').AsDateTime;
    TimeAgendamento.Time := dm.query_agendamentos.FieldByName('hora').AsDateTime;
    SpinHorasTrabalhadas.Value := dm.query_agendamentos.FieldByName('horas_trabalhadas').AsInteger;

  except
    on E: Exception do
    begin
      if E.Message.Contains('Realizado') then
        MessageDlg('Não é possível alterar', mtError, [mbOK], 0)
      else
        MessageDlg('Erro: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;
procedure TfrmAgendamento.DBGrid1DblClick(Sender: TObject);


begin
  if not dm.query_agendamentos.IsEmpty then
  begin
    idSelecionado := dm.query_agendamentos.FieldByName('id').AsInteger;
    Application.CreateForm(TfrmAgendamentoServ, frmAgendamentoServ);
    idAgendamento := idSelecionado;
    frmAgendamentoServ.ShowModal;
  end;
end;

procedure TfrmAgendamento.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  CheckBoxState: Integer;
  Field: TField;
begin
  if (Column.Field.FieldName = 'ConfirmacaoCliente') or
     (Column.Field.FieldName = 'Realizado') then
  begin
    DBGrid1.Canvas.FillRect(Rect);
    Field := Column.Field;
    if Field.AsInteger = 1 then
      CheckBoxState := DFCS_CHECKED
    else
      CheckBoxState := DFCS_BUTTONCHECK;

    DrawFrameControl(DBGrid1.Canvas.Handle, Rect, DFC_BUTTON, CheckBoxState or DFCS_FLAT);
  end
  else
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfrmAgendamento.desabilitarCampos;
begin

    EdtCliente.Enabled := false;
    EdtFuncionario.Enabled := false;
    EdtDescricao.Enabled := false;
    btnBuscarFuncionario.Enabled := false;
    btnBuscarCliente.Enabled := false;
    btnPagamento.Enabled := false;

end;

 procedure TfrmAgendamento.EnviarMensagemWhatsApp(const Numero, Mensagem: string);
var
  Http: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  Json: TStringStream;
  URL, Token, NumeroFormatado, MensagemFormatada: string;
  Response: string;
begin
  // BUSCAR DO BANCO
  dm.query_config_whatsapp.SQL.Text := 'SELECT id ,client_token, api_url FROM config_whatsapp LIMIT 1';
  dm.query_config_whatsapp.Open;

  Token := dm.query_config_whatsapp.FieldByName('client_token').AsString;
  URL := dm.query_config_whatsapp.FieldByName('api_url').AsString;

  dm.query_config_whatsapp.Close;

  if (Trim(Token) = '') or (Trim(URL) = '') then
  begin
    ShowMessage('Configurações do WhatsApp não encontradas.');
    Exit;
  end;

  Http := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Json := nil;

  try
    SSL.SSLOptions.Method := sslvTLSv1_2;
    Http.IOHandler := SSL;

    Http.Request.UserAgent := 'Mozilla/5.0';
    Http.Request.ContentType := 'application/json';
    Http.Request.CustomHeaders.AddValue('Client-Token', Token);
    Http.Request.CustomHeaders.AddValue('Accept', '*/*');

    NumeroFormatado := Numero.Replace(' ', '')
                             .Replace('+', '')
                             .Replace('-', '')
                             .Replace('(', '')
                             .Replace(')', '');

    if not NumeroFormatado.StartsWith('55') then
      NumeroFormatado := '55' + NumeroFormatado;

    Json := TStringStream.Create(
      Format('{"phone": "%s", "message": "%s"}', [NumeroFormatado, Mensagem]),
      TEncoding.UTF8
    );
     // try
      //  Log detalhado
      //ShowMessage(
        //'=== DETALHES DA REQUISIÇÃO ===' + #13#10 +
       //'URL: ' + URL + #13#10 +
       // 'Headers:' + #13#10 +
       //'Client-Token: ' + Http.Request.CustomHeaders.Values['Client-Token'] + #13#10 +
        //'Content-Type: ' + Http.Request.ContentType + #13#10 +
        //'Accept: ' + Http.Request.CustomHeaders.Values['Accept'] + #13#10 +
        //'Body:' + #13#10 +
        //'{"phone": "' + NumeroFormatado + '", "message": "' + Mensagem + '"}' + #13#10 +
       //'=========================='
      //);

      // Tenta fazer a requisição
     // Response := Http.Post(URL, Json);

     // ShowMessage('Resposta do servidor: ' + Response);

     // finally

    //  end;

    Response := Http.Post(URL, Json);
    ShowMessage('Resposta do servidor: ' + Response);
  except
    on E: EIdHTTPProtocolException do
      ShowMessage('Erro HTTP: ' + E.Message + ' | Código: ' + IntToStr(E.ErrorCode));
    on E: Exception do
      ShowMessage('Erro geral: ' + E.Message);
  end;

  Json.Free;
  Http.Free;
  SSL.Free;
end;


procedure TfrmAgendamento.filtrarAgendamentos(cliente, funcionario: string; data: TDate; usarData: Boolean);
var
  sqlBase: string;
begin
  dm.query_agendamentos.Close;
  sqlBase := 'SELECT * FROM agendamentos WHERE 1=1';

  if Trim(cliente) <> '' then
    sqlBase := sqlBase + ' AND cliente LIKE :cliente';

  if Trim(funcionario) <> '' then
    sqlBase := sqlBase + ' AND funcionario LIKE :funcionario';

  if usarData then
    sqlBase := sqlBase + ' AND data = :data';

  dm.query_agendamentos.SQL.Text := sqlBase;

  if Pos(':cliente', sqlBase) > 0 then
    dm.query_agendamentos.ParamByName('cliente').Value := cliente + '%';

  if Pos(':funcionario', sqlBase) > 0 then
    dm.query_agendamentos.ParamByName('funcionario').Value := funcionario + '%';

  if usarData then
    dm.query_agendamentos.ParamByName('data').AsDate := data;

  dm.query_agendamentos.Open;
end;

procedure TfrmAgendamento.FormActivate(Sender: TObject);
begin
 EdtCliente.text := nomeCliente;
 EdtFuncionario.Text := nomeFunc;
end;

procedure TfrmAgendamento.FormCreate(Sender: TObject);
begin
  DateAgendamento.DateTime := Now; // Define a data/hora inicial

  SpinHorasTrabalhadas.MinValue := 1;
  SpinHorasTrabalhadas.MaxValue := 24;
end;

procedure TfrmAgendamento.FormShow(Sender: TObject);
begin
     desabilitarCampos;
     dm.tb_agendamento.Active := true;
     listar;

     SpinHorasTrabalhadas.MinValue := 1;
     limpar;

end;

procedure TfrmAgendamento.habilitarCampos;
begin

    EdtDescricao.Enabled := true;
    btnBuscarFuncionario.Enabled := true;
    btnBuscarCliente.Enabled := true;

end;

procedure TfrmAgendamento.limpar;
begin

    EdtCliente.text := '';
    EdtFuncionario.text := '';
    EdtDescricao.text := '';

end;

procedure TfrmAgendamento.listar;
begin
  dm.query_agendamentos.sql.Clear;
  dm.query_agendamentos.sql.add('select * from agendamentos');
  dm.query_agendamentos.Open();

end;

end.
