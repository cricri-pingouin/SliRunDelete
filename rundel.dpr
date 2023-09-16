Program rundel;

Uses
  Forms,
  unit1 In 'unit1.pas' {MainForm};

{$R *.res}
{$SetPEFlags 1}

Begin
  Application.Initialize;
  Application.Title := 'rundel';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
End.
