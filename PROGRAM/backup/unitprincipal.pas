unit unitPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ExtCtrls, Math;

type

  { TForm1 }

  TForm1 = class(TForm)

    btnSair: TButton;
    btnCalcular: TButton;

    edtCC: TEdit;  // Capacidade da caçamba de carregamento (m cúbicos)
    edtAD: TEdit;  // Tamanho de admissão do britador (m) (AD)
    edtDiametroPerfuracao: TEdit;  //  Diâmetro de perfuração (mm)
    edtRC: TEdit;  // Resistência à compressão da rocha (MPa) (RC)

    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
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

end;

procedure TForm1.btnCalcularClick(Sender: TObject);
begin

  if edtRC.Text <> ''
  then
  begin
    rc := StrToInt(edtRC.Text);
    rt := rc / 10;
    str(rt:0:0, rtStr);
    lblRT.Caption := rtStr + ' MPa';
  end;

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

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.

