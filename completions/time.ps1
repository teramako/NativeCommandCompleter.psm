<#
 # time completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    output      = Do not send the results to stderr, but overwrite the specified file
    append      = (Used together with -o) Do not overwrite but append
    format      = Specify output format
    portability = Use the portable output format
    help        = Display help and exit
    verbose     = Verbose mode
    quiet       = Do not report the status
    version     = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name time -DelegateArgumentIndex 0 -Parameters @(
    New-ParamCompleter -ShortName o -LongName output -Description $msg.output -Type File
    New-ParamCompleter -ShortName a -LongName append -Description $msg.append
    New-ParamCompleter -ShortName f -LongName format -Description $msg.format -Type Required
    New-ParamCompleter -ShortName p -LongName portability -Description $msg.portability
    New-ParamCompleter -LongName help -Description $msg.help
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -LongName quiet -Description $msg.quiet
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    if ($argIndex -eq 0)
    {
        # Complete commands in $env:PATH or the path to a command
        $results = [System.Management.Automation.CompletionCompleters]::CompleteCommand($_, $null, [System.Management.Automation.CommandTypes]::Application);
        if ($results.Count -gt 0)
        {
            $results;
        }
        else
        {
            [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
                $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or
                $_.UnixFileMode.HasFlag([System.IO.UnixFileMode]::UserExecute -bor [System.IO.UnixFileMode]::GroupExecute -bor [System.IO.UnixFileMode]::OtherExecute)
            });
        }
    }
}
