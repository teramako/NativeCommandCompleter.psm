<#
 # userdel completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    userdel  = delete a user account and related files
    force    = force the removal
    help     = display help message
    remove   = remove user's home and mail directories
    root     = apply changes in a chroot directory
    prefix   = apply changes in a prefix directory
    selinux  = remove SELinux user mappings
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name userdel -Description $msg.userdel -Parameters @(
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName r -LongName remove -Description $msg.remove
    New-ParamCompleter -ShortName R -LongName root -Description $msg.root -Type Directory -VariableName 'CHROOT_DIR'
    New-ParamCompleter -ShortName P -LongName prefix -Description $msg.prefix -Type Directory -VariableName 'PREFIX_DIR'
    New-ParamCompleter -ShortName Z -LongName selinux-user -Description $msg.selinux
) -NoFileCompletions -ArgumentCompleter {
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
