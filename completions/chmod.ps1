<#
 # chmod completion
 #>
using namespace System.Management.Automation;

Import-Module NativeCommandCompleter.psm

Register-NativeCompleter -Name chmod -Parameters @(
    New-ParamCompleter -ShortName c -LongName changes -Description 'Like -v but report only changes'
    New-ParamCompleter -LongName no-preserve-root -Description "Don't treat / special (default)"
    New-ParamCompleter -LongName preserve-root -Description  'Suppress most errors'
    New-ParamCompleter -ShortName f -LongName slient, quiet -Description 'Print a message for each created directory';
    New-ParamCompleter -ShortName v -LongName verbose -Description 'Prints each file processed'
    New-ParamCompleter -LongName reference -Description 'Use RFILEs mode instead of MODE values' -ArgumentCompleter {
        param([string] $paramName, [string] $paramValue, [int] $position)
        [CompletionCompleters]::CompleteFilename($paramValue);
    }
    New-ParamCompleter -ShortName R -LongName recursive -Description 'Operate recursively';
    New-ParamCompleter -LongName help -Description 'Display help and exit'
    New-ParamCompleter -LongName version -Description 'Display version and exit';
)
