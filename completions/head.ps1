<#
 # head completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu_bytes   = Print the first N bytes; Leading '-', truncate the last N bytes
    gnu_lines   = Print the first N lines; Leading '-', truncate the last N lines
    gnu_quiet   = Never print file names
    gnu_verbose = Always print file names
    gnu_zero    = Line delimiter is NUL, not newline
    gnu_version = Display version
    gnu_help    = Display help
    macos_bytes = Print the first N bytes
    macos_lines = Print the first N lines
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU head
head --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU
{
    Register-NativeCompleter -Name head -Parameters @(
        New-ParamCompleter -ShortName c -LongName bytes -Description $msg.gnu_bytes -Type Required
        New-ParamCompleter -ShortName n -LongName lines -Description $msg.gnu_lines -Type Required
        New-ParamCompleter -ShortName q -LongName quiet, silent -Description $msg.gnu_quiet
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.gnu_verbose
        New-ParamCompleter -ShortName z -LongName zero-terminated -Description $msg.gnu_zero
        New-ParamCompleter -LongName version -Description $msg.gnu_verbose
        New-ParamCompleter -LongName help -Description $msg.gnu_help
    )
}
else
{
    Register-NativeCompleter -Name head -Parameters @(
        New-ParamCompleter -ShortName c -Description $msg.macos_bytes -Type Required
        New-ParamCompleter -ShortName n -Description $msg.macos_lines -Type Required
    )
}
