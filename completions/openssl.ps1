<#
 # openssl completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    openssl                 = OpenSSL command line tool
    help                    = Display help information
    version                 = Display version information
    
    asn1parse               = Parse ASN.1 sequences
    ca                      = Certificate Authority management
    ciphers                 = Cipher suite description determination
    cms                     = CMS utility
    crl                     = CRL utility
    crl2pkcs7               = Create PKCS#7 structure from CRL
    dgst                    = Message digest calculation
    dhparam                 = DH parameter manipulation and generation
    dsa                     = DSA data management
    dsaparam                = DSA parameter manipulation and generation
    ec                      = EC key processing
    ecparam                 = EC parameter manipulation and generation
    enc                     = Encoding with ciphers
    engine                  = Engine information and manipulation
    errstr                  = Error number to error string conversion
    gendsa                  = Generate DSA private key
    genpkey                 = Generate private key
    genrsa                  = Generate RSA private key
    info                    = Display diverse information
    kdf                     = Key Derivation Function algorithms
    list                    = List algorithms and features
    mac                     = Message Authentication Code algorithms
    nseq                    = Create or examine netscape certificate sequence
    ocsp                    = OCSP utility
    passwd                  = Compute password hashes
    pkcs12                  = PKCS#12 file utility
    pkcs7                   = PKCS#7 file utility
    pkcs8                   = PKCS#8 format private key conversion
    pkey                    = Public and private key management
    pkeyparam               = Public key algorithm parameter management
    pkeyutl                 = Public key algorithm utility
    prime                   = Check if number is prime
    rand                    = Generate pseudo-random bytes
    randfile                = Generate random file
    rehash                  = Create symbolic links to certificate files
    req                     = PKCS#10 certificate request and certificate generating utility
    rsa                     = RSA key management
    rsautl                  = RSA utility for sign, verify, encrypt and decrypt
    s_client                = SSL/TLS client program
    s_server                = SSL/TLS server program
    s_time                  = SSL/TLS performance timing program
    sess_id                 = SSL session handling utility
    smime                   = S/MIME mail processing
    speed                   = Algorithm speed measurement
    spkac                   = SPKAC printing and generating utility
    srp                     = SRP utility
    storeutl                = STORE utility
    ts                      = Time Stamping Authority tool
    _verify                 = X.509 certificate verification
    x509                    = X.509 certificate data management
    
    verbose                 = Verbose output about the operations
    quiet                   = Fewer details output about the operations
    config                  = Configuration file
    in                      = Input file
    out                     = Output file
    inform                  = Input format
    outform                 = Output format
    keyform                 = Private key format
    certform                = Certificate data format
    passin                  = Input file pass phrase source
    passout                 = Output file pass phrase source
    text                    = Print in text form
    noout                   = Don't output encoded version
    modulus                 = Print modulus value
    check                   = Check consistency
    pubin                   = Input is public key
    pubout                  = Output public key
    new                     = Generate new
    newkey                  = Generate new private key
    nodes                   = Don't encrypt private key
    keyout                  = Write private key to file
    days                    = Number of days cert is valid
    subj                    = Set or override request subject
    key                     = Private key file
    cert                    = Certificate file
    CAfile                  = CA certificate file
    CApath                  = CA certificate directory
    verify                  = Turn on peer certificate verification
    cipher                  = Cipher suite
    connect                 = Connect to host:port
    servername              = Set TLS SNI hostname
    starttls                = Use STARTTLS protocol
    brief                   = Brief output
    showcerts               = Show all certificates in chain
    prexit                  = Print session information on exit
    state                   = Print SSL session states
    debug                   = Print extensive debugging information
    msg                     = Show protocol messages
    nbio                    = Turn on non-blocking IO
    crlf                    = Convert LF to CRLF
    ign_eof                 = Ignore input EOF
    no_ign_eof              = Don't ignore input EOF
    tls1                    = Use TLSv1
    tls1_1                  = Use TLSv1.1
    tls1_2                  = Use TLSv1.2
    tls1_3                  = Use TLSv1.3
    no_ssl3                 = Disable SSLv3
    no_tls1                 = Disable TLSv1
    no_tls1_1               = Disable TLSv1.1
    no_tls1_2               = Disable TLSv1.2
    no_tls1_3               = Disable TLSv1.3
    bugs                    = Enable workarounds for known bugs
    
    format_PEM              = PEM format
    format_DER              = DER format
    format_P12              = PKCS#12 format
    format_SMIME            = S/MIME format
    format_ENGINE           = ENGINE format
    
    starttls_smtp           = SMTP protocol
    starttls_pop3           = POP3 protocol
    starttls_imap           = IMAP protocol
    starttls_ftp            = FTP protocol
    starttls_xmpp           = XMPP protocol

    asn1parse_offset        = Starting offset to begin parsing
    asn1parse_length        = Number of bytes to parse
    asn1parse_indent        = Indents the output according to the "depth" of the structures
    asn1parse_oid           = A file containing additional OBJECT IDENTIFIERs (OIDs)
    asn1parse_dump          = Dump unknown data in hex format
    asn1parse_dlimit        = Like -dump, but only the first num bytes are output
    asn1parse_strparse      = Parse the contents octets of the ASN.1 object starting at offset
    asn1parse_genstr        = Generate encoded data based on the specified string
    asn1parse_genconf       = Generate encoded data based on the specified file
    asn1parse_strictpem     = Treat as PEM format with base64 encoded
    asn1parse_item          = Attempt to decode and print the data as an ASN1_ITEM name

    provider                = Load and initialize the provider identified by name
    providerPath            = Specifies the search path that is to be used for looking for providers
    provparam               = Set configuration parameter key to value val in provider name (optional)
    propquery               = Query for loaded provider's property
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$formArgs = @(
    "PEM`t{0}" -f $msg.format_PEM
    "DER`t{0}" -f $msg.format_DER
)
$certformArgs = @(
    "PEM`t{0}" -f $msg.format_PEM
    "DER`t{0}" -f $msg.format_DER
    "P12`t{0}" -f $msg.format_P12
)
$keyformArgs = @(
    "PEM`t{0}" -f $msg.format_PEM
    "DER`t{0}" -f $msg.format_DER
    "P12`t{0}" -f $msg.format_P12
    "ENGINE`t{0}" -f $msg.format_ENGINE
)
$informParam = New-ParamCompleter -Name inform -Description $msg.inform -Arguments $formArgs -VariableName 'format'
$outformParam = New-ParamCompleter -Name outform -Description $msg.outform -Arguments $formArgs -VariableName 'format'
$keyformParam = New-ParamCompleter -Name keyform -Description $msg.keyform -Arguments $keyformArgs -VariableName 'format'
$certformParam = New-ParamCompleter -Name certform -Description $msg.certform -Arguments $certformArgs -VariableName 'format'

$verboseParam = New-ParamCompleter -Name verbose -Description $msg.verbose
$quietParam = New-ParamCompleter -Name quiet -Description $msg.quiet
$configParam = New-ParamCompleter -Name config -Description $msg.config -Type File -VariableName 'configfile'

$passphraseCompleter = {
    switch -Wildcard ($wordToComplete) {
        'pass:*' { $null }
        'env:*' {
            $w = '{0}*' -f $wordToComplete.Split(':', 2)[1]
            [System.Environment]::GetEnvironmentVariables().Keys |
                Where-Object { $_ -like $w } | ForEach-Object { "env:$_" }
        }
        'file:*' {
            $w = $wordToComplete.Split(':', 2)[1]
            [MT.Comp.Helper]::CompleteFilename($w, $this.CurrentDirectory, $true) |
                ForEach-Object { $_.SetPrefix('file:') }
        }
        'fd:*' { $null }
        'stdin' { $null }
        default: {
            @(
                "pass:`tThe actual password",
                "env:`tFrom Environment variable",
                "file:`tRead from specified file",
                "fd:`tThe file descriptor number",
                "stdin`tFrom standard input"
            ) | Where-Object { $_ -like "$wordToComplete*" }
        }
    }
}

$inParam = New-ParamCompleter -Name in -Description $msg.in -Type File -VariableName 'file'
$outParam = New-ParamCompleter -Name out -Description $msg.out -Type File -VariableName 'file'
$passParam = New-ParamCompleter -Name pass -Description $msg.passout -Type Required -VariableName 'arg' -ArgumentCompleter $passphraseCompleter
$passinParam = New-ParamCompleter -Name passin -Description $msg.passin -Type Required -VariableName 'arg' -ArgumentCompleter $passphraseCompleter
$passoutParam = New-ParamCompleter -Name passout -Description $msg.passout -Type Required -VariableName 'arg' -ArgumentCompleter $passphraseCompleter
$textParam = New-ParamCompleter -Name text -Description $msg.text
$nooutParam = New-ParamCompleter -Name noout -Description $msg.noout

$randParam = New-ParamCompleter -Name rand -Description 'A file or files containing random data used to seed the random number generator' -Type File -VariableName 'files'
$writerandParam = New-ParamCompleter -Name writerand -Description 'Writes the seed data to the specified file' -Type File -VariableName 'file'
$engineParam = New-ParamCompleter -Name engine -Description 'Load the engine' -Type Required -VariableName 'id'

$providerParam = New-ParamCompleter -Name provider -Description $msg.provider -Type Required -VariableName 'name'
$providerPathParam = New-ParamCompleter -Name provider-path -Description $msg.providerParam -Type Directory -VariableName 'path'
$provparamParam = New-ParamCompleter -Name provparam -Description $msg.provparam -Type Required -VariableName '[name:]key=value'
$propqueryParam = New-ParamCompleter -Name propquery -Description $msg.propquery -Type Required -VariableName 'propq'

$digestParams = switch -Wildcard ((openssl dgst -list).ForEach({$_ -split '\s+' })) {
    '-*' { New-ParamCompleter -Name $_.Substring(1) -Description 'digest to be used' }
}

$encryptParams = @(
    New-ParamCompleter -Name aes128 -Description 'Encrypt with AES-128'
    New-ParamCompleter -Name aes192 -Description 'Encrypt with AES-192'
    New-ParamCompleter -Name aes256 -Description 'Encrypt with AES-256'
    New-ParamCompleter -Name aria128 -Description 'Encrypt with ARIA-128'
    New-ParamCompleter -Name aria192 -Description 'Encrypt with ARIA-192'
    New-ParamCompleter -Name aria256 -Description 'Encrypt with ARIA-256'
    New-ParamCompleter -Name camellia128 -Description 'Encrypt with Camellia-128'
    New-ParamCompleter -Name camellia192 -Description 'Encrypt with Camellia-192'
    New-ParamCompleter -Name camellia256 -Description 'Encrypt with Camellia-256'
    New-ParamCompleter -Name des -Description 'Encrypt with DES'
    New-ParamCompleter -Name des3 -Description 'Encrypt with 3DES'
    New-ParamCompleter -Name idea -Description 'Encrypt with IDEA'
)

Register-NativeCompleter -Name openssl -Description $msg.openssl -Style Unix -SubCommands @(
    New-CommandCompleter -Name help -Description $msg.help -NoFileCompletions
    New-CommandCompleter -Name version -Description $msg.version -NoFileCompletions

    New-CommandCompleter -Name asn1parse -Description $msg.asn1parse -Style Unix -Parameters @(
        $informParam
        $inParam
        $outParam
        $nooutParam
        New-ParamCompleter -Name offset -Description $msg.asn1parse_offset -Type Required -VariableName 'number'
        New-ParamCompleter -Name length -Description $msg.asn1parse_length -Type Required -VariableName 'number'
        New-ParamCompleter -Name i -Description $msg.asn1parse_indent
        New-ParamCompleter -Name oid -Description $msg.asn1parse_oid -Type File -VariableName 'filename'
        New-ParamCompleter -Name dump -Description $msg.asn1parse_dump
        New-ParamCompleter -Name dlimit -Description $msg.asn1parse_dlimit -Type Required -VariableName 'num'
        New-ParamCompleter -Name strparse -Description $msg.asn1parse_strparse -Type Required -VariableName 'offset'
        New-ParamCompleter -Name genstr -Description $msg.asn1parse_genstr -Type Required -VariableName 'string'
        New-ParamCompleter -Name genconf -Description $msg.asn1parse_genconf -Type File -VariableName 'file'
        New-ParamCompleter -Name strictpem -Description $msg.asn1parse_strictpem
        New-ParamCompleter -Name item -Description $msg.asn1parse_item -Type Required -VariableName 'name'
    )

    New-CommandCompleter -Name ca -Description $msg.ca -Style Unix -Parameters @(
        $verboseParam
        $quietParam
        New-ParamCompleter -Name config -Description 'Configuration file' -Type File -VariableName 'file'
        New-ParamCompleter -Name name, section -Description 'Specifies the configuration file section to use (overrides default_ca in the ca section)' -Type Required -VariableName 'section'
        $inParam
        $informParam
        New-ParamCompleter -Name ss_cert -Description 'A single self-signed certificate to be signed by the CA' -Type File -VariableName 'filename'
        New-ParamCompleter -Name spkac -Description 'SPCAK format file' -Type File -VariableName 'filename'
        New-ParamCompleter -Name infiles -Description 'certificate requests files' -Nargs '1+' -Type File -VariableName 'filename'
        $outParam
        New-ParamCompleter -Name outdir -Description 'The directory to output certificates to' -Type Directory -VariableName 'directory'
        New-ParamCompleter -Name cert -Description $msg.cert -Type File -VariableName 'file'
        $certformParam
        New-ParamCompleter -Name keyfile -Description 'Private key file' -Type File -VariableName 'file'
        $keyformParam
        New-ParamCompleter -Name sigopt -Description 'Pass options to the signature algorithm during sign operations' -Type Required -VariableName 'nm:v'
        New-ParamCompleter -Name vfyopt -Description 'Pass options to the signature algorithm during verify operations' -Type Required -VariableName 'nm:v'
        New-ParamCompleter -Name key -Description 'The password used to encrypt the private key (Better use -passin)' -Type Required -VariableName 'password'
        $passinParam
        New-ParamCompleter -Name selfsign -Description 'Create self-signed certificate'
        New-ParamCompleter -Name notext -Description "Don't output the text form of a certificate to the output file"
        New-ParamCompleter -Name dateopt -Description 'Specify the date output format' -Arguments "rfc_822","iso_8601"
        New-ParamCompleter -Name startdate, not_before -Description 'Set the start date' -Type Required -VariableName 'date'
        New-ParamCompleter -Name enddate, not_after -Description 'Set the end date' -Type Required -VariableName 'date'
        New-ParamCompleter -Name days -Description 'The number of days from today' -Type Required -VariableName 'N'
        New-ParamCompleter -Name md -Description 'The message digest to use' -Type Required -VariableName 'alg'
        New-ParamCompleter -Name policy -Description 'This  option  defines the CA "policy" to use' -Type Required -VariableName 'arg'
        New-ParamCompleter -Name preserveDN -Description 'Set the order is the same as the request'
        New-ParamCompleter -Name noemailDN -Description 'Delete EMAIL DN from Subject and set to extentions'
        New-ParamCompleter -Name batch -Description 'Batch mode'
        New-ParamCompleter -Name extensions -Description 'The section of the configuration file containing certificate extensions' -Type Required -VariableName 'section'
        New-ParamCompleter -Name extfile -Description 'An additional configuration file to read certificate extensions' -Type File -VariableName 'file'
        New-ParamCompleter -Name subj -Description 'Subject name' -Type Required -VariableName 'arg'
        New-ParamCompleter -Name utf8 -Description 'interpreted as UTF8 strings'
        New-ParamCompleter -Name create_serial -Description 'Creates a new random serial file if not exists'
        New-ParamCompleter -Name rand_serial -Description 'Generate a large random number to use as the serial number'
        $randParam
        $writerandParam
        $engineParam
        $providerParam
        $providerPathParam
        $provparamParam
        $propqueryParam
        New-ParamCompleter -Name genclr -Description 'Generates a CRL'
        New-ParamCompleter -Name crl_lastupdate -Description 'Set CRL''s lastUpdate field' -Type Required -VariableName 'time'
        New-ParamCompleter -Name crl_nextupdate -Description 'Set CRL''s nextUpdate field' -Type Required -VariableName 'time'
        New-ParamCompleter -Name crldays -Description 'The number of days before the next CRL is due' -Type Required -VariableName 'num'
        New-ParamCompleter -Name crlhours -Description 'The number of hours before the next CRL is due' -Type Required -VariableName 'num'
        New-ParamCompleter -Name crlsec -Description 'The number of seconds before the next CRL is due' -Type Required -VariableName 'num'
        New-ParamCompleter -Name revoke -Description 'A filename containing a certificate to revoke' -Type File -VariableName 'filename'
        New-ParamCompleter -Name valid -Description 'A filename containing a certificate to add a Valid certificate entry' -Type File -VariableName 'filename'
        New-ParamCompleter -Name status -Description 'Displays the revocation status' -Type Required -VariableName 'serial'
        New-ParamCompleter -Name updatedb -Description 'Updates the database index to purge expired certificates'
        New-ParamCompleter -Name crl_reason -Description 'Revocation reason' -Type Required -VariableName 'reason'
        New-ParamCompleter -Name crl_hold -Description 'Set the CRL hold instruction (OID)' -Type Required -VariableName 'instruction'
        New-ParamCompleter -Name crl_compromise -Description 'Set the compromise time (YYYYMMDDHHMMSSZ) to keyCompromise' -Type Required -VariableName 'time'
        New-ParamCompleter -Name crl_CA_compromise -Description 'Set the compromise time (YYYYMMDDHHMMSSZ) to CACompromise' -Type Required -VariableName 'time'
        New-ParamCompleter -Name crlexts -Description 'The section of the configuration file containing CRL extensions to include' -Type Required -VariableName 'section'
    )

    New-CommandCompleter -Name ciphers -Description $msg.ciphers -Style Unix -Parameters @(
        $providerParam
        $providerPathParam
        $provparamParam
        $propqueryParam
        New-ParamCompleter -Name s -Description 'List only supported ciphers'
        New-ParamCompleter -Name psk -Description 'When combined with -s includes cipher suites which require PSK'
        New-ParamCompleter -Name v -Description 'Verbose listing'
        New-ParamCompleter -Name V -Description 'Like -v, but show hex values additionaly'
        New-ParamCompleter -Name tls1 -Description $msg.tls1
        New-ParamCompleter -Name tls1_1 -Description $msg.tls1_1
        New-ParamCompleter -Name tls1_2 -Description $msg.tls1_2
        New-ParamCompleter -Name tls1_3 -Description $msg.tls1_3
        New-ParamCompleter -Name stdname -Description 'Precede each cipher suite by its standard name'
        New-ParamCompleter -Name convert -Description 'Convert a standard cipher name to its OpenSSL name' -Type Required -VariableName 'name'
        New-ParamCompleter -Name ciphersuites -Description 'Sets the list of TLSv1.3 ciphersuites' -Type Required -VariableName 'val'
    ) -NoFileCompletions

    New-CommandCompleter -Name dgst -Description $msg.dgst -Style Unix -Parameters @(
        $digestParams
        New-ParamCompleter -Name list -Description 'Prints out a list of supported message digests'
        $inParam
        New-ParamCompleter -Name c -Description 'Print digest with separating colons'
        New-ParamCompleter -Name binary -Description 'Output in binary form'
        New-ParamCompleter -Name r -Description 'Print digest in coreutils format'
        $outParam
        New-ParamCompleter -Name sign -Description 'Sign digest' -Type File -VariableName 'filename'
        New-ParamCompleter -Name hex -Description 'Output as hex dump'
        $keyformParam
        New-ParamCompleter -Name sigopt -Description 'Options to the signature algorithm during sign or verify operations' -Type Required -VariableName 'nm:v'
        $passinParam
        New-ParamCompleter -Name verify -Description 'Verify the signature using the public key' -Type File -VariableName 'filename'
        New-ParamCompleter -Name prverify -Description 'Verify the signature using the private key' -Type File -VariableName 'filename'
        New-ParamCompleter -Name signature -Description 'The actual signature to verify' -Type File -VariableName 'filename'
        New-ParamCompleter -Name hmac -Description 'Create a hashed MAC using "key"' -Type Required -VariableName 'key'
        New-ParamCompleter -Name mac -Description 'Create MAC' -Type Required -VariableName 'alg'
        New-ParamCompleter -Name macopt -Description 'Options to MAC algorithm' -Type Required -VariableName 'nm:y'
        New-ParamCompleter -Name fips-fingerprint -Description 'Compute HMAC using a specific key for certain OpenSSL-FIPS operations'
        $randParam
        $writerandParam
        $engineParam
        New-ParamCompleter -Name engine_impl -Description 'Use engine id for digest operations' -Type Required -VariableName 'id'
        $providerParam
        $providerPathParam
        $provparamParam
        $propqueryParam
    )

    New-CommandCompleter -Name enc -Description $msg.enc -Style Unix -Parameters @(
        switch -Wildcard ((openssl enc -list).ForEach({$_ -split '\s+' })) { '-*' {
            New-ParamCompleter -Name $_.Substring(1) -Description 'cipher to be used'
        } }
        New-ParamCompleter -Name list -Description 'List all supported ciphers'
        $inParam
        $outParam
        $passinParam
        $passoutParam
        New-ParamCompleter -Name e -Description 'Encrypt'
        New-ParamCompleter -Name d -Description 'Decrypt'
        New-ParamCompleter -Name base64,a -Description 'Base64 encode/decode'
        New-ParamCompleter -Name A -Description 'Used with -a to specify base64 buffer'
        New-ParamCompleter -Name k -Description 'Passphrase is next argument'
        New-ParamCompleter -Name kfile -Description 'Read passphrase from file' -Type File -VariableName 'file'
        New-ParamCompleter -Name md -Description 'Use the digest to create the key from the passphrase' -Type Required -VariableName 'digest'
        New-ParamCompleter -Name iter -Description 'Iteration count' -Type Required -VariableName 'count'
        New-ParamCompleter -Name pbkdf2 -Description 'Use PBKDF2 algorithm'
        New-ParamCompleter -Name nosalt -Description 'Do not use salt'
        New-ParamCompleter -Name salt -Description 'Use salt'
        New-ParamCompleter -Name S -Description 'The actual salt to use' -Type Required -VariableName 'salt'
        New-ParamCompleter -Name K -Description 'The actual key to use' -Type Required -VariableName 'key'
        New-ParamCompleter -Name iv -Description 'The actual IV to use' -Type Required -VariableName 'IV'
        New-ParamCompleter -Name p -Description 'Print key and IV'
        New-ParamCompleter -Name P -Description 'Print key, IV and exit'
        New-ParamCompleter -Name bufsize -Description 'Buffer size' -Type Required -VariableName 'size'
        New-ParamCompleter -Name nopad -Description 'Disable standard block padding'
        New-ParamCompleter -Name v -Description 'Verbose output'
        New-ParamCompleter -Name z -Description 'Compress or decompress encrypted data using zlib'
        New-ParamCompleter -Name none -Description 'Use NULL cipher'
        New-ParamCompleter -Name skeymgmt -Type Required -VariableName 'skymgmt'
        New-ParamCompleter -Name skeyopt -Type Required -VariableName 'opt:value'
        $randParam
        $writerandParam
        $providerParam
        $providerPathParam
        $provparamParam
        $propqueryParam
        $engineParam
    )

    New-CommandCompleter -Name genrsa -Description $msg.genrsa -Style Unix -Parameters @(
        $outParam
        $passoutParam
        $encryptParams
        New-ParamCompleter -Name primes -Description 'Specify  the number of primes to use while generating the RSA key' -Type Required -VariableName 'num'
        $verboseParam
        $quietParam
        New-ParamCompleter -Name traditional -Description 'Use PKCS#1 format instead of the PKCS#8'
        $randParam
        $writerandParam
        $engineParam
        $providerParam
        $providerPathParam
        $provparamParam
        $propqueryParam
    ) -NoFileCompletions

    New-CommandCompleter -Name genpkey -Description $msg.genpkey -Parameters @(
        $outParam
        New-ParamCompleter -Name outpubkey -Description 'Output the public key' -Type File -VariableName 'filename'
        $outformParam
        $verboseParam
        $quietParam
        $passParam
        New-ParamCompleter -Name algorithm -Description 'Public key algorithm' -Type Required -VariableName 'alg' -Arguments @(
            "RSA", "DSA", "DH", "DHX", "EC", "X25519", "ED448"
        )
        New-ParamCompleter -Name pkeyopt -Description 'Set public key algorithm option' -Type Required -VariableName 'opt:value' -ArgumentCompleter {
            $alg = $this.BoundParameters."altorithm"
            if (-not $alg) { return $null }
            ($k, $v) = $_.Split(':', 2)
            if (-not ([string]::IsNullOrEmpty($v))) {
            }

            switch -CaseSensitive ($alg) {
                'RSA' {
                    "rsa_keygen_bits:`tKey bit",
                    "rsa_keygen_primes:`tThe number of primes",
                    "rsa_keygen_pubexp:`tThe RSA public exponent value"
                }
                'RSA-PSS' {
                    "rsa_keygen_bits:`tKey bit",
                    "rsa_pss_keygen_md:`tDigest for signing",
                    "rsa_pss_keygen_mgf1_md:`tDigest for it's MGF1 parameter"
                    "rsa_pss_keygen_saltlen:`tMinimum salt length"
                }
                'EC' {
                    "ec_paramgen_curve:`tThe EC curve to use",
                    "ec_param_enc:`tThe encoding to use for parameters"
                }
                'ML-DSA' {
                    "hexseed:`tseed in hexadecimal form"
                }
                'ML-KEM' {
                    "hexseed:`tseed in hexadecimal form"
                }
            }
        }
        New-ParamCompleter -Name genparam -Description 'Generate a set of parameters instead of a private key'
        New-ParamCompleter -Name paramfile -Description 'Generate a private key based on a set of parameters' -Type File -VariableName 'filename'
        New-ParamCompleter -Name text -Description 'Print an (unencrypted) text representation'
        $randParam
        $writerandParam
        $engineParam
        $providerParam
        $providerPathParam
        $provparamParam
        $propqueryParam
        $configParam
    )

    New-CommandCompleter -Name req -Description $msg.req -Style Unix -Parameters @(
        $informParam
        $outformParam
        New-ParamCompleter -Name cipher -Description 'Cipher for encrypting the private key' -Type Required -VariableName 'name'
        $inParam
        New-ParamCompleter -Name sigopt -Description 'Pass options to the signature algorithm during sign operations' -Type Required -VariableName 'nm:v'
        New-ParamCompleter -Name vfyopt -Description 'Pass options to the signature algorithm during verify operations' -Type Required -VariableName 'nm:v'
        $passinParam
        $passoutParam
        $outParam
        $textParam
        New-ParamCompleter -Name subject -Description 'Prints out the certificate request subject'
        New-ParamCompleter -Name pubkey -Description 'Output public key'
        $nooutParam
        New-ParamCompleter -Name modules -Description 'Output value of modules of the public key'
        New-ParamCompleter -Name verify -Description 'Verifies the self-signature on the request'
        New-ParamCompleter -Name new -Description $msg.new
        New-ParamCompleter -Name newkey -Description $msg.newkey -Type Required -VariableName 'arg'
        New-ParamCompleter -Name pkeyopt -Description 'Set public key algorithm option' -Type Required -VariableName 'opt:value'
        New-ParamCompleter -Name key -Description $msg.key -Type File -VariableName 'file'
        $keyformParam
        New-ParamCompleter -Name keyout -Description $msg.keyout -Type File -VariableName 'file'
        New-ParamCompleter -Name noenc -Description 'Create a non-encrypted private key'
        New-ParamCompleter -Name nodes -Description $msg.nodes
        $digestParams
        $configParam
        New-ParamCompleter -Name section -Description 'Section name to be used (default = req)' -Type Required -VariableName 'name'
        New-ParamCompleter -Name subj -Description $msg.subj -Type Required -VariableName 'arg'
        New-ParamCompleter -Name x509 -Description 'Output self-signed certificate'
        New-ParamCompleter -Name x509v1 -Description 'Request generation of certificates with X.509 version 1'
        New-ParamCompleter -Name CA -Description 'Specifies the "CA" certificate' -Type File -VariableName 'filename|uri'
        New-ParamCompleter -Name CAkey -Description 'Sets the "CA" private key to sign a certificate with' -Type File -VariableName 'filename|uri'
        New-ParamCompleter -Name not_before -Description 'Set the start date' -Type Required -VariableName 'date'
        New-ParamCompleter -Name not_after -Description 'Set the end date' -Type Required -VariableName 'date'
        New-ParamCompleter -Name days -Description $msg.days -Type Required -VariableName 'n'
        New-ParamCompleter -Name set_serial -Description 'Serial number to use when outputting a self-signed certificate' -Type Required -VariableName 'n'
        New-ParamCompleter -Name copy_extensions -Description 'how X.509 extensions in certificate requests should be handled' -Arguments "none","copy","copyall" -VariableName 'arg'
        New-ParamCompleter -Name extensions, reqexts -Description 'override the name of the configuration file section from which X.509 extensions are included' -Type Required -VariableName 'section'
        New-ParamCompleter -Name addext -Description 'Add a specific extension to the certificate or the request' -Type Required -VariableName 'ext'
        New-ParamCompleter -Name precert -Description 'making it a "pre-certificate" (see RFC6962)'
        New-ParamCompleter -Name utf8 -Description 'interprete as UTF8 strings'
        New-ParamCompleter -Name reqopt -Description 'Customise the printing format' -Type List -VariableName 'option'
        New-ParamCompleter -Name newhdr -Description 'Adds the word NEW to the PEM file header and footer lines'
        New-ParamCompleter -Name batch -Description 'Non-interactive mode'
        $verboseParam
        $quietParam
        New-ParamCompleter -Name keygen_engine -Description 'Specifies an engine' -Type Required -VariableName 'id'
        New-ParamCompleter -Name nameopt -Description 'how the subject or issuer names are displayed' -Type Required -VariableName 'option'
        $randParam
        $writerandParam
        $engineParam
        $providerParam
        $providerPathParam
        $provparamParam
        $propqueryParam
    )

    New-CommandCompleter -Name rsa -Description $msg.rsa -Style Unix -Parameters @(
        New-ParamCompleter -Name inform -Description $msg.inform -Arguments @(
            "PEM`t{0}" -f $msg.format_PEM
            "DER`t{0}" -f $msg.format_DER
            "P12`t{0}" -f $msg.format_P12
            "ENGINE`t{0}" -f $msg.format_ENGINE
        ) -VariableName 'format'
        $outformParam
        New-ParamCompleter -Name traditional -Description 'Use PKCS#1 format instead of the PKCS#8'
        $inParam
        $passinParam
        $outParam
        $passoutParam
        $encryptParams
        $textParam
        $nooutParam
        New-ParamCompleter -Name modulus -Description $msg.modulus
        New-ParamCompleter -Name check -Description $msg.check
        New-ParamCompleter -Name pubin -Description $msg.pubin
        New-ParamCompleter -Name pubout -Description $msg.pubout
        New-ParamCompleter -Name RSAPublicKey_in -Description 'Like -pubin except RSAPublicKey format is used instead'
        New-ParamCompleter -Name RSAPublicKey_out -Description 'Like -pubout except RSAPublicKey format is used instead'
        New-ParamCompleter -Name pvk-strong -Description "Enable 'Strong' PVK encoding level (default)"
        New-ParamCompleter -Name pvk-weak -Description "Enable 'Weak' PVK encoding level"
        New-ParamCompleter -Name pvk-none -Description "Don't enforce PVK encoding"
        $engineParam
        $providerParam
        $providerPathParam
        $provparamParam
        $propqueryParam
    )

    New-CommandCompleter -Name s_client -Description $msg.s_client -Style Unix -Parameters @(
        New-ParamCompleter -Name connect -Description $msg.connect -Type Required -VariableName 'host:port'
        New-ParamCompleter -Name proxy -Description 'With -connect, specify proxy host and port for HTTP' -Type Required -VariableName 'host:port'
        New-ParamCompleter -Name proxy_user -Description 'The proxy user' -Type Required -VariableName 'userid'
        New-ParamCompleter -Name proxy_pass -Description 'The proxy password' -VariableName 'arg' -ArgumentCompleter $passphraseCompleter
        New-ParamCompleter -Name unix -Description 'Connect over the specified Unix-domain socket' -Type File -VariableName 'path'
        New-ParamCompleter -Name '4' -Description 'Use IPv4'
        New-ParamCompleter -Name '6' -Description 'Use IPv6'
        New-ParamCompleter -Name quic -Description 'Connect using the QUIC protocol'
        New-ParamCompleter -Name servername -Description $msg.servername -Type Required -VariableName 'name'
        New-ParamCompleter -Name noservername -Description 'Suppresses sending of the SNI (Server Name Indication)'
        New-ParamCompleter -Name cert -Description $msg.cert -Type File -VariableName 'file'
        $certformParam
        New-ParamCompleter -Name cert_chain -Description 'A file or URI of untrusted certificates to use' -Type File -VariableName 'filename'
        New-ParamCompleter -Name build_chain -Description 'Should build the client certificate chain'
        New-ParamCompleter -Name CRL -Description 'CRL file to use' -Type File -VariableName 'filename'
        New-ParamCompleter -Name CRLform -Description 'The CRL file format' -Arguments $formArgs -VariableName 'form'
        New-ParamCompleter -Name crl_download -Description 'Download CRL from distribution points in the certificate'
        New-ParamCompleter -Name key -Description $msg.key -Type File -VariableName 'file'
        $keyformParam
        $passParam
        New-ParamCompleter -Name verify -Description $msg.verify -Type Required -VariableName 'depth'
        New-ParamCompleter -Name verify_return_error -Description 'Like with -verify, but returns verification errors'
        New-ParamCompleter -Name verify_quiet -Description 'Limit verify output to only errors'
        New-ParamCompleter -Name verifyCAfile -Description "Verifying the server's certificate" -Type File -VariableName 'filename'
        New-ParamCompleter -Name verifyCApath -Description "Verifying the server's certificate containing in the dir" -Type Directory -VariableName 'dir'
        New-ParamCompleter -Name verifyCAstore -Description 'The URI of a store containing trusted certificates to use' -Type Required -VariableName 'uri'
        New-ParamCompleter -Name chainCAfile -Description 'Use to build the client certificate chain' -Type File -VariableName 'file'
        New-ParamCompleter -Name chainCApath -Description 'A directory containing in client certificate chain' -Type Directory -VariableName 'directory'
        New-ParamCompleter -Name chainCAstore -Description 'The URI of a store' -Type Required -VariableName 'uri'
        New-ParamCompleter -Name requestCAfile -Description 'A file containing a list of certificates' -Type File -VariableName 'file'

        New-ParamCompleter -Name reconnect -Description 'Reconnects to the same server 5 times using the same session ID'
        New-ParamCompleter -Name showcerts -Description $msg.showcerts
        New-ParamCompleter -Name prexit -Description $msg.prexit
        New-ParamCompleter -Name no-interactive -Description 'non-interactive mode'
        New-ParamCompleter -Name state -Description $msg.state
        New-ParamCompleter -Name debug -Description $msg.debug
        New-ParamCompleter -Name nocommands -Description 'Do not use interactive command letters'
        New-ParamCompleter -Name adv -Description 'Use advanced command mode'

        New-ParamCompleter -Name CAfile -Description $msg.CAfile -Type File -VariableName 'file'
        New-ParamCompleter -Name CApath -Description $msg.CApath -Type Directory -VariableName 'dir'
        New-ParamCompleter -Name cipher -Description $msg.cipher -Type Required -VariableName 'cipherlist'
        New-ParamCompleter -Name starttls -Description $msg.starttls -Arguments @(
            "smtp`t{0}" -f $msg.starttls_smtp
            "pop3`t{0}" -f $msg.starttls_pop3
            "imap`t{0}" -f $msg.starttls_imap
            "ftp`t{0}" -f $msg.starttls_ftp
            "xmpp`t{0}" -f $msg.starttls_xmpp
        ) -VariableName 'protocol'
        New-ParamCompleter -Name quiet -Description $msg.quiet
        New-ParamCompleter -Name brief -Description $msg.brief
        New-ParamCompleter -Name msg -Description $msg.msg
        New-ParamCompleter -Name nbio -Description $msg.nbio
        New-ParamCompleter -Name crlf -Description $msg.crlf
        New-ParamCompleter -Name ign_eof -Description $msg.ign_eof
        New-ParamCompleter -Name no_ign_eof -Description $msg.no_ign_eof
        New-ParamCompleter -Name tls1 -Description $msg.tls1
        New-ParamCompleter -Name tls1_1 -Description $msg.tls1_1
        New-ParamCompleter -Name tls1_2 -Description $msg.tls1_2
        New-ParamCompleter -Name tls1_3 -Description $msg.tls1_3
        New-ParamCompleter -Name no_ssl3 -Description $msg.no_ssl3
        New-ParamCompleter -Name no_tls1 -Description $msg.no_tls1
        New-ParamCompleter -Name no_tls1_1 -Description $msg.no_tls1_1
        New-ParamCompleter -Name no_tls1_2 -Description $msg.no_tls1_2
        New-ParamCompleter -Name no_tls1_3 -Description $msg.no_tls1_3
        New-ParamCompleter -Name bugs -Description $msg.bugs
    ) -NoFileCompletions

    New-CommandCompleter -Name s_server -Description $msg.s_server -Style Unix -Parameters @(
        New-ParamCompleter -Name accept -Description 'TCP port to accept on' -Type Required -VariableName 'port'
        New-ParamCompleter -Name cert -Description $msg.cert -Type File -VariableName 'file'
        New-ParamCompleter -Name key -Description $msg.key -Type File -VariableName 'file'
        New-ParamCompleter -Name CAfile -Description $msg.CAfile -Type File -VariableName 'file'
        New-ParamCompleter -Name CApath -Description $msg.CApath -Type Directory -VariableName 'dir'
        New-ParamCompleter -Name verify -Description $msg.verify -Type Required -VariableName 'depth'
        New-ParamCompleter -Name Verify -Description 'Require client certificate' -Type Required -VariableName 'depth'
        New-ParamCompleter -Name cipher -Description $msg.cipher -Type Required -VariableName 'cipherlist'
        New-ParamCompleter -Name quiet -Description $msg.quiet
        New-ParamCompleter -Name www -Description 'Respond to WWW style requests'
        New-ParamCompleter -Name WWW -Description 'Respond to WWW style requests, serve files'
        New-ParamCompleter -Name HTTP -Description 'Run as HTTP server'
        New-ParamCompleter -Name debug -Description $msg.debug
        New-ParamCompleter -Name msg -Description $msg.msg
        New-ParamCompleter -Name state -Description $msg.state
        New-ParamCompleter -Name nbio -Description $msg.nbio
    )

    New-CommandCompleter -Name verify -Description $msg._verify -Style Unix -Parameters @(
        New-ParamCompleter -Name CAfile -Description $msg.CAfile -Type File -VariableName 'file'
        New-ParamCompleter -Name CApath -Description $msg.CApath -Type Directory -VariableName 'dir'
        New-ParamCompleter -Name verbose -Description 'Print extra information'
        New-ParamCompleter -Name purpose -Description 'Certificate purpose' -Type Required -VariableName 'purpose'
    )

    New-CommandCompleter -Name x509 -Description $msg.x509 -Style Unix -Parameters @(
        $inParam
        $outParam
        New-ParamCompleter -Name inform -Description $msg.inform -Arguments @("PEM`t{0}" -f $msg.format_PEM; "DER`t{0}" -f $msg.format_DER)
        $outformParam
        $textParam
        $nooutParam
        New-ParamCompleter -Name modulus -Description $msg.modulus
        New-ParamCompleter -Name serial -Description 'Print serial number'
        New-ParamCompleter -Name subject -Description 'Print subject'
        New-ParamCompleter -Name issuer -Description 'Print issuer'
        New-ParamCompleter -Name dates -Description 'Print validity dates'
        New-ParamCompleter -Name fingerprint -Description 'Print fingerprint'
        New-ParamCompleter -Name pubkey -Description 'Output public key'
        New-ParamCompleter -Name C -Description 'Print C code form'
        New-ParamCompleter -Name days -Description $msg.days -Type Required -VariableName 'n'
        New-ParamCompleter -Name signkey -Description 'Self-sign certificate' -Type File -VariableName 'file'
        New-ParamCompleter -Name CA -Description 'Set CA certificate' -Type File -VariableName 'file'
        New-ParamCompleter -Name CAkey -Description 'Set CA key' -Type File -VariableName 'file'
    )

    New-CommandCompleter -Name speed -Description $msg.speed -Style Unix -Parameters @(
        New-ParamCompleter -Name elapsed -Description 'Measure time in real time'
        New-ParamCompleter -Name evp -Description 'Use EVP cipher' -Type Required -VariableName 'alg'
    ) -NoFileCompletions

    New-CommandCompleter -Name rand -Description $msg.rand -Style Unix -Parameters @(
        $outParam
        New-ParamCompleter -Name hex -Description 'Output as hex'
        New-ParamCompleter -Name base64 -Description 'Output as base64'
    ) -NoFileCompletions

    New-CommandCompleter -Name passwd -Description $msg.passwd -Style Unix -Parameters @(
        New-ParamCompleter -Name crypt -Description 'Use crypt algorithm'
        New-ParamCompleter -Name 1 -Description 'Use MD5 algorithm'
        New-ParamCompleter -Name apr1 -Description 'Use Apache MD5 algorithm'
        New-ParamCompleter -Name 5 -Description 'Use SHA256 algorithm'
        New-ParamCompleter -Name 6 -Description 'Use SHA512 algorithm'
        New-ParamCompleter -Name salt -Description 'Use provided salt' -Type Required -VariableName 'string'
        New-ParamCompleter -Name stdin -Description 'Read password from stdin'
        New-ParamCompleter -Name quiet -Description $msg.quiet
    ) -NoFileCompletions
) -NoFileCompletions
