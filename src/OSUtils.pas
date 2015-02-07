{ *********************************************************************** }
{                                                                         }
{ PM Code Works Operating System Utilities Unit v2.0.1                    }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit OSUtils;

{$IFDEF LINUX} {$mode delphi}{$H+} {$ENDIF}

interface

uses
 SysUtils,
{$IFDEF MSWINDOWS}
  Windows, Classes, TLHelp32, Registry, ShellAPI, MMSystem;
{$ELSE}
  Process, Resource, ElfReader, VersionResource, LResources;
{$ENDIF}

const
  { PMCW Website URLs }
  URL_BASE = 'http://www.pm-codeworks.de/';
  URL_CONTACT = URL_BASE +'kontakt.html';

type
  { Exception class }
  EInvalidArgument = class(Exception);

{$IFDEF MSWINDOWS}  
  { TWinWOW64 }
  TWinWOW64 = class(TObject)
  public
    class function DenyWOW64Redirection(AAccessRight: Cardinal): Cardinal;
    class function Wow64FsRedirection(ADisable: Boolean): Boolean;
    class function GetArchitecture(): string;
    class function IsWindows64(): Boolean;
  end;

  { TOSUtils }
  TOSUtils = class(TWinWOW64)
  protected
    class function KillProcess(AExeName: string): Boolean;
  public
    class function CreateTempDir(const AFolderName: string): Boolean;
    class function ExecuteProgram(const AProgram: string;
      AArguments: string = ''; ARunAsAdmin: Boolean = False): Boolean;
    class function ExitWindows(AAction: Word): Boolean;
    class function ExplorerReboot(): Boolean;
    class function ExpandEnvironmentVar(const AString: string): string;
    class function GetBuildNumber(): Cardinal;
    class function GetTempDir(): string;
    class function GetWinDir(): string;
    class function GetWinVersion(AShowServicePack: Boolean = False): string;
    class function HexToInt(AHexValue: string): Integer;
    class function HKeyToStr(AHKey: HKey): string;
    class function MakeUACShieldButton(AButtonHandle: HWND): Integer;
    class function OpenUrl(const AUrl: string): Boolean;
    class function PlaySound(AFileName: string; ASynchronized: Boolean = False): Boolean;
    class function PMCertExists(): Boolean;
    class function ShowAddRegistryDialog(ARegFilePath: string): Boolean;
    class function Shutdown(): Boolean;
    class function StrToHKey(const AMainKey: string): HKEY;
    class function WindowsVistaOrLater(): Boolean;
  end;
{$ELSE}
  { TOSUtils }
  TOSUtils = class(TObject)
  public
    class function GetBuildNumber(): Cardinal;
    class function HexToInt(AHexValue: string): Integer;
    class function OpenUrl(const AUrl: string): Boolean;
    class function PlaySound(AFileName: string; ASynchronized: Boolean = False): Boolean;
    class function Shutdown(): Boolean;
  end;
{$ENDIF}

implementation

uses StrUtils;

{$IFDEF MSWINDOWS}
{ TWinWOW64 }

{ protected TWinWOW64.Wow64FsRedirection

  Disables or reverts the WOW64 redirection on 64bit Windows. }

class function TWinWOW64.Wow64FsRedirection(ADisable: Boolean): Boolean;
type
  TWow64DisableWow64FsRedirection = function(OldValue: Pointer): BOOL; stdcall;
  TWow64RevertWow64FsRedirection = function(OldValue: Pointer): BOOL; stdcall;

var
  LibraryHandle: HMODULE;
  Wow64DisableWow64FsRedirection: TWow64DisableWow64FsRedirection;
  Wow64RevertWow64FsRedirection: TWow64RevertWow64FsRedirection;

begin
  result := False;

  // Init handle
  LibraryHandle := GetModuleHandle(kernel32);

  if (LibraryHandle <> 0) then
  begin
    if ADisable then
    begin
      Wow64DisableWow64FsRedirection := GetProcAddress(LibraryHandle, 'Wow64DisableWow64FsRedirection');

      // Loading of Wow64DisableWow64FsRedirection successful?
      if Assigned(Wow64DisableWow64FsRedirection) then
        result := Wow64DisableWow64FsRedirection(nil);
    end  //of begin
    else
       begin
         Wow64RevertWow64FsRedirection := GetProcAddress(LibraryHandle, 'Wow64RevertWow64FsRedirection');

         // Loading of Wow64RevertWow64FsRedirection successful?
         if Assigned(Wow64RevertWow64FsRedirection) then
           result := Wow64RevertWow64FsRedirection(nil);
       end;  //of begin
  end;  //of begin
end;

{ public TWinWOW64.IsWindows64

  Returns if current Windows is a 32 or 64bit OS. }

class function TWinWOW64.IsWindows64(): Boolean;
type
  TIsWow64Process = function(AHandle: THandle; var AIsWow64: BOOL): BOOL; stdcall;

var
  LibraryHandle: HMODULE;
  IsWow64: BOOL;
  IsWow64Process: TIsWow64Process;

begin
  result := False;
  LibraryHandle := GetModuleHandle(kernel32);

  if (LibraryHandle <> 0) then
  begin
    IsWow64Process := GetProcAddress(LibraryHandle, 'IsWow64Process');

    // Loading of IsWow64Process successful?
    if Assigned(IsWow64Process) then
      // Execute IsWow64Process against process
      if IsWow64Process(GetCurrentProcess(), IsWow64) then
        result := IsWow64;
  end;  //of begin
end;

{ public TWinWOW64.DenyWOW64Redirection

  Disables the WOW64 Registry redirection temporary under 64bit systems that
  a 32 bit application can get access to the 64 bit Registry. }

class function TWinWOW64.DenyWOW64Redirection(AAccessRight: Cardinal): Cardinal;
const
  KEY_WOW64_64KEY = $0100;

begin
  // Used Windows is a 64bit OS?
  if IsWindows64() then
    // Deny WOW64 redirection
    result := KEY_WOW64_64KEY or AAccessRight
  else
    // Ignore redirection
    result := AAccessRight;
end;

{ public TWinWOW64.GetArchitecture

  Returns formatted string indicating if current Windows is a 32 or 64bit OS. }

class function TWinWOW64.GetArchitecture(): string;
begin
  if IsWindows64() then
    result := ' [64bit]'
  else
    result := ' [32bit]';
end;


{ TOSUtils }

{ public TOSUtils.KillProcess

  Terminates a given process. }
  
class function TOSUtils.KillProcess(AExeName: string): Boolean;
var
  Continue: Boolean;
  snapshotHandle: THandle;
  processentry32: TProcessEntry32;
  ProcessID: string;
  Ph: THandle;

begin
  // Read out all running processes
  snapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  processentry32.dwSize := SizeOf(processentry32);
  Continue := Process32First(snapshotHandle, processentry32);

  // Try to search for given process name
  try
    while ((ExtractFileName(processentry32.szExeFile) <> AExeName) and Continue) do
      Continue := Process32Next(snapshotHandle, processentry32);

    // Save process ID for found process
    ProcessID := IntToHex(processentry32.th32ProcessID, 4);

    // Get handle of found process 
    Ph := OpenProcess($0001, BOOL(0), StrToInt('$'+ ProcessID));

    // Terminate found process
    result := (Integer(TerminateProcess(Ph, 0)) = 1);

  finally
    CloseHandle(snapshotHandle);
  end;  //of try
end;

{ public TOSUtils.CreateTempDir

  Creates an new folder in the temporay directory. }

class function TOSUtils.CreateTempDir(const AFolderName: string): Boolean;
begin
  result := ForceDirectories(GetTempDir() + AFolderName);
end;

{ public TOSUtils.ExecuteProgram

  Executes a program (optional as admin) using ShellExecute. }

class function TOSUtils.ExecuteProgram(const AProgram: string;
  AArguments: string = ''; ARunAsAdmin: Boolean = False): Boolean;
var
  Operation: PAnsiChar;

begin
  // Run as administrator?
  if ARunAsAdmin then
    Operation := 'runas'
  else
    Operation := 'open';

  result := (ShellExecute(0, Operation, PChar(AProgram), PChar(AArguments), nil,
    SW_SHOWNORMAL) > 32);
end;

{ public TOSUtils.ExitWindows

  Tells Windows to shutdown, reboot or log off. }

class function TOSUtils.ExitWindows(AAction: Word): Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';

var
  TTokenHd : THandle;
  TTokenPvg : TTokenPrivileges;
  cbtpPrevious : DWORD;
  rTTokenPvg : TTokenPrivileges;
  pcbtpPreviousRequired : DWORD;
  tpResult : Boolean;

begin
  if (AAction <> EWX_LOGOFF) and (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TTokenHd);

    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;

      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd, False, TTokenPvg, cbtpPrevious, rTTokenPvg, pcbtpPreviousRequired);
    end;  //of begin
  end;  //begin

  result := ExitWindowsEx(AAction, 0);   //EWX_SHUTDOWN, EWX_POWEROFF, (EWX_FORCE, EWX_FORCEIFHUNG)
end;

{ public TOSUtils.ExplorerReboot

  Expands an environment variable. }

class function TOSUtils.ExpandEnvironmentVar(const AString: string): string;
var
  BufferSize: Integer;

begin
  // Get required buffer size
  BufferSize := ExpandEnvironmentStrings(PChar(AString), nil, 0);

  if (BufferSize > 0) then
  begin
    // Read expanded string into result string
    SetLength(result, BufferSize - 1);
    ExpandEnvironmentStrings(PChar(AString), PChar(result), BufferSize);
  end
  else
    // Trying to expand empty string
    result := '';
end;

{ public TOSUtils.ExplorerReboot

  Restarts the explorer task of Windows. }

class function TOSUtils.ExplorerReboot(): Boolean;
begin
  result := KillProcess('explorer.exe');
end;

{ public TOSUtils.GetBuildNumber

  Returns build number of current running *.exe. }

class function TOSUtils.GetBuildNumber(): Cardinal;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;

begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);

  if (VerInfoSize <> 0) then
  begin
    GetMem(VerInfo, VerInfoSize);

    try
      GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);

      if VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
        with VerValue^ do
          result := (dwFileVersionLS and $FFFF)
      else
        result := 0;

    finally
      FreeMem(VerInfo, VerInfoSize);
    end;   //of try
  end  //of begin
  else
    result := 0;
end;
{$ELSE}
class function TOSUtils.GetBuildNumber(): Cardinal;
var
  RS : TResources;
  E : TElfResourceReader;
  VR : TVersionResource;
  i : Cardinal;

begin
  RS := TResources.Create;
  VR := nil;
  i := 0;

  try
    E := TElfResourceReader.Create;
    Rs.LoadFromFile(ParamStr(0), E);
    E.Free;

    while (VR = nil) and (i < RS.Count) do
    begin
      if RS.Items[i] is TVersionResource then
        VR := TVersionResource(RS.Items[i]);
      Inc(i);
    end;  //of while

    if Assigned(VR) then
      result := VR.FixedInfo.FileVersion[3];

  finally
    RS.FRee;
  end;  //of try
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
{ public TOSUtils.GetTempDir

  Returns path to the temporary directory of Windows. }

class function TOSUtils.GetTempDir(): string;
begin
  result := SysUtils.GetEnvironmentVariable('temp');
end;

{ public TOSUtils.GetWinDir

  Returns path to install directory of Windows. }

class function TOSUtils.GetWinDir(): string;
begin
  result := SysUtils.GetEnvironmentVariable('windir');
end;

{ public TOSUtils.GetWinVersion

  Returns used Windows version with optional information about installed
  service packs. }

class function TOSUtils.GetWinVersion(AShowServicePack: Boolean = False): string;
begin
  result := '';
  
  // Windows NT platform
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
    case Win32MajorVersion of
      5: case Win32MinorVersion of
           0: result := '2000';
           1: result := 'XP';
           2: result := 'XP 64-Bit Edition';
         end; //of case

      6: case Win32MinorVersion of
           0: result := 'Vista';
           1: result := '7';
           2: result := '8';
           3: result := '8.1';
         end; //of case
    end; //of case

  // Add information about service packs?
  if ((result <> '') and AShowServicePack and (Win32CSDVersion <> '')) then
    result := result +' '+ Win32CSDVersion;
end;
{$ENDIF}

{ public TOSUtils.HexToInt

  Converts a Hexadecimal value to integer. }

class function TOSUtils.HexToInt(AHexValue: string): Integer;
begin
  result := StrToInt('$'+ AHexValue);
end;

{$IFDEF MSWINDOWS}
{ public TOSUtils.HKeyToStr

  Converts a HKEY into its string representation. }

class function TOSUtils.HKeyToStr(AHKey: HKey): string;
begin
  case AHKey of
    HKEY_CLASSES_ROOT:   result := 'HKEY_CLASSES_ROOT';
    HKEY_CURRENT_USER:   result := 'HKEY_CURRENT_USER';
    HKEY_LOCAL_MACHINE:  result := 'HKEY_LOCAL_MACHINE';
    HKEY_USERS:          result := 'HKEY_USERS';
    HKEY_CURRENT_CONFIG: result := 'HKEY_CURRENT_CONFIG';
    else
      raise EInvalidArgument.Create('HKeyToStr: Bad format error! Unknown HKEY!');
  end;  //of case
end;

{ public TOSUtils.MakeUACShieldButton

  Adds the Windows UAC shield to a button. }

class function TOSUtils.MakeUACShieldButton(AButtonHandle: HWND): Integer;
const
  BCM_FIRST = $1600;
  BCM_SETSHIELD = BCM_FIRST + $000C;

begin
  result := SendMessage(AButtonHandle, BCM_SETSHIELD, 0, Integer(True));
end;
{$ENDIF}

{ public TOSUtils.OpenUrl

  Opens a given URL in the default web browser. }

class function TOSUtils.OpenUrl(const AUrl: string): Boolean;
{$IFNDEF MSWINDOWS}
var
  Process : TProcess;
{$ENDIF}
begin
  if not (AnsiStartsText('http://', AUrl) or AnsiStartsText('https://', AUrl)) then
  begin
    result := False;
    Exit;
  end;  //of begin

{$IFNDEF MSWINDOWS}
  if FileExists('/usr/bin/xdg-open') then
    try
      Process := TProcess.Create(nil);

      try
        Process.Executable := '/usr/bin/xdg-open';
        Process.Parameters.Append(AUrl);
        Process.Execute;
        result := True;

      finally
        Process.Free;
      end;  //of try

    except
      result := False;
    end  //of try
  else
    result := False;
{$ELSE}
  result := TOSUtils.ExecuteProgram(AUrl);
{$ENDIF}
end;

{ public TOSUtils.PlaySound

  Plays a *.wav file. }

class function TOSUtils.PlaySound(AFileName: string;
  ASynchronized: Boolean = False): Boolean;
{$IFNDEF MSWINDOWS}
var
  Process : TProcess;
{$ENDIF}
begin
  //AFileName := ExtractFilePath(ParamStr(0)) + AFileName;

  if ((ExtractFileExt(AFileName) <> '.wav') or (not FileExists(AFileName))) then
  begin
    result := False;
    SysUtils.Beep;
    Exit;
  end;  //of begin
  
{$IFDEF MSWINDOWS}
  if ASynchronized then
    SndPlaySound(PChar(AFileName), SND_SYNC)
  else
    SndPlaySound(PChar(AFileName), SND_ASYNC);

  result := True;
{$ELSE}
  Process := TProcess.Create(nil);

  try
    Process.Executable := '/usr/bin/aplay';
    Process.Parameters.Append(AFileName);

    if ASynchronized then
      Process.Options := Process.Options + [poWaitOnExit];

   Process.Execute;
   result := True;

  finally
    Process.Free;
  end;  //of try
{$ENDIF}
end;

{$IFDEF MSWINDOWS}
{ public TOSUtils.PMCertExists

  Returns if the PM Code Works certificate is already installed. }
  
class function TOSUtils.PMCertExists(): Boolean;
var
  reg: TRegistry;

const
  CERT_KEY = 'SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\';
  PM_CERT_THUMBPRINT = '1350A832ED8A6A8FE8B95D2E674495021EB93A4D';

begin
  reg := TRegistry.Create(DenyWOW64Redirection(KEY_READ));
  
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    result := (reg.OpenKeyReadOnly(CERT_KEY) and reg.KeyExists(PM_CERT_THUMBPRINT));
    reg.CloseKey;

  finally
    reg.Free;
  end;  //of try
end;

{ public TOSUtils.ShowAddRegistryDialog

  Shows an dialog where user has the choice to add a *.reg file.  }

class function TOSUtils.ShowAddRegistryDialog(ARegFilePath: string): Boolean;
begin
  if (ARegFilePath = '') then
    raise EInvalidArgument.Create('Missing parameter with a .reg file!');

  if (ARegFilePath[1] <> '"') then
    ARegFilePath := '"'+ ARegFilePath +'"';

  result := TOSUtils.ExecuteProgram('regedit.exe', ARegFilePath);
end;
{$ENDIF}

{ public TOSUtils.Shutdown

  Tells the OS to shutdown the computer. }

class function TOSUtils.Shutdown(): Boolean;
{$IFNDEF MSWINDOWS}
var
  Process: TProcess;

begin
  if FileExists('/usr/bin/dbus-send') then
    try
      Process := TProcess.Create(nil);

      try
        Process.Executable := '/usr/bin/dbus-send';

        with Process.Parameters do
        begin
          Append('--system');
          Append('--print-reply');
          Append('--dest=org.freedesktop.ConsoleKit');
          Append('/org/freedesktop/ConsoleKit/Manager');
          Append('org.freedesktop.ConsoleKit.Manager.Stop');
        end;  //of with

        Process.Execute;
        result := True;

      finally
        Process.Free;
      end;  //of try

    except
      result := False;
    end  //of try
  else
    result := False;
end;
{$ELSE}
begin
  result := TOSUtils.ExitWindows(EWX_SHUTDOWN or EWX_FORCE);
end;

{ public TOSUtils.StrToHKey

  Converts short HKEY string into real HKEY type. } 

class function TOSUtils.StrToHKey(const AMainKey: string): HKEY;
begin
  if (AMainKey = 'HKCR') then
    result := HKEY_CLASSES_ROOT
  else
    if (AMainKey = 'HKCU') then
      result := HKEY_CURRENT_USER
    else
      if (AMainKey = 'HKLM') then
        result := HKEY_LOCAL_MACHINE
      else
        if (AMainKey = 'HKU') then
          result := HKEY_USERS
        else
          if (AMainKey = 'HKCC') then
            result := HKEY_CURRENT_CONFIG
          else
            raise EInvalidArgument.Create('StrToHKey: Bad format error! '
              +'Unknown HKEY: "'+ AMainKey +'"!');
end;

{ public TOSUtils.WindowsVistaOrLater

  Returns if current Windows version is equal or greater than Windows Vista. }

class function TOSUtils.WindowsVistaOrLater(): Boolean;
begin
  result := ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion >= 6));
end;
{$ENDIF}

end.
