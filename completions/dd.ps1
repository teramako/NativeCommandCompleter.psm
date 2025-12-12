<#
 # dd completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    dd                   = convert and copy a file
    help                 = display this help and exit
    version              = output version information and exit
    if                   = read from FILE instead of stdin
    of                   = write to FILE instead of stdout
    ibs                  = read up to BYTES bytes at a time
    obs                  = write BYTES bytes at a time
    bs                   = read and write BYTES bytes at a time
    cbs                  = convert BYTES bytes at a time
    skip                 = skip N ibs-sized blocks at start of input
    seek                 = skip N obs-sized blocks at start of output
    count                = copy only N input blocks
    conv                 = convert the file as per the comma separated symbol list
    conv_ascii           = from EBCDIC to ASCII
    conv_ebcdic          = from ASCII to EBCDIC
    conv_ibm             = from ASCII to alternate EBCDIC
    conv_block           = pad newline-terminated records with spaces to cbs-size
    conv_unblock         = replace trailing spaces in cbs-size records with newline
    conv_lcase           = change upper case to lower case
    conv_ucase           = change lower case to upper case
    conv_sparse          = try to seek rather than write the output for NUL input blocks
    conv_swab            = swap every pair of input bytes
    conv_sync            = pad every input block with NULs to ibs-size
    conv_excl            = fail if the output file already exists
    conv_nocreat         = do not create the output file
    conv_notrunc         = do not truncate the output file
    conv_noerror         = continue after read errors
    conv_fdatasync       = physically write output file data before finishing
    conv_fsync           = likewise, but also write metadata
    iflag                = read as per the comma separated symbol list
    oflag                = write as per the comma separated symbol list
    flag_append          = append mode (makes sense only for output)
    flag_direct          = use direct I/O for data
    flag_directory       = fail unless a directory
    flag_dsync           = use synchronized I/O for data
    flag_sync            = likewise, but also for metadata
    flag_fullblock       = accumulate full blocks of input
    flag_nonblock        = use non-blocking I/O
    flag_noatime         = do not update access time
    flag_nocache         = Request to drop cache
    flag_noctty          = do not assign controlling terminal from file
    flag_nofollow        = do not follow symlinks
    flag_count_bytes     = treat 'count=N' as a byte count
    flag_skip_bytes      = treat 'skip=N' as a byte count
    flag_seek_bytes      = treat 'seek=N' as a byte count
    status               = The LEVEL of information to print to stderr
    status_none          = suppress everything but error messages
    status_noxfer        = suppress the final transfer statistics
    status_progress      = show periodic transfer statistics
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$kvStyle = New-ParamStyle -ValueSeparator '=' -ValueStyle AllowAdjacent

Register-NativeCompleter -Name dd -Description $msg.dd -Metadata @{ msg = $msg } -Parameters @(
    New-ParamCompleter -LongName help -Description $msg.help
    New-ParamCompleter -LongName version -Description $msg.version
    New-ParamCompleter -LongName bs -Description $msg.bs -Style $kvStyle -Type Required -VariableName 'BYTES'
    New-ParamCompleter -LongName cbs -Description $msg.cbs -Style $kvStyle -Type Required -VariableName 'BYTES'
    New-ParamCompleter -LongName conv -Description $msg.conv -Style $kvStyle -Type List -VariableName 'CONVS' -Arguments @(
        "ascii`t{0}" -f $msg.conv_ascii
        "ebcdic`t{0}" -f $msg.conv_ebcdic
        "ibm`t{0}" -f $msg.conv_ibm
        "block`t{0}" -f $msg.conv_block
        "unblock`t{0}" -f $msg.conv_unblock
        "lcase`t{0}" -f $msg.conv_lcase
        "ucase`t{0}" -f $msg.conv_ucase
        "sparse`t{0}" -f $msg.conv_sparse
        "swab`t{0}" -f $msg.conv_swab
        "sync`t{0}" -f $msg.conv_sync
        "excl`t{0}" -f $msg.conv_excl
        "nocreat`t{0}" -f $msg.conv_nocreat
        "notrunc`t{0}" -f $msg.conv_notrunc
        "noerror`t{0}" -f $msg.conv_noerror
        "fdatasync`t{0}" -f $msg.conv_fdatasync
        "fsync`t{0}" -f $msg.conv_fsync
    )
    New-ParamCompleter -LongName count -Description $msg.count -Style $kvStyle -Type Required -VariableName 'N'
    New-ParamCompleter -LongName ibs -Description $msg.ibs -Style $kvStyle -Type Required -VariableName 'BYTES'
    New-ParamCompleter -LongName if -Description $msg.if -Style $kvStyle -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName iflag -Description $msg.iflag -Style $kvStyle -Type List -VariableName 'FLAGS' -Arguments @(
        "append`t{0}" -f $msg.flag_append
        "direct`t{0}" -f $msg.flag_direct
        "directory`t{0}" -f $msg.flag_directory
        "dsync`t{0}" -f $msg.flag_dsync
        "sync`t{0}" -f $msg.flag_sync
        "fullblock`t{0}" -f $msg.flag_fullblock
        "nonblock`t{0}" -f $msg.flag_nonblock
        "noatime`t{0}" -f $msg.flag_noatime
        "nocache`t{0}" -f $msg.flag_nocache
        "noctty`t{0}" -f $msg.flag_noctty
        "nofollow`t{0}" -f $msg.flag_nofollow
        "count_bytes`t{0}" -f $msg.flag_count_bytes
        "skip_bytes`t{0}" -f $msg.flag_skip_bytes
    )
    New-ParamCompleter -LongName obs -Description $msg.obs -Style $kvStyle -Type Required -VariableName 'BYTES'
    New-ParamCompleter -LongName of -Description $msg.of -Style $kvStyle -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName oflag -Description $msg.oflag -Style $kvStyle -Type List -VariableName 'FLAGS' -Arguments @(
        "append`t{0}" -f $msg.flag_append
        "direct`t{0}" -f $msg.flag_direct
        "directory`t{0}" -f $msg.flag_directory
        "dsync`t{0}" -f $msg.flag_dsync
        "sync`t{0}" -f $msg.flag_sync
        "nonblock`t{0}" -f $msg.flag_nonblock
        "noatime`t{0}" -f $msg.flag_noatime
        "nocache`t{0}" -f $msg.flag_nocache
        "noctty`t{0}" -f $msg.flag_noctty
        "nofollow`t{0}" -f $msg.flag_nofollow
        "seek_bytes`t{0}" -f $msg.flag_seek_bytes
    )
    New-ParamCompleter -LongName seek -Description $msg.seek -Style $kvStyle -Type Required -VariableName 'N'
    New-ParamCompleter -LongName skip -Description $msg.skip -Style $kvStyle -Type Required -VariableName 'N'
    New-ParamCompleter -LongName status -Description $msg.status -Style $kvStyle -Type Required -VariableName 'LEVEL' -Arguments @(
        "none`t{0}" -f $msg.status_none
        "noxfer`t{0}" -f $msg.status_noxfer
        "progress`t{0}" -f $msg.status_progress
    )
) -NoFileCompletions
