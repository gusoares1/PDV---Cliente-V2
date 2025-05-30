unit Vincular_Servicos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids;

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

implementation

{$R *.dfm}

uses Modulo, Agendamento;


{ TfrmAgendamentoServ }

procedure TfrmAgendamentoServ.associarCampos;
begin

dm.tb_agendamentoserv.FieldByName('idAgendamento').AsInteger := StrToIntDef(EdtNroAgen.Text, 0);
dm.tb_agendamentoserv.FieldByName('preco').AsFloat := StrToFloatDef(EdtPreco.Text, 0);
dm.tb_agendamentoserv.FieldByName('desconto').AsFloat := StrToFloatDef(EdtDesconto.Text, 0);
dm.tb_agendamentoserv.FieldByName('nomeServico').AsString := cbServicos.Text;
dm.tb_agendamentoserv.FieldByName('seqServico').AsInteger := proxSeq;

end;


procedure TfrmAgendamentoServ.btnEditarClick(Sender: TObject);
var
  idAgendamento: Integer;
  seqServico: Integer;
begin
  try
    // Obter valores atuais do registro
  idAgendamento := dm.query_agendamentoserv.FieldByName('idAgendamento').AsInteger;
  seqServico := dm.query_agendamentoserv.FieldByName('seqServico').AsInteger;


    idAgendamento := dm.tb_agendamentoserv.FieldByName('idAgendamento').AsInteger;
  

   
  ShowMessage('idAgendamento: ' + IntToStr(idAgendamento) + sLineBreak +
            'seqServico: ' + IntToStr(seqServico));

    // Configurar query
    dm.query_agendamentoserv.Close;
    dm.query_agendamentoserv.SQL.Clear;
    dm.query_agendamentoserv.SQL.Add(
      'UPDATE agendamento_servicos ' +
      'SET nomeServico = :nomeServico, ' +
      '    desconto = :desconto, ' +
      '    preco = :preco ' +
      'WHERE idAgendamento = :idAgendamento and seqServico = :seqServico'
    );

    // Parâmetros com tipagem explícita
    dm.query_agendamentoserv.ParamByName('nomeServico').Value := cbServicos.Text;

    dm.query_agendamentoserv.ParamByName('desconto').Value := edtdesconto.Text;

    dm.query_agendamentoserv.ParamByName('preco').Value := edtpreco.Text;

    // Parâmetros do WHERE
    dm.query_agendamentoserv.ParamByName('idAgendamento').AsInteger := idAgendamento;

    dm.query_agendamentoserv.ParamByName('seqServico').AsInteger := seqServico;

    dm.query_agendamentoserv.ExecSQL;
 
      // Atualizar interface
      MessageDlg('Editado com sucesso!', mtInformation, [mbOK], 0);
      dm.tb_agendamentoserv.Refresh;  // Atualiza dataset
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
   //Busca o maior seqServico para esse agendamento
   dm.query_aux.Close;
   dm.query_aux.SQL.Clear;
   dm.query_aux.SQL.add ('SELECT MAX(seqServico) as seqServico FROM agendamento_servicos WHERE idAgendamento = :idAg');
   dm.query_aux.ParamByName('idAg').AsInteger := StrToInt(EdtNroAgen.Text);
   dm.query_aux.Open;

  // Define próximo valor
  if dm.query_aux.FieldByName('seqServico').IsNull then
    proxSeq := 1
  else
  proxSeq := dm.query_aux.FieldByName('seqServico').AsInteger + 1;

  dm.tb_agendamentoserv.Insert;
  associarCampos;
 // Garante que desconto seja salvo mesmo se campo estiver vazio
  if EdtDesconto.Text = '' then
    dm.tb_agendamentoserv.FieldByName('desconto').Clear
  else
    dm.tb_agendamentoserv.FieldByName('desconto').Value := StrToFloatDef(EdtDesconto.Text, 0);

  dm.tb_agendamentoserv.Post;
  
  messageDlg('Servico adicionado',mtInformation,mbOKCancel,0);
  limpar;
  desabilitarCampos;
  listarServicos;
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
begin

  {ShowMessage(
    'ID Agendamento: ' + dm.tb_agendamentoserv.FieldByName('idAgendamento').AsString + sLineBreak +
    'Seq Serviço: ' + dm.tb_agendamentoserv.FieldByName('seqServico').AsString
  ); }
     habilitarCampos;
     btnEditar.Enabled := true;
     btnExcluir.Enabled := true;
     dm.tb_agendamentoserv.Edit;

     EdtNroAgen.Text :=dm.query_agendamentoserv.FieldByName('idAgendamento').value;

     edtpreco.Text :=dm.query_agendamentoserv.FieldByName('preco').value;
     
if dm.query_agendamentoserv.FieldByName('Desconto').value <> null then
     EdtDesconto.Text :=dm.query_agendamentoserv.FieldByName('Desconto').value;

     cbServicos.Text := dm.query_agendamentoserv.FieldByName('nomeServico').value;
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
