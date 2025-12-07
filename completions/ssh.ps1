<#
 # ssh completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ssh                      = OpenSSH remote login client
    ipv4                     = Forces ssh to use IPv4 addresses only
    ipv6                     = Forces ssh to use IPv6 addresses only
    bind_address             = Local address to bind to
    bind_interface           = Bind to the address of that interface
    cipher                   = Selects the cipher specification for encrypting the session
    config                   = Specifies configuration file
    dynamic                  = Specifies local dynamic application-level port forwarding
    escape                   = Sets the escape character
    log_file                 = Append debug logs to log_file instead of standard error
    fork_after_auth          = Requests ssh to go to background just before command execution
    config_keyword           = Passes a configuration option
    gateway_ports            = Allows remote hosts to connect to local forwarded ports
    kex_algorithms           = Specifies available KEX algorithms
    identity_file            = Selects a file from which the identity is read
    login_name               = Specifies the user to log in as on the remote machine
    mac                      = Specifies MAC algorithms
    no_ctl_commands          = Disable the reading of ~/.ssh/rc
    forward_stdinout         = Forward stdin/stdout to host:port over secure channel
    option                   = Can be used to give options in the format used in configuration file
    port                     = Port to connect to on the remote host
    query                    = Queries for the algorithms supported
    quiet                    = Quiet mode
    local_forward            = Specifies local port forwarding
    remote_forward           = Specifies remote port forwarding
    subsystem                = Requests invocation of a subsystem on the remote system
    disable_tty              = Disable pseudo-terminal allocation
    force_tty                = Force pseudo-terminal allocation
    verbose                  = Verbose mode
    version                  = Display the version number
    disable_x11              = Disables X11 forwarding
    enable_x11               = Enables X11 forwarding
    trusted_x11              = Enables trusted X11 forwarding
    log_level                = Set the log level
    forward_agent            = Enables forwarding of the authentication agent connection
    disable_forward_agent    = Disables forwarding of the authentication agent connection
    background               = Requests ssh to go to background before command execution
    compress                 = Requests compression of all data
    pub_key_auth             = Enables public key authentication
    pwd_auth                 = Enables password authentication
    gssapi_auth              = Enables GSSAPI-based authentication
    disable_delegate_gssapi  = Disables forwarding of GSSAPI credentials
    hostkey_auth             = Enables host-based authentication
    kbd_interactive          = Enables keyboard-interactive authentication
    multiplexing             = Enables connection multiplexing
    stricthostkey            = Set strict host key checking behavior
    jump                     = Connect to target host via jump hosts
    cert_file                = Specifies certificate file
    connection_attempts      = Specifies the number of tries to make before exiting
    control_master           = Enables the sharing of multiple sessions over a single network connection
    control_path             = Specify the path to the control socket
    control_persist          = Control socket remains open in background
    exit_on_forward_failure  = Specifies whether ssh should terminate if it cannot set up all requested port forwardings
    host_key_algorithms      = Specifies the host key signature algorithms that the client wants to use
    host_key_alias           = Specifies an alias that should be used instead of real host name
    known_hosts_file         = Specifies alternative known_hosts file
    local_command            = Specifies a command to execute on local machine after successfully connecting
    macs_list                = Specifies the MAC algorithms in order of preference
    permit_local_command     = Allow local command execution via LocalCommand option or using !command escape sequence
    pkcs11_provider          = Specifies which PKCS#11 provider to use
    proxy_command            = Specifies the command to use to connect to the server
    proxy_jump               = Connect via jump hosts
    proxy_use_fdpass         = Specifies that ProxyCommand will pass a connected file descriptor
    pubkey_accepted_types    = Specifies the signature algorithms that will be used for public key authentication
    rekey_limit              = Specifies the maximum amount of data that may be transmitted before the session key is renegotiated
    remote_command           = Specifies a command to execute on the remote machine
    request_tty              = Request pseudo-terminal allocation
    send_env                 = Specifies environment variables to send to the server
    server_alive_count       = Sets the number of server alive messages which may be sent without ssh receiving any messages back
    server_alive_interval    = Sets a timeout interval in seconds after which if no data has been received from the server
    setenv                   = Directly specify environment variable
    stdin_null               = Redirects stdin from /dev/null
    stream_local_bind_mask   = Sets the octal file creation mode mask used when creating a Unix-domain socket file
    stream_local_bind_unlink = Specifies whether to remove an existing Unix-domain socket file before creating a new one
    syslog_facility          = Gives the facility code that is used when logging messages from ssh
    tcp_keepalive            = Specifies whether the system should send TCP keepalive messages to the other side
    tunnel                   = Request tun device forwarding between client and server
    tunnel_device            = Specifies the tun devices to open on the client and the server
    update_known_hosts       = Specifies whether ssh should automatically add host keys to known_hosts file
    verify_host_key_dns      = Specifies whether to verify the remote key using DNS and SSHFP resource records
    visual_host_key          = Specifies whether an ASCII art representation of remote host key fingerprint is printed
    xauth_location           = Specifies the full pathname of the xauth program
    
    print_config             = Print configuration for the Host and exit
    no_execute               = Do not execute a remote command
    tag                      = Specify a tag name that may be used to select configuration
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$sshOptions = @("AddKeysToAgent", "AddressFamily", "BatchMode", "BindAddress", "CanonicalDomains", "CanonicalizeFallbackLocal", "CanonicalizeHostname",
     "CanonicalizeMaxDots", "CanonicalizePermittedCNAMEs", "CASignatureAlgorithms", "CertificateFile", "CheckHostIP", "Ciphers", "ClearAllForwardings",
     "Compression", "ConnectionAttempts", "ConnectTimeout", "ControlMaster", "ControlPath", "ControlPersist", "DynamicForward", "EnableEscapeCommandline",
     "EscapeChar", "ExitOnForwardFailure", "FingerprintHash", "ForkAfterAuthentication", "ForwardAgent", "ForwardX11", "ForwardX11Timeout", "ForwardX11Trusted",
     "GatewayPorts", "GlobalKnownHostsFile", "GSSAPIAuthentication", "GSSAPIKeyExchange", "GSSAPIClientIdentity", "GSSAPIDelegateCredentials",
     "GSSAPIKexAlgorithms", "GSSAPIRenewalForcesRekey", "GSSAPIServerIdentity", "GSSAPITrustDns", "HashKnownHosts", "Host", "HostbasedAcceptedAlgorithms",
     "HostbasedAuthentication", "HostKeyAlgorithms", "HostKeyAlias", "Hostname", "IdentitiesOnly", "IdentityAgent", "IdentityFile", "IPQoS",
     "KbdInteractiveAuthentication", "KbdInteractiveDevices", "KexAlgorithms", "KnownHostsCommand", "LocalCommand", "LocalForward", "LogLevel", "MACs",
     "Match", "NoHostAuthenticationForLocalhost", "NumberOfPasswordPrompts", "PasswordAuthentication", "PermitLocalCommand", "PermitRemoteOpen",
     "PKCS11Provider", "Port", "PreferredAuthentications", "ProxyCommand", "ProxyJump", "ProxyUseFdpass", "PubkeyAcceptedAlgorithms", "PubkeyAuthentication",
     "RekeyLimit", "RemoteCommand", "RemoteForward", "RequestTTY", "RequiredRSASize", "SendEnv", "ServerAliveInterval", "ServerAliveCountMax", "SessionType",
     "SetEnv", "StdinNull", "StreamLocalBindMask", "StreamLocalBindUnlink", "StrictHostKeyChecking", "TCPKeepAlive", "Tunnel", "TunnelDevice", "UpdateHostKeys",
     "User", "UserKnownHostsFile", "VerifyHostKeyDNS", "VisualHostKey", "XAuthLocation"
)

Register-NativeCompleter -Name ssh -Description $msg.ssh -Metadata @{ sshOptions = $sshOptions } -Parameters @(
    New-ParamCompleter -ShortName '4' -Description $msg.ipv4
    New-ParamCompleter -ShortName '6' -Description $msg.ipv6
    New-ParamCompleter -ShortName A -Description $msg.forward_agent
    New-ParamCompleter -ShortName a -Description $msg.disable_forward_agent
    New-ParamCompleter -ShortName B -Description $msg.bind_interface -Type Required -VariableName 'bind_interface'
    New-ParamCompleter -ShortName b -Description $msg.bind_address -Type Required -VariableName 'bind_address'
    New-ParamCompleter -ShortName C -Description $msg.compress
    New-ParamCompleter -ShortName c -Description $msg.cipher -Type Required -VariableName 'cipher_spec'
    New-ParamCompleter -ShortName D -Description $msg.dynamic -Type Required -VariableName '[bind_address:]port'
    New-ParamCompleter -ShortName E -Description $msg.log_file -Type File -VariableName 'log_file'
    New-ParamCompleter -ShortName e -Description $msg.escape -Type Required -VariableName 'escape_char'
    New-ParamCompleter -ShortName F -Description $msg.config -Type File -VariableName 'configfile'
    New-ParamCompleter -ShortName f -Description $msg.fork_after_auth
    New-ParamCompleter -ShortName G -Description $msg.print_config
    New-ParamCompleter -ShortName g -Description $msg.gateway_ports
    New-ParamCompleter -ShortName I -Description $msg.pkcs11_provider -Type File -VariableName 'pkcs11'
    New-ParamCompleter -ShortName i -Description $msg.identity_file -Type File -VariableName 'identity_file'
    New-ParamCompleter -ShortName J -Description $msg.proxy_jump -Type Required -VariableName 'destination'
    New-ParamCompleter -ShortName K -Description $msg.gssapi_auth
    New-ParamCompleter -ShortName k -Description $msg.disable_delegate_gssapi
    New-ParamCompleter -ShortName L -Description $msg.local_forward -Type Required -VariableName '[bind_address:]port:host:hostport'
    New-ParamCompleter -ShortName l -Description $msg.login_name -Type Required -VariableName 'login_name'
    New-ParamCompleter -ShortName M -Description $msg.control_master -Arguments "yes","no","ask","auto","autoask" -VariableName 'option'
    New-ParamCompleter -ShortName m -Description $msg.mac -Type List -VariableName 'mac_spec'
    New-ParamCompleter -ShortName N -Description $msg.no_execute
    New-ParamCompleter -ShortName n -Description $msg.stdin_null
    New-ParamCompleter -ShortName O -Description $msg.multiplexing -Arguments "check", "forward","cancel","exit","stop" -VariableName 'ctl_cmd'
    New-ParamCompleter -ShortName o -Description $msg.option -Type Required -VariableName 'option' -ArgumentCompleter {
        $word = $_;
        $i = $word.IndexOf('=');
        if ($i -lt 0) {
            $this.Metadata.sshOptions | Where-Object { $_ -like "$word*" }
        }
    }
    New-ParamCompleter -ShortName P -Description $msg.tag -Type Required -VariableName 'tag'
    New-ParamCompleter -ShortName p -Description $msg.port -Type Required -VariableName 'port'
    New-ParamCompleter -ShortName Q -Description $msg.query -Arguments "cipher","cipher-auth","mac","kex","key","key-cert","key-plain","key-sig","protocol-version","sig","help" -VariableName 'query_option'
    New-ParamCompleter -ShortName q -Description $msg.quiet
    New-ParamCompleter -ShortName R -Description $msg.remote_forward -Type Required -VariableName '[bind_address:]port:host:hostport'
    New-ParamCompleter -ShortName S -Description $msg.control_path -Type File -VariableName 'ctl_path'
    New-ParamCompleter -ShortName s -Description $msg.subsystem
    New-ParamCompleter -ShortName T -Description $msg.disable_tty
    New-ParamCompleter -ShortName t -Description $msg.force_tty
    New-ParamCompleter -ShortName V -Description $msg.version
    New-ParamCompleter -ShortName v -Description $msg.verbose
    New-ParamCompleter -ShortName W -Description $msg.forward_stdinout -Type Required -VariableName 'host:port'
    New-ParamCompleter -ShortName w -Description $msg.tunnel -Arguments "yes","no","point-to-point","ethernet" -VariableName 'option'
    New-ParamCompleter -ShortName X -Description $msg.enable_x11
    New-ParamCompleter -ShortName x -Description $msg.disable_x11
    New-ParamCompleter -ShortName Y -Description $msg.trusted_x11
    New-ParamCompleter -ShortName y -Description $msg.syslog_facility -Type Required -VariableName 'facility'
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
