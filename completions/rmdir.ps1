<#
 # rmdir completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ignoreFailOnNonEmpty     = Ignore errors from non-empty directories
    parents                  = Remove each component of path
    verbose                  = Verbose mode
    help                     = Display help and exit
    version                  = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name rmdir -Parameters @(
    New-ParamCompleter -LongName ignore-fail-on-non-empty -Description $msg.ignoreFailOnNonEmpty
    New-ParamCompleter -ShortName p -LongName parents -Description $msg.parents
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -LongName help -Description $msg.help
    New-ParamCompleter -LongName version -Description $msg.version
)
