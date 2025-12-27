<#
 # pwsh completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    File                         = Execute PowerShell script
    Command                      = Execute the specified commands (and any parameters).
    ConfigurationName            = Specifies a configuration endpoint in which PowerShell is run.
    ConfigurationFile            = Specifies a session configuration (.pssc) file path.
    CustomPipeName               = Specifies the name to use for an additional IPC server (named pipe).
    EncodedCommand               = Accepts a Base64-encoded string.
    ExecutionPolicy              = Sets the default execution policy.
    ExecutionPolicy_AllSigned    = Scripts can run. But requires sign by a trusted publisher.
    ExecutionPolicy_Bypass       = Nothing is blocked.
    ExecutionPolicy_RemoteSigned = Scripts can run. But downloaded scripts require sign by a trusted publisher.
    ExecutionPolicy_Restricted   = Permits individual commands, but does not allow scripts.
    ExecutionPolicy_Undefined    = No execution policy in the scope.
    ExecutionPolicy_Unrestricted = Unsigned scripts can run.
    InputFormat                  = Describes the format of data sent to PowerShell.
    Interactive                  = Present an interactive prompt to the user.
    Login                        = Starts PowerShell as a login shell (on Linux and macOS).
    MTA                          = Start PowerShell using a multi-threaded apartment.
    NoExit                       = Does not exit after running startup commands.
    NoLogo                       = Hides the banner.
    NonInteractive               = Create sessions that shouldn't require user input.
    NoProfile                    = Does not load the PowerShell profiles.
    NoProfileLoadTime            = Hides the PowerShell profile load time text
    OutputFormat                 = Determines how output from PowerShell is formatted.
    SettingsFile                 = Overrides the system-wide "powershell.config.json" settings file
    SSHServerMode                = Used in sshd_config for running PowerShell as an SSH subsystem.
    STA                          = Start PowerShell using a single-threaded apartment.
    Version                      = Displays the version of PowerShell.
    WindowStyle                  = Sets the window style for the session.
    WorkingDirectory             = Sets the initial working directory.
    Help                         = Displays help for pwsh.
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name pwsh -Description 'PowerShell' -Parameters @(
    New-ParamCompleter -Name File,f -Description $msg.File -Type File
    New-ParamCompleter -Name Command,c -Description $msg.Command -Type Required
    New-ParamCompleter -Name ConfigurationName,config -Description $msg.ConfigurationName -Type Required
    New-ParamCompleter -Name ConfigurationFile -Description $msg.ConfigurationFile -Type File
    New-ParamCompleter -Name CustomPipeName -Description $msg.CustomPipeName -Type Required
    New-ParamCompleter -Name EncodedCommand,e,ec -Description $msg.EncodedCommand -Type Required
    New-ParamCompleter -Name ExecutionPolicy,ex,ep -Description $msg.ExecutionPolicy -Arguments @(
        "AllSigned`t{0}" -f $msg.ExecutionPolicy_AllSigned
        "Bypass`t{0}" -f $msg.ExecutionPolicy_Bypass
        "RemoteSigned`t{0}" -f $msg.ExecutionPolicy_RemoteSigned
        "Restricted`t{0}" -f $msg.ExecutionPolicy_Restricted
        "Undefined`t{0}" -f $msg.ExecutionPolicy_Undefined
        "Unrestricted`t{0}" -f $msg.ExecutionPolicy_Unrestricted
    )
    New-ParamCompleter -Name InputFormat,inp,'if' -Description $msg.InputFormat -Arguments "Text", "XML"
    New-ParamCompleter -Name Interactive,i -Description $msg.Interactive
    New-ParamCompleter -Name Login,l -Description $msg.Login
    New-ParamCompleter -Name MTA -Description $msg.MTA
    New-ParamCompleter -Name NoExit,noe -Description $msg.NoExit
    New-ParamCompleter -Name NoLogo,nol -Description $msg.NoLogo
    New-ParamCompleter -Name NonInteractive,noni -Description $msg.NonInteractive
    New-ParamCompleter -Name NoProfile,nop -Description $msg.NoProfile
    New-ParamCompleter -Name NoProfileLoadTime -Description $msg.NoProfileLoadTime
    New-ParamCompleter -Name OutputFormat,o,of -Description $msg.OutputFormat -Arguments "Text", "XML"
    New-ParamCompleter -Name SettingsFile,settings -Description $msg.SettingsFile -Type File
    New-ParamCompleter -Name SSHServerMode,sshs -Description $msg.SSHServerMode
    New-ParamCompleter -Name STA -Description $msg.STA
    New-ParamCompleter -Name Version,v -Description $msg.Version
    New-ParamCompleter -Name WindowStyle,w -Description $msg.WindowStyle -Arguments "Normal", "Minimized", "Maximized", "Hidden"
    New-ParamCompleter -Name WorkingDirectory,wd -Description $msg.WorkingDirectory -Type Directory
    New-ParamCompleter -Name Help,? -Description $msg.Help
)
