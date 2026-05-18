unit unitSobre;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmSobre }

  TfrmSobre = class(TForm)
    btnFechar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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

