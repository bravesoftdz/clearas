{ *********************************************************************** }
{                                                                         }
{ PM Code Works Cross Plattform Update Check Thread v2.2                  }
{                                                                         }
{ Copyright (c) 2011-2014 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit UpdateCheckThread;

{$IFDEF LINUX} {$mode delphi}{$H+} {$ENDIF}

interface

uses
  Classes, SysUtils, IdHTTP;

const
  URL_DIR = 'http://www.pm-codeworks.de/media/';
  
type
  { Thread event }
  TOnUpdateAvailableEvent = procedure(Sender: TThread; const ANewBuild: Cardinal; AChanges: string) of object;
  TOnUpdateCheckErrorEvent = procedure(Sender: TThread; AResponseCode: Integer) of object;

  { TUpdateCheckThread }
  TUpdateCheckThread = class(TThread)
  private
    FHttp: TIdHTTP;
    FOnUpdate: TOnUpdateAvailableEvent;
    FOnError: TOnUpdateCheckErrorEvent;
    FOnNoUpdate: TNotifyEvent;
    FCurBuild, FNewBuild: Cardinal;
    FRemoteDirName, FChanges: string;
    { Synchronizable events }
    procedure DoNotifyOnError;
    procedure DoNotifyOnNoUpdate;
    procedure DoNotifyOnUpdate;
  protected
    procedure Execute; override;
  public
    constructor Create(ACurrentBuild: Cardinal; ARemoteDirName: string;
      ACreateSuspended: Boolean = True);
    destructor Destroy; override;
    { Externalized events }
    property OnError: TOnUpdateCheckErrorEvent read FOnError write FOnError;
    property OnNoUpdate: TNotifyEvent read FOnNoUpdate write FOnNoUpdate;
    property OnUpdate: TOnUpdateAvailableEvent read FOnUpdate write FOnUpdate;
  end;

implementation

{ TUpdateCheckThread }

{ public TUpdateCheckThread.Create

  Constructor for creating a TUpdateCheckThread instance. }

constructor TUpdateCheckThread.Create(ACurrentBuild: Cardinal;
  ARemoteDirName: string; ACreateSuspended: Boolean = True);
begin
  inherited Create(ACreateSuspended);
  
  // Thread deallocates his memory
  FreeOnTerminate := True;

  FCurBuild := ACurrentBuild;
  FRemoteDirName := ARemoteDirName;
  
  // Init IdHTTP component dynamically
  FHttp := TIdHTTP.Create(nil);

  // Set the user-agent because of some issues with default 
  FHttp.Request.UserAgent := 'Mozilla/5.0 (PM Code Works Update Utility)';
end;

{ public TUpdateCheckThread.Destroy

  Destructor for destroying a TUpdateCheckThread instance. }

destructor TUpdateCheckThread.Destroy;
begin
  FHttp.Free; 
  inherited Destroy;
end;

{ protected TDownloadThread.Execute

  Thread main method that checks for update on an HTTP source. }
  
procedure TUpdateCheckThread.Execute;
var
  BaseUrl: string;

begin
  try
    BaseUrl := URL_DIR + FRemoteDirName;

    // Download version file for application
    FNewBuild := StrToInt(FHttp.Get(BaseUrl +'/version.txt'));

    // Check if downloaded version is newer than current version
    if (FNewBuild > FCurBuild) then
    begin
      try
        // Try to download the changes file
        FChanges := FHttp.Get(BaseUrl +'/changes.txt');

      except
        // Only catch exception: changes file is optional!
      end;  //of try

      // Notify "update available"
      Synchronize(DoNotifyOnUpdate);
    end  //of begin
    else
      // Notify "no update available"
      Synchronize(DoNotifyOnNoUpdate);

  except
    Synchronize(DoNotifyOnError);
  end;  //of except
end;

{ private TDownloadThread.DoNotifyOnError

  Synchronizable event method that is called when error occurs while searching
  for update. }

procedure TUpdateCheckThread.DoNotifyOnError;
begin
  if Assigned(OnError) then
    OnError(Self, FHttp.ResponseCode);
end;

{ private TDownloadThread.DoNotifyOnNoUpdate

  Synchronizable event method that is called when search returns no update. }
  
procedure TUpdateCheckThread.DoNotifyOnNoUpdate;
begin
  if Assigned(OnNoUpdate) then
    OnNoUpdate(Self);
end;

{ private TDownloadThread.DoNotifyOnNoUpdate

  Synchronizable event method that is called when search search returns an
  update. }

procedure TUpdateCheckThread.DoNotifyOnUpdate;
begin
  if Assigned(OnUpdate) then
    OnUpdate(Self, FNewBuild, FChanges);
end;

end.