<#
 # arp completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    arp                = manipulate the system ARP cache
    display            = Display the current ARP entry for hostname
    delete             = Delete an entry for hostname
    set                = Create an ARP entry for hostname with MAC address
    file               = Process multiple entries from file
    numeric            = Display IP addresses numerically
    verbose            = Verbose mode
    device             = Select device interface
    help               = Display help and exit
    version            = Display version and exit
    
    win_display_all    = Displays current ARP entries
    win_display_inet   = Displays ARP entries for the specified interface
    win_delete         = Deletes the host specified by inet_addr
    win_set            = Adds the host and associates the MAC address
    win_set_temp       = Add temporary entry (default: permanent on Windows)
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsWindows)
{
    Register-NativeCompleter -Name arp -Description $msg.arp -Style Unix -Parameters @(
        New-ParamCompleter -ShortName a,g -Description $msg.win_display_all -Type FlagOrValue -VariableName 'inet_addr'
        New-ParamCompleter -ShortName d -Description $msg.win_delete -Type Required -VariableName 'inet_addr'
        New-ParamCompleter -ShortName s -Description $msg.win_set -Type Required -VariableName 'inet_addr'
        New-ParamCompleter -ShortName N -Description $msg.win_display_inet -Type Required -VariableName 'if_addr'
    ) -NoFileCompletions
}
else
{
    Register-NativeCompleter -Name arp -Description $msg.arp -Parameters @(
        New-ParamCompleter -ShortName a -LongName display -Description $msg.display -Type FlagOrValue -VariableName 'hostname'
        New-ParamCompleter -ShortName d -LongName delete -Description $msg.delete -Type Required -VariableName 'hostname'
        New-ParamCompleter -ShortName s -LongName set -Description $msg.set -Type Required -VariableName 'hostname'
        New-ParamCompleter -ShortName f -LongName file -Description $msg.file -Type File -VariableName 'filename'
        New-ParamCompleter -ShortName n -LongName numeric -Description $msg.numeric
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
        New-ParamCompleter -ShortName i -LongName device -Description $msg.device -Type Required -VariableName 'if'
        New-ParamCompleter -ShortName h -LongName help -Description $msg.help
        New-ParamCompleter -ShortName V -LongName version -Description $msg.version
    ) -NoFileCompletions
}
