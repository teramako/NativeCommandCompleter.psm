<#
 # rsync completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    rsync                           = A fast, versatile, remote (and local) file-copying tool
    verbose                         = Increase verbosity
    info                            = Fine-grained informational verbosity
    debug                           = Fine-grained debug verbosity
    stderr                          = Change stderr handling
    quiet                           = Suppress non-error messages
    no_motd                         = Suppress daemon-mode MOTD
    checksum                        = Skip based on checksum, not mod-time & size
    archive                         = Archive mode; equals -rlptgoD (no -H,-A,-X)
    recursive                       = Recurse into directories
    relative                        = Use relative path names
    no_implied_dirs                 = Don't send implied dirs with --relative
    backup                          = Make backups (see --suffix & --backup-dir)
    backup_dir                      = Make backups into hierarchy based in DIR
    suffix                          = Backup suffix (default ~ w/o --backup-dir)
    update                          = Skip files that are newer on the receiver
    inplace                         = Update destination files in-place
    append                          = Append data onto shorter files
    append_verify                   = --append w/old data in file checksum
    dirs                            = Transfer directories without recursing
    mkpath                          = Create all missing path components of the destination path
    old_dirs                        = Works like --dirs when talking to old rsync
    old_args                        = Use old-style arg-splitting and quoting
    protect_args                    = No space-splitting; wildcard chars only
    secluded_args                   = Use the protocol to safely send the args w/o trans protection
    trust_sender                    = Trust the remote sender's file list
    links                           = Copy symlinks as symlinks
    copy_links                      = Transform symlink into referent file/dir
    copy_unsafe_links               = Only "unsafe" symlinks are transformed
    safe_links                      = Ignore symlinks that point outside the tree
    munge_links                     = Munge symlinks to make them safe & unusable
    copy_dirlinks                   = Transform symlink to dir into referent dir
    keep_dirlinks                   = Treat symlinked dir on receiver as dir
    hard_links                      = Preserve hard links
    perms                           = Preserve permissions
    executability                   = Preserve executability
    chmod                           = Affect file and/or directory permissions
    acls                            = Preserve ACLs (implies --perms)
    xattrs                          = Preserve extended attributes
    owner                           = Preserve owner (super-user only)
    group                           = Preserve group
    devices                         = Preserve device files (super-user only)
    specials                        = Preserve special files
    devicesAndSpecials              = "Same as --devices --specials"
    times                           = Preserve modification times
    atimes                          = Preserve access (use) times
    open_noatime                    = Avoid changing the atime on opened files
    crtimes                         = Preserve create times (newness)
    omit_dir_times                  = Omit directories from --times
    omit_link_times                 = Omit symlinks from --times
    super                           = Receiver attempts super-user activities
    fake_super                      = Store/recover privileged attrs using xattrs
    sparse                          = Turn sequences of nulls into sparse blocks
    preallocate                     = Allocate dest files before writing them
    copy_devices                    = Copy devices as normal files
    write_devices                   = Write to devices as files (implies --inplace)
    dry_run                         = Perform a trial run with no changes made
    whole_file                      = Copy files whole (w/o delta-xfer algorithm)
    checksum_choice                 = Choose the checksum algorithm
    one_file_system                 = Don't cross filesystem boundaries
    block_size                      = Force a fixed checksum block-size
    rsh                             = Specify the remote shell to use
    rsync_path                      = Specify the rsync to run on remote machine
    existing                        = Skip creating new files on receiver
    ignore_existing                 = Skip updating files that exist on receiver
    remove_source_files             = Sender removes synchronized files (non-dir)
    delete                          = Delete extraneous files from dest dirs
    delete_before                   = Receiver deletes before xfer, not during
    delete_during                   = Receiver deletes during the transfer
    delete_delay                    = Find deletions during, delete after
    delete_after                    = Receiver deletes after transfer, not during
    delete_excluded                 = Also delete excluded files from dest dirs
    ignore_missing_args             = Ignore missing source args without error
    delete_missing_args             = Delete missing source args from destination
    ignore_errors                   = Delete even if there are I/O errors
    force                           = Force deletion of dirs even if not empty
    max_delete                      = Don't delete more than NUM files
    max_size                        = Don't transfer any file larger than SIZE
    min_size                        = Don't transfer any file smaller than SIZE
    max_alloc                       = Change a limit relating to memory alloc
    partial                         = Keep partially transferred files
    partial_dir                     = Put a partially transferred file into DIR
    delay_updates                   = Put all updated files into place at end
    prune_empty_dirs                = Prune empty directory chains from file-list
    numeric_ids                     = Don't map uid/gid values by user/group name
    usermap                         = Custom username mapping
    groupmap                        = Custom groupname mapping
    chown                           = Simple username/groupname mapping
    timeout                         = Set I/O timeout in seconds
    contimeout                      = Set daemon connection timeout in seconds
    ignore_times                    = Don't skip files that match size and time
    size_only                       = Skip files that match in size
    modify_window                   = Set the accuracy for mod-time comparisons
    temp_dir                        = Create temporary files in directory DIR
    fuzzy                           = Find similar file for basis if no dest file
    compare_dest                    = Also compare destination files relative to DIR
    copy_dest                       = ... and include copies of unchanged files
    link_dest                       = Hardlink to files in DIR when unchanged
    compress                        = Compress file data during the transfer
    compress_choice                 = Choose the compression algorithm
    compress_level                  = Explicitly set compression level
    skip_compress                   = Skip compressing files with suffix in LIST
    cvs_exclude                     = Auto-ignore files in the same way CVS does
    filter                          = Add a file-filtering RULE
    exclude                         = Exclude files matching PATTERN
    exclude_from                    = Read exclude patterns from FILE
    include                         = Don't exclude files matching PATTERN
    include_from                    = Read include patterns from FILE
    files_from                      = Read list of source-file names from FILE
    from0                           = All *-from/filter files are delimited by 0s
    old_compress                    = Use the old compression method
    new_compress                    = Use the new compression method
    protect_args_long               = No space-splitting; only wildcard special-chars
    copy_as                         = Specify user & optional group for the copy
    address                         = Bind address for outgoing socket to daemon
    port                            = Specify double-colon alternate port number
    sockopts                        = Specify custom TCP options
    blocking_io                     = Use blocking I/O for the remote shell
    outbuf                          = Set out buffering to None, Line, or Block
    stats                           = Give some file-transfer stats
    8_bit_output                    = Leave high-bit chars unescaped in output
    human_readable                  = Output numbers in a human-readable format
    progress                        = Show progress during transfer
    partialAndProgress              = Same as --partial --progress
    itemize_changes                 = Output a change-summary for all updates
    remote_option                   = Send OPTION to the remote side only
    out_format                      = Output updates using the specified FORMAT
    log_file                        = Log what we're doing to the specified FILE
    log_file_format                 = Log updates using the specified FMT
    password_file                   = Read daemon-access password from FILE
    early_input                     = Use FILE for daemon's early exec input
    list_only                       = List the files instead of copying them
    bwlimit                         = Limit socket I/O bandwidth
    stop_after                      = Stop rsync after MINS minutes have elapsed
    stop_at                         = Stop rsync at the specified point in time
    fsync                           = Fsync every written file
    write_batch                     = Write a batched update to FILE
    only_write_batch                = Like --write-batch but w/o updating dest
    read_batch                      = Read a batched update from FILE
    protocol                        = Force an older protocol version to be used
    iconv                           = Request charset conversion of filenames
    checksum_seed                   = Set block/file checksum seed (advanced)
    ipv4                            = Prefer IPv4
    ipv6                            = Prefer IPv6
    version                         = Print version number
    help                            = Show this help
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$infoFlags = "backup", "copy", "del", "flist", "misc", "mount", "name", "nonreg", "progress", "remove", "skip", "stats", "symsafe", "none", "help"
$debugFlags = "acl", "backup", "bind", "chdir", "connect", "cmd", "del", "deltasum", "dup", "exit", "filter", "flist", "fuzzy", "genr", "hash",
              "hlink", "iconv", "io", "nstr", "own", "proto", "recv", "send", "time", "all", "none", "help"

Register-NativeCompleter -Name rsync -Description $msg.rsync -Parameters @(
    New-ParamCompleter -LongName help -Description $msg.help
    New-ParamCompleter -LongName version -Description $msg.version
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -LongName info -Description $msg.info -Type List -VariableName 'FLAG' -Arguments $infoFlags
    New-ParamCompleter -LongName debug -Description $msg.debug -Type List -VariableName 'FLAG' -Arguments $debugFlags
    New-ParamCompleter -LongName stderr -Description $msg.stderr -VariableName 'MODE' -Arguments "e","errors","a","all","c","client"
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -LongName no-motd -Description $msg.no_motd
    New-ParamCompleter -ShortName I -LongName ignore-times -Description $msg.ignore_times
    New-ParamCompleter -LongName size-only -Description $msg.size_only
    New-ParamCompleter -LongName modify-window -Description $msg.modify_window -Type Required -VariableName 'NUM'
    New-ParamCompleter -ShortName c -LongName checksum -Description $msg.checksum
    New-ParamCompleter -ShortName a -LongName archive -Description $msg.archive
    New-ParamCompleter -ShortName r -LongName recursive -Description $msg.recursive
    New-ParamCompleter -ShortName R -LongName relative -Description $msg.relative
    New-ParamCompleter -LongName no-implied-dirs -Description $msg.no_implied_dirs
    New-ParamCompleter -ShortName b -LongName backup -Description $msg.backup
    New-ParamCompleter -LongName backup-dir -Description $msg.backup_dir -Type Directory -VariableName 'DIR'
    New-ParamCompleter -LongName suffix -Description $msg.suffix -Type Required -VariableName 'SUFFIX'
    New-ParamCompleter -ShortName u -LongName update -Description $msg.update
    New-ParamCompleter -LongName inplace -Description $msg.inplace
    New-ParamCompleter -LongName append -Description $msg.append
    New-ParamCompleter -LongName append-verify -Description $msg.append_verify
    New-ParamCompleter -ShortName d -LongName dirs -Description $msg.dirs
    New-ParamCompleter -LongName old-dirs, old-d -Description $msg.old_dirs
    New-ParamCompleter -LongName mkpath -Description $msg.mkpath
    New-ParamCompleter -ShortName l -LongName links -Description $msg.links
    New-ParamCompleter -ShortName L -LongName copy-links -Description $msg.copy_links
    New-ParamCompleter -LongName copy-unsafe-links -Description $msg.copy_unsafe_links
    New-ParamCompleter -LongName safe-links -Description $msg.safe_links
    New-ParamCompleter -LongName munge-links -Description $msg.munge_links
    New-ParamCompleter -ShortName k -LongName copy-dirlinks -Description $msg.copy_dirlinks
    New-ParamCompleter -ShortName K -LongName keep-dirlinks -Description $msg.keep_dirlinks
    New-ParamCompleter -ShortName H -LongName hard-links -Description $msg.hard_links
    New-ParamCompleter -ShortName p -LongName perms -Description $msg.perms
    New-ParamCompleter -ShortName E -LongName executability -Description $msg.executability
    New-ParamCompleter -ShortName A -LongName acls -Description $msg.acls
    New-ParamCompleter -ShortName X -LongName xattrs -Description $msg.xattrs
    New-ParamCompleter -LongName chmod -Description $msg.chmod -Type Required -VariableName 'CHMOD'
    New-ParamCompleter -ShortName o -LongName owner -Description $msg.owner
    New-ParamCompleter -ShortName g -LongName group -Description $msg.group
    New-ParamCompleter -LongName devices -Description $msg.devices
    New-ParamCompleter -LongName specials -Description $msg.specials
    New-ParamCompleter -ShortName D -Description $msg.devicesAndSpecials
    New-ParamCompleter -LongName copy-devices -Description $msg.copy_devices
    New-ParamCompleter -LongName write-devices -Description $msg.write_devices
    New-ParamCompleter -ShortName t -LongName times -Description $msg.times
    New-ParamCompleter -ShortName U -LongName atimes -Description $msg.atimes
    New-ParamCompleter -LongName open-noatime -Description $msg.open_noatime
    New-ParamCompleter -ShortName N -LongName crtimes -Description $msg.crtimes
    New-ParamCompleter -ShortName O -LongName omit-dir-times -Description $msg.omit_dir_times
    New-ParamCompleter -ShortName J -LongName omit-link-times -Description $msg.omit_link_times
    New-ParamCompleter -LongName super -Description $msg.super
    New-ParamCompleter -LongName fake-super -Description $msg.fake_super
    New-ParamCompleter -ShortName S -LongName sparse -Description $msg.sparse
    New-ParamCompleter -LongName preallocate -Description $msg.preallocate
    New-ParamCompleter -ShortName n -LongName dry-run -Description $msg.dry_run
    New-ParamCompleter -ShortName W -LongName whole-file -Description $msg.whole_file
    New-ParamCompleter -LongName checksum-choice -Description $msg.checksum_choice -Type List -VariableName 'STR' -Arguments "auto","xxh128","xxh3","xxh64","md5","md4","sha1","none"
    New-ParamCompleter -ShortName x -LongName one-file-system -Description $msg.one_file_system
    New-ParamCompleter -LongName ignore-non-existing, existing -Description $msg.existing
    New-ParamCompleter -LongName ignore-existing -Description $msg.ignore_existing
    New-ParamCompleter -LongName remove-source-files -Description $msg.remove_source_files
    New-ParamCompleter -LongName delete -Description $msg.delete
    New-ParamCompleter -LongName delete-before -Description $msg.delete_before
    New-ParamCompleter -LongName delete-during, del -Description $msg.delete_during
    New-ParamCompleter -LongName delete-delay -Description $msg.delete_delay
    New-ParamCompleter -LongName delete-after -Description $msg.delete_after
    New-ParamCompleter -LongName delete-excluded -Description $msg.delete_excluded
    New-ParamCompleter -LongName ignore-missing-args -Description $msg.ignore_missing_args
    New-ParamCompleter -LongName delete-missing-args -Description $msg.delete_missing_args
    New-ParamCompleter -LongName ignore-errors -Description $msg.ignore_errors
    New-ParamCompleter -LongName force -Description $msg.force
    New-ParamCompleter -LongName max-delete -Description $msg.max_delete -Type Required -VariableName 'NUM'
    New-ParamCompleter -LongName max-size -Description $msg.max_size -Type Required -VariableName 'SIZE'
    New-ParamCompleter -LongName min-size -Description $msg.min_size -Type Required -VariableName 'SIZE'
    New-ParamCompleter -LongName max-alloc -Description $msg.max_alloc -Type Required -VariableName 'SIZE'
    New-ParamCompleter -ShortName B -LongName block-size -Description $msg.block_size -Type Required -VariableName 'SIZE'
    New-ParamCompleter -ShortName e -LongName rsh -Description $msg.rsh -Type Required -VariableName 'COMMAND'
    New-ParamCompleter -LongName rsync-path -Description $msg.rsync_path -Type Required -VariableName 'PROGRAM'
    New-ParamCompleter -ShortName M -LongName remote-option -Description $msg.remote_option -Type Required -VariableName 'OPTION'
    New-ParamCompleter -ShortName C -LongName cvs-exclude -Description $msg.cvs_exclude
    New-ParamCompleter -ShortName f -LongName filter -Description $msg.filter -Type Required -VariableName 'RULE'
    New-ParamCompleter -ShortName F -Type Required -VariableName 'RULE'
    New-ParamCompleter -LongName exclude -Description $msg.exclude -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -LongName exclude-from -Description $msg.exclude_from -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName include -Description $msg.include -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -LongName include-from -Description $msg.include_from -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName files-from -Description $msg.files_from -Type File -VariableName 'FILE'
    New-ParamCompleter -ShortName '0' -LongName from0 -Description $msg.from0
    New-ParamCompleter -LongName old-args -Description $msg.old_args
    New-ParamCompleter -LongName secluded-args -Description $msg.secluded_args
    New-ParamCompleter -ShortName s -LongName protect-args -Description $msg.protect_args
    New-ParamCompleter -LongName trust-sender -Description $msg.trust_sender
    New-ParamCompleter -LongName copy-as -Description $msg.copy_as -Type Required -VariableName 'USER[:GROUP]'
    New-ParamCompleter -ShortName T -LongName temp-dir -Description $msg.temp_dir -Type Directory -VariableName 'DIR'
    New-ParamCompleter -ShortName y -LongName fuzzy -Description $msg.fuzzy
    New-ParamCompleter -LongName compare-dest -Description $msg.compare_dest -Type Directory -VariableName 'DIR'
    New-ParamCompleter -LongName copy-dest -Description $msg.copy_dest -Type Directory -VariableName 'DIR'
    New-ParamCompleter -LongName link-dest -Description $msg.link_dest -Type Directory -VariableName 'DIR'
    New-ParamCompleter -ShortName z -LongName compress -Description $msg.compress
    New-ParamCompleter -LongName old-compress -Description $msg.old_compress
    New-ParamCompleter -LongName new-compress -Description $msg.new_compress
    New-ParamCompleter -LongName compress-choice, zc -Description $msg.compress_choice -Type Required -VariableName 'STR' -Arguments "zstd","lz4","zlibx","zlib","none"
    New-ParamCompleter -LongName compress-level, zl -Description $msg.compress_level -Type Required -VariableName 'NUM'
    New-ParamCompleter -LongName skip-compress -Description $msg.skip_compress -Type Required -VariableName 'LIST'
    New-ParamCompleter -LongName numeric-ids -Description $msg.numeric_ids
    New-ParamCompleter -LongName usermap -Description $msg.usermap -Type Required -VariableName 'STRING'
    New-ParamCompleter -LongName groupmap -Description $msg.groupmap -Type Required -VariableName 'STRING'
    New-ParamCompleter -LongName chown -Description $msg.chown -Type Required -VariableName 'USER:GROUP'
    New-ParamCompleter -LongName timeout -Description $msg.timeout -Type Required -VariableName 'SECONDS'
    New-ParamCompleter -LongName contimeout -Description $msg.contimeout -Type Required -VariableName 'SECONDS'
    New-ParamCompleter -LongName address -Description $msg.address -Type Required -VariableName 'ADDRESS'
    New-ParamCompleter -LongName port -Description $msg.port -Type Required -VariableName 'PORT'
    New-ParamCompleter -LongName sockopts -Description $msg.sockopts -Type Required -VariableName 'OPTIONS'
    New-ParamCompleter -LongName blocking-io -Description $msg.blocking_io
    New-ParamCompleter -LongName outbuf -Description $msg.outbuf -Type Required -VariableName 'MODE' -Arguments "n","none","l","line","b","block"
    New-ParamCompleter -ShortName i -LongName itemize-changes -Description $msg.itemize_changes
    New-ParamCompleter -LongName out-format -Description $msg.out_format -Type Required -VariableName 'FORMAT'
    New-ParamCompleter -LongName log-file -Description $msg.log_file -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName log-file-format -Description $msg.log_file_format -Type Required -VariableName 'FMT'
    New-ParamCompleter -LongName stats -Description $msg.stats
    New-ParamCompleter -ShortName '8' -LongName '8-bit-output' -Description $msg.'8_bit_output'
    New-ParamCompleter -ShortName h -LongName human-readable -Description $msg.human_readable
    New-ParamCompleter -LongName partial -Description $msg.partial
    New-ParamCompleter -LongName partial-dir -Description $msg.partial_dir -Type Directory -VariableName 'DIR'
    New-ParamCompleter -LongName delay-updates -Description $msg.delay_updates
    New-ParamCompleter -ShortName m -LongName prune-empty-dirs -Description $msg.prune_empty_dirs
    New-ParamCompleter -LongName progress -Description $msg.progress
    New-ParamCompleter -ShortName P -Description $msg.partialAndProgress
    New-ParamCompleter -LongName password-file -Description $msg.password_file -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName early-input -Description $msg.early_input -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName list-only -Description $msg.list_only
    New-ParamCompleter -LongName bwlimit -Description $msg.bwlimit -Type Required -VariableName 'RATE'
    New-ParamCompleter -LongName stop-after -Description $msg.stop_after -Type Required -VariableName 'MINS'
    New-ParamCompleter -LongName stop-at -Description $msg.stop_at -Type Required -VariableName 'y-m-dTh:m'
    New-ParamCompleter -LongName fsync -Description $msg.fsync
    New-ParamCompleter -LongName write-batch -Description $msg.write_batch -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName only-write-batch -Description $msg.only_write_batch -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName read-batch -Description $msg.read_batch -Type File -VariableName 'FILE'
    New-ParamCompleter -LongName protocol -Description $msg.protocol -Type Required -VariableName 'NUM'
    New-ParamCompleter -LongName iconv -Description $msg.iconv -Type List -VariableName 'CONVERT_SPEC'
    New-ParamCompleter -ShortName '4' -LongName ipv4 -Description $msg.ipv4
    New-ParamCompleter -ShortName '6' -LongName ipv6 -Description $msg.ipv6
    New-ParamCompleter -LongName checksum-seed -Description $msg.checksum_seed -Type Required -VariableName 'NUM'
)
