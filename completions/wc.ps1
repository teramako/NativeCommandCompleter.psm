<#
 # wc completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    wc                  = print newline, word, and byte counts for each file
    bytes               = Print the byte counts
    chars               = Print the character counts
    lines               = Print the newline counts
    files0_from         = Read input from the files specified by NUL-terminated names in file F
    max_line_length     = Print the maximum display width
    words               = Print the word counts
    total               = When to print a line with total counts
    help                = Display help and exit
    version             = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

wc --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0)
{
    Register-NativeCompleter -Name wc -Description $msg.wc -Parameters @(
        New-ParamCompleter -ShortName c -LongName bytes -Description $msg.bytes
        New-ParamCompleter -ShortName m -LongName chars -Description $msg.chars
        New-ParamCompleter -ShortName l -LongName lines -Description $msg.lines
        New-ParamCompleter -LongName files0-from -Description $msg.files0_from -Type File -VariableName 'F'
        New-ParamCompleter -ShortName L -LongName max-line-length -Description $msg.max_line_length
        New-ParamCompleter -ShortName w -LongName words -Description $msg.words
        New-ParamCompleter -LongName total -Description $msg.total -Type Required -VariableName 'WHEN' -Arguments "auto", "always", "only", "never"
        New-ParamCompleter -LongName help -Description $msg.help
        New-ParamCompleter -LongName version -Description $msg.version
    )
}
else
{
    Register-NativeCompleter -Name wc -Description $msg.wc -Parameters @(
        New-ParamCompleter -ShortName c -Description $msg.bytes
        New-ParamCompleter -ShortName m -Description $msg.chars
        New-ParamCompleter -ShortName l -Description $msg.lines
        New-ParamCompleter -ShortName w -Description $msg.words
    )
}
