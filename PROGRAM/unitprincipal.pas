unit unitPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnSair: TButton;
    btnCalcular: TButton;
    edtRC: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lblRT: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    procedure btnCalcularClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private

  public
    rt : real; // resistência à tração da rocha em MPa
    rtStr : string; // para exibir como string no formulário
    rc : integer; // resistência à compressão da rocha me MPa
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

procedure TForm1.btnCalcularClick(Sender: TObject);
begin
  rc := StrToInt(edtRC.Text);
  rt := rc / 10;
  str(rt:4:0, rtStr);
  lblRT.Caption := rtStr + ' MPa';
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.

