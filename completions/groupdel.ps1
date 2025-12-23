<#
 # groupdel completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    groupdel            = delete a group
    help                = Display help message and exit
    root                = Apply changes in the CHROOT_DIR directory
    prefix              = Apply changes in the PREFIX_DIR directory
    extrausers          = Use the extra users database
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name groupdel -Description $msg.groupdel -Parameters @(
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName R -LongName root -Description $msg.root -Type Directory -VariableName 'CHROOT_DIR'
    New-ParamCompleter -ShortName P -LongName prefix -Description $msg.prefix -Type Directory -VariableName 'PREFIX_DIR'
    New-ParamCompleter -LongName extrausers -Description $msg.extrausers
) -ArgumentCompleter {
    if (Test-Path -LiteralPath '/etc/group') {
        Get-Content -LiteralPath '/etc/group' | ForEach-Object {
            if ($_ -match '^([^:]+):') {
                $group = $Matches[1]
                if ($group -like "$wordToComplete*") {
                    $group
                }
            }
        }
    }
}
