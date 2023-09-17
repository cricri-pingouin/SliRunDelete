unit unit1;

interface

uses
  Windows, SysUtils, Forms, ShellApi, StdCtrls, Classes, Controls, IniFiles,
  StrUtils; //, Dialogs;

type
  TMainForm = class(TForm)
    btnPowerOff: TButton;
    btnRun: TButton;
    btnDelete: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRunClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPowerOffClick(Sender: TObject);
    procedure RunMyFile();
    procedure DeleteMyFile();
    procedure ShutdownMyComputer();
  private
    { Private declarations }
  public
    { Public declarations }
    //Settings
    ExecutablePath: string;
    FilesPath: string;
    OpenExtensions: string;
    AutoRun, RunAndExit, DeletePermanently, AutoShutdown: Boolean;
    //File to open
    FileName: string;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

function RecycleFile(FileName: string): boolean;
var
  Struct: TSHFileOpStruct;
  pFromc: array[0..255] of char;
  Resultval: integer;
begin
  if not FileExists(FileName) then
  begin
    Result := False;
    exit;
  end
  else
  begin
    fillchar(pFromc, sizeof(pFromc), 0);
    StrPcopy(pFromc, expandfilename(FileName) + #0#0);
    Struct.wnd := 0;
    Struct.wFunc := FO_DELETE;
    Struct.pFrom := pFromc;
    Struct.pTo := nil;
    Struct.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
    Struct.fAnyOperationsAborted := false;
    Struct.hNameMappings := nil;
    Resultval := ShFileOperation(Struct);
    Result := (Resultval = 0);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  myINI: TINIFile;
begin
  //Initialise options from INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'rundel.ini');
  ExecutablePath := myINI.ReadString('Settings', 'ExecutablePath', 'D:\Utils\Video\Media Player Classic\mpc-be64.exe');
  FilesPath := myINI.ReadString('Settings', 'FilesPath', 'D:\');
  OpenExtensions := myINI.ReadString('Settings', 'Extensions', '*.mkv');
  AutoRun := myINI.ReadBool('Settings', 'AutoRun', False);
  RunAndExit := myINI.ReadBool('Settings', 'RunAndExit', False);
  DeletePermanently := myINI.ReadBool('Settings', 'DeletePermanently', False);
  AutoShutDown := myINI.ReadBool('Settings', 'AutoShutdown', False);
  myINI.Free;
  //Run if AutoRun true
  if AutoRun = True then
    RunMyFile();
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  myINI: TINIFile;
begin
  //Save settings to INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'rundel.ini');
  myINI.WriteString('Settings', 'ExecutablePath', ExecutablePath);
  myINI.WriteString('Settings', 'FilesPath', FilesPath);
  myINI.WriteString('Settings', 'OpenExtensions', OpenExtensions);
  myINI.WriteBool('Settings', 'AutoRun', AutoRun);
  myINI.WriteBool('Settings', 'RunAndExit', RunAndExit);
  myINI.WriteBool('Settings', 'DeletePermanently', DeletePermanently);
  myINI.WriteBool('Settings', 'AutoShutDown', AutoShutDown);
  myINI.Free;
end;

procedure TMainForm.btnRunClick(Sender: TObject);
begin
  RunMyFile();
end;

procedure TMainForm.btnDeleteClick(Sender: TObject);
begin
  DeleteMyFile();
end;

procedure TMainForm.btnPowerOffClick(Sender: TObject);
begin
  ShutdownMyComputer();
end;

procedure TMainForm.RunMyFile();
var
  SRec: TSearchRec;
begin
  //Make sure path ends with \
  if RightStr(FilesPath, 1) <> '\' then
    FilesPath := FilesPath + '\';
  //Get first file
  try
    if FindFirst(PChar(FilesPath + OpenExtensions), faAnyfile - faDirectory, SRec) = 0 then
      FileName := SRec.Name;
  finally
    FindClose(SRec)
  end;
  //Execute file
  if ExecutablePath <> '' then
    ShellExecute(0, 'open', PChar(ExecutablePath), PChar('"' + FilesPath + FileName + '"'), nil, SW_SHOWNORMAL)
  else
    ShellExecute(0, 'open', PChar('"' + FilesPath + FileName + '"'), nil, nil, SW_SHOWNORMAL);
  if RunAndExit = True then
    Application.Terminate;
  //Activate Delete button
  ActiveControl := btnDelete;
end;

procedure TMainForm.DeleteMyFile();
begin
  if FileExists(FilesPath + FileName) then
    if DeletePermanently = False then
      RecycleFile(FilesPath + FileName) //Send to Recycle Bin
    else
      DeleteFile(FilesPath + FileName); //Delete permanently
  //Activate Power off button
  ActiveControl := btnPowerOff;
  //Shutdown if AutoShutdown true
  if AutoShutdown = True then
    ShutdownMyComputer();
end;

procedure TMainForm.ShutdownMyComputer();
begin
  ShellExecute(0, nil, 'cmd.exe', '/c shutdown /p /f', nil, SW_HIDE);
  Close;
end;

end.

