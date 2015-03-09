{ *********************************************************************** }
{                                                                         }
{ Clearas startup search thread                                           }
{                                                                         }
{ Copyright (c) 2011-2015 P.Meisberger (PM Code Works)                    }
{                                                                         }
{ *********************************************************************** }

unit StartupSearchThread;

interface

uses
  Classes, SyncObjs, ClearasAPI;

type
  TStartupSearchThread = class(TThread)
  private
    FStartupList: TStartupList;
    FIncludeRunOnce, FWin64: Boolean;
    FProgress, FProgressMax: Byte;
    FOnSearching, FOnStart: TSearchEvent;
    FOnFinish: TNotifyEvent;
    FLock: TCriticalSection;
    procedure DoNotifyOnFinish();
    procedure DoNotifyOnSearching();
    procedure DoNotifyOnStart();
    procedure LoadEnabled(const AAllUsers: Boolean); overload;
    procedure LoadEnabled(const AHKey, AKeyName: string); overload;
    procedure LoadDisabled(AStartupUser: Boolean);
  protected
    procedure Execute; override;
  public
    constructor Create(AStartupList: TStartupList; ALock: TCriticalSection);
    { external }
    property IncludeRunOnce: Boolean read FIncludeRunOnce write FIncludeRunOnce;
    property OnFinish: TNotifyEvent read FOnFinish write FOnFinish;
    property OnSearching: TSearchEvent read FOnSearching write FOnSearching;
    property OnStart: TSearchEvent read FOnStart write FOnStart;
    property Win64: Boolean read FWin64 write FWin64;
  end;

implementation

{ TStartupSearchThread }

{ public TStartupSearchThread.Create

  Constructor for creating a TStartupSearchThread instance. }

constructor TStartupSearchThread.Create(AStartupList: TStartupList;
  ALock: TCriticalSection);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FStartupList := AStartupList;
  FLock := ALock;
end;

{ private TStartupSearchThread.DoNotifyOnFinish

  Synchronizable event method that is called when search has finished. }

procedure TStartupSearchThread.DoNotifyOnFinish();
begin
  if Assigned(FOnFinish) then
    FOnFinish(Self);
end;

{ private TStartupSearchThread.DoNotifyOnSearching

  Synchronizable event method that is called when search is in progress. }

procedure TStartupSearchThread.DoNotifyOnSearching();
begin
  if Assigned(FOnSearching) then
  begin
    Inc(FProgress);
    FOnSearching(Self, FProgress);
  end;  //of begin
end;

{ private TStartupSearchThread.DoNotifyOnStart

  Synchronizable event method that is called when search has started. }

procedure TStartupSearchThread.DoNotifyOnStart();
begin
  if Assigned(FOnStart) then
    FOnStart(Self, FProgressMax);
end;

{ public TStartupList.LoadEnabled

  Searches for enabled startup user items and adds them to the list. }

procedure TStartupSearchThread.LoadEnabled(const AAllUsers: Boolean);
begin
  Synchronize(DoNotifyOnSearching);
  FStartupList.LoadEnabled(AAllUsers);
end;

{ private TStartupSearchThread.LoadEnabled

  Searches for enabled startup items and adds them to the list. }

procedure TStartupSearchThread.LoadEnabled(const AHKey, AKeyName: string);
begin
  Synchronize(DoNotifyOnSearching);
  FStartupList.LoadEnabled(AHKey, AKeyName);
end;

{ private TStartupSearchThread.LoadEnabled

  Searches for disabled startup user items and adds them to the list. }

procedure TStartupSearchThread.LoadDisabled(AStartupUser: Boolean);
begin
  Synchronize(DoNotifyOnSearching);
  FStartupList.LoadDisabled(AStartupUser);
end;

{ protected TContextMenuSearchThread.Execute

  Searches for startup items in Registry. }

procedure TStartupSearchThread.Execute;
const
  KEYS_COUNT_MAX = 11;

begin
  FLock.Acquire;
  
  // Clear selected item
  FStartupList.Selected := nil;

  // Clear data
  FStartupList.Clear;

  // Calculate key count for events
  if FWin64 then
    FProgressMax := KEYS_COUNT_MAX
  else
    FProgressMax := KEYS_COUNT_MAX - 3;

  if not FIncludeRunOnce then
    FProgressMax := FProgressMax - 2;

  // Notify start of search
  Synchronize(DoNotifyOnStart);
  FProgress := 0;

  // Start loading...
  LoadEnabled('HKLM', KEY_STARTUP);

  // Load WOW6432 Registry key only on 64bit Windows
  if FWin64 then
    LoadEnabled('HKLM', KEY_STARTUP32);

  // Read RunOnce entries?
  if FIncludeRunOnce then
  begin
    LoadEnabled('HKLM', KEY_RUNONCE);
    LoadEnabled('HKCU', KEY_RUNONCE);

    // Load WOW6432 Registry keys only on 64bit Windows
    if FWin64 then
    begin
      LoadEnabled('HKLM', KEY_RUNONCE32);
      LoadEnabled('HKCU', KEY_RUNONCE32);
    end;  //of begin
  end;  //of begin

  LoadEnabled('HKCU', KEY_STARTUP);
  LoadEnabled(True);
  LoadEnabled(False);
  LoadDisabled(False);
  LoadDisabled(True);

  // Notify end of search
  Synchronize(DoNotifyOnFinish);
  FLock.Release;
end;

end.
