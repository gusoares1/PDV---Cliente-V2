unit Fornecedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.Mask, Vcl.StdCtrls;

type
  TFrmCategoriaGastos = class(TForm)
    EdtBuscarNome: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdtNome: TEdit;
    DBGrid1: TDBGrid;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    BtnEditar: TSpeedButton;
    BtnExcluir: TSpeedButton;
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
  FrmCategoriaGastos: TFrmCategoriaGastos;
   id : string;
implementation

{$R *.dfm}

uses Modulo;

{ TFrmFornecedores }

procedure TFrmCategoriaGastos.associarCampos;
begin
   dm.tb_fornecedor.FieldByName('nome_categoria').Value := edtNome.Text;

end;

procedure TFrmCategoriaGastos.BtnEditarClick(Sender: TObject);
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
       dm.query_fornecedores.SQL.Add('UPDATE categorias_gasto set nome_categoria = :nome_categoria where id_categoria = :id_categoria');
       dm.query_fornecedores.ParamByName('nome').Value := edtNome.Text;

       dm.query_fornecedores.ParamByName('id_categoria').Value := id;
       dm.query_fornecedores.ExecSQL;


       listar;
       MessageDlg('Editado com Sucesso!!', mtInformation, mbOKCancel, 0);
       btnEditar.Enabled := false;
       BtnExcluir.Enabled := false;
       limpar;
       desabilitarCampos;
end;

procedure TFrmCategoriaGastos.BtnExcluirClick(Sender: TObject);
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

procedure TFrmCategoriaGastos.btnNovoClick(Sender: TObject);
begin
  habilitarCampos;
  dm.tb_fornecedor.Insert;
  btnSalvar.Enabled := true;
  btnEditar.Enabled := False;
  btnExcluir.Enabled := False;
end;

procedure TFrmCategoriaGastos.btnSalvarClick(Sender: TObject);
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

procedure TFrmCategoriaGastos.buscarNome;
begin
       dm.query_fornecedores.Close;
       dm.query_fornecedores.SQL.Clear;
       dm.query_fornecedores.SQL.Add('SELECT * from categorias_gasto where nome_categoria LIKE :nome_categoria order by nome_categoria asc');
       dm.query_fornecedores.ParamByName('nome_categoria').Value := EdtBuscarNome.Text + '%';
       dm.query_fornecedores.Open;
end;

procedure TFrmCategoriaGastos.DBGrid1CellClick(Column: TColumn);
begin
habilitarCampos;
  btnEditar.Enabled := true;
  btnExcluir.Enabled := true;

  dm.tb_fornecedor.Edit;


  edtNome.Text := dm.query_fornecedores.FieldByName('nome_categoria').Value;



  id := dm.query_fornecedores.FieldByName('id_categoria').Value;

end;

procedure TFrmCategoriaGastos.desabilitarCampos;
begin
  edtNome.Enabled := false;


end;

procedure TFrmCategoriaGastos.EdtBuscarNomeChange(Sender: TObject);
begin
buscarNome;
end;

procedure TFrmCategoriaGastos.FormShow(Sender: TObject);
begin
desabilitarCampos;
  dm.tb_fornecedor.Active := true;
  listar;
end;

procedure TFrmCategoriaGastos.habilitarCampos;
begin
 edtNome.Enabled := true;

end;

procedure TFrmCategoriaGastos.limpar;
begin
 edtNome.Text := '';

end;

procedure TFrmCategoriaGastos.listar;
begin
       dm.query_fornecedores.Close;
       dm.query_fornecedores.SQL.Clear;
       dm.query_fornecedores.SQL.Add('SELECT * from categorias_gasto order by nome_categoria asc');
       dm.query_fornecedores.Open;
end;

end.
