<#
 # vmstat completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    vmstat              = Report virtual memory statistics
    active              = Display active and inactive memory
    forks               = Display number of forks since boot
    slab                = Display slab info
    oneHeader           = Display only one header line
    stats               = Displays a table of various event counters and memory statistics
    disk                = Display disk statistics
    diskSum             = Display disk statistics in summary format
    partition           = Display partition statistics
    unit                = Output unit
    unit_k              = Output in 1000 bytes
    unit_K              = Output in 1024 bytes
    unit_m              = Output in 1000000 bytes
    unit_M              = Output in 1048576 bytes
    timestamp           = Append timestamp to each line
    wide                = Wide output mode
    noFirst             = Skip first report
    version             = Display version and exit
    help                = Display help and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name vmstat -Description $msg.vmstat -Parameters @(
    New-ParamCompleter -ShortName a -LongName active -Description $msg.active
    New-ParamCompleter -ShortName f -LongName forks -Description $msg.forks
    New-ParamCompleter -ShortName m -LongName slabs -Description $msg.slabs
    New-ParamCompleter -ShortName n -LongName one-header -Description $msg.oneHeader
    New-ParamCompleter -ShortName s -LongName stats -Description $msg.slab
    New-ParamCompleter -ShortName d -LongName disk -Description $msg.disk
    New-ParamCompleter -ShortName D -LongName disk-sum -Description $msg.diskSum
    New-ParamCompleter -ShortName p -LongName partition -Description $msg.partition -Type Required -VariableName 'device'
    New-ParamCompleter -ShortName S -LongName unit -Description $msg.unit -Arguments @(
        "k`t{0}" -f $msg.unit_k
        "K`t{0}" -f $msg.unit_K
        "m`t{0}" -f $msg.unit_m
        "M`t{0}" -f $msg.unit_M
    ) -VariableName 'UNIT'
    New-ParamCompleter -ShortName t -LongName timestamp -Description $msg.timestamp
    New-ParamCompleter -ShortName w -LongName wide -Description $msg.wide
    New-ParamCompleter -ShortName y -LongName no-first -Description $msg.noFirst
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
) -NoFileCompletions
