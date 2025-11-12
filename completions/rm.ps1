<#
 # rm completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    directory       = Unlink directories
    force           = Never prompt for removal
    interactive     = Prompt for removal
    prompt-if-many  = Prompt to remove >3 files
    recursive       = Recursively remove subdirs
    verbose         = Explain what is done
    help            = Display help
    version         = Display rm version
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localeMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name rm -Parameters @(
    New-ParamCompleter -ShortName d -LongName directory -Description $msg."directory"
    New-ParamCompleter -ShortName f -LongName force -Description $msg."force"
    New-ParamCompleter -ShortName i -LongName interactive -Description $msg."interactive"
    New-ParamCompleter -ShortName I -Description $msg."prompt-if-many"
    New-ParamCompleter -ShortName r,R -LongName recursive -Description $msg."recursive"
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg."verbose"
    New-ParamCompleter -ShortName h -LongName help -Description $msg."help"
    New-ParamCompleter -LongName version -Description $msg."version"
)
