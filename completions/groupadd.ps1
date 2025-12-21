<#
 # groupadd completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    groupadd            = create a new group
    force               = Exit successfully if the group already exists
    gid                 = Use GID for the new group
    help                = Display help message and exit
    key                 = Override /etc/login.defs defaults
    non_unique          = Allow to create groups with duplicate (non-unique) GID
    password            = Use this encrypted password for the new group
    root                = Apply changes in the CHROOT_DIR directory
    system              = Create a system group
    prefix              = Apply changes in the PREFIX_DIR directory
    users               = A list of usernames to add as members of the group
    extrausers          = Use the extra users database
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name groupadd -Description $msg.groupadd -Parameters @(
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -ShortName g -LongName gid -Description $msg.gid -Type Required -VariableName 'GID'
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName K -LongName key -Description $msg.key -Type Required -VariableName 'KEY=VALUE'
    New-ParamCompleter -ShortName o -LongName non-unique -Description $msg.non_unique
    New-ParamCompleter -ShortName p -LongName password -Description $msg.password -Type Required -VariableName 'PASSWORD'
    New-ParamCompleter -ShortName r -LongName system -Description $msg.system
    New-ParamCompleter -ShortName R -LongName root -Description $msg.root -Type Directory -VariableName 'CHROOT_DIR'
    New-ParamCompleter -ShortName P -LongName prefix -Description $msg.prefix -Type Directory -VariableName 'PREFIX_DIR'
    New-ParamCompleter -ShortName U -LongName users -Description $msg.users -Type List -VariableName 'USER'
    New-ParamCompleter -LongName extrausers -Description $msg.extrausers
) -NoFileCompletions
