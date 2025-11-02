<#
 # cat completion
 #>
Import-Module NativeCommandCompleter.psm

if ($IsLinux)
{
    Register-NativeCompleter -Name cat -Parameters @(
        New-ParamCompleter -ShortName A -LongName show-all -Description 'Escape all unprintables'
        New-ParamCompleter -ShortName b -LongName number-nonblank -Description 'Number non-blank lines'
        New-ParamCompleter -ShortName e -Description 'Escape unprintables except \t'
        New-ParamCompleter -ShortName E -LongName show-ends -Description 'Display $ at line end'
        New-ParamCompleter -ShortName n -LongName number -Description 'Enumerate lines'
        New-ParamCompleter -ShortName s -LongName squeeze-blank -Description 'Never >1 blank line'
        New-ParamCompleter -ShortName t -Description 'Escape unprintables except \n'
        New-ParamCompleter -ShortName T -LongName show-tabs -Description 'Escape tab'
        New-ParamCompleter -ShortName v -Description 'Escape unprintables except ''\n'' and \t'
        New-ParamCompleter -LongName help -Description 'Display help and exit'
        New-ParamCompleter -LongName version -Description 'Display version and exit'
    )
}
elseif ($IsMacOS)
{
    Register-NativeCompleter -Name cat -Parameters @(
        New-ParamCompleter -ShortName b -Description 'Specify # of non-blank lines'
        New-ParamCompleter -ShortName e -Description 'Show unprintables, end lines with $'
        New-ParamCompleter -ShortName n -Description 'Enumerate lines'
        New-ParamCompleter -ShortName s -Description 'Squeeze away >1 blank lines'
        New-ParamCompleter -ShortName t -Description 'Show unprintables; tab as ^I'
        New-ParamCompleter -ShortName u -Description 'Disable output buffering'
        New-ParamCompleter -ShortName v -Description 'Escape non-printing chars'
        New-ParamCompleter -ShortName l -Description 'Set/block on F_SETLKW stdout lock'
    )
}
