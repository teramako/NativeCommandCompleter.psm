<#
 # mount completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    mount                       = mount a filesystem
    gnu_all                     = Mount all filesystems mentioned in fstab
    gnu_append                  = Append options to existing /etc/mtab
    gnu_bind                    = Remount a subtree to a second position
    gnu_fake                    = Do everything except the actual system call
    gnu_fork                    = Fork off for each device
    gnu_fstab                   = Use alternative fstab file
    gnu_help                    = Display help and exit
    gnu_internal_only           = Don't call mount helpers
    gnu_show_labels             = Show also filesystem labels
    gnu_no_canonicalize         = Don't canonicalize paths
    gnu_no_mtab                 = Don't write to /etc/mtab
    gnu_options                 = Specify mount options
    gnu_options_namespace       = Set options namespace
    gnu_options_source          = Mount options from fstab/mtab
    gnu_options_source_force    = Use mount options from fstab/mtab
    gnu_read_only               = Mount read-only
    gnu_types                   = Specify filesystem type(s)
    gnu_source                  = Explicitly specify source
    gnu_target                  = Explicitly specify mountpoint
    gnu_test_opts               = Limit filesystems by options
    gnu_verbose                 = Verbose mode
    gnu_version                 = Display version and exit
    gnu_read_write              = Mount read-write (default)
    gnu_namespace               = Perform mount in different namespace
    gnu_all_targets             = Perform operation on all mountpoints
    gnu_rbind                   = Remount subtree and all submounts
    gnu_make_shared             = Mark mountpoint as shared
    gnu_make_slave              = Mark mountpoint as slave
    gnu_make_private            = Mark mountpoint as private
    gnu_make_unbindable         = Mark mountpoint as unbindable
    gnu_make_rshared            = Recursively mark as shared
    gnu_make_rslave             = Recursively mark as slave
    gnu_make_rprivate           = Recursively mark as private
    gnu_make_runbindable        = Recursively mark as unbindable
    gnu_move                    = Move a subtree to another position
    gnu_sloppy                  = Ignore mount options (for NFS mainly)
    bsd_async                   = All I/O should be done asynchronously
    bsd_current                 = When used with -u, change only currently specified options
    bsd_force                   = Force revocation of write access
    bsd_fstab                   = Use alternative fstab file
    bsd_late                    = Mark as late-mounted (don't mount until explicitly requested)
    bsd_noasync                 = Force I/O to be synchronous
    bsd_noatime                 = Don't update access time
    bsd_noauto                  = Can only be mounted explicitly
    bsd_noclusterr              = Disable read clustering
    bsd_noclusterw              = Disable write clustering
    bsd_nodev                   = Don't interpret character or block special devices
    bsd_noexec                  = Don't allow execution of binaries
    bsd_nosuid                  = Don't honor setuid/setgid bits
    bsd_nosymfollow             = Don't follow symlinks
    bsd_rdonly                  = Mount read-only
    bsd_sync                    = All I/O should be done synchronously
    bsd_suiddir                 = SUID bit on directory grants owner rights to files
    bsd_symfollow               = Follow symbolic links
    bsd_union                   = Mount as union
    bsd_update                  = Change status of already mounted filesystem
    bsd_options                 = Specify mount options
    bsd_read_only               = Mount read-only
    bsd_read_write              = Mount read-write
    bsd_types                   = Specify filesystem type(s)
    bsd_verbose                 = Verbose mode
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU mount
mount --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU mount
{
    Register-NativeCompleter -Name mount -Description $msg.mount -Parameters @(
        New-ParamCompleter -ShortName a -LongName all -Description $msg.gnu_all
        New-ParamCompleter -ShortName B -LongName bind -Description $msg.gnu_bind
        New-ParamCompleter -ShortName c -LongName no-canonicalize -Description $msg.gnu_no_canonicalize
        New-ParamCompleter -ShortName f -LongName fake -Description $msg.gnu_fake
        New-ParamCompleter -ShortName F -LongName fork -Description $msg.gnu_fork
        New-ParamCompleter -ShortName h -LongName help -Description $msg.gnu_help
        New-ParamCompleter -ShortName i -LongName internal-only -Description $msg.gnu_internal_only
        New-ParamCompleter -ShortName l -LongName show-labels -Description $msg.gnu_show_labels
        New-ParamCompleter -ShortName n -LongName no-mtab -Description $msg.gnu_no_mtab
        New-ParamCompleter -ShortName o -LongName options -Description $msg.gnu_options -Type List -VariableName 'opts'
        New-ParamCompleter -LongName options-mode -Description $msg.gnu_options_namespace -Arguments "ignore","append","prepend","replace" -VariableName 'mode'
        New-ParamCompleter -LongName options-source -Description $msg.gnu_options_source -Arguments "fstab","mtab","disable" -VariableName 'source'
        New-ParamCompleter -LongName options-source-force -Description $msg.gnu_options_source_force
        New-ParamCompleter -ShortName r -LongName read-only -Description $msg.gnu_read_only
        New-ParamCompleter -ShortName R -LongName rbind -Description $msg.gnu_rbind
        New-ParamCompleter -ShortName s -Description $msg.gnu_sloppy
        New-ParamCompleter -LongName source -Description $msg.gnu_source -Type Required -VariableName 'device'
        New-ParamCompleter -LongName target -Description $msg.gnu_target -Type Directory -VariableName 'dir'
        New-ParamCompleter -ShortName T -LongName fstab -Description $msg.gnu_fstab -Type File -VariableName 'file'
        New-ParamCompleter -ShortName t -LongName types -Description $msg.gnu_types -Type List -VariableName 'fstype'
        New-ParamCompleter -ShortName O -LongName test-opts -Description $msg.gnu_test_opts -Type List -VariableName 'opts'
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.gnu_verbose
        New-ParamCompleter -ShortName V -LongName version -Description $msg.gnu_version
        New-ParamCompleter -ShortName w -LongName rw -Description $msg.gnu_read_write
        New-ParamCompleter -LongName namespace -Description $msg.gnu_namespace -Type File -VariableName 'file'
        New-ParamCompleter -ShortName A -LongName all-targets -Description $msg.gnu_all_targets
        New-ParamCompleter -LongName make-shared -Description $msg.gnu_make_shared
        New-ParamCompleter -LongName make-slave -Description $msg.gnu_make_slave
        New-ParamCompleter -LongName make-private -Description $msg.gnu_make_private
        New-ParamCompleter -LongName make-unbindable -Description $msg.gnu_make_unbindable
        New-ParamCompleter -LongName make-rshared -Description $msg.gnu_make_rshared
        New-ParamCompleter -LongName make-rslave -Description $msg.gnu_make_rslave
        New-ParamCompleter -LongName make-rprivate -Description $msg.gnu_make_rprivate
        New-ParamCompleter -LongName make-runbindable -Description $msg.gnu_make_runbindable
        New-ParamCompleter -ShortName M -LongName move -Description $msg.gnu_move
    )
}
else # BSD mount
{
    Register-NativeCompleter -Name mount -Description $msg.mount -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.bsd_async
        New-ParamCompleter -ShortName d -Description $msg.bsd_nodev
        New-ParamCompleter -ShortName e -Description $msg.bsd_noexec
        New-ParamCompleter -ShortName F -Description $msg.bsd_fstab -Type File
        New-ParamCompleter -ShortName f -Description $msg.bsd_force
        New-ParamCompleter -ShortName l -Description $msg.bsd_late
        New-ParamCompleter -ShortName o -Description $msg.bsd_options -Type List
        New-ParamCompleter -ShortName r -Description $msg.bsd_read_only
        New-ParamCompleter -ShortName s -Description $msg.bsd_nosuid
        New-ParamCompleter -ShortName t -Description $msg.bsd_types -Type List -VariableName 'fstype'
        New-ParamCompleter -ShortName u -Description $msg.bsd_update
        New-ParamCompleter -ShortName v -Description $msg.bsd_verbose
        New-ParamCompleter -ShortName w -Description $msg.bsd_read_write
    )
}
