program Clearas;

{$R 'changelog.res' 'changelog.rc'}
{$R 'description.res' 'description.rc'}

uses
  Forms,
{$IFNDEF DEBUG}
  AdminManifest in 'AdminManifest.pas',
{$ENDIF}
  PMCWMutex in 'PMCWMutex.pas',
  ClearasMain in 'ClearasMain.pas' {Main},
  ClearasAPI in 'ClearasAPI.pas',
  StartupSearchThread in 'StartupSearchThread.pas',
  ContextSearchThread in 'ContextSearchThread.pas',
  ExportListThread in 'ExportListThread.pas',
  PMCWAbout in 'PMCWAbout.pas' {About},
  PMCWUpdater in 'PMCWUpdater.pas' {Update};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Clearas';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
