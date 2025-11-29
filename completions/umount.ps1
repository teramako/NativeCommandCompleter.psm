<#
 # umount completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    umount             = unmount filesystems
    all                = Unmount all filesystems
    all_targets        = Unmount all mountpoints for the given device
    detach_loop        = Detach loop device
    fake               = Do everything except actual system call
    force              = Force unmount
    internal_only      = Don't call umount helpers
    lazy               = Detach filesystem from tree now, cleanup later
    no_canonicalize    = Don't canonicalize paths
    no_mtab            = Don't write to /etc/mtab
    options            = Comma-separated list of mount options
    test_opts          = Limit filesystems by mount options
    read_only          = Remount read-only on unmount failure
    recursive          = Unmount recursively
    types              = Limit filesystems by type
    quiet              = Suppress 'not mounted' error messages
    verbose            = Verbose mode
    help               = Display help and exit
    version            = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name umount -Description $msg.umount -Parameters @(
    New-ParamCompleter -ShortName a -LongName all -Description $msg.all
    New-ParamCompleter -ShortName A -LongName all-targets -Description $msg.all_targets
    New-ParamCompleter -ShortName d -LongName detach-loop -Description $msg.detach_loop
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -LongName fake -Description $msg.fake
    New-ParamCompleter -ShortName i -LongName internal-only -Description $msg.internal_only
    New-ParamCompleter -ShortName l -LongName lazy -Description $msg.lazy
    New-ParamCompleter -ShortName n -LongName no-mtab -Description $msg.no_mtab
    New-ParamCompleter -LongName no-canonicalize -Description $msg.no_canonicalize
    New-ParamCompleter -ShortName O -LongName test-opts -Description $msg.test_opts -Type Required -VariableName 'list'
    New-ParamCompleter -ShortName o -LongName options -Description $msg.options -Type Required,List -VariableName 'list'
    New-ParamCompleter -ShortName R -LongName recursive -Description $msg.recursive
    New-ParamCompleter -ShortName r -LongName read-only -Description $msg.read_only
    New-ParamCompleter -ShortName t -LongName types -Description $msg.types -Type Required,List -VariableName 'list'
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
) -ArgumentCompleter {
    # Complete mounted filesystems
    $q = "$wordToComplete*"
    if (Test-Path /proc/mounts) {
        Get-Content /proc/mounts | ForEach-Object {
            $fields = $_ -split '\s+'
            if ($fields.Count -ge 2) {
                $mountpoint = $fields[1]
                $device = $fields[0]
                if ($mountpoint -like $q) {
                    "{0}`t{1}" -f $mountpoint, $device
                }
            }
        }
    }
}
