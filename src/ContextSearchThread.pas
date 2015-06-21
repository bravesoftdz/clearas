{ *********************************************************************** }
{                                                                         }
{ Clearas context menu search thread                                      }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit ContextSearchThread;

interface

uses
  Windows, Classes, Registry, SyncObjs, ClearasAPI, PMCWOSUtils;

type
  { TContextSearchThread }
  TContextSearchThread = class(TThread)
  private
    FReg: TRegistry;
    FLocations: TStringList;
    FProgress, FProgressMax: Cardinal;
    FContextList: TContextList;
    FOnStart, FOnSearching: TSearchEvent;
    FOnFinish: TNotifyEvent;
    FLock: TCriticalSection;
    FWin64: Boolean;
    FRoot: string;
    FRootKey: HKEY;
    procedure DoNotifyOnFinish();
    procedure DoNotifyOnStart();
    procedure DoNotifyOnSearching();
    procedure LoadAllContextMenus();
    procedure LoadContextMenus();
    procedure SearchSubkey(AKeyName: string);
  protected
    procedure Execute; override;
  public
    constructor Create(AContextList: TContextList; ALock: TCriticalSection);
    destructor Destroy(); override;
    { external }
    property Locations: TStringList read FLocations;
    property OnSearching: TSearchEvent read FOnSearching write FOnSearching;
    property OnStart: TSearchEvent read FOnStart write FOnStart;
    property OnFinish: TNotifyEvent read FOnFinish write FOnFinish;
    property Root: string read FRoot write FRoot;
    property RootKey: HKEY read FRootKey write FRootKey;
    property Win64: Boolean read FWin64 write FWin64;
  end;

implementation

uses StrUtils, SysUtils;

{ TContextSearchThread }

{ public TContextSearchThread.Create

  Constructor for creating a TContextSearchThread instance. }

constructor TContextSearchThread.Create(AContextList: TContextList;
  ALock: TCriticalSection);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FContextList := AContextList;
  FLock := ALock;
  FLocations := TStringList.Create;

  // Init Registry access with read-only
  FReg := TRegistry.Create(KEY_WOW64_64KEY or KEY_READ);
  FRootKey := HKEY_CLASSES_ROOT;
  FRoot := '';
end;

{ public TContextSearchThread.Destroy

  Destructor for destroying a TContextSearchThread instance. }

destructor TContextSearchThread.Destroy();
begin
  FReg.CloseKey();
  FReg.Free;
  FLocations.Free;
  inherited Destroy;
end;

{ private TContextSearchThread.DoNotifyOnFinish

  Synchronizable event method that is called when search has finished. }

procedure TContextSearchThread.DoNotifyOnFinish();
begin
  if Assigned(FOnFinish) then
    FOnFinish(Self);
end;

{ private TContextSearchThread.DoNotifyOnSearching

  Synchronizable event method that is called when search is in progress. }

procedure TContextSearchThread.DoNotifyOnSearching();
begin
  if Assigned(FOnSearching) then
    FOnSearching(Self, FProgress);
end;

{ private TContextSearchThread.DoNotifyOnStart

  Synchronizable event method that is called when search has started. }

procedure TContextSearchThread.DoNotifyOnStart();
begin
  if Assigned(FOnSearching) then
    FOnStart(Self, FProgressMax);
end;

{ private TContextSearchThread.SearchSubkey

  Searches for pattern keys in a Registry subkey. }

procedure TContextSearchThread.SearchSubkey(AKeyName: string);
var
  Keys: TStringList;
  i: Integer;

begin
  Keys := TStringList.Create();

  try
    if not FReg.OpenKey(AKeyName, False) then
      Exit;

    if FReg.HasSubKeys() then
    begin
      // Load subkeys
      FReg.GetKeyNames(Keys);

      for i := 0 to Keys.Count - 1 do
      begin
        // Load ShellEx context menu items?
        if AnsiSameText(Keys[i], 'shellex') then
          FContextList.LoadContextmenu(AKeyName, False, FWin64);

        // Load Shell context menu items?
        if AnsiSameText(Keys[i], 'shell') then
          FContextList.LoadContextmenu(AKeyName, True, FWin64);
      end;  //of for
    end;  //of begin

  finally
    FReg.CloseKey();
    Keys.Free;
  end;  //of try
end;

{ private TContextSearchThread.LoadAllContextMenus

  Searches for context menu items in entire Registry. }

procedure TContextSearchThread.LoadAllContextMenus();
var
  i: Integer;
  Keys: TStringList;

begin
  Keys := TStringList.Create;

  try
    FReg.RootKey := FRootKey;
    FReg.OpenKey(FRoot, False);
    FReg.GetKeyNames(Keys);
    FReg.CloseKey();

    FProgressMax := Keys.Count;
    FProgress := 0;

    // Notify start of search
    Synchronize(DoNotifyOnStart);

    for i := 0 to Keys.Count - 1 do
    begin
      Synchronize(DoNotifyOnSearching);

      if (FRoot <> '') then
        SearchSubkey(FRoot +'\'+ Keys[i])
      else
        SearchSubkey(Keys[i]);

      Inc(FProgress);
    end;  //of for

  finally
    Keys.Free;
  end;  //of try
end;

{ private TContextSearchThread.LoadContextMenus

  Searches for specific context menu items in Registry. }

procedure TContextSearchThread.LoadContextMenus();
var
  i: Integer;

begin
  FProgressMax := FLocations.Count;
  FProgress := 0;

  // Notify start of search
  Synchronize(DoNotifyOnStart);

  // Search ...
  for i := 0 to FLocations.Count - 1 do
  begin
    Synchronize(DoNotifyOnSearching);
    FContextList.LoadContextmenu(FLocations[i], FWin64);
    Inc(FProgress);
  end;  //of for
end;

{ protected TContextSearchThread.Execute

  Searches for context menu items in Registry. }

procedure TContextSearchThread.Execute;
begin
  FLock.Acquire;

  // Clear data
  FContextList.Clear;

  // Load specific menus or search for all?
  if (FLocations.Count > 0) then
    LoadContextMenus()
  else
    LoadAllContextMenus();

  // Notify end of search
  Synchronize(DoNotifyOnFinish);
  FLock.Release;
end;

end.
