<#
 # vim completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    vim                     = Vi IMproved - enhanced vi editor
    command                 = Execute Ex command after loading
    arabic_mode             = Start in Arabic mode
    binary_mode             = Start in binary mode
    compatible_mode         = Behave mostly like vi (compatible mode)
    diff_mode               = Start in diff mode
    debug_mode              = Debugging mode
    ex_mode                 = Start in Ex mode
    exim_mode               = Start in improved Ex mode
    gui_mode                = Start in GUI mode
    hebrew_mode             = Start in Hebrew mode
    viminfo                 = Set the viminfo file location
    lisp_mode               = Start in lisp mode
    list_swap               = List swap files
    disable_modify          = Disable file modification (set nowrite)
    disallow_modify         = Disallow file modification (set nomodifiable)
    no_swap                 = Don't use swap files
    no_compatible           = Not compatible with Vi
    horizontally_split      = Open horizontally split for each file
    vertical_split          = Open vertical split for each file
    open_tab                = Open tab for each file
    recovery                = Use swap files for recovery
    readonly_mode           = Readonly mode
    source                  = Source and execute script file
    source_after_load       = Source script after loading
    terminal                = Terminal name
    vimrc                   = Use alternative vimrc
    gvimrc                  = Use alternative gvimrc
    vi_mode                 = Start in vi mode
    verbose_mode            = Start in verbose mode
    write_script            = Record all typed characters
    write_script2           = Record all typed characters (overwrite file)
    encrypt                 = Use encryption when writing files
    no_XServer              = Don't connect to X server
    no_wayland              = Don't connect to the wayland compositor
    easy_mode               = Start in easy mode (modeless)
    restrict_mode           = Start in restricted mode
    clean                   = Factory defaults: skip vimrc, plugins, viminfo
    command_before_load     = Execute Ex command before loading
    help                    = Print help and exit
    literal                 = Do not expand wildcards
    noplugin                = Skip loading plugins
    remote                  = Edit files in a Vim server
    remote_expr             = Evaluate expression in a Vim server
    remote_send             = Send keys to a Vim server
    remote_silent           = Remote without complaining
    remote_wait             = Wait for files to be edited in server
    remote_wait_silent      = Wait silently
    serverlist              = List all Vim servers that can be found
    servername              = Set server name
    startuptime             = Write startup timing to file
    ttyfail                 = Exit if not a tty
    version                 = Print version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name vim -Description $msg.vim -Parameters @(
    New-ParamCompleter -ShortName c -Description $msg.command -Type Required -VariableName 'command'
    New-ParamCompleter -ShortName A -Description $msg.arabic_mode
    New-ParamCompleter -ShortName b -Description $msg.binary_mode
    New-ParamCompleter -ShortName C -Description $msg.compatible_mode
    New-ParamCompleter -ShortName d -Description $msg.diff_mode
    New-ParamCompleter -ShortName D -Description $msg.debug_mode
    New-ParamCompleter -ShortName e -Description $msg.ex_mode
    New-ParamCompleter -ShortName E -Description $msg.exim_mode
    New-ParamCompleter -ShortName g -Description $msg.gui_mode
    New-ParamCompleter -ShortName H -Description $msg.hebrew_mode
    New-ParamCompleter -ShortName i -Description $msg.viminfo -Type File -VariableName 'viminfo'
    New-ParamCompleter -ShortName l -Description $msg.lisp_mode
    New-ParamCompleter -ShortName L -Description $msg.list_swap
    New-ParamCompleter -ShortName m -Description $msg.disable_modify
    New-ParamCompleter -ShortName M -Description $msg.disallow_modify
    New-ParamCompleter -ShortName n -Description $msg.no_swap
    New-ParamCompleter -ShortName N -Description $msg.no_compatible
    New-ParamCompleter -ShortName o -Description $msg.horizontally_split -Type FlagOrValue -VariableName 'N'
    New-ParamCompleter -ShortName O -Description $msg.vertical_split -Type FlagOrValue -VariableName 'N'
    New-ParamCompleter -ShortName p -Description $msg.open_tab -Type FlagOrValue -VariableName 'N'
    New-ParamCompleter -ShortName r -Description $msg.recovery -Type File -VariableName 'file.swp'
    New-ParamCompleter -ShortName R -Description $msg.readonly_mode
    New-ParamCompleter -ShortName s -Description $msg.source -Type File -VariableName 'scriptin'
    New-ParamCompleter -ShortName S -Description $msg.source_after_load -Type File -VariableName 'source'
    New-ParamCompleter -ShortName T -Description $msg.terminal -Type Required -VariableName 'terminal'
    New-ParamCompleter -ShortName u -Description $msg.vimrc -Type File -VariableName 'vimrc'
    New-ParamCompleter -ShortName U -Description $msg.gvimrc -Type File -VariableName 'gvimrc'
    New-ParamCompleter -ShortName v -Description $msg.vi_mode
    New-ParamCompleter -ShortName V -Description $msg.verbose_mode -Type FlagOrValue -VariableName 'N'
    New-ParamCompleter -ShortName w -Description $msg.write_script -Type File -VariableName 'scriptout'
    New-ParamCompleter -ShortName W -Description $msg.write_script2 -Type File -VariableName 'scriptout'
    New-ParamCompleter -ShortName x -Description $msg.encrypt
    New-ParamCompleter -ShortName X -Description $msg.no_XServer
    New-ParamCompleter -ShortName Y -Description $msg.no_wayland
    New-ParamCompleter -ShortName y -Description $msg.easy_mode
    New-ParamCompleter -ShortName Z -Description $msg.restrict_mode
    New-ParamCompleter -LongName clean -Description $msg.clean
    New-ParamCompleter -LongName cmd -Description $msg.command_before_load -Type Required -VariableName 'command'
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -LongName literal -Description $msg.literal
    New-ParamCompleter -LongName noplugin -Description $msg.noplugin
    New-ParamCompleter -LongName remote -Description $msg.remote -Type Required -VariableName 'files'
    New-ParamCompleter -LongName remote-expr -Description $msg.remote_expr -Type Required -VariableName 'expr'
    New-ParamCompleter -LongName remote-send -Description $msg.remote_send -Type Required -VariableName 'keys'
    New-ParamCompleter -LongName remote-silent -Description $msg.remote_silent -Type Required -VariableName 'files'
    New-ParamCompleter -LongName remote-wait -Description $msg.remote_wait -Type Required -VariableName 'files'
    New-ParamCompleter -LongName remote-wait-silent -Description $msg.remote_wait_silent -Type Required -VariableName 'files'
    New-ParamCompleter -LongName serverlist -Description $msg.serverlist
    New-ParamCompleter -LongName servername -Description $msg.servername -Type Required -VariableName 'name'
    New-ParamCompleter -LongName startuptime -Description $msg.startuptime -Type File -VariableName 'file'
    New-ParamCompleter -LongName ttyfail -Description $msg.ttyfail
    New-ParamCompleter -LongName version -Description $msg.version
)
