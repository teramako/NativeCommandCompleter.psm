<#
 # sed completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    sed            = stream editor
    quiet          = Silent mode
    debug          = Annotate program execution
    expression     = Evaluate expression
    file           = Evaluate file
    followSymlinks = Follow symlinks when processing in place
    inPlace        = Edit files in place
    lineLength     = Specify line-length
    posix          = Disable all GNU extensions
    regexpExtended = Use extended regexp
    separate       = Consider files as separate
    sandbox        = Operate in sandbox mode (disable e/r/w commands).
    unbuffered     = Use minimal IO buffers
    nullData       = Separate lines by NUL characters
    help           = Display help and exit
    version        = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsLinux)
{
    Register-NativeCompleter -Name sed -Description $msg.sed -Parameters @(
        New-ParamCompleter -ShortName n -LongName quiet, slient -Description $msg.quiet
        New-ParamCompleter -LongName debug -Description $msg.debug
        New-ParamCompleter -ShortName e -LongName expression -Type Required -Description $msg.expression -VariableName script
        New-ParamCompleter -ShortName f -LongName file -Type File -Description $msg.file -VariableName 'script-file'
        New-ParamCompleter -LongName follow-symlinks -Description $msg.followSymlinks
        New-ParamCompleter -ShortName i -LongName in-place -Type FlagOrValue -Description $msg."inPlace" -VariableName 'SUFFIX'
        New-ParamCompleter -ShortName l -LongName line-length -Type Required -Description $msg."lineLength" -VariableName 'N'
        New-ParamCompleter -LongName posix -Description $msg.posix
        New-ParamCompleter -ShortName E,r -LongName regexp-extended -Description $msg.regexpExtended
        New-ParamCompleter -ShortName s -LongName separate -Description $msg.separate
        New-ParamCompleter -LongName sandbox -Description $msg.sandbox
        New-ParamCompleter -ShortName u -LongName unbuffered -Description $msg.unbuffered
        New-ParamCompleter -ShortName z -LongName null-data -Description $msg.nullData
        New-ParamCompleter -LongName help -Description $msg.help
        New-ParamCompleter -LongName version -Description $msg.version
    ) -ArgumentCompleter {
        param([int] $position, [int] $argIndex)
        if ($argIndex -eq 0 -and -not $this.BoundParameters.ContainsKey("expression"))
        {
            if ([string]::IsNullOrEmpty($_))
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
