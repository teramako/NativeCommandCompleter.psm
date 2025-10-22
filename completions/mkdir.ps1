<#
 # mkdir completion
 #>
Import-Module NativeCommandCompleter.psm

Register-NativeCompleter -Name mkdir -Parameters @(
    New-ParamCompleter -ShortName m -LongName mode -Description 'Set file mode (as in chmod)' -ArgumentCompleter {
        param([string] $paramName, [string] $paramValue, [int] $position)
        # TBD
    }
    New-ParamCompleter -ShortName p -LongName parents -Description 'Make parent directories as needed';
    New-ParamCompleter -ShortName v -LongName verbose -Description 'Print a message for each created directory';
    New-ParamCompleter -LongName version -Description 'Output version';
    New-ParamCompleter -LongName help -Description 'Display help'
)

