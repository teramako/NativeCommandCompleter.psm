<#
 # sftp completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    sftp                    = OpenSSH secure file transfer
    ipv4                    = Forces sftp to use IPv4 addresses only
    ipv6                    = Forces sftp to use IPv6 addresses only
    attemptContinue         = Attempt to continue interrupted transfers
    bufferSize              = Specify the size of the buffer that sftp uses when transferring files
    batchfile               = Batch file
    ciphers                 = Specifies the ciphers to be used for encrypting the data transfers
    compression             = Enables compression
    configFile              = Specifies an alternative per-user configuration file
    directConnect           = Connect directly to a local SFTP server
    jumpHost                = Destination to jumpHost
    forwardAgent            = Allows forwarding of ssh-agent to the remote system
    identity                = Selects the file from which the identity for public key authentication is read
    limitBandwidth          = Limits the used bandwidth, specified in Kbit/s
    noQuiet                 = Disables quiet mode
    sshOption               = Can be used to pass options to ssh
    port                    = Specifies the port to connect to on the remote host
    preserveTimes           = Preserves modification times, access times, and modes from the original files
    quiet                   = Quiet mode
    recursiveCopy           = Recursively copy entire directories when uploading and downloading
    requests                = Specify how many requests may be outstanding at any one time
    program                 = Program to use for the encrypted connection
    subsystem               = Specifies the SSH2 subsystem or the path for an sftp server on the remote host
    verbose                 = Raise logging level
    fsync                   = Flush file to disk after transfer
    sftpOption              = Specify an option that controls aspects of SFTP protocol behaviour.
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name sftp -Description $msg.sftp -Parameters @(
    New-ParamCompleter -ShortName '4' -Description $msg.ipv4
    New-ParamCompleter -ShortName '6' -Description $msg.ipv6
    New-ParamCompleter -ShortName A -Description $msg.forwardAgent
    New-ParamCompleter -ShortName a -Description $msg.attemptContinue
    New-ParamCompleter -ShortName B -Description $msg.bufferSize -Type Required -VariableName 'buffer_size'
    New-ParamCompleter -ShortName b -Description $msg.batchfile -Type File -VariableName 'batchfile'
    New-ParamCompleter -ShortName c -Description $msg.ciphers -Type Required -VariableName 'cipher_spec'
    New-ParamCompleter -ShortName C -Description $msg.compression
    New-ParamCompleter -ShortName D -Description $msg.directConnect -Type Required -VariableName 'sftp_server_path'
    New-ParamCompleter -ShortName F -Description $msg.configFile -Type File -VariableName 'ssh_config'
    New-ParamCompleter -ShortName f -Description $msg.fsync
    New-ParamCompleter -ShortName i -Description $msg.identity -Type File -VariableName 'identity_file'
    New-ParamCompleter -ShortName J -Description $msg.jumpHost -Type Required -VariableName 'destination'
    New-ParamCompleter -ShortName l -Description $msg.limitBandwidth -Type Required -VariableName 'limit'
    New-ParamCompleter -ShortName N -Description $msg.noQuiet
    New-ParamCompleter -ShortName o -Description $msg.sshOption -Type Required -VariableName 'ssh_option'
    New-ParamCompleter -ShortName P -Description $msg.port -Type Required -VariableName 'port'
    New-ParamCompleter -ShortName p -Description $msg.preserveTimes
    New-ParamCompleter -ShortName q -Description $msg.quiet
    New-ParamCompleter -ShortName R -Description $msg.requests -Type Required -VariableName 'num_requests'
    New-ParamCompleter -ShortName r -Description $msg.recursiveCopy
    New-ParamCompleter -ShortName S -Description $msg.program -Type Required -VariableName 'program'
    New-ParamCompleter -ShortName s -Description $msg.subsystem -Type Required -VariableName 'subsystem'
    New-ParamCompleter -ShortName v -Description $msg.verbose
    New-ParamCompleter -ShortName X -Description $msg.sftpOption -Type Required -VariableName 'sftp_option'
) -NoFileCompletions -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    if ($argIndex -eq 0)
    {
        $configFile = $this.BoundParameters["F"] ?? '~/.ssh/config'
        if (-not (Test-Path $configFile)) { return }
        Get-Content ~/.ssh/config | ForEach-Object {
            if ($_ -match '^\s*Host\s+(.+)$') {
                $hosts = $Matches[1] -split '\s+'
                foreach ($h in $hosts) {
                    if ($h -notmatch '[*?]' -and $h -like "$wordToComplete*") {
                        $h
                    }
                }
            }
        }
    }
}
