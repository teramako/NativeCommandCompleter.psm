<#
 # tcpdump completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    tcpdump                     = dump traffic on a network
    dumpASCII                   = Print each packet in ASCII
    printAsNumberInBGP          = Print the AS number in BGP packets in ASDOT notation
    bufferSize                  = Set the operating system capture buffer size (in KiB)
    exitAfterCount              = Exit after receiving count packets
    count                       = Print only packet count when reading capture files
    maxFileSize                 = Maximum size per savefile (in MB)
    dumpPacket                  = Dump the compiled packet-matching code in a human readable form
    dumpPacketAsCFormat         = Dump packet-matching code as a C program fragment
    dumpPacketAsDecimalFormat   = Dump packet-matching code as decimal numbers
    listInterfaces              = Print list of network interfaces
    printLinkLevelHeader        = Print the link-level header on each dump line
    setIPsecDecryptOption       = Set options for decrypting IPsec ESP packets
    printIPv4AsNumeric          = Print foreign IPv4 addresses numerically
    filterFile                  = Use file as input for the filter expression
    rotateSeconds               = Rotate the dump file every rotate_seconds seconds
    help                        = Print version strings and a usage message
    version                     = Print the tcpdump and libpcap version strings
    detect802_11sHeaders        = Attempt to detect 802.11s draft mesh headers
    interface                   = Listen on interface
    monitor                     = Put interface into monitor mode
    immediateMode               = Capture in immediate mode
    timestampType               = Set the time stamp type for the capture
    listTimestampTypes          = List the supported time stamp types for the interface
    timestampPrecision          = Set timestamp precision
    micro                       = Set time stamp precision to microseconds
    nano                        = Set time stamp precision to nanoseconds
    dontVerifyChecksum          = Don't verify IP, TCP, UDP checksums
    line_buffered               = Make stdout line-buffered
    listDataLinkTypes           = List the known data link types for the interface
    loadModule                  = Load SMI MIB module definitions from file
    secret                      = Use a shared secret for validating digests with the TCP-MD5 option
    dontConvertAddresses        = Don't convert host addresses to names
    dontConvertDomainName       = Don't print domain name qualification of host names
    printOptionalNumber         = Print an optional packet number
    noOptimize                  = Do not run the packet-matching code optimizer
    noPromiscuousMode           = Don't put interface into promiscuous mode
    print                       = Print parsed packet output
    direction                   = Choose direction for which packets should be captured
    quiet                       = Print less protocol information
    readFile                    = Read packets from file
    absoluteSequence            = Print absolute TCP sequence numbers
    snapshotLength              = Snarf snaplen bytes of data from each packet
    type                        = Force packets to be interpreted the specified type
    timestamp                   = Don't print a timestamp on each dump line
    timestampAsEpoch            = Print timestamp as seconds and fractions of a second since epoch
    timestampAsDelta            = Print a delta between current and previous line
    timestampAsHMS              = Print timestamp as hours, minutes, seconds, and fractions of a second since midnight
    timestampAsDeltaFromFirst   = Print a delta between current and first line
    undecodedNFS                = Print undecoded NFS handles
    packetBuffered              = Make the packet output packet-buffered
    verbose                     = Produce (slightly more) verbose output
    verbose2                    = Even more verbose output
    verbose3                    = Even more verbose output
    readListOfFilenames         = Read a list of filenames from file
    writeFile                   = Write the raw packets to file
    filecount                   = Limit the number of files created
    hexDump                     = Print the data of each packet in hex (minus link level header)
    hexDump2                    = Print the data of each packet in hex (including link level header)
    hexDumpASCII                = Print the data of each packet in hex and ASCII (minus link level header)
    hexDumpASCII2               = Print the data of each packet in hex and ASCII (including link level header)
    linkType                    = Set the data link type to use while capturing packets
    postrotateCommand           = Make tcpdump run "postrotate-command file"
    relinquishPrivileges        = Drop privileges to user
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$interfaceCompleter = {
    tcpdump -D 2>/dev/null | ForEach-Object {
        if ($_ -match '^\d+\.(\S+)(?:\s+\((.*)\)\s*\[.+?\])?') {
            $name = $Matches[1]
            $desc = if ($Matches[2]) { $Matches[2] } else { "" }
            if ($name -like "$wordToComplete*") {
                if ($desc) {
                    "{0}`t{1}" -f $name, $desc
                } else {
                    $name
                }
            }
        }
    }
}

Register-NativeCompleter -Name tcpdump -Description $msg.tcpdump -Parameters @(
    New-ParamCompleter -ShortName A -Description $msg.dumpASCII
    New-ParamCompleter -ShortName b -Description $msg.printAsNumberInBGP
    New-ParamCompleter -ShortName B -LongName buffer-size -Description $msg.bufferSize -Type Required -VariableName 'buffer_size'
    New-ParamCompleter -ShortName c -Description $msg.exitAfterCount -Type Required -VariableName 'count'
    New-ParamCompleter -LongName count -Description $msg.count
    New-ParamCompleter -ShortName C -Description $msg.maxFileSize -Type Required -VariableName 'file_size'
    New-ParamCompleter -ShortName d -Description $msg.dumpPacket
    New-ParamCompleter -OldStyleName dd -Description $msg.dumpPacketAsCFormat
    New-ParamCompleter -OldStyleName ddd -Description $msg.dumpPacketAsDecimalFormat
    New-ParamCompleter -ShortName D -LongName list-interfaces -Description $msg.listInterfaces
    New-ParamCompleter -ShortName e -Description $msg.printLinkLevelHeader
    New-ParamCompleter -ShortName E -Description $msg.setIPsecDecryptOption -Type Required -VariableName 'algo:secret'
    New-ParamCompleter -ShortName f -Description $msg.printIPv4AsNumeric
    New-ParamCompleter -ShortName F -Description $msg.filterFile -Type File -VariableName 'file'
    New-ParamCompleter -ShortName G -Description $msg.rotateSeconds -Type Required -VariableName 'rotate_seconds'
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -LongName version -Description $msg.version
    New-ParamCompleter -ShortName H -Description $msg.detect802_11sHeaders
    New-ParamCompleter -ShortName i -LongName interface -Description $msg.interface -VariableName 'interface' -ArgumentCompleter $interfaceCompleter
    New-ParamCompleter -ShortName I -LongName monitor-mode -Description $msg.monitor
    New-ParamCompleter -LongName immediate-mode -Description $msg.immediateMode
    New-ParamCompleter -ShortName j -LongName list-time-stamp-types -Description $msg.timestampType -VariableName 'tstamp_type' -Arguments "host","host_lowprec","host_hiprec","adapter","adapter_unsynced"
    New-ParamCompleter -ShortName J -Description $msg.listTimestampTypes
    New-ParamCompleter -LongName time-stamp-precision -Description $msg.timestampPrecision -VariableName 'tstamp_precision' -Arguments "micro","nano"
    New-ParamCompleter -LongName micro -Description $msg.micro
    New-ParamCompleter -LongName nano -Description $msg.nano
    New-ParamCompleter -ShortName K -Description $msg.dontVerifyChecksum
    New-ParamCompleter -ShortName l -Description $msg.line_buffered
    New-ParamCompleter -ShortName L -LongName list-data-link-types -Description $msg.listDataLinkTypes
    New-ParamCompleter -ShortName m -Description $msg.loadModule -Type Required -VariableName 'module'
    New-ParamCompleter -ShortName M -Description $msg.secret -Type Required -VariableName 'secret'
    New-ParamCompleter -ShortName n -Description $msg.dontConvertAddresses
    New-ParamCompleter -ShortName N -Description $msg.dontConvertDomainName
    New-ParamCompleter -ShortName '#' -LongName number -Description $msg.printOptionalNumber
    New-ParamCompleter -ShortName O -LongName no-optimize -Description $msg.noOptimize
    New-ParamCompleter -ShortName p -LongName no-promiscuous-mode -Description $msg.noPromiscuousMode
    New-ParamCompleter -LongName print -Description $msg.print
    New-ParamCompleter -ShortName Q -Description $msg.direction -Arguments "in","out","inout" -VariableName 'direction'
    New-ParamCompleter -ShortName q -Description $msg.quiet
    New-ParamCompleter -ShortName r -Description $msg.readFile -Type File -VariableName 'file'
    New-ParamCompleter -ShortName S -LongName absolute-tcp-sequence-numbers -Description $msg.absoluteSequence
    New-ParamCompleter -ShortName s -LongName snapshot-length -Description $msg.snapshotLength -Type Required -VariableName 'snaplen'
    New-ParamCompleter -ShortName T -Description $msg.type -VariableName 'type' -Arguments "vat","rtp","rtcp","cnfp","wb","aodv"
    New-ParamCompleter -ShortName t -Description $msg.timestamp
    New-ParamCompleter -OldStyleName tt -Description $msg.timestampAsEpoch
    New-ParamCompleter -OldStyleName ttt -Description $msg.timestampAsDelta
    New-ParamCompleter -OldStyleName tttt -Description $msg.timestampAsHMS
    New-ParamCompleter -OldStyleName ttttt -Description $msg.timestampAsDeltaFromFirst
    New-ParamCompleter -ShortName u -Description $msg.undecodedNFS
    New-ParamCompleter -ShortName U -LongName packet-buffered -Description $msg.packetBuffered
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -OldStyleName vv -Description $msg.verbose2
    New-ParamCompleter -OldStyleName vvv -Description $msg.verbose3
    New-ParamCompleter -ShortName V -Description $msg.readListOfFilenames -Type File -VariableName 'file'
    New-ParamCompleter -ShortName w -Description $msg.writeFile -Type File -VariableName 'file'
    New-ParamCompleter -ShortName W -Description $msg.filecount -Type Required -VariableName 'filecount'
    New-ParamCompleter -ShortName x -Description $msg.hexDump
    New-ParamCompleter -OldStyleName xx -Description $msg.hexDump2
    New-ParamCompleter -ShortName X -Description $msg.hexDumpASCII
    New-ParamCompleter -OldStyleName XX -Description $msg.hexDumpASCII2
    New-ParamCompleter -ShortName y -Description $msg.linkType -Type Required -VariableName 'datalinktype'
    New-ParamCompleter -ShortName z -Description $msg.postrotateCommand -Type Required -VariableName 'postrotate-command'
    New-ParamCompleter -ShortName Z -Description $msg.relinquishPrivileges -Type Required -VariableName 'user'
)
