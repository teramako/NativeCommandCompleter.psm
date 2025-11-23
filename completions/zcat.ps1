<#
 # zcat completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    force      = Overwrite
    help       = Display help and exit
    license    = Print license
    version    = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name zcat -Parameters @(
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName L -LongName license -Description $msg.license
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
)
