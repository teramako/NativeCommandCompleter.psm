<#
 # date completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu.date               = Display date described by string
    gnu.file               = Display date for each line in file
    gnu.iso-8601           = Use ISO 8601 output format
    gnu.resolution         = Output the available resolution of timestamps
    gnu.rfc-2822           = Output in RFC 2822 format
    gnu.rfc-3339           = Output in RFC 3339 format
    gnu.reference          = Display last modification time of file 
    gnu.set                = Set time
    gnu.utc                = Print/set UTC time
    gnu.help               = Display help and exit
    gnu.version            = Display version and exit
    bsd.utc                = Display or set UTC time
    bsd.dont-set           = Don't try to set the date
    bsd.mtime-or-timestamp = Format path mtime or UNIX timestamp
    bsd.adjust             = Adjust clock ± time specified
    bsd.rfc-2822           = Use RFC 2822 output format
    bsd.iso-8601           = Use ISO 8601 output format
    bsd.format             = Use format string to parse date
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localeMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU mkdir
date --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU mkdir
{
    Register-NativeCompleter -Name date -Description 'display or set date and time' -Parameters @(
        New-ParamCompleter -ShortName d -LongName date -Description $msg."gnu.date" -Type Required
        New-ParamCompleter -ShortName f -LongName file -Description $msg."gnu.file" -Type File
        New-ParamCompleter -ShortName I -LongName iso-8601 -Description $msg."gnu.iso-8601" -Type FlagOrValue -Arguments "date","hours","minutes","seconds","ns"
        New-ParamCompleter -LongName resolution -Description $msg."gnu.resolution"
        New-ParamCompleter -ShortName R -LongName rfc-2822 -Description $msg."gnu.rfc-2822"
        New-ParamCompleter -LongName rfc-3339 -Description $msg."gnu.rfc-3339" -Arguments "date","seconds","ns"
        New-ParamCompleter -ShortName r -LongName reference -Description $msg."gnu.reference" -Type File
        New-ParamCompleter -ShortName s -LongName set -Description $msg."gnu.set" -Type Required
        New-ParamCompleter -ShortName u -LongName utc,universal -Description $msg."gnu.utc"
        New-ParamCompleter -ShortName h -LongName help -Description $msg."gnu.help"
        New-ParamCompleter -ShortName v -LongName version -Description $msg."gnu.version"
    ) -ArgumentCompleter {
        $null
    }
}
else
{
    Register-NativeCompleter -Name date -Description 'display or set date and time' -Parameters @(
        New-ParamCompleter -ShortName u -Description $msg."bsd.utc"
        New-ParamCompleter -ShortName j -Description $msg."bsd.dont-set"
        New-ParamCompleter -ShortName r -Description $msg."bsd.mtime-or-timestamp" -Type Required
        New-ParamCompleter -ShortName v -Description $msg."bsd.adjust" -Type Required
        New-ParamCompleter -ShortName R -Description $msg."bsd.rfc-2822"
        New-ParamCompleter -ShortName I -Description $msg."bsd.iso-8601" -Arguments "date","hours","minutes","seconds"
        New-ParamCompleter -ShortName f -Description $msg."bsd.format" -Type Required
    ) -ArgumentCompleter {
        $null
    }
}
