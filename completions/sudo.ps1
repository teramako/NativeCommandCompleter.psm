<#
 # sudo completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu_help = Display help and exit
    gnu_version = Display version information and exit
    gnu_askpass = Ask for password via the askpass or $SSH_ASKPASS program
    gnu_closeall = Close all file descriptors greater or equal to the given number
    gnu_preserve_env = Preserve environment
    gnu_home         = Set home
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
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU sudo
sudo --version 2>&1 | Out-Null
if ($IsWindows)
{
    # TBD
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
    ) -ArgumentCompleter {
        param([int] $position, [int] $argIndex)
        if ($argIndex -eq 0)
        {
            # Complete commands in $env:PATH or the path to a command
            $results = [System.Management.Automation.CompletionCompleters]::CompleteCommand($_, $null, [System.Management.Automation.CommandTypes]::Application);
            if ($results.Count -gt 0)
            {
                $results;
            }
            else
            {
                [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
                    $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or
                    $_.UnixFileMode.HasFlag([System.IO.UnixFileMode]::UserExecute -bor [System.IO.UnixFileMode]::GroupExecute -bor [System.IO.UnixFileMode]::OtherExecute)
                });
            }
        }
    }
}
