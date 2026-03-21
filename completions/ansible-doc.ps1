<#
 # ansible-doc completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ansible_doc         = plugin documentation tool
    all                 = Show documentation for all plugins
    entry_point         = Select the entry point for role documentation
    json                = Change output to JSON format
    list                = List available plugins
    metadata_dump       = Dump JSON metadata for all plugins (for testing)
    module_path         = Prepend colon-separated path(s) to module library
    no_native_async     = Disable native async for the documentation process
    playbook_dir        = Set the base directory for the playbook
    rotate_pages        = Use multiple columns when possible for list output
    snippet             = Show playbook snippet for specified plugin
    type                = Choose which plugin type to target
    verbose             = Verbose mode
    version             = Show program version number and exit
    help                = Show help message and exit
    type_become         = Become plugin
    type_cache          = Cache plugin
    type_callback       = Callback plugin
    type_cliconf        = CLI config plugin
    type_connection     = Connection plugin
    type_httpapi        = HTTP API plugin
    type_inventory      = Inventory plugin
    type_lookup         = Lookup plugin
    type_module         = Module (default)
    type_netconf        = Netconf plugin
    type_role           = Role
    type_shell          = Shell plugin
    type_strategy       = Strategy plugin
    type_vars           = Vars plugin
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$pluginTypes = @(
    "become`t{0}"     -f $msg.type_become
    "cache`t{0}"      -f $msg.type_cache
    "callback`t{0}"   -f $msg.type_callback
    "cliconf`t{0}"    -f $msg.type_cliconf
    "connection`t{0}" -f $msg.type_connection
    "httpapi`t{0}"    -f $msg.type_httpapi
    "inventory`t{0}"  -f $msg.type_inventory
    "lookup`t{0}"     -f $msg.type_lookup
    "module`t{0}"     -f $msg.type_module
    "netconf`t{0}"    -f $msg.type_netconf
    "role`t{0}"       -f $msg.type_role
    "shell`t{0}"      -f $msg.type_shell
    "strategy`t{0}"   -f $msg.type_strategy
    "vars`t{0}"       -f $msg.type_vars
)

Register-NativeCompleter -Name ansible-doc -Parameters @(
    New-ParamCompleter -ShortName a -LongName all -Description $msg.all
    New-ParamCompleter -ShortName e -LongName entry-point -Description $msg.entry_point -Type Required -VariableName 'ENTRY_POINT'
    New-ParamCompleter -ShortName j -LongName json -Description $msg.json
    New-ParamCompleter -ShortName l -LongName list -Description $msg.list
    New-ParamCompleter -LongName metadata-dump -Description $msg.metadata_dump
    New-ParamCompleter -ShortName M -LongName module-path -Description $msg.module_path -Type Required -VariableName 'MODULE_PATH'
    New-ParamCompleter -LongName no-native-async -Description $msg.no_native_async
    New-ParamCompleter -LongName playbook-dir -Description $msg.playbook_dir -Type Directory -VariableName 'BASEDIR'
    New-ParamCompleter -ShortName r -LongName rotate-pages -Description $msg.rotate_pages
    New-ParamCompleter -ShortName s -LongName snippet -Description $msg.snippet
    New-ParamCompleter -ShortName t -LongName type -Description $msg.type -Arguments $pluginTypes -VariableName 'TARGET'
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -LongName version -Description $msg.version
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
) -NoFileCompletions
