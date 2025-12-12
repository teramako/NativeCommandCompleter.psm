<#
 # ifconfig completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ifconfig    = configure network interface parameters
    _all        = Display all interfaces
    _short      = Display a short list
    _verbose    = Be more verbose
    _version    = Display version information
    _help       = Display help message
    interface   = The name of the interface.
    up          = Activate the interface
    down        = Deactivate the interface
    arp         = Enable or disable ARP protocol on the interface
    promisc     = Enable or disable promiscuous mode
    allmulti    = Enable or disable all-multicast mode
    mtu         = Set the Maximum Transfer Unit (MTU)
    dstaddr     = Set the remote IP address for point-to-point link
    netmask     = Set the IP network mask
    add         = Add an IPv6 address
    del         = Delete an IPv6 address
    tunnel      = Create IPv6-over-IPv4 tunnel
    irq         = Set the interrupt line used by the device
    io_addr     = Set the I/O address of the device
    mem_start   = Set the start address for shared memory
    media       = Set the physical port or medium type
    broadcast   = Set the broadcast address
    pointopoint = Enable point-to-point mode
    hw          = Set the hardware address
    multicast   = Set the multicast flag
    address     = Set the IP address
    txqueuelen  = Set the transmit queue length
    name        = Change the interface name
    alias       = Create an interface alias
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ifconfig -Description $msg.ifconfig -Parameters @(
    # Display options
    New-ParamCompleter -OldStyleName a -Description $msg._all
    New-ParamCompleter -OldStyleName s -Description $msg._short
    New-ParamCompleter -OldStyleName v -Description $msg._verbose
    New-ParamCompleter -OldStyleName V -Description $msg._version
    New-ParamCompleter -LongName help -Description $msg._help
) -SubCommands @(
    $kvStyle = New-ParamStyle -ValueSeparator ' ' -ValueStyle Separated
    New-CommandCompleter -Name '*' -Description $msg.interface -CustomStyle $kvStyle -Parameters @(
        New-ParamCompleter -LongName up -Description $msg.up
        New-ParamCompleter -LongName down -Description $msg.down
        New-ParamCompleter -LongName arp,-arp -Description $msg.arp
        New-ParamCompleter -LongName promisc,-promisc -Description $msg.promisc
        New-ParamCompleter -LongName allmulti,-allmulti -Description $msg.allmulti
        New-ParamCompleter -LongName mtu -Description $msg.allmulti -Type Required -VariableName 'N'
        New-ParamCompleter -LongName dstaddr -Description $msg.dstaddr -Type Required -VariableName 'addr'
        New-ParamCompleter -LongName netmask -Description $msg.netmask -Type Required -VariableName 'addr'
        New-ParamCompleter -LongName add -Description $msg.add -Type Required -VariableName 'addr/prefixlen'
        New-ParamCompleter -LongName del -Description $msg.add -Type Required -VariableName 'addr/prefixlen'
        New-ParamCompleter -LongName tunnel -Description $msg.tunnel -Type Required -VariableName '::aa.bb.cc.dd'
        New-ParamCompleter -LongName irq -Description $msg.irq -Type Required -VariableName 'addr'
        New-ParamCompleter -LongName io_addr -Description $msg.io_addr -Type Required -VariableName 'addr'
        New-ParamCompleter -LongName mem_start -Description $msg.mem_start -Type Required -VariableName 'addr'
        New-ParamCompleter -LongName media -Description $msg.media -Type Required -VariableName 'type'
        New-ParamCompleter -LongName broadcast, -broadcast -Description $msg.broadcast -Type FlagOrValue -VariableName 'addr'
        New-ParamCompleter -LongName pointopoint, -pointopoint -Description $msg.pointopoint -Type FlagOrValue -VariableName 'addr'
        New-ParamCompleter -LongName hw -Description $msg.hw -Type Required -VariableName 'class address'
        New-ParamCompleter -LongName multicast -Description $msg.multicast
        New-ParamCompleter -LongName address -Description $msg.address
        New-ParamCompleter -LongName txqueuelen -Description $msg.txqueuelen -Type Required -VariableName 'length'
        New-ParamCompleter -LongName name -Description $msg.name -Type Required -VariableName 'newname'
    ) -NoFileCompletions
) -NoFileCompletions -ArgumentCompleter {
    # Complete <interface>
    if (Test-Path -LiteralPath '/sys/class/net' -PathType Container) {
        Get-ChildItem -LiteralPath '/sys/class/net' | Where-Object Name -Like "$wordToComplete*" |
            ForEach-Object { $_.Name }
    }
}
