unit unitSobre;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TfrmSobre }

  TfrmSobre = class(TForm)
    btnFechar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    lblPlanfogo: TLabel;
    lblVersao: TLabel;
    lblAutor: TLabel;
    lblDescricao: TLabel;
    lblEmail: TLabel;
    procedure btnFecharClick(Sender: TObject);

  private

  public

  end;

var
  frmSobre: TfrmSobre;

implementation

{$R *.lfm}

{ TfrmSobre }

procedure TfrmSobre.btnFecharClick(Sender: TObject);
begin
  close;
end;


end.

