<#
 # ping completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ping                = Send ICMP ECHO_REQUEST packets to network hosts

    win_continuous      = Continue sending echo Request messages
    win_resolve         = Resolve addresses to hostnames
    win_count           = Number of echo requests to send
    win_size            = Send buffer size
    win_fragment        = Don't fragment flag in packet (IPv4-only)
    win_ttl             = Set Time To Live
    win_sourceAddr      = Specifies the source address to use (available on IPv6 only).
    win_recordRoute     = Record route for count hops (IPv4-only)
    win_timestamp       = Timestamp for count hops (IPv4-only)
    win_timeout         = Timeout in milliseconds to wait for each reply
    win_looseHostList   = Loose source route along host-list (IPv4-only)
    win_strictHostList  = Strict source route along host-list (IPv4-only)
    win_typeOfService   = Type Of Service (IPv4-only)
    win_roundTrip       = Specifies the round-trip path is traced (available on IPv6 only).
    win_compartment     = Routing compartment identifier

    audible             = Audible ping
    adaptive            = Adaptive ping
    broadcast           = Allow pinging a broadcast address (IPv4 only)
    stickySrcAddr       = Sticky source address
    count               = Stop after sending count ECHO_REQUEST packets
    printTimestamp      = Print timestamps
    soDebug             = Set SO_DEBUG socket option
    flood               = Flood ping
    interface           = Set source address to specified interface address
    interval            = Wait interval seconds between sending each packet
    preload             = Send preload number of packets as fast as possible
    numeric             = Numeric output only
    pattern             = Specify up to 16 padding bytes to fill out the packet
    quiet               = Quiet output
    bypassRouting       = Bypass the normal routing tables
    recordRoute         = Record route
    size                = Specifies the number of data bytes to be sent
    timestamp           = Set IP timestamp options (IPv4 only)
    ttl                 = Set the IP Time to Live
    u2uLatency          = Print full user-to-user latency
    verbose             = Verbose output
    timeout             = Time to wait for a response, in seconds
    deadline            = Specify a timeout, in seconds, before ping exits
    version             = Show version and exit
    help                = Display help and exit
    ipv4                = Use IPv4 only
    ipv6                = Use IPv6 only
    mark                = Tag the packets going out
    socketBufSz         = Set socket buffer size
    mtu_discovery       = Set Path MTU Discovery strategy
    pmtudisc_do         = Prohibit fragmentation
    pmtudisc_dont       = Do not set DF flag
    pmtudisc_want       = Do PMTU discovery, fragment locally when needed
    pmtudisc_probe      = Do PMTU discovery, do not fragment
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsWindows)
{
    $style = New-ParamStyle -ValueStyle Separated

    Register-NativeCompleter -Name ping -Description $msg.ping -Parameters @(
        New-ParamCompleter -OldStyleName '-t','/t' -Style $style -Description $msg.win_continuous
        New-ParamCompleter -OldStyleName '-a','/a' -Style $style -Description $msg.win_resolve
        New-ParamCompleter -OldStyleName '-n','/n' -Style $style -Description $msg.win_count -Type Required -VariableName 'count'
        New-ParamCompleter -OldStyleName '-l','/l' -Style $style -Description $msg.win_size -Type Required -VariableName 'size'
        New-ParamCompleter -OldStyleName '-f','/f' -Style $style -Description $msg.win_fragment
        New-ParamCompleter -OldStyleName '-i','/i' -Style $style -Description $msg.win_ttl -Type Required -VariableName 'TTL'
        New-ParamCompleter -OldStyleName '-v','/v' -Style $style -Description $msg.win_typeOfService -Type Required -VariableName 'TOS'
        New-ParamCompleter -OldStyleName '-r','/r' -Style $style -Description $msg.win_recordRoute -Type Required -VariableName 'count'
        New-ParamCompleter -OldStyleName '-s','/s' -Style $style -Description $msg.win_timestamp -Type Required -VariableName 'count'
        New-ParamCompleter -OldStyleName '-j','/j' -Style $style -Description $msg.win_looseHostList -Type Required -VariableName 'host-list'
        New-ParamCompleter -OldStyleName '-k','/k' -Style $style -Description $msg.win_strictHostList -Type Required -VariableName 'host-list'
        New-ParamCompleter -OldStyleName '-w','/w' -Style $style -Description $msg.win_timeout -Type Required -VariableName 'timeout'
        New-ParamCompleter -OldStyleName '-R','/R' -Style $style -Description $msg.win_roundTrip
        New-ParamCompleter -OldStyleName '-S','/S' -Style $style -Description $msg.win_sourceAddr -Type Required -VariableName 'src-addr'
        New-ParamCompleter -OldStyleName '-c','/c' -Style $style -Description $msg.win_compartment -Type Required -VariableName 'compartment'
        New-ParamCompleter -OldStyleName '-4','/4' -Style $style -Description $msg.ipv4
        New-ParamCompleter -OldStyleName '-6','/6' -Style $style -Description $msg.ipv6
        New-ParamCompleter -OldStyleName '-?','/?' -Style $style -Description $msg.help
    ) -NoFileCompletions
    return
}
else
{
    Register-NativeCompleter -Name ping -Style Unix -Description $msg.ping -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.audible
        New-ParamCompleter -ShortName A -Description $msg.adaptive
        New-ParamCompleter -ShortName b -Description $msg.broadcast
        New-ParamCompleter -ShortName B -Description $msg.stickySrcAddr
        New-ParamCompleter -ShortName c -Description $msg.count -Type Required -VariableName 'count'
        New-ParamCompleter -ShortName D -Description $msg.printTimestamp
        New-ParamCompleter -ShortName d -Description $msg.soDebug
        New-ParamCompleter -ShortName f -Description $msg.flood
        New-ParamCompleter -ShortName i -Description $msg.interval -Type Required -VariableName 'interval'
        New-ParamCompleter -ShortName I -Description $msg.interface -Type Required -VariableName 'interface'
        New-ParamCompleter -ShortName l -Description $msg.preload -Type Required -VariableName 'preload'
        New-ParamCompleter -ShortName m -Description $msg.mark -Type Required -VariableName 'mark'
        New-ParamCompleter -ShortName M -Description $msg.mtu_discovery -Arguments @(
            "do`t{0}" -f $msg.pmtudisc_do
            "dont`t{0}" -f $msg.pmtudisc_dont
            "want`t{0}" -f $msg.pmtudisc_want
            "probe`t{0}" -f $msg.pmtudisc_probe
        ) -VariableName 'pmtudisc_opt'
        New-ParamCompleter -ShortName n -Description $msg.numeric
        New-ParamCompleter -ShortName p -Description $msg.pattern -Type Required -VariableName 'pattern'
        New-ParamCompleter -ShortName q -Description $msg.quiet
        New-ParamCompleter -ShortName r -Description $msg.bypassRouting
        New-ParamCompleter -ShortName R -Description $msg.recordRoute
        New-ParamCompleter -ShortName s -Description $msg.size -Type Required -VariableName 'packetsize'
        New-ParamCompleter -ShortName S -Description $msg.socketBufSz -Type Required -VariableName 'sndbuf'
        New-ParamCompleter -ShortName t -Description $msg.ttl -Type Required -VariableName 'ttl'
        New-ParamCompleter -ShortName T -Description $msg.timestamp -Arguments "tsonly","tsandaddr","tsprespec" -VariableName 'timestamp_opt'
        New-ParamCompleter -ShortName U -Description $msg.u2uLatency
        New-ParamCompleter -ShortName v -Description $msg.verbose
        New-ParamCompleter -ShortName V -Description $msg.version
        New-ParamCompleter -ShortName w -Description $msg.deadline -Type Required -VariableName 'deadline'
        New-ParamCompleter -ShortName W -Description $msg.timeout -Type Required -VariableName 'timeout'
        New-ParamCompleter -ShortName '4' -Description $msg.ipv4
        New-ParamCompleter -ShortName '6' -Description $msg.ipv6
        New-ParamCompleter -ShortName h -Description $msg.help
    ) -NoFileCompletions
}
