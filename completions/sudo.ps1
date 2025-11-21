<#
 # sudo completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu_help             = Display help and exit
    gnu_version          = Display version information and exit
    gnu_askpass          = Ask for password via the askpass or $SSH_ASKPASS program
    gnu_closeall         = Close all file descriptors greater or equal to the given number
    gnu_preserve_env     = Preserve environment
    gnu_home             = Set home
    gnu_remove_timestamp = Remove the credential timestamp entirely
    gnu_preserve_groups  = Preserve group vector
    gnu_stdin            = Read password from stdin
    gnu_background       = Run command in the background
    gnu_edit             = Edit
    gnu_group            = Run command as group
    gnu_login            = Run a login shell
    gnu_reset_timestamp  = Reset or ignore the credential timestamp
    gnu_list             = List the allowed and forbidden commands for the given user
    gnu_non_interactive  = Do not prompt for a password - if one is needed, fail
    gnu_prompt           = Specify a custom password prompt
    gnu_shell            = Run the given command in a shell
    gnu_user             = Run command as user
    gnu_validate         = Validate the credentials, extending timeout

# from: https://github.com/microsoft/sudo/blob/main/sudo/Resources/en-US/Sudo.resw
    win_Base_Help        = Print help
    win_Base_Version     = Print version
    win_Run              = Run a command as admin
    win_Run_CopyEnv      = Pass the current environment variables to the command
    win_Run_NewWindow    = Use a new window for the command
    win_Run_DisableInput = Run in the current terminal, with input to the target application disabled
    win_Run_Inline       = Run in the current terminal
    win_Run_Chdir        = Change the working directory before running the command
    win_Config           = Get current configuration information of sudo
    win_Config_Enable    = Enable configuration
    win_Help             = Print this message or the help of the given subcommand(s)
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsWindows)
{
    $runPreserveEnvParam = New-ParamCompleter -ShortName E -LongName preserve-env -Description $msg.win_Run_CopyEnv
    $runNewWindowParam = New-ParamCompleter -ShortName N -LongName new-window -Description $msg.win_Run_NewWindow
    $runDisableInputParam = New-ParamCompleter -LongName disable-input -Description $msg.win_Run_DisableInput
    $runInlineParam = New-ParamCompleter -LongName inline -Description $msg.win_Run_Inline
    $runChdirParam = New-ParamCompleter -ShortName D -LongName chdir -Description $msg.win_Run_Chdir -Type Directory

    Register-NativeCompleter -Name sudo -Description 'Sudo for Windows' -DelegateArgumentIndex 0 -SubCommands @(
        New-CommandCompleter -Name run -Description $msg.win_Run -DelegateArgumentIndex 0 -Parameters @(
            $runPreserveEnvParam, $runNewWindowParam, $runDisableInputParam, $runInlineParam, $runChdirParam
        )
        New-CommandCompleter -Name config -Description $msg.win_Config -Parameters @(
            New-ParamCompleter -LongName enable -Description $msg.win_Config_Enable -Arguments "disable", "enable", "forceNewWindow", "disableInput", "normal", "default"
        )
        New-CommandCompleter -Name help -Description $msg.win_Help -ArgumentCompleter {
            $arg = $_;
            $results = "run", "config", "help" | Where-Object { $_.StartsWith($arg, [System.StringComparison]::OrdinalIgnoreCase) }
            if ($results.Count -eq 0) { return $null }
            $results
        }
    ) -Parameters @(
        $runPreserveEnvParam, $runNewWindowParam, $runDisableInputParam, $runInlineParam, $runChdirParam
        New-ParamCompleter -ShortName h -LongName help -Description $msg.win_Base_Help
        New-ParamCompleter -ShortName V -LongName version -Description $msg.win_Base_Version
    )
}
else
{
    Register-NativeCompleter -Name sudo -DelegateArgumentIndex 0 -Parameters @(
        New-ParamCompleter -ShortName h -Description $msg.gnu_help
        New-ParamCompleter -ShortName V -Description $msg.gnu_version
        New-ParamCompleter -ShortName A -Description $msg.gnu_askpass
        New-ParamCompleter -ShortName C -Description $msg.gnu_closeall -Arguments "0", "1", "2", "255"
        New-ParamCompleter -ShortName E -Description $msg.gnu_preserve_env
        New-ParamCompleter -ShortName H -Description $msg.gnu_home
        New-ParamCompleter -ShortName K -Description $msg.gnu_remove_timestamp
        New-ParamCompleter -ShortName P -Description $msg.gnu_preserve_groups
        New-ParamCompleter -ShortName S -Description $msg.gnu_stdin
        New-ParamCompleter -ShortName b -Description $msg.gnu_background
        New-ParamCompleter -ShortName e -Description $msg.gnu_edit -Type File
        New-ParamCompleter -ShortName g -Description $msg.gnu_group -Type Required
        New-ParamCompleter -ShortName i -Description $msg.gnu_login
        New-ParamCompleter -ShortName k -Description $msg.gnu_reset_timestamp
        New-ParamCompleter -ShortName l -Description $msg.gnu_list
        New-ParamCompleter -ShortName n -Description $msg.gnu_non_interactive
        New-ParamCompleter -ShortName p -Description $msg.gnu_prompt -Type Required
        New-ParamCompleter -ShortName s -Description $msg.gnu_shell
        New-ParamCompleter -ShortName u -Description $msg.gnu_user -Type Required
        New-ParamCompleter -ShortName v -Description $msg.gnu_validate
    )
}
