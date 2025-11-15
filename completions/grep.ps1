<#
 # grep completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    after-context         = Print NUM lines of trailing context
    text                  = Process binary file as text
    before-context        = Print NUM lines of leading context
    context               = Print NUM lines of context
    byte-offset           = Print byte offset of matches
    binary-files          = Assume data type for binary files
    color                 = Color output
    count                 = Only print number of matches
    devices               = Action for devices
    directories           = Action for devices
    extended-regexp       = Pattern is extended regexp
    regexp                = Specify a pattern
    exclude-from          = Read pattern list from file. Skip files whose base name matches list
    exclude-dir           = Exclude matching directories from recursive searches
    fixed-strings         = Pattern is a fixed string
    file                  = Use patterns from a file
    basic-regexp          = Pattern is basic regex
    with-filename         = Print filename
    no-filename           = Suppress printing filename
    help                  = Display help and exit
    skip-binary-files     = Skip binary files
    ignore-case           = Ignore case
    files-without-match   = Print name of files without matches
    files-with-matches    = Print name of files with matches
    max-count             = Stop reading after NUM matches
    mmap                  = Use the mmap system call to read input
    line-number           = Print line number
    only-matching         = Show only matching part
    label                 = Rename stdin
    line-buffered         = Use line buffering
    perl-regexp           = Pattern is a Perl regexp (PCRE) string
    quiet                 = Do not write anything
    dereference-recursive = Recursively read files under each directory, following symlinks
    recursive             = Recursively read files under each directory
    include               = Search only files matching PATTERN
    exclude               = Skip files matching PATTERN
    no-messages           = Suppress error messages
    initial-tab           = Ensure first character of actual line content lies on a tab stop
    binary                = Treat files as binary
    unix-byte-offsets     = Report Unix-style byte offsets
    version               = Display version and exit
    invert-match          = Invert the sense of matching
    word-regexp           = Only whole matching words
    line-regexp           = Only whole matching lines
    null-data             = Treat input as a set of zero-terminated lines
    null                  = Output a zero byte after filename
    group-separator       = Set a group separator
    no-group-separator    = Use empty string as a group separator
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name grep -Parameters @(
    New-ParamCompleter -ShortName A -LongName after-context -Type Required -Description $msg."after-context"
    New-ParamCompleter -ShortName a -LongName text -Description $msg."text"
    New-ParamCompleter -ShortName B -LongName before-context -Type Required -Description $msg."before-context"
    New-ParamCompleter -ShortName C -LongName context -Type Required -Description $msg."context"
    New-ParamCompleter -ShortName b -LongName byte-offset -Description $msg."byte-offset"
    New-ParamCompleter -LongName binary-files -Description $msg."binary-files" -Arguments "binnary`tBinary format", "text`tText format"
    New-ParamCompleter -LongName color,colour -Description $msg."color" -Type FlagOrValue -Arguments 'never','always','auto'
    New-ParamCompleter -ShortName c -LongName count -Description $msg."count"
    New-ParamCompleter -ShortName D -LongName devices -Description $msg."devices" -Arguments 'read', 'skip'
    New-ParamCompleter -ShortName d -LongName directories -Description $msg."directories" -Arguments 'read', 'skip', 'recurse'
    New-ParamCompleter -ShortName E -LongName extended-regexp -Description $msg."extended-regexp"
    New-ParamCompleter -ShortName e -LongName regexp -Type Required -Description $msg."regexp"
    New-ParamCompleter -LongName exclude-from -Type File -Description $msg."exclude-from"
    New-ParamCompleter -LongName exclude-dir -Type Required -Description $msg."exclude-dir"
    New-ParamCompleter -ShortName F -LongName fixed-strings -Description $msg."fixed-strings"
    New-ParamCompleter -ShortName f -LongName file -Type File -Description $msg."file"
    New-ParamCompleter -ShortName G -LongName basic-regexp -Description $msg."basic-regexp"
    New-ParamCompleter -ShortName H -LongName with-filename -Description $msg."with-filename"
    New-ParamCompleter -ShortName h -LongName no-filename -Description $msg."no-filename"
    New-ParamCompleter -LongName help -Description $msg."help"
    New-ParamCompleter -ShortName I -Description $msg."skip-binary-files"
    New-ParamCompleter -ShortName i -LongName ignore-case -Description $msg."ignore-case"
    New-ParamCompleter -ShortName L -LongName files-without-match -Description $msg."files-without-match"
    New-ParamCompleter -ShortName l -LongName files-with-matches -Description $msg."files-with-matches"
    New-ParamCompleter -ShortName m -LongName max-count -Description $msg."max-count"
    New-ParamCompleter -LongName mmap -Description $msg."mmap"
    New-ParamCompleter -ShortName n -LongName line-number -Description $msg."line-number"
    New-ParamCompleter -ShortName o -LongName only-matching -Description $msg."only-matching"
    New-ParamCompleter -LongName label -Type Required -Description $msg."label"
    New-ParamCompleter -LongName line-buffered -Description $msg."line-buffered"
    New-ParamCompleter -ShortName P -LongName perl-regexp -Description $msg."perl-regexp"
    New-ParamCompleter -ShortName q -LongName quiet, slient -Description $msg."quiet"
    New-ParamCompleter -ShortName R -LongName dereference-recursive -Description $msg."dereference-recursive"
    New-ParamCompleter -ShortName r -LongName recursive -Description $msg."recursive"
    New-ParamCompleter -LongName include -Type Required -Description $msg."include"
    New-ParamCompleter -LongName exclude -Type Required -Description $msg."exclude"
    New-ParamCompleter -ShortName s -LongName no-messages -Description $msg."no-messages"
    New-ParamCompleter -ShortName T -LongName initial-tab -Description $msg."initial-tab"
    New-ParamCompleter -ShortName U -LongName binary -Description $msg."binary"
    New-ParamCompleter -ShortName u -LongName unix-byte-offsets -Description $msg."unix-byte-offsets"
    New-ParamCompleter -ShortName V -LongName version -Description $msg."version"
    New-ParamCompleter -ShortName v -LongName invert-match -Description $msg."invert-match"
    New-ParamCompleter -ShortName w -LongName word-regexp -Description $msg."word-regexp"
    New-ParamCompleter -ShortName x -LongName line-regexp -Description $msg."line-regexp"
    New-ParamCompleter -ShortName z -LongName null-data -Description $msg."null-data"
    New-ParamCompleter -ShortName Z -LongName null -Description $msg."null"
    New-ParamCompleter -LongName group-separator -Type Required -Description $msg."group-separator"
    New-ParamCompleter -LongName no-group-separator -Description $msg."no-group-separator"
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
