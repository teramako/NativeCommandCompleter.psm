<#
 # whoami completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    upn     = Displays the user name in user principal name (UPN) format.
    fqdn    = Displays the user name in fully qualified domain name (FQDN) format.
    logonid = Displays the logon ID of the current user.
    user    = Displays the current domain and user name and the security identifier (SID).
    groups  = Displays the user groups to which the current user belongs.
    claims  = Displays the claims for current user, such as claim name, flags, type and values.
    priv    = Displays the security privileges of the current user.user
    fo      = Specifies the output format.
    all     = Displays all information.
    nh      = Specifies that the column header shouldn't be displayed in the output.
    help    = Displays help at the command prompt.

    gnu_help    = Display this help and exit
    gnu_version = Output version information and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsWindows)
{
    Register-NativeCompleter -Name whoami -Style Windows -Description 'print effective user name' -Parameters @(
        New-ParamCompleter -LongName UPN -Description $msg.upn
        New-ParamCompleter -LongName FQDN -Description $msg.fqdn
        New-ParamCompleter -LongName USER -Description $msg.user
        New-ParamCompleter -LongName GROUPS -Description $msg.groups
        New-ParamCompleter -LongName CLAIMS -Description $msg.claims
        New-ParamCompleter -LongName PRIV -Description $msg.priv
        New-ParamCompleter -LongName LOGONID -Description $msg.logonid
        New-ParamCompleter -LongName ALL -Description $msg.all
        New-ParamCompleter -LongName FO -Description $msg.fo -Arguments "TABLE", "LIST", "CSV"
        New-ParamCompleter -LongName NH -Description $msg.nh
        New-ParamCompleter -LongName ? -Description $msg.help
    ) -NoFileCompletions
}
else
{
    Register-NativeCompleter -Name whoami -Description 'print effective user name' -Parameters @(
        New-ParamCompleter -LongName help -Description $msg.gnu_help
        New-ParamCompleter -LongName version -Description $msg.gnu_version
    ) -NoFileCompletions
}
