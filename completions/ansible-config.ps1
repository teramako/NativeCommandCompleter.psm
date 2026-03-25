<#
 # ansible-config completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ansible_config          = View ansible configuration.
    list                    = Print all config options
    dump                    = Dump configuration
    view                    = View configuration file
    init                    = Create initial configuration
    help                    = Show this help message and exit
    version                 = Show version and exit

    config_file             = path to configuration file, defaults to first file found in precedence.
    verbose                 = Verbose mode (-vvv for more, -vvvv to enable connection debugging)
    quiet                   = minimize output
    only_changed            = Only show configurations that have changed from the default
    format                  = Output format for list and dump
    type_filter             = Only show configuration of a given type
    disabled                = Print the documentation for existing plugins
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$helpParam = New-ParamCompleter -ShortName h -LongName help -Description $msg.help
$configFileParam = New-ParamCompleter -ShortName c -LongName config-file -Description $msg.config_file -Type File -VariableName 'CONFIG_FILE'
$verboseParam = New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
$quietParam = New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
$formatParam = New-ParamCompleter -ShortName f -LongName format -Description $msg.format -Arguments "ini","toml","env" -VariableName 'FORMAT'
$typeParam = New-ParamCompleter -ShortName t -LongName type -Description $msg.type_filter -Arguments "all","base","become","cache","callback","cliconf","connection","httpapi","inventory","lookup","netconf","shell","vars" -VariableName 'TYPE'

Register-NativeCompleter -Name ansible-config -Description $msg.ansible_config -Parameters @(
    $configFileParam
    $verboseParam
    $quietParam
    $helpParam
    New-ParamCompleter -LongName version -Description $msg.version
) -SubCommands @(
    New-CommandCompleter -Name list -Description $msg.list -Parameters @(
        $configFileParam
        $verboseParam
        $quietParam
        $formatParam
        $typeParam
        $helpParam
    ) -NoFileCompletions

    New-CommandCompleter -Name dump -Description $msg.dump -Parameters @(
        $configFileParam
        $verboseParam
        $quietParam
        $formatParam
        $typeParam
        $helpParam
        New-ParamCompleter -LongName only-changed, changed-only -Description $msg.only_changed
    ) -NoFileCompletions

    New-CommandCompleter -Name view -Description $msg.view -Parameters @(
        $configFileParam
        $verboseParam
        $quietParam
        $helpParam
    ) -NoFileCompletions

    New-CommandCompleter -Name init -Description $msg.init -Parameters @(
        $configFileParam
        $verboseParam
        $quietParam
        $formatParam
        $typeParam
        $helpParam
        New-ParamCompleter -ShortName d -LongName disabled -Description $msg.disabled
    ) -NoFileCompletions
)
