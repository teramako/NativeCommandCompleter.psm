<#
 # ls completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu.all                      = Show hidden
    gnu.almos-all                = Show hidden except '.' and '..'
    gnu.author                   = Print author
    gnu.escape                   = Octal escapes for non-graphic characters
    gnu.block-size               = Set block size
    gnu.ignore-backups           = Ignore files ending with '~'
    gnu.short_ctime              = Sort by changed time, (-l) show ctime
    gnu.force-multi-column       = Force multi-column output
    gnu.color                    = Use colors
    gnu.directory                = List directories, not their content
    gnu.dired                    = Generate dired output
    gnu.unsort-output            = Unsorted output, enables -a
    gnu.short_classify           = Append filetype indicator (*/=>@|)
    gnu.classify                 = Append filetype indicator (*/=>@|)
    gnu.file-type                = Append filetype indicator
    gnu.format                   = List format
    gnu.full-time                = Long format, full-iso time
    gnu.show-group               = Show group instead of owner in long format
    gnu.group-directories-first  = Group directories before files
    gnu.no-group                 = Don't print group information
    gnu.human-readable           = Human readable sizes
    gnu.si                       = Human readable sizes, powers of 1000
    gnu.dereference-command-line = Follow symlinks
    gnu.dereference-command-line-symlink-to-dir = Follow directory symlinks from command line
    gnu.hide                     = Do not list implied entries matching specified shell pattern
    gnu.hyperlink                = Hyperlink file names
    gnu.indicator-style          = Append filetype indicator
    gnu.indicator-style-slash    = Append '/' indicator to directory
    gnu.inode                    = Print inode number of files
    gnu.ignore                   = Skip entries matching pattern
    gnu.kibibytes                = Set blocksize to 1kB
    gnu.long-list-format         = Long listing format
    gnu.dereference              = Follow symlinks
    gnu.comma-separated-format   = Comma-separated format, fills across screen
    gnu.numeric-uid-gid          = Long format, numeric UIDs and GIDs
    gnu.literal                  = Print raw entry names
    gnu.hide-control-chars       = Replace non-graphic characters with '?'
    gnu.show-control-chars       = Non-graphic characters printed as-is
    gnu.quote-name               = Enclose entry in quotes
    gnu.quoting-style            = Select quoting style
    gnu.reverse                  = Reverse sort order
    gnu.recursive                = List subdirectory recursively
    gnu.size                     = Print size of files
    gnu.sort-by-size             = Sort by size
    gnu.sort                     = Sort criteria
    gnu.sort.none                = Don't sort. Same as (-U)
    gnu.sort.size                = Sort by size. Same as (-S)
    gnu.sort.time                = Sort by modification time. Same as (-t)
    gnu.sort.version             = Sort by version. Same as (-v)
    gnu.sort.extension           = Sort by file extension. Same as (-X)
    gnu.sort.width               = Sort by file width
    gnu.time                     = Timestamp used to display or sort
    gnu.time.access-time         = Access time
    gnu.time.change-time         = Metadata change time
    gnu.time.modified-time       = Modified time (default)
    gnu.time.birth-time          = Birth time
    gnu.time-style               = Select time style
    gnu.sort-by-time             = Sort by modified time, most recent first
    gnu.tabsize                  = Assume tab stops at each COLS
    gnu.dont-sort                = Do not sort
    gnu.sort-by-version          = Sort by version
    gnu.width                    = Assume screen width
    gnu.multi-column-output      = Multi-column output, horizontally listed
    gnu.sort-by-extension        = Sort by extension
    gnu.context                  = Display security context so it fits on most displays
    gnu.zero                     = Output line with NUL, not newline
    gnu.list-per-line            = List one entry per line
    gnu.help                     = Display help and exit
    gnu.version                  = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localeMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU ls
ls --version 2>/dev/null >/dev/null
if ($LASTEXITCODE -eq 0) # GNU ls
{
    $when_arguments = "always", "auto", "never"
    $format_arguments = "across","commas","horizontal","long","single-column","verbose","vertical"
    $indicator_style_arguments = "none", "slash", "file-type", "classify"

    Register-NativeCompleter -Name ls -Description 'list directory contents' -Parameters @(
        New-ParamCompleter -ShortName a -LongName all -Description $msg."gnu.all"
        New-ParamCompleter -ShortName A -LongName almost-all -Description $msg."gnu.almos-all"
        New-ParamCompleter -LongName author -Description $msg."gnu.author"
        New-ParamCompleter -ShortName b -LongName escape -Description $msg."gnu.escape"
        New-ParamCompleter -LongName block-size -Description $msg."gnu.block-size" -Type Required
        New-ParamCompleter -ShortName B -LongName ignore-backups -Description $msg."gnu.ignore-backups"
        New-ParamCompleter -ShortName c -Description $msg."gnu.short_ctime"
        New-ParamCompleter -ShortName C -Description $msg."gnu.force-multi-column"
        New-ParamCompleter -LongName color -Description $msg."gnu.color" -Type FlagOrValue -Arguments $when_arguments
        New-ParamCompleter -ShortName d -LongName directory -Description $msg."gnu.directory"
        New-ParamCompleter -ShortName D -LongName dired -Description $msg."gnu.dired"
        New-ParamCompleter -ShortName f -Description $msg."gnu.unsort-output"
        New-ParamCompleter -ShortName F -Description $msg."gnu.short_classify"
        New-ParamCompleter -LongName classify -Description $msg."gnu.classify" -Type FlagOrValue -Arguments $when_arguments
        New-ParamCompleter -LongName file-type -Description $msg."gnu.file-type"
        New-ParamCompleter -LongName format -Description $msg."gnu.format" -Arguments $format_arguments
        New-ParamCompleter -LongName full-time -Description $msg."gnu.full-time"
        New-ParamCompleter -ShortName g -Description $msg."gnu.show-group"
        New-ParamCompleter -LongName group-directories-first -Description $msg."gnu.group-directories-first"
        New-ParamCompleter -ShortName G -LongName no-group -Description $msg."gnu.no-group"
        New-ParamCompleter -ShortName h -LongName human-readable -Description $msg."gnu.human-readable"
        New-ParamCompleter -LongName si -Description $msg."gnu.si"
        New-ParamCompleter -ShortName H -LongName dereference-command-line -Description $msg."gnu.dereference-command-line"
        New-ParamCompleter -LongName dereference-command-line-symlink-to-dir -Description $msg."gnu.dereference-command-line-symlink-to-dir"
        New-ParamCompleter -LongName hide -Description $msg."gnu.hide" -Type Required
        New-ParamCompleter -LongName hyperlink -Description $msg."gnu.hyperlink" -Arguments $when_arguments
        New-ParamCompleter -LongName indicator-style -Description $msg."gnu.indicator-style" -Arguments $indicator_style_arguments
        New-ParamCompleter -ShortName i -LongName inode -Description $msg."gnu.inode"
        New-ParamCompleter -ShortName I -LongName ignore -Description $msg."gnu.ignore" -Type Required
        New-ParamCompleter -ShortName k -LongName kibibytes -Description $msg."gnu.kibibytes"
        New-ParamCompleter -ShortName l -Description $msg."gnu.long-list-format"
        New-ParamCompleter -ShortName L -LongName dereference -Description $msg."gnu.dereference"
        New-ParamCompleter -ShortName m -Description $msg."gnu.comma-separated-format"
        New-ParamCompleter -ShortName n -LongName numeric-uid-gid -Description $msg."gnu.numeric-uid-gid"
        New-ParamCompleter -ShortName N -LongName literal -Description $msg."gnu.literal"
        New-ParamCompleter -ShortName p -Description $msg."gnu.indicator-style-slash"
        New-ParamCompleter -ShortName q -LongName hide-control-chars -Description $msg."gnu.hide-control-chars"
        New-ParamCompleter -LongName show-control-chars -Description $msg."gnu.show-control-chars"
        New-ParamCompleter -ShortName Q -LongName quote-name -Description $msg."gnu.quote-name"
        New-ParamCompleter -LongName quoting-style -Description $msg."gnu.quoting-style" -Arguments "literal","locale","shell","shell-always","c","escape"
        New-ParamCompleter -ShortName r -LongName reverse -Description $msg."gnu.reverse"
        New-ParamCompleter -ShortName R -LongName recursive -Description $msg."gnu.recursive"
        New-ParamCompleter -ShortName s -LongName size -Description $msg."gnu.size"
        New-ParamCompleter -ShortName S -Description $msg."gnu.sort-by-size"
        New-ParamCompleter -LongName sort -Description $msg."gnu.sort" -Arguments @(
            "none `t{0}" -f $msg."gnu.sort.none"
            "size `t{0}" -f $msg."gnu.sort.size"
            "time `t{0}" -f $msg."gnu.sort.time"
            "version `t{0}" -f $msg."gnu.sort.version"
            "extension `t{0}" -f $msg."gnu.sort.extension"
            "width `t{0}" -f $msg."gnu.sort.width"
        )
        New-ParamCompleter -LongName time -Description $msg."gnu.time" -Arguments @(
            "atime `t{0}" -f $msg."gnu.time.access-time"
            "access `t{0}" -f $msg."gnu.time.access-time"
            "use `t{0}" -f $msg."gnu.time.access-time"
            "ctime `t{0}" -f $msg."gnu.time.change-time"
            "status `t{0}" -f $msg."gnu.time.change-time"
            "mtime `t{0}" -f $msg."gnu.time.modified-time"
            "modification `t{0}" -f $msg."gnu.time.modified-time"
            "birth `t{0}" -f $msg."gnu.time.birth-time"
            "creation `t{0}" -f $msg."gnu.time.birth-time"
        )
        New-ParamCompleter -LongName time-style -Description $msg."gnu.time-style" -Type Required -Arguments "full-iso","long-iso","iso","locale"
        New-ParamCompleter -ShortName t -Description $msg."gnu.sort-by-time"
        New-ParamCompleter -ShortName T -LongName tabsize -Description $msg."gnu.tabsize" -Type Required
        New-ParamCompleter -ShortName U -Description $msg."gnu.dont-sort"
        New-ParamCompleter -ShortName v -Description $msg."gnu.sort-by-version"
        New-ParamCompleter -ShortName w -LongName width -Description $msg."gnu.width" -Type Required
        New-ParamCompleter -ShortName x -Description $msg."gnu.multi-column-output"
        New-ParamCompleter -ShortName X -Description $msg."gnu.sort-by-extension"
        New-ParamCompleter -ShortName Z -LongName context -Description $msg."gnu.context"
        New-ParamCompleter -LongName zero -Description $msg."gnu.zero"
        New-ParamCompleter -ShortName 1 -Description $msg."gnu.list-per-line"
        New-ParamCompleter -LongName help -Description $msg."gnu.help"
        New-ParamCompleter -LongName version -Description $msg."gnu.version"
    )
}
else
{
    Register-NativeCompleter -Name ls -Description 'list directory contents' -Parameters @(
        # TBD
    )
}

