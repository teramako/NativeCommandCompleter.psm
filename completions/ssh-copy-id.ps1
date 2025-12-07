<#
 # ssh-copy-id completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ssh_copy_id = use locally available keys to authorise logins on a remote machine
    identity    = Identity file to use
    force       = Force mode: add keys without checking if they are already present
    dryrun      = Do not actually copy keys; only show what would be done
    sftp        = Use sftp
    port        = Connect to this port on the remote host
    option      = Pass this option to ssh
    debug       = debugging the ssh-copy-id script
    help        = Show help message
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ssh-copy-id -Description $msg.ssh_copy_id -Parameters @(
    New-ParamCompleter -ShortName i -Description $msg.identity -Type File -VariableName 'identity_file'
    New-ParamCompleter -ShortName f -Description $msg.force
    New-ParamCompleter -ShortName n -Description $msg.dryrun
    New-ParamCompleter -ShortName s -Description $msg.sftp
    New-ParamCompleter -ShortName p -Description $msg.port -Type Required -VariableName 'port'
    New-ParamCompleter -ShortName o -Description $msg.option -Type Required -VariableName 'ssh_option'
    New-ParamCompleter -ShortName x -Description $msg.debug
    New-ParamCompleter -ShortName h -Description $msg.help
) -NoFileCompletions
