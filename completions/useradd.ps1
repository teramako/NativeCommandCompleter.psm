<#
 # useradd completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    useradd                 = create a new user or update default new user information
    base_dir                = Base directory for the home directory
    comment                 = GECOS field of the new account
    home_dir                = Home directory of the new account
    defaults                = Print or change default useradd configuration
    expiredate              = Expiration date of the new account
    inactive                = Number of days after password expires until account is disabled
    gid                     = Name or ID of the primary group
    groups                  = List of supplementary groups
    skel                    = Skeleton directory
    key                     = Override /etc/login.defs defaults
    no_log_init             = Do not add the user to the lastlog and faillog databases
    create_home             = Create the user's home directory
    no_create_home          = Do not create the user's home directory
    no_user_group           = Do not create a group with the same name as the user
    non_unique              = Allow to create users with duplicate UID
    password                = Encrypted password of the new account
    system                  = Create a system account
    shell                   = Login shell of the new account
    uid                     = User ID of the new account
    user_group              = Create a group with the same name as the user
    selinux_user            = SELinux user for the user's login
    root_dir                = Directory to chroot into
    prefix                  = Prefix directory where are located the /etc/* files
    badname                 = Do not check for bad names
    add_subids_for_system   = Add subordinate IDs even for system users
    help                    = Display help message and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$groupCompleter = {
    if (Test-Path '/etc/group') {
        Get-Content '/etc/group' | ForEach-Object {
            if ($_ -match '^([^:]+):') {
                $group = $Matches[1]
                if ($group -like "$wordToComplete*") {
                    $group
                }
            }
        }
    }
}

$shellCompleter = {
    if (Test-Path '/etc/shells') {
        Get-Content '/etc/shells' | Where-Object { 
            -not [string]::IsNullOrWhiteSpace($_) -and -not $_.StartsWith('#') 
        } | ForEach-Object {
            if ($_ -like "$wordToComplete*") {
                $_
            }
        }
    }
}

Register-NativeCompleter -Name useradd -Description $msg.useradd -Parameters @(
    New-ParamCompleter -LongName badname -Description $msg.badname
    New-ParamCompleter -ShortName b -LongName base-dir -Description $msg.base_dir -Type Directory -VariableName 'BASE_DIR'
    New-ParamCompleter -ShortName c -LongName comment -Description $msg.comment -Type Required -VariableName 'COMMENT'
    New-ParamCompleter -ShortName d -LongName home-dir -Description $msg.home_dir -Type Directory -VariableName 'HOME_DIR'
    New-ParamCompleter -ShortName D -LongName defaults -Description $msg.defaults
    New-ParamCompleter -ShortName e -LongName expiredate -Description $msg.expiredate -Type Required -VariableName 'EXPIRE_DATE'
    New-ParamCompleter -ShortName f -LongName inactive -Description $msg.inactive -Type Required -VariableName 'INACTIVE'
    New-ParamCompleter -ShortName F -LongName add-subids-for-system -Description $msg.add_subids_for_system
    New-ParamCompleter -ShortName g -LongName gid -Description $msg.gid -Type Required -VariableName 'GROUP' -ArgumentCompleter $groupCompleter
    New-ParamCompleter -ShortName G -LongName groups -Description $msg.groups -Type Required,List -VariableName 'GROUPS' -ArgumentCompleter $groupCompleter
    New-ParamCompleter -ShortName k -LongName skel -Description $msg.skel -Type Directory -VariableName 'SKEL_DIR'
    New-ParamCompleter -ShortName K -LongName key -Description $msg.key -Type Required -VariableName 'KEY=VALUE'
    New-ParamCompleter -ShortName l -LongName no-log-init -Description $msg.no_log_init
    New-ParamCompleter -ShortName m -LongName create-home -Description $msg.create_home
    New-ParamCompleter -ShortName M -LongName no-create-home -Description $msg.no_create_home
    New-ParamCompleter -ShortName N -LongName no-user-group -Description $msg.no_user_group
    New-ParamCompleter -ShortName o -LongName non-unique -Description $msg.non_unique
    New-ParamCompleter -ShortName p -LongName password -Description $msg.password -Type Required -VariableName 'PASSWORD'
    New-ParamCompleter -ShortName r -LongName system -Description $msg.system
    New-ParamCompleter -ShortName R -LongName root -Description $msg.root_dir -Type Directory -VariableName 'CHROOT_DIR'
    New-ParamCompleter -ShortName P -LongName prefix -Description $msg.prefix -Type Directory -VariableName 'PREFIX_DIR'
    New-ParamCompleter -ShortName s -LongName shell -Description $msg.shell -Type Required -VariableName 'SHELL' -ArgumentCompleter $shellCompleter
    New-ParamCompleter -ShortName u -LongName uid -Description $msg.uid -Type Required -VariableName 'UID'
    New-ParamCompleter -ShortName U -LongName user-group -Description $msg.user_group
    New-ParamCompleter -ShortName Z -LongName selinux-user -Description $msg.selinux_user -Type Required -VariableName 'SEUSER'
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
) -NoFileCompletions
