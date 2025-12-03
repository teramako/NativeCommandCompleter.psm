<#
 # ip completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ip                      = show / manipulate routing, network devices, interfaces and tunnels
    _humanReadable          = output statistics with human readable values
    _batch                  = Read commands from file or stdin
    _force                  = Don't terminate ip on errors
    _rcvbuf                 = Set the netlink socket receive buffer size
    _all                    = Execute command for all objects
    _color                  = Use color output
    _brief                  = Output only basic information
    _json                   = Output results in JSON format
    _pretty                 = Output results in pretty JSON format
    _family                 = Specify protocol family
    _family_inet            = IPv4
    _family_inet6           = IPv6
    _family_link            = No network protocol
    _family_mpls            = MPLS
    _family_bridge          = Ethernet bridge
    _oneline                = Output each record on a single line
    _resolve                = print DNS names
    _timestamp              = Display current time when using monitor
    _timestampShort         = Display time in short format
    _iecUnits               = print human readable rates in IEC units
    _terse                  = Terse output
    _details                = Detailed information
    _numeric                = Print the number
    _stats                  = Output more statistics
    _loops                  = Specify maximum number of loops
    _netns                  = Switch to specified network namespace
    _help                   = Display help and exit
    _version                = Display version and exit

    address                 = Protocol (IPv4 or IPv6) address on a device
    addrlabel               = Label configuration for protocol address selection
    fou                     = Foo-over-UDP receive port configuration
    ila                     = Manage identifier locator addressing for IPv6
    ioam                    = Manage IOAM namespaces and schemas
    l2tp                    = Tunnel Ethernet over IP (L2TPv3)
    link                    = Network device
    macsec                  = MACsec device configuration
    maddress                = Multicast address
    monitor                 = Watch for netlink messages
    mptcp                   = Manage MPTCP path manager
    mroute                  = Multicast routing cache entry
    mrule                   = Rule in multicast routing policy database
    neighbor                = Manage ARP or NDISC cache entries
    neighbour               = Manage ARP or NDISC cache entries (alias)
    netconf                 = Network configuration monitoring
    netns                   = Manage network namespaces
    nexthop                 = Manage nexthop objects
    ntable                  = Manage neighbor cache operation
    route                   = Routing table entry
    rule                    = Rule in routing policy database
    sr                      = Manage IPv6 SR objects
    stats                   = Manage and show interface statistics
    tap                     = Manage TUN/TAP devices
    tcpmetrics              = Manage TCP metrics
    token                   = Manage tokenized interface identifiers
    tunnel                  = Tunnel over IP
    tuntap                  = Manage TUN/TAP devices
    vrf                     = Manage virtual routing and forwarding devices
    xfrm                    = Manage IPsec policies

    addr_add                = Add new protocol address
    addr_change             = Change existing address
    addr_replace            = Add or update address
    addr_delete             = Delete address
    addr_show               = List addresses
    addr_save               = Save addresses to stdout
    addr_flush              = Flush protocol addresses
    addr_restore            = Restore addresses from stdin

    link_add                = Add virtual link
    link_delete             = Delete virtual or physical link
    link_set                = Change link attributes
    link_show               = Display link attributes
    link_xstats             = Display extended statistics
    link_afstats            = Display address-family specific statistics
    link_property           = Manage link properties

    route_add               = Add new route
    route_change            = Change existing route
    route_replace           = Add or update route
    route_delete            = Delete route
    route_show              = List routes
    route_flush             = Flush routing tables
    route_save              = Save routes to stdout
    route_restore           = Restore routes from stdin
    route_get               = Get a single route
    route_list              = List routes (alias for show)
    route_lst               = List routes (alias for show)

    neigh_add               = Add new neighbor entry
    neigh_change            = Change existing entry
    neigh_replace           = Add or update entry
    neigh_delete            = Delete entry
    neigh_show              = List entries
    neigh_flush             = Flush neighbor entries
    neigh_get               = Lookup neighbor entry

    rule_add                = Add new rule
    rule_delete             = Delete rule
    rule_show               = List rules
    rule_flush              = Flush rules
    rule_save               = Save rules to stdout
    rule_restore            = Restore rules from stdin

    netns_list              = List network namespaces
    netns_add               = Create new network namespace
    netns_attach            = Attach network namespace to process
    netns_set               = Set network namespace properties
    netns_delete            = Delete network namespace
    netns_identify          = Identify network namespace
    netns_pids              = List processes in namespace
    netns_exec              = Execute command in namespace
    netns_monitor           = Monitor netns creation and deletion

    tunnel_add              = Add new tunnel
    tunnel_change           = Change existing tunnel
    tunnel_delete           = Delete tunnel
    tunnel_show             = List tunnels
    tunnel_prl              = Manage PRL
    tunnel_6rd              = Manage 6RD

    monitor_all             = Monitor all
    monitor_file            = Save monitoring data to file
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$familyArguments = @(
    "inet`t{0}" -f $msg._family_inet
    "inet6`t{0}" -f $msg._family_inet6
    "link`t{0}" -f $msg._family_link
    "mpls`t{0}" -f $msg._family_mpls
    "bridge`t{0}" -f $msg._family_bridge
)

Register-NativeCompleter -Name ip -Description $msg.ip -Parameters @(
    New-ParamCompleter -OldStyleName Version, V -Description $msg._version
    New-ParamCompleter -OldStyleName human-readable, human, h -Description $msg._humanReadable
    New-ParamCompleter -OldStyleName batch, b -Description $msg._batch -Type File -VariableName 'FILE'
    New-ParamCompleter -OldStyleName force -Description $msg._force
    New-ParamCompleter -OldStyleName statistics, stats, s -Description $msg._stats
    New-ParamCompleter -OldStyleName details, d -Description $msg._details
    New-ParamCompleter -OldStyleName loops -Description $msg._loops -Type Required -VariableName 'COUNT'
    New-ParamCompleter -ShortName f -LongName family -Description $msg._family -Arguments $familyArguments -VariableName 'FAMILY'
    New-ParamCompleter -OldStyleName '4' -Description $msg._family_inet
    New-ParamCompleter -OldStyleName '6' -Description $msg._family_inet6
    New-ParamCompleter -OldStyleName B -Description $msg._family_bridge
    New-ParamCompleter -OldStyleName M -Description $msg._family_mpls
    New-ParamCompleter -OldStyleName '0' -Description $msg._family_link
    New-ParamCompleter -OldStyleName oneline, o -Description $msg._oneline
    New-ParamCompleter -OldStyleName resolve, r -Description $msg._resolve
    New-ParamCompleter -OldStyleName netns, n -Description $msg._netns -Type Required -VariableName 'NAME'
    New-ParamCompleter -OldStyleName Numeric, N -Description $msg._numeric
    New-ParamCompleter -OldStyleName all, a -Description $msg._all
    # FIXME: not supported `-c[color][={always|auto|never}`
    # New-ParamCompleter -OldStyleName color, c -Description $msg.color
    New-ParamCompleter -OldStyleName timestamp, t -Description $msg._timestamp
    New-ParamCompleter -OldStyleName tshort, ts -Description $msg._timestampShort
    New-ParamCompleter -OldStyleName rcvbuf, rc -Description $msg._rcvbuf -Type Required -VariableName 'SIZE'
    New-ParamCompleter -OldStyleName iec -Description $msg._iecUnits
    New-ParamCompleter -OldStyleName brief, br -Description $msg._brief
    New-ParamCompleter -OldStyleName json, j -Description $msg._json
    New-ParamCompleter -OldStyleName pretty, p -Description $msg._pretty
    New-ParamCompleter -OldStyleName help -Description $msg._help
) -SubCommands @(
    # address
    New-CommandCompleter -Name address -Aliases addr, a -Description $msg.address -SubCommands @(
        New-CommandCompleter -Name add -Description $msg.addr_add -NoFileCompletions 
        New-CommandCompleter -Name change -Description $msg.addr_change -NoFileCompletions
        New-CommandCompleter -Name replace -Description $msg.addr_replace -NoFileCompletions
        New-CommandCompleter -Name delete -Aliases del -Description $msg.addr_delete -NoFileCompletions
        New-CommandCompleter -Name show -Aliases list, lst -Description $msg.addr_show -NoFileCompletions
        New-CommandCompleter -Name save -Description $msg.addr_save -NoFileCompletions
        New-CommandCompleter -Name flush -Description $msg.addr_flush -NoFileCompletions
        New-CommandCompleter -Name restore -Description $msg.addr_restore -NoFileCompletions
    ) -NoFileCompletions

    # addrlabel
    New-CommandCompleter -Name addrlabel -Description $msg.addrlabel -NoFileCompletions

    # link
    New-CommandCompleter -Name link -Aliases l -Description $msg.link -SubCommands @(
        New-CommandCompleter -Name add -Description $msg.link_add -NoFileCompletions
        New-CommandCompleter -Name delete -Aliases del -Description $msg.link_delete -NoFileCompletions
        New-CommandCompleter -Name set -Description $msg.link_set -NoFileCompletions
        New-CommandCompleter -Name show -Aliases list, lst -Description $msg.link_show -NoFileCompletions
        New-CommandCompleter -Name xstats -Description $msg.link_xstats -NoFileCompletions
        New-CommandCompleter -Name afstats -Description $msg.link_afstats -NoFileCompletions
        New-CommandCompleter -Name property -Description $msg.link_property -NoFileCompletions
    ) -NoFileCompletions

    # route
    New-CommandCompleter -Name route -Aliases r, ro -Description $msg.route -SubCommands @(
        New-CommandCompleter -Name show -Aliases list, lst -Description $msg.route_show -NoFileCompletions
        New-CommandCompleter -Name flush -Description $msg.route_flush -NoFileCompletions
        New-CommandCompleter -Name save -Description $msg.route_save -NoFileCompletions
        New-CommandCompleter -Name restore -Description $msg.route_restore -NoFileCompletions
        New-CommandCompleter -Name add -Description $msg.route_add -NoFileCompletions
        New-CommandCompleter -Name change -Description $msg.route_change -NoFileCompletions
        New-CommandCompleter -Name replace -Description $msg.route_replace -NoFileCompletions
        New-CommandCompleter -Name delete -Aliases del -Description $msg.route_delete -NoFileCompletions
        New-CommandCompleter -Name get -Description $msg.route_get -NoFileCompletions
    ) -NoFileCompletions

    # neighbor/neighbour
    New-CommandCompleter -Name neighbor -Aliases neighbour, neigh, n -Description $msg.neighbor -SubCommands @(
        New-CommandCompleter -Name add -Description $msg.neigh_add -NoFileCompletions
        New-CommandCompleter -Name change -Description $msg.neigh_change -NoFileCompletions
        New-CommandCompleter -Name replace -Description $msg.neigh_replace -NoFileCompletions
        New-CommandCompleter -Name delete -Aliases del -Description $msg.neigh_delete -NoFileCompletions
        New-CommandCompleter -Name show -Aliases list, lst -Description $msg.neigh_show -NoFileCompletions
        New-CommandCompleter -Name flush -Description $msg.neigh_flush -NoFileCompletions
        New-CommandCompleter -Name get -Description $msg.neigh_get -NoFileCompletions
    ) -NoFileCompletions

    # rule
    New-CommandCompleter -Name rule -Description $msg.rule -SubCommands @(
        New-CommandCompleter -Name add -Description $msg.rule_add -NoFileCompletions
        New-CommandCompleter -Name delete -Aliases del -Description $msg.rule_delete -NoFileCompletions
        New-CommandCompleter -Name show -Aliases list, lst -Description $msg.rule_show -NoFileCompletions
        New-CommandCompleter -Name flush -Description $msg.rule_flush -NoFileCompletions
        New-CommandCompleter -Name save -Description $msg.rule_save -NoFileCompletions
        New-CommandCompleter -Name restore -Description $msg.rule_restore -NoFileCompletions
    ) -NoFileCompletions

    # netns
    New-CommandCompleter -Name netns -Aliases ns -Description $msg.netns -SubCommands @(
        New-CommandCompleter -Name list -Aliases show -Description $msg.netns_list -NoFileCompletions
        New-CommandCompleter -Name add -Description $msg.netns_add -NoFileCompletions
        New-CommandCompleter -Name attach -Description $msg.netns_attach -NoFileCompletions
        New-CommandCompleter -Name set -Description $msg.netns_set -NoFileCompletions
        New-CommandCompleter -Name delete -Aliases del -Description $msg.netns_delete -NoFileCompletions
        New-CommandCompleter -Name identify -Description $msg.netns_identify -NoFileCompletions
        New-CommandCompleter -Name pids -Description $msg.netns_pids -NoFileCompletions
        New-CommandCompleter -Name exec -Description $msg.netns_exec -DelegateArgumentIndex 1 -NoFileCompletions
        New-CommandCompleter -Name monitor -Description $msg.netns_monitor -NoFileCompletions
    ) -NoFileCompletions

    # tunnel
    New-CommandCompleter -Name tunnel -Aliases tunl -Description $msg.tunnel -SubCommands @(
        New-CommandCompleter -Name add -Description $msg.tunnel_add -NoFileCompletions
        New-CommandCompleter -Name change -Description $msg.tunnel_change -NoFileCompletions
        New-CommandCompleter -Name delete -Aliases del -Description $msg.tunnel_delete -NoFileCompletions
        New-CommandCompleter -Name show -Aliases list, lst -Description $msg.tunnel_show -NoFileCompletions
        New-CommandCompleter -Name prl -Description $msg.tunnel_prl -NoFileCompletions
        New-CommandCompleter -Name 6rd -Description $msg.tunnel_6rd -NoFileCompletions
    ) -NoFileCompletions

    # monitor
    New-CommandCompleter -Name monitor -Aliases mon, m -Description $msg.monitor -NoFileCompletions

    # Other object types
    New-CommandCompleter -Name maddress -Aliases maddr -Description $msg.maddress -NoFileCompletions
    New-CommandCompleter -Name mroute -Aliases mr -Description $msg.mroute -NoFileCompletions
    New-CommandCompleter -Name mrule -Description $msg.mrule -NoFileCompletions
    New-CommandCompleter -Name ntable -Description $msg.ntable -NoFileCompletions
    New-CommandCompleter -Name tcp_metrics -Aliases tcpmetrics, tcpm -Description $msg.tcpmetrics -NoFileCompletions
    New-CommandCompleter -Name token -Description $msg.token -NoFileCompletions
    New-CommandCompleter -Name xfrm -Description $msg.xfrm -NoFileCompletions
    New-CommandCompleter -Name nexthop -Aliases nh -Description $msg.nexthop -NoFileCompletions
    New-CommandCompleter -Name vrf -Description $msg.vrf -NoFileCompletions
    New-CommandCompleter -Name sr -Description $msg.sr -NoFileCompletions
    New-CommandCompleter -Name fou -Description $msg.fou -NoFileCompletions
    New-CommandCompleter -Name macsec -Description $msg.macsec -NoFileCompletions
    New-CommandCompleter -Name ila -Description $msg.ila -NoFileCompletions
    New-CommandCompleter -Name l2tp -Description $msg.l2tp -NoFileCompletions
    New-CommandCompleter -Name mptcp -Description $msg.mptcp -NoFileCompletions
    New-CommandCompleter -Name ioam -Description $msg.ioam -NoFileCompletions
    New-CommandCompleter -Name stats -Description $msg.stats -NoFileCompletions
    New-CommandCompleter -Name netconf -Description $msg.netconf -NoFileCompletions
    New-CommandCompleter -Name tuntap -Description $msg.tuntap -NoFileCompletions
) -NoFileCompletions
