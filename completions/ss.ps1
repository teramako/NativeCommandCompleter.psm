<#
 # ss completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ss                      = utility to investigate sockets
    help                    = Show help
    version                 = Print version information
    numeric                 = Don't resolve service names
    resolve                 = Resolve host names
    all                     = Display all sockets
    listening               = Display listening sockets
    options                 = Show timer information
    extended                = Show detailed socket information
    memory                  = Show socket memory usage
    processes               = Show process using socket
    threads                 = Show thread using socket
    info                    = Show internal TCP information
    context                 = As the -p option but also shows process security context
    contexts                = As the -Z option but also shows the socket context
    net                     = Switch to network namespace
    summary                 = Show socket usage summary
    bpf                     = Show BPF filter
    events                  = Display only RTNL-related sockets
    dccp                    = Display DCCP sockets
    sctp                    = Display SCTP sockets
    packet                  = Display packet sockets
    tcp                     = Display TCP sockets
    mptcp                   = Display MPTCP sockets
    udp                     = Display UDP sockets
    raw                     = Display RAW sockets
    unix                    = Display Unix domain sockets
    vsock                   = Display vsock sockets
    xdp                     = Display XDP sockets
    inetSockopt             = Display INET sockets
    ipv4                    = Display only IP version 4 sockets
    ipv6                    = Display only IP version 6 sockets
    tipc                    = Display TIPC sockets
    family                  = Display sockets of type FAMILY.
    tos                     = Show TOS and priority information
    cgroup                  = Show cgroup information
    kill                    = Forcibly close sockets
    no_header               = Suppress header line
    oneline                 = Display each socket on a single line
    wide                    = Don't truncate IP addresses by abbreviation
    diag                    = dump raw information about TCP sockets to FILE
    filter                  = Read filter information from FILE
    state                   = Show sockets in state STATE
    query                   = Filter sockets by EXPR
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ss -Description $msg.ss -Parameters @(
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
    New-ParamCompleter -ShortName H -LongName no-header -Description $msg.no_header
    New-ParamCompleter -ShortName O -LongName oneline -Description $msg.oneline
    New-ParamCompleter -ShortName n -LongName numeric -Description $msg.numeric
    New-ParamCompleter -ShortName r -LongName resolve -Description $msg.resolve
    New-ParamCompleter -ShortName a -LongName all -Description $msg.all
    New-ParamCompleter -ShortName l -LongName listening -Description $msg.listening
    New-ParamCompleter -ShortName o -LongName options -Description $msg.options
    New-ParamCompleter -ShortName e -LongName extended -Description $msg.extended
    New-ParamCompleter -ShortName m -LongName memory -Description $msg.memory
    New-ParamCompleter -ShortName p -LongName processes -Description $msg.processes
    New-ParamCompleter -ShortName T -LongName threads -Description $msg.threads
    New-ParamCompleter -ShortName i -LongName info -Description $msg.info
    New-ParamCompleter -LongName tos -Description $msg.tos
    New-ParamCompleter -LongName cgroup -Description $msg.cgroup
    New-ParamCompleter -ShortName K -LongName kill -Description $msg.kill
    New-ParamCompleter -ShortName s -LongName summary -Description $msg.summary
    New-ParamCompleter -ShortName E -LongName events -Description $msg.events
    New-ParamCompleter -ShortName Z -LongName context -Description $msg.context
    New-ParamCompleter -ShortName z -LongName contexts -Description $msg.contexts
    New-ParamCompleter -ShortName N -LongName net -Description $msg.net -Type Required -VariableName 'NSNAME'
    New-ParamCompleter -ShortName b -LongName bpf -Description $msg.bpf
    New-ParamCompleter -ShortName '4' -LongName ipv4 -Description $msg.ipv4
    New-ParamCompleter -ShortName '6' -LongName ipv6 -Description $msg.ipv6
    New-ParamCompleter -ShortName '0' -LongName packet -Description $msg.packet
    New-ParamCompleter -ShortName t -LongName tcp -Description $msg.tcp
    New-ParamCompleter -ShortName u -LongName udp -Description $msg.udp
    New-ParamCompleter -ShortName d -LongName dccp -Description $msg.dccp
    New-ParamCompleter -ShortName w -LongName raw -Description $msg.raw
    New-ParamCompleter -ShortName x -LongName unix -Description $msg.unix
    New-ParamCompleter -ShortName S -LongName sctp -Description $msg.sctp
    New-ParamCompleter -LongName tipc -Description $msg.tipc
    New-ParamCompleter -LongName vsock -Description $msg.vsock
    New-ParamCompleter -LongName xdp -Description $msg.xdp
    New-ParamCompleter -ShortName M -LongName mptcp -Description $msg.mptcp
    New-ParamCompleter -LongName inet-sockopt -Description $msg.inetSockopt
    New-ParamCompleter -ShortName f -LongName family -Description $msg.family -VariableName 'FAMILY' -Arguments "unix", "inet", "inet6", "link", "netlink", "vsock", "tipc", "xdp"
    New-ParamCompleter -ShortName A -LongName query, socket -Description $msg.query -Type List -VariableName '[!]QUERY' -Arguments @(
        "all","inet","tcp","mptcp","udp","raw","unix","unix_dgram","unix_stream","unix_seqpacket","packet","packet_raw","packet_dgram","netlink","dccp","sctp","vsock_stream","vsock_dgram","tipc","xdp"
    )
    New-ParamCompleter -ShortName D -LongName diag -Description $msg.filter -Type File -VariableName 'FILE'
    New-ParamCompleter -ShortName F -LongName filter -Description $msg.filter -Type File -VariableName 'FILE'
) -NoFileCompletions
