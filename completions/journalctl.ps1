<#
 # journalctl completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    journalctl                  = Query the systemd journal
    no_full                     = Ellipsize fields
    all                         = Show all fields in full
    lines                       = Show the most recent journal events
    no_tail                     = Show all lines, even in follow mode
    reverse                     = Reverse output so newest entries are first
    output                      = Change journal output mode
    output_short                = Default syslog-style output
    output_short_full           = Syslog-style with all fields
    output_short_iso            = ISO 8601 wallclock timestamps
    output_short_iso_precise    = ISO 8601 with microsecond precision
    output_short_precise        = Timestamps with microsecond precision
    output_short_monotonic      = Monotonic timestamps
    output_short_unix           = Unix time (seconds since epoch)
    output_verbose              = All journal fields
    output_export               = Binary export format
    output_json                 = JSON with one entry per line
    output_json_pretty          = JSON formatted for humans
    output_json_sse             = JSON wrapped for server-sent events
    output_json_seq             = JSON with record separator
    output_cat                  = Only message field
    output_with_unit            = Show unit names where available
    utc                         = Express time in UTC
    no_hostname                 = Don't show hostname field
    output_fields               = Select fields to output
    catalog                     = Show explanatory message texts from catalog
    merge                       = Show entries from all available journals
    boot                        = Show messages from a specific boot
    list_boots                  = Show boot IDs and timestamps
    this_boot                   = Show only messages from current boot
    dmesg                       = Show kernel messages
    system                      = Show messages from system services
    user                        = Show messages from user services
    machine                     = Show messages from a local container
    directory                   = Show journal files from directory
    file                        = Show journal from file
    root                        = Operate on files below root directory
    namespace                   = Show journal data from namespace
    image                       = Operate on files in filesystem image
    image_policy                = Specify disk image dissection policy
    header                      = Show internal header information
    disk_usage                  = Show disk space used by journal files
    vacuum_size                 = Reduce disk usage below specified size
    vacuum_files                = Leave only specified number of journal files
    vacuum_time                 = Remove journal files older than specified time
    list_catalog                = Show all message IDs in catalog
    dump_catalog                = Show catalog entries
    update_catalog              = Update the message catalog database
    setup_keys                  = Generate Forward Secure Sealing key pair
    interval                    = Change interval for sealing keys
    verify                      = Check journal file for internal consistency
    verify_key                  = Specify FSS verification key
    sync                        = Write all unwritten journal messages to disk
    relinquish_var              = Stop logging to disk
    smart_relinquish_var        = Similar to relinquish-var but NOP if logging
    flush                       = Flush all journal data from volatile storage
    rotate                      = Request immediate rotation of journal files
    priority                    = Filter output by message priority
    facility                    = Filter output by syslog facility
    grep                        = Filter output to entries matching pattern
    case_sensitive              = Make pattern matching case sensitive
    identifier                  = Show messages for the specified syslog identifier
    unit                        = Show messages for specified systemd unit
    user_unit                   = Show messages for specified user unit
    since                       = Start showing entries on or newer than date
    until                       = Stop showing entries on or older than date
    cursor                      = Start showing entries from specified cursor
    cursor_file                 = Store or read cursor in/from file
    after_cursor                = Start showing entries after specified cursor
    show_cursor                 = Print cursor after last entry
    follow                      = Show new journal entries as they appear
    quiet                       = Do not show info messages and privilege warning
    pager_end                   = Jump to end within the pager
    force                       = Override FSS key pair check
    no_pager                    = Do not pipe output into a pager
    no_legend                   = Do not print legend
    help                        = Show this help text
    version                     = Show package version
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$unitCompleter = {
    systemctl list-units --all --no-legend --no-pager --plain | 
        ForEach-Object {
            if ($_ -match '^([^\s]+)\s+') {
                $unit = $Matches[1]
                if ($unit -like "$wordToComplete*") {
                    $unit
                }
            }
        }
}

$facilityCompleter = {
    $word = $_;
    "kern","user","mail","daemon","auth","syslog","lpr","news","uucp","cron","authpriv","ftp",
    "local0","local1","local2","local3","local4","local5","local6","local7" |
        Where-Object { $_ -like "$word*" }
}

Register-NativeCompleter -Name journalctl -Description $msg.journalctl -Parameters @(
    # Output control
    New-ParamCompleter -LongName no-full -Description $msg.no_full
    New-ParamCompleter -ShortName a -LongName all -Description $msg.all
    New-ParamCompleter -ShortName n -LongName lines -Description $msg.lines -Type Required -VariableName 'N'
    New-ParamCompleter -LongName no-tail -Description $msg.no_tail
    New-ParamCompleter -ShortName r -LongName reverse -Description $msg.reverse
    New-ParamCompleter -ShortName o -LongName output -Description $msg.output -Arguments @(
        "short`t{0}" -f $msg.output_short
        "short-full`t{0}" -f $msg.output_short_full
        "short-iso`t{0}" -f $msg.output_short_iso
        "short-iso-precise`t{0}" -f $msg.output_short_iso_precise
        "short-precise`t{0}" -f $msg.output_short_precise
        "short-monotonic`t{0}" -f $msg.output_short_monotonic
        "short-unix`t{0}" -f $msg.output_short_unix
        "verbose`t{0}" -f $msg.output_verbose
        "export`t{0}" -f $msg.output_export
        "json`t{0}" -f $msg.output_json
        "json-pretty`t{0}" -f $msg.output_json_pretty
        "json-sse`t{0}" -f $msg.output_json_sse
        "json-seq`t{0}" -f $msg.output_json_seq
        "cat`t{0}" -f $msg.output_cat
        "with-unit`t{0}" -f $msg.output_with_unit
    ) -VariableName 'STRING'
    New-ParamCompleter -LongName utc -Description $msg.utc
    New-ParamCompleter -LongName no-hostname -Description $msg.no_hostname
    New-ParamCompleter -LongName output-fields -Description $msg.output_fields -Type Required -VariableName 'LIST'
    New-ParamCompleter -ShortName x -LongName catalog -Description $msg.catalog
    
    # Source selection
    New-ParamCompleter -ShortName m -LongName merge -Description $msg.merge
    New-ParamCompleter -ShortName b -LongName boot -Description $msg.boot -Type FlagOrValue -VariableName 'ID'
    New-ParamCompleter -LongName list-boots -Description $msg.list_boots
    New-ParamCompleter -LongName this-boot -Description $msg.this_boot
    New-ParamCompleter -ShortName k -LongName dmesg -Description $msg.dmesg
    New-ParamCompleter -LongName system -Description $msg.system
    New-ParamCompleter -LongName user -Description $msg.user
    New-ParamCompleter -ShortName M -LongName machine -Description $msg.machine -Type Required -VariableName 'CONTAINER'
    New-ParamCompleter -ShortName D -LongName directory -Description $msg.directory -Type Directory -VariableName 'PATH'
    New-ParamCompleter -LongName file -Description $msg.file -Type File -VariableName 'PATH'
    New-ParamCompleter -LongName root -Description $msg.root -Type Directory -VariableName 'ROOT'
    New-ParamCompleter -LongName namespace -Description $msg.namespace -Type Required -VariableName 'NAMESPACE'
    New-ParamCompleter -LongName image -Description $msg.image -Type File -VariableName 'IMAGE'
    New-ParamCompleter -LongName image-policy -Description $msg.image_policy -Type Required -VariableName 'POLICY'
    
    # Journal management
    New-ParamCompleter -LongName header -Description $msg.header
    New-ParamCompleter -LongName disk-usage -Description $msg.disk_usage
    New-ParamCompleter -LongName vacuum-size -Description $msg.vacuum_size -Type Required -VariableName 'BYTES'
    New-ParamCompleter -LongName vacuum-files -Description $msg.vacuum_files -Type Required -VariableName 'INT'
    New-ParamCompleter -LongName vacuum-time -Description $msg.vacuum_time -Type Required -VariableName 'TIME'
    New-ParamCompleter -LongName list-catalog -Description $msg.list_catalog
    New-ParamCompleter -LongName dump-catalog -Description $msg.dump_catalog
    New-ParamCompleter -LongName update-catalog -Description $msg.update_catalog
    New-ParamCompleter -LongName setup-keys -Description $msg.setup_keys
    New-ParamCompleter -LongName interval -Description $msg.interval -Type Required -VariableName 'TIME'
    New-ParamCompleter -LongName verify -Description $msg.verify
    New-ParamCompleter -LongName verify-key -Description $msg.verify_key -Type Required -VariableName 'KEY'
    New-ParamCompleter -LongName sync -Description $msg.sync
    New-ParamCompleter -LongName relinquish-var -Description $msg.relinquish_var
    New-ParamCompleter -LongName smart-relinquish-var -Description $msg.smart_relinquish_var
    New-ParamCompleter -LongName flush -Description $msg.flush
    New-ParamCompleter -LongName rotate -Description $msg.rotate
    
    # Filtering
    New-ParamCompleter -ShortName p -LongName priority -Description $msg.priority -Type Required -VariableName 'RANGE'
    New-ParamCompleter -LongName facility -Description $msg.facility -Type Required -VariableName 'FACILITY' -ArgumentCompleter $facilityCompleter
    New-ParamCompleter -ShortName g -LongName grep -Description $msg.grep -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -LongName case-sensitive -Description $msg.case_sensitive -Type FlagOrValue -VariableName 'BOOLEAN'
    New-ParamCompleter -ShortName t -LongName identifier -Description $msg.identifier -Type Required -VariableName 'STRING'
    New-ParamCompleter -ShortName u -LongName unit -Description $msg.unit -Type Required -VariableName 'UNIT' -ArgumentCompleter $unitCompleter
    New-ParamCompleter -LongName user-unit -Description $msg.user_unit -Type Required -VariableName 'UNIT' -ArgumentCompleter $unitCompleter
    New-ParamCompleter -ShortName S -LongName since -Description $msg.since -Type Required -VariableName 'DATE'
    New-ParamCompleter -ShortName U -LongName until -Description $msg.until -Type Required -VariableName 'DATE'
    New-ParamCompleter -ShortName c -LongName cursor -Description $msg.cursor -Type Required -VariableName 'CURSOR'
    New-ParamCompleter -LongName cursor-file -Description $msg.cursor_file -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName after-cursor -Description $msg.after_cursor -Type Required -VariableName 'CURSOR'
    New-ParamCompleter -LongName show-cursor -Description $msg.show_cursor
    
    # Behavior
    New-ParamCompleter -ShortName f -LongName follow -Description $msg.follow
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -ShortName e -LongName pager-end -Description $msg.pager_end
    New-ParamCompleter -LongName force -Description $msg.force
    New-ParamCompleter -LongName no-pager -Description $msg.no_pager
    New-ParamCompleter -LongName no-legend -Description $msg.no_legend
    
    # Info
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -LongName version -Description $msg.version
) -NoFileCompletions -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    # Match expressions like FIELD=VALUE
    if ($_ -match '^([A-Z_]+)=') {
        # Field name provided, could suggest values based on common fields
        $null
    } else {
        # Suggest common field names
        "MESSAGE=","PRIORITY=","SYSLOG_IDENTIFIER=","_SYSTEMD_UNIT=","_PID=","_UID=","_GID=","_COMM=","_EXE=","_CMDLINE=" |
            Where-Object { $_ -like "$wordToComplete*" }
    }
}
