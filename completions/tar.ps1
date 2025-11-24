<#
  tar completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    catenate                   = Append archive to archive
    create                     = Create archive
    diff                       = Compare archive and filesystem
    delete                     = Delete from archive
    append                     = Append files to archive
    list                       = List archive
    test_label                 = Test the archive volume label
    update                     = Append new files
    extract                    = Extract from archive
    show_defaults              = Show built-in defaults for various tar options
    help                       = Display short option summary
    usage                      = List available options
    version                    = Print program version and copyright information
    check_device               = Check device numbers when creating incremental archives
    listed_incremental         = Handle new GNU-format incremental backups
    hole_detection             = Use METHOD to detect holes in sparse files
    incremental                = Use old incremental GNU format
    ignore_failed_read         = Do not exit with nonzero on unreadable files
    level                      = Set dump level for a created listed-incremental archive
    seek                       = Assume the archive is seekable
    no_check_device            = Do not check device numbers when creating incremental archives
    no_seek                    = Assume the archive is not seekable
    occurrence                 = Process only the Nth occurrence of each file in the archive
    restrict                   = Disable the use of some potentially harmful options
    sparse_version             = Set which version of the sparse format to use
    sparse                     = Handle sparse files
    keep_old_files             = Don't overwrite
    keep_newer_files           = Don't replace existing files that are newer
    keep_directory_symlink     = Don't replace existing symlinks
    no_overwrite_dir           = Preserve metadata of existing directories
    one_top_level              = Extract into directory
    overwrite                  = Overwrite existing files when extracting
    overwrite_dir              = Overwrite metadata of existing directories
    recursive_unlink           = Recursively remove all files in the directory prior to extracting it
    remove_files               = Remove files after adding to archive
    skip_old_files             = Don't replace existing files when extracting
    unlink_first               = Remove each file prior to extracting over it
    verify                     = Verify archive
    ignore_command_error       = Ignore subprocess exit codes
    no_ignore_command_error    = Treat non-zero exit codes of children as error
    to_stdout                  = Extract to stdout
    to_command                 = Pipe extracted files to COMMAND
    atime_preserve             = Keep access time
    delay_directory_restore    = Delay setting modification times
    group                      = Force NAME as group for added files
    group_map                  = Read group translation map from FILE
    mode                       = Force symbolic mode CHANGES for added files
    mtime                      = Set mtime for added files
    touch                      = Don't extract modification time
    no_delay_directory_restore = Cancel the effect of the prior --delay-directory-restore
    no_same_owner              = Extract files as yourself
    no_same_permissions        = Apply the user's umask when extracting
    numeric_owner              = Always use numbers for user/group names
    owner                      = Force NAME as owner for added files
    owner_map                  = Read owner translation map from FILE
    same_permissions           = Extract all permissions
    same_owner                 = Try extracting files with the same ownership
    same_order                 = Do not sort file arguments
    sort                       = Sort directory entries according to ORDER
    acls                       = Enable POSIX ACLs support
    no_acls                    = Disable POSIX ACLs support
    selinux                    = Enable SELinux context support
    no_selinux                 = Disable SELinux context support
    xattrs                     = Enable extended attributes support
    no_xattrs                  = Disable extended attributes support
    xattrs_exclude             = Specify the exclude pattern for xattr keys
    xattrs_include             = Specify the include pattern for xattr keys
    file                       = Archive file
    force_local                = Archive file is local
    info_script                = Run script at end of tape
    tape_length                = Tape length
    multi_volume               = Multi volume archive
    rmt_command                = Use COMMAND instead of rmt
    rsh_command                = Use COMMAND instead of rsh
    volno_file                 = keep track of which volume of a multi-volume archive it is working in FILE
    blocking_factor            = Set record size to BLOCKSx512 bytes
    read_full_records          = Reblock while reading
    ignore_zeros               = Ignore zero block in archive
    record_size                = Set record size
    format                     = Create archive of the given format
    format_gnu                 = GNU tar 1.13.x format
    format_oldgnu              = GNU format as per tar <= 1.12
    format_pax                 = POSIX 1003.1-2001 (pax) format
    format_posix               = POSIX 1003.1-2001 (pax) format
    format_utar                = POSIX 1003.1-1988 (ustar) format
    format_v7                  = Old V7 tar format
    old_archive                = Same as --format=v7
    pax_option                 = Control pax keywords
    posix                      = Same as --format=posix
    auto_compress              = Use archive suffix to determine the compression program
    use_compress_program       = Filter through specified program
    bzip2                      = Filter through bzip2
    xz                         = Filter through xz
    lzip                       = Filter through lzip
    lzma                       = Filter through lzma
    lzop                       = Filter through lzop
    no_auto_compress           = Do not use archive suffix to determine the compression program
    gzip                       = Filter through gzip
    compress                   = Filter through compress
    zstd                       = Filter through zstd
    add_file                   = Add to the archive
    backup                     = Backup before removal
    backup_none                = Never make backups
    backup_t                   = Make numbered backups
    backup_nil                 = Make numbered backups if numbered backups exist, simple backups otherwise.
    backup_never               = Always make simple backups
    directory                  = Change directory
    exclude                    = Exclude file
    exclude_backups            = Exclude backups and lock files
    exclude_caches             = Exclude contents of directories containing file CACHEDIR.TAG
    exclude_caches_all         = Exclude directories containing file CACHEDIR.TAG
    exclude_caches_under       = Exclude everything under directories containing CACHEDIR.TAG
    exclude_ignore             = Exclude patterns from the file
    exclude_ignore_recursive   = Similer to --exclude-ignore=FILE, but affect to subdirectories
    exclude_tag                = Exclude contents of directories containing the file, except itself
    exclude_tag_all            = Exclude directories containing the file.
    exclude_tag_under          = Exclude everything under directories containing the file
    exclude_vcs                = Exclude VCS directories
    exclude_vcs_ignore         = Exclude files reading from VCS-specific ignore files
    dereference                = Follow symlinks
    hard_dereference           = Follow hard links
    starting_file              = Starting file in archive
    newer                      = Only store newer files
    newer_mtime                = Only store newer files
    null                       = -T has null-terminated names
    no_null                    = Disable previous --null option
    recursion                  = Recurse into directories (default)
    no_recursion               = Avoid descending automatically in directories
    unquote                    = Unquote file or member names (default)
    no_unquote                 = Don't unquote
    one_file_system            = Stay in local filesystem
    absolute_names             = Don't strip leading /
    suffix                     = Set backup file suffix
    files_from                 = Extract file from file
    exclude_from               = Exclude files listed in specified file
    checkpoint                 = Display progress messages
    block_number               = Show block number
    totals                     = Print total bytes written
    utc                        = Print mtime in UTC
    verbose                    = Verbosely list files processed
    confirmation               = Ask for confirmation
    anchored                   = Patterns match file name start
    ignore_case                = Ignore case
    wildcards                  = Use wildcards
    wildcards_match_slash      = Wildcards match /
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name tar -Parameters @(
    ## Operation mode
    New-ParamCompleter -ShortName A -LongName catenate, concatenate -Description $msg.catenate
    New-ParamCompleter -ShortName c -LongName create -Description $msg.create
    New-ParamCompleter -ShortName d -LongName diff, compare -Description $msg.diff
    New-ParamCompleter -LongName delete -Description $msg.delete
    New-ParamCompleter -ShortName r -LongName append -Description $msg.append
    New-ParamCompleter -ShortName t -LongName list -Description $msg.list
    New-ParamCompleter -LongName test-label -Description $msg.test_label
    New-ParamCompleter -ShortName u -LongName update -Description $msg.update
    New-ParamCompleter -ShortName x -LongName extract, get -Description $msg.extract
    New-ParamCompleter -LongName show-defaults -Description $msg.show_defaults
    New-ParamCompleter -ShortName '?' -LongName help -Description $msg.help
    New-ParamCompleter -LongName usage -Description $msg.usage
    New-ParamCompleter -LongName version -Description $msg.version

    ## Operation modifiers
    New-ParamCompleter -LongName check-device -Description $msg.check_device
    New-ParamCompleter -ShortName g -LongName listed-incremental -Description $msg.listed_incremental -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName hole-detection -Description $msg.hole_detection -Arguments "seek", "raw" -VariableName 'METHOD'
    New-ParamCompleter -ShortName G -LongName incremental -Description $msg.incremental
    New-ParamCompleter -LongName ignore-failed-read -Description $msg.ignore_failed_read
    New-ParamCompleter -LongName level -Description $msg.level -Arguments "0" -VariableName 'NUMBER'
    New-ParamCompleter -ShortName n -LongName seek -Description $msg.seek
    New-ParamCompleter -LongName no-check-device -Description $msg.no_check_device
    New-ParamCompleter -LongName no-seek -Description $msg.no_seek
    New-ParamCompleter -LongName occurrence -Description $msg.occurrence -Type FlagOrValue -VariableName 'N'
    New-ParamCompleter -LongName restrict -Description $msg.restrict
    New-ParamCompleter -LongName sparse-version -Description $msg.sparse_version -Arguments "0.0", "0.1", "1.0" -VariableName 'MAJOR[.MINOR]'
    New-ParamCompleter -ShortName S -LongName sparse -Description $msg.sparse

    ## Overwrite control
    New-ParamCompleter -ShortName k -LongName keep-old-files -Description $msg.keep_old_files
    New-ParamCompleter -LongName keep-newer-files -Description $msg.keep_newer_files
    New-ParamCompleter -LongName keep-directory-symlink -Description $msg.keep_directory_symlink
    New-ParamCompleter -LongName no-overwrite-dir -Description $msg.no_overwrite_dir
    New-ParamCompleter -LongName one-top-level -Description $msg.one_top_level -Type FlagOrValue -VariableName 'DIR'
    New-ParamCompleter -LongName overwrite -Description $msg.overwrite
    New-ParamCompleter -LongName overwrite-dir -Description $msg.overwrite_dir
    New-ParamCompleter -LongName recursive-unlink -Description $msg.recursive_unlink
    New-ParamCompleter -LongName remove-files -Description $msg.remove_files
    New-ParamCompleter -LongName skip-old-files -Description $msg.skip_old_files
    New-ParamCompleter -ShortName U -LongName unlink-first -Description $msg.unlink_first
    New-ParamCompleter -ShortName W -LongName verify -Description $msg.verify

    ## Output stream selection
    New-ParamCompleter -LongName ignore-command-error -Description $msg.ignore_command_error
    New-ParamCompleter -LongName no-ignore-command-error -Description $msg.no_ignore_command_error
    New-ParamCompleter -ShortName O -LongName to-stdout -Description $msg.to_stdout
    New-ParamCompleter -LongName to-command -Description $msg.to_command -Type Required -VariableName 'COMMAND'

    ## Handling of file attributes
    New-ParamCompleter -LongName atime-preserve -Description $msg.atime_preserve -Type FlagOrValue -Arguments "replace", "system" -VariableName 'METHOD'
    New-ParamCompleter -LongName delay-directory-restore -Description $msg.delay_directory_restore
    New-ParamCompleter -LongName group -Description $msg.group -Type Required -VariableName 'NAME[:GID]'
    New-ParamCompleter -LongName group-map -Description $msg.group_map -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName mode -Description $msg.mode -Type Required -VariableName 'CHANGES'
    New-ParamCompleter -LongName mtime -Description $msg.mtime -Type Required -VariableName 'DATE-OR-FILE'
    New-ParamCompleter -ShortName m -LongName touch -Description $msg.touch
    New-ParamCompleter -LongName no-delay-directory-restore -Description $msg.no_delay_directory_restore
    New-ParamCompleter -LongName no-same-owner -Description $msg.no_same_owner
    New-ParamCompleter -LongName no-same-permissions -Description $msg.no_same_permissions
    New-ParamCompleter -LongName numeric-owner -Description $msg.numeric_owner
    New-ParamCompleter -LongName owner -Description $msg.owner -Type Required -VariableName 'NAME[:UID]'
    New-ParamCompleter -LongName owner-map -Description $msg.owner_map -Type File -VariableName 'FILE'
    New-ParamCompleter -ShortName p -LongName same-permissions, preserve-permissions -Description $msg.same_permissions
    New-ParamCompleter -LongName same-owner -Description $msg.same_owner
    New-ParamCompleter -ShortName s -LongName same-order, preserve-order -Description $msg.same_order
    New-ParamCompleter -LongName sort -Description $msg.sort -Arguments "none","name","inode" -VariableName 'ORDER'

    ## Extended file attributes
    New-ParamCompleter -LongName acls -Description $msg.acls
    New-ParamCompleter -LongName no-acls -Description $msg.no_acls
    New-ParamCompleter -LongName selinux -Description $msg.selinux
    New-ParamCompleter -LongName no-selinux -Description $msg.no_selinux
    New-ParamCompleter -LongName xattrs -Description $msg.xattrs
    New-ParamCompleter -LongName no-xattrs -Description $msg.no_xattrs
    New-ParamCompleter -LongName xattrs-exclude -Description $msg.xattrs_exclude -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -LongName xattrs-include -Description $msg.xattrs_include -Type Required -VariableName 'PATTERN'

    ## Device selection and switching
    New-ParamCompleter -ShortName f -LongName file -Description $msg.file -Type File -VariableName 'ARCHIVE'
    New-ParamCompleter -LongName force-local -Description $msg.force_local -Type Required
    New-ParamCompleter -ShortName F -LongName info-script, new-volume-script -Description $msg.info_script -Type Required -VariableName 'COMMAND'
    New-ParamCompleter -ShortName L -LongName tape-length -Description $msg.tape_length -Type Required -VariableName 'N'
    New-ParamCompleter -ShortName M -LongName multi-volume -Description $msg.multi_volume
    New-ParamCompleter -LongName rmt-command -Description $msg.rmt_command -Type Required -VariableName 'COMMAND'
    New-ParamCompleter -LongName rsh-command -Description $msg.rsh_command -Type Required -VariableName 'COMMAND'
    New-ParamCompleter -LongName volno-file -Description $msg.volno_file -Type Required -VariableName 'FILE'

    ## Device blocking
    New-ParamCompleter -ShortName b -LongName blocking-factor -Description $msg.blocking_factor -Type Required -VariableName 'BLOCKS'
    New-ParamCompleter -ShortName B -LongName read-full-records -Description $msg.read_full_records
    New-ParamCompleter -ShortName i -LongName ignore-zeros -Description $msg.ignore_zeros
    New-ParamCompleter -LongName record-size -Description $msg.record_size -Type Required -VariableName 'NUMBER'

    ## Archive format selection
    New-ParamCompleter -ShortName H -LongName format -Description $msg.format -Type Required -Arguments @(
        "gnu`t{0}" -f $msg.format_gnu
        "oldgnu`t{0}" -f $msg.format_oldgnu
        "pax`t{0}" -f $msg.format_pax
        "posix`t{0}" -f $msg.format_posix
        "ustar`t{0}" -f $msg.format_utar
        "v7`t{0}" -f $msg.format_v7
    ) -VariableName 'FORMAT'
    New-ParamCompleter -LongName old-archive, portability -Description $msg.old_archive
    New-ParamCompleter -LongName pax-option -Description $msg.pax_option -Type Required -VariableName 'keyword[[:]=value]'
    New-ParamCompleter -LongName posix -Description $msg.posix
    New-ParamCompleter -ShortName V -LongName label -Description "Set volume name" -Type Required

    ## Compression options
    New-ParamCompleter -ShortName a -LongName auto-compress -Description $msg.auto_compress
    New-ParamCompleter -ShortName I -LongName use-compress-program -Description $msg.use_compress_program -Type Required -VariableName 'COMMAND'
    New-ParamCompleter -ShortName j -LongName bzip2 -Description $msg.bzip2
    New-ParamCompleter -ShortName J -LongName xz -Description $msg.xz
    New-ParamCompleter -LongName lzip -Description $msg.lzip
    New-ParamCompleter -LongName lzma -Description $msg.lzma
    New-ParamCompleter -LongName lzop -Description $msg.lzop
    New-ParamCompleter -LongName no-auto-compress -Description $msg.no_auto_compress
    New-ParamCompleter -ShortName z -LongName gzip, gunzip, ungzip -Description $msg.gzip
    New-ParamCompleter -ShortName Z -LongName compress, uncompress -Description $msg.compress
    New-ParamCompleter -LongName zstd -Description $msg.zstd

    ## Local file selection
    New-ParamCompleter -LongName add-file -Description $msg.add_file -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName backup -Description $msg.backup -Type FlagOrValue -Arguments @(
        "none`t{0}" -f $msg.backup_none
        "off`t{0}" -f $msg.backup_none
        "t`t{0}" -f $msg.backup_t
        "numbered`t{0}" -f $msg.backup_t
        "nil`t{0}" -f $msg.backup_nil
        "existing`t{0}" -f $msg.backup_nil
        "never`t{0}" -f $msg.backup_never
        "simple`t{0}" -f $msg.backup_nver
    ) -VariableName 'CONTROL'
    New-ParamCompleter -ShortName C -LongName directory -Description $msg.directory -Type Directory -VariableName 'DIR'
    New-ParamCompleter -LongName exclude -Description $msg.exclude -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -LongName exclude-backups -Description $msg.exclude_backups
    New-ParamCompleter -LongName exclude-caches -Description $msg.exclude_caches
    New-ParamCompleter -LongName exclude-caches-all -Description $msg.exclude_caches_all
    New-ParamCompleter -LongName exclude-caches-under -Description $msg.exclude_caches_under
    New-ParamCompleter -LongName exclude-ignore -Description $msg.exclude_ignore -Type Required -VariableName 'FILE'
    New-ParamCompleter -LongName exclude-ignore-recursive -Description $msg.exclude_ignore_recursive -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName exclude-tag -Description $msg.exclude_tag -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName exclude-tag-all -Description $msg.exclude_tag_all -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName exclude-tag-under -Description $msg.exclude_tag_under -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName exclude-vcs -Description $msg.exclude_vcs
    New-ParamCompleter -LongName exclude-vcs-ignore -Description $msg.exclude_vcs_ignore
    New-ParamCompleter -ShortName h -LongName dereference -Description $msg.dereference
    New-ParamCompleter -LongName hard-dereference -Description $msg.hard_dereference
    New-ParamCompleter -ShortName K -LongName starting-file -Description $msg.starting_file -Type Required -VariableName 'MEMBER'
    New-ParamCompleter -LongName newer-mtime -Description $msg.newer_mtime -Type Required -VariableName 'DATE'
    New-ParamCompleter -LongName no-null -Description $msg.no_null
    New-ParamCompleter -LongName no-recursion -Description $msg.no_recursion
    New-ParamCompleter -LongName no-unquote -Description $msg.no_unquote
    New-ParamCompleter -LongName null -Description $msg.null
    New-ParamCompleter -ShortName N -LongName newer, after-date -Description $msg.newer -Type Required -VariableName 'DATE'
    New-ParamCompleter -LongName one-file-system -Description $msg.one_file_system
    New-ParamCompleter -ShortName P -LongName absolute-names -Description $msg.absolute_names
    New-ParamCompleter -LongName recursion -Description $msg.recursion
    New-ParamCompleter -LongName suffix -Description $msg.suffix -Type Required -VariableName 'STRING'
    New-ParamCompleter -ShortName T -LongName files-from -Description $msg.files_from -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName unquote -Description $msg.unquote
    New-ParamCompleter -ShortName X -LongName exclude-from -Description $msg.exclude_from -Type File -VariableName 'FILE'

    ## File name transformations
    # TBD

    ## File name matching options
    New-ParamCompleter -LongName anchored -Description $msg.anchored
    New-ParamCompleter -LongName ignore-case -Description $msg.ignore_case
    New-ParamCompleter -LongName wildcards -Description $msg.wildcards
    New-ParamCompleter -LongName wildcards-match-slash -Description $msg.wildcards_match_slash
    # TBD

    ## Informative output
    New-ParamCompleter -LongName checkpoint -Description $msg.checkpoint -Type FlagOrValue -VariableName 'N'
    New-ParamCompleter -ShortName R -LongName block-number -Description $msg.block_number
    New-ParamCompleter -LongName totals -Description $msg.totals -Type FlagOrValue -Arguments "SIGHUP","SIGQUIT","SIGINT","SIGUSR1","SIGUSR2" -VariableName 'SIGNAL'
    New-ParamCompleter -LongName utc -Description $msg.utc
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -ShortName w -LongName interactive, confirmation -Description "Ask for confirmation"
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    $params = $this.BoundParameters
    if ($params.ContainsKey('create') -or
        $params.ContainsKey('append') -or
        $params.ContainsKey('update') -or
        $params.ContainsKey('catenate'))
    {
        return [MT.Comp.Helper]::CompleteFilename($this, $false, $false)
    }
    $file = $params.file
    if ($file.Count -eq 1 -and (Test-Path -LiteralPath $file -PathType Leaf))
    {
        if ($params.ContainsKey('delete') -or
            $params.ContainsKey('list') -or
            $params.ContainsKey('extract'))
        {
            tar -atf $file | ForEach-Object {
                "{0} `tArchived file" -f $_;
            }
        }
    }
}
