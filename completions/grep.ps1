<#
 # grep completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    grep                  = print lines that match patterns
    afterContext          = Print NUM lines of trailing context
    text                  = Process binary file as text
    beforeContext         = Print NUM lines of leading context
    context               = Print NUM lines of context
    byteOffset            = Print byte offset of matches
    binaryFiles           = Assume data type for binary files
    color                 = Color output
    count                 = Only print number of matches
    devices               = Action for devices
    directories           = Action for devices
    extendedRegexp        = Pattern is extended regexp
    regexp                = Specify a pattern
    excludeFrom           = Read pattern list from file. Skip files whose base name matches list
    excludeDir            = Exclude matching directories from recursive searches
    fixedStrings          = Pattern is a fixed string
    file                  = Use patterns from a file
    basicRegexp           = Pattern is basic regex
    withFilename          = Print filename
    noFilename            = Suppress printing filename
    help                  = Display help and exit
    skipBinaryFiles       = Skip binary files
    ignoreCase            = Ignore case
    filesWithoutMatch     = Print name of files without matches
    filesWithMatches      = Print name of files with matches
    maxCount              = Stop reading after NUM matches
    mmap                  = Use the mmap system call to read input
    lineNumber            = Print line number
    onlyMatching          = Show only matching part
    label                 = Rename stdin
    lineBuffered          = Use line buffering
    perlRegexp            = Pattern is a Perl regexp (PCRE) string
    quiet                 = Do not write anything
    dereferenceRecursive  = Recursively read files under each directory, following symlinks
    recursive             = Recursively read files under each directory
    include               = Search only files matching PATTERN
    exclude               = Skip files matching PATTERN
    noMessages            = Suppress error messages
    initialTab            = Ensure first character of actual line content lies on a tab stop
    binary                = Treat files as binary
    unixByteOffsets       = Report Unix-style byte offsets
    version               = Display version and exit
    invertMatch           = Invert the sense of matching
    wordRegexp            = Only whole matching words
    lineRegexp            = Only whole matching lines
    nullData              = Treat input as a set of zero-terminated lines
    null                  = Output a zero byte after filename
    groupSeparator        = Set a group separator
    noGroupSeparator      = Use empty string as a group separator
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name grep -Description $msg.grep -Parameters @(
    New-ParamCompleter -ShortName A -LongName after-context -Type Required -Description $msg.afterContext -VariableName 'NUM'
    New-ParamCompleter -ShortName a -LongName text -Description $msg.text
    New-ParamCompleter -ShortName B -LongName before-context -Type Required -Description $msg.beforeContext -VariableName 'NUM'
    New-ParamCompleter -ShortName C -LongName context -Type Required -Description $msg.context -VariableName 'NUM'
    New-ParamCompleter -ShortName b -LongName byte-offset -Description $msg.byteOffset
    New-ParamCompleter -LongName binary-files -Description $msg.binaryFiles -Arguments "binnary`tBinary format", "text`tText format" -VariableName 'TYPE'
    New-ParamCompleter -LongName color,colour -Description $msg.color -Type FlagOrValue -Arguments 'never','always','auto' -VariableName WHEN
    New-ParamCompleter -ShortName c -LongName count -Description $msg.count
    New-ParamCompleter -ShortName D -LongName devices -Description $msg.devices -Arguments 'read', 'skip' -VariableName 'ACTION'
    New-ParamCompleter -ShortName d -LongName directories -Description $msg.directories -Arguments 'read', 'skip', 'recurse' -VariableName 'ACTION'
    New-ParamCompleter -ShortName E -LongName extended-regexp -Description $msg.extendedRegexp
    New-ParamCompleter -ShortName e -LongName regexp -Type Required -Description $msg.regexp -VariableName 'PATTERNS'
    New-ParamCompleter -LongName exclude-from -Type File -Description $msg.excludeFrom -VariableName 'FILE'
    New-ParamCompleter -LongName exclude-dir -Type Required -Description $msg.excludeDir -VariableName 'GLOB'
    New-ParamCompleter -ShortName F -LongName fixed-strings -Description $msg.fixedStrings
    New-ParamCompleter -ShortName f -LongName file -Type File -Description $msg.file -VariableName 'FILE'
    New-ParamCompleter -ShortName G -LongName basic-regexp -Description $msg.basicRegexp
    New-ParamCompleter -ShortName H -LongName with-filename -Description $msg.withFilename
    New-ParamCompleter -ShortName h -LongName no-filename -Description $msg.noFilename
    New-ParamCompleter -LongName help -Description $msg.help
    New-ParamCompleter -ShortName I -Description $msg.skipBinaryFiles
    New-ParamCompleter -ShortName i -LongName ignore-case -Description $msg.ignoreCase
    New-ParamCompleter -ShortName L -LongName files-without-match -Description $msg.filesWithoutMatch
    New-ParamCompleter -ShortName l -LongName files-with-matches -Description $msg.filesWithMatches
    New-ParamCompleter -ShortName m -LongName max-count -Description $msg.maxCount -VariableName 'NUM'
    New-ParamCompleter -LongName mmap -Description $msg.mmap
    New-ParamCompleter -ShortName n -LongName line-number -Description $msg.lineNumber
    New-ParamCompleter -ShortName o -LongName only-matching -Description $msg.onlyMatching
    New-ParamCompleter -LongName label -Type Required -Description $msg.label -VariableName 'LABEL'
    New-ParamCompleter -LongName line-buffered -Description $msg.lineBuffered
    New-ParamCompleter -ShortName P -LongName perl-regexp -Description $msg.perlRegexp
    New-ParamCompleter -ShortName q -LongName quiet, slient -Description $msg.quiet
    New-ParamCompleter -ShortName R -LongName dereference-recursive -Description $msg.dereferenceRecursive
    New-ParamCompleter -ShortName r -LongName recursive -Description $msg.recursive
    New-ParamCompleter -LongName include -Type Required -Description $msg.include -VariableName 'GLOB'
    New-ParamCompleter -LongName exclude -Type Required -Description $msg.exclude -VariableName 'GLOB'
    New-ParamCompleter -ShortName s -LongName no-messages -Description $msg.noMessages
    New-ParamCompleter -ShortName T -LongName initial-tab -Description $msg.initialTab
    New-ParamCompleter -ShortName U -LongName binary -Description $msg.binary
    New-ParamCompleter -ShortName u -LongName unix-byte-offsets -Description $msg.unixByteOffsets
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
    New-ParamCompleter -ShortName v -LongName invert-match -Description $msg.invertMatch
    New-ParamCompleter -ShortName w -LongName word-regexp -Description $msg.wordRegexp
    New-ParamCompleter -ShortName x -LongName line-regexp -Description $msg.lineRegexp
    New-ParamCompleter -ShortName z -LongName null-data -Description $msg.nullData
    New-ParamCompleter -ShortName Z -LongName null -Description $msg.null
    New-ParamCompleter -LongName group-separator -Type Required -Description $msg.groupSeparator -VariableName 'SEP'
    New-ParamCompleter -LongName no-group-separator -Description $msg.noGroupSeparator
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    if ($argIndex -eq 0 -and -not $this.BoundParameters.ContainsKey("regexp"))
    {
        if ([string]::IsNullOrEmpty($_))
        {
            "pattern`tSpecify a pattern"
        }
        else
        {
            $null
        }
    }
}
