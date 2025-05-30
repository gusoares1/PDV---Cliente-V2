unit Fornecedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.Mask, Vcl.StdCtrls;

type
  TFrmFornecedores = class(TForm)
    EdtBuscarNome: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdtNome: TEdit;
    Label4: TLabel;
    EdtTel: TMaskEdit;
    Label5: TLabel;
    EdtEndereco: TEdit;
    DBGrid1: TDBGrid;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    BtnEditar: TSpeedButton;
    BtnExcluir: TSpeedButton;
    Label3: TLabel;
    edtProduto: TEdit;
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure BtnExcluirClick(Sender: TObject);
    procedure EdtBuscarNomeChange(Sender: TObject);
  private
    { Private declarations }
      procedure limpar;
      procedure habilitarCampos;
      procedure desabilitarCampos;

      procedure associarCampos;
      procedure listar;


      procedure buscarNome;
  public
    { Public declarations }
  end;

var
  FrmFornecedores: TFrmFornecedores;
   id : string;
implementation

{$R *.dfm}

uses Modulo;

{ TFrmFornecedores }

procedure TFrmFornecedores.associarCampos;
begin
   dm.tb_fornecedor.FieldByName('nome').Value := edtNome.Text;
   dm.tb_fornecedor.FieldByName('produto').Value := edtProduto.Text;
   dm.tb_fornecedor.FieldByName('telefone').Value := edtTel.Text;
   dm.tb_fornecedor.FieldByName('endereco').Value := EdtEndereco.Text;

   dm.tb_fornecedor.FieldByName('data').Value := DateToStr(Date);
end;

procedure TFrmFornecedores.BtnEditarClick(Sender: TObject);
begin
  if Trim(EdtNome.Text) = '' then
       begin
           MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
           EdtNome.SetFocus;
           exit;
       end;


       associarCampos;
       dm.query_fornecedores.Close;
       dm.query_fornecedores.SQL.Clear;
       dm.query_fornecedores.SQL.Add('UPDATE fornecedores set nome = :nome, produto = :produto, endereco = :endereco, telefone = :telefone where id = :id');
       dm.query_fornecedores.ParamByName('nome').Value := edtNome.Text;
       dm.query_fornecedores.ParamByName('produto').Value := edtProduto.Text;
       dm.query_fornecedores.ParamByName('endereco').Value := EdtEndereco.Text;
       dm.query_fornecedores.ParamByName('telefone').Value := edtTel.Text;

       dm.query_fornecedores.ParamByName('id').Value := id;
       dm.query_fornecedores.ExecSQL;


       listar;
       MessageDlg('Editado com Sucesso!!', mtInformation, mbOKCancel, 0);
       btnEditar.Enabled := false;
       BtnExcluir.Enabled := false;
       limpar;
       desabilitarCampos;
end;

procedure TFrmFornecedores.BtnExcluirClick(Sender: TObject);
begin
if MessageDlg('Deseja Excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
begin
  dm.tb_fornecedor.Delete;
    MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);


     btnEditar.Enabled := false;
     BtnExcluir.Enabled := false;
     edtNome.Text := '';
     listar;
end;
end;

procedure TFrmFornecedores.btnNovoClick(Sender: TObject);
begin
  habilitarCampos;
  dm.tb_fornecedor.Insert;
  btnSalvar.Enabled := true;
  btnEditar.Enabled := False;
  btnExcluir.Enabled := False;
end;

procedure TFrmFornecedores.btnSalvarClick(Sender: TObject);
begin
       if Trim(EdtNome.Text) = '' then
       begin
           MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
           EdtNome.SetFocus;
           exit;
       end;



        associarCampos;
        dm.tb_fornecedor.Post;
        MessageDlg('Salvo com Sucesso', mtInformation, mbOKCancel, 0);
        limpar;
        desabilitarCampos;
        btnSalvar.Enabled := false;
        listar;

end;

procedure TFrmFornecedores.buscarNome;
begin
       dm.query_fornecedores.Close;
       dm.query_fornecedores.SQL.Clear;
       dm.query_fornecedores.SQL.Add('SELECT * from fornecedores where nome LIKE :nome order by nome asc');
       dm.query_fornecedores.ParamByName('nome').Value := EdtBuscarNome.Text + '%';
       dm.query_fornecedores.Open;
end;

procedure TFrmFornecedores.DBGrid1CellClick(Column: TColumn);
begin
habilitarCampos;
  btnEditar.Enabled := true;
  btnExcluir.Enabled := true;

  dm.tb_fornecedor.Edit;


  edtNome.Text := dm.query_fornecedores.FieldByName('nome').Value;

  edtProduto.Text := dm.query_fornecedores.FieldByName('produto').Value;

  if dm.query_fornecedores.FieldByName('telefone').Value <> null then
  edtTel.Text := dm.query_fornecedores.FieldByName('telefone').Value;

  if dm.query_fornecedores.FieldByName('endereco').Value <> null then
  EdtEndereco.Text := dm.query_fornecedores.FieldByName('endereco').Value;

  id := dm.query_fornecedores.FieldByName('id').Value;

end;

procedure TFrmFornecedores.desabilitarCampos;
begin
  edtNome.Enabled := false;
  edtProduto.Enabled := false;
  EdtEndereco.Enabled := false;
  EdtTel.Enabled := false;

end;

procedure TFrmFornecedores.EdtBuscarNomeChange(Sender: TObject);
begin
buscarNome;
end;

procedure TFrmFornecedores.FormShow(Sender: TObject);
begin
desabilitarCampos;
  dm.tb_fornecedor.Active := true;
  listar;
end;

procedure TFrmFornecedores.habilitarCampos;
begin
 edtNome.Enabled := true;
  edtProduto.Enabled := true;
  EdtEndereco.Enabled := true;
  EdtTel.Enabled := true;
end;

procedure TFrmFornecedores.limpar;
begin
 edtNome.Text := '';
  edtProduto.Text := '';
  EdtEndereco.Text := '';
  EdtTel.Text := '';
end;

procedure TFrmFornecedores.listar;
begin
       dm.query_fornecedores.Close;
       dm.query_fornecedores.SQL.Clear;
       dm.query_fornecedores.SQL.Add('SELECT * from fornecedores order by nome asc');
       dm.query_fornecedores.Open;
end;

end.
