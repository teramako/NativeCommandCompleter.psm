<#
 # ifconfig completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ifconfig   = configure network interface parameters
    _all       = Display all interfaces
    _short     = Display a short list
    _verbose   = Be more verbose
    _version   = Display version information
    _help      = Display help message
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
) -NoFileCompletions -ArgumentCompleter {
    param([int] $position, [int] $argIndex)

    switch ($argIndex) {
        0 {
            # Complete <interface>
            if (Test-Path -LiteralPath '/sys/class/net' -PathType Container) {
                Get-ChildItem -LiteralPath '/sys/class/net' | Where-Object Name -Like "$wordToComplete*" |
                    ForEach-Object { $_.Name }
            }
        }
        1 {
            $msg = ConvertFrom-StringData @'
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
'@
            $cmds = @(
                "up `t{0}" -f $msg.up
                "down `t{0}" -f $msg.down
                "arp `t{0}" -f $msg.arp
                "-arp `t{0}" -f $msg.arp
                "promisc `t{0}" -f $msg.promisc
                "-promisc `t{0}" -f $msg.promisc
                "allmulti `t{0}" -f $msg.allmulti
                "-allmulti `t{0}" -f $msg.allmulti
                "mtu `t{0}" -f $msg.mtu
                "dstaddr `t{0}" -f $msg.dstaddr
                "netmask `t{0}" -f $msg.netmask
                "add `t{0}" -f $msg.add
                "del `t{0}" -f $msg.del
                "tunnel `t{0}" -f $msg.tunnel
                "irq `t{0}" -f $msg.irq
                "io_addr `t{0}" -f $msg.io_addr
                "mem_start `t{0}" -f $msg.mem_start
                "media `t{0}" -f $msg.media
                "broadcast `t{0}" -f $msg.broadcast
                "-broadcast `t{0}" -f $msg.broadcast
                "pointopoint `t{0}" -f $msg.pointopoint
                "-pointopoint `t{0}" -f $msg.pointopoint
                "hw `t{0}" -f $msg.hw
                "multicast `t{0}" -f $msg.multicast
                "address `t{0}" -f $msg.address
                "txqueuelen `t{0}" -f $msg.txqueuelen
                "name `t{0}" -f $msg.name
            )
            $cmds | Where-Object { $_ -like "$wordToComplete*" }
        }
    }
}
