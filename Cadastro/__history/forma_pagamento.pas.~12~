unit forma_pagamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls;

type
  TFrmFormaPgto = class(TForm)
    Label2: TLabel;
    EdtNome: TEdit;
    DBGrid1: TDBGrid;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    ChkAtivar: TCheckBox;
    ChkParcelar: TCheckBox;
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btnEditarClick(Sender: TObject);
  private
    { Private declarations }
    procedure associarCampos;
    procedure listar;
    function validarCampos: Boolean;
  public
    { Public declarations }
  end;

var
  FrmFormaPgto: TFrmFormaPgto;
  idFormaPgto: Integer;

implementation

{$R *.dfm}

uses Modulo;

procedure TFrmFormaPgto.associarCampos;
begin
  dm.tb_formapagto.FieldByName('nome').Value := EdtNome.Text;
  dm.tb_formapagto.FieldByName('parcela').AsBoolean := ChkParcelar.Checked; // Mapeia BIT para CheckBox
  dm.tb_formapagto.FieldByName('ativo').AsBoolean := ChkAtivar.Checked;
end;

procedure TFrmFormaPgto.btnEditarClick(Sender: TObject);
var
  nomeAtual: string;
begin
  if not validarCampos then Exit;

  // Verificar duplicidade
  dm.query_formapagto.Close;
  dm.query_formapagto.SQL.Text :=
    'SELECT * FROM forma_pagamento WHERE nome = :nome AND idFormaPagamento <> :id';
  dm.query_formapagto.ParamByName('nome').Value := Trim(EdtNome.Text);
  dm.query_formapagto.ParamByName('id').Value := idFormaPgto;
  dm.query_formapagto.Open;

  if not dm.query_formapagto.IsEmpty then
  begin
    nomeAtual := dm.query_formapagto.FieldByName('nome').AsString;
    MessageDlg('A forma de pagamento "' + nomeAtual + '" já está cadastrada!',
      mtWarning, [mbOK], 0);
    Exit;
  end;

  // Atualizar registro
  dm.query_formapagto.Close;
  dm.query_formapagto.SQL.Text :=
    'UPDATE forma_pagamento SET ' +
    'nome = :nome, parcela = :parcela, ativo = :ativo ' +
    'WHERE idFormaPagamento = :id';

  dm.query_formapagto.ParamByName('nome').Value := EdtNome.Text;
  dm.query_formapagto.ParamByName('parcela').AsBoolean := ChkParcelar.Checked;
  dm.query_formapagto.ParamByName('ativo').AsBoolean := ChkAtivar.Checked;
  dm.query_formapagto.ParamByName('id').Value := idFormaPgto;

  dm.query_formapagto.ExecSQL;

  MessageDlg('Registro atualizado com sucesso!', mtInformation, [mbOK], 0);
  listar;
  btnEditar.Enabled := False;
  EdtNome.Clear;
end;

procedure TFrmFormaPgto.btnNovoClick(Sender: TObject);
begin
  EdtNome.Clear;
  ChkAtivar.Checked := True;  // Default ativo
  ChkParcelar.Checked := False;
  EdtNome.Enabled := True;
  btnSalvar.Enabled := True;
  btnEditar.Enabled := False;
  EdtNome.SetFocus;
end;

procedure TFrmFormaPgto.btnSalvarClick(Sender: TObject);
begin
  if not validarCampos then Exit;

  // Verificar duplicidade
  dm.query_formapagto.Close;
  dm.query_formapagto.SQL.Text := 'SELECT * FROM forma_pagamento WHERE nome = :nome';
  dm.query_formapagto.ParamByName('nome').Value := Trim(EdtNome.Text);
  dm.query_formapagto.Open;

  if not dm.query_formapagto.IsEmpty then
  begin
    MessageDlg('Esta forma de pagamento já está cadastrada!', mtWarning, [mbOK], 0);
    Exit;
  end;

  // Inserir novo registro
  dm.tb_formapagto.Insert;
  associarCampos;
  dm.tb_formapagto.Post;

  MessageDlg('Forma de pagamento cadastrada com sucesso!', mtInformation, [mbOK], 0);
  listar;
  btnSalvar.Enabled := False;
  EdtNome.Clear;
end;

procedure TFrmFormaPgto.DBGrid1CellClick(Column: TColumn);
begin
  if dm.tb_formapagto.IsEmpty then Exit;

  idFormaPgto := dm.tb_formapagto.FieldByName('idFormaPagamento').AsInteger;
  EdtNome.Text := dm.tb_formapagto.FieldByName('nome').AsString;
  ChkParcelar.Checked := dm.tb_formapagto.FieldByName('parcela').AsBoolean;
  ChkAtivar.Checked := dm.tb_formapagto.FieldByName('ativo').AsBoolean;

  btnEditar.Enabled := True;
  btnSalvar.Enabled := False;
end;

procedure TFrmFormaPgto.FormCreate(Sender: TObject);
begin
  dm.tb_formapagto.Active := True;
  listar;
end;

procedure TFrmFormaPgto.listar;
begin
  dm.query_formapagto.Close;
  dm.query_formapagto.SQL.Text :=
    'SELECT idFormaPagamento, nome, parcela, ativo ' +
    'FROM forma_pagamento ORDER BY nome';
  dm.query_formapagto.Open;
end;

function TFrmFormaPgto.validarCampos: Boolean;
begin
  Result := False;

  if Trim(EdtNome.Text) = '' then
  begin
    MessageDlg('Informe o nome da forma de pagamento!', mtWarning, [mbOK], 0);
    EdtNome.SetFocus;
    Exit;
  end;

  Result := True;
end;

end.
