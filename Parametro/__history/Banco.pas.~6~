unit Banco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, System.IniFiles;

type
  TfrmBanco = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    btnSalvar: TSpeedButton;
    edtUser: TEdit;
    edtHost: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtDatabase: TEdit;
    edtPort: TEdit;
    edtPassword: TEdit;
    Label6: TLabel;
    btnTestConnection: TButton;
    procedure btnTestConnectionClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBanco: TfrmBanco;

implementation

{$R *.dfm}

uses Modulo;

procedure TfrmBanco.btnSalvarClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    Ini.WriteString('Conexao', 'Host', edtHost.Text);
    Ini.WriteString('Conexao', 'Port', edtPort.Text);
    Ini.WriteString('Conexao', 'Database', edtDatabase.Text);
    Ini.WriteString('Conexao', 'User', edtUser.Text);
    Ini.WriteString('Conexao', 'Password', edtPassword.Text);
    ShowMessage('Configuração salva com sucesso.');
  finally
    Ini.Free;
  end;
end;

procedure TfrmBanco.btnTestConnectionClick(Sender: TObject);
begin
  dm.fd.Params.Clear;
  dm.fd.Params.DriverID := 'MySQL';
  dm.fd.Params.Database := edtDatabase.Text;
  dm.fd.Params.UserName := edtUser.Text;
  dm.fd.Params.Password := edtPassword.Text;
  dm.fd.Params.Add('Server=' + edtHost.Text);
  dm.fd.Params.Add('Port=' + edtPort.Text);

  try
    dm.fd.Connected := True;
    ShowMessage('Conexão bem-sucedida!');
  except
    on E: Exception do
      ShowMessage('Erro ao conectar: ' + E.Message);
  end;
end;

procedure TfrmBanco.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    edtHost.Text     := Ini.ReadString('Conexao', 'Host', 'localhost');
    edtPort.Text     := Ini.ReadString('Conexao', 'Port', '3306');
    edtDatabase.Text := Ini.ReadString('Conexao', 'Database', '');
    edtUser.Text     := Ini.ReadString('Conexao', 'User', 'root');
    edtPassword.Text := Ini.ReadString('Conexao', 'Password', '');
  finally
    Ini.Free;
  end;
end;
end.
