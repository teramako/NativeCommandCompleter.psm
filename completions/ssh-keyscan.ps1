<#
 # ssh-keyscan completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ssh_keyscan     = gather SSH public keys from servers
    ipv4            = Forces ssh-keyscan to use IPv4 addresses only
    ipv6            = Forces ssh-keyscan to use IPv6 addresses only
    certificate     = Request certificates from target hosts instead of plain keys
    print_SSHFP_DNS = Print keys found as SSHFP DNS records.
    file            = Read hosts or "addrlist namelist" pairs from file
    hash_hosts      = Hash all hostnames and addresses in the output
    port            = Port to connect to on the remote host
    timeout         = Set the timeout for connection attempts
    type            = Specify the type of the key to fetch from the scanned hosts
    verbose         = Verbose mode
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ssh-keyscan -Description $msg.ssh_keyscan -Parameters @(
    New-ParamCompleter -ShortName '4' -Description $msg.ipv4
    New-ParamCompleter -ShortName '6' -Description $msg.ipv6
    New-ParamCompleter -ShortName c -Description $msg.certificate
    New-ParamCompleter -ShortName D -Description $msg.print_SSHFP_DNS
    New-ParamCompleter -ShortName f -Description $msg.file -Type File -VariableName 'file'
    New-ParamCompleter -ShortName H -Description $msg.hash_hosts
    New-ParamCompleter -ShortName p -Description $msg.port -Type Required -VariableName 'port'
    New-ParamCompleter -ShortName T -Description $msg.timeout -Type Required -VariableName 'timeout'
    New-ParamCompleter -ShortName t -Description $msg.type -Type List -Arguments @(
        "dsa"
        "ecdsa"
        "ecdsa-sha2-nistp256"
        "ecdsa-sha2-nistp384"
        "ecdsa-sha2-nistp521"
        "ed25519"
        "rsa"
    ) -VariableName 'type'
    New-ParamCompleter -ShortName v -Description $msg.verbose
) -NoFileCompletions
