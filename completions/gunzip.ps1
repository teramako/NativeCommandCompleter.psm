<#
 # gunzip completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    stdout     = Compress to stdout
    force      = Overwrite
    help       = Display help and exit
    keep       = Keep input files
    list       = List compression information
    license    = Print license
    noName     = Do not save/restore filename
    name       = Save/restore filename
    quiet      = Suppress warnings
    recursive  = Recurse directories
    suffix     = Suffix
    test       = Check integrity
    verbose    = Display compression ratios
    version    = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name gunzip -Parameters @(
    New-ParamCompleter -ShortName c -LongName stdout -Description $msg.stdout
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName k -LongName keep -Description $msg.keep
    New-ParamCompleter -ShortName l -LongName list -Description $msg.list
    New-ParamCompleter -ShortName L -LongName license -Description $msg.license
    New-ParamCompleter -ShortName n -LongName no-name -Description $msg.noName
    New-ParamCompleter -ShortName N -LongName name -Description $msg.name
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -ShortName r -LongName recursive -Description $msg.recursive
    New-ParamCompleter -ShortName S -LongName suffix -Description $msg.suffix -Type Required
    New-ParamCompleter -ShortName t -LongName test -Description $msg.test
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
)
