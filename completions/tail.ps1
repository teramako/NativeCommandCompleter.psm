<#
 # tail completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu_bytes               = output the last K bytes; with +K output bytes starting with the Kth
    gnu_follow              = output appended data as the file grows; default: 'descriptor'
    gnu_follow_descriptor   = same as --follow=descriptor
    gnu_follow_name         = same as --follow=name --retry
    gnu_lines               = output the last K lines; with +K output lines starting with the Kth
    gnu_max_unchanged_stats = with --follow=name, reopen a FILE which has not changed size after N iterations
    gnu_pid                 = with -f, terminate after process ID, PID dies
    gnu_quiet               = never output headers giving file names
    gnu_retry               = keep trying to open a file even when it is inaccessible; useful with --follow=name
    gnu_sleep_interval      = with -f, sleep for approximately N seconds (default 1.0) between iterations
    gnu_verbose             = always output headers giving file names
    gnu_zero                = Line delimiter is NUL, not newline
    gnu_help                = display this help and exit
    gnu_version             = output version information and exit
    macos_blocks            = output last K 512 byte blocks
    macos_bytes             = output the last K bytes or only K bytes with -r
    macos_follow_name       = output appended data as the file grows
    macos_follow_descriptor = Like -f, but also follow renamed or rotated files
    macos_lines             = output the last K lines, instead of the last 10 - or only K lines with -r
    macos_quiet             = never output headers giving file names
    macos_reverse           = Display input in reverse order
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU tail
tail --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU
{
    Register-NativeCompleter -Name tail -Parameters @(
        New-ParamCompleter -ShortName c -LongName bytes -Description $msg.gnu_bytes -Type Required
        New-ParamCompleter -LongName follow -Description $msg.gnu_follow -Type FlagOrValue -Arguments "name","descriptor"
        New-ParamCompleter -ShortName f -Description $msg.gnu_follow_descriptor
        New-ParamCompleter -ShortName F -Description $msg.gnu_follow_name
        New-ParamCompleter -ShortName n -LongName lines -Description $msg.gnu_lines -Type Required
        New-ParamCompleter -LongName max-unchanged-stats -Description $msg.gnu_max_unchanged_stats -Type Required
        New-ParamCompleter -LongName pid -Description $msg.gnu_pid -Type Required
        New-ParamCompleter -ShortName q -LongName quiet, silent -Description $msg.gnu_quiet
        New-ParamCompleter -LongName retry -Description $msg.gnu_retry
        New-ParamCompleter -ShortName s -LongName sleep-interval -Description $msg.gnu_sleep_interval -Type Required
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.gnu_verbose
        New-ParamCompleter -ShortName z -LongName zero-terminated -Description $msg.gnu_zero
        New-ParamCompleter -LongName help -Description $msg.gnu_help
        New-ParamCompleter -LongName version -Description $msg.gnu_version
    )
}
else
{
    Register-NativeCompleter -Name tail -Parameters @(
        New-ParamCompleter -ShortName b -Description $msg.macos_blocks
        New-ParamCompleter -ShortName c -Description $msg.macos_bytes
        New-ParamCompleter -ShortName f -Description $msg.macos_follow_name
        New-ParamCompleter -ShortName F -Description $msg.macos_follow_descriptor
        New-ParamCompleter -ShortName n -Description $msg.macos_lines
        New-ParamCompleter -ShortName q -Description $msg.macos_quiet
        New-ParamCompleter -ShortName r -Description $msg.macos_reverse
    )
}
