unit ULogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    labelLoading: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    procedure IniciarSistema;
  public
    { public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  dmMain, Umain, UCadastroMural;

{$R *.lfm}

{ TfrmLogin }

procedure TfrmLogin.FormShow(Sender: TObject);      // On Show
begin
  IniciarSistema;
end;

procedure TfrmLogin.IniciarSistema;                 // Inicia Sistema
var
  SLcfg : TStringList;
begin
  // BANCO DE DADOS ------------------------------------------------------------
  ProgressBar1.StepBy(0);                                     // ---
  labelLoading.Caption := 'Conectando ao Banco de Dados...';
  Application.CreateForm(TDM1, DM1);
  with DM1 do
  begin
    try
      // Carrega arquivo cfg
      SLcfg := TStringList.Create;
      SLcfg.LoadFromFile('conf/db.cfg');

      ProgressBar1.StepIt;                                    // ---
      labelLoading.Caption := 'Descriptografando tabelas...';

      // Le informações
      SEMEDconnection.Database := SLcfg[0];
      SEMEDconnection.HostName := SLcfg[1];
      SEMEDconnection.User := SLcfg[2];
      SEMEDconnection.Password := SLcfg[3];
      // Conecta ao banco
      SEMEDconnection.Connected := true;
    finally
      SLcfg.Free;
    end;

    ProgressBar1.StepIt;                                     // ---
    labelLoading.Caption := 'Realizando ligações...';

    //Habilita tabelas
    tb_cidades.Active := true;
    tb_pessoas.Active := true;
    tb_local_trabalho.Active := true;
    querycontratos.Active := true;
    tb_cargos.Active := true;
    tb_mural.Active := true;
    queryCADASTROPESSOAScidades.Active := true;
  end;

  // MURAL ---------------------------------------------------------------------
  ProgressBar1.StepIt;                                     // ---
  labelLoading.Caption := 'Atualizando Mural de Recados...';

  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmCadastroMural, frmCadastroMural);
  frmCadastroMural.AtualizarMural;

  // INICIAR -------------------------------------------------------------------
  ProgressBar1.StepIt;                                     // ---
  labelLoading.Caption := 'Criando Interface de usuário...';

  FrmMain.Show;

  self.Hide;
end;

end.
