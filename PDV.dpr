program PDV;

uses
  Vcl.Forms,
  login in 'login.pas' {FrmLogin},
  Menu in 'Menu.pas' {frmMenu},
  Usuarios in 'Cadastro\Usuarios.pas' {FrmUsuario},
  Funcionario in 'Cadastro\Funcionario.pas' {frmFuncionarios},
  Cargos in 'Cadastro\Cargos.pas' {FrmCargos},
  Modulo in 'Modulo.pas' {dm: TDataModule},
  Fornecedores in 'Cadastro\Fornecedores.pas' {FrmCategoriaGastos},
  Agendamento in 'Agendamento\Agendamento.pas' {FrmAgendamento},
  Cliente in 'Cadastro\Cliente.pas' {FrmCliente},
  Servicos in 'Cadastro\Servicos.pas' {frmServico},
  Vincular_Servicos in 'Agendamento\Vincular_Servicos.pas' {frmAgendamentoServ},
  Filtrar in 'Agendamento\Filtro\Filtrar.pas' {FrmFiltroAgendamento},
  forma_pagamento in 'Cadastro\forma_pagamento.pas' {FrmFormaPgto},
  pagto_agend in 'Agendamento\pagto_agend.pas' {frmPagtoAgendamento},
  Relatorios_Operacionais in 'Relatorio\Relatorios_Operacionais.pas' {frmRelatoriosOperacionais},
  Relatorios_Financeiros in 'Relatorio\Relatorios_Financeiros.pas' {FrmRelatorios_Financeiros},
  parametro in 'Parametro\parametro.pas' {FrmParametro},
  Banco in 'Parametro\Banco.pas' {frmBanco},
  Gastos in 'Financeiro\Gastos.pas' {FrmGastos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmGastos, FrmGastos);
  Application.Run;
end.
