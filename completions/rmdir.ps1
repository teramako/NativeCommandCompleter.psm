<#
 # rmdir completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ignore-fail-on-non-empty = Ignore errors from non-empty directories
    parents                  = Remove each component of path
    verbose                  = Verbose mode
    help                     = Display help and exit
    version                  = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localeMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name rmdir -Parameters @(
    New-ParamCompleter -LongName ignore-fail-on-non-empty -Description $msg."ignore-fail-on-non-empty"
    New-ParamCompleter -ShortName p -LongName parents -Description $msg."parents"
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg."verbose"
    New-ParamCompleter -LongName help -Description $msg."help"
    New-ParamCompleter -LongName version -Description $msg."version"
)
