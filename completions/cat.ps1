<#
 # cat completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu.show-all               = Escape all unprintables
    gnu.number-nonblank        = Number non-blank lines
    gnu.show-except-tab        = Escape unprintables except '\t'
    gnu.show-ends              = Display '$' at line end
    gnu.number                 = Enumerate lines
    gnu.squeeze-blank          = Never >1 blank line
    gnu.show-except-nl         = Escape unprintables except '\n'
    gnu.show-tabs              = Escape tab
    gnu.show-except-nl-and-tab = Escape unprintables except '\n' and '\t'
    gnu.help                   = Display help and exit
    gnu.version                = Display version and exit
    macos.b                    = Specify # of non-blank lines
    macos.e                    = Show unprintables, end lines with $
    macos.n                    = Enumerate lines
    macos.s                    = Squeeze away >1 blank lines
    macos.t                    = Show unprintables; tab as ^I
    macos.u                    = Disable output buffering
    macos.v                    = Escape non-printing chars
    macos.l                    = Set/block on F_SETLKW stdout lock
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localeMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsLinux)
{
    Register-NativeCompleter -Name cat -Parameters @(
        New-ParamCompleter -ShortName A -LongName show-all -Description $msg."gnu.show-all"
        New-ParamCompleter -ShortName b -LongName number-nonblank -Description $msg."gnu.number-nonblank"
        New-ParamCompleter -ShortName e -Description $msg."gnu.show-except-tab"
        New-ParamCompleter -ShortName E -LongName show-ends -Description $msg."gnu.show-ends"
        New-ParamCompleter -ShortName n -LongName number -Description $msg."gnu.number"
        New-ParamCompleter -ShortName s -LongName squeeze-blank -Description $msg."gnu.squeeze-blank"
        New-ParamCompleter -ShortName t -Description $msg."gnu.show-except-nl"
        New-ParamCompleter -ShortName T -LongName show-tabs -Description $msg."gnu.show-tabs"
        New-ParamCompleter -ShortName v -Description $msg."gnu.show-except-nl-and-tab"
        New-ParamCompleter -LongName help -Description $msg."gnu.help"
        New-ParamCompleter -LongName version -Description $msg."gnu.version"
    )
}
elseif ($IsMacOS)
{
    Register-NativeCompleter -Name cat -Parameters @(
        New-ParamCompleter -ShortName b -Description $msg."macos.b"
        New-ParamCompleter -ShortName e -Description $msg."macos.e"
        New-ParamCompleter -ShortName n -Description $msg."macos.n"
        New-ParamCompleter -ShortName s -Description $msg."macos.s"
        New-ParamCompleter -ShortName t -Description $msg."macos.t"
        New-ParamCompleter -ShortName u -Description $msg."macos.u"
        New-ParamCompleter -ShortName v -Description $msg."macos.v"
        New-ParamCompleter -ShortName l -Description $msg."macos.l"
    )
}
