<#
 # cp completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu.archive                = Same as -dpR
    gnu.attributes-only        = Copy just the attributes
    gnu.backup                 = Make backup of each existing destination file
    gnu.backup.none            = Never make backups
    gnu.backup.numbered        = Make numbered backups
    gnu.backup.existing        = Numbered backups if any exist, else simple
    gnu.backup.simple          = Make simple backups
    gnu.short_backup           = Make backup of each existing destination file
    gnu.copy-contents          = Copy contents of special files when recursive
    gnu.short_d                = Same as --no-dereference --preserve=links
    gnu.force                  = Do not prompt before overwriting
    gnu.interactive            = Prompt before overwrite
    gnu.short_H                = Follow command-line symbolic links
    gnu.link                   = Link files instead of copying
    gnu.strip-trailing-slashes = Remove trailing slashes from source
    gnu.suffix                 = Backup suffix
    gnu.target-directory       = Target directory
    gnu.short_update           = Equivalent to --update[=older]
    gnu.update                 = Do not overwrite newer files
    gnu.verbose                = Verbose mode
    gnu.help                   = Display help and exit
    gnu.version                = Display version and exit
    gnu.dereference            = Always follow symbolic links
    gnu.no-clobber             = Do not overwrite an existing file
    gnu.no-dereference         = Never follow symbolic links
    gnu.short_p                = Same as --preserve=mode,ownership,timestamps
    gnu.preserve               = Preserve ATTRIBUTES if possible
    gnu.no-preserve            = Don't preserve ATTRIBUTES
    gnu.parents                = Use full source file name under DIRECTORY
    gnu.recursive              = Copy directories recursively
    gnu.reflink                = Control clone/CoW copies
    gnu.remove-destination     = First remove existing destination files
    gnu.sparse                 = Control creation of sparse files
    gnu.symbolic-link          = Make symbolic links instead of copying
    gnu.no-target-directory    = Treat DEST as a normal file
    gnu.one-file-system        = Stay on this file system
    gnu.short_Z                = Set SELinux context of copy to default type
    gnu.context                = Set SELinux context of copy to CONTEXT
    gnu.attr_list.mode         = Permissions (including any ACL and xattr permissions)
    gnu.attr_list.ownership    = User and group
    gnu.attr_list.timestamps   = File timestamps
    gnu.attr_list.links        = Hard links
    gnu.attr_list.context      = Security context
    gnu.attr_list.xattr        = Extended attributes
    gnu.attr_list.all          = All attributes
    gnu.update.older           = Files being replaced if they're older than the corresponding source file
    gnu.update.none            = Similar to the --no-clobber option, but no failure
    gnu.update.all             = All existing files in the destination being replaced (default)
    gnu.reflink.always         = Perform a lightweight copy, where the data blocks are copied only when modified
    gnu.reflink.auto           = Attempt lightweight copy, if failed, fall back to a standard copy
    gnu.reflink.never          = Ensure a standard copy is performed
    gnu.sparse.always          = Create a sparse DEST file whenever the SOURCE file contains a long enough sequence of zero bytes
    gnu.sparse.auto            = Detected by a crude heuristic and the corresponding DEST file is made sparse as well
    gnu.sparse.never           = Inhibit creation of sparse files
    macos.recursive            = Copy directories recursively
    macos.follow-symlink       = -R: Follow symlink arguments
    macos.follow-all-symlink   = -R: Follow all symlinks
    macos.dont-follow-symlink  = -R: Don't follow symlinks (default)
    macos.force                = Don't confirm to overwrite
    macos.interactive          = Prompt before overwrite
    macos.dont-overwrite       = Don't overwrite existing
    macos.preserve             = Preserve attributes of source
    macos.verbose              = Print filenames as they're copied
    macos.archive              = Archive mode (-pPR)
    macos.clonefile2           = Clone using clonefile(2)
    macos.ommit-xattrs         = Omit xattrs, resource forks
    macos.hardlink             = Hard link instead of copying
    macos.dont-traverse        = Don't traverse mount points
    macos.symlink              = Symlink instead of copying
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localeMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

cp --version 2>/dev/null >/dev/null # GNU cp
if ($LASTEXITCODE -eq 0)
{
    $attr_list_arguments = @(
        "mode`t{0}" -f $msg."gnu.attr_list.mode"
        "ownership`t{0}" -f $msg."gnu.attr_list.ownership"
        "timestamps`t{0}" -f $msg."gnu.attr_list.timestamps"
        "links`t{0}" -f $msg."gnu.attr_list.links"
        "context`t{0}" -f $msg."gnu.attr_list.context"
        "xattr`t{0}" -f $msg."gnu.attr_list.xattr"
        "all`t{0}" -f $msg."gnu.attr_list.all"
    )
    Register-NativeCompleter -Name cp -Parameters @(
        New-ParamCompleter -ShortName a -LongName archive -Description $msg."gnu.archive"
        New-ParamCompleter -LongName attributes-only -Description $msg."gnu.attributes-only"
        New-ParamCompleter -LongName backup -Description $msg."gnu.backup" -Arguments @(
            "none `t{0}" -f $msg."gnu.backup.none"
            "off `t{0}" -f $msg."gnu.backup.none"
            "numbered `t{0}" -f $msg."gnu.backup.numbered"
            "t `t{0}" -f $msg."gnu.backup.numbered"
            "existing `t{0}" -f $msg."gnu.backup.existing"
            "nil `t{0}" -f $msg."gnu.backup.existing"
            "simple `t{0}" -f $msg."gnu.backup.simple"
            "never `t{0}" -f $msg."gnu.backup.simple"
        )
        New-ParamCompleter -ShortName b -Description $msg."gnu.short_backup"
        New-ParamCompleter -LongName copy-contents -Description $msg."gnu.copy-contents"
        New-ParamCompleter -ShortName d -Description $msg."gnu.short_d"
        New-ParamCompleter -ShortName f -LongName force -Description $msg."gnu.force"
        New-ParamCompleter -ShortName i -LongName interactive -Description $msg."gnu.interactive"
        New-ParamCompleter -ShortName H -Description $msg."gnu.short_H"
        New-ParamCompleter -ShortName l -LongName link -Description $msg."gnu.link"
        New-ParamCompleter -LongName strip-trailing-slashes -Description $msg."gnu.strip-trailing-slashes"
        New-ParamCompleter -ShortName S -LongName suffix -Description $msg."gnu.suffix" -Type Required
        New-ParamCompleter -ShortName t -LongName target-directory -Description $msg."gnu.target-directory" -Type Directory
        New-ParamCompleter -ShortName u -Description $msg."gnu.short_update"
        New-ParamCompleter -LongName update -Description $msg."gnu.update" -Type FlagOrValue -Arguments @(
            "older `t{0}" -f $msg."gnu.update.older"
            "none `t{0}" -f $msg."gnu.update.none"
            "all `t{0}" -f $msg."gnu.update.all"
        )
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg."gnu.verbose"
        New-ParamCompleter -LongName help -Description $msg."gnu.help"
        New-ParamCompleter -LongName version -Description $msg."gnu.version"
        New-ParamCompleter -ShortName L -LongName dereference -Description $msg."gnu.dereference"
        New-ParamCompleter -ShortName n -LongName no-clobber -Description $msg."gnu.no-clobber"
        New-ParamCompleter -ShortName P -LongName no-dereference -Description $msg."gnu.no-dereference"
        New-ParamCompleter -ShortName p -Description $msg."gnu.short_p"
        New-ParamCompleter -LongName preserve -Description $msg."gnu.preserve" -Arguments $attr_list_arguments -Type FlagOrValue,List
        New-ParamCompleter -LongName no-preserve -Description $msg."gnu.no-preserve" -Arguments $attr_list_arguments -Type List
        New-ParamCompleter -LongName parents -Description $msg."gnu.parents"
        New-ParamCompleter -ShortName r,R -LongName recursive -Description $msg."gnu.recursive"
        New-ParamCompleter -LongName reflink -Description $msg."gnu.reflink" -Type FlagOrValue -Arguments @(
            "always `t{0}" -f $msg."gnu.reflink.always" 
            "auto `t{0}" -f $msg."gnu.reflink.auto"
            "never `t{0}" -f  $msg."gnu.reflink.never"
        )
        New-ParamCompleter -LongName remove-destination -Description $msg."gnu.remove-destination"
        New-ParamCompleter -LongName sparse -Description $msg."gnu.sparse" -Arguments @(
            "always `t{0}" -f $msg."gnu.sparse.always" 
            "auto `t{0}" -f $msg."gnu.sparse.auto"
            "never `t{0}" -f  $msg."gnu.sparse.never"
        )
        New-ParamCompleter -ShortName s -LongName symbolic-link -Description $msg."gnu.symbolic-link"
        New-ParamCompleter -ShortName T -LongName no-target-directory -Description $msg."gnu.no-target-directory"
        New-ParamCompleter -ShortName x -LongName one-file-system -Description $msg."gnu.one-file-system"
        New-ParamCompleter -ShortName Z -Description $msg."gnu.short_Z"
        New-ParamCompleter -ShortName X -LongName context -Description $msg."gnu.context" -Type Required
    )
}
else
{
    Register-NativeCompleter -Name cp -Parameters @(
        New-ParamCompleter -ShortName R -Description $msg."macos.recursive"
        New-ParamCompleter -ShortName H -Description $msg."macos.follow-symlink"
        New-ParamCompleter -ShortName L -Description $msg."macos.follow-all-symlink"
        New-ParamCompleter -ShortName P -Description $msg."macos.dont-follow-symlink"
        New-ParamCompleter -ShortName f -Description $msg."macos.force"
        New-ParamCompleter -ShortName i -Description $msg."macos.interactive"
        New-ParamCompleter -ShortName n -Description $msg."macos.dont-overwrite"
        New-ParamCompleter -ShortName p -Description $msg."macos.preserve"
        New-ParamCompleter -ShortName v -Description $msg."macos.verbose"
        New-ParamCompleter -ShortName a -Description $msg."macos.archive"
        New-ParamCompleter -ShortName c -Description $msg."macos.clonefile2"
        New-ParamCompleter -ShortName X -Description $msg."macos.ommit-xattrs"
        New-ParamCompleter -ShortName l -Description $msg."macos.hardlink"
        New-ParamCompleter -ShortName x -Description $msg."macos.dont-traverse"
        New-ParamCompleter -ShortName s -Description $msg."macos.symlink"
    )
}
