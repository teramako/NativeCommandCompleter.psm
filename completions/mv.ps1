<#
 # mv completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    backup                 = Backup each existing destination file
    backup_none            = Never make backups
    backup_numbered        = Make numbered backups
    backup_existing        = Numbered backups if any exist, else simple
    backup_simple          = Make simple backups
    short_backup           = Backup each existing destination file
    force                  = Don't prompt to overwrite
    interactive            = Prompt to overwrite
    noClobber              = Don't overwrite existing
    stripTrailingSlashes   = Remove trailing '/' from source args
    suffix                 = Override default backup suffix
    targetDirectory        = Move all source args into DIR
    noTargetDirectory      = Treat DEST as a normal file
    update                 = Control which existing files are updated
    update_all             = All existing files in the destination being replaced.
    update_none            = Similar to the --no-clobber option, in that no files in the destination are replaced, but also skipped files do not induce a failure.
    update_older           = (default) Files being replaced if they're older than the corresponding source file.
    short_updateOlder      = Equivalent to --update[=older], files being replaced if they're older than the corresponding source file.
    verbose                = Print filenames as it goes
    context                = Set SELinux context to default
    help                   = Print help and exit
    version                = Print version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

if ($IsLinux)
{
    Register-NativeCompleter -Name mv -Parameters @(
        New-ParamCompleter -LongName backup -Description $msg.backup -Arguments @(
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
        New-ParamCompleter -ShortName f -LongName force -Description $msg.force
        New-ParamCompleter -ShortName i -LongName interactive -Description $msg.interactive
        New-ParamCompleter -ShortName n -LongName no-clobber -Description $msg.noClobber
        New-ParamCompleter -LongName strip-trailing-slashes -Description $msg.stripTrailingSlashes
        New-ParamCompleter -ShortName S -LongName suffix -Type Required -Description $msg.suffix -VariableName 'SUFFIX'
        New-ParamCompleter -ShortName t -LongName target-directory -Type Directory -Description $msg.targetDirectory -VariableName 'DIRECTORY'
        New-ParamCompleter -ShortName T -LongName no-target-directory -Description $msg.noTargetDirectory
        New-ParamCompleter -LongName update -Description $msg.update -Type FlagOrValue -Arguments @(
            "all `t{0}" -f $msg.update_all
            "none `t{0}" -f $msg.update_none
            "older `t{0}" -f $msg.update_older
        ) -VariableName 'UPDATE'
        New-ParamCompleter -ShortName u -Description $msg.short_updateOlder
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
        New-ParamCompleter -ShortName Z -LongName context -Description $msg.context
        New-ParamCompleter -LongName help -Description $msg.help
        New-ParamCompleter -LongName version -Description $msg.version
    )
}
