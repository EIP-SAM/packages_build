#define url "https://eip-sam.github.io"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{B28437AF-E0E7-4431-A10D-0A6FBC4C072E}
AppName={#_pkgname}
AppVersion={#pkgver}
AppPublisher={#publisher}
AppPublisherURL={#url}
AppSupportURL="https://github.com/EIP-SAM/SAM-Solution-Daemon-Client"
AppUpdatesURL="https://github.com/EIP-SAM/SAM-Solution-Daemon-Client/releases"
DefaultDirName="{pf}\{#pkgname}"
DisableDirPage=yes
DefaultGroupName={#_pkgname}
OutputDir={#output_dir}
LicenseFile="{#source_dir}\LICENSE"
OutputBaseFilename=setup_{#pkgname}_{#pkgver}_any
Compression=lzma
SolidCompression=yes

[Run]
Filename: "{sys}\cmd.exe"; Parameters: "/c ""{app}\system_config\install_chocolatey.cmd"" "
Filename: "{sys}\cmd.exe"; Parameters: "/c ""{app}\system_config\install_choco_dependancies.cmd"" "
Filename: "{sys}\cmd.exe"; Parameters: "/c ""{app}\system_config\install_npm_dependancies.cmd"" "
Filename: "{sys}\cmd.exe"; Parameters: "/c ""{app}\system_config\install_as_service.cmd"" "

[UninstallRun]
Filename: "{sys}\cmd.exe"; Parameters: "/c ""{app}\system_config\uninstall_service.cmd"" "

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "{#source_dir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:ProgramOnTheWeb,{#_pkgname}}"; Filename: "{#url}"
Name: "{group}\{cm:UninstallProgram,{#_pkgname}}"; Filename: "{uninstallexe}"
