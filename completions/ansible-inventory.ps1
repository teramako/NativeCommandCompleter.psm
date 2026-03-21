<#
 # ansible-inventory completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ansible_inventory       = Show Ansible inventory information
    export                  = When doing an --list, represent in a way that is optimized for export
    graph                   = Create inventory graph
    host                    = Output specific host info, works as inventory script
    list                    = Output all hosts info, works as inventory script
    output                  = When doing --list, send the inventory to a file instead of to the screen
    playbook_dir            = Since this tool does not use playbooks, use this as a substitute
    vars                    = Add vars to the play
    toml                    = Use TOML format instead of default JSON
    yaml                    = Use YAML format instead of default JSON
    vault_id                = The vault identity to use
    vault_password_file     = Vault password file
    version                 = Show program version number
    ask_vault_password      = Ask for vault password
    extra_vars              = Set additional variables as key=value or YAML/JSON
    help                    = Show help message and exit
    inventory               = Specify inventory host path or comma separated host list
    limit                   = Further limit selected hosts to an additional pattern
    verbose                 = Verbose mode
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ansible-inventory -Description $msg.ansible_inventory -Parameters @(
    New-ParamCompleter -LongName export -Description $msg.export
    New-ParamCompleter -LongName graph -Description $msg.graph
    New-ParamCompleter -LongName host -Description $msg.host -Type Required -VariableName 'HOST'
    New-ParamCompleter -LongName list -Description $msg.list
    New-ParamCompleter -LongName output -Description $msg.output -Type File -VariableName 'OUTPUT_FILE'
    New-ParamCompleter -LongName playbook-dir -Description $msg.playbook_dir -Type Directory -VariableName 'BASEDIR'
    New-ParamCompleter -LongName vars -Description $msg.vars
    New-ParamCompleter -LongName toml -Description $msg.toml
    New-ParamCompleter -LongName yaml -Description $msg.yaml
    New-ParamCompleter -LongName vault-id -Description $msg.vault_id -Type Required -VariableName 'VAULT_ID'
    New-ParamCompleter -LongName vault-password-file, vault-pass-file -Description $msg.vault_password_file -Type File -VariableName 'VAULT_PASSWORD_FILE'
    New-ParamCompleter -LongName version -Description $msg.version
    New-ParamCompleter -ShortName J -LongName ask-vault-password, ask-vault-pass -Description $msg.ask_vault_password
    New-ParamCompleter -ShortName e -LongName extra-vars -Description $msg.extra_vars -Type Required -VariableName 'EXTRA_VARS'
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName i -LongName inventory, inventory-file -Description $msg.inventory -Type File -VariableName 'INVENTORY'
    New-ParamCompleter -ShortName l -LongName limit -Description $msg.limit -Type Required -VariableName 'SUBSET'
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
) -NoFileCompletions
