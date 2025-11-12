<#
 # chmod completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    changes          = Like -v but report only changes
    no-preserve-root = Don't treat / special (default)
    preserve-root    = Suppress most errors
    silent           = Print a message for each created directory
    verbose          = Prints each file processed
    reference        = Use RFILEs mode instead of MODE values
    recursive        = Operate recursively
    help             = Display help and exit
    version          = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localeMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name chmod -Parameters @(
    New-ParamCompleter -ShortName c -LongName changes -Description $msg."changes"
    New-ParamCompleter -LongName no-preserve-root -Description $msg."no-preserve-root"
    New-ParamCompleter -LongName preserve-root -Description $msg."preserve-root"
    New-ParamCompleter -ShortName f -LongName silent, quiet -Description $msg."slient"
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg."verbose"
    New-ParamCompleter -LongName reference -Type File -Description $msg."reference"
    New-ParamCompleter -ShortName R -LongName recursive -Description $msg."recursive"
    New-ParamCompleter -LongName help -Description $msg."help"
    New-ParamCompleter -LongName version -Description $msg."version"
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    if ($argIndex -eq 0 -and -not $this.BoundParameters.ContainsKey("reference"))
    {
        return $null
    }
}
