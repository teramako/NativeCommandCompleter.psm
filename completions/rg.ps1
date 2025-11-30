<#
 # rg (ripgrep) completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    rg                      = recursively search the current directory for lines matching a pattern
    afterContext            = Show NUM lines after each match
    beforeContext           = Show NUM lines before each match
    context                 = Show NUM lines before and after each match
    binary                  = Search binary files
    blockBuffered           = Force block buffering
    byteOffset              = Print the byte offset for each matching line
    caseSensitive           = Search case sensitively
    color                   = When to use colors
    colors                  = Configure color settings
    column                  = Show column numbers
    contextSeparator        = Set the context separator string
    count                   = Only show count of matches
    countMatches            = Only show count of individual matches
    crlf                    = Support CRLF line terminators
    debug                   = Show debug messages
    dfaSizeLimit            = Set the max size of the regex DFA
    encoding                = Specify the text encoding
    engine                  = Which regex engine to use
    file                    = Search for a pattern from file
    files                   = Print each file that would be searched
    filesWithMatches        = Only print files with matches
    filesWithoutMatch       = Only print files without matches
    fixedStrings            = Treat pattern as literal string
    follow                  = Follow symbolic links
    glob                    = Include or exclude files
    globCaseInsensitive     = Process glob patterns case insensitively
    heading                 = Print file name above matching contents
    hidden                  = Search hidden files and directories
    iglob                   = Same as --glob, but case insensitive
    ignoreCase              = Search case insensitively
    ignoreFile              = Specify additional ignore file
    ignoreFileCaseInsensitive = Process ignore files case insensitively
    includeZero             = Include files with zero matches in count
    invertMatch             = Invert matching
    json                    = Show search results in JSON
    lineBuffered            = Force line buffering
    lineNumber              = Show line numbers
    lineRegexp              = Only show matches surrounded by line boundaries
    maxColumns              = Don't print lines longer than this limit
    maxColumnsPreview       = Print a preview for lines exceeding the limit
    maxCount                = Limit number of matches
    maxDepth                = Descend at most NUM directories
    maxFilesize             = Ignore files larger than NUM bytes
    mmap                    = Search using memory maps when possible
    multiline               = Enable matching across multiple lines
    multilineDotall         = Make '.' match newlines in multiline mode
    noConfig                = Never read config files
    noHeading               = Don't print file names
    noIgnore                = Don't respect ignore files
    noIgnoreDot             = Don't respect .ignore files
    noIgnoreExclude         = Don't respect local exclusion files
    noIgnoreFiles           = Don't respect --ignore-file arguments
    noIgnoreGlobal          = Don't respect global ignore files
    noIgnoreMessages        = Suppress ignore file parse error messages
    noIgnoreParent          = Don't respect parent ignore files
    noIgnoreVcs             = Don't respect version control ignore files
    noLineNumber            = Suppress line numbers
    noMessages              = Suppress error messages
    noMmap                  = Never use memory maps
    noPcre2Unicode          = Disable Unicode mode for PCRE2
    noUnicode               = Disable Unicode mode
    null                    = Print NUL byte after file names
    nullData                = Use NUL as line terminator
    oneFileSystem           = Don't descend into directories on other file systems
    onlyMatching            = Print only matched parts of lines
    pathSeparator           = Set the path separator
    passthru                = Print both matching and non-matching lines
    pcre2                   = Use PCRE2 for regex engine
    pre                     = Execute command before searching
    preGlob                 = Include/exclude files from --pre
    pretty                  = Alias for --color always --heading --line-number
    quiet                   = Don't print anything
    regexSizeLimit          = Set the max size of compiled regex
    regexp                  = Use pattern for searching
    replace                 = Replace matches with string
    searchZip               = Search in compressed files
    smartCase               = Search case insensitively if pattern is all lowercase
    sort                    = Sort results
    sortr                   = Sort results in reverse
    stats                   = Print statistics about search
    text                    = Search binary files as if they were text
    threads                 = The number of threads to use
    trace                   = Show trace messages
    trim                    = Trim whitespace from matching lines
    type                    = Only search files matching TYPE
    typeAdd                 = Add a new file type
    typeClear               = Clear file type definitions
    typeList                = Show all supported file types
    typeNot                 = Don't search files matching TYPE
    unrestricted            = Reduce respect for ignore files
    vimgrep                 = Show results in vim compatible format
    withFilename            = Print file name for each match
    wordRegexp              = Only show matches surrounded by word boundaries
    help                    = Prints help information
    version                 = Prints version information
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name rg -Description $msg.rg -Parameters @(
    New-ParamCompleter -ShortName A -LongName after-context -Description $msg.afterContext -Type Required -VariableName 'NUM'
    New-ParamCompleter -ShortName B -LongName before-context -Description $msg.beforeContext -Type Required -VariableName 'NUM'
    New-ParamCompleter -ShortName C -LongName context -Description $msg.context -Type Required -VariableName 'NUM'
    New-ParamCompleter -LongName binary -Description $msg.binary
    New-ParamCompleter -LongName block-buffered -Description $msg.blockBuffered
    New-ParamCompleter -ShortName b -LongName byte-offset -Description $msg.byteOffset
    New-ParamCompleter -ShortName s -LongName case-sensitive -Description $msg.caseSensitive
    New-ParamCompleter -LongName color -Description $msg.color -Arguments 'never','auto','always','ansi' -VariableName 'WHEN'
    New-ParamCompleter -LongName colors -Description $msg.colors -Type Required -VariableName 'COLOR_SPEC'
    New-ParamCompleter -LongName column -Description $msg.column
    New-ParamCompleter -LongName context-separator -Description $msg.contextSeparator -Type Required -VariableName 'SEPARATOR'
    New-ParamCompleter -ShortName c -LongName count -Description $msg.count
    New-ParamCompleter -LongName count-matches -Description $msg.countMatches
    New-ParamCompleter -LongName crlf -Description $msg.crlf
    New-ParamCompleter -LongName debug -Description $msg.debug
    New-ParamCompleter -LongName dfa-size-limit -Description $msg.dfaSizeLimit -Type Required -VariableName 'NUM+SUFFIX?'
    New-ParamCompleter -ShortName E -LongName encoding -Description $msg.encoding -Type Required -VariableName 'ENCODING'
    New-ParamCompleter -LongName engine -Description $msg.engine -Arguments 'default','pcre2','auto' -VariableName 'ENGINE'
    New-ParamCompleter -ShortName f -LongName file -Description $msg.file -Type File -VariableName 'PATTERNFILE'
    New-ParamCompleter -LongName files -Description $msg.files
    New-ParamCompleter -ShortName l -LongName files-with-matches -Description $msg.filesWithMatches
    New-ParamCompleter -LongName files-without-match -Description $msg.filesWithoutMatch
    New-ParamCompleter -ShortName F -LongName fixed-strings -Description $msg.fixedStrings
    New-ParamCompleter -ShortName L -LongName follow -Description $msg.follow
    New-ParamCompleter -ShortName g -LongName glob -Description $msg.glob -Type Required -VariableName 'GLOB'
    New-ParamCompleter -LongName glob-case-insensitive -Description $msg.globCaseInsensitive
    New-ParamCompleter -LongName heading -Description $msg.heading
    New-ParamCompleter -LongName hidden -Description $msg.hidden
    New-ParamCompleter -LongName iglob -Description $msg.iglob -Type Required -VariableName 'GLOB'
    New-ParamCompleter -ShortName i -LongName ignore-case -Description $msg.ignoreCase
    New-ParamCompleter -LongName ignore-file -Description $msg.ignoreFile -Type File -VariableName 'PATH'
    New-ParamCompleter -LongName ignore-file-case-insensitive -Description $msg.ignoreFileCaseInsensitive
    New-ParamCompleter -LongName include-zero -Description $msg.includeZero
    New-ParamCompleter -ShortName v -LongName invert-match -Description $msg.invertMatch
    New-ParamCompleter -LongName json -Description $msg.json
    New-ParamCompleter -LongName line-buffered -Description $msg.lineBuffered
    New-ParamCompleter -ShortName n -LongName line-number -Description $msg.lineNumber
    New-ParamCompleter -ShortName x -LongName line-regexp -Description $msg.lineRegexp
    New-ParamCompleter -ShortName M -LongName max-columns -Description $msg.maxColumns -Type Required -VariableName 'NUM'
    New-ParamCompleter -LongName max-columns-preview -Description $msg.maxColumnsPreview
    New-ParamCompleter -ShortName m -LongName max-count -Description $msg.maxCount -Type Required -VariableName 'NUM'
    New-ParamCompleter -LongName max-depth -Description $msg.maxDepth -Type Required -VariableName 'NUM'
    New-ParamCompleter -LongName max-filesize -Description $msg.maxFilesize -Type Required -VariableName 'NUM+SUFFIX?'
    New-ParamCompleter -LongName mmap -Description $msg.mmap
    New-ParamCompleter -ShortName U -LongName multiline -Description $msg.multiline
    New-ParamCompleter -LongName multiline-dotall -Description $msg.multilineDotall
    New-ParamCompleter -LongName no-config -Description $msg.noConfig
    New-ParamCompleter -LongName no-heading -Description $msg.noHeading
    New-ParamCompleter -LongName no-ignore -Description $msg.noIgnore
    New-ParamCompleter -LongName no-ignore-dot -Description $msg.noIgnoreDot
    New-ParamCompleter -LongName no-ignore-exclude -Description $msg.noIgnoreExclude
    New-ParamCompleter -LongName no-ignore-files -Description $msg.noIgnoreFiles
    New-ParamCompleter -LongName no-ignore-global -Description $msg.noIgnoreGlobal
    New-ParamCompleter -LongName no-ignore-messages -Description $msg.noIgnoreMessages
    New-ParamCompleter -LongName no-ignore-parent -Description $msg.noIgnoreParent
    New-ParamCompleter -LongName no-ignore-vcs -Description $msg.noIgnoreVcs
    New-ParamCompleter -ShortName N -LongName no-line-number -Description $msg.noLineNumber
    New-ParamCompleter -LongName no-messages -Description $msg.noMessages
    New-ParamCompleter -LongName no-mmap -Description $msg.noMmap
    New-ParamCompleter -LongName no-pcre2-unicode -Description $msg.noPcre2Unicode
    New-ParamCompleter -LongName no-unicode -Description $msg.noUnicode
    New-ParamCompleter -ShortName '0' -LongName null -Description $msg.null
    New-ParamCompleter -LongName null-data -Description $msg.nullData
    New-ParamCompleter -LongName one-file-system -Description $msg.oneFileSystem
    New-ParamCompleter -ShortName o -LongName only-matching -Description $msg.onlyMatching
    New-ParamCompleter -LongName path-separator -Description $msg.pathSeparator -Type Required -VariableName 'SEPARATOR'
    New-ParamCompleter -LongName passthru -Description $msg.passthru
    New-ParamCompleter -ShortName P -LongName pcre2 -Description $msg.pcre2
    New-ParamCompleter -LongName pre -Description $msg.pre -Type Required -VariableName 'COMMAND'
    New-ParamCompleter -LongName pre-glob -Description $msg.preGlob -Type Required -VariableName 'GLOB'
    New-ParamCompleter -ShortName p -LongName pretty -Description $msg.pretty
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -LongName regex-size-limit -Description $msg.regexSizeLimit -Type Required -VariableName 'NUM+SUFFIX?'
    New-ParamCompleter -ShortName e -LongName regexp -Description $msg.regexp -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -ShortName r -LongName replace -Description $msg.replace -Type Required -VariableName 'REPLACEMENT'
    New-ParamCompleter -ShortName z -LongName search-zip -Description $msg.searchZip
    New-ParamCompleter -ShortName S -LongName smart-case -Description $msg.smartCase
    New-ParamCompleter -LongName sort -Description $msg.sort -Arguments 'none','path','modified','accessed','created' -VariableName 'SORTBY'
    New-ParamCompleter -LongName sortr -Description $msg.sortr -Arguments 'none','path','modified','accessed','created' -VariableName 'SORTBY'
    New-ParamCompleter -LongName stats -Description $msg.stats
    New-ParamCompleter -ShortName a -LongName text -Description $msg.text
    New-ParamCompleter -ShortName j -LongName threads -Description $msg.threads -Type Required -VariableName 'NUM'
    New-ParamCompleter -LongName trace -Description $msg.trace
    New-ParamCompleter -LongName trim -Description $msg.trim
    New-ParamCompleter -ShortName t -LongName type -Description $msg.type -Type Required -VariableName 'TYPE'
    New-ParamCompleter -LongName type-add -Description $msg.typeAdd -Type Required -VariableName 'TYPESPEC'
    New-ParamCompleter -LongName type-clear -Description $msg.typeClear -Type Required -VariableName 'TYPE'
    New-ParamCompleter -LongName type-list -Description $msg.typeList
    New-ParamCompleter -ShortName T -LongName type-not -Description $msg.typeNot -Type Required -VariableName 'TYPE'
    New-ParamCompleter -ShortName u -LongName unrestricted -Description $msg.unrestricted
    New-ParamCompleter -LongName vimgrep -Description $msg.vimgrep
    New-ParamCompleter -ShortName H -LongName with-filename -Description $msg.withFilename
    New-ParamCompleter -ShortName w -LongName word-regexp -Description $msg.wordRegexp
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    if ($argIndex -eq 0 -and -not $this.BoundParameters.ContainsKey("regexp") -and -not $this.BoundParameters.ContainsKey("file"))
    {
        if ([string]::IsNullOrEmpty($_))
        {
            "pattern`tSpecify a search pattern"
        }
        else
        {
            $null
        }
    }
}
