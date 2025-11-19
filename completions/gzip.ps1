<#
 # gzip completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    stdout     = Compress to stdout
    decompress = Decompress
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
    fast       = Use fast setting
    best       = Use high compression setting
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name gzip -Parameters @(
    New-ParamCompleter -ShortName c -LongName stdout -Description $msg.stdout
    New-ParamCompleter -ShortName d -LongName decompress -Description $msg.Decompress -Type File -ArgumentCompleter {
        [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
            $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Extension -match '\.\(?:gz|tgz)$'
        });
    }
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
    New-ParamCompleter -ShortName 1 -LongName fast -Description $msg.fast
    New-ParamCompleter -ShortName 9 -LongName best -Description $msg.best
)

