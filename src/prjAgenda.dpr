program prjAgenda;

uses
  Vcl.Forms,
  uAgenda in 'uAgenda.pas' {frmAgenda},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TfrmAgenda, frmAgenda);
  Application.Run;
end.
