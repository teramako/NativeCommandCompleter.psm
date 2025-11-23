<#
 # rm completion
 #>
Import-Module NativeCommandCompleter.psm

Register-NativeCompleter -Name rm -Parameters @(
    New-ParamCompleter -ShortName d -LongName directory -Description 'Unlink directories'
    New-ParamCompleter -ShortName f -LongName force -Description 'Never prompt for removal'
    New-ParamCompleter -ShortName i -LongName interactive -Description 'Prompt for removal'
    New-ParamCompleter -ShortName I -Description 'Prompt to remove >3 files'
    New-ParamCompleter -ShortName r -LongName recursive -Description 'Recursively remove subdirs'
    New-ParamCompleter -ShortName R -Description 'Recursively remove subdirs'
    New-ParamCompleter -ShortName v -LongName verbose -Description 'Explain what is done'
    New-ParamCompleter -ShortName h -LongName help -Description 'Display help'
    New-ParamCompleter -LongName version -Description 'Display rm version';
)
