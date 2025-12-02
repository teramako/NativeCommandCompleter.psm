<#
 # ls completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ls                           = list directory contents
    gnu_all                      = Show hidden
    gnu_almosAll                 = Show hidden except '.' and '..'
    gnu_author                   = Print author
    gnu_escape                   = Octal escapes for non-graphic characters
    gnu_blockSize                = Set block size
    gnu_ignoreBackups            = Ignore files ending with '~'
    gnu_short_ctime              = Sort by changed time, (-l) show ctime
    gnu_forceMultiColumn         = Force multi-column output
    gnu_color                    = Use colors
    gnu_directory                = List directories, not their content
    gnu_dired                    = Generate dired output
    gnu_unsortOutput             = Unsorted output, enables -a
    gnu_short_classify           = Append filetype indicator (*/=>@|)
    gnu_classify                 = Append filetype indicator (*/=>@|)
    gnu_fileType                 = Append filetype indicator
    gnu_format                   = List format
    gnu_fullTime                 = Long format, full-iso time
    gnu_showGroup                = Show group instead of owner in long format
    gnu_groupDirectoriesFirst    = Group directories before files
    gnu_noGroup                  = Don't print group information
    gnu_humanReadable            = Human readable sizes
    gnu_si                       = Human readable sizes, powers of 1000
    gnu_dereferenceCommandLine   = Follow symlinks
    gnu_dereferenceCommandLineSymlinkToDir      = Follow directory symlinks from command line
    gnu_hide                     = Do not list implied entries matching specified shell pattern
    gnu_hyperlink                = Hyperlink file names
    gnu_indicatorStyle           = Append filetype indicator
    gnu_indicatorStyleSlash      = Append '/' indicator to directory
    gnu_inode                    = Print inode number of files
    gnu_ignore                   = Skip entries matching pattern
    gnu_kibibytes                = Set blocksize to 1kB
    gnu_longListFormat           = Long listing format
    gnu_dereference              = Follow symlinks
    gnu_commaSeparatedFormat     = Comma-separated format, fills across screen
    gnu_numericUidGid            = Long format, numeric UIDs and GIDs
    gnu_literal                  = Print raw entry names
    gnu_hideControlChars         = Replace non-graphic characters with '?'
    gnu_showControlChars         = Non-graphic characters printed as-is
    gnu_quoteName                = Enclose entry in quotes
    gnu_quotingStyle             = Select quoting style
    gnu_reverse                  = Reverse sort order
    gnu_recursive                = List subdirectory recursively
    gnu_size                     = Print size of files
    gnu_sortBySize               = Sort by size
    gnu_sort                     = Sort criteria
    gnu_sort_none                = Don't sort. Same as (-U)
    gnu_sort_size                = Sort by size. Same as (-S)
    gnu_sort_time                = Sort by modification time. Same as (-t)
    gnu_sort_version             = Sort by version. Same as (-v)
    gnu_sort_extension           = Sort by file extension. Same as (-X)
    gnu_sort_width               = Sort by file width
    gnu_time                     = Timestamp used to display or sort
    gnu_time_accessTime          = Access time
    gnu_time_changeTime          = Metadata change time
    gnu_time_modifiedTime        = Modified time (default)
    gnu_time_birthTime           = Birth time
    gnu_timeStyle                = Select time style
    gnu_sortByTime               = Sort by modified time, most recent first
    gnu_tabsize                  = Assume tab stops at each COLS
    gnu_dontSort                 = Do not sort
    gnu_sortByVersion            = Sort by version
    gnu_width                    = Assume screen width
    gnu_multiColumnOutput        = Multi-column output, horizontally listed
    gnu_sortByExtension          = Sort by extension
    gnu_context                  = Display security context so it fits on most displays
    gnu_zero                     = Output line with NUL, not newline
    gnu_listPerLine              = List one entry per line
    gnu_help                     = Display help and exit
    gnu_version                  = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU ls
ls --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU ls
{
    $when_arguments = "always", "auto", "never"
    $format_arguments = "across","commas","horizontal","long","single-column","verbose","vertical"
    $indicator_style_arguments = "none", "slash", "file-type", "classify"

    Register-NativeCompleter -Name ls -Description $msg.ls -Parameters @(
        New-ParamCompleter -ShortName a -LongName all -Description $msg.gnu_all
        New-ParamCompleter -ShortName A -LongName almost-all -Description $msg.gnu_almosAll
        New-ParamCompleter -LongName author -Description $msg.gnu_author
        New-ParamCompleter -ShortName b -LongName escape -Description $msg.gnu_escape
        New-ParamCompleter -LongName block-size -Description $msg.gnu_blockSize -Type Required -VariableName 'SIZE'
        New-ParamCompleter -ShortName B -LongName ignore-backups -Description $msg.gnu_ignoreBackups
        New-ParamCompleter -ShortName c -Description $msg.gnu_short_ctime
        New-ParamCompleter -ShortName C -Description $msg.gnu_forceMultiColumn
        New-ParamCompleter -LongName color -Description $msg.gnu_color -Type FlagOrValue -Arguments $when_arguments -VariableName 'WHEN'
        New-ParamCompleter -ShortName d -LongName directory -Description $msg.gnu_directory
        New-ParamCompleter -ShortName D -LongName dired -Description $msg.gnu_dired
        New-ParamCompleter -ShortName f -Description $msg.gnu_unsortOutput
        New-ParamCompleter -ShortName F -Description $msg.gnu_short_classify
        New-ParamCompleter -LongName classify -Description $msg.gnu_classify -Type FlagOrValue -Arguments $when_arguments -VariableName 'WHEN'
        New-ParamCompleter -LongName file-type -Description $msg.gnu_fileType
        New-ParamCompleter -LongName format -Description $msg.gnu_format -Arguments $format_arguments -VariableName 'WORD'
        New-ParamCompleter -LongName full-time -Description $msg.gnu_fullTime
        New-ParamCompleter -ShortName g -Description $msg.gnu_showGroup
        New-ParamCompleter -LongName group-directories-first -Description $msg.gnu_groupDirectoriesFirst
        New-ParamCompleter -ShortName G -LongName no-group -Description $msg.gnu_noGroup
        New-ParamCompleter -ShortName h -LongName human-readable -Description $msg.gnu_humanReadable
        New-ParamCompleter -LongName si -Description $msg.gnu_si
        New-ParamCompleter -ShortName H -LongName dereference-command-line -Description $msg.gnu_dereferenceCommandLine
        New-ParamCompleter -LongName dereference-command-line-symlink-to-dir -Description $msg.gnu_dereferenceCommandLineSymlinkToDir
        New-ParamCompleter -LongName hide -Description $msg.gnu_hide -Type Required -VariableName 'PATTERN'
        New-ParamCompleter -LongName hyperlink -Description $msg.gnu_hyperlink -Arguments $when_arguments -VariableName 'WHEN'
        New-ParamCompleter -LongName indicator-style -Description $msg.gnu_indicatorStyle -Arguments $indicator_style_arguments -VariableName 'WORD'
        New-ParamCompleter -ShortName i -LongName inode -Description $msg.gnu_inode
        New-ParamCompleter -ShortName I -LongName ignore -Description $msg.gnu_ignore -Type Required -VariableName 'PATTERN'
        New-ParamCompleter -ShortName k -LongName kibibytes -Description $msg.gnu_kibibytes
        New-ParamCompleter -ShortName l -Description $msg.gnu_longListFormat
        New-ParamCompleter -ShortName L -LongName dereference -Description $msg.gnu_dereference
        New-ParamCompleter -ShortName m -Description $msg.gnu_commaSeparatedFormat
        New-ParamCompleter -ShortName n -LongName numeric-uid-gid -Description $msg.gnu_numericUidGid
        New-ParamCompleter -ShortName N -LongName literal -Description $msg.gnu_literal
        New-ParamCompleter -ShortName p -Description $msg.gnu_indicatorStyleSlash
        New-ParamCompleter -ShortName q -LongName hide-control-chars -Description $msg.gnu_hideControlChars
        New-ParamCompleter -LongName show-control-chars -Description $msg.gnu_showControlChars
        New-ParamCompleter -ShortName Q -LongName quote-name -Description $msg.gnu_quoteName
        New-ParamCompleter -LongName quoting-style -Description $msg.gnu_quotingStyle -Arguments "literal","locale","shell","shell-always","c","escape" -VariableName 'WORD'
        New-ParamCompleter -ShortName r -LongName reverse -Description $msg.gnu_reverse
        New-ParamCompleter -ShortName R -LongName recursive -Description $msg.gnu_recursive
        New-ParamCompleter -ShortName s -LongName size -Description $msg.gnu_size
        New-ParamCompleter -ShortName S -Description $msg.gnu_sortBySize
        New-ParamCompleter -LongName sort -Description $msg.gnu_sort -Arguments @(
            "none `t{0}" -f $msg.gnu_sort_none
            "size `t{0}" -f $msg.gnu_sort_size
            "time `t{0}" -f $msg.gnu_sort_time
            "version `t{0}" -f $msg.gnu_sort_version
            "extension `t{0}" -f $msg.gnu_sort_extension
            "width `t{0}" -f $msg.gnu_sort_width
        ) -VariableName 'WORD'
        New-ParamCompleter -LongName time -Description $msg.gnu_time -Arguments @(
            "atime `t{0}" -f $msg.gnu_time_accessTime
            "access `t{0}" -f $msg.gnu_time_accessTime
            "use `t{0}" -f $msg.gnu_time_accessTime
            "ctime `t{0}" -f $msg.gnu_time_changeTime
            "status `t{0}" -f $msg.gnu_time_changeTime
            "mtime `t{0}" -f $msg.gnu_time_modifiedTime
            "modification `t{0}" -f $msg.gnu_time_modifiedTime
            "birth `t{0}" -f $msg.gnu_time_birthTime
            "creation `t{0}" -f $msg.gnu_time_birthTime
        ) -VariableName 'WORD'
        New-ParamCompleter -LongName time-style -Description $msg.gnu_timeStyle -Type Required -Arguments "full-iso","long-iso","iso","locale" -VariableName 'TIME_STYLE'
        New-ParamCompleter -ShortName t -Description $msg.gnu_sortByTime
        New-ParamCompleter -ShortName T -LongName tabsize -Description $msg.gnu_tabsize -Type Required -VariableName 'COLS'
        New-ParamCompleter -ShortName U -Description $msg.gnu_dontSort
        New-ParamCompleter -ShortName v -Description $msg.gnu_sortByVersion
        New-ParamCompleter -ShortName w -LongName width -Description $msg.gnu_width -Type Required -VariableName 'COLS'
        New-ParamCompleter -ShortName x -Description $msg.gnu_multiColumnOutput
        New-ParamCompleter -ShortName X -Description $msg.gnu_sortByExtension
        New-ParamCompleter -ShortName Z -LongName context -Description $msg.gnu_context
        New-ParamCompleter -LongName zero -Description $msg.gnu_zero
        New-ParamCompleter -ShortName 1 -Description $msg.gnu_listPerLine
        New-ParamCompleter -LongName help -Description $msg.gnu_help
        New-ParamCompleter -LongName version -Description $msg.gnu_version
    )
}
else
{
    Register-NativeCompleter -Name ls -Description 'list directory contents' -Parameters @(
        # TBD
    )
}

