<#
 # tracert completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    tracert             = Trace route to destination
    max_hops            = Maximum number of hops to search for target
    no_resolve          = Do not resolve addresses to hostnames
    max_timeout         = Wait timeout milliseconds for each reply
    source_route        = Loose source route along host-list (IPv4-only)
    reverse_route       = Trace the reverse route (IPv6-only)
    source_route_ipv6   = Source address (IPv6-only)
    ipv4                = Force using IPv4
    ipv6                = Force using IPv6
    help                = Display help
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$style = New-ParamStyle -ValueStyle Separated

Register-NativeCompleter -Name tracert -Description $msg.tracert -CustomStyle $style -Parameters @(
    New-ParamCompleter -Name '-d','/d' -Description $msg.no_resolve
    New-ParamCompleter -Name '-h','/h' -Description $msg.max_hops -Type Required -VariableName 'maximum_hops'
    New-ParamCompleter -Name '-j','/j' -Description $msg.source_route -Type Required -VariableName 'host-list'
    New-ParamCompleter -Name '-w','/w' -Description $msg.max_timeout -Type Required -VariableName 'timeout'
    New-ParamCompleter -Name '-R','/R' -Description $msg.reverse_route
    New-ParamCompleter -Name '-S','/S' -Description $msg.source_route_ipv6 -Type Required -VariableName 'srcaddr'
    New-ParamCompleter -Name '-4','/4' -Description $msg.ipv4
    New-ParamCompleter -Name '-6','/6' -Description $msg.ipv6
    New-ParamCompleter -Name '-?','/?' -Description $msg.help
) -NoFileCompletions
