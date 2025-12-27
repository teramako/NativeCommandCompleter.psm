<#
 # xargs completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    xargs                   = build and execute command lines from standard input
    null                    = Input items are terminated by null character
    delimiter               = Input items are terminated by specified character
    eof                     = Set logical EOF string
    replace                 = Replace occurrences of replace-str in initial-arguments
    max_args                = Use at most max-args arguments per command line
    max_chars               = Use at most max-chars characters per command line
    max_lines               = Use at most max-lines nonblank input lines per command line
    max_procs               = Run up to max-procs processes at a time
    interactive             = Prompt before executing commands
    no_run_if_empty         = If there is no input, do not run the command
    verbose                 = Print the command line on stderr before executing
    exit                    = Exit if size is exceeded
    help                    = Display help and exit
    version                 = Display version and exit
    arg_file                = Read arguments from file instead of stdin
    process_slot_var        = Set environment variable to unique value in child processes
    show_limits             = Show limits on command-line length
    open_tty                = Reopen stdin as /dev/tty in child process before executing
    delimiter_print0        = Items are separated by null character
    max_replace_args        = Maximum number of arguments to replace
    bsd_trace               = Echo each command
    bsd_open_stdin          = Open /dev/tty as stdin in child
    bsd_replace_args        = Maximum replacements
    bsd_insert_pos          = Insert mode for replacements
    bsd_size                = Maximum characters per command line
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU xargs
xargs --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU xargs
{
    Register-NativeCompleter -Name xargs -Description $msg.xargs -Parameters @(
        New-ParamCompleter -ShortName '0' -LongName null -Description $msg.null
        New-ParamCompleter -ShortName a -LongName arg-file -Description $msg.arg_file -Type File -VariableName 'file'
        New-ParamCompleter -ShortName d -LongName delimiter -Description $msg.delimiter -Type Required -VariableName 'delim'
        New-ParamCompleter -ShortName E -Description $msg.eof -Type Required -VariableName 'eof-str'
        New-ParamCompleter -ShortName e -LongName eof -Description $msg.eof -Type FlagOrValue -VariableName 'eof-str'
        New-ParamCompleter -ShortName I -Description $msg.replace -Type Required -VariableName 'replace-str'
        New-ParamCompleter -ShortName i -LongName replace -Description $msg.replace -Type FlagOrValue -VariableName 'replace-str'
        New-ParamCompleter -ShortName L -Description $msg.max_lines -Type Required -VariableName 'max-lines'
        New-ParamCompleter -ShortName l -LongName max-lines -Description $msg.max_lines -Type FlagOrValue -VariableName 'max-lines'
        New-ParamCompleter -ShortName n -LongName max-args -Description $msg.max_args -Type Required -VariableName 'max-args'
        New-ParamCompleter -ShortName P -LongName max-procs -Description $msg.max_procs -Type Required -VariableName 'max-procs'
        New-ParamCompleter -ShortName p -LongName interactive -Description $msg.interactive
        New-ParamCompleter -LongName process-slot-var -Description $msg.process_slot_var -Type Required -VariableName 'name'
        New-ParamCompleter -ShortName r -LongName no-run-if-empty -Description $msg.no_run_if_empty
        New-ParamCompleter -ShortName s -LongName max-chars -Description $msg.max_chars -Type Required -VariableName 'max-chars'
        New-ParamCompleter -LongName show-limits -Description $msg.show_limits
        New-ParamCompleter -ShortName t -LongName verbose -Description $msg.verbose
        New-ParamCompleter -ShortName x -LongName exit -Description $msg.exit
        New-ParamCompleter -LongName help -Description $msg.help
        New-ParamCompleter -LongName version -Description $msg.version
    ) -DelegateArgumentIndex 0
}
else # BSD xargs
{
    Register-NativeCompleter -Name xargs -Description $msg.xargs -Parameters @(
        New-ParamCompleter -ShortName '0' -Description $msg.delimiter_print0
        New-ParamCompleter -ShortName E -Description $msg.eof -Type Required -VariableName 'eofstr'
        New-ParamCompleter -ShortName I -Description $msg.replace -Type Required -VariableName 'replstr'
        New-ParamCompleter -ShortName J -Description $msg.bsd_insert_pos -Type Required -VariableName 'replstr'
        New-ParamCompleter -ShortName L -Description $msg.max_lines -Type Required -VariableName 'number'
        New-ParamCompleter -ShortName n -Description $msg.max_args -Type Required -VariableName 'number'
        New-ParamCompleter -ShortName o -Description $msg.bsd_open_stdin
        New-ParamCompleter -ShortName P -Description $msg.max_procs -Type Required -VariableName 'maxprocs'
        New-ParamCompleter -ShortName p -Description $msg.interactive
        New-ParamCompleter -ShortName R -Description $msg.bsd_replace_args -Type Required -VariableName 'replacements'
        New-ParamCompleter -ShortName r -Description $msg.no_run_if_empty
        New-ParamCompleter -ShortName s -Description $msg.bsd_size -Type Required -VariableName 'size'
        New-ParamCompleter -ShortName t -Description $msg.bsd_trace
        New-ParamCompleter -ShortName x -Description $msg.exit
    ) -DelegateArgumentIndex 0
}
