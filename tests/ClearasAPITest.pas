unit ClearasAPITest;

interface

uses
  TestFramework, StrUtils, Registry, PMCWLanguageFile, ClearasAPI, ComObj,
  ActiveX, SysUtils, ShellAPI, Windows, PMCWOSUtils, KnownFolders, Taskschd,
  Variants, SyncObjs, ShlObj, Generics.Collections, Classes, Zip, CommCtrl,
  PMCWIniFileParser, WinSvc, Graphics, Forms;

type
  TestRootList = class(TTestCase)
  protected
    FRootList: TRootList<TRootItem>;
  public
    procedure TearDown; override;
  public
    procedure TestDisable;
    procedure TestEnable;
    procedure TestDelete;
    procedure TestExportItem;
    procedure TestExportBackup;
    procedure TestImportBackup;
    procedure TestRename;
  published
    procedure TestLocking;
  end;

  TestStartupList = class(TestRootList)
  private
    procedure TestItem(AName: string);
    procedure ImportStartupFile(const AFileName: TFileName;
      ACommonStartup: Boolean = False);
  public
    procedure SetUp; override;
  published
    procedure TestHKCUItem;
    procedure TestHKCU32Item;
    procedure TestHKLMItem;
    procedure TestHKLM32Item;
    procedure TestRunOnceItem;
    procedure TestRunOnce32Item;
    procedure TestStartupUserItem;
    procedure TestStartupCommonItem;
  end;

  TestTTaskList = class(TTestCase)
  strict private
    FTaskList: TTaskList;
    procedure OnTaskSearchFinished(Sender: TObject);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestChangeItemFilePath;
    procedure TestExportItem;
    procedure TestExportBackup;
    procedure TestImportBackup;
    procedure TestRenameItem;
  end;

implementation

type
  // Helper class needed becaue UpdateActions() is protected
  TMyCustomForm = class(TCustomForm);

function GetTickCount64(): UInt64; stdcall; external kernel32 name 'GetTickCount64' delayed;

procedure Delay(AMilliseconds: Cardinal);
var
  FirstTickCount: UInt64;

begin
  FirstTickCount := GetTickCount64();

  while (GetTickCount64() < FirstTickCount + AMilliseconds) do
  begin
    Sleep(5);

    if ((GetCurrentThreadID() = MainThreadID) and Assigned(Application)) then
    begin
      Application.ProcessMessages();

      // Also process update actions
      if Assigned(Screen.ActiveCustomForm) then
        TMyCustomForm(Screen.ActiveCustomForm).UpdateActions();

      CheckSynchronize();
    end;  //of if
  end;  //of while
end;

procedure ImportRegistryFile(const AFileName: TFileName);
begin
  ShellExecute(0, 'open', 'regedit.exe', PChar('-s '+ AFileName), PChar(ExtractFileDir(Application.ExeName)), SW_SHOWNORMAL);
end;

{ TestRootList }

procedure TestRootList.TearDown;
begin
  FreeAndNil(FRootList);
  inherited TearDown;
end;

procedure TestRootList.TestDelete;
var
  CountBefore, CountEnabledBefore: Word;
  WasEnabled: Boolean;

begin
  CountBefore := FRootList.Count;
  CountEnabledBefore := FRootList.Enabled;
  WasEnabled := FRootList.Selected.Enabled;
  CheckTrue(FRootList.DeleteItem(), 'Item was not deleted!');

  if WasEnabled then
    CheckEquals(CountEnabledBefore - 1, FRootList.Enabled, 'After deleting enabled item count must be decreased by 1!')
  else
    CheckEquals(CountEnabledBefore, FRootList.Enabled, 'After deleting disabled item count must not be changed!');

  CheckEquals(CountBefore, FRootList.Count, 'After deleting item count must must be decreased by 1!');
end;

procedure TestRootList.TestDisable;
var
  CountBefore, CountEnabledBefore: Integer;

begin
  CountBefore := FRootList.Count;
  CountEnabledBefore := FRootList.Enabled;
  CheckTrue(FRootList.Selected.Enabled, 'Item must be enabled to be disabled!');
  CheckTrue(FRootList.DisableItem(), 'Item was not disabled!');
  CheckFalse(FRootList.Selected.Enabled, 'After disabling item status must also be disabled!');
  CheckEquals(0, FRootList.Enabled, 'After disabling item enabled count must be decreased by 1!');
  CheckEquals(CountBefore, FRootList.Count, 'After disabling count must not be changed!');
end;

procedure TestRootList.TestEnable;
var
  CountBefore, CountEnabledBefore: Integer;

begin
  CountBefore := FRootList.Count;
  CountEnabledBefore := FRootList.Enabled;
  CheckFalse(FRootList.Selected.Enabled, 'Item must be disabled to be enabled!');
  CheckTrue(FRootList.EnableItem(), 'Item was not enabled!');
  CheckTrue(FRootList.Selected.Enabled, 'After enabling item status must also be enabled!');
  CheckEquals(1, FRootList.Enabled, 'After enabling item enabled count must be increased by 1!');
  CheckEquals(CountBefore, FRootList.Count, 'After enabling count must not be changed!');
end;

procedure TestRootList.TestExportBackup;
begin

end;

procedure TestRootList.TestExportItem;
begin
  FRootList.ExportItem(FRootList.Selected.Name);
  FCheckCalled := True;
end;

procedure TestRootList.TestImportBackup;
const
  TestTaskFile = 'C:\Users\Phil\PMCW\Projekte\clearas\tests\data\Task.xml';

begin
  if not Supports(FRootList, IImportableList) then
  begin
    FCheckCalled := True;
    Exit;
  end;  //of begin

  CheckTrue((FRootList as IImportableList).ImportBackup(TestTaskFile), 'Import failed');
  CheckEquals(1, FRootList.Count, 'After importing there must be 1 item in list but it is empty');
  FRootList.Selected := FRootList[0];

  if FRootList.Selected.Enabled then
  begin
    CheckTrue(FRootList.DisableItem(), 'Could not disable imported item');
    CheckFalse(FRootList.Selected.Enabled, 'After disabling an item the status must also be disabled');
  end
  else
  begin
    CheckTrue(FRootList.EnableItem(), 'Could not enable imported item');
    CheckTrue(FRootList.Selected.Enabled, 'After enabling an item the status must also be enabled');
  end;

  CheckFalse((FRootList as IImportableList).ImportBackup(TestTaskFile), 'Backup duplicated');
  CheckTrue(FRootList.DeleteItem(), 'Could not delete imported item');
  CheckEquals(0, FRootList.Count, 'After deleting one item the list must be empty');
end;

procedure TestRootList.TestLocking;
begin
  FRootList.Load();

  try
    FRootList.EnableItem();

  except
    on E: EListBlocked do
      FCheckCalled := True;
  end;

  Delay(1000);
end;

procedure TestRootList.TestRename;
begin
  CheckTrue(FRootList.RenameItem(FRootList.Selected.ClassName));
end;

{ TestTTaskList }

procedure TestTTaskList.SetUp;
begin
  inherited SetUp;
  FTaskList := TTaskList.Create;
end;

procedure TestTTaskList.TearDown;
begin
  FreeAndNil(FTaskList);
  inherited TearDown;
end;

procedure TestTTaskList.OnTaskSearchFinished(Sender: TObject);
const
  ZipFile = 'C:\Users\Phil\PMCW\Projekte\clearas\tests\TestExportList.zip';

begin
  Check(FTaskList.Count > 0, 'List must not be empty!');
  FTaskList.ExportList(ZipFile);
  CheckTrue(FileExists(ZipFile), 'List was not exported as file!');
end;

procedure TestTTaskList.TestChangeItemFilePath;
const
  TestTaskFile = 'Task.xml';
  NewFileName = 'C:\Windows\regedit.exe';

var
  OldFileName: string;

begin
  CheckTrue(FTaskList.ImportBackup(TestTaskFile), 'Import failed');
  CheckEquals(1, FTaskList.Count, 'There must be 1 task in list but it is empty');
  FTaskList.Selected := FTaskList[0];

  OldFileName := FTaskList.Selected.FileName;
  CheckNotEquals('', OldFileName, 'FileName must not be empty!');

  // Change path
  CheckTrue(FTaskList.ChangeItemFilePath(NewFileName), 'Could not change path!');
  CheckEquals(NewFileName, FTaskList.Selected.FileName, 'FileNames are not the same!');

  CheckTrue(FTaskList.EnableItem(), 'Could not enable task');
  CheckTrue(FTaskList.Selected.Enabled, 'After enabling a task the status must be enabled');



  CheckTrue(FTaskList.DeleteItem(), 'Could not delete task');
  CheckEquals(0, FTaskList.Count, 'After deleting of one item task list must be empty');
end;

procedure TestTTaskList.TestExportBackup;
begin
  FTaskList.OnSearchFinish := OnTaskSearchFinished;
  FTaskList.Load(False);
  Delay(1000);
  FTaskList.Clear;
  CheckEquals(0, FTaskList.Count, 'After clearing the list must be empty!');
end;

procedure TestTTaskList.TestExportItem;
begin

end;

procedure TestTTaskList.TestImportBackup;
const
  TestTaskFile = 'C:\Users\Phil\PMCW\Projekte\clearas\tests\TestTask.xml';

begin
  CheckTrue(FTaskList.ImportBackup(TestTaskFile), 'Import failed');
  CheckEquals(1, FTaskList.Count, 'There must be 1 task in list but it is empty');
  FTaskList.Selected := FTaskList[0];

  if FTaskList.Selected.Enabled then
  begin
    CheckTrue(FTaskList.DisableItem(), 'Could not disable task');
    CheckFalse(FTaskList.Selected.Enabled, 'After disabling a task the status must be disabled');
  end
  else
  begin
    CheckTrue(FTaskList.EnableItem(), 'Could not enable task');
    CheckTrue(FTaskList.Selected.Enabled, 'After enabling a task the status must be enabled');
  end;

  CheckFalse(FTaskList.ImportBackup(TestTaskFile), 'Task duplicated');
  CheckTrue(FTaskList.DeleteItem(), 'Could not delete task');
  CheckEquals(0, FTaskList.Count, 'After deleting of one item task list must be empty');
end;

procedure TestTTaskList.TestRenameItem;
begin

end;


{ TestStartupList }

procedure TestStartupList.SetUp;
begin
  inherited SetUp;
  FRootList := TRootList<TRootItem>(TStartupList.Create);
end;

procedure TestStartupList.ImportStartupFile(const AFileName: TFileName;
  ACommonStartup: Boolean = False);
var
  Destination: string;

begin
  if ACommonStartup then
    Destination := GetKnownFolderPath(FOLDERID_CommonStartup)
  else
    Destination := GetKnownFolderPath(FOLDERID_Startup);

  Destination := Destination + ChangeFileExt(ExtractFileName(AFileName), '.lnk');
  CopyFile(PChar(AFileName), PChar(Destination), False);
end;

procedure TestStartupList.TestItem(AName: string);
var
  Index: Integer;

begin
  Check(FRootList.Count > 0, 'List must contain at least 1 item!');
  Index := FRootList.IndexOf(AName);
  CheckNotEquals(-1, Index, 'Item not found in list!');
  FRootList.Selected := FRootList[Index];
  TestDisable;
  TestRename;
  TestEnable;
  TestDelete;
end;

procedure TestStartupList.TestHKCU32Item;
begin
  ImportRegistryFile('..\data\HKCU32.reg');
  TStartupList(FRootList).LoadStartup(rkHKCU, False, True);
  TestItem('HKCU32');
end;

procedure TestStartupList.TestHKCUItem;
begin
  ImportRegistryFile('..\data\HKCU.reg');
  TStartupList(FRootList).LoadStartup(rkHKCU);
  TestItem('HKCU');
end;

procedure TestStartupList.TestHKLM32Item;
begin
  ImportRegistryFile('..\data\HKLM32.reg');
  TStartupList(FRootList).LoadStartup(rkHKLM, False, True);
  TestItem('HKLM32');
end;

procedure TestStartupList.TestHKLMItem;
begin
  ImportRegistryFile('..\data\HKLM32.reg');
  TStartupList(FRootList).LoadStartup(rkHKLM);
  TestItem('HKLM');
end;

procedure TestStartupList.TestRunOnce32Item;
begin
  ImportRegistryFile('..\data\RunOnce32.reg');
  TStartupList(FRootList).LoadStartup(rkHKLM, True, True);
  TestItem('RunOnce32');
end;

procedure TestStartupList.TestRunOnceItem;
begin
  ImportRegistryFile('..\data\RunOnce.reg');
  TStartupList(FRootList).LoadStartup(rkHKLM, True, False);
  TestItem('RunOnce');
end;

procedure TestStartupList.TestStartupCommonItem;
begin
  ImportStartupFile('..\data\Backup.CommonStartup', True);
  TStartupList(FRootList).LoadStartup(True);
  TestItem('Backup.CommonStartup');
end;

procedure TestStartupList.TestStartupUserItem;
begin
  ImportStartupFile('..\data\Backup.Startup', False);
  TStartupList(FRootList).LoadStartup(False);
  TestItem('Backup.Startup');
end;

initialization
  RegisterTest(TestStartupList.Suite);
  RegisterTest(TestTTaskList.Suite);
end.

