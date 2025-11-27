<#
 # ps completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    all                  = Select all processes
    all_with_tty         = Select all processes with a tty except session leaders
    deselect             = Select all processes except those that fulfill the specified conditions
    terminal             = Select all processes associated with this terminal
    all_except_session   = Select all processes except session leaders
    process_by_pid       = Select by process ID
    process_by_ppid      = Select by parent process ID
    process_by_pgid      = Select by process group ID
    process_by_sid       = Select by session ID
    process_by_tty       = Select by tty
    process_by_user      = Select by effective user ID or name
    process_by_ruser     = Select by real user ID or name
    process_by_group     = Select by effective group ID or name
    process_by_rgroup    = Select by real group ID or name
    process_by_command   = Select by command name
    format_full          = Full format listing
    format_full_extra    = Extra full format
    format_long          = Long format
    format_jobs          = Jobs format
    format_signal        = Signal format
    format_user          = User-oriented format
    format_vm            = Virtual memory format
    format_custom        = User-defined format
    with_preloaded       = Preloaded format (-o pid,<format>,state,tname,time,command)
    forest               = ASCII art process tree
    headers              = Repeat header lines
    no_headers           = Print no header line
    lines                = Set screen height
    columns              = Set screen width
    wide                 = Wide output
    cumulative           = Include some dead child process data
    threads_with_LWP     = Show threads. With LWP/NLWP
    threads_after_procs  = Show threads after processes
    threads_with_SPID    = Show threads. With SPID
    sort                 = Specify sort order
    threads              = Show threads
    help_simple          = Print a help message
    help_all             = Print all help
    help_section         = Print help for specific section
    info                 = Print debugging info
    version              = Print version and exit
    context              = Display security context
    quick_pid            = Quick mode with PID only
    cols_width           = Set output width
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ps -Description 'report a snapshot of the current processes' -Parameters @(
    # Simple process selection
    New-ParamCompleter -ShortName A -LongName all -Description $msg.all
    New-ParamCompleter -ShortName a -Description $msg.all_with_tty
    New-ParamCompleter -ShortName d -Description $msg.all_except_session
    New-ParamCompleter -ShortName e -Description $msg.all
    New-ParamCompleter -ShortName N -LongName deselect -Description $msg.deselect

    # Process selection by list
    New-ParamCompleter -ShortName C -Description $msg.process_by_command -Type List -VariableName 'cmdlist'
    New-ParamCompleter -ShortName G -LongName Group -Description $msg.process_by_rgroup -Type List -VariableName 'grplist'
    New-ParamCompleter -ShortName g -LongName group -Description $msg.process_by_group -Type List -VariableName 'grplist'
    New-ParamCompleter -ShortName p -LongName pid -Description $msg.process_by_pid -Type List -VariableName 'pidlist'
    New-ParamCompleter -LongName ppid -Description $msg.process_by_ppid -Type List -VariableName 'pidlist'
    New-ParamCompleter -LongName sid -Description $msg.process_by_sid -Type List -VariableName 'sesslist'
    New-ParamCompleter -ShortName t -LongName tty -Description $msg.process_by_tty -Type List -VariableName 'ttylist'
    New-ParamCompleter -ShortName U -LongName User -Description $msg.process_by_ruser -Type List -VariableName 'userlist'
    New-ParamCompleter -ShortName u -LongName user -Description $msg.process_by_user -Type List -VariableName 'userlist'

    # Output format control
    New-ParamCompleter -ShortName f -Description $msg.format_full
    New-ParamCompleter -ShortName j -Description $msg.format_jobs
    New-ParamCompleter -ShortName l -Description $msg.format_long
    New-ParamCompleter -ShortName s -Description $msg.format_signal
    New-ParamCompleter -ShortName u -Description $msg.format_user
    New-ParamCompleter -ShortName v -Description $msg.format_vm
    New-ParamCompleter -ShortName F -Description $msg.format_full_extra
    New-ParamCompleter -ShortName o -LongName format -Description $msg.format_custom -Type Required -VariableName 'format'
    New-ParamCompleter -ShortName O -Description $msg.with_preloaded -Type Required -VariableName 'format'

    # Output modifiers
    New-ParamCompleter -ShortName H -LongName forest -Description $msg.forest
    New-ParamCompleter -ShortName h -LongName headers -Description $msg.headers
    New-ParamCompleter -LongName no-headers -Description $msg.no_headers
    New-ParamCompleter -LongName lines -Description $msg.lines -Type Required -VariableName 'n'
    New-ParamCompleter -LongName cols,columns,width -Description $msg.columns -Type Required -VariableName 'n'
    New-ParamCompleter -ShortName w -Description $msg.wide
    New-ParamCompleter -LongName cumulative -Description $msg.cumulative

    # Thread display
    New-ParamCompleter -ShortName L -Description $msg.threads_with_LWP
    New-ParamCompleter -ShortName m -Description $msg.threads_after_procs
    New-ParamCompleter -ShortName T -Description $msg.threads_with_SPID

    # Miscellaneous options
    New-ParamCompleter -LongName sort -Description $msg.sort -Type Required -VariableName '[+|-]key'
    New-ParamCompleter -LongName context -Description $msg.context
    New-ParamCompleter -ShortName q -LongName quick-pid -Description $msg.quick_pid

    # Help options
    New-ParamCompleter -LongName help -Description $msg.help_simple -Arguments "simple","list","output","threads","misc","all"
    New-ParamCompleter -LongName info -Description $msg.info
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
) -NoFileCompletions
