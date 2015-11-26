{ *********************************************************************** }
{                                                                         }
{ PM Code Works Cross Plattform Update Check Thread v3.0                  }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit PMCWUpdateCheckThread;

{$IFDEF LINUX} {$mode delphi}{$H+} {$ENDIF}

interface

uses
  Classes, SysUtils, IdHTTP;

const
  /// <summary>
  ///   URL to the download (base) directory on website.
  /// </summary>
  URL_DIR = 'http://www.pm-codeworks.de/media/';

type
  { Thread event }
  TOnUpdateAvailableEvent = procedure(Sender: TThread; const ANewBuild: Cardinal) of object;
  TOnUpdateCheckErrorEvent = procedure(Sender: TThread; AResponseCode: Integer;
    AResponseText: string) of object;

  /// <summary>
  ///   A <c>TUpdateCheckThread</c> downloads the version.txt from the website
  ///   and notifies about update status.
  /// </summary>
  TUpdateCheckThread = class(TThread)
  private
    FHttp: TIdHTTP;
    FResponseCode: Integer;
    FResponseText: string;
    FOnUpdate: TOnUpdateAvailableEvent;
    FOnError: TOnUpdateCheckErrorEvent;
    FOnNoUpdate: TNotifyEvent;
    FCurBuild, FNewBuild: Cardinal;
    FRemoteDirName: string;
    procedure DoNotifyOnError;
    procedure DoNotifyOnNoUpdate;
    procedure DoNotifyOnUpdate;
  protected
    procedure Execute; override;
  public
    /// <summary>
    ///   Constructor for creating a <c>TUpdateCheckThread</c> instance.
    /// </summary>
    /// <param name="ACurrentBuild">
    ///   The build number of the current program.
    /// </param>
    /// <param name="ARemoteDirName">
    ///   The directory on website which contains the version.txt file.
    /// </param>
    /// <param name="ACreateSuspended">
    ///   If set to <c>True</c> the thread is created suspendend and does not
    ///   start directly. Needed if some events must be registered. To really
    ///   start the thread use the <c>Start()</c> method. If set to <c>False</c>
    ///   the thread starts directly executing!
    /// </param>
    constructor Create(ACurrentBuild: Cardinal; ARemoteDirName: string;
      ACreateSuspended: Boolean = True);

    /// <summary>
    ///   Destructor for destroying a <c>TUpdateCheckThread</c> instance.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Occurs when search for update fails.
    /// </summary>
    property OnError: TOnUpdateCheckErrorEvent read FOnError write FOnError;

    /// <summary>
    ///   Occurs when no update is available.
    /// </summary>
    property OnNoUpdate: TNotifyEvent read FOnNoUpdate write FOnNoUpdate;

    /// <summary>
    ///   Occurs when an update is available.
    /// </summary>
    property OnUpdate: TOnUpdateAvailableEvent read FOnUpdate write FOnUpdate;
  end;

implementation

{ TUpdateCheckThread }

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

  // Setup some HTTP options
  with FHttp.Request do
  begin
    // Set the user-agent because of some issues with default
    UserAgent := 'Updater/3.0 (PM Code Works Update Utility)';

    // Only accept plain text
    Accept := 'text/plain';

    // Close connection after completion of the response
    Connection := 'close';
  end;  //of with
end;

destructor TUpdateCheckThread.Destroy;
begin
  FHttp.Free;
  inherited Destroy;
end;

procedure TUpdateCheckThread.Execute;
var
  VersionUrl: string;
  ErrorCode: Integer;

begin
  try
    // Download version file for application
    VersionUrl := URL_DIR + FRemoteDirName +'/version.txt';
    Val(FHttp.Get(VersionUrl), FNewBuild, ErrorCode);

    // Invalid response?
    // Note: Should NEVER be raised!
    if (ErrorCode <> 0) then
      raise EConvertError.Create('Error while parsing response!');

    // Check if downloaded version is newer than current version
    if (FNewBuild > FCurBuild) then
      // Notify "update available"
      Synchronize(DoNotifyOnUpdate)
    else
      // Notify "no update available"
      Synchronize(DoNotifyOnNoUpdate);

  except
    on E: EConvertError do
    begin
      FResponseCode := 406;
      FResponseText := E.Message;
      Synchronize(DoNotifyOnError);
    end;

    on E: Exception do
    begin
      FResponseCode := FHttp.ResponseCode;
      FResponseText := FHttp.ResponseText;
      Synchronize(DoNotifyOnError);
    end;
  end;  //of try
end;

procedure TUpdateCheckThread.DoNotifyOnError;
begin
  if Assigned(OnError) then
    OnError(Self, FResponseCode, FResponseText);
end;

procedure TUpdateCheckThread.DoNotifyOnNoUpdate;
begin
  if Assigned(OnNoUpdate) then
    OnNoUpdate(Self);
end;

procedure TUpdateCheckThread.DoNotifyOnUpdate;
begin
  if Assigned(OnUpdate) then
    OnUpdate(Self, FNewBuild);
end;

end.