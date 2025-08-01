program PDVbkp;

uses
  Vcl.Forms,
  login in 'login.pas' {FrmLogin},
  Menu in 'Menu.pas' {frmMenu},
  Usuarios in 'Cadastro\Usuarios.pas' {FrmUsuario},
  Funcionario in 'Cadastro\Funcionario.pas' {frmFuncionarios},
  Cargos in 'Cadastro\Cargos.pas' {FrmCargos},
  Modulo in 'Modulo.pas' {dm: TDataModule},
  Fornecedores in 'Cadastro\Fornecedores.pas' {frmfornecedores},
  Agendamento in 'Agendamento\Agendamento.pas' {FrmAgendamento},
  Cliente in 'Cadastro\Cliente.pas' {FrmCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tfrmfornecedores, frmfornecedores);
  Application.CreateForm(TFrmAgendamento, FrmAgendamento);
  Application.CreateForm(TFrmCliente, FrmCliente);
  Application.Run;
end.
