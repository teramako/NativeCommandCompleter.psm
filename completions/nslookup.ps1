<#
 # nslookup completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    nslookup          = query Internet name servers interactively
    domain            = Set default domain name
    debug             = Set debugging mode
    nodebug           = Unset debugging mode
    defname           = Append domain name to each query
    nodefname         = Do not append domain name
    port              = Change default TCP/UDP name server port
    querytype         = Change type of information query
    type              = Change type of information query
    recurse           = Ask server to query other servers if it doesn't have information
    norecurse         = Do not ask server to query other servers
    retry             = Set number of retries
    timeout           = Set initial time-out interval
    vc                = Always use a virtual circuit
    novc              = Do not always use a virtual circuit
    search            = Append domain names in domain search list
    nosearch          = Do not append domain names
    class             = Change query class
    class_IN          = Internet class
    class_CHAOS       = Chaos class
    class_HESIOD      = MIT Athena Hesiod class
    class_ANY         = Wildcard
    srchlist          = Set domain search list
    ndots             = Set number of dots
    help              = Print brief summary of commands
    exit              = Exit the program
    server            = Change default server to specified DNS server
    lserver           = Change default server to specified DNS server using initial server
    root              = Change default server to the root server
    finger            = Connect with finger server
    ls                = List information about a DNS domain
    ls_a              = List canonical names and aliases
    ls_d              = List all records
    ls_t              = List records of given type
    view              = Sort and list output of ls command
    set               = Change state information affecting lookups
    all               = Print current values of frequently used options
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsWindows)
{
    Register-NativeCompleter -Name nslookup -Description $msg.nslookup -Parameters @(
        New-ParamCompleter -OldStyleName debug -Description $msg.debug
        New-ParamCompleter -OldStyleName nodebug -Description $msg.nodebug
        New-ParamCompleter -OldStyleName defname -Description $msg.defname
        New-ParamCompleter -OldStyleName nodefname -Description $msg.nodefname
        New-ParamCompleter -OldStyleName d2 -Description $msg.debug
        New-ParamCompleter -OldStyleName nod2 -Description $msg.nodebug
        New-ParamCompleter -OldStyleName domain -Description $msg.domain -Type Required -VariableName 'NAME'
        New-ParamCompleter -OldStyleName port -Description $msg.port -Type Required -VariableName 'PORT'
        New-ParamCompleter -OldStyleName querytype,type -Description $msg.querytype -Type Required -Arguments "A","AAAA","CNAME","MX","NS","PTR","SOA","SRV","TXT","ANY"
        New-ParamCompleter -OldStyleName recurse -Description $msg.recurse
        New-ParamCompleter -OldStyleName norecurse -Description $msg.norecurse
        New-ParamCompleter -OldStyleName retry -Description $msg.retry -Type Required -VariableName 'NUMBER'
        New-ParamCompleter -OldStyleName timeout -Description $msg.timeout -Type Required -VariableName 'NUMBER'
        New-ParamCompleter -OldStyleName vc -Description $msg.vc
        New-ParamCompleter -OldStyleName novc -Description $msg.novc
        New-ParamCompleter -OldStyleName class -Description $msg.class -Type Required -Arguments @(
            "IN`t{0}" -f $msg.class_IN
            "CHAOS`t{0}" -f $msg.class_CHAOS
            "HESIOD`t{0}" -f $msg.class_HESIOD
            "ANY`t{0}" -f $msg.class_ANY
        )
        New-ParamCompleter -OldStyleName srchlist -Description $msg.srchlist -Type Required -VariableName 'DOMAIN[/...]'
        New-ParamCompleter -OldStyleName '?' -Description $msg.help
    ) -NoFileCompletions
}
else
{
    Register-NativeCompleter -Name nslookup -Description $msg.nslookup -Parameters @(
        New-ParamCompleter -OldStyleName debug -Description $msg.debug
        New-ParamCompleter -OldStyleName nodebug -Description $msg.nodebug
        New-ParamCompleter -OldStyleName defname -Description $msg.defname
        New-ParamCompleter -OldStyleName nodefname -Description $msg.nodefname
        New-ParamCompleter -OldStyleName d2 -Description $msg.debug
        New-ParamCompleter -OldStyleName nod2 -Description $msg.nodebug
        New-ParamCompleter -OldStyleName domain -Description $msg.domain -Type Required -VariableName 'NAME'
        New-ParamCompleter -OldStyleName port -Description $msg.port -Type Required -VariableName 'PORT'
        New-ParamCompleter -OldStyleName querytype,type -Description $msg.querytype -Type Required -Arguments "A","AAAA","AFSDB","APL","CAA","CDNSKEY","CDS","CERT","CNAME","CSYNC","DHCID","DLV","DNAME","DNSKEY","DS","EUI48","EUI64","HINFO","HIP","HTTPS","IPSECKEY","KEY","KX","LOC","MX","NAPTR","NS","NSEC","NSEC3","NSEC3PARAM","OPENPGPKEY","PTR","RRSIG","RP","SIG","SMIMEA","SOA","SRV","SSHFP","SVCB","TA","TKEY","TLSA","TSIG","TXT","URI","ZONEMD","ANY"
        New-ParamCompleter -OldStyleName recurse -Description $msg.recurse
        New-ParamCompleter -OldStyleName norecurse -Description $msg.norecurse
        New-ParamCompleter -OldStyleName retry -Description $msg.retry -Type Required -VariableName 'NUMBER'
        New-ParamCompleter -OldStyleName timeout -Description $msg.timeout -Type Required -VariableName 'NUMBER'
        New-ParamCompleter -OldStyleName vc -Description $msg.vc
        New-ParamCompleter -OldStyleName novc -Description $msg.novc
        New-ParamCompleter -OldStyleName search -Description $msg.search
        New-ParamCompleter -OldStyleName nosearch -Description $msg.nosearch
        New-ParamCompleter -OldStyleName class -Description $msg.class -Type Required -Arguments @(
            "IN`t{0}" -f $msg.class_IN
            "CH`t{0}" -f $msg.class_CHAOS
            "HS`t{0}" -f $msg.class_HESIOD
            "ANY`t{0}" -f $msg.class_ANY
        )
        New-ParamCompleter -OldStyleName srchlist -Description $msg.srchlist -Type Required -VariableName 'DOMAIN[/...]'
        New-ParamCompleter -OldStyleName ndots -Description $msg.ndots -Type Required -VariableName 'NUMBER'
        New-ParamCompleter -OldStyleName '?' -Description $msg.help
    ) -NoFileCompletions
}
