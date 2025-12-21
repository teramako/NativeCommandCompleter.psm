<#
 # usermod completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    usermod             = modify a user account
    append              = Append the user to the supplementary groups
    badname             = Allow names that do not conform to standards
    comment             = New value of the GECOS field
    home                = New home directory for the user account
    expiredate          = Set account expiration date
    inactive            = Set password inactive after expiration
    gid                 = Force use GROUP as new primary group
    groups              = New list of supplementary groups
    help                = Display help message and exit
    login               = New value of the login name
    lock                = Lock the user account
    move_home           = Move the content of the user's home directory
    non_unique          = Allow using duplicate (non-unique) UID
    password            = Encrypted password of the new account
    root                = Apply changes in the CHROOT_DIR directory
    prefix              = Prefix directory where /etc/* files are located
    shell               = New login shell for the user account
    uid                 = New numerical value of the user's ID
    unlock              = Unlock the user account
    add_subuids         = Add a range of subordinate uids
    del_subuids         = Remove a range of subordinate uids
    add_subgids         = Add a range of subordinate gids
    del_subgids         = Remove a range of subordinate gids
    selinux_user        = New SELinux user for the user's login
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$userCompleter = {
    if (Test-Path -LiteralPath '/etc/passwd') {
        Import-Csv -Delimiter : -Header Name,X,UID,GID,Comment,Home,Shell -Path /etc/passwd |
            Where-Object Name -Like "$wordToComplete*" |
            ForEach-Object {
                $comment = ($_.Comment -Split ',')[0]
                if ($comment) {
                    "{0}`t{1}" -f $_.Name, $comment
                } else {
                    $_.Name
                }
            }
    }
}

$groupCompleter = {
    if (Test-Path -LiteralPath '/etc/group') {
        Import-Csv -Delimiter : -Header Name,X,GID,Users -Path /etc/group |
            Where-Object Name -Like "$wordToComplete*" |
            ForEach-Object {
                if ($_.Users) {
                    "{0}`t{1}" -f $_.Name, $_.Users
                } else {
                    $_.Name
                }
            }
    }
}

Register-NativeCompleter -Name usermod -Description $msg.usermod -Parameters @(
    New-ParamCompleter -ShortName a -LongName append -Description $msg.append
    New-ParamCompleter -LongName badname -Description $msg.badname
    New-ParamCompleter -ShortName c -LongName comment -Description $msg.comment -Type Required -VariableName 'COMMENT'
    New-ParamCompleter -ShortName d -LongName home -Description $msg.home -Type Directory -VariableName 'HOME_DIR'
    New-ParamCompleter -ShortName e -LongName expiredate -Description $msg.expiredate -Type Required -VariableName 'EXPIRE_DATE'
    New-ParamCompleter -ShortName f -LongName inactive -Description $msg.inactive -Type Required -VariableName 'INACTIVE'
    New-ParamCompleter -ShortName g -LongName gid -Description $msg.gid -Type Required -VariableName 'GROUP' -ArgumentCompleter $groupCompleter
    New-ParamCompleter -ShortName G -LongName groups -Description $msg.groups -Type List -VariableName 'GROUPS' -ArgumentCompleter $groupCompleter
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName l -LongName login -Description $msg.login -Type Required -VariableName 'NEW_LOGIN'
    New-ParamCompleter -ShortName L -LongName lock -Description $msg.lock
    New-ParamCompleter -ShortName m -LongName move-home -Description $msg.move_home
    New-ParamCompleter -ShortName o -LongName non-unique -Description $msg.non_unique
    New-ParamCompleter -ShortName p -LongName password -Description $msg.password -Type Required -VariableName 'PASSWORD'
    New-ParamCompleter -ShortName R -LongName root -Description $msg.root -Type Directory -VariableName 'CHROOT_DIR'
    New-ParamCompleter -ShortName P -LongName prefix -Description $msg.prefix -Type Directory -VariableName 'PREFIX_DIR'
    New-ParamCompleter -ShortName s -LongName shell -Description $msg.shell -Type Required -VariableName 'SHELL'
    New-ParamCompleter -ShortName u -LongName uid -Description $msg.uid -Type Required -VariableName 'UID'
    New-ParamCompleter -ShortName U -LongName unlock -Description $msg.unlock
    New-ParamCompleter -ShortName v -LongName add-subuids -Description $msg.add_subuids -Type Required -VariableName 'FIRST-LAST'
    New-ParamCompleter -ShortName V -LongName del-subuids -Description $msg.del_subuids -Type Required -VariableName 'FIRST-LAST'
    New-ParamCompleter -ShortName w -LongName add-subgids -Description $msg.add_subgids -Type Required -VariableName 'FIRST-LAST'
    New-ParamCompleter -ShortName W -LongName del-subgids -Description $msg.del_subgids -Type Required -VariableName 'FIRST-LAST'
    New-ParamCompleter -ShortName Z -LongName selinux-user -Description $msg.selinux_user -Type Required -VariableName 'SEUSER'
) -ArgumentCompleter $userCompleter
