<#
 # ln completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ln                  = make links between files
    backup              = Make a backup of each existing destination file
    short_backup        = Make a backup of each existing destination file
    backup_none         = Never make backups
    backup_numbered     = Make numbered backups
    backup_existing     = Numbered backups if any exist, else simple
    backup_simple       = Make simple backups
    directory           = Allow superuser to attempt to hard link directories
    force               = Remove existing destination files
    interactive         = Prompt whether to remove destinations
    logical             = Dereference TARGETs that are symbolic links
    noDereference       = Treat symlink to directory as if it were a file
    physical            = Make hard links directly to symbolic links
    relative            = With -s, create links relative to link location
    symbolic            = Make symbolic links instead of hard links
    suffix              = Override the usual ~ backup suffix
    targetDirectory     = Specify the DIRECTORY in which to create the links
    noTargetDirectory   = Treat LINK_NAME as a normal file
    verbose             = Print name of each linked file
    help                = Display help and exit
    version             = Output version information and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ln -Description $msg.ln -Parameters @(
    New-ParamCompleter -LongName backup -Description $msg.backup -Type FlagOrValue -Arguments @(
        "none `t{0}" -f $msg.backup_none
        "off `t{0}" -f $msg.backup_none
        "numbered `t{0}" -f $msg.backup_numbered
        "t `t{0}" -f $msg.backup_numbered
        "existing `t{0}" -f $msg.backup_existing
        "nil `t{0}" -f $msg.backup_existing
        "simple `t{0}" -f $msg.backup_simple
        "never `t{0}" -f $msg.backup_simple
    ) -VariableName 'CONTROL'
    New-ParamCompleter -ShortName b -Description $msg.short_backup
    New-ParamCompleter -ShortName d -LongName directory -Description $msg.directory
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -ShortName i -LongName interactive -Description $msg.interactive
    New-ParamCompleter -ShortName L -LongName logical -Description $msg.logical
    New-ParamCompleter -ShortName n -LongName no-dereference -Description $msg.noDereference
    New-ParamCompleter -ShortName P -LongName physical -Description $msg.physical
    New-ParamCompleter -ShortName r -LongName relative -Description $msg.relative
    New-ParamCompleter -ShortName s -LongName symbolic -Description $msg.symbolic
    New-ParamCompleter -ShortName S -LongName suffix -Description $msg.suffix -VariableName 'SUFFIX'
    New-ParamCompleter -ShortName t -LongName target-directory -Description $msg.targetDirectory -Type Directory -VariableName 'DIRECTORY'
    New-ParamCompleter -ShortName T -LongName no-target-directory -Description $msg.noTargetDirectory
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -LongName help -Description $msg.help
    New-ParamCompleter -LongName version -Description $msg.version
)
