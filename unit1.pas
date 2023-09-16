unit unit1;

interface

uses
  Windows, SysUtils, Forms, Dialogs, ShellApi, StdCtrls, Classes, Controls,
  IniFiles, StrUtils;

type
  TMainForm = class(TForm)
    btnPowerOff: TButton;
    btnRun: TButton;
    btnDelete: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnPowerOffClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RunMyFile();
    procedure DeleteMyFile();
    procedure ShutdownMyComputer();
  private
    { Private declarations }
  public
    { Public declarations }
    //Settings
    //ExecutablePath: string;
    FilesPath: string;
    OpenExtensions: string;
    DeletePermanently, AutoRun, AutoShutdown: Boolean;
    //File to open
    FileName: string;
    FullPathName: PChar;
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
  SRec: TSearchRec;
begin
  //Initialise options from INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'rundel.ini');
  //ExecutablePath := myINI.ReadString('Settings', 'ExecutablePath', 'D:\Utils\Video\Media Player Classic\mpc-be64.exe');
  FilesPath := myINI.ReadString('Settings', 'FilesPath', 'D:\');
  OpenExtensions := myINI.ReadString('Settings', 'Extensions', '*.mkv');
  DeletePermanently := myINI.ReadBool('Settings', 'DeletePermanently', False);
  AutoRun := myINI.ReadBool('Settings', 'AutoRun', False);
  AutoShutDown := myINI.ReadBool('Settings', 'AutoShutdown', False);
  myINI.Free;
  //Get first file
  try
    if FindFirst(PChar(FilesPath + OpenExtensions), faAnyfile, SRec) = 0 then
      repeat
        FileName := SRec.Name;
      until (FindNext(SRec) <> 0) or (SRec.Size > 0);
  finally
    FindClose(SRec)
  end;
  if RightStr(FilesPath, 1) <> '\' then
    FilesPath := FilesPath + '\';
  FullPathName := PChar(FilesPath + FileName);
  if AutoRun = True then
    RunMyFile();
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  myINI: TINIFile;
begin
  //Save settings to INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'rundel.ini');
  //myINI.WriteString('Settings', 'ExecutablePath', ExecutablePath);
  myINI.WriteString('Settings', 'FilesPath', FilesPath);
  myINI.WriteString('Settings', 'OpenExtensions', OpenExtensions);
  myINI.WriteBool('Settings', 'DeletePermanently', DeletePermanently);
  myINI.WriteBool('Settings', 'AutoRun', AutoRun);
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
begin
  ShellExecute(Handle, 'open', FullPathName, nil, nil, SW_SHOWNORMAL);
  ActiveControl := btnDelete;
end;

procedure TMainForm.DeleteMyFile();
begin
  if fileexists(FullPathName) then
  begin
    if DeletePermanently = False then
      RecycleFile(FullPathName) //Send to Recycle Bin
    else
      DeleteFile(FullPathName); //Delete permanently
  end;
  //Shutdown if auto on
  ActiveControl := btnPowerOff;
  if AutoShutdown = True then
    ShutdownMyComputer();
end;

procedure TMainForm.ShutdownMyComputer();
begin
  ShellExecute(0, nil, 'cmd.exe', '/C shutdown /p', nil, SW_HIDE);
  Close;
end;

end.

