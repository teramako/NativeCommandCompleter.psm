<#
 # sed completion
 #>
Import-Module NativeCommandCompleter.psm

if ($IsLinux)
{
    Register-NativeCompleter -Name sed -Description 'stream editor' -Parameters @(
        New-ParamCompleter -ShortName n -LongName quiet, slient -Description 'Silent mode'
        New-ParamCompleter -LongName debug -Description 'Annotate program execution'
        New-ParamCompleter -ShortName e -LongName expression -Description 'Evaluate expression' -Type Required
        New-ParamCompleter -ShortName f -LongName file -Description 'Evaluate file' -Type File
        New-ParamCompleter -LongName follow-symlinks -Description 'Follow symlinks when processing in place'
        New-ParamCompleter -ShortName i -LongName in-place -Description 'Edit files in place' -Type FlagOrValue
        New-ParamCompleter -ShortName l -LongName line-length -Description "Specify line-length" -Type Required
        New-ParamCompleter -LongName posix -Description 'Disable all GNU extensions'
        New-ParamCompleter -ShortName E,r -LongName regexp-extended -Description 'Use extended regexp'
        New-ParamCompleter -ShortName s -LongName separate -Description 'Consider files as separate'
        New-ParamCompleter -LongName sandbox -Description 'Operate in sandbox mode (disable e/r/w commands).'
        New-ParamCompleter -ShortName u -LongName unbuffered -Description 'Use minimal IO buffers'
        New-ParamCompleter -ShortName z -LongName null-data -Description 'Separate lines by NUL characters'
        New-ParamCompleter -LongName help -Description 'Display help and exit'
        New-ParamCompleter -LongName version -Description 'Display version and exit'
    ) -ArgumentCompleter {
        param([string] $wordToComplete, [int] $position, [int] $argIndex, [MT.Comp.CompletionContext] $context)
        if ($argIndex -eq 0 -and -not $context.BoundParameters.ContainsKey("expression"))
        {
            if ([string]::IsNullOrEmpty($wordToComplete))
            {
                "pattern`tSpecify a pattern"
            }
            else
            {
                $null
            }
        }
    }
}
