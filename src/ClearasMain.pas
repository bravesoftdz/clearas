{ *********************************************************************** }
{                                                                         }
{ Clearas Main Unit                                                       }
{                                                                         }
{ Copyright (c) 2011-2014 P.Meisberger (PM Code Works)                    }
{                                                                         }
{ *********************************************************************** }

unit ClearasMain;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, ComCtrls, StdCtrls, ExtCtrls,
  Dialogs, Menus, Graphics, ShellAPI, ClearasAPI, ClearasInfo, LanguageFile,
  OSUtils, Updater;

type
  { TMain }
  TMain = class(TForm, IChangeLanguageListener, IUpdateListener)
    PopupMenu: TPopupMenu;
    pmChangeStatus: TMenuItem;
    N1: TMenuItem;
    pmExport: TMenuItem;
    pmDelete: TMenuItem;
    MainMenu: TMainMenu;
    mmView: TMenuItem;
    mmRefresh: TMenuItem;
    N2: TMenuItem;
    pmProperties: TMenuItem;
    mmHelp: TMenuItem;
    mmInfo: TMenuItem;
    mmEdit: TMenuItem;
    mmContext: TMenuItem;
    mmFile: TMenuItem;
    mmExportList: TMenuItem;
    N3: TMenuItem;
    mmClose: TMenuItem;
    mmExport: TMenuItem;
    mmAdd: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    mmDate: TMenuItem;
    mmImport: TMenuItem;
    mmDelBackup: TMenuItem;
    mmStandard: TMenuItem;
    N7: TMenuItem;
    mmOptimate: TMenuItem;
    N8: TMenuItem;
    pmSearch: TMenuItem;
    N6: TMenuItem;
    mmLang: TMenuItem;
    mmGer: TMenuItem;
    mmEng: TMenuItem;
    PageControl: TPageControl;
    tsStartup: TTabSheet;
    tsContext: TTabSheet;
    lwList: TListView;
    lStartup: TLabel;
    bEnableStartupItem: TButton;
    bClose: TButton;
    bDisableStartupItem: TButton;
    bDeleteStartupItem: TButton;
    bExportStartupItem: TButton;
    lCopy1: TLabel;
    lCopy2: TLabel;
    bExportContext: TButton;
    bDeleteContext: TButton;
    bClose2: TButton;
    bDeactContext: TButton;
    bActContext: TButton;
    lwContext: TListView;
    lContext: TLabel;
    lVersion2: TLabel;
    lVersion: TLabel;
    pbLoad: TProgressBar;
    cbExpert: TCheckBox;
    lWindows2: TLabel;
    lWindows: TLabel;
    mmFra: TMenuItem;
    mmUpdate: TMenuItem;
    N9: TMenuItem;
    mmDownloadCert: TMenuItem;
    N10: TMenuItem;
    pmEdit: TMenuItem;
    mmReport: TMenuItem;
    mmRunOnce: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bDeleteStartupItemClick(Sender: TObject);
    procedure bDeleteContextClick(Sender: TObject);
    procedure bEnableStartupItemClick(Sender: TObject);
    procedure bActContextClick(Sender: TObject);
    procedure bDisableStartupItemClick(Sender: TObject);
    procedure bDeactContextClick(Sender: TObject);
    procedure bExportStartupItemClick(Sender: TObject);
    procedure bExportContextClick(Sender: TObject);
    procedure lwListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lwContextSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lwContextDblClick(Sender: TObject);
    procedure lwListDblClick(Sender: TObject);
    procedure lwListColumnClick(Sender: TObject; Column: TListColumn);  //http://www.delphipraxis.net/283-wie-kann-ich-eine-listview-sortieren.html
    procedure lwListCompare(Sender: TObject; Item1, Item2: TListItem;   //http://www.delphipraxis.net/283-wie-kann-ich-eine-listview-sortieren.html
      Data: Integer; var Compare: Integer);
    procedure pmChangeStatusClick(Sender: TObject);
    procedure pmPropertiesClick(Sender: TObject);
    procedure pmDeleteClick(Sender: TObject);
    procedure pmSearchClick(Sender: TObject);
    procedure pmEditClick(Sender: TObject);
    procedure mmImportClick(Sender: TObject);
    procedure mmRefreshClick(Sender: TObject);
    procedure mmContextClick(Sender: TObject);
    procedure mmExportListClick(Sender: TObject);
    procedure mmExportClick(Sender: TObject);
    procedure mmAddClick(Sender: TObject);
    procedure mmGerClick(Sender: TObject);
    procedure mmEngClick(Sender: TObject);
    procedure mmFraClick(Sender: TObject);
    procedure mmStandardClick(Sender: TObject);
    procedure mmOptimateClick(Sender: TObject);
    procedure mmDateClick(Sender: TObject);
    procedure mmDelBackupClick(Sender: TObject);
    procedure mmInfoClick(Sender: TObject);
    procedure mmUpdateClick(Sender: TObject);
    procedure mmDownloadCertClick(Sender: TObject);
    procedure mmReportClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure cbExpertClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lCopy1MouseLeave(Sender: TObject);
    procedure lCopy1MouseEnter(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure lCopy1Click(Sender: TObject);
  private
    FColumnToSort: Word;
    Startup: TStartupList;
    Context: TContextList;
    FLang: TLanguageFile;
    FUpdateCheck: TUpdateCheck;
    procedure AfterUpdate(Sender: TObject; ADownloadedFileName: string);
    procedure BeforeUpdate(Sender: TObject; const ANewBuild: Cardinal);
    procedure EditPath(APath: string);
    procedure OnSearchProgress(Sender: TObject; AWorkCount: Cardinal);
    procedure OnSearchStart(Sender: TObject; AWorkCountMax: Cardinal);
    procedure OnSearchEnd(Sender: TObject);
    procedure RefreshContextCounter();
    procedure RefreshStartupCounter();
    procedure SetLanguage(Sender: TObject);
    procedure ShowContextMenuEntries(ATotalRefresh: Boolean = True);
    procedure ShowRegistryExportDialog();
    procedure ShowStartupEntries(ATotalRefresh: Boolean = True);
  end;

var
  Main: TMain;

implementation

{$R *.dfm}
{$R manifest.res}

{ TMain }

{ TMain.FormCreate

  VCL event that is called when form is being created. }

procedure TMain.FormCreate(Sender: TObject);
begin
  // German language default
  FLang := TLanguageFile.Create(100, Application);
  FLang.AddListener(Self);
  SetLanguage(Self);

  // Init update notificator
  FUpdateCheck := TUpdateCheck.Create(Self, 'Clearas', FLang);

  // Check for update on startup
  FUpdateCheck.CheckForUpdate(False);

  // Init Clearas instances
  Startup := TStartupList.Create;
  Context := TContextList.Create;

  // Set title
  Caption := Application.Title + TOSUtils.GetArchitecture();
end;

{ TMain.FormDestroy

  VCL event that is called when form is being destroyed. }

procedure TMain.FormDestroy(Sender: TObject);
begin
  Context.Free;
  Startup.Free;
  FUpdateCheck.Free;
  FLang.Free;
end;

{ TMain.FormShow

  VCL event that is called when form is shown. }

procedure TMain.FormShow(Sender: TObject);
var
  windows: string;
  newWindows: Boolean;

begin
  windows := TOSUtils.GetWinVersion();
  newWindows := TOSUtils.CheckWindows();

  // Check for incompatibility
  if not (newWindows or (windows[1] in ['X','2'])) then
  begin
    Flang.MessageBox(FLang.Format(65, [windows]) + FLang.GetString(66), mtError);
    mmExportList.Enabled := False;
    mmRefresh.Enabled := False;
    mmContext.Enabled := False;
    lwList.Enabled := False;
    lwContext.Enabled := False;
    cbExpert.Enabled := False;
    Exit;
  end;  //of if

  //"Deaktivierungsdatum" nur ab Vista
  mmDate.Enabled := newWindows;

  //Pfad in Kontextmen� aktualisieren     
  mmContext.Checked := TClearas.UpdateContextPath(FLang);

  // Auslesen
  ShowStartupEntries();
end;

{ private TMain.AfterUpdate

  Event method that is called by TUpdate when download is finished. }

procedure TMain.AfterUpdate(Sender: TObject; ADownloadedFileName: string);
begin
  if (ExtractFileExt(ADownloadedFileName) <> '.reg') then
  begin
    // Caption "Search for update"
    mmUpdate.Caption := FLang.GetString(15);
    mmUpdate.Enabled := False;
  end  //of begin
  else
    mmDownloadCert.Enabled := False;
end;

{ private TMain.BeforeUpdate

  Event that is called by TUpdateCheck when TUpdateCheckThread finds an update. }

procedure TMain.BeforeUpdate(Sender: TObject; const ANewBuild: Cardinal);
begin
  // Show dialog: Ask for permitting download
  with FLang do
    if (MessageBox(SysUtils.Format(GetString(21) +^J+ GetString(22), [ANewBuild]),
      mtQuestion, True) = IDYES) then
      with TUpdate.Create(Self, FLang, FLang.GetString(24)) do
        Download('clearas.exe', 'Clearas.exe')
    else
      mmUpdate.Caption := FLang.GetString(24);
end;

{ private TMain.RefreshContextCounter

  Refreshs the counter label of context menu items. }

procedure TMain.RefreshContextCounter();
begin
  lwContext.Columns[1].Caption := FLang.Format(87, [Context.ActCount, Context.Count]);
end;

{ private TMain.RefreshStartupCounter

  Refreshs the counter label of startup items. }

procedure TMain.RefreshStartupCounter();
begin
  lwList.Columns[1].Caption := FLang.Format(88, [Startup.ActCount, Startup.Count]);
end;


procedure TMain.EditPath(APath: string);
var
  FullPath: string;

  function AddCommas(APath: string): string;
  begin
    if (APath[1] <> '"') then
       result := '"'+ APath +'"'
    else
       result := APath;
  end;

begin
  with Startup do
  begin
    FullPath := InputBox(FLang.GetString(33), FLang.GetString(54), AddCommas(APath));  //Pfad bearbeiten Dialog

    if ((FullPath = '') or (FullPath = ' '))then
      FullPath := AddCommas(APath);                                   //Fehlervermeidung: Standard-Wert

    if Item.Enabled then                                               //Item aktiviert?
      TClearas.WriteStrValue(Item.RootKey, Item.KeyPath, Item.Name, FullPath)  //neuen Pfad in REG schreiben
    else
      begin                                                           //Item deaktiviert
        TClearas.WriteStrValue(Item.RootKey, Item.KeyPath, 'Command', FullPath); //neuen Pfad in REG schreiben
        TClearas.WriteStrValue(Item.RootKey, Item.KeyPath, 'Item', Item.Name);   //Name in REG schreiben
      end;  //of if

    lwList.ItemFocused.SubItems[1] := FullPath;                        //in Liste schreiben
  end;  //of with
end;

{ private TMain.OnSearchProgress

  Event that is called when search is in progress. }

procedure TMain.OnSearchProgress(Sender: TObject; AWorkCount: Cardinal);
begin
  pbLoad.Position := AWorkCount;
end;

{ private TMain.OnSearchProgress

  Event that is called when search starts. }

procedure TMain.OnSearchStart(Sender: TObject; AWorkCountMax: Cardinal);
begin
  pbLoad.Visible := True;
  pbLoad.Max := AWorkCountMax;
end;

{ private TMain.OnSearchProgress

  Event that is called when search ends. }

procedure TMain.OnSearchEnd(Sender: TObject);
begin
  pbLoad.Visible := False;
  pbLoad.Position := 0;
end;

{ private TMain.SetLanguage

  Updates all component captions with new language text. }

procedure TMain.SetLanguage(Sender: TObject);
begin
  with FLang do
  begin
    // File menu labels
    mmFile.Caption := GetString(68);
    mmAdd.Caption := GetString(69);
    mmImport.Caption := GetString(70);
    mmExport.Caption := GetString(71);
    mmExportlist.Caption := GetString(72);
    mmClose.Caption := GetString(73);

    // Edit menu labels
    mmEdit.Caption := GetString(74);
    mmContext.Caption := GetString(75);
    mmDelBackup.Caption := GetString(76);

    // View menu labels
    mmView.Caption := GetString(20);
    mmRefresh.Caption := GetString(77);
    mmStandard.Caption := GetString(78);
    mmOptimate.Caption := GetString(79);
    mmDate.Caption := GetString(80);
    mmRunOnce.Caption := GetString(81);
    mmLang.Caption := GetString(25);

    // Help menu labels
    mmHelp.Caption := GetString(14);
    mmUpdate.Caption := GetString(15);
    mmDownloadCert.Caption := GetString(16);
    mmReport.Caption := GetString(26);
    mmInfo.Caption := GetString(17);

    // Startup tab TButton labels
    tsContext.Caption := GetString(84);
    bEnableStartupItem.Caption := GetString(93);
    bDisableStartupItem.Caption := GetString(94);
    bExportStartupItem.Caption := GetString(95);
    bDeleteStartupItem.Caption := GetString(96);
    bClose.Caption := mmClose.Caption;

    // Startup tab TListView labels
    lStartup.Caption := GetString(82);
    lwList.Columns[0].Caption := GetString(91);
    lwList.Columns[2].Caption := GetString(68);
    lwList.Columns[3].Caption := GetString(92);

    // Context menu tab TButton labels
    bActContext.Caption := bEnableStartupItem.Caption;
    bDeactContext.Caption := bDisableStartupItem.Caption;
    bExportContext.Caption := bExportStartupItem.Caption;
    bDeleteContext.Caption := bDeleteStartupItem.Caption;
    bClose2.Caption := bClose.Caption;
    cbExpert.Caption := GetString(89);
    tsStartup.Caption := GetString(83);

    // Context menu tab TListView labels
    lContext.Caption := GetString(86);
    lwContext.Columns[0].Caption := lwList.Columns[0].Caption;
    lwContext.Columns[2].Caption := GetString(90);
    lwContext.Columns[3].Caption := lwList.Columns[3].Caption;

    // Popup menu labels
    pmChangeStatus.Caption := bDisableStartupItem.Caption;
    pmSearch.Caption := GetString(34);
    pmEdit.Caption := mmEdit.Caption;
    pmExport.Caption := mmExport.Caption;
    pmDelete.Caption := bDeleteStartupItem.Caption;
    pmProperties.Caption := GetString(35);
  end;  //of with

  // Update list labels
  ShowStartupEntries(False);
  ShowContextMenuEntries(False);
end;

{ private TMain.ShowContextMenuEntries

  Loads context menu entries and brings them into a TListView. }

procedure TMain.ShowContextMenuEntries(ATotalRefresh: Boolean = True);
var
  i: Cardinal;

begin
  if not Assigned(Context) then
    Exit;

  // Clears all visual data
  lwContext.Clear();

  // Make a total refresh or just use cached items
  if ATotalRefresh then
  begin
    // Clears all data
    Context.Clear();

    // Use expert search mode?
    if cbExpert.Checked then
    begin
      // Link search events
      Context.OnSearchBegin := OnSearchStart;
      Context.OnSearch := OnSearchProgress;
      Context.OnSearchEnd := OnSearchEnd;
      Application.ProcessMessages;

      // Do the expert search!
      Context.AddEntry();
    end  //of begin
    else
      // Use default search mode
      Context.LoadContextMenus();
  end;  //of begin

  if (Context.Count > 0) then
    // Print all information about context menu entires
    for i := 0 to Context.Count -1 do
      with lwContext.Items.Add do
      begin
        Caption := Context[i].GetStatus(FLang);
        SubItems.Append(Context[i].Name);
        SubItems.Append(Context[i].Location);
        SubItems.Append(Context[i].TypeOf);
      end; //of with

  // Hide TProgressBar
  pbLoad.Visible := False;

  // Refresh counter label
  RefreshContextCounter();
end;

{ private TMain.ShowRegistryExportDialog

  Shows a .reg file export dialog. }

procedure TMain.ShowRegistryExportDialog();
var
  SaveDialog: TSaveDialog;

begin
  SaveDialog := TSaveDialog.Create(Self);

  // Set TSaveDialog options
  with SaveDialog do
  begin
    Title := FLang.GetString(95);

    // Confirm overwrite
    Options := Options + [ofOverwritePrompt];

    // Filter .reg files only
    Filter := FLang.GetString(36);
    DefaultExt := '.reg';

    // Set a default file name
    if (PageControl.ActivePage = tsStartup) then
      FileName := Startup.Item.Name + DefaultExt
    else
      FileName := Context.Item.Name +'_'+ Context.Item.Location + DefaultExt;
  end;  //of with

  try
    // User clicked "save"?
    if SaveDialog.Execute then
      if (PageControl.ActivePage = tsStartup) then
        Startup.Item.ExportItem(SaveDialog.FileName)
      else
        Context.Item.ExportItem(SaveDialog.FileName);

  finally
    SaveDialog.Free;
  end;  //of try
end;

{ private TMain.ShowStartupEntries

  Loads startup entries and brings them into a TListView. }

procedure TMain.ShowStartupEntries(ATotalRefresh: Boolean = True);
var
  i: Cardinal;

begin
  if not Assigned(Startup) then
    Exit;

  // Clears all visual data
  lwList.Clear;

  // Make a total refresh or just use cached items
  if ATotalRefresh then
  begin
    // Clears all data
    Startup.Clear();

    // Load autostart with or without special RunOnce entires
    Startup.LoadAutostart(mmRunOnce.Checked);
  end;  //of begin

  if (Startup.Count > 0) then
    // Print all information about startup entires
    for i := 0 to Startup.Count -1 do
      with lwList.Items.Add do
      begin
        Caption := Startup[i].GetStatus(FLang);
        SubItems.Append(Startup[i].Name);
        SubItems.Append(Startup[i].FilePath);
        SubItems.Append(Startup[i].TypeOf);

        // Show deactivation timestamp?
        if mmDate.Checked then
          SubItems.Append(Startup[i].Time);
      end;  //of with

  // Refresh counter label
  RefreshStartupCounter();
end;

{ TMain.bExportContextClick

  Calls the export method of current selected deactivated startup item. }

procedure TMain.bExportStartupItemClick(Sender: TObject);
begin 
  // Special .lnk file backup only for activated startup user entries!
  if (Startup.Item.Enabled and Startup.Item.StartupUser) then
  begin
    // Successfully created backup of .lnk file?
    if Startup.CreateBackup() then
    begin
      FLang.MessageBox(Flang.Format(42, [TClearas.GetBackupDir()]));
      bExportStartupItem.Enabled := False;
    end  //of with
    else
      Flang.MessageBox(43, mtError);
  end  //of begin
  else
    // Default .reg file export
    ShowRegistryExportDialog();
end;

{ TMain.bExportContextClick

  Calls the export method of current selected context menu item. }

procedure TMain.bExportContextClick(Sender: TObject);
begin
  ShowRegistryExportDialog();
end;

{ TMain.bDeleteClick

  Deletes currently selected startup item. }

procedure TMain.bDeleteStartupItemClick(Sender: TObject);
var
  DelBackup, Exported: Boolean;

begin
  // Confirm deletion of item
  if (FLang.MessageBox(FLang.Format(48, [Startup.Item.Name]) +^J
    + FLang.GetString(49) + FLang.GetString(50), mtConfirm) = IDYES) then
  begin
    // Save the DeleteBackup flag
    DelBackup := Startup.DeleteBackup;
    Exported := False;

    // Export item (last chance) only if backup does not exist?
    if (bExportStartupItem.Enabled and (FLang.MessageBox(FLang.GetString(52),
      mtQuestion) = IDYES)) then
    begin
      bExportStartupItem.Click;
      DelBackup := False;
      Exported := True;
    end;  //of begin

    // Ask: Delete old backup if a backup exists and item was not exported
    if ((not Exported) and Startup.Item.StartupUser and Startup.BackupExists) then
      Startup.DeleteBackup := (FLang.MessageBox(FLang.GetString(44), mtQuestion) = IDYES);

    try
      // Successfully deleted item physically?
      if Startup.DeleteItem() then
      begin
        // Delete item from ListView visual
        lwList.DeleteSelected();

        // Refresh counter label
        RefreshStartupCounter();
      end  //of begin
      else
        raise Exception.Create('Could not delete item!');

    except
      on E: Exception do
        FLang.MessageBox(FLang.GetString(96) + FLang.GetString(66) +^J
          + E.Message, mtError);
    end;  //of try

    // Restore the DeleteBackup flag
    Startup.DeleteBackup := DelBackup;
  end;  //of begin
end;

{ TMain.bDeleteContextClick

  Deletes currently selected context menu item. }

procedure TMain.bDeleteContextClick(Sender: TObject);
begin
  // Confirm deletion of item
  if (FLang.MessageBox(FLang.Format(85, [Context.Item.Name]) +^J
    + FLang.GetString(49) + FLang.GetString(50), mtConfirm) = IDYES) then
  begin
    // Ask to export item (last chance)?
    if (FLang.MessageBox(FLang.GetString(52), mtQuestion) = IDYES) then
      ShowRegistryExportDialog();

    try
      // Successfully deleted item physically?
      if Context.DeleteItem() then
      begin
        // Delete item from ListView visual
        lwContext.DeleteSelected();

        // Refresh counter label
        RefreshContextCounter();
      end  //of begin
      else
        raise Exception.Create('Could not delete item!');

    except
      on E: Exception do
        FLang.MessageBox(FLang.GetString(96) + FLang.GetString(66) +^J
          + E.Message, mtError);
    end;  //of try
  end;  //of begin
end;

{ TMain.bActivateClick

  Activates currently selected startup item. }

procedure TMain.bEnableStartupItemClick(Sender: TObject);
begin
  try
    // Successfully activated item?
    if Startup.ChangeItemStatus() then
    begin
      // Change item visual status
      lwList.ItemFocused.Caption := Startup.Item.GetStatus(FLang);

      // Change button states
      bEnableStartupItem.Enabled := False;
      bDisableStartupItem.Enabled := True;
      bDisableStartupItem.Default := True;
      bExportStartupItem.Enabled := not Startup.BackupExists;
      pmChangeStatus.Caption := bDisableStartupItem.Caption;

      // Delete deactivation timestamp if necassary
      if mmDate.Checked then
        lwList.ItemFocused.SubItems[3] := '';

      // Refresh counter label
      RefreshStartupCounter();
    end  //of begin
    else
      raise Exception.Create('Could not enable item!');

  except
    on E: Exception do
      FLang.MessageBox(FLang.GetString(93) + FLang.GetString(66) +^J
        + E.Message, mtError);
  end;  //of try
end;

{ TMain.bActContextClick

  Activates currently selected context menu item. }

procedure TMain.bActContextClick(Sender: TObject);
begin
  try
    // Successfully activated item?
    if Context.ChangeItemStatus() then
    begin
      // Change item visual status
      lwContext.ItemFocused.Caption := Context.Item.GetStatus(FLang);

      // Change button states
      bActContext.Enabled := False;
      bDeactContext.Enabled := True;
      bDeactContext.Default := True;
      pmChangeStatus.Caption := bDisableStartupItem.Caption;

      // Refresh counter label
      RefreshContextCounter();
    end  //of begin
    else
      raise Exception.Create('Could not enable item!');

  except
    on E: Exception do
      FLang.MessageBox(FLang.GetString(93) + FLang.GetString(66) +^J
        + E.Message, mtError);
  end;  //of try
end;

{ TMain.bDeactivateClick

  Deactivates currently selected startup item. }

procedure TMain.bDisableStartupItemClick(Sender: TObject);
begin
  try
    // Successfully deactivated item?
    if Startup.ChangeItemStatus() then
    begin
      // Change item visual status
      lwList.ItemFocused.Caption := Startup.Item.GetStatus(FLang);

      // Change button states
      bDisableStartupItem.Enabled := False;
      bEnableStartupItem.Enabled := True;
      bEnableStartupItem.Default := True;
      pmChangeStatus.Caption := bEnableStartupItem.Caption;

      // Show deactivation timestamp?
      if mmDate.Checked then
        lwList.ItemFocused.SubItems[3] := Startup.Item.Time;

      if (Startup.Item.StartupUser and not bExportStartupItem.Enabled) then
        bExportStartupItem.Enabled := True;

      // Refresh counter label
      RefreshStartupCounter();
    end  //of begin
    else
      raise Exception.Create('Could not disable item!');

  except
    on E: Exception do
      FLang.MessageBox(FLang.GetString(94) + FLang.GetString(66) +^J
        + E.Message, mtError);
  end;  //of try
end;

{ TMain.bDeactContextClick

  Deactivates currently selected context menu item. }

procedure TMain.bDeactContextClick(Sender: TObject);
begin
  try
    // Successfully deactivated item?
    if Context.ChangeItemStatus() then
    begin
      // Change item visual status
      lwContext.ItemFocused.Caption := Context.Item.GetStatus(FLang);

      // Change button states
      bDisableStartupItem.Enabled := False;
      bEnableStartupItem.Enabled := True;
      bEnableStartupItem.Default := True;
      pmChangeStatus.Caption := bEnableStartupItem.Caption;

      // Refresh counter label
      RefreshContextCounter();
    end  //of begin
    else
      raise Exception.Create('Could not disable item!');

  except
    on E: Exception do
      FLang.MessageBox(FLang.GetString(94) + FLang.GetString(66) +^J
        + E.Message, mtError);
  end;  //of try
end;

{ Selektion Events }
procedure TMain.lwListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  Index: Word;

  function IsDouble(AName: string; AStartIndex: Integer): Integer;
  var
    i, j, k: Integer;

  begin
    result := -1;
    j := 0;

    for i := AStartIndex +1 to lwList.Items.Count -1 do
      if (AName = lwList.Items.Item[i].SubItems[0]) then
         begin
         Inc(j);
         result := i;
         Break;
         end;  //of begin

    if (j = 0) then
       for k := 0 to Item.Index -1 do
         if (AName = lwList.Items.Item[k].SubItems[0]) then
            begin
            result := k;
            Break;
            end;  //of begin
  end;

begin
  if (Selected and Assigned(Item)) then         //Item selektiert?
      begin
      Index := Startup.IndexOf(Item.SubItems[0], (Item.Caption = FLang.GetString(31)));
      Startup.Item := Startup.Items[Index];    //Pointer setzen
      bClose.Default := False;

      if (Startup.Item.StartupUser and Startup.Item.Enabled and Startup.BackupExists) then
         begin
         bExportStartupItem.Enabled := False;
         pmExport.Enabled := False;
         end //of begin
      else
         begin
         bExportStartupItem.Enabled := True;
         pmExport.Enabled := True;
         end;  //of if

      bDeleteStartupItem.Enabled := True;
      pmProperties.Enabled := True;
      pmDelete.Enabled := True;

      if ((Item.SubItems[2] <> '') and ((Item.SubItems[1] = '') or
         (Item.SubItems[1] = ' '))) then     //Schl�ssel existiert und Pfad fehlt
         begin                               //...dann kann User danach suchen
         bEnableStartupItem.Enabled := False;
         bDisableStartupItem.Enabled := False;
         pmChangeStatus.Enabled := False;
         bExportStartupItem.Enabled := False;
         pmExport.Enabled := False;
         bDeleteStartupItem.Default := True;
         pmSearch.Visible := True;
         end  //of begin
      else
         begin
         if ((Item.Data = Startup.AppIndex) and (Assigned(Startup.AppIndex) or
            Assigned(Item.Data))) then     //ist Item das ge�nderte Programm?
            begin                         
            pmSearch.Visible := True;

            if pmEdit.Enabled then        //dann erlauben, den Pfad zu �ndern
               pmEdit.Visible := True;
            end  //of begin
         else
            begin
            pmSearch.Visible := False;    
            pmEdit.Visible := False;
            end;  //of if

         if (Item.SubItems[2] = '') then  //Schl�ssel fehlt
            begin
            bEnableStartupItem.Enabled := False;
            bDisableStartupItem.Enabled := False;
            bExportStartupItem.Enabled := False;
            pmExport.Enabled := False;
            pmChangeStatus.Enabled := False;
            bDeleteStartupItem.Default := True;
            end  //of begin
         else
            begin
            if (IsDouble(Item.SubItems[0], Item.Index) <> -1) then
               begin
               bEnableStartupItem.Enabled := False;
               bDisableStartupItem.Enabled := False;
               bDeleteStartupItem.Default := True;
               end  //of begin
            else
               begin
               if bDeleteStartupItem.Default then
                  bDeleteStartupItem.Default := False;

               if Startup.Item.Enabled then                       //aktiviert?
                  begin                                           //JA
                  bDeleteStartupItem.Default := False;
                  bEnableStartupItem.Enabled := False;
                  bDisableStartupItem.Enabled := True;
                  bDisableStartupItem.Default := True;
                  pmChangeStatus.Enabled := True;
                  pmChangeStatus.Caption := bDisableStartupItem.Caption;  //Beschriftung �ndern
                  end //of begin
               else
                  begin                                           //NEIN
                  bDeleteStartupItem.Default := False;
                  bEnableStartupItem.Enabled := True;
                  bDisableStartupItem.Enabled := False;
                  bEnableStartupItem.Default := True;
                  pmChangeStatus.Enabled := True;
                  pmChangeStatus.Caption := bEnableStartupItem.Caption;  //Beschriftung �ndern
                  end; //of if

               if not KeyPreview then                 //Hotkeys aktiviert?
                  KeyPreview := True;
               end; //of if
            end;  //of if
         end;  //of if
      end  //of begin
  else
    // Nothing selected?
    if not Assigned(Item) then
    begin
      if bEnableStartupItem.Enabled then
      begin
        bEnableStartupItem.Default := False;
        bEnableStartupItem.Enabled := False;
      end  //of begin
      else
        begin
          bDisableStartupItem.Default := False;
          bDisableStartupItem.Enabled := False;
        end;  //of if

      pmChangeStatus.Enabled := False;
      pmDelete.Enabled := False;
      pmExport.Enabled := False;
      pmProperties.Enabled := False;
      bExportStartupItem.Enabled := False;
      bDeleteStartupItem.Enabled := False;
      bClose.Default := True;
    end;  //of if
end;


procedure TMain.lwContextSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  Index: Word;

begin
  // Item selected?
  if (Selected and Assigned(Item)) then
      begin
      Index := Context.IndexOf(Item.SubItems[0], Item.SubItems[1]);
      Context.Item := Context.Items[Index];             //Pointer setzen
      bClose2.Default := False;
      bDeleteContext.Enabled := True;
      pmDelete.Enabled := True;
      bExportContext.Enabled := True;
      pmExport.Enabled := True;
      pmProperties.Enabled := True;
      pmProperties.Visible := (Item.SubItems[2] = 'Shell');  //Eigenschaften f�r Shell anzeigen

      if bDeletecontext.Default then
         bDeletecontext.Default := False;

      if (Item.Caption = FLang.GetString(31)) then    //aktiviert?
         begin
         bActContext.Enabled := False;                  //JA
         bDeactContext.Enabled := True;
         bDeactContext.Default := True;
         pmChangeStatus.Enabled := True;
         pmChangeStatus.Caption := bDisableStartupItem.Caption;  //Beschriftung �ndern
         end //of begin
      else
         begin                                          //NEIN
         bActContext.Enabled := True;
         bDeactContext.Enabled := False;
         bActContext.Default := True;
         pmChangeStatus.Enabled := True;
         pmChangeStatus.Caption := bEnableStartupItem.Caption;  //Beschriftung �ndern
         end; //of if
      end  //of begin
  else
     // Nothing selected?
     if not Assigned(Item) then
     begin
       if bActContext.Enabled then
       begin
         bActContext.Default := False;
         bActContext.Enabled := False;
       end  //of begin
       else
         begin
           bDeactcontext.Default := False;
           bDeactcontext.Enabled := False;
         end;  //of if

       pmChangeStatus.Enabled := False;
       pmExport.Enabled := False;
       pmDelete.Enabled := False;
       pmProperties.Enabled := False;
       bExportContext.Enabled := False;
       bDeleteContext.Enabled := False;
       bClose2.Default := True;
     end;  //of if
end;

{ TMain.lwListDblClick

  Event method that is called when user double clicks on TListView item. }

procedure TMain.lwListDblClick(Sender: TObject);
begin
  if bEnableStartupItem.Enabled then
    bEnableStartupItem.Click
  else
    if bDisableStartupItem.Enabled then
      bDisableStartupItem.Click
    else
      if bDeleteStartupItem.Enabled then
        bDeleteStartupItem.Click;
end;

{ TMain.lwContextDblClick

  Event method that is called when user double clicks on TListView item. }

procedure TMain.lwContextDblClick(Sender: TObject);
begin
  if bActContext.Default then
    bActContext.Click
  else
    if bDeactContext.Default then
      bDeactContext.Click
    else
      if bDeleteContext.Default then
        bDeleteContext.Click;
end;

{ TMain.lwListColumnClick

  Event method that is called when user clicks on TListView column. }

procedure TMain.lwListColumnClick(Sender: TObject; Column: TListColumn);
begin
  FColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

{ TMain.lwListColumnClick

  Sorts a TListView column alphabetically. }

procedure TMain.lwListCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  // Status column?
  if (FColumnToSort = 0) then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
    begin
      Data := FColumnToSort -1;

      if (Data < 3) then
        Compare := CompareText(Item1.SubItems[Data], Item2.SubItems[Data]);
    end;  //of if
end;

{ TMain.pmDeactivateClick

  Popup menu entry to deactivate an item. }

procedure TMain.pmChangeStatusClick(Sender: TObject);
begin
  if (PageControl.ActivePage = tsStartup) then
    lwListDblClick(Sender)
  else
    lwContextDblClick(Sender);
end;

{ TMain.pmDeleteClick

  Popup menu entry to delete an item. }

procedure TMain.pmDeleteClick(Sender: TObject);
begin
  if (PageControl.ActivePage = tsStartup) then
    bDeleteStartupItem.Click
  else
    bDeleteContext.Click;
end;

{ TMain.pmPropertiesClick

  Popup menu entry to show some properties. }

procedure TMain.pmPropertiesClick(Sender: TObject);
var
  Properties: string;

begin
  if (PageControl.ActivePage = tsStartup) then
    Startup.Item.GetItemInfo(Properties, FLang)
  else
    Context.Item.GetItemInfo(Properties, FLang);

  FLang.MessageBox(Properties);
end;

{ TMain.pmSearchClick

  Popup menu entry to search for a lost file path. }

procedure TMain.pmSearchClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  index: integer;

begin
  OpenDialog := TOpenDialog.Create(Self);

  // Set TOpenDialog options
  with OpenDialog do
  begin
    Title := FLang.GetString(34);
    InitialDir := '%ProgramFiles%';
    Filter := FLang.GetString(38);
  end;  //of with

  try
    // User clicked "open"
    if OpenDialog.Execute then
    begin
      // Save index to current selected list item
      index := lwList.ItemFocused.Index;

      // Write pointer to index in current item data
      lwList.ItemFocused.Data := Pointer(index);

      // Save this pointer
      Startup.AppIndex := lwList.ItemFocused.Data;

      // Let user edit the path
      EditPath(OpenDialog.FileName);

      // Select current item in list
      lwListSelectItem(Self, lwList.ItemFocused, True);

      // Enable edit once again
      pmEdit.Enabled := True;
    end;  //of begin

  finally
    OpenDialog.Free;
  end;  //of try
end;

{ TMain.pmEditClick

  Popup menu entry to edit the path of a program. }

procedure TMain.pmEditClick(Sender: TObject);
begin
  EditPath(lwList.ItemFocused.SubItems[1]);
end;

{ TMain.mmAddClick

  MainMenu entry to add a application to autostart. }

procedure TMain.mmAddClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  Name, Params: string;

begin
  OpenDialog := TOpenDialog.Create(Self);

  // Set TOpenDialog options
  with OpenDialog do
  begin
    Title := FLang.GetString(69);
    InitialDir := '%ProgramFiles%';

    // Filter .exe files
    Filter := FLang.GetString(38);
  end;  //of with

  try
    try
      // User clicked "open"?
      if OpenDialog.Execute then
      begin
        Name := '';

        if (OpenDialog.FilterIndex = 3) then
        begin
          // Set default name
          Name := TClearas.DeleteExt(ExtractFileName(OpenDialog.FileName));

          // User can edit the name
          Name := InputBox(FLang.GetString(74), FLang.GetString(97), Name);

          // Name must not be empty!
          if (Name = '') then
            Exit;

          // optional parameters
          if not InputQuery(FLang.GetString(99), FLang.GetString(98), Params) then
            Exit;
        end;  //of begin

        // Item already exists?
        if not Startup.AddProgram(OpenDialog.FileName, Name) then
          FLang.MessageBox(FLang.Format(40, [OpenDialog.FileName]), mtError)
        else
          // Update TListView
          ShowStartupEntries(False);
      end;  //of begin

    finally
      OpenDialog.Free;
    end;  //of try

  except
    FLang.MessageBox(55, mtError);
  end;  //of try
end;

{ TMain.mmImportClick

  MainMenu entry to import a startup backup file. }

procedure TMain.mmImportClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  
begin
  OpenDialog := TOpenDialog.Create(Self);

  try
    // Create Backup directory if not exists
    if not DirectoryExists(TClearas.GetBackupDir()) then
      ForceDirectories(TClearas.GetBackupDir());

    // Set TOpenDialog options
    with OpenDialog do
    begin
      Title := FLang.GetString(70);
      InitialDir := TClearas.GetBackupDir();
      Filter := Format(FLang.GetString(39), [EXT_USER, EXT_USER, EXT_COMMON, EXT_COMMON]);
    end;  //of with

    try
      // User clicked "open"?
      if OpenDialog.Execute then
        // Item already exists?
        if not Startup.ImportBackup(OpenDialog.FileName) then
          FLang.MessageBox(FLang.Format(41, [Name]), mtError)
        else
          // Update TListView
          ShowStartupEntries(False);

    finally
      OpenDialog.Free;
    end;  //of try

  except
    FLang.MessageBox(55, mtError);
  end;  //of try
end;

{ TMain.mmExportClick

  MainMenu entry to export a single item as .reg file. }

procedure TMain.mmExportClick(Sender: TObject);
begin
  if (PageControl.ActivePage = tsStartup) then
    bExportStartupItem.Click()
  else
    if (PageControl.ActivePage = tsContext) then
      bExportContext.Click()
    else
      FLang.MessageBox(FLang.GetString(95) + FLang.GetString(66) +^J
                  + FLang.GetString(53), mtWarning);
end;

{ TMain.mmExportListClick

  MainMenu entry to export the complete autostart as .reg file (for backup). }

procedure TMain.mmExportListClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;

begin
  SaveDialog := TSaveDialog.Create(Self);

  // Set TSaveDialog options
  with SaveDialog do
  begin
    Title := FLang.GetString(72);

    // Confirm overwrite
    Options := Options + [ofOverwritePrompt];

    // Filter .reg files only
    Filter := FLang.GetString(36);
    DefaultExt := '.reg';

    // Sets a default file name
    FileName := FLang.GetString(68) + DefaultExt;
  end;  //of with

  try
    // User clicked "save"?
    if SaveDialog.Execute then
      Startup.ExportList(SaveDialog.FileName);

  finally
    SaveDialog.Free;
  end;  //of try
end;

{ TMain.mmContextClick

  MainMenu entry to set or resets the flag to delete backups automatically. }

procedure TMain.mmDelBackupClick(Sender: TObject);
begin
  Startup.DeleteBackup := mmDelBackup.Checked;
end;

{ TMain.mmContextClick

  MainMenu entry to add or removes "Clearas" in the recycle bin context menu. }

procedure TMain.mmContextClick(Sender: TObject);
begin
  mmContext.Checked := TClearas.RegisterInContextMenu(mmContext.Checked);
end;

{ TMain.mmRefreshClick

  MainMenu entry to refreshe the current shown TListView. }

procedure TMain.mmRefreshClick(Sender: TObject);
begin
  if (PageControl.ActivePage = tsStartup) then
    ShowStartupEntries()
  else
    ShowContextMenuEntries();
end;

{ TMain.mmStandardClick

  MainMenu entry to resize all columns to standard size. }

procedure TMain.mmStandardClick(Sender: TObject);
begin
  if (PageControl.ActivePage = tsStartup) then
  begin
    lwList.Columns[1].Width := 125;
    lwList.Columns[2].Width := 124;
    lwList.Columns[3].Width := 80;
  end  //of begin
  else
    begin
      lwContext.Columns[1].Width := 150;
      lwContext.Columns[2].Width := 115;
      lwContext.Columns[3].Width := 65;
    end;  //of if
end;

{ TMain.mmOptimateClick

  MainMenu entry to resize all columns to fit the shown text optimal. }

procedure TMain.mmOptimateClick(Sender: TObject);
begin
  if (PageControl.ActivePage = tsStartup) then
  begin
    lwList.Columns[1].Width := ColumnTextWidth;
    lwList.Columns[2].Width := ColumnTextWidth;
    lwList.Columns[3].Width := ColumnTextWidth;
  end  //of begin
  else
    begin
      lwContext.Columns[1].Width := ColumnTextWidth;
      lwContext.Columns[2].Width := ColumnTextWidth;
    end;  //of if
end;

{ TMain.mmDateClick

  MainMenu entry to add or removes the deactivation timestamp column with
  an animation. }

procedure TMain.mmDateClick(Sender: TObject);
var
  endOf: integer;

begin
  if not (WindowState = wsMaximized) then
    lwList.Clear;

  // Timestamp already shown?
  if mmDate.Checked then
  begin
    mmDate.Checked := False;

    if (lwList.Columns.Count > 4) then
    begin
      Constraints.MinWidth := Constraints.MinWidth - lwList.Column[4].Width;
      lwList.Column[4].MinWidth := 0;
      endOf := Width - 120;

      // Animation to remove column smoothly
      repeat
        Width := Width - 1;

        if (WindowState = wsMaximized) then
          endOf := Width;

        if (lwList.Column[4].Width <= 120) then
          lwList.Column[4].Width := lwList.Column[4].Width - 1;

        Update;
        Sleep(0);
      until ((lwList.Column[4].Width <= 0) and (Width = endOf));

      // Delete column
      lwList.Columns.Delete(4);

      // Refresh counter label
      ShowStartupEntries(False);
    end;  //of if
  end  //of begin
  else
    begin
      mmDate.Checked := True;
      endOf := Width + 120;

      // Add column
      lwList.Columns.Add.Caption := FLang.GetString(80);

      if (WindowState = wsMaximized) then
        ShowStartupEntries(False);

      // Animation to add column smoothly
      repeat
        Width := Width + 1;

        if (WindowState = wsMaximized) then
          endOf := Width;

        if (lwList.Column[4].Width < 120) then
          lwList.Column[4].Width := lwList.Column[4].Width + 1;

        Update;
        Sleep(0);
      until ((lwList.Column[4].Width >= 120) and (Width = endOf));

      lwList.Column[4].MinWidth := lwList.Column[4].Width;
      lwList.Column[4].MaxWidth := lwList.Column[4].Width;
      Constraints.MinWidth := Constraints.MinWidth + lwList.Column[4].Width;

      if not (WindowState = wsMaximized) then
        ShowStartupEntries(False);
    end;  //of if
end;

{ TMain.mmGerClick

  MainMenu entry that allows to change the current language to german. }

procedure TMain.mmGerClick(Sender: TObject);
begin
  FLang.ChangeLanguage(Sender, 100);
end;

{ TMain.mmEngClick

  MainMenu entry that allows to change the current language to english. }

procedure TMain.mmEngClick(Sender: TObject);
begin
  FLang.ChangeLanguage(Sender, 300);
end;

{ TMain.mmFraClick

  MainMenu entry that allows to change the current language to french. }

procedure TMain.mmFraClick(Sender: TObject);
begin
  FLang.ChangeLanguage(Sender, 500);
end;

{ TMain.mmDownloadCertClick

  MainMenu entry that allows to download the PM Code Works certificate. }

procedure TMain.mmDownloadCertClick(Sender: TObject);
begin
  // Certificate already installed?
  if (TOSUtils.PMCertExists() and (FLang.MessageBox(FLang.GetString(27) +^J+
    FLang.GetString(28), mtQuestion) = IDYES)) then
    // Download certificate
    with TUpdate.Create(Self, FLang, FLang.GetString(16)) do
      DownloadCertificate();
end;

{ TMain.mmUpdateClick

  MainMenu entry that allows users to manually search for updates. }

procedure TMain.mmUpdateClick(Sender: TObject);
begin
  FUpdateCheck.CheckForUpdate(True);
end;

{ TMain.mmReportClick

  MainMenu entry that allows users to easily report a bug by opening the web
  browser and using the "report bug" formular. }

procedure TMain.mmReportClick(Sender: TObject);
begin
  TOSUtils.OpenUrl(URL_CONTACT);
end;

{ TMain.mmInfoClick

  MainMenu entry that shows a info page with build number and version history. }

procedure TMain.mmInfoClick(Sender: TObject);
var
  Info: TInfo;

begin
  Application.CreateForm(TInfo, Info);
  Info.ShowModal;
  Info.Free;
end;

{ TMain.lCopyClick

  Opens the homepage of PM Code Works in a web browser. }

procedure TMain.lCopy1Click(Sender: TObject);
begin
  TOSUtils.OpenUrl(URL_BASE);
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
begin
  mmExport.Enabled := True;
  mmExport.Visible := True;

  // Disable some menu items not used on context menu page
  if (PageControl.ActivePage = tsContext) then
  begin
    mmAdd.Visible := False;
    mmImport.Visible := False;
    mmExportList.Visible := False;
    mmDate.Visible := False;
    mmRunOnce.Visible := False;
    N2.Visible := False;
    pmProperties.Visible := False;

    if (Context.Count = 0) then
      ShowContextMenuEntries();
  end  //of begin
  else
  begin
    mmAdd.Visible := True;
    mmImport.Visible := True;
    mmExportList.Visible := True;
    mmDate.Visible := True;
    mmRunOnce.Visible := True;
    N2.Visible := True;
    pmProperties.Visible := True;
  end;  //of if
end;

{ TMain.cbExpertClick

  Event method that is called when user clicked on "expert mode". }

procedure TMain.cbExpertClick(Sender: TObject);
begin
  ShowContextMenuEntries();
end;

{ TMain.FormKeyDown

  Event method that is called when user presses a key. }

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Bind the "delete" key to delete methods
  if (Key = VK_DELETE) then
     if (PageControl.ActivePage = tsStartup) then
        bDeleteStartupItem.Click
     else
        if (PageControl.ActivePage = tsContext) then
           bDeleteContext.Click;
end;

{ TMain.bCloseClick

  Closes Clearas. }

procedure TMain.bCloseClick(Sender: TObject);
begin
  Close;
end;

end.