<#
 # netstat completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    netstat                 = Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships
    all                     = Show both listening and non-listening sockets
    listening               = Show only listening sockets
    numeric                 = Show numerical addresses instead of resolving names
    numeric_hosts           = Show numerical host addresses
    numeric_ports           = Show numerical port numbers
    numeric_users           = Show numerical user IDs
    program                 = Show the PID and name of the program to which each socket belongs
    timers                  = Include timing information
    extend                  = Display additional information
    extend_twice            = Display maximum detail
    verbose                 = Verbose output
    continuous              = Display statistics continuously
    wide                    = Do not truncate IP addresses
    route                   = Display the kernel routing table
    groups                  = Display multicast group membership information
    interfaces              = Display a table of all network interfaces
    statistics              = Display summary statistics for each protocol
    masquerade              = Display a list of masqueraded connections
    help                    = Display help
    version                 = Display version
    connection_tcp          = TCP connections
    connection_udp          = UDP connections
    connection_raw          = RAW connections
    protocol                = Show connections for the specified protocol
    protocol_ipv4           = IPv4 sockets
    protocol_ipv6           = IPv6 sockets
    protocol_unix           = Unix domain sockets
    protocol_ipx            = IPX sockets
    protocol_ax25           = AX.25 sockets
    protocol_netrom         = NET/ROM sockets
    protocol_dpp            = DPP sockets
    protocol_bluetooth      = Bluetooth sockets
    bsd_numeric_ports       = Show network addresses as numbers (normally netstat interprets addresses)
    bsd_all                 = Show the state of all sockets
    bsd_interface           = Show the state of interfaces
    bsd_interface_mtu       = Show the MTU for each interface
    bsd_routing_table       = Show the routing tables
    bsd_per_proto_stats     = Show statistics for protocol
    bsd_drop_root           = Drop root privileges
    bsd_memory              = Show network memory pool statistics
    bsd_multicast           = Show multicast routing information
    bsd_protocol            = Use alternate protocol file
    bsd_raw                 = Show raw network sockets
    bsd_statistics          = Show per-protocol statistics
    bsd_unix_domain         = Show Unix domain sockets
    bsd_wait                = Show network interface statistics at intervals of wait seconds
    win_all_connections     = Display all connections and listening ports
    win_ethernet_stats      = Display Ethernet statistics
    win_fully_qualified     = Display addresses in FQDN format
    win_numeric             = Display addresses and port numbers in numerical form
    win_owner_pid           = Display owning process ID associated with each connection
    win_protocol            = Show connections for the protocol specified
    win_route_table         = Display the routing table
    win_statistics          = Display per-protocol statistics
    win_offload_state       = Display the current offload state of the connection
    win_template            = Display the template for the connection
    win_interval            = Redisplay statistics, pausing interval seconds between each display
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsWindows)
{
    Register-NativeCompleter -Name netstat -Description $msg.netstat -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.win_all_connections
        New-ParamCompleter -ShortName e -Description $msg.win_ethernet_stats
        New-ParamCompleter -ShortName f -Description $msg.win_fully_qualified
        New-ParamCompleter -ShortName n -Description $msg.win_numeric
        New-ParamCompleter -ShortName o -Description $msg.win_owner_pid
        New-ParamCompleter -ShortName p -Description $msg.win_protocol -Type Required -Arguments "TCP","UDP","TCPv6","UDPv6","IP","IPv6","ICMP","ICMPv6" -VariableName 'protocol'
        New-ParamCompleter -ShortName r -Description $msg.win_route_table
        New-ParamCompleter -ShortName s -Description $msg.win_statistics
        New-ParamCompleter -ShortName t -Description $msg.win_offload_state
        New-ParamCompleter -ShortName x -Description $msg.win_template
        New-ParamCompleter -ShortName y -Description $msg.win_template
        New-ParamCompleter -ShortName '?' -Description $msg.help
    ) -NoFileCompletions -ArgumentCompleter {
        param([int] $position, [int] $argIndex)
        if ($argIndex -eq 0 -and [string]::IsNullOrEmpty($_))
        {
            "interval`tRedisplay statistics at specified intervals"
        }
    }
}
else
{
    # Check if GNU netstat (Linux) or BSD netstat (macOS/BSD)
    netstat --version 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) # GNU netstat
    {
        # GNU netstat (Linux)
        Register-NativeCompleter -Name netstat -Description $msg.netstat -Parameters @(
            New-ParamCompleter -ShortName r -LongName route -Description $msg.route
            New-ParamCompleter -ShortName g -LongName groups -Description $msg.groups
            New-ParamCompleter -ShortName i -LongName interfaces -Description $msg.interfaces
            New-ParamCompleter -ShortName M -LongName masquerade -Description $msg.masquerade
            New-ParamCompleter -ShortName s -LongName statistics -Description $msg.statistics

            New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
            New-ParamCompleter -ShortName W -LongName wide -Description $msg.wide
            New-ParamCompleter -ShortName n -LongName numeric -Description $msg.numeric
            New-ParamCompleter -LongName numeric-hosts -Description $msg.numeric_hosts
            New-ParamCompleter -LongName numeric-ports -Description $msg.numeric_ports
            New-ParamCompleter -LongName numeric-users -Description $msg.numeric_users
            New-ParamCompleter -ShortName A -LongName protocol -Description $msg.protocol -Type List -Arguments "inet","inet6","unix","ipx","ax25","netrom","ddp","bluetooth" -VariableName 'family'
            New-ParamCompleter -ShortName c -LongName continuous -Description $msg.continuous
            New-ParamCompleter -ShortName e -LongName extend -Description $msg.extend
            New-ParamCompleter -ShortName o -LongName timers -Description $msg.timers
            New-ParamCompleter -ShortName p -LongName program -Description $msg.program
            New-ParamCompleter -ShortName l -LongName listening -Description $msg.listening
            New-ParamCompleter -ShortName a -LongName all -Description $msg.all

            New-ParamCompleter -ShortName t -LongName tcp -Description $msg.connection_tcp
            New-ParamCompleter -ShortName u -LongName udp -Description $msg.connection_udp
            New-ParamCompleter -ShortName w -LongName raw -Description $msg.connection_raw
            New-ParamCompleter -ShortName '4' -LongName inet -Description $msg.protocol_ipv4
            New-ParamCompleter -ShortName '6' -LongName inet6 -Description $msg.protocol_ipv6
            New-ParamCompleter -ShortName x -LongName unix -Description $msg.protocol_unix
            New-ParamCompleter -LongName ipx -Description $msg.protocol_ipx
            New-ParamCompleter -LongName ax25 -Description $msg.protocol_ax25
            New-ParamCompleter -LongName netrom -Description $msg.protocol_netrom
            New-ParamCompleter -LongName dpp -Description $msg.protocol_dpp
            New-ParamCompleter -LongName bluetooth -Description $msg.protocol_bluetooth
            New-ParamCompleter -ShortName h -LongName help -Description $msg.help
            New-ParamCompleter -ShortName V -LongName version -Description $msg.version
        ) -NoFileCompletions
    }
    else
    {
        # BSD netstat (macOS/BSD)
        Register-NativeCompleter -Name netstat -Description $msg.netstat -Parameters @(
            New-ParamCompleter -ShortName a -Description $msg.bsd_all
            New-ParamCompleter -ShortName i -Description $msg.bsd_interface
            New-ParamCompleter -ShortName m -Description $msg.bsd_interface_mtu
            New-ParamCompleter -ShortName r -Description $msg.bsd_routing_table
            New-ParamCompleter -ShortName s -Description $msg.bsd_per_proto_stats
            New-ParamCompleter -ShortName d -Description $msg.bsd_drop_root
            New-ParamCompleter -ShortName g -Description $msg.bsd_multicast
            New-ParamCompleter -ShortName l -Description $msg.listening
            New-ParamCompleter -ShortName n -Description $msg.bsd_numeric_ports
            New-ParamCompleter -ShortName p -Description $msg.bsd_protocol -Type Required -VariableName 'protocol'
            New-ParamCompleter -ShortName v -Description $msg.verbose
            New-ParamCompleter -ShortName w -Description $msg.bsd_wait -Type Required -VariableName 'wait'
            New-ParamCompleter -ShortName f -Description $msg.protocol -Type Required -Arguments "inet","inet6","unix","link" -VariableName 'address_family'
        ) -NoFileCompletions
    }
}
