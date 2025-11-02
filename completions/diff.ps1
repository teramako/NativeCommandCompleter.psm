<#
 # diff completion
 #>
Import-Module NativeCommandCompleter.psm

Register-NativeCompleter -Name diff -Parameters @(
    New-ParamCompleter -LongName normal -Description "Output a normal diff"
    New-ParamCompleter -ShortName q -LongName brief -Description "Output only whether the files differ"
    New-ParamCompleter -ShortName s -LongName report-identical-files -Description "Report when two files are the same"
    New-ParamCompleter -ShortName C -LongName context -Description "Output NUM lines of copied context" -Type Required
    New-ParamCompleter -ShortName c -Description "Output 3 lines of copied context"
    New-ParamCompleter -ShortName U -LongName unified -Description "Output NUM lines of unified context" -Type Required
    New-ParamCompleter -ShortName u -Description "Output 3 lines of unified context"
    New-ParamCompleter -ShortName e -LongName ed -Description "Output an ed script"
    New-ParamCompleter -ShortName n -LongName rcs -Description "Output an RCS format diff"
    New-ParamCompleter -ShortName y -LongName side-by-side -Description "Output in two columns"
    New-ParamCompleter -ShortName W -LongName width -Description "Output at most NUM print columns" -Type Required
    New-ParamCompleter -LongName left-column -Description "Output only the left column of common lines"
    New-ParamCompleter -LongName suppress-common-lines -Description "Do not output common lines"
    New-ParamCompleter -ShortName p -LongName show-c-function -Description "Show which C function each change is in"
    New-ParamCompleter -ShortName F -LongName show-function-line -Description "Show the most recent line matching REGEX" -Type Required
    New-ParamCompleter -LongName label -Description "Use LABEL instead of file name and timestamp (can be repeated)" -Type Required
    New-ParamCompleter -ShortName t -LongName expand-tabs -Description "Expand tabs to spaces in output"
    New-ParamCompleter -ShortName T -LongName initial-tab -Description "Make tabs line up by prepending a tab"
    New-ParamCompleter -LongName tabsize -Description "Tab stops every NUM (default 8) print columns" -Type Required
    New-ParamCompleter -LongName suppress-blank-empty -Description "Suppress space or tab before empty output lines"
    New-ParamCompleter -ShortName l -LongName paginate -Description "pass output through 'pr' to paginate it"
    New-ParamCompleter -ShortName r -LongName recursive -Description "Recursively compare subdirectories"
    New-ParamCompleter -LongName no-dereference -Description "Don't follow symbolic links"
    New-ParamCompleter -ShortName N -LongName new-file -Description "Treat absent files as empty"
    New-ParamCompleter -LongName unidirectional-new-file -Description "Treat absent first files as empty"
    New-ParamCompleter -LongName ignore-file-name-case -Description "Ignore case when comparing file names"
    New-ParamCompleter -LongName no-ignore-file-name-case -Description "Consider case when comparing file names"
    New-ParamCompleter -ShortName x -LongName exclude -Description "Exclude files that match PAT" -Type Required
    New-ParamCompleter -ShortName X -LongName exclude-from -Description "Exclude files that match any pattern in FILE" -Type File
    New-ParamCompleter -ShortName S -LongName starting-file -Description "Start with FILE when comparing directories" -Type File
    New-ParamCompleter -LongName from-file -Description "Compare FILE1 to all operands" -Type File
    New-ParamCompleter -LongName to-file -Description "Compare FILE2 to all operands" -Type File
    New-ParamCompleter -ShortName i -LongName ignore-case -Description "Ignore case differences"
    New-ParamCompleter -ShortName E -LongName ignore-tab-expansion -Description "Ignore changes due to tab expansion"
    New-ParamCompleter -ShortName Z -LongName ignore-trailing-space -Description "Ignore white space at line end"
    New-ParamCompleter -ShortName b -LongName ignore-space-change -Description "Ignore changes in the amount of white space"
    New-ParamCompleter -ShortName w -LongName ignore-all-space -Description "Ignore all white space"
    New-ParamCompleter -ShortName B -LongName ignore-blank-lines -Description "Ignore changes whose lines are all blank"
    New-ParamCompleter -ShortName I -LongName ignore-matching-lines -Description "Ignore changes whose lines match the REGEX" -Type Required
    New-ParamCompleter -ShortName a -LongName text -Description "Treat all files as text"
    New-ParamCompleter -LongName strip-trailing-cr -Description "Strip trailing carriage return on input"
    New-ParamCompleter -ShortName D -LongName ifdef -Description "output merged file with '#ifdef NAME' diffs" -Type Required
    New-ParamCompleter -LongName GTYPE-group-format -Description "Format GTYPE input groups with GFMT" -Type Required
    New-ParamCompleter -LongName line-format -Description "Format all input lines with LFMT" -Type Required
    New-ParamCompleter -LongName LTYPE-line-format -Description "Format LTYPE input lines with LFMT" -Type Required
    New-ParamCompleter -ShortName d -LongName minimal -Description "Try to find a smaller set of changes"
    New-ParamCompleter -LongName horizon-lines -Description "Keep NUM lines of the common prefix and suffix" -Type Required
    New-ParamCompleter -LongName speed-large-files -Description "Assume large files and many scattered small changes"
    New-ParamCompleter -LongName color -Description "Colorize the output" -Type Flag,OnlyWithValueSperator -Arguments 'never','always','auto'
    New-ParamCompleter -LongName palette -Description "The colors to use when --color is active" -Type Required
    New-ParamCompleter -LongName help -Description "Display help and exit"
    New-ParamCompleter -ShortName v -LongName version -Description "Display version and exit"
)
