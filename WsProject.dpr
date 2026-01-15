program WsProject;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {Form1},
  calculadora in 'calculadora.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
