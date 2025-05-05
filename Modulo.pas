unit Modulo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  Tdm = class(TDataModule)
    fd: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    tb_Cargos: TFDTable;
    query_cargos: TFDQuery;
    query_cargosid: TFDAutoIncField;
    query_cargoscargo: TStringField;
    DScargos: TDataSource;
    tb_funcionario: TFDTable;
    DSfuncionario: TDataSource;
    query_func: TFDQuery;
    query_funcid: TFDAutoIncField;
    query_funcnome: TStringField;
    query_funccpf: TStringField;
    query_functelefone: TStringField;
    query_funcendereco: TStringField;
    query_funccargo: TStringField;
    query_funcdata: TDateField;
    tb_funcionarioid: TFDAutoIncField;
    tb_funcionarionome: TStringField;
    tb_funcionariocpf: TStringField;
    tb_funcionariotelefone: TStringField;
    tb_funcionarioendereco: TStringField;
    tb_funcionariocargo: TStringField;
    tb_funcionariodata: TDateField;
    tb_usuario: TFDTable;
    query_usuarios: TFDQuery;
    DSusuarios: TDataSource;
    tb_usuarioid: TFDAutoIncField;
    tb_usuarionome: TStringField;
    tb_usuariousuario: TStringField;
    tb_usuariosenha: TStringField;
    tb_usuariocargo: TStringField;
    tb_usuarioid_funcionario: TIntegerField;
    query_usuariosnome: TStringField;
    query_usuariosusuario: TStringField;
    query_usuariossenha: TStringField;
    query_usuarioscargo: TStringField;
    query_usuariosid: TFDAutoIncField;
    query_usuariosid_funcionario: TIntegerField;
    tb_fornecedor: TFDTable;
    query_fornecedores: TFDQuery;
    DSFornecedores: TDataSource;
    query_fornecedoresid: TFDAutoIncField;
    query_fornecedoresnome: TStringField;
    query_fornecedoresproduto: TStringField;
    query_fornecedoresendereco: TStringField;
    query_fornecedoresdata: TDateField;
    query_fornecedorestelefone: TStringField;
    tb_agendamento: TFDTable;
    query_agendamentos: TFDQuery;
    DsAgendamento: TDataSource;
    tb_uf: TFDTable;
    query_uf: TFDQuery;
    DsUF: TDataSource;
    tb_municipio: TFDTable;
    query_municipio: TFDQuery;
    DsMunicipio: TDataSource;
    tb_cliente: TFDTable;
    query_cliente: TFDQuery;
    DsCliente: TDataSource;
    query_ufid: TIntegerField;
    query_ufnome: TStringField;
    query_ufsigla: TStringField;
    query_clienteid: TFDAutoIncField;
    query_clientenome: TStringField;
    query_clientedocumento: TStringField;
    query_clientedata_nascimento: TDateField;
    query_clientetelefone: TStringField;
    query_clienteestado_id: TIntegerField;
    query_clientecidade_id: TIntegerField;
    query_clientebairro: TStringField;
    query_clientecep: TStringField;
    query_clienteendereco: TStringField;
    query_Listar_Cliente: TFDQuery;
    query_Listar_Clientenome: TStringField;
    query_Listar_Clientedocumento: TStringField;
    query_Listar_Clientedata_nascimento: TDateField;
    query_Listar_Clientetelefone: TStringField;
    query_Listar_Clientecidade: TStringField;
    query_Listar_Clienteestado: TStringField;
    query_Listar_Clientebairro: TStringField;
    query_Listar_Clientecep: TStringField;
    query_Listar_Clienteendereco: TStringField;
    DsListarCliente: TDataSource;
    query_municipioid: TIntegerField;
    query_municipioufid: TIntegerField;
    query_municipionome: TStringField;
    query_agendamentosid: TFDAutoIncField;
    query_agendamentosdata: TDateField;
    query_agendamentoshora: TTimeField;
    query_agendamentosCliente: TStringField;
    query_agendamentosConfirmacaoCliente: TShortintField;
    query_agendamentosRealizado: TShortintField;
    query_agendamentosDescricao: TStringField;
    query_agendamentosFuncionario: TStringField;
    query_agendamentoshoras_trabalhadas: TIntegerField;
    tb_agendamentoid: TFDAutoIncField;
    tb_agendamentodata: TDateField;
    tb_agendamentohora: TTimeField;
    tb_agendamentoCliente: TStringField;
    tb_agendamentoDescricao: TStringField;
    tb_agendamentoConfirmacaoCliente: TShortintField;
    tb_agendamentoRealizado: TShortintField;
    tb_agendamentoFuncionario: TStringField;
    tb_agendamentohoras_trabalhadas: TIntegerField;
    tb_servicos: TFDTable;
    query_servicos: TFDQuery;
    DsServicos: TDataSource;
    query_servicosid: TFDAutoIncField;
    query_servicosnome: TStringField;
    query_servicospreco: TBCDField;
    query_servicosdescricao: TMemoField;
    query_servicostempo_estimado: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure query_agendamentosConfirmacaoClienteGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure query_agendamentosRealizadoGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;
  idCliente : string;
  nomeCliente : string;
  telefoneCliente : string;
  documentoCliente : string;

  idFunc : string;
  nomeFunc : string;
  cargoFunc : string;
  telefoneFunc : string;

  chamada : string;
  chamada2 : string;

  nomeUsuario : string;
  cargoUsuario : string;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
     fd.connected := true;
end;

procedure Tdm.query_agendamentosConfirmacaoClienteGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsInteger = 1 then
    Text := 'Sim'
  else
    Text := 'Não';
end;

procedure Tdm.query_agendamentosRealizadoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsInteger = 1 then
    Text := 'Sim'
  else
    Text := 'Não';
end;

end.
