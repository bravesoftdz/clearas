{ *********************************************************************** }
{                                                                         }
{ Clearas Main Unit                                                       }
{                                                                         }
{ Copyright (c) 2011-2017 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit ClearasMain;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Menus, Vcl.Graphics,
  Vcl.ClipBrd, Registry, System.ImageList, Winapi.CommCtrl, System.UITypes,
  System.Generics.Collections, Winapi.ShellAPI, Vcl.ImgList, ClearasAPI,
  PMCW.Dialogs.About, PMCW.LanguageFile, PMCW.SysUtils, PMCW.CA, PMCW.Dialogs.Updater,
  ClearasDialogs, Winapi.Messages, PMCW.Registry;

type
  { TMain }
  TMain = class(TForm, IChangeLanguageListener)
    PopupMenu: TPopupMenu;
    pmChangeStatus: TMenuItem;
    N1: TMenuItem;
    pmExport: TMenuItem;
    pmDelete: TMenuItem;
    MainMenu: TMainMenu;
    mmView: TMenuItem;
    mmRefresh: TMenuItem;
    N2: TMenuItem;
    pmCopyLocation: TMenuItem;
    mmHelp: TMenuItem;
    mmAbout: TMenuItem;
    mmEdit: TMenuItem;
    mmFile: TMenuItem;
    mmExport: TMenuItem;
    N3: TMenuItem;
    mmClose: TMenuItem;
    mmAdd: TMenuItem;
    N4: TMenuItem;
    mmDate: TMenuItem;
    mmImport: TMenuItem;
    N7: TMenuItem;
    N6: TMenuItem;
    mmLang: TMenuItem;
    PageControl: TPageControl;
    tsStartup: TTabSheet;
    tsContext: TTabSheet;
    lwStartup: TListView;
    lStartup: TLabel;
    bCloseStartup: TButton;
    bDisableStartupItem: TButton;
    bDeleteStartupItem: TButton;
    bExportStartupItem: TButton;
    lCopy1: TLabel;
    bExportContextItem: TButton;
    bDeleteContextItem: TButton;
    bCloseContext: TButton;
    bDisableContextItem: TButton;
    bEnableContextItem: TButton;
    lwContext: TListView;
    lContext: TLabel;
    pbContextProgress: TProgressBar;
    cbContextExpert: TCheckBox;
    mmUpdate: TMenuItem;
    N9: TMenuItem;
    mmInstallCertificate: TMenuItem;
    N10: TMenuItem;
    pmEditPath: TMenuItem;
    mmReport: TMenuItem;
    pmOpenRegedit: TMenuItem;
    pmOpenExplorer: TMenuItem;
    tsService: TTabSheet;
    lwService: TListView;
    lService: TLabel;
    bExportServiceItem: TButton;
    bDeleteServiceItem: TButton;
    bCloseService: TButton;
    bDisableServiceItem: TButton;
    bEnableServiceItem: TButton;
    bEnableStartupItem: TButton;
    cbServiceExpert: TCheckBox;
    cbRunOnce: TCheckBox;
    QuickSearchIconList: TImageList;
    eContextSearch: TButtonedEdit;
    eServiceSearch: TButtonedEdit;
    pbServiceProgress: TProgressBar;
    tsTasks: TTabSheet;
    bCloseTasks: TButton;
    bDeleteTaskItem: TButton;
    bDisableTaskitem: TButton;
    bEnableTaskItem: TButton;
    bExportTaskItem: TButton;
    cbTaskExpert: TCheckBox;
    eTaskSearch: TButtonedEdit;
    lTasks: TLabel;
    lwTasks: TListView;
    pbTaskProgress: TProgressBar;
    pmRename: TMenuItem;
    pmChangeIcon: TMenuItem;
    pmDeleteIcon: TMenuItem;
    N5: TMenuItem;
    mmShowCaptions: TMenuItem;
    lCopy2: TLabel;
    lCopy3: TLabel;
    lCopy4: TLabel;
    mmDeleteErasable: TMenuItem;
    eStartupSearch: TButtonedEdit;
    pmExecute: TMenuItem;
    N8: TMenuItem;
    pmProperties: TMenuItem;
    StartupImages: TImageList;
    pmExtended: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bCloseStartupClick(Sender: TObject);
    procedure bEnableItemClick(Sender: TObject);
    procedure bDeleteItemClick(Sender: TObject);
    procedure bDisableItemClick(Sender: TObject);
    procedure bExportItemClick(Sender: TObject);
    procedure eSearchChange(Sender: TObject);
    procedure lwContextDblClick(Sender: TObject);
    procedure lwContextSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lwServiceDblClick(Sender: TObject);
    procedure lwServiceSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lwStartupDblClick(Sender: TObject);
    procedure ListViewKeyPress(Sender: TObject; var Key: Char);
    procedure lwStartupSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure mmAddClick(Sender: TObject);
    procedure mmDateClick(Sender: TObject);
    procedure mmExportClick(Sender: TObject);
    procedure mmImportClick(Sender: TObject);
    procedure mmRefreshClick(Sender: TObject);
    procedure mmAboutClick(Sender: TObject);
    procedure mmUpdateClick(Sender: TObject);
    procedure mmInstallCertificateClick(Sender: TObject);
    procedure mmReportClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure pmChangeStatusClick(Sender: TObject);
    procedure pmCopyLocationClick(Sender: TObject);
    procedure pmEditPathClick(Sender: TObject);
    procedure pmOpenRegeditClick(Sender: TObject);
    procedure pmOpenExplorerClick(Sender: TObject);
    procedure lCopy1MouseLeave(Sender: TObject);
    procedure lCopy1MouseEnter(Sender: TObject);
    procedure lCopy1Click(Sender: TObject);
    procedure eSearchRightButtonClick(Sender: TObject);
    procedure lwTasksSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lwTasksDblClick(Sender: TObject);
    procedure pmRenameClick(Sender: TObject);
    procedure pmChangeIconClick(Sender: TObject);
    procedure pmDeleteIconClick(Sender: TObject);
    procedure mmShowCaptionsClick(Sender: TObject);
    procedure mmDeleteErasableClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure pmExecuteClick(Sender: TObject);
    procedure pmPropertiesClick(Sender: TObject);
    procedure pmExtendedClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FStartup: TStartupList;
    FContext: TContextMenuList;
    FService: TServiceList;
    FTasks: TTaskList;
    FLang: TLanguageFile;
    FUpdateCheck: TUpdateCheck;
    FStatusText: array[Boolean] of string;
    function GetListForIndex(AIndex: Integer): TRootList<TRootItem>;
    function GetListViewForIndex(AIndex: Integer): TListView;
    function GetSelectedItem(): TRootItem;
    function GetSelectedList(): TRootList<TRootItem>;
    function GetSelectedListView(): TListView;
    function GetItemText(AItem: TRootItem): string;
    procedure Refresh(AIndex: Integer; ATotal: Boolean = True);
    procedure OnContextSearchStart(Sender: TObject);
    procedure OnContextSearchEnd(Sender: TObject);
    procedure OnContextListNotify(Sender: TObject; const AItem: TContextMenuListItem;
      AAction: TCollectionNotification);
    procedure OnContextCounterUpdate(Sender: TObject);
    procedure OnExportListStart(Sender: TObject);
    procedure OnExportListEnd(Sender: TObject);
    procedure OnExportListError(Sender: TObject; const AErrorMessage: string);
    procedure OnSearchError(Sender: TObject; const AErrorMessage: string);
    procedure OnListLocked(Sender: TObject);
    procedure OnStartupSearchStart(Sender: TObject);
    procedure OnStartupSearchEnd(Sender: TObject);
    procedure OnStartupListNotify(Sender: TObject; const AItem: TStartupListItem;
      AAction: TCollectionNotification);
    procedure OnStartupCounterUpdate(Sender: TObject);
    procedure OnServiceSearchStart(Sender: TObject);
    procedure OnServiceSearchEnd(Sender: TObject);
    procedure OnServiceListNotify(Sender: TObject; const AItem: TServiceListItem;
      AAction: TCollectionNotification);
    procedure OnServiceCounterUpdate(Sender: TObject);
    procedure OnTaskSearchStart(Sender: TObject);
    procedure OnTaskSearchEnd(Sender: TObject);
    procedure OnTaskListNotify(Sender: TObject; const AItem: TTaskListItem;
      AAction: TCollectionNotification);
    procedure OnTaskCounterUpdate(Sender: TObject);
    procedure SortList(AListView: TListView);
    function ShowExportItemDialog(AItem: TRootItem): Boolean;
    procedure ShowOperationPendingUI(AIndex: Integer; AShow: Boolean);
    procedure ShowColumnDate(AListView: TListView; AShow: Boolean = True);
    procedure OnUpdate(Sender: TObject; const ANewBuild: Cardinal);
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    { IChangeLanguageListener }
    procedure LanguageChanged();
  end;

var
  Main: TMain;

implementation

{$I LanguageIDs.inc}
{$R *.dfm}

const
  SORT_ASCENDING  = 0;
  SORT_DESCENDING = 1;

{ TMain }

{ TMain.FormCreate

  VCL event that is called when form is being created. }

procedure TMain.FormCreate(Sender: TObject);
begin
  // Setup languages
  FLang := TLanguageFile.Create;

  with FLang do
  begin
    AddListener(Self);
    BuildLanguageMenu(mmLang);
  end;  //of with

  // Init update notificator
  FUpdateCheck := TUpdateCheck.Create('Clearas', FLang);

  with FUpdateCheck do
  begin
    OnUpdate := Self.OnUpdate;
  {$IFNDEF DEBUG}
    CheckForUpdate();
  {$ENDIF}
  end;  //of with

  // Init lists
  FStartup := TStartupList.Create;

  // Link search events
  with FStartup do
  begin
    OnCounterUpdate := OnStartupCounterUpdate;
    OnNotify := OnStartupListNotify;
    Images := lwStartup.SmallImages;
  end;  //of with

  FContext := TContextMenuList.Create;

  // Link search events
  with FContext do
  begin
    OnCounterUpdate := OnContextCounterUpdate;
    OnNotify := OnContextListNotify;
  end;  //of with

  FService := TServiceList.Create;

  // Link search events
  with FService do
  begin
    OnCounterUpdate := OnServiceCounterUpdate;
    OnNotify := OnServiceListNotify;
  end;  //of with

  FTasks := TTaskList.Create;

  // Link search events
  with FTasks do
  begin
    OnCounterUpdate := OnTaskCounterUpdate;
    OnNotify := OnTaskListNotify;
  end;  //of with
end;

{ TMain.FormDestroy

  VCL event that is called when form is being destroyed. }

procedure TMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTasks);
  FreeAndNil(FService);
  FreeAndNil(FContext);
  FreeAndNil(FStartup);
  FreeAndNil(FUpdateCheck);
  FreeAndNil(FLang);
end;

{ TMain.FormShow

  VCL event that is called when form is shown. }

procedure TMain.FormShow(Sender: TObject);
begin
  // Windows Vista is required as scheduled task feature is not compatible with XP
  if not CheckWin32Version(6) then
  begin
    MessageDlg(FLang[LID_INCOMPATIBLE_OS], mtWarning, [mbClose], 0);
    Close;
  end  //of begin
  else
    // Load items
    PageControlChange(Sender);
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;

begin
  CanClose := True;

  for i := 0 to PageControl.PageCount - 1 do
  begin
    // Export pending?
    if GetListForIndex(i).IsExporting then
    begin
      CanClose := (MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK, mbIgnore], 0) = idIgnore);
      Break;
    end;  //of begin
  end;
end;

{ private TMain.OnUpdate

  Event that is called by TUpdateCheck when an update is available. }

procedure TMain.OnUpdate(Sender: TObject; const ANewBuild: Cardinal);
var
  Updater: TUpdateDialog;

begin
  mmUpdate.Caption := FLang.GetString(LID_UPDATE_DOWNLOAD);

  // Ask user to permit download
  if (TaskMessageDlg(FLang.Format(LID_UPDATE_AVAILABLE, [ANewBuild]),
    FLang[LID_UPDATE_CONFIRM_DOWNLOAD], mtConfirmation, mbYesNo, 0, mbYes) = idYes) then
  begin
    Updater := TUpdateDialog.Create(Self, FLang);

    try
      with Updater do
      begin
      {$IFDEF PORTABLE}
        FileNameLocal := 'Clearas.exe';

        // Download 64-Bit version?
        if (TOSVersion.Architecture = arIntelX64) then
          FileNameRemote := 'clearas64.exe'
        else
          FileNameRemote := 'clearas.exe';
      {$ELSE}
        FileNameLocal := 'Clearas Setup.exe';
        FileNameRemote := 'clearas_setup.exe';
      {$ENDIF}
      end;  //of begin

      // Successfully downloaded update?
      if Updater.Execute() then
      begin
        mmUpdate.Caption := FLang.GetString(LID_UPDATE_SEARCH);
        mmUpdate.Enabled := False;
      {$IFNDEF PORTABLE}
        Updater.LaunchSetup();
      {$ENDIF}
      end;  //of begin

    finally
      Updater.Free;
    end;  //of try
  end;  //of begin
end;

function TMain.GetItemText(AItem: TRootItem): string;
begin
  if ((AItem.Caption <> '') and mmShowCaptions.Checked) then
    Result := AItem.Caption
  else
    Result := AItem.Name;
end;

function TMain.GetListForIndex(AIndex: Integer): TRootList<TRootItem>;
begin
  case AIndex of
    0:   Result := TRootList<TRootItem>(FStartup);
    1:   Result := TRootList<TRootItem>(FContext);
    2:   Result := TRootList<TRootItem>(FService);
    3:   Result := TRootList<TRootItem>(FTasks);
    else Result := nil;
  end;  //of case

  if not Assigned(Result) then
    raise EInvalidItem.CreateFmt('No list at index %d!', [AIndex]);
end;

function TMain.GetListViewForIndex(AIndex: Integer): TListView;
begin
  case AIndex of
    0:   Result := lwStartup;
    1:   Result := lwContext;
    2:   Result := lwService;
    3:   Result := lwTasks;
    else Result := nil;
  end;  //of case

  if not Assigned(Result) then
    raise EInvalidItem.CreateFmt('No ListView at index %d!', [AIndex]);
end;

{ private TMain.GetSelectedItem

  Returns the current selected TRootItem. }

function TMain.GetSelectedItem(): TRootItem;
var
  SelectedListView: TListView;

begin
  SelectedListView := GetSelectedListView();

  if not Assigned(SelectedListView.ItemFocused) then
    raise EInvalidItem.Create(SNoItemSelected);

  Result := TRootItem(SelectedListView.ItemFocused.SubItems.Objects[0]);

  if not Assigned(Result) then
    raise EInvalidItem.Create('No object attached!');
end;

{ private TMain.GetSelectedList

  Returns the current selected TRootList. }

function TMain.GetSelectedList(): TRootList<TRootItem>;
begin
  Result := GetListForIndex(PageControl.ActivePageIndex);
end;

{ private TMain.GetSelectedListView

  Returns the current selected TListView. }

function TMain.GetSelectedListView(): TListView;
begin
  Result := GetListViewForIndex(PageControl.ActivePageIndex);
end;

{ private TMain.Refresh

  Loads items and brings them into a TListView. }

procedure TMain.Refresh(AIndex: Integer; ATotal: Boolean = True);
var
  i: Integer;
  RootList: TRootList<TRootItem>;
  ListView: TListView;

begin
  try
    RootList := GetListForIndex(AIndex);
    ListView := GetListViewForIndex(AIndex);

    // Disable buttons
    ListView.OnSelectItem(Self, nil, False);

    // Make a total refresh or just use cached items
    if ATotal then
    begin
      // Export pending?
      if RootList.IsExporting() then
        raise EListBlocked.Create(SOperationPending);

      with TSearchThread.Create(RootList) do
      begin
        OnError := OnSearchError;
        OnListLocked := Self.OnListLocked;

        case AIndex of
          0:
            begin
              OnStart := OnStartupSearchStart;
              OnTerminate := OnStartupSearchEnd;
              ExpertMode := cbRunOnce.Checked;
              Start();
            end;

          1:
            begin
              OnStart := OnContextSearchStart;
              OnTerminate := OnContextSearchEnd;
              ExpertMode := cbContextExpert.Checked;
              Start();
            end;

          2:
            begin
              OnStart := OnServiceSearchStart;
              OnTerminate := OnServiceSearchEnd;
              ExpertMode := cbServiceExpert.Checked;
              Start();
            end;

          3:
            begin
              OnStart := OnTaskSearchStart;
              OnTerminate := OnTaskSearchEnd;
              ExpertMode := cbTaskExpert.Checked;
              Start();
            end;
        end;
      end;  //of with
    end  //of begin
    else
    begin
      ListView.Clear();

      for i := 0 to RootList.Count - 1 do
        RootList.OnNotify(Self, RootList[i], cnAdded);

      // Resort items
      SortList(ListView);
    end;  //of if

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;
  end;  //of try
end;

{ private TMain.OnContextSearchStart

  Event that is called when search starts. }

procedure TMain.OnContextSearchStart(Sender: TObject);
begin
  lwContext.Clear();
  ShowOperationPendingUI(1, True);
end;

{ private TMain.OnContextSearchEnd

  Event that is called when search ends. }

procedure TMain.OnContextSearchEnd(Sender: TObject);
begin
  SortList(lwContext);
  ShowOperationPendingUI(1, False);
end;

{ private TMain.OnContextCounterUpdate

  Event method that is called when item status has been changed. }

procedure TMain.OnContextCounterUpdate(Sender: TObject);
begin
  // Refresh counter label
  if (not (csDestroying in ComponentState) and Assigned(FContext)) then
  begin
    lwContext.Columns[1].Caption := FLang.Format(LID_CONTEXT_MENU_COUNTER,
      [FContext.EnabledItemsCount, FContext.Count]);
  end;  //of begin
end;

procedure TMain.OnContextListNotify(Sender: TObject; const AItem: TContextMenuListItem;
  AAction: TCollectionNotification);
var
  Text: string;

begin
  if (AAction = cnAdded) then
  begin
    Text := GetItemText(AItem);

    // Filter items
    if ((eContextSearch.Text = '') or
      (Text.ToLower().Contains(LowerCase(eContextSearch.Text)) or
      AItem.LocationRoot.ToLower().Contains(LowerCase(eContextSearch.Text)))) then
    begin
      with lwContext.Items.Add do
      begin
        Caption := FStatusText[AItem.Enabled];
        SubItems.AddObject(Text, AItem);
        SubItems.Append(AItem.LocationRoot);
        SubItems.Append(AItem.ToString());
      end; //of with
    end;  //of begin
  end;  //of begin
end;

{ private TMain.OnExportListStart

  Event that is called when export list starts. }

procedure TMain.OnExportListStart(Sender: TObject);
var
  Index: Integer;

begin
  Index := (Sender as TExportListThread).PageControlIndex;
  PageControl.Pages[Index].Cursor := crHourGlass;
  ShowOperationPendingUI(Index, True);
end;

procedure TMain.OnListLocked(Sender: TObject);
begin
  MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
    mtWarning, [mbOK], 0);
end;

{ private TMain.OnExportListEnd

  Event that is called when export list ends. }

procedure TMain.OnExportListEnd(Sender: TObject);
var
  Index: Integer;

begin
  Index := (Sender as TExportListThread).PageControlIndex;
  PageControl.Pages[Index].Cursor := crDefault;
  ShowOperationPendingUI(Index, False);
end;

{ private TMain.OnExportListError

  Event method that is called when export thread has failed. }

procedure TMain.OnExportListError(Sender: TObject; const AErrorMessage: string);
begin
  FLang.ShowException(FLang.GetString([LID_EXPORT, LID_IMPOSSIBLE]), AErrorMessage);
end;

{ private TMain.OnStartupCounterUpdate

  Event method that is called when item status has been changed. }

procedure TMain.OnStartupCounterUpdate(Sender: TObject);
begin
  // Refresh counter label
  if (not (csDestroying in ComponentState) and Assigned(FStartup)) then
  begin
    lwStartup.Columns[1].Caption := FLang.Format(LID_PROGRAM_COUNTER,
      [FStartup.EnabledItemsCount, FStartup.Count]);
  end;  //of begin
end;

procedure TMain.OnStartupListNotify(Sender: TObject; const AItem: TStartupListItem;
  AAction: TCollectionNotification);
var
  Text: string;

begin
  if (AAction = cnAdded) then
  begin
    Text := GetItemText(AItem);

    if ((eStartupSearch.Text = '') or (Text.ToLower().Contains(LowerCase(eStartupSearch.Text)))) then
    begin
      with lwStartup.Items.Add do
      begin
        Caption := FStatusText[AItem.Enabled];
        ImageIndex := AItem.ImageIndex;
        SubItems.AddObject(Text, AItem);
        SubItems.Append(AItem.Command);
        SubItems.Append(AItem.ToString());

        // Show deactivation timestamp?
        if mmDate.Checked then
        begin
          if (AItem.DeactivationTime <> 0) then
            SubItems.Append(DateTimeToStr(AItem.DeactivationTime))
          else
            SubItems.Append('');
        end;  //of begin
      end;  //of with
    end;  //of begin
  end;  //of begin
end;

{ private TMain.OnStartupSearchStart

  Event that is called when search starts. }

procedure TMain.OnStartupSearchStart(Sender: TObject);
begin
  lwStartup.Clear();
  ShowOperationPendingUI(0, True);
end;

{ private TMain.OnStartupSearchEnd

  Event that is called when search ends. }

procedure TMain.OnStartupSearchEnd(Sender: TObject);
begin
  SortList(lwStartup);
  ShowOperationPendingUI(0, False);
end;

{ private TMain.OnServiceCounterUpdate

  Event method that is called when item status has been changed. }

procedure TMain.OnServiceCounterUpdate(Sender: TObject);
begin
  // Refresh counter label
  if (not (csDestroying in ComponentState) and Assigned(FService)) then
  begin
    lwService.Columns[1].Caption := FLang.Format(LID_SERVICE_COUNTER,
      [FService.EnabledItemsCount, FService.Count]);
  end;  //of begin
end;

procedure TMain.OnServiceListNotify(Sender: TObject;
  const AItem: TServiceListItem; AAction: TCollectionNotification);

  function GetServiceStartCaption(AServiceStart: TServiceStart): string;
  begin
    case AServiceStart of
      ssAutomatic: Result := FLang.GetString(LID_AUTOMATICALLY);
      ssManual:    Result := FLang.GetString(LID_MANUALLY);
      else         Result := 'Service';
    end;  //of case
  end;

var
  Text: string;

begin
  if (AAction = cnAdded) then
  begin
    Text := GetItemText(AItem);

    // Filter items
    if ((eServiceSearch.Text = '') or (Text.ToLower().Contains(LowerCase(eServiceSearch.Text)))) then
    begin
      with lwService.Items.Add do
      begin
        Caption := FStatusText[AItem.Enabled];
        SubItems.AddObject(Text, AItem);
        SubItems.Append(AItem.Command);
        SubItems.Append(GetServiceStartCaption(AItem.Start));

        // Show deactivation timestamp?
        if mmDate.Checked then
        begin
          if (AItem.DeactivationTime <> 0) then
            SubItems.Append(DateTimeToStr(AItem.DeactivationTime))
          else
            SubItems.Append('');
        end;  //of begin
      end;  //of with
    end;  //of begin
  end;  //of begin
end;

{ private TMain.OnServiceSearchStart

  Event that is called when search starts. }

procedure TMain.OnServiceSearchStart(Sender: TObject);
begin
  lwService.Clear();
  ShowOperationPendingUI(2, True);
end;

{ private TMain.OnServiceSearchEnd

  Event that is called when search ends. }

procedure TMain.OnServiceSearchEnd(Sender: TObject);
begin
  SortList(lwService);
  ShowOperationPendingUI(2, False);
end;

{ private TMain.OnSearchError

  Event method that is called when search thread has failed. }

procedure TMain.OnSearchError(Sender: TObject; const AErrorMessage: string);
begin
  FLang.ShowException(FLang.GetString([LID_REFRESH, LID_IMPOSSIBLE]), AErrorMessage);
end;

{ private TMain.OnTaskCounterUpdate

  Event method that is called when item status has been changed. }

procedure TMain.OnTaskCounterUpdate(Sender: TObject);
begin
  // Refresh counter label
  if (not (csDestroying in ComponentState) and Assigned(FTasks)) then
  begin
    lwTasks.Columns[1].Caption := FLang.Format(LID_TASKS_COUNTER, [FTasks.EnabledItemsCount,
      FTasks.Count]);
  end;  //of begin
end;

procedure TMain.OnTaskListNotify(Sender: TObject; const AItem: TTaskListItem;
  AAction: TCollectionNotification);
var
  Text: string;

begin
  if (AAction = cnAdded) then
  begin
    Text := AItem.Name;

    // Filter items
    if ((eTaskSearch.Text = '') or (Text.ToLower().Contains(LowerCase(eTaskSearch.Text)))) then
    begin
      with lwTasks.Items.Add do
      begin
        Caption := FStatusText[AItem.Enabled];
        SubItems.AddObject(Text, AItem);
        SubItems.Append(AItem.Command);
        SubItems.Append(AItem.Location);
      end; //of with
    end;  //of begin
  end;  //of begin
end;

procedure TMain.OnTaskSearchEnd(Sender: TObject);
begin
  SortList(lwTasks);
  ShowOperationPendingUI(3, False);
end;

{ private TMain.OnTaskSearchStart

  Event that is called when search starts. }

procedure TMain.OnTaskSearchStart(Sender: TObject);
begin
  lwTasks.Clear();
  ShowOperationPendingUI(3, True);
end;

{ private TMain.SetLanguage

  Updates all component captions with new language text. }

procedure TMain.LanguageChanged();
var
  i: Integer;

begin
  with FLang do
  begin
    // Cache status text
    FStatusText[False] := FLang.GetString(LID_NO);
    FStatusText[True] := FLang.GetString(LID_YES);

    // File menu labels
    mmFile.Caption := GetString(LID_FILE);

    case PageControl.ActivePageIndex of
      0,2: mmAdd.Caption := GetString(LID_STARTUP_ADD);
      1:   mmAdd.Caption := GetString(LID_CONTEXT_MENU_ADD);
      3:   mmAdd.Caption := GetString(LID_TASKS_ADD);
    end;  //of case

    mmImport.Caption := GetString(LID_IMPORT);
    mmExport.Caption := GetString(LID_EXPORT);
    mmClose.Caption := GetString(LID_QUIT);

    // Edit menu labels
    mmEdit.Caption := GetString(LID_EDIT);
    mmDeleteErasable.Caption := GetString(LID_DELETE_ERASABLE);

    // View menu labels
    mmView.Caption := GetString(LID_VIEW);
    mmRefresh.Caption := GetString(LID_REFRESH);
    mmShowCaptions.Caption := GetString(LID_DESCRIPTION_SHOW);
    mmDate.Caption := GetString(LID_DATE_OF_DEACTIVATION);
    cbRunOnce.Caption := GetString(LID_STARTUP_RUNONCE);
    mmLang.Caption := GetString(LID_SELECT_LANGUAGE);

    // Help menu labels
    mmHelp.Caption := GetString(LID_HELP);
    mmUpdate.Caption := GetString(LID_UPDATE_SEARCH);
    mmInstallCertificate.Caption := GetString(LID_CERTIFICATE_INSTALL);
    mmReport.Caption := GetString(LID_REPORT_BUG);
    mmAbout.Caption := Format(LID_ABOUT, [Application.Title]);

    // "Startup" tab TButton labels
    tsStartup.Caption := GetString(LID_STARTUP);
    bEnableStartupItem.Caption := GetString(LID_ENABLE);
    bDisableStartupItem.Caption := GetString(LID_DISABLE);
    bExportStartupItem.Caption := GetString(LID_EXPORT);
    bDeleteStartupItem.Caption := GetString(LID_DELETE);
    bCloseStartup.Caption := mmClose.Caption;

    // "Startup" tab TListView labels
    lStartup.Caption := GetString(LID_STARTUP_HEADLINE);
    lwStartup.Columns[0].Caption := GetString(LID_ENABLED);
    lwStartup.Columns[2].Caption := StripHotkey(mmFile.Caption);
    lwStartup.Columns[3].Caption := GetString(LID_KEY);

    // Date column visible?
    if (lwStartup.Columns.Count > 4) then
      lwStartup.Columns[4].Caption := GetString(LID_DATE_OF_DEACTIVATION);

    lCopy1.Hint := GetString(LID_TO_WEBSITE);
    eStartupSearch.TextHint := GetString(LID_SEARCH);

    // "Context menu" tab TButton labels
    tsContext.Caption := GetString(LID_CONTEXT_MENU);
    bEnableContextItem.Caption := bEnableStartupItem.Caption;
    bDisableContextItem.Caption := bDisableStartupItem.Caption;
    bExportContextItem.Caption := bExportStartupItem.Caption;
    bDeleteContextItem.Caption := bDeleteStartupItem.Caption;
    bCloseContext.Caption := bCloseStartup.Caption;
    cbContextExpert.Caption := GetString(LID_EXPERT_MODE);
    eContextSearch.TextHint := GetString(LID_SEARCH);

    // "Context menu" tab TListView labels
    lContext.Caption := GetString(LID_CONTEXT_MENU_HEADLINE);
    lwContext.Columns[0].Caption := lwStartup.Columns[0].Caption;
    lwContext.Columns[2].Caption := GetString(LID_LOCATION);
    lwContext.Columns[3].Caption := lwStartup.Columns[3].Caption;
    lCopy2.Hint := lCopy1.Hint;

    // "Service" tab TButton labels
    tsService.Caption := GetString(LID_SERVICES);
    lService.Caption := lStartup.Caption;
    bEnableServiceItem.Caption := bEnableStartupItem.Caption;
    bDisableServiceItem.Caption := bDisableStartupItem.Caption;
    bExportServiceItem.Caption := bExportStartupItem.Caption;
    bDeleteServiceItem.Caption := bDeleteStartupItem.Caption;
    bCloseService.Caption := bCloseStartup.Caption;
    cbServiceExpert.Caption := cbContextExpert.Caption;

    // "Service" tab TListView labels
    lwService.Columns[0].Caption := lwStartup.Columns[0].Caption;
    lwService.Columns[2].Caption := lwStartup.Columns[2].Caption;
    lwService.Columns[3].Caption := GetString(LID_SERVICE_START);

    // Date column visible?
    if (lwService.Columns.Count > 4) then
      lwService.Columns[4].Caption := GetString(LID_DATE_OF_DEACTIVATION);

    lCopy3.Hint := lCopy1.Hint;
    eServiceSearch.TextHint := eContextSearch.TextHint;

    // "Tasks" tab TButton labels
    tsTasks.Caption := GetString(LID_TASKS);
    lTasks.Caption := GetString(LID_TASKS_HEADLINE);
    bEnableTaskItem.Caption := bEnableStartupItem.Caption;
    bDisableTaskitem.Caption := bDisableStartupItem.Caption;
    bExportTaskItem.Caption := bExportStartupItem.Caption;
    bDeleteTaskItem.Caption := bDeleteStartupItem.Caption;
    bCloseTasks.Caption := bCloseStartup.Caption;
    cbTaskExpert.Caption := cbContextExpert.Caption;

    // "Tasks" tab TListView labels
    lwTasks.Columns[0].Caption := lwStartup.Columns[0].Caption;
    lwTasks.Columns[2].Caption := lwStartup.Columns[2].Caption;
    lwTasks.Columns[3].Caption := lwContext.Columns[2].Caption;
    lCopy4.Hint := lCopy1.Hint;
    eTaskSearch.TextHint := eContextSearch.TextHint;

    // Popup menu labels
    pmChangeStatus.Caption := bDisableStartupItem.Caption;
    pmExecute.Caption := GetString(LID_EXECUTE);
    pmOpenRegedit.Caption := GetString(LID_OPEN_IN_REGEDIT);
    pmOpenExplorer.Caption := GetString(LID_OPEN_IN_EXPLORER);
    pmEditPath.Caption := GetString(LID_PATH_EDIT);
    pmExport.Caption := bExportStartupItem.Caption;
    pmDelete.Caption := bDeleteStartupItem.Caption;
    pmRename.Caption := GetString(LID_RENAME);
    pmCopyLocation.Caption := GetString(LID_LOCATION_COPY);
    pmChangeIcon.Caption := GetString(LID_CONTEXT_MENU_ICON_CHANGE);
    pmDeleteIcon.Caption := GetString(LID_CONTEXT_MENU_ICON_DELETE);
    pmExtended.Caption := GetString(LID_EXTEND);
    pmProperties.Caption := GetString(LID_PROPERTIES);
  end;  //of with

  // Refresh list captions
  if Visible then
  begin
    for i := 0 to PageControl.PageCount - 1 do
      Refresh(i, False);
  end;  //of begin
end;

{ private TMain.ShowColumnDate

  Adds or removes the date of deactivation column. }

procedure TMain.ShowColumnDate(AListView: TListView; AShow: Boolean = True);
begin
  // Timestamp already shown?
  if not AShow then
  begin
    if (AListView.Columns.Count = 5) then
      AListView.Columns.Delete(4);
  end  //of begin
  else
    if (AListView.Columns.Count = 4) then
      with AListView.Columns.Add do
      begin
        Caption := FLang.GetString(LID_DATE_OF_DEACTIVATION);
        Width := 120;
        Refresh(PageControl.ActivePageIndex, False);
      end;  //of with
end;

{ private TMain.ShowExportItemDialog

  Shows a file export dialog. }

function TMain.ShowExportItemDialog(AItem: TRootItem): Boolean;
var
  FileName, Filter, DefaultExt: string;
  SelectedList: TRootList<TRootItem>;
  ContextMenuItem: TContextMenuListItem;

begin
  Result := False;

  try
    if not Assigned(AItem) then
      raise EInvalidItem.Create(SNoItemSelected);

    SelectedList := GetSelectedList();

    // Set a default file name
    if (PageControl.ActivePageIndex = 1) then
    begin
      ContextMenuItem := (AItem as TContextMenuListItem);

      if (ContextMenuItem.LocationRoot = '*') then
        FileName := ContextMenuItem.Name
      else
        if (AItem is TContextMenuShellNewItem) then
          FileName := ContextMenuItem.Name +'_'+ TContextMenuShellNewItem.CanonicalName
        else
          FileName := ContextMenuItem.Name +'_'+ ContextMenuItem.LocationRoot;
    end  //of begin
    else
      FileName := AItem.Name;

    Filter := AItem.GetExportFilter(FLang);
    DefaultExt := AItem.GetBackupExtension();
    FileName := FileName + DefaultExt;

    // Show save dialog
    if PromptForFileName(FileName, Filter, DefaultExt, StripHotkey(pmExport.Caption),
      '', True) then
    begin
      SelectedList.ExportItem(AItem, FileName);
      Result := True;
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_EXPORT, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

procedure TMain.ShowOperationPendingUI(AIndex: Integer; AShow: Boolean);
begin
  case AIndex of
    0: cbRunOnce.Enabled := not AShow;

    1:
      begin
        pbContextProgress.Visible := AShow;
        eContextSearch.Visible := not AShow;
        cbContextExpert.Enabled := not AShow;
      end;

    2:
      begin
        pbServiceProgress.Visible := AShow;
        eServiceSearch.Visible := not AShow;
        cbServiceExpert.Enabled := not AShow;
      end;

    3:
      begin
        pbTaskProgress.Visible := AShow;
        eTaskSearch.Visible := not AShow;
        cbTaskExpert.Enabled := not AShow;
      end;
  end;  //of case

  if AShow then
    GetListViewForIndex(AIndex).Cursor := crHourGlass
  else
    GetListViewForIndex(AIndex).Cursor := crDefault;
end;

procedure TMain.SortList(AListView: TListView);
begin
  if not Assigned(AListView) then
    Exit;

  if (AListView.Tag >= 0) then
    AListView.AlphaSort();

  if Assigned(AListView.ItemFocused) then
    AListView.ItemFocused.MakeVisible(False);
end;

{ public TMain.mmDeleteErasableClick

  Deletes erasable marked items. }

procedure TMain.mmDeleteErasableClick(Sender: TObject);
var
  i, Answer, ItemsDeleted: Integer;
  SelectedList: TRootList<TRootItem>;
  SelectedItem: TRootItem;
  SelectedListView: TListView;

begin
  try
    SelectedList := GetSelectedList();
    SelectedListView := GetSelectedListView();

    // No erasable items?
    if (SelectedList.ErasableItemsCount = 0) then
    begin
      MessageDlg(FLang[LID_DELETE_ERASABLE_NO_ITEMS], mtInformation, [mbOK], 0);
      Exit;
    end;  //of begin

    // Export pending?
    if SelectedList.IsExporting() then
      raise EListBlocked.Create(SOperationPending);

    ItemsDeleted := 0;

    // TListView.Items.Count is decreased when item is deleted which leads
    // to an AV if erasable items are not consecutive: Start at the end to avoid this
    for i := SelectedListView.Items.Count - 1 downto 0 do
    begin
      SelectedItem := TRootItem(SelectedListView.Items[i].SubItems.Objects[0]);

      if not SelectedItem.Erasable then
        Continue;

      // Select and show item in TListView
      SelectedListView.ItemFocused := SelectedListView.Items[i];
      SelectedListView.Selected := SelectedListView.Items[i];
      SelectedListView.Items[i].MakeVisible(False);

      // Confirm deletion of every erasable item
      Answer := TaskMessageDlg(FLang.Format([LID_ITEM_DELETE],
        [SelectedListView.Items[i].SubItems[0]]), FLang.GetString([LID_FILE_DOES_NOT_EXIST,
        LID_ITEM_ERASABLE]), mtWarning, mbYesNoCancel, 0);

      case Answer of
        mrCancel:
          Break;

        mrNo:
          Continue;

        mrYes:
          begin
            // Ask user to export item
            if (MessageDlg(FLang.GetString(LID_ITEM_DELETE_STORE), mtConfirmation,
              mbYesNo, 0, mbYes) = idYes) then
            begin
              // User clicked cancel?
              if not ShowExportItemDialog(SelectedItem) then
                Continue;
            end;  //of begin

            SelectedList.DeleteItem(SelectedItem);
            SelectedListView.Items[i].Delete();
            Inc(ItemsDeleted);

            // All eraseble items deleted?
            if (SelectedList.ErasableItemsCount = 0) then
              Break;
          end;
      end;  //of case
    end;  //of for

    MessageDlg(FLang.Format(LID_DELETE_ERASABLE_SUCCESS, [ItemsDeleted]),
      mtInformation, [mbOK], 0);

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_DELETE_ERASABLE, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

procedure TMain.WMTimer(var Message: TWMTimer);
begin
  KillTimer(Handle, Message.TimerID);
  Refresh(Message.TimerID, False);
end;

{ TMain.bDeleteItemClick

  Event method that is called when user wants to delete an item. }

procedure TMain.bDeleteItemClick(Sender: TObject);
var
  SelectedListView: TListView;
  SelectedList: TRootList<TRootItem>;
  SelectedItem: TRootItem;

begin
  try
    SelectedListView := GetSelectedListView();
    SelectedList := GetSelectedList();
    SelectedItem := GetSelectedItem();

    // Confirm deletion of item
    if (TaskMessageDlg(FLang.Format([LID_ITEM_DELETE], [SelectedListView.ItemFocused.SubItems[0]]),
      FLang.GetString([LID_ITEM_DELETE_CONFIRM1, LID_ITEM_DELETE_CONFIRM2]),
      mtWarning, mbYesNo, 0, mbNo) = idYes) then
    begin
      // Ask user to export item
      if (MessageDlg(FLang.GetString(LID_ITEM_DELETE_STORE), mtConfirmation,
        mbYesNo, 0, mbYes) = idYes) then
      begin
        // User clicked cancel?
        if not ShowExportItemDialog(SelectedItem) then
          Exit;
      end;  //of begin

      SelectedList.DeleteItem(SelectedItem);
      SelectedListView.DeleteSelected();
      SelectedListView.ItemFocused := nil;

      // Disable buttons
      SelectedListView.OnSelectItem(Self, nil, False);
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: EWarning do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_DELETE, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

{ TMain.bDisableItemClick

  Event method that is called when user wants to disable an item. }

procedure TMain.bDisableItemClick(Sender: TObject);
var
  SelectedListView: TListView;
  SelectedList: TRootList<TRootItem>;
  SelectedItem: TRootItem;

begin
  try
    SelectedListView := GetSelectedListView();
    SelectedList := GetSelectedList();
    SelectedItem := GetSelectedItem();
    SelectedList.DisableItem(SelectedItem);

    case PageControl.ActivePageIndex of
      0:
        begin
          bEnableStartupItem.Enabled := True;
          bDisableStartupItem.Enabled := False;
          pmChangeStatus.Caption := bEnableStartupItem.Caption;

          // Append deactivation timestamp if necassary
          if (mmDate.Enabled and mmDate.Checked and ((SelectedItem as TStartupListItem).DeactivationTime <> 0)) then
            lwStartup.ItemFocused.SubItems[3] := DateTimeToStr((SelectedItem as TStartupListItem).DeactivationTime);
        end;

      1:
        begin
          bEnableContextItem.Enabled := True;
          bDisableContextItem.Enabled := False;
          pmChangeStatus.Caption := bEnableContextItem.Caption;
        end;

      2:
        begin
          bEnableServiceItem.Enabled := True;
          bDisableServiceItem.Enabled := False;
          pmChangeStatus.Caption := bEnableServiceItem.Caption;

          // Append deactivation timestamp if necassary
          if (mmDate.Enabled and mmDate.Checked and ((SelectedItem as TServiceListItem).DeactivationTime <> 0)) then
            lwService.ItemFocused.SubItems[3] := DateTimeToStr((SelectedItem as TServiceListItem).DeactivationTime);
        end;

      3:
        begin
          bEnableTaskItem.Enabled := True;
          bDisableTaskitem.Enabled := False;
          pmChangeStatus.Caption := bEnableTaskItem.Caption;
        end;
    end;  //of case

    // Change item visual status
    SelectedListView.ItemFocused.Caption := FStatusText[SelectedItem.Enabled];

    // Item is erasable?
    if SelectedItem.Erasable then
    begin
      TaskMessageDlg(FLang.GetString(LID_FILE_DOES_NOT_EXIST),
        FLang.GetString(LID_ITEM_ERASABLE), mtWarning, [mbOK], 0);
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: EWarning do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_DISABLE, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

{ TMain.bEnableItemClick

  Enables currently selected item. }

procedure TMain.bEnableItemClick(Sender: TObject);
var
  SelectedListView: TListView;
  SelectedList: TRootList<TRootItem>;
  SelectedItem: TRootItem;

begin
  try
    SelectedListView := GetSelectedListView();
    SelectedList := GetSelectedList();
    SelectedItem := GetSelectedItem();
    SelectedList.EnableItem(SelectedItem);

    case PageControl.ActivePageIndex of
      0:
        begin
          bEnableStartupItem.Enabled := False;
          bDisableStartupItem.Enabled := True;
          pmChangeStatus.Caption := bDisableStartupItem.Caption;

          // Delete deactivation timestamp if necassary
          if (mmDate.Enabled and mmDate.Checked) then
            lwStartup.ItemFocused.SubItems[3] := '';
        end;

      1:
        begin
          bEnableContextItem.Enabled := False;
          bDisableContextItem.Enabled := True;
          pmChangeStatus.Caption := bDisableContextItem.Caption;
        end;

      2:
        begin
          bEnableServiceItem.Enabled := False;
          bDisableServiceItem.Enabled := True;
          pmChangeStatus.Caption := bDisableServiceItem.Caption;

          // Delete deactivation timestamp if necassary
          if (mmDate.Enabled and mmDate.Checked) then
            lwService.ItemFocused.SubItems[3] := '';
        end;

      3:
        begin
          bEnableTaskItem.Enabled := False;
          bDisableTaskitem.Enabled := True;
          pmChangeStatus.Caption := bDisableTaskitem.Caption;
        end;
    end;  //of case

    // Change item visual status
    SelectedListView.ItemFocused.Caption := FStatusText[SelectedItem.Enabled];

    // Item is erasable?
    if SelectedItem.Erasable then
    begin
      TaskMessageDlg(FLang.GetString(LID_FILE_DOES_NOT_EXIST),
        FLang.GetString(LID_ITEM_ERASABLE), mtWarning, [mbOK], 0);
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: EWarning do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_ENABLE, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

{ TMain.bExportItemClick

  Event method that is called when user wants to export an item. }

procedure TMain.bExportItemClick(Sender: TObject);
begin
  try
    ShowExportItemDialog(GetSelectedItem());

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);
  end;  //of try
end;

{ TMain.eSearchChange

  Event method that is called when user changes the search string. }

procedure TMain.eSearchChange(Sender: TObject);
begin
  if ((Sender as TButtonedEdit).Text = '') then
  begin
    (Sender as TButtonedEdit).RightButton.ImageIndex := 0;
    (Sender as TButtonedEdit).RightButton.DisabledImageIndex := 0;
    (Sender as TButtonedEdit).RightButton.HotImageIndex := 0;
    (Sender as TButtonedEdit).RightButton.PressedImageIndex := 0;
  end  //of begin
  else
  begin
    (Sender as TButtonedEdit).RightButton.ImageIndex := 1;
    (Sender as TButtonedEdit).RightButton.DisabledImageIndex := 1;
    (Sender as TButtonedEdit).RightButton.HotImageIndex := 2;
    (Sender as TButtonedEdit).RightButton.PressedImageIndex := 2;
  end;  //of if

  // Refresh TListView delayed
  SetTimer(Handle, PageControl.ActivePageIndex, 250, nil);
end;

{ TMain.eSearchRightButtonClick

  Event method that is called when user clicked on clear. }

procedure TMain.eSearchRightButtonClick(Sender: TObject);
begin
  if ((Sender as TButtonedEdit).Text <> '') then
    (Sender as TButtonedEdit).Clear();
end;

{ TMain.CustomDrawItem

  Custom drawing of erasable items. }

procedure TMain.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  // Mark erasable items
  if TRootItem(Item.SubItems.Objects[0]).Erasable then
    Sender.Canvas.Font.Color := clGray
  else
    Sender.Canvas.Font.Color := clBlack;
end;

{ TMain.lwContextDblClick

  Event method that is called when user double clicks on TListView item. }

procedure TMain.lwContextDblClick(Sender: TObject);
begin
  if bEnableContextItem.Enabled then
    bEnableContextItem.Click
  else
    if bDisableContextItem.Enabled then
      bDisableContextItem.Click;
end;

{ TMain.lwContextSelectItem

  Event method that is called when user selects an item in list. }

procedure TMain.lwContextSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  // Item selected?
  if (Selected and Assigned(Item)) then
  begin
    // Change button states
    bEnableContextItem.Enabled := not TRootItem(Item.SubItems.Objects[0]).Enabled;
    bDisableContextItem.Enabled := not bEnableContextItem.Enabled;
    bDeleteContextItem.Enabled := True;
    bExportContextItem.Enabled := True;

    // Allow popup menu
    PopupMenu.AutoPopup := True;
  end  //of begin
  else
  begin
    // Nothing selected
    lwContext.ItemFocused := nil;
    bEnableContextItem.Enabled := False;
    bDisableContextItem.Enabled := False;
    bDeleteContextItem.Enabled := False;
    bExportContextItem.Enabled := False;

    // Disallow popup menu
    PopupMenu.AutoPopup := False;
  end;
end;

{ TMain.lwServiceDblClick

  Event method that is called when user double clicks on TListView item. }

procedure TMain.lwServiceDblClick(Sender: TObject);
begin
  if bEnableServiceItem.Enabled then
    bEnableServiceItem.Click
  else
    if bDisableServiceItem.Enabled then
      bDisableServiceItem.Click;
end;

{ TMain.lwServiceSelectItem

  Event method that is called when user selects an item in list. }

procedure TMain.lwServiceSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  // Item selected?
  if (Selected and Assigned(Item)) then
  begin
    // Change button states
    bEnableServiceItem.Enabled := not TRootItem(Item.SubItems.Objects[0]).Enabled;
    bDisableServiceItem.Enabled := not bEnableServiceItem.Enabled;
    bDeleteServiceItem.Enabled := True;
    bExportServiceItem.Enabled := True;

    // Allow popup menu
    PopupMenu.AutoPopup := True;
  end  //of begin
  else
  begin
    // Nothing selected
    lwService.ItemFocused := nil;
    bEnableServiceItem.Enabled := False;
    bDisableServiceItem.Enabled := False;
    bDeleteServiceItem.Enabled := False;
    bExportServiceItem.Enabled := False;

    // Disallow popup menu
    PopupMenu.AutoPopup := False;
  end;  //of if
end;

{ TMain.lwTasksDblClick

  Event method that is called when user double clicks on TListView item. }

procedure TMain.lwTasksDblClick(Sender: TObject);
begin
  if bEnableTaskItem.Enabled then
    bEnableTaskItem.Click
  else
    if bDisableTaskitem.Enabled then
      bDisableTaskitem.Click;
end;

{ TMain.lwTasksSelectItem

  Event method that is called when user selects an item in list. }

procedure TMain.lwTasksSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  // Item selected?
  if (Selected and Assigned(Item)) then
  begin
    // Change button states
    bEnableTaskItem.Enabled := not TRootItem(Item.SubItems.Objects[0]).Enabled;
    bDisableTaskitem.Enabled := not bEnableTaskItem.Enabled;
    bDeleteTaskItem.Enabled := True;
    bExportTaskItem.Enabled := True;

    // Allow popup menu
    PopupMenu.AutoPopup := True;
  end  //of begin
  else
  begin
    // Nothing selected
    lwTasks.ItemFocused := nil;
    bEnableTaskItem.Enabled := False;
    bDisableTaskitem.Enabled := False;
    bDeleteTaskItem.Enabled := False;
    bExportTaskItem.Enabled := False;

    // Disallow popup menu
    PopupMenu.AutoPopup := False;
  end;  //of if
end;

{ TMain.ListViewColumnClick

  Event method that is called when user clicks on TListView column. }

procedure TMain.ListViewColumnClick(Sender: TObject; Column: TListColumn);
var
  List: TListView;
  Header: HWND;
  Item: THDItem;
  i: Integer;

begin
  List := (Sender as TListView);
  Header := ListView_GetHeader(List.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;

  // Remove the sort ascending flags from columns
  for i := 0 to List.Columns.Count - 1 do
  begin
    // Skip current column!
    if (i = Column.Index) then
      Continue;

    Item.Mask := HDI_FORMAT;
    Header_GetItem(Header, i, Item);
    Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN);
    Header_SetItem(Header, i, Item);
    List.Columns[i].Tag := SORT_ASCENDING;
  end;  //of begin

  // Current column
  Header_GetItem(Header, Column.Index, Item);

  // Sorted ascending?
  if (Item.fmt and HDF_SORTUP <> 0) then
  begin
    Item.fmt := Item.fmt and not HDF_SORTUP or HDF_SORTDOWN;
    Column.Tag := SORT_DESCENDING;
  end  //of begin
  else
  begin
    Item.fmt := Item.fmt and not HDF_SORTDOWN or HDF_SORTUP;
    Column.Tag := SORT_ASCENDING;
  end;  //of if

  // Include sort icon
  Header_SetItem(Header, Column.Index, Item);

  // Do the alphabetically sort
  List.Tag := Column.Index;
  List.AlphaSort();
end;

{ TMain.ListViewCompare

  Sorts a TListView column alphabetically. }

procedure TMain.ListViewCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  List: TListView;
  ColumnToSort: NativeInt;

begin
  List := (Sender as TListView);
  ColumnToSort := List.Tag;

  // Nothing to sort
  if (ColumnToSort < 0) then
    Exit;

  // Status column?
  if (ColumnToSort = 0) then
  begin
    case List.Columns[ColumnToSort].Tag of
      SORT_ASCENDING:  Compare := CompareText(Item1.Caption, Item2.Caption);
      SORT_DESCENDING: Compare := CompareText(Item2.Caption, Item1.Caption);
    end;  //of case
  end  //of begin
  else
  begin
    Data := ColumnToSort - 1;

    if (Data < List.Columns.Count - 1) then
    begin
      case List.Columns[ColumnToSort].Tag of
        SORT_ASCENDING:  Compare := CompareText(Item1.SubItems[Data], Item2.SubItems[Data]);
        SORT_DESCENDING: Compare := CompareText(Item2.SubItems[Data], Item1.SubItems[Data]);
      end;  //of case
    end;  //of begin
  end;  //of begin
end;

{ TMain.lwStartupDblClick

  Event method that is called when user double clicks on TListView item. }

procedure TMain.lwStartupDblClick(Sender: TObject);
begin
  if bEnableStartupItem.Enabled then
    bEnableStartupItem.Click
  else
    if bDisableStartupItem.Enabled then
      bDisableStartupItem.Click;
end;

{ TMain.ListViewKeyPress

  Event method that is called when user pushes a button inside TListView. }

procedure TMain.ListViewKeyPress(Sender: TObject; var Key: Char);
var
  i, StartIndex: Integer;
  List: TListView;

begin
  StartIndex := 0;
  List := (Sender as TListView);

  if not Assigned(List.ItemFocused) then
    Exit;

  // Current selected item already starts with key?
  if List.ItemFocused.SubItems[0].StartsWith(Key, True) then
    StartIndex := List.ItemFocused.Index + 1;

  // Find next item whose first char starts with key
  for i := StartIndex to List.Items.Count - 1 do
    if List.Items[i].SubItems[0].StartsWith(Key, True) then
    begin
      List.ItemIndex := i;
      List.ItemFocused := List.Items[i];
      List.ItemFocused.MakeVisible(True);
      Break;
    end;  //of begin
end;

{ TMain.lwStartupSelectItem

  Event method that is called when user selects an item in list. }

procedure TMain.lwStartupSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  // Item selected?
  if (Selected and Assigned(Item)) then
  begin
    // Change button states
    bEnableStartupItem.Enabled := not TRootItem(Item.SubItems.Objects[0]).Enabled;
    bDisableStartupItem.Enabled := not bEnableStartupItem.Enabled;
    bDeleteStartupItem.Enabled := True;
    bExportStartupItem.Enabled := True;

    // Allow popup menu
    PopupMenu.AutoPopup := True;
  end  //of begin
  else
  begin
    // Nothing selected
    lwStartup.ItemFocused := nil;
    bEnableStartupItem.Enabled := False;
    bDisableStartupItem.Enabled := False;
    bDeleteStartupItem.Enabled := False;
    bExportStartupItem.Enabled := False;

    // Disallow popup menu
    PopupMenu.AutoPopup := False;
  end;  //of if
end;

{ TMain.pmChangeStatusClick

  Popup menu entry to change the status of the current selected item. }

procedure TMain.pmChangeStatusClick(Sender: TObject);
begin
  GetSelectedListView().OnDblClick(Sender);
end;

{ TMain.pmChangeIconClick

  Popup menu entry to change the icon of the current selected shell item. }

procedure TMain.pmChangeIconClick(Sender: TObject);
var
  FileName: string;
  SelectedItem: TRootItem;

begin
  try
    // Export pending?
    if FContext.IsExporting() then
      raise EListBlocked.Create(SOperationPending);

    SelectedItem := GetSelectedItem();

    // Only icon of shell item can be changed
    if not (SelectedItem is TContextMenuShellItem) then
      Exit;

    if PromptForFileName(FileName, 'Application *.exe|*.exe|Icon *.ico|*.ico',
      '', StripHotkey(pmChangeIcon.Caption)) then
    begin
      FContext.ChangeIcon(SelectedItem as TContextMenuShellItem, '"'+ FileName +'"');
      pmDeleteIcon.Visible := True;
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: Exception do
    begin
      FLang.ShowException(FLang.GetString([LID_CONTEXT_MENU_ICON_CHANGE,
        LID_IMPOSSIBLE]), E.Message);
    end;
  end;  //of try
end;

{ TMain.pmDeleteIconClick

  Popup menu entry to delete the icon of the current selected shell item. }

procedure TMain.pmDeleteIconClick(Sender: TObject);
var
  SelectedItem: TRootItem;

begin
  try
    // Export pending?
    if FContext.IsExporting() then
      raise EListBlocked.Create(SOperationPending);

    SelectedItem := GetSelectedItem();

    // Only icon of shell item can be deleted
    if not (SelectedItem is TContextMenuShellItem) then
      Exit;

    // Show confimation
    if (MessageDlg(FLang.GetString(LID_CONTEXT_MENU_ICON_DELETE_CONFIRM),
      mtConfirmation, mbYesNo, 0) = idYes) then
    begin
      FContext.DeleteIcon(SelectedItem as TContextMenuShellItem);
      pmDeleteIcon.Visible := False;
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: Exception do
    begin
      FLang.ShowException(FLang.GetString([LID_CONTEXT_MENU_ICON_DELETE,
        LID_IMPOSSIBLE]), E.Message);
    end;
  end;  //of try
end;

{ TMain.pmOpenRegeditClick

  Opens the path of the current selected item in Explorer. }

procedure TMain.pmOpenExplorerClick(Sender: TObject);
begin
  try
    GetSelectedItem().OpenInExplorer();

  except
    on E: EWarning do
    begin
      TaskMessageDlg(FLang.GetString(LID_FILE_DOES_NOT_EXIST),
        FLang.GetString(LID_ITEM_ERASABLE), mtWarning, [mbOK], 0);
    end;

    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);
  end;  //of try
end;

{ TMain.pmOpenRegeditClick

  Opens the current selected item in RegEdit. }

procedure TMain.pmOpenRegeditClick(Sender: TObject);
var
  Item: TRootItem;

begin
  try
    Item := GetSelectedItem();

    if (Item is TRegistryItem) then
      (Item as TRegistryItem).OpenInRegEdit();

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);
  end;  //of try
end;

procedure TMain.pmPropertiesClick(Sender: TObject);
var
  ShellExecuteInfo: TShellExecuteInfo;
  SelectedItem: TRootItem;

begin
  try
    SelectedItem := GetSelectedItem();

    if (SelectedItem.Command <> '') then
    begin
      ZeroMemory(@ShellExecuteInfo, SizeOf(TShellExecuteInfo));

      with ShellExecuteInfo do
      begin
        cbSize := SizeOf(TShellExecuteInfo);
        lpVerb := 'properties';
        lpFile := PChar(SelectedItem.Command.Expand());
        nShow := SW_SHOWNORMAL;
        fMask := SEE_MASK_INVOKEIDLIST;
      end;  //of with

      if not ShellExecuteEx(@ShellExecuteInfo) then
        MessageDlg(SysErrorMessage(GetLastError()), mtError, [mbOK], 0);
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);
  end;  //of try
end;

{ TMain.pmRenameClick

  Renames the current selected item. }

procedure TMain.pmRenameClick(Sender: TObject);
var
  Name, OriginalName: string;
  Item: TRootItem;

begin
  try
    Item := GetSelectedItem();

    // The caption of startup and task items can not be renamed
    if (PageControl.ActivePageIndex in [0, 3]) then
      Name := Item.Name
    else
      Name := Item.Caption;

    OriginalName := Name;

    if InputQuery(StripHotkey(pmRename.Caption), StripHotkey(pmRename.Caption), Name) then
    begin
      // Nothing entered or nothing changed
      if ((Trim(Name) = '') or AnsiSameText(Name, OriginalName)) then
        Exit;

      GetSelectedList().RenameItem(Item, Name);

      // Names are visible instead of captions?
      if (not mmShowCaptions.Checked or (PageControl.ActivePageIndex in [1, 3])) then
        GetSelectedListView().ItemFocused.SubItems[0] := Name;
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: EAlreadyExists do
      MessageDlg(FLang.GetString(LID_ITEM_ALREADY_EXISTS), mtError, [mbOK], 0);

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_RENAME, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

procedure TMain.PopupMenuPopup(Sender: TObject);
var
  SelectedItem: TRootItem;

begin
  // OnPopup also occurs when hotkeys are pressed
  if not PopupMenu.AutoPopup then
    Exit;

  // Since this point cannot be reached when no item is selected EInvalidItem is
  // assumed not to be raised
  SelectedItem := GetSelectedItem();

  // Change text
  if SelectedItem.Enabled then
    pmChangeStatus.Caption := bDisableStartupItem.Caption
  else
    pmChangeStatus.Caption := bEnableStartupItem.Caption;

  // Disable properties if item is erasable or command is empty
  pmProperties.Enabled := (not SelectedItem.Erasable and (SelectedItem.Command <> ''));

  // Update popup menu items
  case PageControl.ActivePageIndex of
    0:
      begin
        // Startup user items are located in filesystem not in registry!
        pmOpenRegedit.Enabled := not ((SelectedItem is TStartupUserItem) and
          SelectedItem.Enabled);
        pmOpenExplorer.Enabled := True;
        pmRename.Enabled := True;
        pmDeleteIcon.Visible := False;
        pmChangeIcon.Visible := False;
        pmExtended.Visible := False;
        pmEditPath.Enabled := True;
        pmExecute.Enabled := not SelectedItem.Erasable;
      end;

    1:
      begin
        pmOpenRegedit.Enabled := True;

        // ShellNew and cascading Shell items cannot be opened in Explorer
        pmOpenExplorer.Enabled := not (SelectedItem is TContextMenuShellNewItem) and not
          (SelectedItem is TContextMenuShellCascadingItem);

        // Only Shell contextmenu items can be renamed
        pmRename.Enabled := (SelectedItem is TContextMenuShellItem);

        // Currently only icon of Shell contextmenu items can be changed
        pmChangeIcon.Visible := pmRename.Enabled;
        pmDeleteIcon.Visible := (pmRename.Enabled and (SelectedItem.IconFileName <> ''));
        pmExtended.Visible := pmRename.Enabled;
        pmExtended.Checked := (pmRename.Enabled and (SelectedItem as TContextMenuShellItem).Extended);
        pmEditPath.Enabled := (SelectedItem.Command <> '');

        // Context menu items cannot be executed
        pmExecute.Enabled := False;
      end;

    2:
      begin
        pmOpenRegedit.Enabled := True;
        pmOpenExplorer.Enabled := True;
        pmRename.Enabled := True;
        pmDeleteIcon.Visible := False;
        pmChangeIcon.Visible := False;
        pmExtended.Visible := False;
        pmEditPath.Enabled := (SelectedItem.Command <> '');
        pmExecute.Enabled := not SelectedItem.Erasable;
      end;

    3:
      begin
        pmOpenRegedit.Enabled := False;
        pmOpenExplorer.Enabled := True;
        pmRename.Enabled := True;
        pmDeleteIcon.Visible := False;
        pmChangeIcon.Visible := False;
        pmExtended.Visible := False;
        pmEditPath.Enabled := (SelectedItem.Command <> '');

        // Tasks cannot be executed when they are disabled
        pmExecute.Enabled := SelectedItem.Enabled;
      end;
  end;  //of case
end;

{ TMain.pmCopyLocationClick

  Popup menu entry to show some properties. }

procedure TMain.pmCopyLocationClick(Sender: TObject);
var
  SelectedItem: TRootItem;

begin
  try
    SelectedItem := GetSelectedItem();

    if (SelectedItem is TStartupItem) then
    begin
      with SelectedItem as TStartupItem do
        Clipboard.AsText := RootKey.ToString() +'\'+ Wow64Location
    end  //of begin
    else
      Clipboard.AsText := SelectedItem.LocationFull;

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);
  end;  //of try
end;

{ TMain.pmEditClick

  Popup menu entry to edit the path of a program. }

procedure TMain.pmEditPathClick(Sender: TObject);
var
  Path, EnteredPath: string;
  SelectedListView: TListView;
  SelectedItem: TRootItem;

begin
  try
    SelectedListView := GetSelectedListView();
    SelectedItem := GetSelectedItem();
    Path := SelectedItem.Command;

    // Show input box for editing path
    EnteredPath := InputBox(FLang.GetString(LID_PATH_EDIT),
      FLang.GetString(LID_ITEM_CHANGE_PATH), Path);

    // Nothing entered or nothing changed
    if ((Trim(EnteredPath) = '') or AnsiSameText(EnteredPath, Path)) then
      Exit;

    // Try to change the file path
    GetSelectedList().ChangeCommand(SelectedItem, EnteredPath);

    // Update icon
    if (PageControl.ActivePageIndex = 0) then
      lwStartup.ItemFocused.ImageIndex := SelectedItem.ImageIndex;

    // Update file path in TListView
    if (PageControl.ActivePageIndex <> 1) then
      SelectedListView.ItemFocused.SubItems[1] := EnteredPath;

    // Update caption
    if ((SelectedItem.Caption <> '') and mmShowCaptions.Checked) then
      SelectedListView.ItemFocused.SubItems[0] := SelectedItem.Caption;

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_PATH_EDIT, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

procedure TMain.pmExecuteClick(Sender: TObject);
begin
  try
    GetSelectedItem().Execute();

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_EXECUTE, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

procedure TMain.pmExtendedClick(Sender: TObject);
var
  SelectedItem: TRootItem;

begin
  try
    // Export pending?
    if FContext.IsExporting() then
      raise EListBlocked.Create(SOperationPending);

    SelectedItem := GetSelectedItem();

    if (SelectedItem is TContextMenuShellItem) then
      FContext.ChangeExtended(SelectedItem as TContextMenuShellItem, pmExtended.Checked);

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: Exception do
      FLang.ShowException(FLang.GetString([LID_HIDE, LID_IMPOSSIBLE]), E.Message);
  end;  //of try
end;

{ TMain.mmAddClick

  MainMenu entry to add a new item to the current selected list. }

procedure TMain.mmAddClick(Sender: TObject);
var
  FileName, Name, Args, Location: string;
  List: TStringList;
  Extended: Boolean;

begin
  if (PageControl.ActivePageIndex = 3) then
  begin
    ShellExecute(0, 'open', 'control', 'schedtasks', nil, SW_SHOWNORMAL);
    Exit;
  end;  //of begin

  // Show open dialog
  if not PromptForFileName(FileName, FLang.GetString(LID_FILTER_EXE_BAT_FILES),
    '', StripHotKey(mmAdd.Caption)) then
    Exit;

  try
    // Set default name
    Name := ChangeFileExt(ExtractFileName(FileName), '');

    // Setup special default values for new contextmenu items
    if (PageControl.ActivePageIndex = 1) then
    begin
      Name := '&'+ Name;
      Args := '"%1"';
    end;  //of begin

    // User can edit the name
    if not InputQuery(StripHotKey(mmAdd.Caption), FLang.GetString(LID_RENAME_PROMPT), Name) then
      Exit;

    if (Name = '') then
      raise EArgumentException.Create('Name must not be empty!');

    // Append optional parameters
    if not InputQuery(StripHotKey(mmAdd.Caption), FLang.GetString(LID_PARAMETERS_PROMPT), Args) then
      Exit;

    // Add startup item?
    case PageControl.ActivePageIndex of
      0: begin
           if not FStartup.Add(FileName, Args, Name) then
             raise Exception.Create('Item was not added!');
         end;

      1: begin
           List := TStringList.Create;

           try
             // Init location ComboBox
             List.CommaText := TContextMenuList.DefaultLocations +', .txt, .zip';

             // Show dialog for location selection
             if not InputCombo(FLang.GetString(LID_CONTEXT_MENU_ADD),
               FLang.GetString(LID_LOCATION) +':', List, Location,
               FLang.GetString(LID_HIDE), Extended, False) then
               Exit;

             if not FContext.Add(FileName, Args, Location, Name) then
               raise Exception.Create('Item was not added!');

             (FContext.Last as TContextMenuShellItem).Extended := Extended;

             // User choice exists for selected file extension?
             if FContext.Last.UserChoiceExists(Location) then
             begin
               // Delete user choice?
               if (TaskMessageDlg(FLang[LID_CONTEXT_MENU_USER_CHOICE_WARNING1],
                 FLang.GetString([LID_CONTEXT_MENU_USER_CHOICE_WARNING2, LID_CONTEXT_MENU_USER_CHOICE_RESET]),
                 mtConfirmation, mbYesNo, 0) = idYes) then
                 FContext.Last.DeleteUserChoice(Location);
             end;  //of begin

           finally
             List.Free;
           end;  //of try
         end;  //of if

      2: begin
           if not FService.Add(FileName, Args, Name) then
             raise Exception.Create('Item was not added!');
         end;
    end;  //of case

  except
    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: EAlreadyExists do
      MessageDlg(FLang.GetString(LID_ITEM_ALREADY_EXISTS), mtError, [mbOK], 0);

    on E: EArgumentException do
      MessageDlg(E.Message, mtError, [mbOK], 0);

    on E: Exception do
    begin
      FLang.ShowException(StripHotKey(mmAdd.Caption) + FLang.GetString(LID_IMPOSSIBLE),
        E.Message);
    end;
  end;  //of try
end;

{ TMain.mmDateClick

  MainMenu entry to add or remove the deactivation timestamp column. }

procedure TMain.mmDateClick(Sender: TObject);
var
  ListView: TListView;

begin
  case PageControl.ActivePageIndex of
    0:   ListView := lwStartup;
    2:   ListView := lwService;
    else Exit;
  end;  //of case

  if (WindowState = wsNormal) then
  begin
    if mmDate.Checked then
      Width := Width + 120
    else
      Width := Width - ListView.Columns[4].Width;
  end;  //of begin

  // Add or remove date column
  ShowColumnDate(ListView, mmDate.Checked);
end;

{ TMain.mmExportListClick

  MainMenu entry to export the complete list as .reg (backup) file. }

procedure TMain.mmExportClick(Sender: TObject);
var
  SelectedList: TRootList<TRootItem>;
  FileName, Filter, DefaultExt: string;

begin
  try
    SelectedList := GetSelectedList();

    // Export already pending?
    if SelectedList.IsExporting() then
      raise EListBlocked.Create(SOperationPending);

    Filter := SelectedList.GetExportFilter(FLang);
    DefaultExt := SelectedList.GetBackupExtension();
    FileName := PageControl.ActivePage.Caption + DefaultExt;

    // Show save dialog
    if PromptForFileName(FileName, Filter, DefaultExt, StripHotkey(mmExport.Caption),
      '', True) then
    begin
      with TExportListThread.Create(SelectedList, FileName, PageControl.ActivePageIndex) do
      begin
        OnStart := OnExportListStart;
        OnTerminate := OnExportListEnd;
        OnError := OnExportListError;
        OnListLocked := Self.OnListLocked;
        Start;
      end;  //of with
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;
  end;  //of try
end;

{ TMain.mmImportClick

  MainMenu entry to import a startup backup file. }

procedure TMain.mmImportClick(Sender: TObject);
var
  Filter, FileName: string;
  ImportableList: IImportableList;

begin
  try
    // Selected list does not support importing backups
    if not Supports(GetSelectedList(), IImportableList, ImportableList) then
      Exit;

    Filter := ImportableList.GetImportFilter(FLang);

    // Show select file dialog
    if PromptForFileName(FileName, Filter, '', StripHotkey(mmImport.Caption)) then
    begin
      if not ImportableList.ImportBackup(FileName) then
        raise EWarning.Create(FLang.GetString(LID_ITEM_ALREADY_EXISTS));
    end;  //of begin

  except
    on E: EInvalidItem do
      MessageDlg(FLang.GetString(LID_NOTHING_SELECTED), mtWarning, [mbOK], 0);

    on E: EListBlocked do
    begin
      MessageDlg(FLang.GetString([LID_OPERATION_PENDING1, LID_OPERATION_PENDING2]),
        mtWarning, [mbOK], 0);
    end;

    on E: EArgumentException do
      MessageDlg(E.Message, mtError, [mbOK], 0);

    on E: EAlreadyExists do
      MessageDlg(FLang.GetString(LID_ITEM_ALREADY_EXISTS), mtError, [mbOK], 0);

    on E: Exception do
    begin
      FLang.ShowException(FLang.GetString([LID_IMPORT, LID_IMPOSSIBLE]),
        E.Message);
    end;
  end;  //of try
end;

{ TMain.mmRefreshClick

  MainMenu entry to refresh the current shown TListView. }

procedure TMain.mmRefreshClick(Sender: TObject);
begin
  Refresh(PageControl.ActivePageIndex);
end;

{ TMain.mmShowCaptionsClick

  MainMenu entry to show captions instead of names. }

procedure TMain.mmShowCaptionsClick(Sender: TObject);
var
  i: Integer;

begin
  for i := 0 to PageControl.PageCount - 1 do
    Refresh(i, False);
end;

{ TMain.mmInstallCertificateClick

  MainMenu entry that allows to install the PM Code Works certificate. }

procedure TMain.mmInstallCertificateClick(Sender: TObject);
begin
  try
    // Certificate already installed?
    if CertificateExists() then
    begin
      MessageDlg(FLang.GetString(LID_CERTIFICATE_ALREADY_INSTALLED),
        mtInformation, [mbOK], 0);
    end  //of begin
    else
      InstallCertificate();

  except
    on E: EOSError do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

{ TMain.mmUpdateClick

  MainMenu entry that allows users to manually search for updates. }

procedure TMain.mmUpdateClick(Sender: TObject);
begin
  FUpdateCheck.NotifyNoUpdate := True;
  FUpdateCheck.CheckForUpdate();
end;

{ TMain.mmReportClick

  MainMenu entry that allows users to easily report a bug by opening the web
  browser and using the "report bug" formular. }

procedure TMain.mmReportClick(Sender: TObject);
begin
  OpenUrl(URL_CONTACT);
end;

{ TMain.mmAboutClick

  MainMenu entry that shows a info page with build number and version history. }

procedure TMain.mmAboutClick(Sender: TObject);
var
  AboutDialog: TAboutDialog;
  Description, Changelog: TResourceStream;

begin
  AboutDialog := TAboutDialog.Create(Self);
  Description := TResourceStream.Create(HInstance, RESOURCE_DESCRIPTION, RT_RCDATA);
  Changelog := TResourceStream.Create(HInstance, RESOURCE_CHANGELOG, RT_RCDATA);

  try
    AboutDialog.Title := StripHotkey(mmAbout.Caption);
    AboutDialog.Description.LoadFromStream(Description);
    AboutDialog.Changelog.LoadFromStream(Changelog);
    AboutDialog.Execute();

  finally
    Changelog.Free;
    Description.Free;
    AboutDialog.Free;
  end;  //of begin
end;

{ TMain.lCopyClick

  Opens the homepage of PM Code Works in a web browser. }

procedure TMain.lCopy1Click(Sender: TObject);
begin
  OpenUrl(URL_BASE);
end;

{ TMain.lCopyMouseEnter

  Allows a label to have the look like a hyperlink. }

procedure TMain.lCopy1MouseEnter(Sender: TObject);
begin
  with (Sender as TLabel) do
  begin
    Font.Style := Font.Style + [fsUnderline];
    Font.Color := clBlue;
    Cursor := crHandPoint;
  end;  //of with
end;

{ TMain.lCopyMouseLeave

  Allows a label to have the look of a normal label again. }

procedure TMain.lCopy1MouseLeave(Sender: TObject);
begin
  with (Sender as TLabel) do
  begin
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := clBlack;
    Cursor := crDefault;
  end;  //of with
end;

{ TMain.PageControlChange

  Event method that is called when tab is changed. }

procedure TMain.PageControlChange(Sender: TObject);
var
  SelectedList: TRootList<TRootItem>;

begin
  case PageControl.ActivePageIndex of
    0: begin
         mmAdd.Caption := FLang.GetString(LID_STARTUP_ADD);
         mmDate.Enabled := True;
         mmShowCaptions.Enabled := True;
         ShowColumnDate(lwStartup, mmDate.Checked);
       end;

    1: begin
         mmAdd.Caption := FLang.GetString(LID_CONTEXT_MENU_ADD);
         mmImport.Enabled := False;
         mmDate.Enabled := False;
         mmShowCaptions.Enabled := True;
       end;

    2: begin
         mmAdd.Caption := FLang.GetString(LID_SERVICE_ADD);
         mmDate.Enabled := True;
         mmShowCaptions.Enabled := True;
         ShowColumnDate(lwService, mmDate.Checked);
       end;

    3: begin
         mmAdd.Caption := FLang.GetString(LID_TASKS_ADD);
         mmDate.Enabled := False;
         mmShowCaptions.Enabled := False;
       end;
  end;  //of case

  SelectedList := GetSelectedList();

  // Only enable "Import" if list supports it
  mmImport.Enabled := Supports(SelectedList, IImportableList);

  // Load items dynamically
  if (SelectedList.Count = 0) then
    Refresh(PageControl.ActivePageIndex);

  // Only allow popup menu if item is focused
  PopupMenu.AutoPopup := Assigned(GetSelectedListView().ItemFocused);
end;

{ TMain.bCloseStartupClick

  Closes Clearas. }

procedure TMain.bCloseStartupClick(Sender: TObject);
begin
  Close;
end;

end.
