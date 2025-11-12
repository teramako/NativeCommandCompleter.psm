<#
 # rmdir completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

Register-NativeCompleter -Name rmdir -Parameters @(
    New-ParamCompleter -LongName ignore-fail-on-non-empty -Description 'Ignore errors from non-empty directories'
    New-ParamCompleter -ShortName p -LongName parents -Description 'Remove each component of path'
    New-ParamCompleter -ShortName v -LongName verbose -Description 'Verbose mode'
    New-ParamCompleter -LongName help -Description 'Display help and exit'
    New-ParamCompleter -LongName version -Description 'Display version and exit';
)
