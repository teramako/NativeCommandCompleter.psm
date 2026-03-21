<#
 # ansible completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ansible          = Run a task on target hosts
    ask_become_pass  = Ask for privilege escalation password
    ask_pass         = Ask for connection password
    ask_vault_pass   = Ask for vault password
    background       = Run asynchronously, failing after N seconds
    become           = Run operations with become
    become_method    = Privilege escalation method to use
    become_user      = Run operations as this user
    check            = Run in dry-run mode, do not make changes
    connection       = Connection type to use
    diff             = Show differences for changed files and templates
    extra_vars       = Set additional variables as key=value or YAML/JSON
    forks            = Specify number of parallel processes
    help             = Show help message and exit
    inventory        = Specify inventory host path or comma separated host list
    limit            = Limit execution to a subset of hosts
    list_hosts       = Output matching hosts and exit
    module_args      = Module arguments
    module_name      = Module name to execute
    module_path      = Prepend colon-separated path(s) to module library
    one_line         = Condense output
    playbook_dir     = Set alternate base directory for the playbook
    poll             = Set the polling interval for background tasks
    private_key      = Use this file to authenticate the connection
    scp_extra_args   = Extra arguments to pass to scp only
    sftp_extra_args  = Extra arguments to pass to sftp only
    ssh_common_args  = Extra arguments to pass to all ssh CLI tools
    ssh_extra_args   = Extra arguments to pass to ssh only
    task_timeout     = Override the task timeout
    timeout          = Override the connection timeout
    tree             = Log output to this directory
    user             = Connect as this user
    vault_id         = Vault identity to use
    vault_pass_file  = Vault password file path
    verbose          = Verbose mode
    version          = Show version information and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$connectionCompleter = {
    $q = "$wordToComplete*"
    $items = ansible-doc -t connection -lj | ConvertFrom-Json -AsHashtable
    $items.GetEnumerator().ForEach({
        $name = $_.Key.Split('.')[-1]
        if ($_.Key -like $q) {
            "{0}`t{1}" -f $_.Key, $_.Value
        }
        if ($name -like $q) {
            "{0}`t{1}" -f $name, $_.Value
        }
    })
}

$becomeCompleter = {
    $items = ansible-doc -t become -lj | ConvertFrom-Json -AsHashtable
    $items.GetEnumerator().ForEach({
        $name = $_.Key.Split('.')[-1]
        if ($_.Key -like $q) {
            "{0}`t{1}" -f $_.Key, $_.Value
        }
        if ($name -like $q) {
            "{0}`t{1}" -f $name, $_.Value
        }
    })
}

Register-NativeCompleter -Name ansible -Description $msg.ansible -Parameters @(
    New-ParamCompleter -ShortName h -LongName help    -Description $msg.help
    New-ParamCompleter -LongName version              -Description $msg.version
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose

    # Target
    New-ParamCompleter -ShortName i -LongName inventory, inventory-file -Description $msg.inventory -Type File     -VariableName 'INVENTORY'
    New-ParamCompleter -ShortName l -LongName limit, subset             -Description $msg.limit     -Type Required -VariableName 'SUBSET'
    New-ParamCompleter -LongName list-hosts -Description $msg.list_hosts

    # Module
    New-ParamCompleter -ShortName m -LongName module-name -Description $msg.module_name -Type Required  -VariableName 'MODULE_NAME'
    New-ParamCompleter -ShortName a -LongName args        -Description $msg.module_args -Type Required  -VariableName 'MODULE_ARGS'
    New-ParamCompleter -ShortName M -LongName module-path -Description $msg.module_path -Type Directory -VariableName 'MODULE_PATH'

    # Execution
    New-ParamCompleter -ShortName e -LongName extra-vars -Description $msg.extra_vars   -Type Required  -VariableName 'EXTRA_VARS'
    New-ParamCompleter -ShortName f -LongName forks      -Description $msg.forks        -Type Required  -VariableName 'NUM'
    New-ParamCompleter -ShortName C -LongName check      -Description $msg.check
    New-ParamCompleter -ShortName D -LongName diff       -Description $msg.diff
    New-ParamCompleter -ShortName o -LongName one-line   -Description $msg.one_line
    New-ParamCompleter -ShortName t -LongName tree       -Description $msg.tree         -Type Directory -VariableName 'TREE'
    New-ParamCompleter -LongName task-timeout            -Description $msg.task_timeout -Type Required  -VariableName 'TASK_TIMEOUT'
    New-ParamCompleter -LongName playbook-dir            -Description $msg.playbook_dir -Type Directory -VariableName 'BASEDIR'

    # Async
    New-ParamCompleter -ShortName B -LongName background -Description $msg.background -Type Required -VariableName 'SECONDS'
    New-ParamCompleter -ShortName P -LongName poll       -Description $msg.poll       -Type Required -VariableName 'POLL_INTERVAL'

    # Connection
    New-ParamCompleter -ShortName c -LongName connection -Description $msg.connection      -ArgumentCompleter $connectionCompleter -VariableName 'CONNECTION'
    New-ParamCompleter -ShortName u -LongName user       -Description $msg.user            -Type Required -VariableName 'REMOTE_USER'
    New-ParamCompleter -ShortName T -LongName timeout    -Description $msg.timeout         -Type Required -VariableName 'TIMEOUT'
    New-ParamCompleter -LongName private-key, key-file   -Description $msg.private_key     -Type File     -VariableName 'PRIVATE_KEY_FILE'
    New-ParamCompleter -ShortName k -LongName ask-pass   -Description $msg.ask_pass
    New-ParamCompleter -LongName ssh-common-args         -Description $msg.ssh_common_args -Type Required -VariableName 'SSH_COMMON_ARGS'
    New-ParamCompleter -LongName ssh-extra-args          -Description $msg.ssh_extra_args  -Type Required -VariableName 'SSH_EXTRA_ARGS'
    New-ParamCompleter -LongName sftp-extra-args         -Description $msg.sftp_extra_args -Type Required -VariableName 'SFTP_EXTRA_ARGS'
    New-ParamCompleter -LongName scp-extra-args          -Description $msg.scp_extra_args  -Type Required -VariableName 'SCP_EXTRA_ARGS'

    # Privilege escalation
    New-ParamCompleter -ShortName b -LongName become          -Description $msg.become
    New-ParamCompleter -LongName become-method                -Description $msg.become_method -ArgumentCompleter $becomeCompleter -VariableName 'BECOME_METHOD'
    New-ParamCompleter -LongName become-user                  -Description $msg.become_user   -Type Required -VariableName 'BECOME_USER'
    New-ParamCompleter -ShortName K -LongName ask-become-pass -Description $msg.ask_become_pass

    # Vault
    New-ParamCompleter -LongName vault-id                             -Description $msg.vault_id        -Type Required -VariableName 'VAULT_IDS'
    New-ParamCompleter -LongName vault-password-file, vault-pass-file -Description $msg.vault_pass_file -Type File     -VariableName 'VAULT_PASSWORD_FILES'
    New-ParamCompleter -LongName ask-vault-pass, ask-vault-password   -Description $msg.ask_vault_pass
) -NoFileCompletions -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    $q = "$wordToComplete*"
    $cmdArgs = @("--list")
    if ($this.BoundParameters["inventory"]) {
        $cmdArgs += "--inventory", $this.BoundParameters["inventory"]
    }
    $inventory = ansible-inventory @cmdArgs | ConvertFrom-Json -AsHashtable
    $groups = $inventory.Keys.Where({$_ -ne "_meta"}) | Sort-Object
    $hosts = $groups | ForEach-Object { $inventory[$_].hosts } | Sort-Object -Unique

    foreach ($name in $groups.Where({$_ -like $q})) {
        "{0}`tGroup" -f $name
    }
    foreach ($name in $hosts.Where({$_ -like $q})) {
        "{0}`tHost" -f $name
    }
}
