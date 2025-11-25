<#
 # touch completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    description = change file access and modification times
    atime       = change access time (atime)
    mtime       = change modification time (mtime)
    time        = use specified time [[CC]YY]MMDDhhmm[.SS]
    noCreate    = don't create file if it doesn't exist
    date        = set to specified YYYY-MM-DDThh:mm:SS[.frac][tz]
    reference   = use times from specified reference file
    help        = display this help and exit
    version     = output version information and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU touch
touch --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU touch
{
    Register-NativeCompleter -Name touch -Description $msg.description -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.atime
        New-ParamCompleter -ShortName m -Description $msg.mtime
        New-ParamCompleter -ShortName t -Description $msg.time -Type Required -VariableName 'STAMP'
        New-ParamCompleter -ShortName c -LongName no-create -Description $msg.noCreate
        New-ParamCompleter -ShortName d -LongName date -Description $msg.date -VariableName 'STRING'
        New-ParamCompleter -ShortName r -LongName reference -Description $msg.reference -Type File -VariableName 'FILE'
        New-ParamCompleter -LongName help -Description $msg.help
        New-ParamCompleter -LongName version -Description $msg.version
    )
}
else
{
    Register-NativeCompleter -Name touch -Description $msg.description -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.atime
        New-ParamCompleter -ShortName m -Description $msg.mtime
        New-ParamCompleter -ShortName t -Description $msg.time -Type Required -VariableName 'STAMP'
        New-ParamCompleter -ShortName c -Description $msg.noCreate
        New-ParamCompleter -ShortName d -Description $msg.date -VariableName 'STRING'
        New-ParamCompleter -ShortName r -Description $msg.reference -Type File -VariableName 'FILE'
    )
}
