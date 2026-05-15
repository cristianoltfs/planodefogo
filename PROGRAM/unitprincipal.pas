unit unitPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ExtCtrls, Math;

type

  { TForm1 }

  TForm1 = class(TForm)

    Bevel1: TBevel;
    Bevel2: TBevel;

    btnSair: TButton;
    btnCalcular: TButton;
    CmbBxRocha: TComboBox;
    edtAlturaBancada: TEdit;


    edtDensidadeExplosivo: TEdit;
    edtDensidadeDaRocha: TEdit;
    edtCC: TEdit;  // Capacidade da caçamba de carregamento (m cúbicos)
    edtAD: TEdit;  // Tamanho de admissão do britador (m) (AD)
    edtDiametroPerfuracao: TEdit;  //  Diâmetro de perfuração (mm)
    edtRC: TEdit;  // Resistência à compressão da rocha (MPa) (RC)

    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lblSubperfuracao: TLabel;
    lblEspacamento: TLabel;
    lblBancada: TLabel;
    lblFragmentacao: TLabel;
    lblAfastamento: TLabel;  //  Valor do afastamento
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblTB: TLabel;
    lblRT: TLabel;  //  Resitência à tração da rocha (MPA) (RT):

    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;

    procedure btnCalcularClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);

  private

  public

    rt : real; // resistência à tração da rocha em MPa
    rtStr : string;  // para exibir como string no formulário
    rc : integer;  // resistência à compressão da rocha me MPa

    tbBritador : real;  // tamanho dos blocos expresso por sua maior longitude (admissão do britador)
    tbBritadorStr : string;
    tbCacamba : real;  // tamanho dos blocos expresso por sua maior longitude (capacidade da caçamba)
    tbCacambaStr : string;

    diametroPerfuracao : real;
    densidadeExplosivo : real;
    densidadeRocha : real;
    afastamento : real;
    afastamentoStr : string;

    alturaBancada : real;
    relacaoBancadaAfastamento : real;
    fragmentacao : string;
    bancada : string;
    espacamento : real;
    espacamentoStr : string;

    subperfuracao : real;
    subperfuracaoStr : string;

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  CmbBxRocha.Items.Clear;
  CmbBxRocha.Items.Add('Calcário');
  CmbBxRocha.Items.Add('Granito');
  CmbBxRocha.Items.Add('Itabirito');
  CmbBxRocha.Items.Add('Outra');
  CmbBxRocha.ItemIndex := 0;

end;

procedure TForm1.btnCalcularClick(Sender: TObject);
begin

  // cálculo da resistência à tração em relação à compressão
  if edtRC.Text <> ''
  then
  begin
    rc := StrToInt(edtRC.Text);
    rt := rc / 10;
    str(rt:0:0, rtStr);
    lblRT.Caption := rtStr + ' MPa';
  end;

  //  cálculo do tamanho do bloco em relação ao tamanho do britador e da caçamba
  tbBritador := 0.8 * StrToFloat(edtAD.Text);
  tbCacamba := 0.7 * Power(StrToFloat(edtCC.text), 1/3);
  if tbCacamba < tbBritador
    then
    begin
      str(tbCacamba:0:2, tbCacambaStr);
      lblTB.Caption := tbCacambaStr + ' m';
    end
    else
    begin
      str(tbBritador:0:2, tbBritadorStr);
      lblTB.Caption := tbBritadorStr + ' m';
    end;

  // Cálculo do afastamento
  diametroPerfuracao := StrToFloat(edtDiametroPerfuracao.Text);
  densidadeExplosivo := StrToFloat(edtDensidadeExplosivo.Text);
  densidadeRocha := StrToFloat(edtDensidadeDaRocha.Text);
  if diametroPerfuracao < 140.0
    then afastamento :=  0.0123*(2*(densidadeExplosivo/densidadeRocha)+1.5)*diametroPerfuracao
    else if rc > 120
      then afastamento :=  0.00877*(2*(densidadeExplosivo/densidadeRocha)+1.5)*diametroPerfuracao
      else if rc >= 70
        then afastamento :=  0.00967*(2*(densidadeExplosivo/densidadeRocha)+1.5)*diametroPerfuracao
        else afastamento :=  0.01053*(2*(densidadeExplosivo/densidadeRocha)+1.5)*diametroPerfuracao;
  str(afastamento:0:1, afastamentoStr);
  lblAfastamento.Caption := afastamentoStr + ' m';

  // cálculo da relação entre altura da bancada e afastamento
  alturaBancada := StrToFloat(edtAlturaBancada.Text);
  relacaoBancadaAfastamento := alturaBancada / afastamento;
  bancada := 'baixa';
  if relacaoBancadaAfastamento < 2
    then fragmentacao := 'ruim'
    else if relacaoBancadaAfastamento < 3
      then fragmentacao := 'regular'
      else if relacaoBancadaAfastamento < 4
        then fragmentacao := 'boa'
        else if relacaoBancadaAfastamento >= 4
          then
          begin
            fragmentacao := 'excelente';
            bancada := 'alta';
          end;
  lblFragmentacao.Caption := fragmentacao;
  lblBancada.Caption := bancada;

  // cálculo do espaçamento

  if CmbBxRocha.ItemIndex = 0
    then espacamento := 2 * afastamento
    else if rc > 120
      then espacamento := 1.15 * afastamento
      else if rc >= 70
        then espacamento := 1.2 * afastamento
        else espacamento := 1.25 * afastamento;
  str(espacamento:0:1, espacamentoStr);
  lblEspacamento.Caption := espacamentoStr + ' m';

  // cálculo da subperfuração
  subperfuracao := 0.3 * afastamento;
  str(subperfuracao:0:1, subperfuracaoStr);
  lblSubperfuracao.Caption := subperfuracaoStr;

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.

