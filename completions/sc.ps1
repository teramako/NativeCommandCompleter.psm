<#
 # sc completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    sc                      = Service Control - Communicates with the Service Control Manager and services
    query                   = Query the status of a service or enumerate the status of types of services
    queryex                 = Query the extended status of a service or enumerate the status of types of services
    start                   = Start a service
    pause                   = Pause a service
    interrogate             = Send an interrogate control request to a service
    continue                = Continue a service
    stop                    = Stop a service
    config                  = Change the configuration of a service
    description             = Change the description of a service
    failure                 = Change the actions upon failure of a service
    failureflag             = Change the failure actions flag of a service
    sidtype                 = Change the service SID type of a service
    privs                   = Change the required privileges of a service
    managedaccount          = Change the service to mark the service account password as managed by LSA
    qc                      = Query the configuration information for a service
    qdescription            = Query the description for a service
    qfailure                = Query the actions taken by a service upon failure
    qfailureflag            = Query the failure actions flag of a service
    qsidtype                = Query the service SID type of a service
    qprivs                  = Query the required privileges of a service
    qtriggerinfo            = Query the trigger parameters of a service
    qpreferrednode          = Query the preferred NUMA node of a service
    qmanagedaccount         = Query whether a service uses an account with a password managed by LSA
    qprotection             = Query the process protection level of a service
    quserservice            = Query for a local instance of a user service template
    delete                  = Delete a service
    create                  = Create a service
    control                 = Send a control to a service
    sdshow                  = Display a service's security descriptor in SDDL format
    sdset                   = Set a service's security descriptor using SDDL format
    showsid                 = Display the service SID string corresponding to an arbitrary name
    triggerinfo             = Configure the trigger parameters of a service
    preferrednode           = Set the preferred NUMA node of a service
    GetDisplayName          = Get the DisplayName for a service
    GetKeyName              = Get the ServiceKeyName for a service
    EnumDepend              = Enumerate service dependencies
    boot                    = Indicate whether the last boot should be saved as the last-known-good boot configuration
    Lock                    = Lock the Service Database
    QueryLock               = Query the LockStatus for the SCManager Database
    
    server                  = The server to connect to
    type_own                = Service runs in its own process
    type_share              = Service shares a process with other services
    type_interact           = Service can interact with the desktop
    type_kernel             = Driver service
    type_filesys            = File system driver service
    type_rec                = File system recognizer driver service
    type_adapt              = Adapter driver service
    type_userservice        = User service
    type_usersvc_template   = User service template
    type_pktmonservice      = Packet monitor service
    type_pktmonsvc_template = Packet monitor service template
    start_boot              = Driver is loaded by the boot loader
    start_system            = Driver is loaded during kernel initialization
    start_auto              = Service starts automatically during system startup
    start_demand            = Service must be started manually
    start_disabled          = Service cannot be started
    start_delayed           = Service starts automatically with a delay
    error_normal            = Error is logged and a message box is displayed
    error_severe            = Error is logged and system is restarted with last-known-good configuration
    error_critical          = Error is logged and system attempts to restart with last-known-good configuration
    error_ignore            = Error is logged and startup continues
    state_all               = Enumerate services of all types and all states
    state_active            = Enumerate only active services
    state_inactive          = Enumerate only inactive services
    bufsize                 = The size of the enumeration buffer
    ri                      = The resume index at which to begin the enumeration
    group                   = The load order group
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$serviceCompleter = {
    Get-Service | Where-Object Name -Like "$wordToComplete*" | ForEach-Object {
        "{0}`t{1}" -f $_.Name, $_.DisplayName
    }
}

$typeArguments = @(
    "own`t{0}" -f $msg.type_own
    "share`t{0}" -f $msg.type_share
    "interact`t{0}" -f $msg.type_interact
    "kernel`t{0}" -f $msg.type_kernel
    "filesys`t{0}" -f $msg.type_filesys
    "rec`t{0}" -f $msg.type_rec
    "adapt`t{0}" -f $msg.type_adapt
    "userservice`t{0}" -f $msg.type_userservice
    "usersvc_template`t{0}" -f $msg.type_usersvc_template
    "pktmonservice`t{0}" -f $msg.type_pktmonservice
    "pktmonsvc_template`t{0}" -f $msg.type_pktmonsvc_template
)

$startArguments = @(
    "boot`t{0}" -f $msg.start_boot
    "system`t{0}" -f $msg.start_system
    "auto`t{0}" -f $msg.start_auto
    "demand`t{0}" -f $msg.start_demand
    "disabled`t{0}" -f $msg.start_disabled
    "delayed-auto`t{0}" -f $msg.start_delayed
)

$errorArguments = @(
    "normal`t{0}" -f $msg.error_normal
    "severe`t{0}" -f $msg.error_severe
    "critical`t{0}" -f $msg.error_critical
    "ignore`t{0}" -f $msg.error_ignore
)

$stateArguments = @(
    "all`t{0}" -f $msg.state_all
    "active`t{0}" -f $msg.state_active
    "inactive`t{0}" -f $msg.state_inactive
)

Register-NativeCompleter -Name sc -Description $msg.sc -Style Windows -Parameters @(
    New-ParamCompleter -LongName server -Description $msg.server -Type Required -VariableName 'ServerName'
) -SubCommands @(
    New-CommandCompleter -Name query -Description $msg.query -Parameters @(
        New-ParamCompleter -LongName type -Description $msg.type_own -Arguments $typeArguments -VariableName 'type'
        New-ParamCompleter -LongName state -Description $msg.state_all -Arguments $stateArguments -VariableName 'state'
        New-ParamCompleter -LongName bufsize -Description $msg.bufsize -Type Required -VariableName 'BufferSize'
        New-ParamCompleter -LongName ri -Description $msg.ri -Type Required -VariableName 'ResumeIndex'
        New-ParamCompleter -LongName group -Description $msg.group -Type Required -VariableName 'GroupName'
    ) -ArgumentCompleter $serviceCompleter
    
    New-CommandCompleter -Name queryex -Description $msg.queryex -Parameters @(
        New-ParamCompleter -LongName type -Description $msg.type_own -Arguments $typeArguments -VariableName 'type'
        New-ParamCompleter -LongName state -Description $msg.state_all -Arguments $stateArguments -VariableName 'state'
        New-ParamCompleter -LongName bufsize -Description $msg.bufsize -Type Required -VariableName 'BufferSize'
        New-ParamCompleter -LongName ri -Description $msg.ri -Type Required -VariableName 'ResumeIndex'
        New-ParamCompleter -LongName group -Description $msg.group -Type Required -VariableName 'GroupName'
    ) -ArgumentCompleter $serviceCompleter
    
    New-CommandCompleter -Name start -Description $msg.start -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name pause -Description $msg.pause -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name interrogate -Description $msg.interrogate -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name continue -Description $msg.continue -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name stop -Description $msg.stop -ArgumentCompleter $serviceCompleter
    
    New-CommandCompleter -Name config -Description $msg.config -Parameters @(
        New-ParamCompleter -LongName type -Description $msg.type_own -Arguments $typeArguments -VariableName 'type'
        New-ParamCompleter -LongName start -Description $msg.start_auto -Arguments $startArguments -VariableName 'start'
        New-ParamCompleter -LongName error -Description $msg.error_normal -Arguments $errorArguments -VariableName 'error'
        New-ParamCompleter -LongName binPath -Description 'BinaryPathName' -Type Required -VariableName 'BinaryPathName'
        New-ParamCompleter -LongName group -Description $msg.group -Type Required -VariableName 'LoadOrderGroup'
        New-ParamCompleter -LongName tag -Description 'TagId' -Arguments "yes","no" -VariableName 'yes/no'
        New-ParamCompleter -LongName depend -Description 'Dependencies' -Type Required -VariableName 'Dependencies'
        New-ParamCompleter -LongName obj -Description 'AccountName' -Type Required -VariableName 'AccountName'
        New-ParamCompleter -LongName DisplayName -Description 'DisplayName' -Type Required -VariableName 'DisplayName'
        New-ParamCompleter -LongName password -Description 'Password' -Type Required -VariableName 'Password'
    ) -ArgumentCompleter $serviceCompleter
    
    New-CommandCompleter -Name description -Description $msg.description -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name failure -Description $msg.failure -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name failureflag -Description $msg.failureflag -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name sidtype -Description $msg.sidtype -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name privs -Description $msg.privs -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name managedaccount -Description $msg.managedaccount -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qc -Description $msg.qc -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qdescription -Description $msg.qdescription -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qfailure -Description $msg.qfailure -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qfailureflag -Description $msg.qfailureflag -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qsidtype -Description $msg.qsidtype -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qprivs -Description $msg.qprivs -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qtriggerinfo -Description $msg.qtriggerinfo -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qpreferrednode -Description $msg.qpreferrednode -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qmanagedaccount -Description $msg.qmanagedaccount -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name qprotection -Description $msg.qprotection -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name quserservice -Description $msg.quserservice -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name delete -Description $msg.delete -ArgumentCompleter $serviceCompleter
    
    New-CommandCompleter -Name create -Description $msg.create -Parameters @(
        New-ParamCompleter -LongName type -Description $msg.type_own -Arguments $typeArguments -VariableName 'type'
        New-ParamCompleter -LongName start -Description $msg.start_auto -Arguments $startArguments -VariableName 'start'
        New-ParamCompleter -LongName error -Description $msg.error_normal -Arguments $errorArguments -VariableName 'error'
        New-ParamCompleter -LongName binPath -Description 'BinaryPathName' -Type Required -VariableName 'BinaryPathName'
        New-ParamCompleter -LongName group -Description $msg.group -Type Required -VariableName 'LoadOrderGroup'
        New-ParamCompleter -LongName tag -Description 'TagId' -Arguments "yes","no" -VariableName 'yes/no'
        New-ParamCompleter -LongName depend -Description 'Dependencies' -Type Required -VariableName 'Dependencies'
        New-ParamCompleter -LongName obj -Description 'AccountName' -Type Required -VariableName 'AccountName'
        New-ParamCompleter -LongName DisplayName -Description 'DisplayName' -Type Required -VariableName 'DisplayName'
        New-ParamCompleter -LongName password -Description 'Password' -Type Required -VariableName 'Password'
    ) -NoFileCompletions
    
    New-CommandCompleter -Name control -Description $msg.control -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name sdshow -Description $msg.sdshow -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name sdset -Description $msg.sdset -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name showsid -Description $msg.showsid -NoFileCompletions
    New-CommandCompleter -Name triggerinfo -Description $msg.triggerinfo -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name preferrednode -Description $msg.preferrednode -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name GetDisplayName -Description $msg.GetDisplayName -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name GetKeyName -Description $msg.GetKeyName -NoFileCompletions
    New-CommandCompleter -Name EnumDepend -Description $msg.EnumDepend -ArgumentCompleter $serviceCompleter
    New-CommandCompleter -Name boot -Description $msg.boot -NoFileCompletions
    New-CommandCompleter -Name Lock -Description $msg.Lock -NoFileCompletions
    New-CommandCompleter -Name QueryLock -Description $msg.QueryLock -NoFileCompletions
) -NoFileCompletions
