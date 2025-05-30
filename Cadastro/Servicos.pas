unit Servicos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmServico = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EdtServico: TEdit;
    EdtDescricao: TEdit;
    edtpreco: TEdit;
    EdtBuscarNome: TEdit;
    DBGrid1: TDBGrid;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure edtprecoKeyPress(Sender: TObject; var Key: Char);
  private
    procedure associarCampos;
    procedure listar;
  public
  end;

var
  FrmServico: TFrmServico;
  id: string;

implementation

{$R *.dfm}

uses Modulo;

procedure TFrmServico.associarCampos;
begin
  dm.tb_servicos.FieldByName('nome').Value := EdtServico.Text;
  dm.tb_servicos.FieldByName('descricao').Value := EdtDescricao.Text;
  dm.tb_servicos.FieldByName('preco').Value := edtpreco.Text;
end;

procedure TFrmServico.btnNovoClick(Sender: TObject);
begin
    if dm.tb_servicos.State in [dsEdit] then
    dm.tb_servicos.Cancel;
  btnSalvar.Enabled := True;

  EdtServico.Enabled := True;
  EdtDescricao.Enabled := True;
  edtpreco.Enabled := True;

  EdtServico.text := '';
  EdtDescricao.text := '';
  edtpreco.text := '';

  EdtServico.SetFocus;
  dm.tb_servicos.Insert;

  btnEditar.Enabled := False;
  btnExcluir.Enabled := False;

end;

procedure TFrmServico.btnSalvarClick(Sender: TObject);
begin
  if Trim(EdtServico.Text) = '' then
  begin
    MessageDlg('Preencha o Nome do Serviço', mtInformation, [mbOK], 0);
    EdtServico.SetFocus;
    Exit;
  end;

  dm.query_servicos.SQL.Clear;
  dm.query_servicos.SQL.Add('SELECT * FROM servico WHERE nome = ' + QuotedStr(Trim(EdtServico.Text)));
  dm.query_servicos.Open;

  if not dm.query_servicos.IsEmpty then
  begin
    MessageDlg('O serviço "' + EdtServico.Text + '" já está cadastrado.', mtInformation, [mbOK], 0);
    Exit;
  end;

  associarCampos;
  dm.tb_servicos.Post;

  MessageDlg('Salvo com sucesso.', mtInformation, [mbOK], 0);

  EdtServico.Clear;
  EdtDescricao.Clear;
  edtpreco.Clear;
  btnSalvar.Enabled := False;
  listar;
end;

procedure TFrmServico.btnEditarClick(Sender: TObject);
begin
  associarCampos;
  dm.tb_servicos.Post;
  MessageDlg('Editado com sucesso.', mtInformation, [mbOK], 0);
  listar;
end;

procedure TFrmServico.btnExcluirClick(Sender: TObject);
begin
    if MessageDlg('Deseja Excluir o registro?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
    begin
      associarCampos;
      dm.query_servicos.close;
      dm.query_servicos.sql.Clear;
      dm.query_servicos.sql.add('DELETE FROM servico WHERE id = :id');
      dm.query_servicos.ParamByName('id').Value := id;
      dm.query_servicos.ExecSQL;
      MessageDlg('Deletado com sucesso', TMsgDlgType.mtInformation, mbOKCancel, 0);
      btnEditar.Enabled := false;
      btnExcluir.Enabled := false;
      EdtServico.Text := '';
      edtpreco.Text := '';
      EdtDescricao.Text := '';
      listar;

    end;

end;

procedure TFrmServico.DBGrid1CellClick(Column: TColumn);
begin
    // Cancela a inserção se estiver em modo Insert
  if dm.tb_servicos.State in [dsInsert] then
    dm.tb_servicos.Cancel;

  EdtServico.Text := dm.query_servicos.FieldByName('nome').AsString;
  EdtDescricao.Text := dm.query_servicos.FieldByName('descricao').AsString;
  edtpreco.Text := dm.query_servicos.FieldByName('preco').AsString;
  id := dm.query_servicos.FieldByName('id').AsString;

  btnEditar.Enabled := True;
  btnExcluir.Enabled := True;

  dm.tb_servicos.Edit;

  EdtServico.Enabled := True;
  EdtDescricao.Enabled := True;
  edtpreco.Enabled := True;

end;

procedure TFrmServico.edtprecoKeyPress(Sender: TObject; var Key: Char);
var
  texto: string;
  posVirgula: Integer;
begin
  // Permite números, vírgula e backspace
  if not (Key in ['0'..'9', ',', #8]) then
  begin
    Key := #0;
    Exit;
  end;

  texto := TEdit(Sender).Text;

  // Impede mais de uma vírgula
  if (Key = ',') and (Pos(',', texto) > 0) then
  begin
    Key := #0;
    Exit;
  end;

  // Limita a 2 casas decimais após a vírgula
  posVirgula := Pos(',', texto);
  if (posVirgula > 0) and (tedit(sender).SelStart > posVirgula) then
  begin
    if Length(Copy(texto, posVirgula + 1, Length(texto))) >= 2 then
      Key := #0;
  end;
end;

procedure TFrmServico.FormCreate(Sender: TObject);
begin
  dm.tb_servicos.Active := True;
  listar;
end;

procedure TFrmServico.listar;
begin
  dm.query_servicos.SQL.Clear;
  dm.query_servicos.SQL.Add('SELECT * FROM servico ORDER BY nome');
  dm.query_servicos.Open;
end;

end.
