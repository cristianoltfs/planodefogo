unit unitPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ExtCtrls, Math, unitSobre;

type

  { TForm1 }

  TForm1 = class(TForm)

    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;

    btnSair: TButton;
    btnCalcular: TButton;
    CmbBxRocha: TComboBox;
    edtInclinacaoFuro: TEdit;
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
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    lblAlturaCargaFundo: TLabel;
    lblRazaoLinearCarregamento: TLabel;
    lblPerfuracaoEspecifica: TLabel;
    lblVolumeDeRochaPorFuro: TLabel;
    Label22: TLabel;
    lblAlturaTampao: TLabel;
    lblDiametroTampao: TLabel;
    lblProfundidadeFuro: TLabel;
    lblFragRuim: TLabel;
    lblFragRegular: TLabel;
    lblFragBoa: TLabel;
    lblFragExcelente: TLabel;
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
    ScrllBrDiametroPerfuracao: TScrollBar;

    procedure btnCalcularClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure ScrllBrDiametroPerfuracaoChange(Sender: TObject);

    procedure AtualizarFragmentacao(frag: string);

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

    profundidadeFuro : real;
    profundidadeFuroStr : string;
    inclinacaoFuro : real;  //  inclinação do furo em graus

    diametroTampao : real;
    diametroTampaoStr : string;

    alturaTampao : real;
    alturaTampaoStr : string;

    volumeRochaPorFuro : real;
    volumeRochaPorFuroStr : string;

    perfuracaoEspecifica : real;
    perfuracaoEspecificaStr : string;

    razaoLinearCarregamento : real;
    razaoLinearCarregamentoStr : string;

    alturaCargaFundo : real;
    alturaCargaFundoStr : string;

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

  ScrllBrDiametroPerfuracao.Min := 20;
  ScrllBrDiametroPerfuracao.Max := 500;
  ScrllBrDiametroPerfuracao.Position := 102; // valor inicial
  ScrllBrDiametroPerfuracao.SmallChange := 1; // sesta move 1mm
  ScrllBrDiametroPerfuracao.LargeChange := 1; // clique na barra move 1mm

  edtDiametroPerfuracao.Text := IntToStr(ScrllBrDiametroPerfuracao.Position);

end;

procedure TForm1.btnCalcularClick(Sender: TObject);
begin

  try

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
  lblSubperfuracao.Caption := subperfuracaoStr + ' m';

  // Profundidade do furo
  inclinacaoFuro := StrToFloat(edtInclinacaoFuro.Text);
  profundidadeFuro := (alturaBancada / Cos(DegToRad(inclinacaoFuro))) + ((1 - inclinacaoFuro / 100) * subperfuracao);
  str(profundidadeFuro:0:1, profundidadeFuroStr);
  lblProfundidadeFuro.Caption := profundidadeFuroStr + ' m';

  // Diâmtro do tampão
  diametroTampao := diametroPerfuracao / 20;
  str(diametroTampao:0:1, diametroTampaoStr);
  lblDiametroTampao.Caption := diametroTampaoStr + ' m';

  // altura do tampão
  alturaTampao := 0.7 * afastamento;
  str(alturaTampao:0:1, alturaTampaoStr);
  lblAlturaTampao.Caption := alturaTampaoStr + ' m';
  {
  if alturaTampao < afastamento
  then
    lblRiscoAlturaTampao.Caption := 'Risco de ultralançamento da superfície mais alta!'
  else
    lblRiscoAlturaTampao.Caption := 'Produção de mais matacões. Lançamento menor!';
  }

  // altura do tampão
  volumeRochaPorFuro := alturaBancada * afastamento * espacamento;
  str(volumeRochaPorFuro:0:1, volumeRochaPorFuroStr);
  lblVolumeDeRochaPorFuro.Caption := volumeRochaPorFuroStr + ' m³';

  // perfuração específica
  perfuracaoEspecifica := profundidadeFuro / volumeRochaPorFuro;
  str(perfuracaoEspecifica:0:2, perfuracaoEspecificaStr);
  lblPerfuracaoEspecifica.Caption := perfuracaoEspecificaStr;

  // razão linear de carregamento
  razaoLinearCarregamento := 0.000785 * densidadeExplosivo * diametroPerfuracao;
  str(razaoLinearCarregamento:0:2, razaoLinearCarregamentoStr);
  lblRazaoLinearCarregamento.Caption := razaoLinearCarregamentoStr;

  // altura da carga de fundo
  alturaCargaFundo := 0.3;
  str(alturaCargaFundo:0:2, alturaCargaFundoStr);
  lblAlturaCargaFundo.Caption := alturaCargaFundoStr;

  AtualizarFragmentacao(fragmentacao);

  except
    on E : Exception do
      ShowMessage('Erro de Cálculo: ' + E.Message);

  end;


end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  frmSobre.ShowModal; //  abre como janela modal (bloqueia a principal)
end;

procedure TForm1.ScrllBrDiametroPerfuracaoChange(Sender: TObject);
begin

  edtDiametroPerfuracao.Text := IntToStr(ScrllBrDiametroPerfuracao.Position);

  btnCalcularClick(Sender);

end;

procedure TForm1.AtualizarFragmentacao(frag: string);
var
  labels: array[0..3] of TLabel;
  nomes: array[0..3] of string;
  cores: array[0..3] of TColor;
  i: integer;
begin

  labels[0] := lblFragRuim;
  labels[1] := lblFragRegular;
  labels[2] := lblFragBoa;
  labels[3] := lblFragExcelente;

  nomes[0] := 'ruim';
  nomes[1] := 'regular';
  nomes[2] := 'boa';
  nomes[3] := 'excelente';

  cores[0] := clRed;
  cores[1] := $00005FBB;  // laranja
  cores[2] := $000077AA;  // amarelo
  cores[3] := clGreen;

  for i := 0 to 3 do
  begin
    if nomes[i] = frag then
    begin
      labels[i].Font.Bold := True;
      labels[i].Font.Color := cores[i];
      labels[i].Transparent := False;
      labels[i].Color := clWhite;
    end
    else
    begin
      labels[i].Font.Bold := False;
      labels[i].Font.Color := clGray;
      labels[i].Color := clDefault;  // volta ao fundo padrão
      labels[i].Transparent := TRUE;
    end;
  end;
end;

end.

