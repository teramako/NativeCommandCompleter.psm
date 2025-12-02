<#
 # cp completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu_archive                = Same as -dpR
    gnu_attributesOnly         = Copy just the attributes
    gnu_backup                 = Make backup of each existing destination file
    gnu_backup_none            = Never make backups
    gnu_backup_numbered        = Make numbered backups
    gnu_backup_existing        = Numbered backups if any exist, else simple
    gnu_backup_simple          = Make simple backups
    gnu_short_backup           = Make backup of each existing destination file
    gnu_copyContents           = Copy contents of special files when recursive
    gnu_short_d                = Same as --no-dereference --preserve=links
    gnu_force                  = Do not prompt before overwriting
    gnu_interactive            = Prompt before overwrite
    gnu_short_H                = Follow command-line symbolic links
    gnu_link                   = Link files instead of copying
    gnu_stripTrailingSlashes   = Remove trailing slashes from source
    gnu_suffix                 = Backup suffix
    gnu_targetDirectory        = Target directory
    gnu_short_update           = Equivalent to --update[=older]
    gnu_update                 = Do not overwrite newer files
    gnu_verbose                = Verbose mode
    gnu_help                   = Display help and exit
    gnu_version                = Display version and exit
    gnu_dereference            = Always follow symbolic links
    gnu_noClobber              = Do not overwrite an existing file
    gnu_noDereference          = Never follow symbolic links
    gnu_short_p                = Same as --preserve=mode,ownership,timestamps
    gnu_preserve               = Preserve ATTRIBUTES if possible
    gnu_noPreserve             = Don't preserve ATTRIBUTES
    gnu_parents                = Use full source file name under DIRECTORY
    gnu_recursive              = Copy directories recursively
    gnu_reflink                = Control clone/CoW copies
    gnu_removeDestination      = First remove existing destination files
    gnu_sparse                 = Control creation of sparse files
    gnu_symbolicLink           = Make symbolic links instead of copying
    gnu_noTargetDirectory      = Treat DEST as a normal file
    gnu_oneFileSystem          = Stay on this file system
    gnu_short_Z                = Set SELinux context of copy to default type
    gnu_context                = Set SELinux context of copy to CONTEXT
    gnu_attrList_mode          = Permissions (including any ACL and xattr permissions)
    gnu_attrList_ownership     = User and group
    gnu_attrList_timestamps    = File timestamps
    gnu_attrList_links         = Hard links
    gnu_attrList_context       = Security context
    gnu_attrList_xattr         = Extended attributes
    gnu_attrList_all           = All attributes
    gnu_update_older           = Files being replaced if they're older than the corresponding source file
    gnu_update_none            = Similar to the --no-clobber option, but no failure
    gnu_update_all             = All existing files in the destination being replaced (default)
    gnu_reflink_always         = Perform a lightweight copy, where the data blocks are copied only when modified
    gnu_reflink_auto           = Attempt lightweight copy, if failed, fall back to a standard copy
    gnu_reflink_never          = Ensure a standard copy is performed
    gnu_sparse_always          = Create a sparse DEST file whenever the SOURCE file contains a long enough sequence of zero bytes
    gnu_sparse_auto            = Detected by a crude heuristic and the corresponding DEST file is made sparse as well
    gnu_sparse_never           = Inhibit creation of sparse files
    macos_recursive            = Copy directories recursively
    macos_followSymlink        = -R: Follow symlink arguments
    macos_followAllSymlink     = -R: Follow all symlinks
    macos_dontFollowSymlink    = -R: Don't follow symlinks (default)
    macos_force                = Don't confirm to overwrite
    macos_interactive          = Prompt before overwrite
    macos_dontOverwrite        = Don't overwrite existing
    macos_preserve             = Preserve attributes of source
    macos_verbose              = Print filenames as they're copied
    macos_archive              = Archive mode (-pPR)
    macos_clonefile2           = Clone using clonefile(2)
    macos_ommitXattrs          = Omit xattrs, resource forks
    macos_hardlink             = Hard link instead of copying
    macos_dontTraverse         = Don't traverse mount points
    macos_symlink              = Symlink instead of copying
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

cp --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0)
{
    $attr_list_arguments = @(
        "mode`t{0}" -f $msg.gnueattrList_mode
        "ownership`t{0}" -f $msg.gnu_attrList_ownership
        "timestamps`t{0}" -f $msg.gnu_attrList_timestamps
        "links`t{0}" -f $msg.gnu_attrList_links
        "context`t{0}" -f $msg.gnu_attrList_context
        "xattr`t{0}" -f $msg.gnu_attrList_xattr
        "all`t{0}" -f $msg.gnu_attrList_all
    )
    Register-NativeCompleter -Name cp -Parameters @(
        New-ParamCompleter -ShortName a -LongName archive -Description $msg."gnu_archive"
        New-ParamCompleter -LongName attributes-only -Description $msg.gnu_attributesOnly
        New-ParamCompleter -LongName backup -Description $msg.gnu_backup -Arguments @(
            "none `t{0}" -f $msg.gnu_backup_none
            "off `t{0}" -f $msg.gnu_backup_none
            "numbered `t{0}" -f $msg.gnu_backup_numbered
            "t `t{0}" -f $msg.gnu_backup_numbered
            "existing `t{0}" -f $msg.gnu_backup_existing
            "nil `t{0}" -f $msg.gnu_backup_existing
            "simple `t{0}" -f $msg.gnu_backup_simple
            "never `t{0}" -f $msg.gnu_backup_simple
        ) -VariableName 'CONTROL'
        New-ParamCompleter -ShortName b -Description $msg.gnu_short_backup
        New-ParamCompleter -LongName copy-contents -Description $msg.gnu_copyContents
        New-ParamCompleter -ShortName d -Description $msg.gnu_short_d
        New-ParamCompleter -ShortName f -LongName force -Description $msg.gnu_force
        New-ParamCompleter -ShortName i -LongName interactive -Description $msg.gnu_interactive
        New-ParamCompleter -ShortName H -Description $msg.gnu_short_H
        New-ParamCompleter -ShortName l -LongName link -Description $msg.gnu_link
        New-ParamCompleter -LongName strip-trailing-slashes -Description $msg.gnu_stripTrailingSlashes
        New-ParamCompleter -ShortName S -LongName suffix -Description $msg.gnu_suffix -Type Required -VariableName 'SUFFIX'
        New-ParamCompleter -ShortName t -LongName target-directory -Description $msg.gnu_targetDirectory -Type Directory -VariableName 'DIRECTORY'
        New-ParamCompleter -ShortName u -Description $msg.gnu_short_update
        New-ParamCompleter -LongName update -Description $msg.gnu_update -Type FlagOrValue -Arguments @(
            "older `t{0}" -f $msg.gnu_update_older
            "none `t{0}" -f $msg.gnu_update_none
            "all `t{0}" -f $msg.gnu_update_all
        ) -VariableName 'UPDATE'
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.gnu_verbose
        New-ParamCompleter -LongName help -Description $msg.gnu_help
        New-ParamCompleter -LongName version -Description $msg.gnu_version
        New-ParamCompleter -ShortName L -LongName dereference -Description $msg.gnu_dereference
        New-ParamCompleter -ShortName n -LongName no-clobber -Description $msg.gnu_noClobber
        New-ParamCompleter -ShortName P -LongName no-dereference -Description $msg.gnu_noDereference
        New-ParamCompleter -ShortName p -Description $msg.gnu_short_p
        New-ParamCompleter -LongName preserve -Description $msg.gnu_preserve -Arguments $attr_list_arguments -Type FlagOrValue,List -VariableName 'ATTR_LIST'
        New-ParamCompleter -LongName no-preserve -Description $msg.gnu_noPreserve -Arguments $attr_list_arguments -Type List -VariableName 'ATTR_LIST'
        New-ParamCompleter -LongName parents -Description $msg.gnu_parents
        New-ParamCompleter -ShortName r,R -LongName recursive -Description $msg.gnu_recursive
        New-ParamCompleter -LongName reflink -Description $msg.gnu_reflink -Type FlagOrValue -Arguments @(
            "always `t{0}" -f $msg.gnu_reflink_always 
            "auto `t{0}" -f $msg.gnu_reflink_auto
            "never `t{0}" -f  $msg.gnu_reflink_never
        ) -VariableName 'WHEN'
        New-ParamCompleter -LongName remove-destination -Description $msg.gnu_removeDestination
        New-ParamCompleter -LongName sparse -Description $msg.gnu_sparse -Arguments @(
            "always `t{0}" -f $msg.gnu_sparse_always 
            "auto `t{0}" -f $msg.gnu_sparse_auto
            "never `t{0}" -f  $msg.gnu_sparse_never
        ) -VariableName 'WHEN'
        New-ParamCompleter -ShortName s -LongName symbolic-link -Description $msg.gnu_symbolicLink
        New-ParamCompleter -ShortName T -LongName no-target-directory -Description $msg.gnu_noTargetDirectory
        New-ParamCompleter -ShortName x -LongName one-file-system -Description $msg.gnu_oneFileSystem
        New-ParamCompleter -ShortName Z -Description $msg.gnu_short_Z
        New-ParamCompleter -ShortName X -LongName context -Description $msg.gnu_context -Type Required -VariableName 'CTX'
    )
}
else
{
    Register-NativeCompleter -Name cp -Parameters @(
        New-ParamCompleter -ShortName R -Description $msg.macos_recursive
        New-ParamCompleter -ShortName H -Description $msg.macos_followSymlink
        New-ParamCompleter -ShortName L -Description $msg.macos_followAllSymlink
        New-ParamCompleter -ShortName P -Description $msg.macos_dontFollowSymlink
        New-ParamCompleter -ShortName f -Description $msg.macos_force
        New-ParamCompleter -ShortName i -Description $msg.macos_interactive
        New-ParamCompleter -ShortName n -Description $msg.macos_dontOverwrite
        New-ParamCompleter -ShortName p -Description $msg.macos_preserve
        New-ParamCompleter -ShortName v -Description $msg.macos_verbose
        New-ParamCompleter -ShortName a -Description $msg.macos_archive
        New-ParamCompleter -ShortName c -Description $msg.macos_clonefile2
        New-ParamCompleter -ShortName X -Description $msg.macos_ommitXattrs
        New-ParamCompleter -ShortName l -Description $msg.macos_hardlink
        New-ParamCompleter -ShortName x -Description $msg.macos_dontTraverse
        New-ParamCompleter -ShortName s -Description $msg.macos_symlink
    )
}
