{ *********************************************************************** }
{                                                                         }
{ Clearas service search thread                                           }
{                                                                         }
{ Copyright (c) 2011-2015 P.Meisberger (PM Code Works)                    }
{                                                                         }
{ *********************************************************************** }

unit ServiceSearchThread;

interface

uses
  Windows, Classes, Registry, SyncObjs, ClearasAPI, OSUtils;

type
  { TServiceSearchThread }
  TServiceSearchThread = class(TThread)
  private
    FServiceList: TServiceList;
    FProgress, FProgressMax: Word;
    FOnSearching, FOnStart: TSearchEvent;
    FOnFinish: TNotifyEvent;
    FLock: TCriticalSection;
    procedure DoNotifyOnFinish();
    procedure DoNotifyOnSearching();
    procedure DoNotifyOnStart();
  protected
    procedure Execute; override;
  public
    constructor Create(AServiceList: TServiceList; ALock: TCriticalSection);
    { external }
    property OnFinish: TNotifyEvent read FOnFinish write FOnFinish;
    property OnSearching: TSearchEvent read FOnSearching write FOnSearching;
    property OnStart: TSearchEvent read FOnStart write FOnStart;
  end;

implementation

{ TServiceSearchThread }

{ public TServiceSearchThread.Create

  Constructor for creating a TServiceSearchThread instance. }

constructor TServiceSearchThread.Create(AServiceList: TServiceList;
  ALock: TCriticalSection);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FServiceList := AServiceList;
  FLock := ALock;
end;

{ private TServiceSearchThread.DoNotifyOnFinish

  Synchronizable event method that is called when search has finished. }

procedure TServiceSearchThread.DoNotifyOnFinish();
begin
  if Assigned(FOnFinish) then
    FOnFinish(Self);
end;

{ private TServiceSearchThread.DoNotifyOnSearching

  Synchronizable event method that is called when search is in progress. }

procedure TServiceSearchThread.DoNotifyOnSearching();
begin
  if Assigned(FOnSearching) then
  begin
    Inc(FProgress);
    FOnSearching(Self, FProgress);
  end;  //of begin
end;

{ private TServiceSearchThread.DoNotifyOnStart

  Synchronizable event method that is called when search has started. }

procedure TServiceSearchThread.DoNotifyOnStart();
begin
  if Assigned(FOnStart) then
    FOnStart(Self, FProgressMax);
end;

{ protected TContextMenuSearchThread.Execute

  Searches for startup items in Registry. }

procedure TServiceSearchThread.Execute;
var
  Reg: TRegistry;
  Services: TStringList;
  i: Integer;

begin
  FLock.Acquire;

  // Clear selected item
  FServiceList.Selected := nil;

  // Clear data
  FServiceList.Clear;

  Reg := TRegistry.Create(TOSUtils.DenyWOW64Redirection(KEY_READ));
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Services := TStringList.Create;

  try
    Reg.OpenKey(KEY_SERVICE_ENABLED, False);
    Reg.GetKeyNames(Services);

    // Notify start of search
    FProgressMax := Services.Count;
    Synchronize(DoNotifyOnStart);
    Reg.CloseKey();
    
    for i := 0 to Services.Count - 1 do
    begin
      Synchronize(DoNotifyOnSearching);
      FServiceList.LoadService(Services[i], Reg);
      Inc(FProgress);
    end;  //of for

  finally
    Services.Free;
    Reg.CloseKey();
    Reg.Free;

    // Notify end of search
    Synchronize(DoNotifyOnFinish);
    FLock.Release;
  end;  //of try
end;

end.
