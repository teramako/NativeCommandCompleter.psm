<#
 # ssh-keygen completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ssh_keygen                = authentication key generation, management and conversion
    bits                      = Specifies the number of bits in the key to create
    type                      = Specifies the type of key to create
    comment                   = Provides a new comment
    file                      = Specifies the filename of the key file
    passphrase                = Provides the (old) passphrase
    new_passphrase            = Provides the new passphrase
    rounds                    = Specifies the number of KDF rounds
    generate                  = Generate a Diffie-Hellman group exchange candidate
    screen                    = Screen candidate primes for Diffie-Hellman group exchange
    test_primality            = Test primality of candidate primes for DH-GEX
    fingerprint               = Show fingerprint of specified public key file
    hash_known_hosts          = Hash a known_hosts file
    import_key                = Import key to OpenSSH format
    export_key                = Export key to OpenSSH format
    find_host                 = Find hostname in known_hosts file
    list_fingerprints         = Show fingerprints and comments of all keys
    print_bubblebabble        = Print Bubble Babble digest
    change_comment            = Change comment in private and public key files
    change_passphrase         = Change passphrase of a private key file
    print_public              = Print public key
    quiet                     = Silence ssh-keygen
    revoke                    = Revoke keys in a KRL
    remove_keys               = Remove keys from known_hosts file
    sign_file                 = Sign file using SSH key
    verify_signature          = Verify signature on file
    check_krl                 = Test whether keys are revoked in a KRL
    update_krl                = Update KRL
    verbose                   = Verbose mode
    hash_function             = Specify hash algorithm for fingerprints
    convert_format            = Specify key format for conversions
    show_certificate          = Show the contents of a certificate
    cert_option               = Specify certificate option when signing a key
    serial_number             = Serial number for certificate
    identity_file             = Identity file for certificate
    principals_file           = Principals allowed to use signed key
    validity_interval         = Validity interval for certificate
    add_key                   = Add key to agent
    add_host_keys             = Add host keys from stdin to known_hosts
    allowed_signers           = File containing allowed signers
    find_principal            = Find principal name in allowed_signers file
    matching_principal        = Match principal name in allowed_signers file
    namespace                 = Specify namespace for FIDO key
    print_revoked             = Print revoked keys instead of revoking
    attestation               = Specify FIDO attestation challenge
    output_file               = Specify output file for key generation
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ssh-keygen -Description $msg.ssh_keygen -Parameters @(
    New-ParamCompleter -ShortName b -Description $msg.bits -Type Required -VariableName 'bits'
    New-ParamCompleter -ShortName t -Description $msg.type -Arguments @(
        "dsa`tDSA key"
        "ecdsa`tECDSA key"
        "ecdsa-sk`tECDSA security key"
        "ed25519`tEd25519 key"
        "ed25519-sk`tEd25519 security key"
        "rsa`tRSA key"
    ) -VariableName 'type'
    New-ParamCompleter -ShortName C -Description $msg.comment -Type Required -VariableName 'comment'
    New-ParamCompleter -ShortName f -Description $msg.file -Type File -VariableName 'filename'
    New-ParamCompleter -ShortName N -Description $msg.new_passphrase -Type Required -VariableName 'new_passphrase'
    New-ParamCompleter -ShortName P -Description $msg.passphrase -Type Required -VariableName 'passphrase'
    New-ParamCompleter -ShortName a -Description $msg.rounds -Type Required -VariableName 'rounds'
    New-ParamCompleter -ShortName G -Description $msg.generate -Type Required -VariableName 'output_file'
    New-ParamCompleter -ShortName T -Description $msg.screen -Type Required -VariableName 'output_file'
    New-ParamCompleter -ShortName M -Description $msg.test_primality -Arguments "generate","screen"
    New-ParamCompleter -ShortName l -Description $msg.fingerprint
    New-ParamCompleter -ShortName H -Description $msg.hash_known_hosts
    New-ParamCompleter -ShortName i -Description $msg.import_key
    New-ParamCompleter -ShortName e -Description $msg.export_key
    New-ParamCompleter -ShortName F -Description $msg.find_host -Type Required -VariableName 'hostname'
    New-ParamCompleter -ShortName L -Description $msg.list_fingerprints
    New-ParamCompleter -ShortName B -Description $msg.print_bubblebabble
    New-ParamCompleter -ShortName c -Description $msg.change_comment
    New-ParamCompleter -ShortName p -Description $msg.change_passphrase
    New-ParamCompleter -ShortName y -Description $msg.print_public
    New-ParamCompleter -ShortName q -Description $msg.quiet
    New-ParamCompleter -ShortName k -Description $msg.revoke -Type File -VariableName 'krl_file'
    New-ParamCompleter -ShortName R -Description $msg.remove_keys -Type Required -VariableName 'hostname'
    New-ParamCompleter -ShortName Y -Description $msg.sign_file -Arguments "find-principals","check-novalidate","sign","verify"
    New-ParamCompleter -ShortName Q -Description $msg.check_krl
    New-ParamCompleter -ShortName u -Description $msg.update_krl
    New-ParamCompleter -ShortName v -Description $msg.verbose
    New-ParamCompleter -ShortName E -Description $msg.hash_function -Type Required -Arguments "md5","sha256" -VariableName 'fingerprint_hash'
    New-ParamCompleter -ShortName m -Description $msg.convert_format -Arguments "RFC4716","PKCS8","PEM" -VariableName 'key_format'
    New-ParamCompleter -ShortName D -Description $msg.show_certificate -Type File -VariableName 'pkcs11'
    New-ParamCompleter -ShortName O -Description $msg.cert_option -Type Required -VariableName 'option'
    New-ParamCompleter -ShortName z -Description $msg.serial_number -Type Required -VariableName 'serial_number'
    New-ParamCompleter -ShortName I -Description $msg.identity_file -Type Required -VariableName 'key_id'
    New-ParamCompleter -ShortName n -Description $msg.principals_file -Type List -VariableName 'principals'
    New-ParamCompleter -ShortName V -Description $msg.validity_interval -Type Required -VariableName 'validity_interval'
    New-ParamCompleter -ShortName A -Description $msg.add_key
    New-ParamCompleter -ShortName h -Description $msg.add_host_keys
    New-ParamCompleter -ShortName s -Description $msg.allowed_signers -Type File -VariableName 'ca_key'
    New-ParamCompleter -ShortName U -Description $msg.find_principal
    New-ParamCompleter -ShortName Z -Description $msg.matching_principal -Type Required -VariableName 'principal'
    New-ParamCompleter -ShortName w -Description $msg.namespace -Type Required -VariableName 'provider'
    New-ParamCompleter -ShortName r -Description $msg.print_revoked
    New-ParamCompleter -ShortName g -Description $msg.attestation -Arguments "verify-required"
    New-ParamCompleter -ShortName o -Description $msg.output_file -Type File -VariableName 'filename'
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
        $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or 
        $_.Extension -match '^\.(pub|pem|ppk)?$'
    })
}
