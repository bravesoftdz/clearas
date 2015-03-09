{ *********************************************************************** }
{                                                                         }
{ Clearas API Interface Unit v4.1                                         }
{                                                                         }
{ Copyright (c) 2011-2015 P.Meisberger (PM Code Works)                    }
{                                                                         }
{ *********************************************************************** }

unit ClearasAPI;

interface

uses
  Windows, Classes, SysUtils, Registry, ShlObj, ActiveX, ComObj, CommCtrl,
  ShellAPI, Contnrs, SyncObjs, StrUtils, OSUtils, LanguageFile, IniFileParser;

const
  { Registry keys }
  KEY_DEACT = 'SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\';
  KEY_DEACT_FOLDER = 'SOFTWARE\Microsoft\Shared Tools\MSConfig\startupfolder\';
  KEY_RECYCLEBIN = 'CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell';
  KEY_RUNONCE = 'SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce';
  KEY_RUNONCE32 = 'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce';
  KEY_STARTUP = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run';
  KEY_STARTUP32 = 'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run';
  KEY_REGEDIT = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit';

  { Context menu Registry subkeys }
  CM_SHELL = '\shell';
  CM_SHELLEX = '\shellex\ContextMenuHandlers';
  CM_SHELLEX_FILE = 'CLSID\%s\InProcServer32';

  { Extensions of backup files }
  EXT_COMMON = '.CommonStartup';
  EXT_USER = '.Startup';

  { Description type of startup user items }
  TYPE_COMMON = 'Startup Common';
  TYPE_COMMON_XP = 'Common Startup';
  TYPE_USER = 'Startup User';
  TYPE_USER_XP = 'Startup';

type
  { TLnkFile }
  TLnkFile = class(TObject)
  private
    FFileName, FExeFileName, FArguments, FBackupExt: string;
    function GetBackupLnk(): string;
    function GetFullPath(): string;
    function GetFullPathEscaped(): string;
  public
    constructor Create(AFileName, ABackupExtension: string); overload;
    constructor Create(AName: string; AAllUsers: Boolean); overload;
    function BackupExists(): Boolean;
    function CreateBackup(): Boolean;
    function Delete(): Boolean;
    function DeleteBackup(): Boolean;
    function Exists(): Boolean;
    class function GetBackupDir(): string;
    class function GetStartUpDir(AAllUsers: Boolean): string;
    function HasArguments(): Boolean;
    function ReadLnkFile(): Boolean;
    function WriteLnkFile(): Boolean; overload;
    function WriteLnkFile(AFileName, AExeFileName: string;
      AArguments: string = ''): Boolean; overload;
    { external }
    property Arguments: string read FArguments write FArguments;
    property BackupExt: string read FBackupExt write FBackupExt;
    property BackupLnk: string read GetBackupLnk;
    property ExeFileName: string read FExeFileName write FExeFileName;
    property FileName: string read FFileName write FFileName;
    property FullPath: string read GetFullPath;
    property FullPathEscaped: string read GetFullPathEscaped;
  end;

  { TRegUtils }
  TRegUtils = class(TOSUtils)
  protected
    class function DeleteKey(ARootKey, AKeyPath, AKeyName: string): Boolean;
    class function DeleteValue(ARootKey, AKeyName, AValueName: string): Boolean;
  public
    class function GetKeyValue(ARootKey, AKeyPath, AValueName: string): string;
    class function RegisterInContextMenu(ACheck: Boolean): Boolean;
    class function UpdateContextPath(): Boolean; overload;
    class function UpdateContextPath(ALangFile: TLanguageFile): Boolean; overload; deprecated;
    class procedure WriteStrValue(ARootKey, AKeyName, AName, AValue: string);
  end;

  { Exception classes }
  EInvalidItem = class(EAccessViolation);
  EWarning = class(EAbort);

  { TRootItem }
  TRootItem = class(TObject)
  private
    FIndex: Word;
    FName, FType, FFilePath: string;
    function GetArguments(): string;
    function GetFilePath(): string;
    function GetIcon(): HICON;
  protected
    FEnabled: Boolean;
    FLocation: string;
    function DeleteQuoteChars(const APath: string): string;
    function ExtractArguments(const APath: string): string;
    function ExtractPathToFile(const APath: string): string;
    function GetFullLocation(): string; virtual; abstract;
  public
    constructor Create(AIndex: Word; AEnabled: Boolean);
    function ChangeFilePath(const ANewFilePath: string): Boolean; virtual; abstract;
    function ChangeStatus(): Boolean; virtual;
    function Delete(): Boolean; virtual; abstract;
    function Disable(): Boolean; virtual; abstract;
    function Enable(): Boolean; virtual; abstract;
    procedure ExportItem(const AFileName: string); virtual; abstract;
    function GetStatus(ALangFile: TLanguageFile): string;
    procedure OpenInExplorer();
    { external }
    property Arguments: string read GetArguments;
    property Enabled: Boolean read FEnabled;
    property FilePath: string read FFilePath write FFilePath;
    property FilePathOnly: string read GetFilePath;
    property Icon: HICON read GetIcon;
    property ItemIndex: Word read FIndex;
    property Location: string read FLocation write FLocation;
    property LocationFull: string read GetFullLocation;
    property Name: string read FName write FName;
    property TypeOf: string read FType write FType;
  end;

  { TRootRegItem }
  TRootRegItem = class(TRootItem)
  public
    procedure OpenInRegEdit(); virtual;
  end;

  { Events }
  TSearchEvent = procedure(Sender: TObject; const ACount: Cardinal) of object;

  { TRootList }
  TRootList = class(TObjectList)
  private
    FItem: TRootItem;
    FOnSearchStart, FOnSearching: TSearchEvent;
    FOnSearchFinish: TNotifyEvent;
    FOnChanged: TNotifyEvent;
  protected
    FActCount: Word;
    FLock: TCriticalSection;
    function RootItemAt(AIndex: Word): TRootItem;
  public
    constructor Create;
    destructor Destroy; override;
    function ChangeItemFilePath(const ANewFilePath: string): Boolean; virtual;
    function ChangeItemStatus(): Boolean; virtual;
    procedure Clear; override;
    function DeleteItem(): Boolean; virtual;
    function DisableItem(): Boolean; virtual;
    function EnableItem(): Boolean; virtual;
    procedure ExportItem(const AFileName: string); virtual;
    function IndexOf(const AItemName: string): Integer; overload;
    function IndexOf(AItemName: string; AEnabled: Boolean): Integer; overload;
    { external }
    property ActCount: Word read FActCount;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnSearching: TSearchEvent read FOnSearching write FOnSearching;
    property OnSearchStart: TSearchEvent read FOnSearchStart write FOnSearchStart;
    property OnSearchFinish: TNotifyEvent read FOnSearchFinish write FOnSearchFinish;
    property Selected: TRootItem read FItem write FItem;
  end;

  { Exception class }
  EStartupException = class(Exception);

  { TStartupListItem }
  TStartupListItem = class(TRootRegItem)
  private
    FRootKey, FTime: string;
    function GetTimestamp(AReg: TRegistry): string;
    procedure WriteTimestamp(AReg: TRegistry);
  protected
    function GetFullLocation(): string; override;
  public
    function ChangeFilePath(const ANewFilePath: string): Boolean; override;
    procedure ExportItem(const AFileName: string); override;
    { external }
    property RootKey: string read FRootKey write FRootKey;
    property Time: string read FTime write FTime;
  end;

  { TStartupItem }
  TStartupItem = class(TStartupListItem)
  public
    function Delete(): Boolean; override;
    function Disable(): Boolean; override;
    function Enable(): Boolean; override;
  end;

  { TStartupUserItem }
  TStartupUserItem = class(TStartupListItem)
  private
    FLnkFile: TLnkFile;
    function AddCircumflex(const AName: string): string;
  protected
    function GetFullLocation(): string; override;
  public
    destructor Destroy; override;
    function ChangeFilePath(const ANewFilePath: string): Boolean; override;
    function Delete(): Boolean; override;
    function Disable(): Boolean; override;
    function Enable(): Boolean; override;
    procedure ExportItem(const AFileName: string); override;
    { external }
    property LnkFile: TLnkFile read FLnkFile write FLnkFile;
  end;

  { TStartupList }
  TStartupList = class(TRootList)
  private
    FDeleteBackup: Boolean;
    function DeleteBackupFile(): Boolean;
    function ItemAt(AIndex: Word): TStartupListItem;
    function GetSelectedItem(): TStartupListItem;
    function GetStartupUserType(const AKeyPath: string): string; overload;
    function GetStartupUserType(AAllUsers: Boolean): string; overload;
  protected
    function AddItemDisabled(AReg: TRegistry): Integer;
    function AddItemEnabled(const ARootKey, AKeyPath, AName,
      AFileName: string): Integer;
    function AddNewStartupUserItem(AName, AFilePath: string;
      AArguments: string = ''; AAllUsers: Boolean = False): Boolean;
    function AddUserItemDisabled(AReg: TRegistry): Integer;
    function AddUserItemEnabled(ALnkFile: TLnkFile; AAllUsers: Boolean): Integer;
  public
    constructor Create;
    function AddProgram(AFileName, AArguments: string;
      ADisplayedName: string = ''): Boolean;
    function BackupExists(): Boolean;
    function ChangeItemStatus(): Boolean; override;
    function DeleteItem(): Boolean; override;
    function EnableItem(): Boolean; override;
    procedure ExportList(const AFileName: string);
    function ImportBackup(const AFileName: string): Boolean;
    procedure LoadDisabled(AStartupUser: Boolean);
    procedure LoadEnabled(AAllUsers: Boolean); overload;
    procedure LoadEnabled(const ARootKey, AKeyPath: string); overload;
    procedure LoadStartup(AIncludeRunOnce: Boolean);
    { external }
    property DeleteBackup: Boolean read FDeleteBackup write FDeleteBackup;
    property Item: TStartupListItem read GetSelectedItem;
    property Items[AIndex: Word]: TStartupListItem read ItemAt; default;
  end;

  { Alias class }
  TAutostart = TStartupList;

  { Exception class }
  EContextMenuException = class(Exception);

  { TContextListItem }
  TContextListItem = class(TRootRegItem)
  private
    FCaption: string;
    function GetKeyPath(): string; virtual; abstract;
  protected
    function GetFullLocation(): string; override;
  public
    function Delete(): Boolean; override;
    procedure ExportItem(const AFileName: string); override;
    { external }
    property Caption: string read FCaption write FCaption;
    property Location: string read GetKeyPath;
    property LocationRoot: string read FLocation write FLocation;
  end;

  { TShellItem }
  TShellItem = class(TContextListItem)
  private
    function GetKeyPath(): string; override;
  public
    function ChangeFilePath(const ANewFilePath: string): Boolean; override;
    function Disable(): Boolean; override;
    function Enable(): Boolean; override;
  end;

  { TShellExItem }
  TShellExItem = class(TContextListItem)
  private
    function GetKeyPath(): string; override;
    function GetProgramPathKey(): string;
  public
    function ChangeFilePath(const ANewFilePath: string): Boolean; override;
    function Disable(): Boolean; override;
    function Enable(): Boolean; override;
  end;

  { TContextList }
  TContextList = class(TRootList)
  private
    function GetSelectedItem(): TContextListItem;
    function ItemAt(AIndex: Word): TContextListItem;
  protected
    function AddShellItem(const AName, ALocationRoot, AFilePath, ACaption: string;
      AEnabled: Boolean): Integer;
    function AddShellExItem(const AName, ALocationRoot, AFilePath: string;
      AEnabled: Boolean): Integer;
  public
    constructor Create;
    function AddEntry(const AFilePath, AArguments, ALocationRoot,
      ADisplayedName: string): Boolean;
    procedure ExportList(const AFileName: string);
    function IndexOf(AName, ALocationRoot: string): Integer; overload;
    procedure LoadContextmenu(const ALocationRoot: string); overload;
    procedure LoadContextmenu(const ALocationRoot: string;
      ASearchForShellItems: Boolean); overload;
    procedure LoadContextMenus(ALocationRootCommaList: string = '');
    { external }
    property Item: TContextListItem read GetSelectedItem;
    property Items[AIndex: Word]: TContextListItem read ItemAt; default;
  end;


implementation

uses StartupSearchThread, ContextSearchThread;

{ TLnkFile }

{ public TLnkFile.Create

  Constructor for creating a TLnkFile instance. }

constructor TLnkFile.Create(AFileName, ABackupExtension: string);
begin
  inherited Create;
  FFileName := AFileName;
  FBackupExt := ABackupExtension;
end;

{ public TLnkFile.Create

  Constructor for creating a TLnkFile instance. }

constructor TLnkFile.Create(AName: string; AAllUsers: Boolean);
begin
  inherited Create;
  FFileName := GetStartUpDir(AAllUsers) + AName;

  if AAllUsers then
    FBackupExt := EXT_COMMON
  else
    FBackupExt := EXT_USER;
end;

{ private TLnkFile.GetBackupLnk

  Returns the absoulte path to the backup lnk file. }

function TLnkFile.GetBackupLnk(): string;
begin
  Result := GetBackupDir() + ExtractFileName(FFileName) + FBackupExt;
end;

{ private TLnkFile.GetFullPath

  Returns the concatenation of file name and arguments. }

function TLnkFile.GetFullPath(): string;
begin
  if HasArguments() then
    Result := FExeFileName +' '+ FArguments
  else
    Result := FExeFileName;
end;

{ private TLnkFile.GetFullPathEscaped

  Returns the concatenation of file name and arguments escaped with quotes. }

function TLnkFile.GetFullPathEscaped(): string;
begin
  if HasArguments() then
    Result := '"'+ FFileName +'" '+ FArguments
  else
    Result := '"'+ FFileName +'"';
end;

{ public TLnkFile.BackupExists

  Returns True if the backup .lnk file in C:\Windows\pss\ exists. }

function TLnkFile.BackupExists(): Boolean;
begin
  Result := FileExists(GetBackupLnk());
end;

{ public TLnkFile.CreateBackup

  Creates a backup .lnk file in C:\Windows\pss\. }

function TLnkFile.CreateBackup(): Boolean;
begin
  Result := WriteLnkFile(GetBackupLnk(), FExeFileName, FArguments);
end;

{ public TLnkFile.Delete

  Deletes the .lnk file. }

function TLnkFile.Delete(): Boolean;
begin
  Result := DeleteFile(FFileName);
end;

{ public TLnkFile.DeleteBackup

  Deletes the backup .lnk file. }

function TLnkFile.DeleteBackup(): Boolean;
begin
  Result := DeleteFile(GetBackupLnk());
end;

{ public TLnkFile.Exists

  Returns True if the .lnk file exists. }

function TLnkFile.Exists(): Boolean;
begin
  Result := FileExists(FFileName);
end;

{ public TLnkFile.GetBackupDir

  Returns the path to the backup directory. }

class function TLnkFile.GetBackupDir(): string;
begin
  Result := TOSUtils.GetWinDir +'\pss\';
end;

{ public TLnkFile.GetStartUpDir

  Returns the file system startup location of current user or all. }

class function TLnkFile.GetStartUpDir(AAllUsers: Boolean): string;
var
  ItemIDs: PItemIDList;
  Path: PChar;
  Folder: Cardinal;

begin
  if AAllUsers then
    Folder := CSIDL_COMMON_STARTUP
  else
    Folder := CSIDL_STARTUP;

  if Succeeded(SHGetSpecialFolderLocation(0, Folder, ItemIDs)) then
  begin
    Path := StrAlloc(MAX_PATH);
    SHGetPathFromIDList(ItemIDs, Path);
    Result := IncludeTrailingBackslash(string(Path));
  end  //of begin
  else
    Result := '';
end;

{ public TLnkFile.HasArguments

  Returns if arguments are specified. }

function TLnkFile.HasArguments(): Boolean;
begin
  Result := (FArguments <> '');
end;

{ public TLnkFile.ReadLnkFile

  Reads the .exe file path and arguments from a .lnk file. }

function TLnkFile.ReadLnkFile(): Boolean;
var
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  FileInfo: TWin32FindData;
  Path, Arguments: string;

begin
  Result := False;

  try
    CoInitialize(nil);

    if Succeeded(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
      IShellLink, ShellLink)) then
    begin
      PersistFile := (ShellLink as IPersistFile);

      // Try to .lnk read file
      if Succeeded(PersistFile.Load(StringToOleStr(FFileName), STGM_READ)) then
        with ShellLink do
        begin
          SetLength(Path, MAX_PATH + 1);

          // Try to read path from .lnk
          if Succeeded(GetPath(PChar(Path), MAX_PATH, FileInfo, SLR_ANY_MATCH)) then
          begin
            FExeFileName := PChar(Path);
            SetLength(Arguments, MAX_PATH + 1);

            // Try to read arguments from .lnk file
            if Succeeded(GetArguments(PChar(Arguments), MAX_PATH)) then
              FArguments := PChar(Arguments);

            Result := True;
          end;  //of begin
        end; //of with
    end;  //of begin

  finally
    CoUninitialize();
  end;  //of try
end;

{ public TLnkFile.WriteLnkFile

  Creates a new .lnk file. }

function TLnkFile.WriteLnkFile(): Boolean;
begin
  Result := WriteLnkFile(FFileName, FExeFileName, FArguments);
end;

{ public TLnkFile.WriteLnkFile

  Creates a new .lnk file. }

function TLnkFile.WriteLnkFile(AFileName, AExeFileName: string;
  AArguments: string = ''): Boolean;
var
  ShellLink : IShellLink;
  PersistFile : IPersistFile;
  Name : PWideChar;

begin
  Result := False;

  if (AFileName = '') or (AExeFileName = '') then
    raise EStartupException.Create('File name for .lnk file must not be empty!');

  try
    CoInitialize(nil);

    if Succeeded(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_inPROC_SERVER,
      IID_IShellLinkA, ShellLink)) then
    begin
      // Set path to .exe
      ShellLink.SetPath(PChar(AExeFileName));

      // Set arguments if specified
      if (AArguments <> '') then
        ShellLink.SetArguments(PChar(AArguments));

      // Set working directory
      ShellLink.SetWorkingDirectory(PChar(ExtractFilePath(AExeFileName)));

      if Succeeded(ShellLink.QueryInterface(IPersistFile, PersistFile)) then
      begin
        GetMem(Name, MAX_PATH * 2);

        try
          // Set up information
          MultiByteToWideChar(CP_ACP, 0, PChar(AFileName), -1, Name, MAX_PATH);

          // Save .lnk
          Result := Succeeded(PersistFile.Save(Name, True));

        finally
          FreeMem(Name, MAX_PATH * 2);
        end; //of finally
      end; //of begin
    end; //of begin

  finally
    CoUninitialize();
  end;  //of try
end;


{ TRegUtils }

{ public TRegUtils.DeleteKey

  Deletes a Registry key. }

class function TRegUtils.DeleteKey(ARootKey, AKeyPath, AKeyName: string): Boolean;
var
  Reg: TRegistry;

begin
  Result := False;
  Reg := TRegistry.Create(DenyWOW64Redirection(KEY_READ or KEY_WRITE));

  try
    Reg.RootKey := StrToHKey(ARootKey);

    if not Reg.OpenKey(AKeyPath, False) then
      raise Exception.Create('Key does not exist!');

    Result := Reg.DeleteKey(AKeyName);

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TRegUtils.DeleteValue

  Deletes a Registry value. }

class function TRegUtils.DeleteValue(ARootKey, AKeyName, AValueName: string): Boolean;
var
  Reg: TRegistry;

begin
  Result := False;
  Reg := TRegistry.Create(DenyWOW64Redirection(KEY_READ or KEY_WRITE));

  try
    Reg.RootKey := StrToHKey(ARootKey);

    if not Reg.OpenKey(AKeyName, False) then
      raise Exception.Create('Key does not exist!');

    if Reg.ValueExists(AValueName) then
      Result := Reg.DeleteValue(AValueName)
    else
      Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TRegUtils.GetKeyValue

  Returns a Registry value as string. }

class function TRegUtils.GetKeyValue(ARootKey, AKeyPath, AValueName: string): string;
var
  Reg: TRegistry;

begin
  Result := '';
  Reg := TRegistry.Create(DenyWOW64Redirection(KEY_READ));

  try
    Reg.RootKey := StrToHKey(ARootKey);

    if Reg.OpenKey(AKeyPath, False) then
    begin
      // Only read if value exists (to deny exception)
      if (Reg.ValueExists(AValueName)) then
        Result := Reg.ReadString(AValueName);
    end;  //of begin

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TRegUtils.RegisterInContextMenu

  Adds or deletes "Clearas" in recycle bin context menu. }

class function TRegUtils.RegisterInContextMenu(ACheck: Boolean): Boolean;
begin
  // Checkbox not checked?
  if not ACheck then
  begin
    // Add recycle bin context menu entry
    WriteStrValue('HKCR', KEY_RECYCLEBIN +'\Clearas\command', '', ParamStr(0));
    Result := True;
  end  //of begin
  else
    // Remove recycle bin context menu entry
    Result := DeleteKey('HKCR', KEY_RECYCLEBIN, 'Clearas');
end;

{ public TRegUtils.UpdateContextPath

  Updates "Open Clearas" in recycle bin context menu. }

class function TRegUtils.UpdateContextPath(): Boolean;
var
  Reg: TRegistry;

begin
  Reg := TRegistry.Create(DenyWOW64Redirection(KEY_WRITE));
  Reg.RootKey := HKEY_CLASSES_ROOT;

  try
    // Only update if context menu entry exists
    if Reg.OpenKey(KEY_RECYCLEBIN +'\Clearas\command', False) then
    begin
      Reg.WriteString('', ParamStr(0));
      Result := True;
    end  //of begin
    else
      Result := False;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TRegUtils.UpdateContextPath

  Updates "Open Clearas" in recycle bin context menu. }

class function TRegUtils.UpdateContextPath(ALangFile: TLanguageFile): Boolean;
var
  Reg: TRegistry;
  ClearasKey: string;

begin
  Reg := TRegistry.Create(DenyWOW64Redirection(KEY_ALL_ACCESS));
  Reg.RootKey := HKEY_CLASSES_ROOT;

  try
    Reg.OpenKey(KEY_RECYCLEBIN, False);
    ClearasKey := ALangFile.GetString(37);

    // Only update if context menu entry exists
    if Reg.KeyExists(ClearasKey) then
    begin
      // Delete old context menu key
      if not Reg.DeleteKey(ClearasKey) then
        raise Exception.Create('Could not delete key: '+ ClearasKey);
    end;  //of begin

  finally
    Reg.CloseKey();
    Reg.Free;
    Result := UpdateContextPath();
  end;  //of try
end;

{ public TRegUtils.WriteStrValue

  Writes a string value to Registry }

class procedure TRegUtils.WriteStrValue(ARootKey, AKeyName, AName, AValue: string);
var
  Reg: TRegistry;

begin
  Reg := TRegistry.Create(DenyWOW64Redirection(KEY_WRITE));

  try
    try
      Reg.RootKey := StrToHKey(ARootKey);

      if not Reg.OpenKey(AKeyName, True) then
        raise Exception.Create('Could not open key!');

      Reg.WriteString(AName, AValue);

    finally
      Reg.CloseKey();
      Reg.Free;
    end;  //of try

  except
    on E: Exception do
    begin
      E.Message := 'Error while writing Registry value "'+ AName +'" : '+ E.Message;
      raise;
    end;  //of begin
  end;  //of try
end;


{ TRootItem }

{ public TRootItem.Create

  General constructor for creating a TRootItem instance. }

constructor TRootItem.Create(AIndex: Word; AEnabled: Boolean);
begin
  inherited Create;
  FIndex := AIndex;
  FEnabled := AEnabled;
end;

{ private TRootItem.GetArguments

  Returns the arguments of the item file path. }

function TRootItem.GetArguments(): string;
begin
  Result := DeleteQuoteChars(ExtractArguments(FFilePath));
end;

{ private TRootItem.GetFilePath

  Returns only the file path (without arguments) of the item. }

function TRootItem.GetFilePath(): string;
begin
  Result := DeleteQuoteChars(ExtractPathToFile(FFilePath));
end;

{ private TRootItem.GetIcon

  Returns the icon handle to the item file path. }

function TRootItem.GetIcon(): HICON;
var
  FileInfo: SHFILEINFO;
  Win64: Boolean;

begin
  Win64 := TOSUtils.IsWindows64();
  
  // Deny WOW64 redirection only on 64bit Windows
  if Win64 then
    TOSUtils.Wow64FsRedirection(True);

  if Succeeded(SHGetFileInfo(PChar(GetFilePath()), 0, FileInfo, SizeOf(FileInfo),
    SHGFI_ICON or SHGFI_SMALLICON)) then
    Result := FileInfo.hIcon
  else
    Result := 0;

  // Allow WOW64 redirection only on 64bit Windows
  if Win64 then
    TOSUtils.Wow64FsRedirection(False);
end;

{ protected TRootItem.DeleteQuoteChars

  Deletes quote chars from a file path. }

function TRootItem.DeleteQuoteChars(const APath: string): string;
begin
  Result := StringReplace(APath , '"', '', [rfReplaceAll]);
end;

{ protected TRootItem.ExtractArguments

  Extracts the arguments from a file path. }

function TRootItem.ExtractArguments(const APath: string): string;
var
  ExtWithArguments: string;
  SpaceDelimiter: Integer;

begin
  // Cut path from extension until end
  ExtWithArguments := ExtractFileExt(APath);

  // Find space delimter between extension and arguments
  SpaceDelimiter := AnsiPos(' ', ExtWithArguments);

  // No space char after extension: no arguments!
  if (SpaceDelimiter = 0) then
    Exit;

  // Copy arguments without entension and space char at front and end
  Result := Trim(Copy(ExtWithArguments, SpaceDelimiter, Length(ExtWithArguments)));
end;

{ protected TRootItem.ExtractPathToFile

  Extracts the absolute file path + name without arguments from a path. }

function TRootItem.ExtractPathToFile(const APath: string): string;
var
  ArgumentsIndex: Integer;

begin
  // Find index of arguments
  ArgumentsIndex := AnsiPos(ExtractArguments(APath), APath);

  // Copy path without arguments
  if (ArgumentsIndex > 0) then
    Result := Trim(Copy(APath, 0, ArgumentsIndex - 1))
  else
    Result := APath;

  // Add missing quote
  if ((Result = '"') and (Result[Length(Result)] <> '"')) then
    Result := Result +'"';
end;

{ public TRootItem.ChangeStatus

  Changes the item status. }

function TRootItem.ChangeStatus(): Boolean;
begin
  if FEnabled then
    Result := Disable()
  else
    Result := Enable();
end;

{ public TRootItem.GetStatus

  Returns the item status as text. }

function TRootItem.GetStatus(ALangFile: TLanguageFile): string;
begin
  if FEnabled then
    Result := ALangFile.GetString(31)
  else
    Result := ALangFile.GetString(32);
end;

{ public TRootItem.OpenInExplorer

  Opens an TRootItem object in Explorer. }

procedure TRootItem.OpenInExplorer();
var
  PreparedFileName: string;
  Win64: Boolean;

begin
  // Extract the file path only (without arguments and quote chars)
  PreparedFileName := GetFilePath();

  // Variable has to be expanded?
  if ((PreparedFileName <> '') and (PreparedFileName[1] = '%')) then
    PreparedFileName := TOSUtils.ExpandEnvironmentVar(PreparedFileName);

  // 64bit Windows?
  Win64 := TOSUtils.IsWindows64();

  // Deny WOW64 redirection only on 64bit Windows
  if Win64 then
    TOSUtils.Wow64FsRedirection(True);

  // Open file in explorer
  if ((PreparedFileName <> '') and FileExists(PreparedFileName)) then
    TOSUtils.ExecuteProgram('explorer.exe', '/select, '+ PreparedFileName)
  else
    raise EWarning.Create('File "'+ PreparedFileName +'" does not exist!');

  // Allow WOW64 redirection only on 64bit Windows
  if Win64 then
    TOSUtils.Wow64FsRedirection(False);
end;


{ TRootRegItem }

{ public TRootRegItem.OpenInRegEdit

  Opens a TRootRegItem object in RegEdit. }

procedure TRootRegItem.OpenInRegEdit();
begin
  // Set the Registry key to show
  TRegUtils.WriteStrValue('HKCU', KEY_REGEDIT, 'LastKey', 'Computer\'
    + GetFullLocation());

  // Deny WOW64 redirection only on 64bit Windows
  if TOSUtils.IsWindows64() then
  begin
    TOSUtils.Wow64FsRedirection(True);
    TOSUtils.ExecuteProgram('regedit.exe');
    TOSUtils.Wow64FsRedirection(False);
  end  //of begin
  else
    TOSUtils.ExecuteProgram('regedit.exe');
end;


{ TRootList }

{ public TRootList.Create

  General constructor for creating a TRootList instance. }

constructor TRootList.Create;
begin
  inherited Create;
  FActCount := 0;
  FLock := TCriticalSection.Create;
end;

{ public TRootList.Destroy

  General destructor for destroying a TRootList instance. }

destructor TRootList.Destroy;
begin
  FLock.Free;
  Clear();
  inherited Destroy;
end;

{ protected TRootList.RootItemAt

  Returns a TRootItem object at index. }

function TRootList.RootItemAt(AIndex: Word): TRootItem;
begin
  Result := TRootItem(Items[AIndex]);
end;

{ public TRootList.Clear

  Deletes all items in the list. }

procedure TRootList.Clear;
begin
  inherited Clear;
  FActCount := 0;
end;

{ public TRootList.ChangeItemFilePath

  Changes the file path of an item. }

function TRootList.ChangeItemFilePath(const ANewFilePath: string): Boolean;
begin
  // Invalid item?
  if (not Assigned(FItem) or (IndexOf(FItem) = -1)) then
    raise EInvalidItem.Create('No item selected!');

  // Change item file path
  Result := FItem.ChangeFilePath(ANewFilePath);

  // Notify changed
  if (Result and Assigned(FOnChanged)) then
    FOnChanged(Self);
end;

{ public TRootList.ChangeItemStatus

  Changes the item status. }

function TRootList.ChangeItemStatus(): Boolean;
var
  Changed: Boolean;

begin
  if (not Assigned(FItem) or (IndexOf(FItem) = -1)) then
    raise EInvalidItem.Create('No item selected!');

  // Change the status
  Changed := FItem.ChangeStatus();

  // Successful?
  if Changed then
  begin
    // Item has been enabled?
    if FItem.Enabled then
      Inc(FActCount)
    else
      Dec(FActCount);

    // Notify changed
    if Assigned(FOnChanged) then
      FOnChanged(Self);
  end;  //of begin

  Result := Changed;
end;

{ public TRootList.DeleteItem

  Deletes an item from location and list. }

function TRootList.DeleteItem(): Boolean;
var
  Deleted: Boolean;

begin
  if (not Assigned(FItem) or (IndexOf(FItem) = -1)) then
    raise EInvalidItem.Create('No item selected!');

  // Delete task from filesystem
  Deleted := FItem.Delete();

  // Successful?
  if Deleted then
  begin
    // Item was enabled
    if FItem.Enabled then
      // Update active counter
      Dec(FActCount);

    // Remove item from list
    inherited Remove(FItem);
    FItem := nil;

    // Notify delete
    if Assigned(FOnChanged) then
      FOnChanged(Self);
  end;  //of begin

  Result := Deleted;
end;

{ public TRootList.DisableItem

  Disables the current selected item. }

function TRootList.DisableItem(): Boolean;
begin
  if (not Assigned(FItem) or (IndexOf(FItem) = -1)) then
    raise EInvalidItem.Create('No item selected!');

  if not FItem.Enabled then
    raise EWarning.Create('Item already disabled!');

  // Disable item
  Result := FItem.Disable();

  if Result then
  begin
    // Update active counter
    Dec(FActCount);

    // Notify disable
    if Assigned(FOnChanged) then
      FOnChanged(Self);
  end;  //of begin
end;

{ public TRootList.EnableItem

  Enables the current selected item. }

function TRootList.EnableItem(): Boolean;
begin
  if (not Assigned(FItem) or (IndexOf(FItem) = -1)) then
    raise EInvalidItem.Create('No item selected!');

  if FItem.Enabled then
    raise EWarning.Create('Item already enabled!');

  // Enable item
  Result := FItem.Enable();

  if Result then
  begin
    // Update active counter
    Inc(FActCount);

    // Notify enable
    if Assigned(FOnChanged) then
      FOnChanged(Self);
  end;  //of begin
end;

{ public TRootList.ExportItem

  Exports an item as file. }

procedure TRootList.ExportItem(const AFileName: string);
begin
  if (not Assigned(FItem) or (IndexOf(FItem) = -1)) then
    raise EInvalidItem.Create('No item selected!');

  FItem.ExportItem(AFileName);
end;

{ public TRootList.IndexOf

  Returns the index of an item checking name only. }

function TRootList.IndexOf(const AItemName: string): Integer;
var
  i: Integer;

begin
  Result := -1;

  for i := 0 to Count -1 do
    if (RootItemAt(i).Name = AItemName) then
    begin
      Result := i;
      Break;
    end;  //of begin
end;

{ public TRootList.IndexOf

  Returns the index of an item checking name and status. }

function TRootList.IndexOf(AItemName: string; AEnabled: Boolean): Integer;
var
  i: Integer;
  Item: TRootItem;

begin
  Result := -1;

  for i := 0 to Count - 1 do
  begin
    Item := RootItemAt(i);

    if ((Item.Name = AItemName) and (Item.Enabled = AEnabled)) then
    begin
      Result := i;
      Break;
    end;  //of begin
  end;  //of for
end;


{ TStartupListItem }

{ private TStartupListItem.GetTimestamp

  Returns the deactivation timestamp. }

function TStartupListItem.GetTimestamp(AReg: TRegistry): string;
var
  Year, Month, Day, Hour, Min, Sec: Word;
  Date, Time: string;

begin
  // Deactivation timestamp only available for disabled items
  if FEnabled then
  begin
    Result := '';
    Exit;
  end;  //of begin

  try
    // At least one valid date entry exists?
    if AReg.ValueExists('YEAR') then
    begin
      Year := AReg.ReadInteger('YEAR');
      Month := AReg.ReadInteger('MONTH');
      Day := AReg.ReadInteger('DAY');
      Hour := AReg.ReadInteger('HOUR');
      Min := AReg.ReadInteger('MINUTE');
      Sec := AReg.ReadInteger('SECOND');
      Date := FormatDateTime('c', EncodeDate(Year, Month, Day));
      Time := FormatDateTime('tt', EncodeTime(Hour, Min, Sec, 0));
      Result := Date +'  '+ Time;
    end;  //of if

  except
    // Do not raise exception: Corrupted date is not fatal!
    Result := '';
  end;  //of try
end;

{ private TStartupListItem.WriteTimestamp

  Writes the deactivation timestamp. }

procedure TStartupListItem.WriteTimestamp(AReg: TRegistry);
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  TimeNow: TDateTime;

begin
  try
    // Read current time and update current deactivation timestamp
    TimeNow := Now();
    FTime := FormatDateTime('c', TimeNow);

    // Split current date
    DecodeDate(TimeNow, Year, Month, Day);

    // Split current time
    DecodeTime(TimeNow, Hour, Min, Sec, MSec);

    // Write time stamp
    with AReg do
    begin
      WriteInteger('YEAR', Year);
      WriteInteger('MONTH', Month);
      WriteInteger('DAY', Day);
      WriteInteger('HOUR', Hour);
      WriteInteger('MINUTE', Min);
      WriteInteger('SECOND', Sec);
    end;  //of with

  except
    on E: Exception do
    begin
      E.Message := 'Error while writing deactivation timestamp: '+ E.Message;
      raise;
    end;  //of begin
  end;  //of try
end;

{ protected TStartupListItem.GetFullLocation

  Returns the full Registry path to a TStartupListItem. }

function TStartupListItem.GetFullLocation(): string;
begin
  Result := TRegUtils.HKeyToStr(TRegUtils.StrToHKey(FRootKey)) +'\'+ FLocation;
end;

{ public TStartupListItem.ChangeFilePath

  Changes the file path of an TStartupListItem item. }

function TStartupListItem.ChangeFilePath(const ANewFilePath: string): Boolean;
var
  Reg: TRegistry;
  ItemName: string;

begin
  Result := False;
  Reg := TRegistry.Create(TWinWOW64.DenyWOW64Redirection(KEY_READ or KEY_WRITE));

  try
    Reg.RootKey := TOSUtils.StrToHKey(FRootKey);

    // Invalid key?
    if not Reg.OpenKey(FLocation, False) then
      raise Exception.Create('Key does not exist!');

    if FEnabled then
      ItemName := Name
    else
      ItemName := 'command';

    // Value must exist!
    if not Reg.ValueExists(ItemName) then
      raise Exception.Create('Value does not exist!');

    // Change path
    Reg.WriteString(ItemName, ANewFilePath);
    FilePath := ANewFilePath;
    Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TStartupListItem.ExportItem

  Exports an list item as .reg file. }

procedure TStartupListItem.ExportItem(const AFileName: string);
var
  RegFile: TRegistryFile;

begin
  RegFile := TRegistryFile.Create(AFileName, True);

  try
    if FEnabled then
      RegFile.ExportReg(TRegUtils.StrToHKey(FRootKey), FLocation, Name)
    else
      RegFile.ExportReg(TRegUtils.StrToHKey(FRootKey), FLocation, False);

  finally
    RegFile.Free;
  end;  //of try
end;


{ TStartupItem }

{ public TStartupItem.Delete

  Deletes a TStartupItem object and returns True if successful. }

function TStartupItem.Delete(): Boolean;
begin
  if FEnabled then
  begin
    if not TRegUtils.DeleteValue(FRootKey, FLocation, Name) then
      raise EStartupException.Create('Could not delete value!');
  end  //of begin
  else
    if not TRegUtils.DeleteKey('HKLM', KEY_DEACT, Name) then
      raise EStartupException.Create('Could not delete key!');

  Result := True;
end;

{ public TStartupItem.Disable

  Disables an TStartupItem object and returns True if successful. }

function TStartupItem.Disable(): Boolean;
var
  Reg: TRegistry;

begin
  Result := False;
  Reg := TRegistry.Create(TRegUtils.DenyWOW64Redirection(KEY_WRITE));

  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    // Failed to delete old entry?
    if not TRegUtils.DeleteValue(FRootKey, FLocation, Name) then
      raise EStartupException.Create('Could not delete value!');

    // Failed to create new key?
    if not Reg.OpenKey(KEY_DEACT + Name, True) then
      raise EStartupException.Create('Could not create key!');

    // Write values
    Reg.WriteString('hkey', FRootKey);
    Reg.WriteString('key', FLocation);
    Reg.WriteString('item', Name);
    Reg.WriteString('command', FilePath);
    Reg.WriteString('inimapping', '0');

    // Windows >= Vista?
    if TOSUtils.WindowsVistaOrLater() then
      // Save deactivation timestamp
      WriteTimestamp(Reg);

    // Update information
    FRootKey := 'HKLM';
    FLocation := KEY_DEACT + Name;
    FEnabled := False;
    Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TStartupItem.Enable

  Enables an TStartupItem object and returns True if successful. }

function TStartupItem.Enable(): Boolean;
var
  Reg: TRegistry;
  NewHKey, NewKeyPath: string;

begin
  Result := False;
  Reg := TRegistry.Create(TRegUtils.DenyWOW64Redirection(KEY_READ or KEY_WRITE));

  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if not Reg.OpenKey(FLocation, False) then
      raise EStartupException.Create('Key does not exist!');

    if (not Reg.ValueExists('hkey') or not Reg.ValueExists('key')) then
      raise EStartupException.Create('Missing destination Registry values '
        +'"hkey" or "key"!');

    // Set new values
    NewHKey := Reg.ReadString('hkey');
    NewKeyPath := Reg.ReadString('key');
    Reg.CloseKey;

    if ((NewHKey = '') or (NewKeyPath = '')) then
      raise EStartupException.Create('Invalid destination Registry values for '
        +'"hkey" or "key"!');

    Reg.RootKey := TRegUtils.StrToHKey(NewHKey);

    // Failed to create new key?
    if not Reg.OpenKey(NewKeyPath, True) then
      raise EStartupException.Create('Could not create key "'+ NewKeyPath +'"!');

    // Write startup entry
    Reg.WriteString(Name, FilePath);

    // Delete old key
    Result := TRegUtils.DeleteKey('HKLM', KEY_DEACT, Name);

    // Update information
    FRootKey := NewHKey;
    FLocation := NewKeyPath;
    FEnabled := True;
    FTime := '';

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;


{ TStartupUserItem }

{ public TStartupUserItem.Destroy

  General destructor for destroying a TStartupUserItem instance. }

destructor TStartupUserItem.Destroy;
begin
  FLnkFile.Free;
  inherited Destroy;
end;

{ private TStartupUserItem.AddCircumflex

  Replaces all backslashes in a path by circumflex. }

function TStartupUserItem.AddCircumflex(const AName: string): string;
begin
  Result := StringReplace(AName, '\', '^', [rfReplaceAll]);
end;

{ protected TStartupUserItem.GetFullLocation

  Returns the file path of a TStartupUserItem. }

function TStartupUserItem.GetFullLocation(): string;
begin
  if FEnabled then
    Result := FLocation
  else
    Result := inherited GetFullLocation();
end;

{ public TStartupUserItem.ChangeFilePath

  Changes the file path of a TStartupUserItem item. }

function TStartupUserItem.ChangeFilePath(const ANewFilePath: string): Boolean;
var
  NewFilePath, Arguments: string;

begin
  if not FEnabled then
    inherited ChangeFilePath(ANewFilePath);

  NewFilePath := DeleteQuoteChars(ExtractPathToFile(ANewFilePath));
  Arguments := DeleteQuoteChars(ExtractArguments(ANewFilePath));

  // Failed to create new .lnk file?
  if (FEnabled and not FLnkFile.WriteLnkFile(FLocation, NewFilePath, Arguments)) then
    raise EStartupException.Create('Could not create .lnk file!');

  // Update information
  FilePath := ANewFilePath;
  FLnkFile.ExeFileName := NewFilePath;
  FLnkFile.Arguments := Arguments;

  // Rewrite backup
  if (not FEnabled and FLnkFile.BackupExists()) then
    if not FLnkFile.CreateBackup() then
      raise EStartupException.Create('Backup could not be created!');

  Result := True;
end;

{ public TStartupUserItem.Delete

  Deletes a TStartupUserItem object and returns True if successful. }

function TStartupUserItem.Delete(): Boolean;
var
  Dir, KeyName: string;

begin
  if FEnabled then
  begin
    // Could not delete .lnk?
    if not DeleteFile(FLocation) then
      raise EStartupException.Create('Could not delete .lnk "'+ FLocation +'"!');
  end  //of begin
  else
  begin
    Dir := TLnkFile.GetStartUpDir(AnsiContainsText('Common', TypeOf));
    KeyName := AddCircumflex(Dir + Name);

    // Could not delete key?
    if not TRegUtils.DeleteKey('HKLM', KEY_DEACT_FOLDER, KeyName) then
      raise EStartupException.Create('Could not delete key!');
  end;  //of if
  
  Result := True;
end;

{ public TStartupUserItem.Disable

  Disables an TStartupUserItem object and returns True if successful. }

function TStartupUserItem.Disable(): Boolean;
var
  Reg: TRegistry;
  KeyName: string;

begin
  Result := False;
  Reg := TRegistry.Create(TRegUtils.DenyWOW64Redirection(KEY_WRITE));

  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := AddCircumflex(FLocation);

    if not FLnkFile.ReadLnkFile() then
      raise EStartupException.Create('Could not read .lnk file!');

    if not Reg.OpenKey(KEY_DEACT_FOLDER + KeyName, True) then
      raise EStartupException.Create('Could not create key!');

    Reg.WriteString('path', FLocation);
    Reg.WriteString('item', ChangeFileExt(ExtractFileName(Name), ''));
    Reg.WriteString('command', FilePath);
    Reg.WriteString('backup', FLnkFile.BackupLnk);

    // Special Registry entries only for Windows >= Vista
    if TOSUtils.WindowsVistaOrLater() then
    begin
      Reg.WriteString('backupExtension', FLnkFile.BackupExt);
      Reg.WriteString('location', ExtractFileDir(FLocation));
      WriteTimestamp(Reg);
    end  //of begin
    else
      Reg.WriteString('location', TypeOf);

    // Create backup directory if not exist
    if not DirectoryExists(TLnkFile.GetBackupDir()) then
      ForceDirectories(TLnkFile.GetBackupDir());

    // Create backup by copying original .lnk
    if not CopyFile(PChar(FLocation), PChar(FLnkFile.BackupLnk), False) then
      raise EStartupException.Create('Could not create backup file!');

    // Delete original .lnk
    if not FLnkFile.Delete() then
      raise EStartupException.Create('Could not delete .lnk file!');

    // Update information
    FLocation := KEY_DEACT_FOLDER + KeyName;
    FRootKey := 'HKLM';
    FEnabled := False;
    Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TStartupUserItem.Enable

  Enables an TStartupUserItem object and returns True if successful. }

function TStartupUserItem.Enable(): Boolean;
begin
  // Backup file exists?
  if FLnkFile.BackupExists() then
  begin
    // Failed to restore backup file?
    if not CopyFile(PChar(FLnkFile.BackupLnk), PChar(FLnkFile.FileName), True) then
      raise EStartupException.Create('Could not restore backup .lnk file!');
  end  //of begin
  else
    begin
      // Failed to create new .lnk file?
      if not FLnkFile.WriteLnkFile(FLnkFile.FileName, GetFilePath(), GetArguments()) then
        raise EStartupException.Create('Could not create .lnk file!');
    end;  //of if

  // Could not delete old key?
  if not TRegUtils.DeleteKey('HKLM', KEY_DEACT_FOLDER, AddCircumflex(FLnkFile.FileName)) then
    raise EStartupException.Create('Could not delete key!');

  // Update information
  FLocation := FLnkFile.FileName;
  FRootKey := '';
  FEnabled := True;
  Result := True;
end;

{ public TStartupUserItem.ExportItem

  Exports a TStartupUserItem object as .reg or .lnk backup file. }

procedure TStartupUserItem.ExportItem(const AFileName: string);
begin
  if not FEnabled then
    inherited ExportItem(AFileName)
  else
    if not FLnkFile.CreateBackup() then
      raise EStartupException.Create('Could not create backup file!');
end;


{ TStartupList }

{ public TStartupList.Create

  General constructor for creating a TStartupList instance. }

constructor TStartupList.Create;
begin
  inherited Create;
  FDeleteBackup := True;
end;

{ private TStartupList.DeleteBackupFile

  Deletes the backup file of a TStartupUserItem. }

function TStartupList.DeleteBackupFile(): Boolean;
begin
  Result := False;

  if (FDeleteBackup and (Selected is TStartupUserItem)) then
    Result := (Selected as TStartupUserItem).LnkFile.DeleteBackup();
end;

{ private TStartupList.ItemAt

  Returns a TStartupListItem object at index. }

function TStartupList.ItemAt(AIndex: Word): TStartupListItem;
begin
  Result := TStartupListItem(RootItemAt(AIndex));
end;

{ private TStartupList.GetSelectedItem

  Returns the current selected item as TStartupListItem. }

function TStartupList.GetSelectedItem(): TStartupListItem;
begin
  Result := TStartupListItem(Selected);
end;

{ private TStartupList.GetStartupUserType

  Returns the startup item type. }

function TStartupList.GetStartupUserType(const AKeyPath: string): string;
var
  StartupType: string;

begin
  // Windows >= Vista?
  if TOSUtils.WindowsVistaOrLater() then
  begin
    StartupType := TRegUtils.GetKeyValue('HKLM', AKeyPath, 'backupExtension');

    if AnsiSameText(StartupType, EXT_COMMON) then
      Result := TYPE_COMMON
    else
      Result := TYPE_USER;
  end  //of begin
  else
    Result := TRegUtils.GetKeyValue('HKLM', AKeyPath, 'location');
end;

{ private TStartupList.GetStartupUserType

  Returns the startup item type. }

function TStartupList.GetStartupUserType(AAllUsers: Boolean): string;
begin
  // Windows >= Vista?
  if TOSUtils.WindowsVistaOrLater() then
  begin
    if AAllUsers then
      Result := TYPE_COMMON
    else
      Result := TYPE_USER;
  end  //of begin
  else
    if AAllUsers then
      Result := TYPE_COMMON_XP
    else
      Result := TYPE_USER_XP;
end;

{ protected TStartupList.AddItemDisabled

  Adds a disabled default startup item to the list. }

function TStartupList.AddItemDisabled(AReg: TRegistry): Integer;
var
  Item: TStartupListItem;

begin
  Item := TStartupItem.Create(Count, False);

  try
    with Item do
    begin
      RootKey := 'HKLM';
      FLocation := AReg.CurrentPath;
      Name := ExtractFileName(FLocation);
      FilePath := AReg.ReadString('command');
      Time := GetTimestamp(AReg);
      TypeOf := AReg.ReadString('hkey');
    end;  //of with

    Result := Add(Item);

  except
    Item.Free;
    Result := -1;
  end;  //of try
end;

{ protected TStartupList.AddItemEnabled

  Adds a enabled default startup item to the list. }

function TStartupList.AddItemEnabled(const ARootKey, AKeyPath, AName,
  AFileName: string): Integer;
var
  Item: TStartupListItem;

begin
  Item := TStartupItem.Create(Count, True);

  try
    with Item do
    begin
      RootKey := ARootKey;
      FLocation := AKeyPath;
      Name := AName;
      FilePath := AFileName;
      Time := '';

      if ((AKeyPath = KEY_RUNONCE) or (AKeyPath = KEY_RUNONCE32)) then
        TypeOf := 'RunOnce'
      else
        TypeOf := ARootKey;
    end;  //of with

    Inc(FActCount);
    Result := Add(Item);

  except
    Item.Free;
    Result := -1;
  end;  //of try
end;

{ protected TStartupList.AddNewStartupUserItem

  Adds a new startup user item to the autostart. }

function TStartupList.AddNewStartupUserItem(AName, AFilePath: string;
  AArguments: string = ''; AAllUsers: Boolean = False): Boolean;
var
  LnkFile: TLnkFile;

begin
  if (ExtractFileExt(AName) <> '.lnk') then
    AName := AName +'.lnk';

  // Init .lnk file
  LnkFile := TLnkFile.Create(AName, AAllUsers);

  // Link file created successfully?
  if not LnkFile.WriteLnkFile(LnkFile.FileName, AFilePath, AArguments) then
    raise EStartupException.Create('Could not create .lnk file!');

  // Add item to list
  Result := (AddUserItemEnabled(LnkFile, AAllUsers) <> -1);
end;

{ protected TStartupList.AddUserItemDisabled

  Adds a disabled startup user item to the list. }

function TStartupList.AddUserItemDisabled(AReg: TRegistry): Integer;
var
  Item: TStartupListItem;
  Path, Ext: string;

begin
  Item := TStartupUserItem.Create(Count, False);

  try
    with (Item as TStartupUserItem) do
    begin
      RootKey := 'HKLM';
      FLocation := AReg.CurrentPath;
      Name := ExtractFileName(StringReplace(FLocation, '^', '\', [rfReplaceAll]));
      FilePath := AReg.ReadString('command');
      Time := GetTimestamp(AReg);
      TypeOf := GetStartupUserType(FLocation);
      Path := AReg.ReadString('path');

      if ((TypeOf = TYPE_USER) or (TypeOf = TYPE_USER_XP)) then
        Ext := EXT_USER
      else
        Ext := EXT_COMMON;

      LnkFile := TLnkFile.Create(Path, Ext);
      LnkFile.ReadLnkFile();
    end;  //of with

    Result := Add(Item);

  except
    Item.Free;
    Result := -1;
  end;  //of try
end;

{ protected TStartupList.AddUserItemEnabled

  Adds a enabled startup user item to the list. }

function TStartupList.AddUserItemEnabled(ALnkFile: TLnkFile;
  AAllUsers: Boolean): Integer;
var
  Item: TStartupListItem;

begin
  Item := TStartupUserItem.Create(Count, True);

  try
    // Read .lnk file
    ALnkFile.ReadLnkFile();

    with (Item as TStartupUserItem) do
    begin
      RootKey := '';
      FLocation := ALnkFile.FileName;
      FilePath := ALnkFile.FullPath;
      LnkFile := ALnkFile;
      Name := ExtractFileName(ALnkFile.FileName);
      Time := '';
      TypeOf := GetStartupUserType(AAllUsers);
    end;  //of with

    Inc(FActCount);
    Result := Add(Item);

  except
    Item.Free;
    Result := -1;
  end;  //of try
end;

{ public TStartupList.AddProgram

  Adds a new startup item to autostart. }

function TStartupList.AddProgram(AFileName, AArguments: string;
  ADisplayedName: string = ''): Boolean;
var
  Name, Ext: string;
  i: Word;

begin
  Result := False;
  Name := ExtractFileName(AFileName);
  Ext := ExtractFileExt(Name);

  // Check invalid extension
  if ((Ext <> '.exe') and (Ext <> '.bat')) then
    raise EInvalidArgument.Create('Invalid program extension! Must be ".exe"'
      +' or ".bat"!');

  // File path already exists in another item?
  for i := 0 to Count - 1 do
    if AnsiContainsStr(ItemAt(i).FilePath, AFileName) then
      Exit;

  // Add new startup user item?
  if (Ext = '.exe') then
  begin
    if (ADisplayedName <> '') then
      Name := ADisplayedName
    else
      Name := ChangeFileExt(Name, '');

    Result := AddNewStartupUserItem(Name, AFileName, AArguments);
  end  //of begin
  else
    begin
      // Append arguments if used
      if (AArguments <> '') then
        AFileName := AFileName +' '+ AArguments;

      // Adds new startup item to Registry
      TRegUtils.WriteStrValue('HKCU', KEY_STARTUP, ADisplayedName, AFileName);

      // Adds item to list
      Result := (AddItemEnabled('HKCU', KEY_STARTUP, ADisplayedName, AFileName) <> -1);
    end;  //of begin
end;

{ public TStartupList.BackupExists

  Checks if a backup file already exists. }

function TStartupList.BackupExists(): Boolean;
begin
  if (not Assigned(Selected) or (IndexOf(Selected) = -1)) then
    raise EInvalidItem.Create('No item selected!');

  if (Selected is TStartupUserItem) then
    Result := (Selected as TStartupUserItem).LnkFile.BackupExists()
  else
    Result := False;
end;

{ public TStartupList.ChangeItemStatus

  Changes the item status. }

function TStartupList.ChangeItemStatus(): Boolean;
begin
  Result := inherited ChangeItemStatus();

  // Only delete backup if item has been enabled!
  if (Result and Selected.Enabled) then
    DeleteBackupFile();
end;

{ public TStartupList.DeleteItem

  Deletes an item from Registry and list. }

function TStartupList.DeleteItem(): Boolean;
begin
  DeleteBackupFile();
  Result := inherited DeleteItem();
end;

{ public TStartupList.EnableItem

  Enables the current selected item. }

function TStartupList.EnableItem(): Boolean;
begin
  Result := inherited EnableItem();

  if Result then
    DeleteBackupFile();
end;

{ public TStartupList.ExportList

  Exports the complete list as .reg file. }

procedure TStartupList.ExportList(const AFileName: string);
var
  i: Integer;
  RegFile: TRegistryFile;
  Item: TStartupListItem;

begin
  // Init Reg file
  RegFile := TRegistryFile.Create(AFileName, True);

  try
    for i := 0 to Count - 1 do
    begin
      Item := ItemAt(i);
      RegFile.ExportKey(TOSUtils.StrToHKey(Item.RootKey), Item.Location, True);
    end;  //of for

    // Save file
    RegFile.Save();

  finally
    RegFile.Free;
  end;  //of try
end;

{ public TStartupList.ImportBackup

  Imports a startup user backup file and adds it to the list. }

function TStartupList.ImportBackup(const AFileName: string): Boolean;
var
  Name, Ext: string;
  i: Integer;
  LnkFile: TLnkFile;

begin
  Result := False;
  Ext := ExtractFileExt(AFileName);

  // Check invalid extension
  if ((Ext <> EXT_COMMON) and (Ext <> EXT_USER)) then
    raise EInvalidArgument.Create('Invalid backup file extension! Must be "'
      + EXT_COMMON +'" or "'+ EXT_USER+'"!');

  // Init new .lnk file
  LnkFile := TLnkFile.Create(AFileName, Ext);

  // Set the name of item
  Name := ExtractFileName(ChangeFileExt(AFileName, ''));

  // Append extension if not exist
  if (ExtractFileExt(Name) = '') then
    Name := Name +'.lnk';

  try
    // Extract path to .exe
    if not LnkFile.ReadLnkFile() then
      raise EStartupException.Create('Could not read backup file!');

    // File path already exists in another item?
    for i := 0 to Count - 1 do
      if (ItemAt(i).FilePath = LnkFile.ExeFileName) then
        Exit;

    // Create .lnk file and add it to list
    Result := AddNewStartupUserItem(Name, LnkFile.ExeFileName, LnkFile.Arguments,
      (Ext = EXT_COMMON));

  finally
    LnkFile.Free;
  end;  //of try
end;

{ public TStartupList.LoadDisabled

  Searches for disabled items in AKeyPath and adds them to the list. }

procedure TStartupList.LoadDisabled(AStartupUser: Boolean);
var
  Reg: TRegistry;
  Items: TStringList;
  KeyPath: string;
  i: Integer;

begin
  Items := TStringList.Create;
  Reg := TRegistry.Create(TOSUtils.DenyWOW64Redirection(KEY_READ));
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  if AStartupUser then
    KeyPath := KEY_DEACT_FOLDER
  else
    KeyPath := KEY_DEACT;

  try
    Reg.OpenKey(KeyPath, False);
    Reg.GetKeyNames(Items);

    for i := 0 to Items.Count - 1 do
    begin
      Reg.CloseKey();
      Reg.OpenKey(KeyPath + Items[i], False);

      if AStartupUser then
        AddUserItemDisabled(Reg)
      else
        AddItemDisabled(Reg);
    end;  //of for

  finally
    Reg.CloseKey();
    Reg.Free;
    Items.Free;
  end;  //of try
end;

{ public TStartupList.LoadEnabled

  Searches for enabled startup user items and adds them to the list. }

procedure TStartupList.LoadEnabled(AAllUsers: Boolean);
var
  LnkFiles: TStringList;
  SearchResult: TSearchRec;
  Folder: string;
  i: Integer;
  LnkFile: TLnkFile;

begin
  LnkFiles := TStringList.Create;

  // Retrieve a list containing all activated startup user .lnk files
  try
    Folder := TLnkFile.GetStartUpDir(AAllUsers);

    if (FindFirst(Folder +'*.lnk', faAnyFile, SearchResult) = 0) then
      try
        repeat
          // .lnk file found?
          if (SearchResult.Attr <> faDirectory) then
            LnkFiles.Add(Folder + SearchResult.Name);

        until FindNext(SearchResult) <> 0;

      finally
        FindClose(SearchResult);
      end;  //of try

    // Add every file to list
    for i := 0 to LnkFiles.Count - 1 do
    begin
      LnkFile := TLnkFile.Create(ExtractFileName(LnkFiles[i]), AAllUsers);
      AddUserItemEnabled(LnkFile, AAllUsers);
    end;  //of begin

  finally
    LnkFiles.Free;
  end;  //of try
end;

{ public TStartupList.LoadEnabled

  Searches for enabled items in ARootKey and AKeyPath and adds them to the list. }

procedure TStartupList.LoadEnabled(const ARootKey, AKeyPath: string);
var
  Reg: TRegistry;
  Items: TStringList;
  i: Integer;

begin
  if not AnsiStartsText('Run', ExtractFileName(AKeyPath)) then
    raise EStartupException.Create('Invalid startup key!');
  
  Items := TStringList.Create;
  Reg := TRegistry.Create(TOSUtils.DenyWOW64Redirection(KEY_READ));

  try
    Reg.RootKey := TOSUtils.StrToHKey(ARootKey);
    Reg.OpenKey(AKeyPath, False);
    Reg.GetValueNames(Items);

    for i := 0 to Items.Count - 1 do
      // Read path to .exe and add item to list
      AddItemEnabled(ARootKey, AKeyPath, Items[i], Reg.ReadString(Items[i]));

  finally
    Reg.CloseKey();
    Reg.Free;
    Items.Free;
  end;  //of finally
end;

{ public TStartupList.LoadStartup

  Searches for startup items at different locations. }

procedure TStartupList.LoadStartup(AIncludeRunOnce: Boolean);
var
  StartupSearchThread: TStartupSearchThread;

begin
  // Init search thread
  StartupSearchThread := TStartupSearchThread.Create(Self, FLock);

  with StartupSearchThread do
  begin
    Win64 := TOSUtils.IsWindows64();
    IncludeRunOnce := AIncludeRunOnce;
    OnStart := FOnSearchStart;
    OnSearching := FOnSearching;
    OnFinish := FOnSearchFinish;
    Resume;
  end;  // of with
end;


{ TContextListItem }

{ protected TContextListItem.GetFullLocation

  Returns the Registry path to a TStartupListItem. }

function TContextListItem.GetFullLocation(): string;
begin
  Result := TRegUtils.HKeyToStr(HKEY_CLASSES_ROOT) +'\'+ GetKeyPath();
end;

{ public TContextListItem.Delete

  Deletes a TContextListItem object and returns True if successful. }

function TContextListItem.Delete(): Boolean;
begin
  if not TRegUtils.DeleteKey('HKCR', ExtractFileDir(GetKeyPath()), Name) then
    raise EStartupException.Create('Could not delete key!');

  Result := True;
end;

{ public TContextListItem.ExportItem

  Exports an list item as .reg file. }

procedure TContextListItem.ExportItem(const AFileName: string);
var
  RegFile: TRegistryFile;

begin
  RegFile := TRegistryFile.Create(AFileName, True);

  try
    RegFile.ExportReg(HKEY_CLASSES_ROOT, GetKeyPath(), True);

  finally
    RegFile.Free;
  end;  //of try
end;


{ TShellItem }

{ private TShellItem.GetKeyPath

  Returns the Registry path of a TShellItem item. }

function TShellItem.GetKeyPath(): string;
begin
  Result := FLocation + CM_SHELL +'\'+ Name;
end;

{ public TShellItem.ChangeFilePath

  Changes the file path of an TShellItem item. }

function TShellItem.ChangeFilePath(const ANewFilePath: string): Boolean;
var
  Reg: TRegistry;

begin
  Result := False;
  Reg := TRegistry.Create(TWinWOW64.DenyWOW64Redirection(KEY_ALL_ACCESS));

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    // Invalid key?
    if not Reg.OpenKey(GetKeyPath() +'\command', False) then
      raise Exception.Create('Key does not exist!');

    // Change path
    Reg.WriteString('', ANewFilePath);
    Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TShellItem.Disable

  Disables a TShellItem object and returns True if successful. }

function TShellItem.Disable(): Boolean;
var
  Reg: TRegistry;

begin
  Result := False;
  Reg := TRegistry.Create(TRegUtils.DenyWOW64Redirection(KEY_READ or KEY_WRITE));

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    // Key does not exist?
    if not Reg.OpenKey(GetKeyPath(), False) then
      raise EContextMenuException.Create('Key does not exist!');

    Reg.WriteString('LegacyDisable', '');

    // Update status
    FEnabled := False;
    Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TShellItem.Enable

  Enables a TShellItem object and returns True if successful. }

function TShellItem.Enable(): Boolean;
begin
  if not TRegUtils.DeleteValue('HKCR', GetKeyPath(), 'LegacyDisable') then
    raise EContextMenuException.Create('Could not delete disable value!');

  // Update status
  FEnabled := True;
  Result := True;
end;


{ TShellExItem }

{ private TShellExItem.GetKeyPath

  Returns the Registry path to a TShellExItem. }

function TShellExItem.GetKeyPath(): string;
begin
  Result := FLocation + CM_SHELLEX +'\'+ Name;
end;

{ private TShellExItem.GetProgramPathKey

  Returns the Registry key of the correspondending program. }

function TShellExItem.GetProgramPathKey(): string;
var
  GUID: string;

begin
  GUID := TRegUtils.GetKeyValue('HKCR', GetKeyPath(), '');
  Result := Format(CM_SHELLEX_FILE, [GUID]);
end;

{ public TShellExItem.ChangeFilePath

  Changes the file path of an TShellExItem item. }

function TShellExItem.ChangeFilePath(const ANewFilePath: string): Boolean;
begin
  TRegUtils.WriteStrValue('HKCR', GetProgramPathKey(), '', ANewFilePath);
  Result := True;
end;

{ public TShellExItem.Disable

  Disables a TShellExItem object and returns True if successful. }

function TShellExItem.Disable(): Boolean;
var
  Reg: TRegistry;
  OldValue, NewValue: string;

begin
  Result := False;
  Reg := TRegistry.Create(TRegUtils.DenyWOW64Redirection(KEY_READ or KEY_WRITE));

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    // Key does not exist?
    if not Reg.OpenKey(GetKeyPath(), False) then
      raise EContextMenuException.Create('Key does not exist!');

    // Value does not exist?
    if not Reg.ValueExists('') then
      raise EContextMenuException.Create('Value does not exist!');

    OldValue := Reg.ReadString('');

    if (Trim(OldValue) = '') then
      raise EContextMenuException.Create('Value must not be empty!');

      // Item enabled?
    if (OldValue[1] = '{') then
    begin
      // Set up new value and write it
      NewValue := '-'+ OldValue;
      Reg.WriteString('', NewValue);
    end;  //of begin

    // Update status
    FEnabled := False;
    Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TShellExItem.Enable

  Enables a TShellExItem object and returns True if successful. }

function TShellExItem.Enable(): Boolean;
var
  Reg: TRegistry;
  OldValue, NewValue: string;

begin
  Result := False;
  Reg := TRegistry.Create(TRegUtils.DenyWOW64Redirection(KEY_READ or KEY_WRITE));

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    // Key does not exist?
    if not Reg.OpenKey(GetKeyPath(), False) then
      raise EContextMenuException.Create('Key does not exist!');

    // Value does not exist?
    if not Reg.ValueExists('') then
      raise EContextMenuException.Create('Value does not exist!');

    OldValue := Reg.ReadString('');

    if (Trim(OldValue) = '') then
      raise EContextMenuException.Create('Value must not be empty!');

    // Item really disabled?
    if (OldValue[1] <> '{') then
    begin
      // Set up new value and write it
      NewValue := Copy(OldValue, 2, Length(OldValue));
      Reg.WriteString('', NewValue);
    end;  //of begin

    // Update status
    FEnabled := True;
    Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;


{ TContextList }

{ public TContextList.Create

  General constructor for creating a TContextList instance. }

constructor TContextList.Create;
begin
  inherited Create;
  FActCount := 0;
end;

{ public TContextList.AddEntry

  Adds a new contextmenu entry. }

function TContextList.AddEntry(const AFilePath, AArguments, ALocationRoot,
  ADisplayedName: string): Boolean;
var
  Name, Ext, FullPath, KeyName: string;
  Reg: TRegistry;

begin
  Result := False;
  Ext := ExtractFileExt(AFilePath);
  Name := ChangeFileExt(ExtractFileName(AFilePath), '');

  // Check invalid extension
  if ((Ext <> '.exe') and (Ext <> '.bat')) then
    raise EInvalidArgument.Create('Invalid program extension! Must be ".exe"'
      +' or ".bat"!');

  // File path already exists in another item?
  if (IndexOf(Name, ALocationRoot) <> -1) then
    Exit;

  // Escape space char using quotes
  FullPath := '"'+ AFilePath +'"';

  // Append arguments if used
  if (AArguments <> '') then
    FullPath := FullPath +' '+ AArguments;

  // Build Registry key name
  KeyName := ALocationRoot + CM_SHELL +'\'+ Name;

  // Adds new context item to Registry
  Reg := TRegistry.Create(TRegUtils.DenyWOW64Redirection(KEY_WRITE));

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    if not Reg.OpenKey(KeyName, True) then
      raise EContextMenuException.Create('Could not create key!');

    // Write caption of item
    Reg.WriteString('', ADisplayedName);
    Reg.CloseKey();

    if not Reg.OpenKey(KeyName +'\command', True) then
      raise EContextMenuException.Create('Could not create key!');

    // Write command of item
    Reg.WriteString('', FullPath);

    // Adds item to list
    AddShellItem(Name, ALocationRoot, FullPath, ADisplayedName, True);
    Result := True;

  finally
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ private TContextList.GetSelectedItem

  Returns the current selected item as TContextListItem. }

function TContextList.GetSelectedItem(): TContextListItem;
begin
  Result := TContextListItem(Selected);
end;

{ private TContextList.ItemAt

  Returns a TContextListItem object at index. }

function TContextList.ItemAt(AIndex: Word): TContextListItem;
begin
  Result := TContextListItem(RootItemAt(AIndex));
end;

{ protected TContextList.AddShellItem

  Adds a shell item to list. }

function TContextList.AddShellItem(const AName, ALocationRoot, AFilePath,
  ACaption: string; AEnabled: Boolean): Integer;
var
  Item: TContextListItem;

begin
  Item := TShellItem.Create(Count, AEnabled);

  with Item do
  begin
    Name := AName;
    LocationRoot := ALocationRoot;
    FilePath := AFilePath;
    Caption := ACaption;
    TypeOf := 'Shell';

    if AEnabled then
      Inc(FActCount);
  end;  //of with

  Result := Add(Item);
end;

{ protected TContextList.AddShellExItem

  Adds a shellex item to list. }

function TContextList.AddShellExItem(const AName, ALocationRoot, AFilePath: string;
  AEnabled: Boolean): Integer;
var
  Item: TContextListItem;

begin
  Item := TShellExItem.Create(Count, AEnabled);

  with Item do
  begin
    Name := AName;
    LocationRoot := ALocationRoot;
    FilePath := AFilePath;
    TypeOf := 'ShellEx';

    if AEnabled then
      Inc(FActCount);
  end;  //of with

  Result := Add(Item);
end;

{ public TContextList.ExportList

  Exports the complete list as .reg file. }

procedure TContextList.ExportList(const AFileName: string);
var
  i: Word;
  RegFile: TRegistryFile;
  Item: TContextListItem;

begin
  // Init Reg file
  RegFile := TRegistryFile.Create(AFileName, True);

  try
    for i := 0 to Count - 1 do
    begin
      Item := ItemAt(i);
      RegFile.ExportKey(HKEY_CLASSES_ROOT, Item.Location, True);
    end;  //of for

    // Save file
    RegFile.Save();

  finally
    RegFile.Free;
  end;  //of try
end;

{ public TContextList.IndexOf

  Returns the index of an item checking name and location. }

function TContextList.IndexOf(AName, ALocationRoot: string): Integer;
var
  i: Word;
  Item: TContextListItem;

begin
  Result := -1;

  for i := 0 to Count - 1 do
  begin
    Item := ItemAt(i);

    if (((Item.Name = AName) or (Item.Caption = AName)) and
      (Item.LocationRoot = ALocationRoot)) then
    begin
      Result := i;
      Break;
    end;  //of begin
  end;  //of for
end;

{ public TContextList.LoadContextmenu

  Searches for Shell and ShellEx context menu entries in specific Registry key
  and adds them to the list. }

procedure TContextList.LoadContextmenu(const ALocationRoot: string);
begin
  LoadContextmenu(ALocationRoot, True);
  LoadContextmenu(ALocationRoot, False);
end;

{ public TContextList.LoadContextmenu

  Searches for either Shell or ShellEx context menu entries in specific
  Registry key and adds them to the list. }

procedure TContextList.LoadContextmenu(const ALocationRoot: string;
  ASearchForShellItems: Boolean);
var
  Reg: TRegistry;
  i: Integer;
  List: TStringList;
  Item, Key, KeyName, FilePath, GUID, Caption: string;
  Enabled: Boolean;

begin
  Reg := TRegistry.Create(TOSUtils.DenyWOW64Redirection(KEY_READ));
  List := TStringList.Create;

  if ASearchForShellItems then
    Key := ALocationRoot + CM_SHELL
  else
    Key := ALocationRoot + CM_SHELLEX;

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey(Key, False);

    // Read out all keys
    Reg.GetKeyNames(List);

    for i := 0 to List.Count - 1 do
    begin
      Reg.CloseKey();
      Item := List[i];
      Reg.OpenKey(Key +'\'+ Item, False);
      FilePath := '';

      // Default value of key is a GUID for ShellEx items and caption for Shell
      GUID := Reg.ReadString('');
      Caption := GUID;

      // Filter empty and important entries
      if ((Caption <> '') and (Item[1] <> '{') and (GUID[1] <> '@')) then
      begin
        // Search for shell entries?
        if ASearchForShellItems then
        begin
          // Get status and caption
          Enabled := not Reg.ValueExists('LegacyDisable');

          // Get file path of command
          if Reg.OpenKey('command', False) then
            FilePath := Reg.ReadString('');

          // Add item to list
          AddShellItem(Item, ALocationRoot, FilePath, Caption, Enabled);
        end  //of begin
        else
          // Search for shellex entries
          begin
            // Get status and GUID
            Enabled := (GUID[1] = '{');

            // Disabled ShellEx items got "-" before GUID!
            if not Enabled then
              GUID := Copy(GUID, 2, Length(GUID));

            // Set up Registry key
            KeyName := Format(CM_SHELLEX_FILE, [GUID]);
            Reg.CloseKey();

            // Get file path of command
            if Reg.OpenKey(KeyName, False) then
              FilePath := Reg.ReadString('');

            // Add item to list
            AddShellExItem(Item, ALocationRoot, FilePath, Enabled);
          end  //of begin
        end;  //of begin
    end;  //of for

  finally
    List.Free;
    Reg.CloseKey();
    Reg.Free;
  end;  //of try
end;

{ public TContextList.LoadContextMenus

  Searches for context menu entries at different locations. }

procedure TContextList.LoadContextMenus(ALocationRootCommaList: string = '');
var
  SearchThread: TContextSearchThread;

begin
  // Init search thread
  SearchThread := TContextSearchThread.Create(Self, FLock);

  with SearchThread do
  begin
    Locations.CommaText := ALocationRootCommaList;
    OnStart := FOnSearchStart;
    OnSearching := FOnSearching;
    OnFinish := FOnSearchFinish;
    Resume;
  end;  // of with
end;

end.
