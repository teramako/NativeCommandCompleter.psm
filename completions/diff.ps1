<#
 # diff completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    normal                   = Output a normal diff
    brief                    = Output only whether the files differ
    report-identical-files   = Report when two files are the same
    context                  = Output NUM lines of copied context
    short.c                  = Output 3 lines of copied context
    unified                  = Output NUM lines of unified context
    short.u                  = Output 3 lines of unified context
    ed                       = Output an ed script
    rcs                      = Output an RCS format diff
    side-by-side             = Output in two columns
    width                    = Output at most NUM print columns
    left-column              = Output only the left column of common lines
    suppress-common-lines    = Do not output common lines
    show-c-function          = Show which C function each change is in
    show-function-line       = Show the most recent line matching REGEX
    label                    = Use LABEL instead of file name and timestamp (can be repeated) 
    expand-tabs              = Expand tabs to spaces in output
    initial-tab              = Make tabs line up by prepending a tab
    tabsize                  = Tab stops every NUM (default 8) print columns
    suppress-blank-empty     = Suppress space or tab before empty output lines
    paginate                 = pass output through 'pr' to paginate it
    recursive                = Recursively compare subdirectories
    no-dereference           = Don't follow symbolic links
    new-file                 = Treat absent files as empty
    unidirectional-new-file  = Treat absent first files as empty
    ignore-file-name-case    = Ignore case when comparing file names
    no-ignore-file-name-case = Consider case when comparing file names
    exclude                  = Exclude files that match PAT
    exclude-from             = Exclude files that match any pattern in FILE
    starting-file            = Start with FILE when comparing directories
    from-file                = Compare FILE1 to all operands
    to-file                  = Compare FILE2 to all operands
    ignore-case              = Ignore case differences
    ignore-tab-expansion     = Ignore changes due to tab expansion
    ignore-trailing-space    = Ignore white space at line end
    ignore-space-change      = Ignore changes in the amount of white space
    ignore-all-space         = Ignore all white space
    ignore-blank-lines       = Ignore changes whose lines are all blank
    ignore-matching-lines    = Ignore changes whose lines match the REGEX
    text                     = Treat all files as text
    strip-trailing-cr        = Strip trailing carriage return on input
    ifdef                    = output merged file with '#ifdef NAME' diffs
    GTYPE-group-format       = Format GTYPE input groups with GFMT
    line-format              = Format all input lines with LFMT
    LTYPE-line-format        = Format LTYPE input lines with LFMT
    minimal                  = Try to find a smaller set of changes
    horizon-lines            = Keep NUM lines of the common prefix and suffix
    speed-large-files        = Assume large files and many scattered small changes
    color                    = Colorize the output
    palette                  = The colors to use when --color is active
    help                     = Display help and exit
    version                  = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name diff -Parameters @(
    New-ParamCompleter -LongName normal -Description $msg."normal"
    New-ParamCompleter -ShortName q -LongName brief -Description $msg."brief"
    New-ParamCompleter -ShortName s -LongName report-identical-files -Description $msg."report-identical-files"
    New-ParamCompleter -ShortName C -LongName context -Type Required -Description $msg."context"
    New-ParamCompleter -ShortName c -Description $msg."short.c"
    New-ParamCompleter -ShortName U -LongName unified -Type Required -Description $msg."unified"
    New-ParamCompleter -ShortName u -Description $msg."short.u"
    New-ParamCompleter -ShortName e -LongName ed -Description $msg."ed"
    New-ParamCompleter -ShortName n -LongName rcs -Description $msg."rcs"
    New-ParamCompleter -ShortName y -LongName side-by-side -Description $msg."side-by-side"
    New-ParamCompleter -ShortName W -LongName width -Type Required -Description $msg."width"
    New-ParamCompleter -LongName left-column -Description $msg."left-column"
    New-ParamCompleter -LongName suppress-common-lines -Description $msg."suppress-common-lines"
    New-ParamCompleter -ShortName p -LongName show-c-function -Description $msg."show-c-function"
    New-ParamCompleter -ShortName F -LongName show-function-line -Type Required -Description $msg."show-function-line"
    New-ParamCompleter -LongName label -Type Required -Description $msg."label"
    New-ParamCompleter -ShortName t -LongName expand-tabs -Description $msg."expand-tabs"
    New-ParamCompleter -ShortName T -LongName initial-tab -Description $msg."initial-tab"
    New-ParamCompleter -LongName tabsize -Type Required -Description $msg."tabsize"
    New-ParamCompleter -LongName suppress-blank-empty -Description $msg."suppress-blank-empty"
    New-ParamCompleter -ShortName l -LongName paginate -Description $msg."paginate"
    New-ParamCompleter -ShortName r -LongName recursive -Description $msg."recursive"
    New-ParamCompleter -LongName no-dereference -Description $msg."no-dereference"
    New-ParamCompleter -ShortName N -LongName new-file -Description $msg."new-file"
    New-ParamCompleter -LongName unidirectional-new-file -Description $msg."unidirectional-new-file"
    New-ParamCompleter -LongName ignore-file-name-case -Description $msg."ignore-file-name-case"
    New-ParamCompleter -LongName no-ignore-file-name-case -Description $msg."no-ignore-file-name-case"
    New-ParamCompleter -ShortName x -LongName exclude -Type Required -Description $msg."exclude"
    New-ParamCompleter -ShortName X -LongName exclude-from -Type File -Description $msg."exclude-from"
    New-ParamCompleter -ShortName S -LongName starting-file -Type File -Description $msg."starting-file"
    New-ParamCompleter -LongName from-file -Type File -Description $msg."from-file"
    New-ParamCompleter -LongName to-file -Type File -Description $msg."to-file"
    New-ParamCompleter -ShortName i -LongName ignore-case -Description $msg."ignore-case"
    New-ParamCompleter -ShortName E -LongName ignore-tab-expansion -Description $msg."ignore-tab-expansion"
    New-ParamCompleter -ShortName Z -LongName ignore-trailing-space -Description $msg."ignore-trailing-space"
    New-ParamCompleter -ShortName b -LongName ignore-space-change -Description $msg."ignore-space-change"
    New-ParamCompleter -ShortName w -LongName ignore-all-space -Description $msg."ignore-all-space"
    New-ParamCompleter -ShortName B -LongName ignore-blank-lines -Description $msg."ignore-blank-lines"
    New-ParamCompleter -ShortName I -LongName ignore-matching-lines -Type Required -Description $msg."ignore-matching-lines"
    New-ParamCompleter -ShortName a -LongName text -Description $msg."text"
    New-ParamCompleter -LongName strip-trailing-cr -Description $msg."strip-trailing-cr"
    New-ParamCompleter -ShortName D -LongName ifdef -Type Required -Description $msg."ifdef"
    New-ParamCompleter -LongName GTYPE-group-format -Type Required -Description $msg."GTYPE-group-format"
    New-ParamCompleter -LongName line-format -Type Required -Description $msg."line-format"
    New-ParamCompleter -LongName LTYPE-line-format -Type Required -Description $msg."LTYPE-line-format"
    New-ParamCompleter -ShortName d -LongName minimal -Description $msg."minimal"
    New-ParamCompleter -LongName horizon-lines -Type Required -Description $msg."horizon-lines"
    New-ParamCompleter -LongName speed-large-files -Description $msg."speed-large-files"
    New-ParamCompleter -LongName color -Type FlagOrValue -Description $msg."color" -Arguments 'never','always','auto'
    New-ParamCompleter -LongName palette -Type Required -Description $msg."palette"
    New-ParamCompleter -LongName help -Description $msg."help"
    New-ParamCompleter -ShortName v -LongName version -Description $msg."version"
)
