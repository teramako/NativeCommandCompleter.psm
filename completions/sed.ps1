<#
 # sed completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    quiet     = Silent mode
    debug     = Annotate program execution
    expression = Evaluate expression
    file       = Evaluate file
    follow-symlinks = Follow symlinks when processing in place
    in-place        = Edit files in place
    line-length     = Specify line-length
    posix           = Disable all GNU extensions
    regexp-extended = Use extended regexp
    separate        = Consider files as separate
    sandbox         = Operate in sandbox mode (disable e/r/w commands).
    unbuffered      = Use minimal IO buffers
    null-data       = Separate lines by NUL characters
    help            = Display help and exit
    version         = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsLinux)
{
    Register-NativeCompleter -Name sed -Description 'stream editor' -Parameters @(
        New-ParamCompleter -ShortName n -LongName quiet, slient -Description $msg."quiet"
        New-ParamCompleter -LongName debug -Description $msg."debug"
        New-ParamCompleter -ShortName e -LongName expression -Type Required -Description $msg."expression" -VariableName script
        New-ParamCompleter -ShortName f -LongName file -Type File -Description $msg."file" -VariableName 'script-file'
        New-ParamCompleter -LongName follow-symlinks -Description $msg."follow-symlinks"
        New-ParamCompleter -ShortName i -LongName in-place -Type FlagOrValue -Description $msg."in-place" -VariableName 'SUFFIX'
        New-ParamCompleter -ShortName l -LongName line-length -Type Required -Description $msg."line-length" -VariableName 'N'
        New-ParamCompleter -LongName posix -Description $msg."posix"
        New-ParamCompleter -ShortName E,r -LongName regexp-extended -Description $msg."regexp-extended"
        New-ParamCompleter -ShortName s -LongName separate -Description $msg."separate"
        New-ParamCompleter -LongName sandbox -Description $msg."sandbox"
        New-ParamCompleter -ShortName u -LongName unbuffered -Description $msg."unbuffered"
        New-ParamCompleter -ShortName z -LongName null-data -Description $msg."null-data"
        New-ParamCompleter -LongName help -Description $msg."help"
        New-ParamCompleter -LongName version -Description $msg."version"
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
