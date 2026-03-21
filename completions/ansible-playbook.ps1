<#
 # ansible-playbook completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ansible_playbook       = Runs Ansible playbooks, executing the defined tasks on the targeted hosts.
    ask_become_pass        = Ask for privilege escalation password
    ask_pass               = Ask for connection password
    ask_vault_password     = Ask for vault password
    become                 = Run operations with become
    become_method          = Privilege escalation method
    become_user            = Run operations as this user
    check                  = Don't make any changes; instead, try to predict changes
    connection             = Connection type to use
    diff                   = Show the differences for changed files
    extra_vars             = Set additional variables as key=value or YAML/JSON
    flush_cache            = Clear the fact cache for every host in inventory
    force_handlers         = Run handlers even if a task fails
    forks                  = Specify number of parallel processes to use
    help                   = Show this help message and exit
    inventory              = Specify inventory host path or comma separated host list
    limit                  = Further limit selected hosts to an additional pattern
    list_hosts             = Outputs a list of matching hosts
    list_tags              = List all available tags
    list_tasks             = List all tasks that would be executed
    module_path            = Prepend paths to module library
    private_key            = Use this file to authenticate the connection
    scp_extra_args         = Extra arguments to pass to scp only
    sftp_extra_args        = Extra arguments to pass to sftp only
    skip_tags              = Only run plays and tasks whose tags do not match
    ssh_common_args        = Common extra arguments for sftp/scp/ssh
    ssh_extra_args         = Extra arguments to pass to ssh only
    start_at_task          = Start the playbook at the task matching this name
    step                   = One-step-at-a-time: confirm each task before running
    syntax_check           = Perform a syntax check on the playbook
    tags                   = Only run plays and tasks tagged with these values
    timeout                = Override the connection timeout in seconds
    user                   = Connect as this user
    vault_id               = The vault identity to use
    vault_password_file    = Vault password file
    verbose                = Verbose mode
    version                = Show program's version number and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$extraVarsCompleter = {
    param([int] $postion, [int] $argIndex)
    if ([string]::IsNullOrEmpty($wordToComplete)) {
        "'@`tRead from file",
        "'{`tYAML/JSON"
    } elseif ($wordToComplete -match '^([''"])?@.*?\1?$') {
        [MT.Comp.Helper]::CompleteFilename($this, $false, $false, $null, "@")
    } else {
        return $null
    }
}

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

$hostsCompleter = {
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

Register-NativeCompleter -Name ansible-playbook -Description $msg.ansible_playbook -Parameters @(
    New-ParamCompleter -ShortName K -LongName ask-become-pass -Description $msg.ask_become_pass
    New-ParamCompleter -ShortName k -LongName ask-pass -Description $msg.ask_pass
    New-ParamCompleter -LongName ask-vault-password, ask-vault-pass -Description $msg.ask_vault_password
    New-ParamCompleter -ShortName b -LongName become -Description $msg.become
    New-ParamCompleter -LongName become-method -Description $msg.become_method -Type Required -VariableName 'BECOME_METHOD' -ArgumentCompleter $becomeCompleter
    New-ParamCompleter -LongName become-user -Description $msg.become_user -Type Required -VariableName 'BECOME_USER'
    New-ParamCompleter -ShortName C -LongName check -Description $msg.check
    New-ParamCompleter -ShortName c -LongName connection -Description $msg.connection -Type Required -VariableName 'CONNECTION' -ArgumentCompleter $connectionCompleter
    New-ParamCompleter -ShortName D -LongName diff -Description $msg.diff
    New-ParamCompleter -ShortName e -LongName extra-vars -Description $msg.extra_vars -Type Required -VariableName 'EXTRA_VARS' -ArgumentCompleter $extraVarsCompleter
    New-ParamCompleter -LongName flush-cache -Description $msg.flush_cache
    New-ParamCompleter -LongName force-handlers -Description $msg.force_handlers
    New-ParamCompleter -ShortName f -LongName forks -Description $msg.forks -Type Required -VariableName 'FORKS'
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName i -LongName inventory -Description $msg.inventory -Type File -VariableName 'INVENTORY'
    New-ParamCompleter -ShortName l -LongName limit -Description $msg.limit -Type List -VariableName 'SUBSET' -ArgumentCompleter $hostsCompleter
    New-ParamCompleter -LongName list-hosts -Description $msg.list_hosts
    New-ParamCompleter -LongName list-tags -Description $msg.list_tags
    New-ParamCompleter -LongName list-tasks -Description $msg.list_tasks
    New-ParamCompleter -ShortName M -LongName module-path -Description $msg.module_path -Type Required -VariableName 'MODULE_PATH'
    New-ParamCompleter -LongName private-key, key-file -Description $msg.private_key -Type File -VariableName 'PRIVATE_KEY_FILE'
    New-ParamCompleter -LongName scp-extra-args -Description $msg.scp_extra_args -Type Required -VariableName 'SCP_EXTRA_ARGS'
    New-ParamCompleter -LongName sftp-extra-args -Description $msg.sftp_extra_args -Type Required -VariableName 'SFTP_EXTRA_ARGS'
    New-ParamCompleter -LongName skip-tags -Description $msg.skip_tags -Type Required -VariableName 'SKIP_TAGS'
    New-ParamCompleter -LongName ssh-common-args -Description $msg.ssh_common_args -Type Required -VariableName 'SSH_COMMON_ARGS'
    New-ParamCompleter -LongName ssh-extra-args -Description $msg.ssh_extra_args -Type Required -VariableName 'SSH_EXTRA_ARGS'
    New-ParamCompleter -LongName start-at-task -Description $msg.start_at_task -Type Required -VariableName 'START_AT_TASK'
    New-ParamCompleter -LongName step -Description $msg.step
    New-ParamCompleter -LongName syntax-check -Description $msg.syntax_check
    New-ParamCompleter -ShortName t -LongName tags -Description $msg.tags -Type Required -VariableName 'TAGS'
    New-ParamCompleter -ShortName T -LongName timeout -Description $msg.timeout -Type Required -VariableName 'TIMEOUT'
    New-ParamCompleter -ShortName u -LongName user -Description $msg.user -Type Required -VariableName 'REMOTE_USER'
    New-ParamCompleter -LongName vault-id -Description $msg.vault_id -Type Required -VariableName 'VAULT_IDS'
    New-ParamCompleter -LongName vault-password-file, vault-pass-file -Description $msg.vault_password_file -Type File -VariableName 'VAULT_PASSWORD_FILES'
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -LongName version -Description $msg.version
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
        $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Extension -match '\.ya?ml$'
    })
}
