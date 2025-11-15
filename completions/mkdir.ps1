<#
 # mkdir completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    mode    = Set file mode (as in chmod)
    parents = Make parent directories as needed
    verbose = Print a message for each created directory
    version = Output version
    help    = Display help
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU mkdir
mkdir --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU mkdir
{
    Register-NativeCompleter -Name mkdir -Parameters @(
        New-ParamCompleter -ShortName m -LongName mode -Description $msg.mode -Type Required
        New-ParamCompleter -ShortName p -LongName parents -Description $msg.parents
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
        New-ParamCompleter -LongName version -Description $msg.version
        New-ParamCompleter -LongName help -Description $msg.help
    )
}
else
{
    Register-NativeCompleter -Name mkdir -Parameters @(
        New-ParamCompleter -ShortName m -Description $msg.mode -Type Required
        New-ParamCompleter -ShortName p -Description $msg.parents
        New-ParamCompleter -ShortName v -Description $msg.verbose
    )
}

