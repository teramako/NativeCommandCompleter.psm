<#
 # ipconfig completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    all         = Displays the full TCP/IP configuration for all adapters.
    displaydns  = Displays the contents of the DNS client resolver cache
    flushdns    = Flushes and resets the contents of the DNS client resolver cache.
    registerdns = Initiates manual dynamic registration for the DNS names and IP addresses
    release     = Sends a DHCPRELEASE message to the DHCP server
    release6    = Sends a DHCPRELEASE message to the DHCPv6 server
    renew       = Renews DHCP configuration for all adapters
    renew6      = Renews DHCPv6 configuration for all adapters
    setclassid  = Configures the DHCP class ID for a specified adapter
    showclassid = Displays the DHCP class ID for a specified adapter
    help        = Displays Help at the command prompt
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ipconfig -Style Windows -Parameters @(
    New-ParamCompleter -OldStyleName allcompartments
) -SubCommands @(
    New-CommandCompleter -Name '/all' -Description $msg.all -NoFileCompletions
    New-CommandCompleter -Name '/displaydns' -Description $msg.displaydns -NoFileCompletions
    New-CommandCompleter -Name '/flushdns' -Description $msg.flushdns -NoFileCompletions
    New-CommandCompleter -Name '/registerdns' -Description $msg.registerdns -NoFileCompletions
    New-CommandCompleter -Name '/release' -Description $msg.release -NoFileCompletions
    New-CommandCompleter -Name '/release6' -Description $msg.release6 -NoFileCompletions
    New-CommandCompleter -Name '/renew' -Description $msg.renew -NoFileCompletions
    New-CommandCompleter -Name '/renew6' -Description $msg.renew6 -NoFileCompletions
    New-CommandCompleter -Name '/setclassid' -Description $msg.setclassid -NoFileCompletions
    New-CommandCompleter -Name '/showclassid' -Description $msg.showclassid -NoFileCompletions
    New-CommandCompleter -Name '/?' -Description $msg.help -NoFileCompletions
) -NoFileCompletions
