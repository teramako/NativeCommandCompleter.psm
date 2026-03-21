<#
 # ansible-vault completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ansible_vault             = encryption/decryption utility for Ansible data files

    create                    = Create new vault encrypted file
    decrypt                   = Decrypt vault encrypted file
    edit                      = Edit vault encrypted file
    encrypt                   = Encrypt YAML file
    encrypt_string            = Encrypt a string
    rekey                     = Re-key a vault encrypted file
    view                      = View vault encrypted file

    vault_id                  = The vault identity to use
    vault_password_file       = Vault password file
    new_vault_id              = The new vault identity to use for rekey
    new_vault_password_file   = New vault password file for rekey
    output                    = Output file name for encrypt or decrypt
    encrypt_string_stdin_name = Specify the variable name used in stdin mode
    encrypt_string_prompt     = Prompt for the string to encrypt
    encrypt_string_show_input = Show the string being encrypted
    encrypt_string_name       = Specify the variable name
    ask_vault_pass            = Ask for vault password
    verbose                   = Verbose mode
    version                   = Show program version number and exit
    help                      = Show help message and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$vaultIdParam = New-ParamCompleter -LongName vault-id -Description $msg.vault_id -Type Required -VariableName 'VAULT_ID'
$vaultPasswordFileParam = New-ParamCompleter -LongName vault-password-file, vault-pass-file -Description $msg.vault_password_file -Type File -VariableName 'VAULT_PASSWORD_FILE'
$askVaultPassParam = New-ParamCompleter -LongName ask-vault-password, ask-vault-pass -Description $msg.ask_vault_pass
$verboseParam = New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
$helpParam = New-ParamCompleter -ShortName h -LongName help -Description $msg.help

Register-NativeCompleter -Name ansible-vault -Description $msg.ansible_vault -Parameters @(
    $verboseParam
    New-ParamCompleter -LongName version -Description $msg.version
    $helpParam
) -SubCommands @(
    New-CommandCompleter -Name create -Description $msg.create -Parameters @(
        $vaultIdParam
        $vaultPasswordFileParam
        $askVaultPassParam
        $verboseParam
        $helpParam
    )

    New-CommandCompleter -Name decrypt -Description $msg.decrypt -Parameters @(
        $vaultIdParam
        $vaultPasswordFileParam
        $askVaultPassParam
        New-ParamCompleter -LongName output -Description $msg.output -Type File -VariableName 'OUTPUT_FILE'
        $verboseParam
        $helpParam
    )

    New-CommandCompleter -Name edit -Description $msg.edit -Parameters @(
        $vaultIdParam
        $vaultPasswordFileParam
        $askVaultPassParam
        $verboseParam
        $helpParam
    )

    New-CommandCompleter -Name encrypt -Description $msg.encrypt -Parameters @(
        $vaultIdParam
        $vaultPasswordFileParam
        $askVaultPassParam
        New-ParamCompleter -LongName output -Description $msg.output -Type File -VariableName 'OUTPUT_FILE'
        $verboseParam
        $helpParam
    )

    New-CommandCompleter -Name encrypt_string -Description $msg.encrypt_string -Parameters @(
        $vaultIdParam
        $vaultPasswordFileParam
        $askVaultPassParam
        New-ParamCompleter -LongName stdin-name -Description $msg.encrypt_string_stdin_name -Type Required -VariableName 'ENCRYPT_STRING_STDIN_NAME'
        New-ParamCompleter -ShortName p -LongName prompt -Description $msg.encrypt_string_prompt
        New-ParamCompleter -LongName show-input -Description $msg.encrypt_string_show_input
        New-ParamCompleter -ShortName n -LongName name -Description $msg.encrypt_string_name -Type Required -VariableName 'ENCRYPT_STRING_NAME'
        New-ParamCompleter -LongName output -Description $msg.output -Type File -VariableName 'OUTPUT_FILE'
        $verboseParam
        $helpParam
    ) -NoFileCompletions

    New-CommandCompleter -Name rekey -Description $msg.rekey -Parameters @(
        $vaultIdParam
        $vaultPasswordFileParam
        $askVaultPassParam
        New-ParamCompleter -LongName new-vault-id -Description $msg.new_vault_id -Type Required -VariableName 'NEW_VAULT_ID'
        New-ParamCompleter -LongName new-vault-password-file -Description $msg.new_vault_password_file -Type File -VariableName 'NEW_VAULT_PASSWORD_FILE'
        $verboseParam
        $helpParam
    )

    New-CommandCompleter -Name view -Description $msg.view -Parameters @(
        $vaultIdParam
        $vaultPasswordFileParam
        $askVaultPassParam
        $verboseParam
        $helpParam
    )
) -NoFileCompletions
