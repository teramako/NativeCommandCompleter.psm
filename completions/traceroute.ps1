<#
 # traceroute completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    traceroute              = print the route packets trace to network host
    first_ttl               = Start from the first_ttl hop
    gateway                 = Route packets through the specified gateway
    icmp                    = Use ICMP ECHO for tracerouting
    max_ttl                 = Set the max number of hops
    dontfragment            = Do not fragment packets
    port                    = Set the destination port to use
    nqueries                = Set the number of probes per each hop
    pause                   = Wait pause milliseconds between probes
    sendwait                = Wait time seconds for a response
    waittime                = Wait time seconds for a response (for compatibility)
    source                  = Use source src_addr for outgoing packets
    tos                     = Set the TOS (IPv4) or TC (IPv6) value
    module                  = Use specified module for traceroute operations
    mtu                     = Discover MTU along the path
    back                    = Print the number of backward hops
    numeric                 = Do not resolve IP addresses to their domain names
    extensions              = Show ICMP extensions (if present)
    as_lookups              = Perform AS path lookups
    version                 = Print version info and exit
    help                    = Read this help and exit
    
    max_hops                = Set max number of hops
    numeric_dns             = Do not resolve addresses to hostnames
    port_num                = Base UDP port number used in probes
    timeout                 = Wait timeout seconds for a response
    queries                 = Set number of probes per hop
    verbose                 = Verbose output
    version_bsd             = Print version and exit
    packet_len              = Set packet length
    dont_fragment           = Set Don't Fragment bit
    source_addr             = Source address
    type_of_service         = Type of Service
    gateway_bsd             = Loose source route gateway
    icmp_bsd                = Use ICMP ECHO instead of UDP datagrams
    max_ttl_bsd             = Maximum TTL value
    min_ttl                 = Minimum TTL value
    no_probe                = Do not send probe packets
    use_icmp_bsd            = Use ICMP ECHO for probes
    udp_port                = UDP port for probes
    wait_time_bsd           = Wait time for response
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU traceroute
traceroute --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU traceroute
{
    Register-NativeCompleter -Name traceroute -Description $msg.traceroute -Parameters @(
        New-ParamCompleter -ShortName f -LongName first -Description $msg.first_ttl -Type Required -VariableName 'first_ttl'
        New-ParamCompleter -ShortName g -LongName gateway -Description $msg.gateway -Type Required -VariableName 'gateway'
        New-ParamCompleter -ShortName I -LongName icmp -Description $msg.icmp
        New-ParamCompleter -ShortName m -LongName max-hops -Description $msg.max_ttl -Type Required -VariableName 'max_ttl'
        New-ParamCompleter -ShortName F -LongName dont-fragment -Description $msg.dontfragment
        New-ParamCompleter -ShortName p -LongName port -Description $msg.port -Type Required -VariableName 'port'
        New-ParamCompleter -ShortName q -LongName queries -Description $msg.nqueries -Type Required -VariableName 'nqueries'
        New-ParamCompleter -LongName sim-queries -Description $msg.nqueries -Type Required -VariableName 'nqueries'
        New-ParamCompleter -ShortName z -LongName sendwait -Description $msg.pause -Type Required -VariableName 'sendwait'
        New-ParamCompleter -ShortName w -LongName wait -Description $msg.sendwait -Type Required -VariableName 'time'
        New-ParamCompleter -LongName waittime -Description $msg.waittime -Type Required -VariableName 'time'
        New-ParamCompleter -ShortName s -LongName source -Description $msg.source -Type Required -VariableName 'src_addr'
        New-ParamCompleter -ShortName t -LongName tos -Description $msg.tos -Type Required -VariableName 'tos'
        New-ParamCompleter -ShortName M -LongName module -Description $msg.module -Type Required -VariableName 'name'
        New-ParamCompleter -LongName mtu -Description $msg.mtu
        New-ParamCompleter -LongName back -Description $msg.back
        New-ParamCompleter -ShortName n -Description $msg.numeric
        New-ParamCompleter -ShortName e -LongName extensions -Description $msg.extensions
        New-ParamCompleter -ShortName A -LongName as-path-lookups -Description $msg.as_lookups
        New-ParamCompleter -ShortName V -LongName version -Description $msg.version
        New-ParamCompleter -LongName help -Description $msg.help
    ) -NoFileCompletions
}
else # BSD traceroute
{
    Register-NativeCompleter -Name traceroute -Description $msg.traceroute -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.as_lookups
        New-ParamCompleter -ShortName A -Description $msg.as_lookups
        New-ParamCompleter -ShortName d -Description $msg.verbose
        New-ParamCompleter -ShortName D -Description $msg.dont_fragment
        New-ParamCompleter -ShortName e -Description $msg.extensions
        New-ParamCompleter -ShortName f -Description $msg.min_ttl -Type Required -VariableName 'first_ttl'
        New-ParamCompleter -ShortName F -Description $msg.dont_fragment
        New-ParamCompleter -ShortName g -Description $msg.gateway_bsd -Type Required -VariableName 'gateway'
        New-ParamCompleter -ShortName I -Description $msg.icmp_bsd
        New-ParamCompleter -ShortName i -Description $msg.source_addr -Type Required -VariableName 'iface'
        New-ParamCompleter -ShortName m -Description $msg.max_ttl_bsd -Type Required -VariableName 'max_ttl'
        New-ParamCompleter -ShortName M -Description $msg.min_ttl -Type Required -VariableName 'first_ttl'
        New-ParamCompleter -ShortName n -Description $msg.numeric_dns
        New-ParamCompleter -ShortName P -Description $msg.udp_port -Type Required -VariableName 'proto'
        New-ParamCompleter -ShortName p -Description $msg.port_num -Type Required -VariableName 'port'
        New-ParamCompleter -ShortName q -Description $msg.queries -Type Required -VariableName 'nqueries'
        New-ParamCompleter -ShortName S -Description $msg.source_addr -Type Required -VariableName 'src_addr'
        New-ParamCompleter -ShortName s -Description $msg.source_addr -Type Required -VariableName 'src_addr'
        New-ParamCompleter -ShortName t -Description $msg.type_of_service -Type Required -VariableName 'tos'
        New-ParamCompleter -ShortName v -Description $msg.verbose
        New-ParamCompleter -ShortName w -Description $msg.wait_time_bsd -Type Required -VariableName 'waittime'
        New-ParamCompleter -ShortName z -Description $msg.pause -Type Required -VariableName 'pausemsecs'
    ) -NoFileCompletions
}
