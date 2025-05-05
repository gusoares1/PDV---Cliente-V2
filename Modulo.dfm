object dm: Tdm
  OnCreate = DataModuleCreate
  Height = 669
  Width = 1011
  object fd: TFDConnection
    Params.Strings = (
      'Database=pdv'
      'User_Name=root'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 8
    Top = 8
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\Users\Pichau\OneDrive\Documentos\Embarcadero\Studio\Projects\' +
      'PDV\Lib\libmySQL.dll'
    Left = 96
    Top = 8
  end
  object tb_Cargos: TFDTable
    IndexFieldNames = 'id'
    Connection = fd
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'pdv.cargos'
    Left = 16
    Top = 96
  end
  object query_cargos: TFDQuery
    Connection = fd
    SQL.Strings = (
      'select * from cargos')
    Left = 88
    Top = 96
    object query_cargosid: TFDAutoIncField
      DisplayLabel = 'ID'
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object query_cargoscargo: TStringField
      FieldName = 'cargo'
      Origin = 'cargo'
      Required = True
      Size = 30
    end
  end
  object DScargos: TDataSource
    DataSet = query_cargos
    Left = 160
    Top = 96
  end
  object tb_funcionario: TFDTable
    IndexFieldNames = 'id'
    Connection = fd
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'pdv.funcionarios'
    Left = 32
    Top = 160
    object tb_funcionarioid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object tb_funcionarionome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 30
    end
    object tb_funcionariocpf: TStringField
      FieldName = 'cpf'
      Origin = 'cpf'
      Required = True
    end
    object tb_funcionariotelefone: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'telefone'
      Origin = 'telefone'
      Size = 15
    end
    object tb_funcionarioendereco: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'endereco'
      Origin = 'endereco'
      Size = 50
    end
    object tb_funcionariocargo: TStringField
      FieldName = 'cargo'
      Origin = 'cargo'
      Required = True
      Size = 25
    end
    object tb_funcionariodata: TDateField
      FieldName = 'data'
      Origin = 'data'
      Required = True
    end
  end
  object DSfuncionario: TDataSource
    DataSet = query_func
    Left = 192
    Top = 160
  end
  object query_func: TFDQuery
    Connection = fd
    SQL.Strings = (
      'select * from funcionarios')
    Left = 112
    Top = 160
    object query_funcid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object query_funcnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 30
    end
    object query_funccpf: TStringField
      FieldName = 'cpf'
      Origin = 'cpf'
      Required = True
    end
    object query_functelefone: TStringField
      FieldName = 'telefone'
      Origin = 'telefone'
      Size = 15
    end
    object query_funcendereco: TStringField
      FieldName = 'endereco'
      Origin = 'endereco'
      Size = 50
    end
    object query_funccargo: TStringField
      FieldName = 'cargo'
      Origin = 'cargo'
      Required = True
      Size = 25
    end
    object query_funcdata: TDateField
      FieldName = 'data'
      Origin = 'data'
      Required = True
    end
  end
  object tb_usuario: TFDTable
    IndexFieldNames = 'id'
    Connection = fd
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'pdv.usuarios'
    Left = 24
    Top = 248
    object tb_usuarioid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object tb_usuarionome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 30
    end
    object tb_usuariousuario: TStringField
      FieldName = 'usuario'
      Origin = 'usuario'
      Required = True
      Size = 30
    end
    object tb_usuariosenha: TStringField
      FieldName = 'senha'
      Origin = 'senha'
      Required = True
      Size = 25
    end
    object tb_usuariocargo: TStringField
      FieldName = 'cargo'
      Origin = 'cargo'
      Required = True
      Size = 25
    end
    object tb_usuarioid_funcionario: TIntegerField
      FieldName = 'id_funcionario'
      Origin = 'id_funcionario'
      Required = True
    end
  end
  object query_usuarios: TFDQuery
    Connection = fd
    SQL.Strings = (
      'select * from usuarios')
    Left = 104
    Top = 248
    object query_usuariosnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 30
    end
    object query_usuariosusuario: TStringField
      FieldName = 'usuario'
      Origin = 'usuario'
      Required = True
      Size = 30
    end
    object query_usuariossenha: TStringField
      FieldName = 'senha'
      Origin = 'senha'
      Required = True
      Size = 25
    end
    object query_usuarioscargo: TStringField
      FieldName = 'cargo'
      Origin = 'cargo'
      Required = True
      Size = 25
    end
    object query_usuariosid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object query_usuariosid_funcionario: TIntegerField
      FieldName = 'id_funcionario'
      Origin = 'id_funcionario'
      Required = True
    end
  end
  object DSusuarios: TDataSource
    DataSet = query_usuarios
    Left = 192
    Top = 248
  end
  object tb_fornecedor: TFDTable
    Connection = fd
    TableName = 'pdv.fornecedores'
    Left = 32
    Top = 320
  end
  object query_fornecedores: TFDQuery
    Connection = fd
    SQL.Strings = (
      '               select * from fornecedores')
    Left = 136
    Top = 320
    object query_fornecedoresid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object query_fornecedoresnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 25
    end
    object query_fornecedoresproduto: TStringField
      FieldName = 'produto'
      Origin = 'produto'
      Required = True
      Size = 25
    end
    object query_fornecedorestelefone: TStringField
      DisplayWidth = 10
      FieldName = 'telefone'
      Origin = 'telefone'
      Required = True
      Size = 35
    end
    object query_fornecedoresendereco: TStringField
      FieldName = 'endereco'
      Origin = 'endereco'
      Required = True
      Size = 40
    end
    object query_fornecedoresdata: TDateField
      FieldName = 'data'
      Origin = 'data'
      Required = True
    end
  end
  object DSFornecedores: TDataSource
    DataSet = query_fornecedores
    Left = 249
    Top = 320
  end
  object tb_agendamento: TFDTable
    IndexFieldNames = 'id'
    Connection = fd
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'agendamentos'
    Left = 32
    Top = 384
    object tb_agendamentoid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object tb_agendamentodata: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'data'
      Origin = 'data'
    end
    object tb_agendamentohora: TTimeField
      AutoGenerateValue = arDefault
      FieldName = 'hora'
      Origin = 'hora'
    end
    object tb_agendamentoCliente: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'Cliente'
      Origin = 'Cliente'
      Size = 35
    end
    object tb_agendamentoDescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'Descricao'
      Origin = 'Descricao'
      Size = 50
    end
    object tb_agendamentoConfirmacaoCliente: TShortintField
      AutoGenerateValue = arDefault
      FieldName = 'ConfirmacaoCliente'
      Origin = 'ConfirmacaoCliente'
    end
    object tb_agendamentoRealizado: TShortintField
      AutoGenerateValue = arDefault
      FieldName = 'Realizado'
      Origin = 'Realizado'
    end
    object tb_agendamentoFuncionario: TStringField
      FieldName = 'Funcionario'
      Origin = 'Funcionario'
      Required = True
      Size = 15
    end
    object tb_agendamentohoras_trabalhadas: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'horas_trabalhadas'
      Origin = 'horas_trabalhadas'
    end
  end
  object query_agendamentos: TFDQuery
    Connection = fd
    SQL.Strings = (
      '               select * from agendamentos')
    Left = 152
    Top = 384
    object query_agendamentosid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object query_agendamentosdata: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'data'
      Origin = 'data'
    end
    object query_agendamentoshora: TTimeField
      AutoGenerateValue = arDefault
      FieldName = 'hora'
      Origin = 'hora'
    end
    object query_agendamentosCliente: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'Cliente'
      Origin = 'Cliente'
      Size = 35
    end
    object query_agendamentosFuncionario: TStringField
      FieldName = 'Funcionario'
      Origin = 'Funcionario'
      Required = True
      Size = 15
    end
    object query_agendamentosConfirmacaoCliente: TShortintField
      AutoGenerateValue = arDefault
      FieldName = 'ConfirmacaoCliente'
      Origin = 'ConfirmacaoCliente'
      OnGetText = query_agendamentosConfirmacaoClienteGetText
    end
    object query_agendamentoshoras_trabalhadas: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'horas_trabalhadas'
      Origin = 'horas_trabalhadas'
    end
    object query_agendamentosRealizado: TShortintField
      AutoGenerateValue = arDefault
      FieldName = 'Realizado'
      Origin = 'Realizado'
      OnGetText = query_agendamentosRealizadoGetText
    end
    object query_agendamentosDescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'Descricao'
      Origin = 'Descricao'
      Size = 50
    end
  end
  object DsAgendamento: TDataSource
    DataSet = query_agendamentos
    Left = 273
    Top = 384
  end
  object tb_uf: TFDTable
    Connection = fd
    TableName = 'pdv.uf'
    Left = 32
    Top = 448
  end
  object query_uf: TFDQuery
    Connection = fd
    SQL.Strings = (
      '               select * from uf')
    Left = 152
    Top = 448
    object query_ufid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object query_ufnome: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome'
      Origin = 'nome'
      FixedChar = True
      Size = 255
    end
    object query_ufsigla: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'sigla'
      Origin = 'sigla'
      FixedChar = True
      Size = 2
    end
  end
  object DsUF: TDataSource
    DataSet = query_uf
    Left = 273
    Top = 448
  end
  object tb_municipio: TFDTable
    IndexFieldNames = 'id'
    Connection = fd
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'pdv.municipio'
    Left = 32
    Top = 528
  end
  object query_municipio: TFDQuery
    Active = True
    Connection = fd
    SQL.Strings = (
      '               select * from municipio')
    Left = 152
    Top = 528
    object query_municipioid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object query_municipioufid: TIntegerField
      FieldName = 'ufid'
      Origin = 'ufid'
      Required = True
    end
    object query_municipionome: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome'
      Origin = 'nome'
      FixedChar = True
      Size = 255
    end
  end
  object DsMunicipio: TDataSource
    DataSet = query_municipio
    Left = 273
    Top = 528
  end
  object tb_cliente: TFDTable
    IndexFieldNames = 'id'
    Connection = fd
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'cliente'
    Left = 480
    Top = 32
  end
  object query_cliente: TFDQuery
    Connection = fd
    SQL.Strings = (
      '               select * from cliente')
    Left = 552
    Top = 32
    object query_clienteid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object query_clientenome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 100
    end
    object query_clientedocumento: TStringField
      FieldName = 'documento'
      Origin = 'documento'
      Required = True
    end
    object query_clientedata_nascimento: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'data_nascimento'
      Origin = 'data_nascimento'
    end
    object query_clientetelefone: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'telefone'
      Origin = 'telefone'
      Size = 15
    end
    object query_clienteestado_id: TIntegerField
      FieldName = 'estado_id'
      Origin = 'estado_id'
      Required = True
    end
    object query_clientecidade_id: TIntegerField
      FieldName = 'cidade_id'
      Origin = 'cidade_id'
      Required = True
    end
    object query_clientebairro: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'bairro'
      Origin = 'bairro'
      Size = 100
    end
    object query_clientecep: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'cep'
      Origin = 'cep'
      Size = 10
    end
    object query_clienteendereco: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'endereco'
      Origin = 'endereco'
      Size = 255
    end
  end
  object DsCliente: TDataSource
    DataSet = query_cliente
    Left = 625
    Top = 32
  end
  object query_Listar_Cliente: TFDQuery
    Connection = fd
    SQL.Strings = (
      
        'SELECT a.id,a.nome, a.documento, a.data_nascimento,a.telefone,b.' +
        'nome AS cidade, c.nome AS estado, a.bairro, a.cep, a.endereco '
      '    FROM cliente a '
      '    JOIN municipio b ON a.cidade_id = b.id'
      '    JOIN uf c ON a.estado_id = c.id')
    Left = 712
    Top = 32
    object query_Listar_Clientenome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
    end
    object query_Listar_Clientedocumento: TStringField
      FieldName = 'documento'
      Origin = 'documento'
      Required = True
      Size = 15
    end
    object query_Listar_Clientedata_nascimento: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'data_nascimento'
      Origin = 'data_nascimento'
    end
    object query_Listar_Clientetelefone: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'telefone'
      Origin = 'telefone'
      Size = 15
    end
    object query_Listar_Clientecidade: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'cidade'
      Origin = 'nome'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
    end
    object query_Listar_Clienteestado: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'estado'
      Origin = 'nome'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
    end
    object query_Listar_Clientebairro: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'bairro'
      Origin = 'bairro'
    end
    object query_Listar_Clientecep: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'cep'
      Origin = 'cep'
      Size = 10
    end
    object query_Listar_Clienteendereco: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'endereco'
      Origin = 'endereco'
      Size = 30
    end
  end
  object DsListarCliente: TDataSource
    DataSet = query_Listar_Cliente
    Left = 817
    Top = 32
  end
  object tb_servicos: TFDTable
    Active = True
    IndexFieldNames = 'id'
    Connection = fd
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'pdv.servico'
    Left = 480
    Top = 104
  end
  object query_servicos: TFDQuery
    Connection = fd
    SQL.Strings = (
      '               select * from servico')
    Left = 560
    Top = 104
    object query_servicosid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object query_servicosnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 100
    end
    object query_servicospreco: TBCDField
      FieldName = 'preco'
      Origin = 'preco'
      Required = True
      Precision = 10
      Size = 2
    end
    object query_servicosdescricao: TMemoField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      BlobType = ftMemo
    end
    object query_servicostempo_estimado: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'tempo_estimado'
      Origin = 'tempo_estimado'
    end
  end
  object DsServicos: TDataSource
    DataSet = query_servicos
    Left = 641
    Top = 104
  end
end
