program SppdProxy;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form2},
  uProxy in 'uProxy.pas',
  Helper in 'Helper.pas',
  uCards in 'uCards.pas',
  uBattle in 'uBattle.pas',
  NewProxy in 'NewProxy.pas',
  uClasses in 'uClasses.pas',
  uProxy2 in 'uProxy2.pas',
  PopUp in 'PopUp.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
