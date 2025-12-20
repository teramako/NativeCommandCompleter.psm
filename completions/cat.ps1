<#
 # cat completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu_showAll            = Escape all unprintables
    gnu_numberNonblank     = Number non-blank lines
    gnu_showExceptTab      = Escape unprintables except '\\t'
    gnu_showEnds           = Display '$' at line end
    gnu_number             = Enumerate lines
    gnu_squeezeBlank       = Never >1 blank line
    gnu_showExceptNl       = Escape unprintables except '\\n'
    gnu_showTabs           = Escape tab
    gnu_showExceptNlAndTab = Escape unprintables except '\\n' and '\\t'
    gnu_help               = Display help and exit
    gnu_version            = Display version and exit
    macos_b                = Specify # of non-blank lines
    macos_e                = Show unprintables, end lines with $
    macos_n                = Enumerate lines
    macos_s                = Squeeze away >1 blank lines
    macos_t                = Show unprintables; tab as ^I
    macos_u                = Disable output buffering
    macos_v                = Escape non-printing chars
    macos_l                = Set/block on F_SETLKW stdout lock
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsLinux)
{
    Register-NativeCompleter -Name cat -Parameters @(
        New-ParamCompleter -ShortName A -LongName show-all -Description $msg.gnu_showAll
        New-ParamCompleter -ShortName b -LongName number-nonblank -Description $msg.gnu_numberNonblank
        New-ParamCompleter -ShortName e -Description $msg.gnu_showExceptTab
        New-ParamCompleter -ShortName E -LongName show-ends -Description $msg.gnu_showEnds
        New-ParamCompleter -ShortName n -LongName number -Description $msg.gnu_number
        New-ParamCompleter -ShortName s -LongName squeeze-blank -Description $msg.gnu_squeezeBlank
        New-ParamCompleter -ShortName t -Description $msg.gnu_showExceptNl
        New-ParamCompleter -ShortName T -LongName show-tabs -Description $msg.gnu_showTabs
        New-ParamCompleter -ShortName v -Description $msg.gnu_showExceptNlAndTab
        New-ParamCompleter -LongName help -Description $msg.gnu_help
        New-ParamCompleter -LongName version -Description $msg.gnu_version
    )
}
elseif ($IsMacOS)
{
    Register-NativeCompleter -Name cat -Parameters @(
        New-ParamCompleter -ShortName b -Description $msg.macos_b
        New-ParamCompleter -ShortName e -Description $msg.macos_e
        New-ParamCompleter -ShortName n -Description $msg.macos_n
        New-ParamCompleter -ShortName s -Description $msg.macos_s
        New-ParamCompleter -ShortName t -Description $msg.macos_t
        New-ParamCompleter -ShortName u -Description $msg.macos_u
        New-ParamCompleter -ShortName v -Description $msg.macos_v
        New-ParamCompleter -ShortName l -Description $msg.macos_l
    )
}
