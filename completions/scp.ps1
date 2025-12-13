<#
 # scp completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    scp                    = OpenSSH secure file copy
    copyBetweenTwoHost     = Copies between two remote hosts are transferred through the local host
    ipv4                   = Forces scp to use IPv4 addresses only
    ipv6                   = Forces scp to use IPv6 addresses only
    forwardAgent           = Allows forwarding of ssh-agent to the remote system
    batchMode              = Prevents asking for passwords and passphrases
    cipher                 = Selects the cipher to use for encrypting the data transfer
    compression            = Enables compression
    directConnect          = Connect directly to a local SFTP server
    config                 = Specifies an alternative per-user configuration file
    identityFile           = Selects the file from which the identity for public key authentication is read
    jumpHost               = Connect to the target host by first making an scp connection to the jump host
    limit                  = Limits the used bandwidth, specified in Kbit/s
    useSCP                 = Use original SCP protocol instead of SFTP
    sshOption              = Can be used to pass options to ssh
    port                   = Specifies the port to connect to on the remote host
    preserve               = Preserves modification times, access times, and modes
    quiet                  = Quiet mode: disables the progress meter
    recursive              = Recursively copy entire directories
    program                = Name of program to use for the encrypted connection
    noStrictChecking       = Disable strict filename checking
    source_address         = Use the specified address as the source address
    verbose                = Verbose mode
    sftpOption             = Specify an option that controls aspects of SFTP protocol behaviour.
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name scp -Description $msg.scp -Parameters @(
    New-ParamCompleter -ShortName '3' -Description $msg.copyBetweenTwoHost
    New-ParamCompleter -ShortName '4' -Description $msg.ipv4
    New-ParamCompleter -ShortName '6' -Description $msg.ipv6
    New-ParamCompleter -ShortName A -Description $msg.forwardAgent
    New-ParamCompleter -ShortName B -Description $msg.batchMode
    New-ParamCompleter -ShortName C -Description $msg.compression
    New-ParamCompleter -ShortName c -Description $msg.cipher -Type Required -VariableName 'cipher'
    New-ParamCompleter -ShortName D -Description $msg.directConnect -Type Required -VariableName 'sftp_server_path'
    New-ParamCompleter -ShortName F -Description $msg.config -Type File -VariableName 'ssh_config'
    New-ParamCompleter -ShortName i -Description $msg.identityFile -Type File -VariableName 'identity_file'
    New-ParamCompleter -ShortName J -Description $msg.jumpHost -Type Required -VariableName 'destination'
    New-ParamCompleter -ShortName l -Description $msg.limit -Type Required -VariableName 'limit'
    New-ParamCompleter -ShortName O -Description $msg.useSCP
    New-ParamCompleter -ShortName o -Description $msg.sshOption -Type Required -VariableName 'ssh_option'
    New-ParamCompleter -ShortName P -Description $msg.port -Type Required -VariableName 'port'
    New-ParamCompleter -ShortName p -Description $msg.preserve
    New-ParamCompleter -ShortName q -Description $msg.quiet
    New-ParamCompleter -ShortName r -Description $msg.recursive
    New-ParamCompleter -ShortName S -Description $msg.program -Type Required -VariableName 'program'
    New-ParamCompleter -ShortName T -Description $msg.noStrictChecking
    New-ParamCompleter -ShortName v -Description $msg.verbose
    New-ParamCompleter -ShortName X -Description $msg.sftpOption -Type Required -VariableName 'sftp_option'
)
