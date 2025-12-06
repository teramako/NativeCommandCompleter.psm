<#
 # systemctl completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    systemctl                   = Control the systemd system and service manager
    list_units                  = List units that systemd currently has in memory
    list_sockets                = List socket units currently in memory
    list_timers                 = List timer units currently in memory
    list_unit_files             = List unit files installed on the system
    list_jobs                   = List jobs that are in progress
    list_machines               = List local containers and VMs
    list_dependencies           = Show unit dependency tree
    start                       = Start (activate) one or more units
    stop                        = Stop (deactivate) one or more units
    reload                      = Reload one or more units
    restart                     = Restart one or more units
    try_restart                 = Restart one or more units if active
    reload_or_restart           = Reload one or more units if possible, otherwise restart
    try_reload_or_restart       = Reload one or more units if possible and active, otherwise restart
    isolate                     = Start one unit and stop all others
    kill                        = Send signal to processes of a unit
    clean                       = Remove configuration, state, cache, logs or runtime data of units
    freeze                      = Freeze execution of unit processes
    thaw                        = Resume execution of a frozen unit
    is_active                   = Check whether units are active
    is_failed                   = Check whether units are failed
    status                      = Show runtime status of one or more units
    show                        = Show properties of one or more units/jobs/manager
    cat                         = Show files provided by units
    help                        = Show man page for one or more units
    reset_failed                = Reset failed state for all, one, or more units
    enable                      = Enable one or more unit files
    disable                     = Disable one or more unit files
    reenable                    = Reenable one or more unit files
    preset                      = Enable/disable one or more unit files based on preset configuration
    preset_all                  = Enable/disable all unit files based on preset configuration
    is_enabled                  = Check whether unit files are enabled
    mask                        = Mask one or more units
    unmask                      = Unmask one or more units
    link                        = Link a unit file into the search path
    revert                      = Revert one or more unit files to vendor version
    add_wants                   = Add Wants= dependency for target
    add_requires                = Add Requires= dependency for target
    edit                        = Edit one or more unit files
    get_default                 = Get the default target
    set_default                 = Set the default target
    daemon_reload               = Reload systemd manager configuration
    daemon_reexec               = Reexecute systemd manager
    show_environment            = Show environment variables
    set_environment             = Set one or more environment variables
    unset_environment           = Unset one or more environment variables
    import_environment          = Import environment variables
    service_watchdogs           = Enable/disable service watchdogs
    log_level                   = Get/set manager log level
    log_target                  = Get/set manager log target
    is_system_running           = Check if system is running
    default                     = Enter default mode
    rescue                      = Enter rescue mode
    emergency                   = Enter emergency mode
    halt                        = Shut down and halt the system
    poweroff                    = Shut down and power off the system
    reboot                      = Shut down and reboot the system
    kexec                       = Shut down and reboot via kexec
    exit                        = Ask systemd manager to quit
    switch_root                 = Change root directory
    suspend                     = Suspend the system
    hibernate                   = Hibernate the system
    hybrid_sleep                = Hibernate and suspend the system
    suspend_then_hibernate      = Suspend the system, wake up after period and hibernate
    cancel                      = Cancel all, one, or more jobs
    
    type                        = List units of specified type
    state                       = List units in specified state
    property                    = Show only specified properties
    all                         = Show all properties/units/jobs
    recursive                   = Show dependencies recursively
    reverse                     = Show reverse dependencies
    after                       = Show units ordered before specified unit
    before                      = Show units ordered after specified unit
    jobs                        = Additionally show jobs after status
    failed                      = Show only failed units
    full                        = Do not ellipsize unit names and truncate output
    value                       = Show only values when showing properties
    show_types                  = Show socket types when listing sockets
    job_mode                    = Specify how to deal with queued jobs
    fail                        = If operation on one unit fails, fail entire operation
    ignore_dependencies         = Ignore dependencies
    ignore_inhibitors           = Ignore inhibitor locks
    skip_redirect               = Do not honour symlinks
    kill_mode                   = Send signal to which process(es)
    kill_value                  = Which value to set for sd_notify EXTEND_TIMEOUT_USEC
    signal                      = Which signal to send
    what                        = Select what type of per-unit resources to remove
    now                         = Start/stop/isolate unit after enabling/disabling/masking it
    dry_run                     = Only print what would be done
    quiet                       = Suppress output
    force                       = Override safety checks
    message                     = Reason for halt/reboot/etc
    no_wall                     = Do not send wall message before halt/reboot/etc
    no_reload                   = Do not reload daemon after enable/disable
    no_legend                   = Do not print column headers
    no_pager                    = Do not pipe output into a pager
    no_ask_password             = Do not prompt for passwords
    system                      = Connect to system manager
    user                        = Connect to user service manager
    global                      = Enable/disable/mask unit files globally
    runtime                     = Enable/disable/mask unit files temporarily
    lines                       = Show number of journal entries
    output                      = Change journal output mode
    firmware_setup              = Reboot into firmware setup
    boot_loader_menu            = Reboot into boot loader menu
    boot_loader_entry           = Reboot into specific boot loader entry
    plain                       = When used with list-dependencies, list as flat list
    timestamp                   = Change format of printed timestamps
    read_only                   = Create read-only bind mount
    mkdir                       = Create directory before bind mounting
    marked                      = Operate only on marked units
    when                        = When to perform action
    preset_mode                 = Apply only enable or only disable presets
    root                        = Operate on files below specified directory
    image                       = Operate on files in specified image
    image_policy                = Specify image dissection policy
    host                        = Execute operation on remote host
    machine                     = Execute operation on local container
    wait                        = Wait until operation finished
    version                     = Show package version
    help_cmd                    = Show help
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$unitCompleter = {
    systemctl list-units --all --no-legend --no-pager --plain | 
        ForEach-Object {
            if ($_ -match '^(\S+)\s+\S+\s+\S+\s+\S+\s+(.*)$') {
                $unit = $Matches[1]
                $desc = $Matches[2]
                if ($unit -like "$wordToComplete*") {
                    "{0}`t{1}" -f $unit, $desc
                }
            }
        }
}

$unitFileCompleter = {
    systemctl list-unit-files --no-legend --no-pager --plain |
        ForEach-Object {
            if ($_ -match '^(\S+)\s+(.*)$') {
                $unit = $Matches[1]
                $state = $Matches[2]
                if ($unit -like "$wordToComplete*") {
                    "{0}`t{1}" -f $unit, $state
                }
            }
        }
}

$typeValues = "service", "socket", "target", "device", "mount", "automount", "swap", "timer", "path", "slice", "scope"
$stateValues = "loaded", "not-found", "bad-setting", "error", "merged", "masked", "active", "inactive", "failed", "activating", "deactivating"
$outputModeValues = "short","short-full","short-iso","short-iso-precise","short-precise","short-monotonic","short-unix","verbose","export","json","json-pretty","json-sse","json-seq","cat","with-unit"
$jobModeValues = "fail","replace","replace-irreversibly","isolate","ignore-dependencies","ignore-requirements"

Register-NativeCompleter -Name systemctl -Description $msg.systemctl -SubCommands @(
    # Unit commands
    New-CommandCompleter -Name list-units -Description $msg.list_units -NoFileCompletions
    New-CommandCompleter -Name list-sockets -Description $msg.list_sockets -NoFileCompletions
    New-CommandCompleter -Name list-timers -Description $msg.list_timers -NoFileCompletions
    New-CommandCompleter -Name list-unit-files -Description $msg.list_unit_files -NoFileCompletions
    New-CommandCompleter -Name list-jobs -Description $msg.list_jobs -NoFileCompletions
    New-CommandCompleter -Name list-machines -Description $msg.list_machines -NoFileCompletions
    New-CommandCompleter -Name list-dependencies -Description $msg.list_dependencies -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name start -Description $msg.start -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name stop -Description $msg.stop -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name reload -Description $msg.reload -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name restart -Description $msg.restart -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name try-restart -Description $msg.try_restart -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name reload-or-restart -Description $msg.reload_or_restart -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name try-reload-or-restart -Description $msg.try_reload_or_restart -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name isolate -Description $msg.isolate -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name kill -Description $msg.kill -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name clean -Description $msg.clean -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name freeze -Description $msg.freeze -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name thaw -Description $msg.thaw -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name is-active -Description $msg.is_active -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name is-failed -Description $msg.is_failed -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name status -Description $msg.status -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name show -Description $msg.show -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name cat -Description $msg.cat -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name help -Description $msg.help -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name reset-failed -Description $msg.reset_failed -ArgumentCompleter $unitCompleter
    
    # Unit file commands
    New-CommandCompleter -Name enable -Description $msg.enable -ArgumentCompleter $unitFileCompleter
    New-CommandCompleter -Name disable -Description $msg.disable -ArgumentCompleter $unitFileCompleter
    New-CommandCompleter -Name reenable -Description $msg.reenable -ArgumentCompleter $unitFileCompleter
    New-CommandCompleter -Name preset -Description $msg.preset -ArgumentCompleter $unitFileCompleter
    New-CommandCompleter -Name preset-all -Description $msg.preset_all -NoFileCompletions
    New-CommandCompleter -Name is-enabled -Description $msg.is_enabled -ArgumentCompleter $unitFileCompleter
    New-CommandCompleter -Name mask -Description $msg.mask -ArgumentCompleter $unitFileCompleter
    New-CommandCompleter -Name unmask -Description $msg.unmask -ArgumentCompleter $unitFileCompleter
    New-CommandCompleter -Name link -Description $msg.link
    New-CommandCompleter -Name revert -Description $msg.revert -ArgumentCompleter $unitFileCompleter
    New-CommandCompleter -Name add-wants -Description $msg.add_wants -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name add-requires -Description $msg.add_requires -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name edit -Description $msg.edit -ArgumentCompleter $unitCompleter
    New-CommandCompleter -Name get-default -Description $msg.get_default -NoFileCompletions
    New-CommandCompleter -Name set-default -Description $msg.set_default -ArgumentCompleter $unitCompleter
    
    # Manager commands
    New-CommandCompleter -Name daemon-reload -Description $msg.daemon_reload -NoFileCompletions
    New-CommandCompleter -Name daemon-reexec -Description $msg.daemon_reexec -NoFileCompletions
    New-CommandCompleter -Name show-environment -Description $msg.show_environment -NoFileCompletions
    New-CommandCompleter -Name set-environment -Description $msg.set_environment -NoFileCompletions
    New-CommandCompleter -Name unset-environment -Description $msg.unset_environment -NoFileCompletions
    New-CommandCompleter -Name import-environment -Description $msg.import_environment -NoFileCompletions
    New-CommandCompleter -Name service-watchdogs -Description $msg.service_watchdogs -NoFileCompletions
    New-CommandCompleter -Name log-level -Description $msg.log_level -NoFileCompletions
    New-CommandCompleter -Name log-target -Description $msg.log_target -NoFileCompletions
    New-CommandCompleter -Name is-system-running -Description $msg.is_system_running -NoFileCompletions
    
    # System commands
    New-CommandCompleter -Name default -Description $msg.default -NoFileCompletions
    New-CommandCompleter -Name rescue -Description $msg.rescue -NoFileCompletions
    New-CommandCompleter -Name emergency -Description $msg.emergency -NoFileCompletions
    New-CommandCompleter -Name halt -Description $msg.halt -NoFileCompletions
    New-CommandCompleter -Name poweroff -Description $msg.poweroff -NoFileCompletions
    New-CommandCompleter -Name reboot -Description $msg.reboot -NoFileCompletions
    New-CommandCompleter -Name kexec -Description $msg.kexec -NoFileCompletions
    New-CommandCompleter -Name exit -Description $msg.exit -NoFileCompletions
    New-CommandCompleter -Name switch-root -Description $msg.switch_root
    New-CommandCompleter -Name suspend -Description $msg.suspend -NoFileCompletions
    New-CommandCompleter -Name hibernate -Description $msg.hibernate -NoFileCompletions
    New-CommandCompleter -Name hybrid-sleep -Description $msg.hybrid_sleep -NoFileCompletions
    New-CommandCompleter -Name suspend-then-hibernate -Description $msg.suspend_then_hibernate -NoFileCompletions
    New-CommandCompleter -Name cancel -Description $msg.cancel -NoFileCompletions
) -Parameters @(
    New-ParamCompleter -ShortName t -LongName type -Description $msg.type -Type List -VariableName 'TYPE' -Arguments $typeValues
    New-ParamCompleter -LongName state -Description $msg.state -Type List -VariableName 'STATE' -Arguments $stateValues
    New-ParamCompleter -ShortName p -LongName property -Description $msg.property -Type List -VariableName 'NAME'
    New-ParamCompleter -ShortName a -LongName all -Description $msg.all
    New-ParamCompleter -ShortName r -LongName recursive -Description $msg.recursive
    New-ParamCompleter -LongName reverse -Description $msg.reverse
    New-ParamCompleter -LongName after -Description $msg.after
    New-ParamCompleter -LongName before -Description $msg.before
    New-ParamCompleter -LongName jobs -Description $msg.jobs
    New-ParamCompleter -LongName failed -Description $msg.failed
    New-ParamCompleter -ShortName l -LongName full -Description $msg.full
    New-ParamCompleter -LongName value -Description $msg.value
    New-ParamCompleter -LongName show-types -Description $msg.show_types
    New-ParamCompleter -LongName job-mode -Description $msg.job_mode -Type Required -Arguments $jobModeValues -VariableName 'MODE'
    New-ParamCompleter -LongName fail -Description $msg.fail
    New-ParamCompleter -LongName ignore-dependencies -Description $msg.ignore_dependencies
    New-ParamCompleter -ShortName i -LongName ignore-inhibitors -Description $msg.ignore_inhibitors
    New-ParamCompleter -LongName skip-redirect -Description $msg.skip_redirect
    New-ParamCompleter -LongName kill-mode -Description $msg.kill_mode -Type Required -Arguments "control-group","process","mixed","none" -VariableName 'MODE'
    New-ParamCompleter -LongName kill-value -Description $msg.kill_value -Type Required -VariableName 'VALUE'
    New-ParamCompleter -ShortName s -LongName signal -Description $msg.signal -Type Required -VariableName 'SIGNAL'
    New-ParamCompleter -LongName what -Description $msg.what -Type List -Arguments "configuration","state","cache","logs","runtime","fdstore","all" -VariableName 'RESOURCES'
    New-ParamCompleter -LongName now -Description $msg.now
    New-ParamCompleter -LongName dry-run -Description $msg.dry_run
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -LongName message -Description $msg.message -Type Required -VariableName 'MESSAGE'
    New-ParamCompleter -LongName no-wall -Description $msg.no_wall
    New-ParamCompleter -LongName no-reload -Description $msg.no_reload
    New-ParamCompleter -LongName no-legend -Description $msg.no_legend
    New-ParamCompleter -LongName no-pager -Description $msg.no_pager
    New-ParamCompleter -LongName no-ask-password -Description $msg.no_ask_password
    New-ParamCompleter -LongName system -Description $msg.system
    New-ParamCompleter -LongName user -Description $msg.user
    New-ParamCompleter -LongName global -Description $msg.global
    New-ParamCompleter -LongName runtime -Description $msg.runtime
    New-ParamCompleter -ShortName n -LongName lines -Description $msg.lines -Type Required -VariableName 'INTEGER'
    New-ParamCompleter -ShortName o -LongName output -Description $msg.output -Type Required -Arguments $outputModeValues -VariableName 'MODE'
    New-ParamCompleter -LongName firmware-setup -Description $msg.firmware_setup
    New-ParamCompleter -LongName boot-loader-menu -Description $msg.boot_loader_menu -Type Required -VariableName 'TIMEOUT'
    New-ParamCompleter -LongName boot-loader-entry -Description $msg.boot_loader_entry -Type Required -VariableName 'ID'
    New-ParamCompleter -LongName plain -Description $msg.plain
    New-ParamCompleter -LongName timestamp -Description $msg.timestamp -Type Required -Arguments "pretty","unix","us","utc","us+utc" -VariableName 'FORMAT'
    New-ParamCompleter -LongName read-only -Description $msg.read_only
    New-ParamCompleter -LongName mkdir -Description $msg.mkdir
    New-ParamCompleter -LongName marked -Description $msg.marked
    New-ParamCompleter -LongName when -Description $msg.when -Type Required -Arguments "active","inactive","condition" -VariableName 'CONDITION'
    New-ParamCompleter -LongName preset-mode -Description $msg.preset_mode -Type Required -Arguments "full","enable-only","disable-only" -VariableName 'MODE'
    New-ParamCompleter -LongName root -Description $msg.root -Type Directory -VariableName 'PATH'
    New-ParamCompleter -LongName image -Description $msg.image -Type File -VariableName 'PATH'
    New-ParamCompleter -LongName image-policy -Description $msg.image_policy -Type Required -VariableName 'POLICY'
    New-ParamCompleter -ShortName H -LongName host -Description $msg.host -Type Required -VariableName 'HOST'
    New-ParamCompleter -ShortName M -LongName machine -Description $msg.machine -Type Required -VariableName 'CONTAINER'
    New-ParamCompleter -LongName wait -Description $msg.wait
    New-ParamCompleter -LongName version -Description $msg.version
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help_cmd
) -NoFileCompletions
