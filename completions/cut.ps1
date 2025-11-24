<#
 # cut completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    bytes                      = Select byte positions
    fields                     = Select fields
    bsd_dont_split_multibytes  = Don't split multi-byte characters
    only_delimited             = Suppress lines without delimiter
    gnu_characters             = Select characters
    gnu_delimiter              = Select field delimiter
    gnu_output_delimiter       = Select output delimiter
    gnu_zero_terminated        = line delimiter is NUL, not newline
    gnu_complement             = complement the set of selected bytes, characters or fields
    gnu_help                   = Display help and exit
    gnu_version                = Display version and exit
    bsd_characters             = Output character range
    bsd_delimiter              = Delimiter instead of \t to use
    bsd_whitespace_delimiter   = Use whitespace as delimiter
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU
cut --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU
{
    Register-NativeCompleter -Name cut -Parameters @(
        New-ParamCompleter -ShortName b -LongName bytes -Description $msg.bytes -Type Required -VariableName 'LIST'
        New-ParamCompleter -ShortName c -LongName characters -Description $msg.gnu_characters -Type Required -VariableName 'LIST'
        New-ParamCompleter -ShortName d -LongName delimiter -Description $msg.gnu_delimiter -Type Required -VariableName 'DELIM'
        New-ParamCompleter -ShortName f -LongName fields -Description $msg.fields -Type Required -VariableName 'LIST'
        New-ParamCompleter -LongName complement -Description $msg.gnu_complement
        New-ParamCompleter -ShortName s -LongName only-delimited -Description $msg.only_delimited
        New-ParamCompleter -LongName output-delimiter -Description $msg.gnu_output_delimiter -Type Required -VariableName 'STRING'
        New-ParamCompleter -ShortName z -LongName zero-terminated -Description $msg.gnu_zero_terminated
        New-ParamCompleter -LongName help -Description $msg.gnu_help
        New-ParamCompleter -LongName version -Description $msg.gnu_version
    )
}
else
{
    Register-NativeCompleter -Name cut -Parameters @(
        New-ParamCompleter -ShortName b -Description $msg.bytes -Type Required -VariableName 'LIST'
        New-ParamCompleter -ShortName c -Description $msg.bsd_characters -Type Required -VariableName 'LIST'
        New-ParamCompleter -ShortName d -Description $msg.bsd_delimiter -Type Required -VariableName 'DELIM'
        New-ParamCompleter -ShortName f -Description $msg.fields -Type Required -VariableName 'LIST'
        New-ParamCompleter -ShortName n -Description $msg.bsd_dont_split_multibytes
        New-ParamCompleter -ShortName s -Description $msg.only_delimited
        New-ParamCompleter -ShortName w -Description $msg.bsd_whitespace_delimiter
    )
}
