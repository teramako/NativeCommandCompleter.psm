<#
 # grep completion
 #>
Import-Module NativeCommandCompleter.psm

Register-NativeCompleter -Name grep -Parameters @(
    New-ParamCompleter -ShortName A -LongName after-context -Description 'Print NUM lines of trailing context' -Type Required
    New-ParamCompleter -ShortName a -LongName text -Description 'Process binary file as text'
    New-ParamCompleter -ShortName B -LongName before-context -Description 'Print NUM lines of leading context' -Type Required
    New-ParamCompleter -ShortName C -LongName context -Description 'Print NUM lines of context' -Type Required
    New-ParamCompleter -ShortName b -LongName byte-offset -Description 'Print byte offset of matches'
    New-ParamCompleter -LongName binary-files -Description 'Assume data type for binary files' -Arguments "binnary`tBinary format", "text`tText format"
    New-ParamCompleter -LongName color,colour -Description 'Color output' -Type Flag,OnlyWithValueSperator -Arguments 'never','always','auto'
    New-ParamCompleter -ShortName c -LongName count -Description 'Only print number of matches'
    New-ParamCompleter -ShortName D -LongName devices -Description 'Action for devices' -Arguments 'read', 'skip'
    New-ParamCompleter -ShortName d -LongName directories -Description 'Action for directories' -Arguments 'read', 'skip', 'recurse'
    New-ParamCompleter -ShortName E -LongName extended-regexp -Description 'Pattern is extended regexp'
    New-ParamCompleter -ShortName e -LongName regexp -Description 'Specify a pattern' -Type Required
    New-ParamCompleter -LongName exclude-from -Description 'Read pattern list from file. Skip files whose base name matches list' -Type File
    New-ParamCompleter -LongName exclude-dir -Description 'Exclude matching directories from recursive searches' -Type Required
    New-ParamCompleter -ShortName F -LongName fixed-strings -Description 'Pattern is a fixed string'
    New-ParamCompleter -ShortName f -LongName file -Description 'Use patterns from a file' -Type File
    New-ParamCompleter -ShortName G -LongName basic-regexp -Description 'Pattern is basic regex'
    New-ParamCompleter -ShortName H -LongName with-filename -Description 'Print filename'
    New-ParamCompleter -ShortName h -LongName no-filename -Description 'Suppress printing filename'
    New-ParamCompleter -LongName help -Description 'Display help and exit'
    New-ParamCompleter -ShortName I -Description 'Skip binary files'
    New-ParamCompleter -ShortName i -LongName ignore-case -Description 'Ignore case'
    New-ParamCompleter -ShortName L -LongName files-without-match -Description 'Print name of files without matches'
    New-ParamCompleter -ShortName l -LongName files-with-matches -Description 'Print name of files with matches'
    New-ParamCompleter -ShortName m -LongName max-count -Description 'Stop reading after NUM matches'
    New-ParamCompleter -LongName mmap -Description 'Use the mmap system call to read input'
    New-ParamCompleter -ShortName n -LongName line-number -Description 'Print line number'
    New-ParamCompleter -ShortName o -LongName only-matching -Description 'Show only matching part'
    New-ParamCompleter -LongName label -Description 'Rename stdin' -Type Required
    New-ParamCompleter -LongName line-buffered -Description 'Use line buffering'
    New-ParamCompleter -ShortName P -LongName perl-regexp -Description 'Pattern is a Perl regexp (PCRE) string'
    New-ParamCompleter -ShortName q -LongName quiet -Description 'Do not write anything'
    New-ParamCompleter -LongName silent -Description 'Do not write anything'
    New-ParamCompleter -ShortName R -LongName dereference-recursive -Description 'Recursively read files under each directory, following symlinks'
    New-ParamCompleter -ShortName r -LongName recursive -Description 'Recursively read files under each directory'
    New-ParamCompleter -LongName include -Description 'Search only files matching PATTERN' -Type Required
    New-ParamCompleter -LongName exclude -Description 'Skip files matching PATTERN' -Type Required
    New-ParamCompleter -ShortName s -LongName no-messages -Description 'Suppress error messages'
    New-ParamCompleter -ShortName T -LongName initial-tab -Description 'Ensure first character of actual line content lies on a tab stop'
    New-ParamCompleter -ShortName U -LongName binary -Description 'Treat files as binary'
    New-ParamCompleter -ShortName u -LongName unix-byte-offsets -Description 'Report Unix-style byte offsets'
    New-ParamCompleter -ShortName V -LongName version -Description 'Display version and exit'
    New-ParamCompleter -ShortName v -LongName invert-match -Description 'Invert the sense of matching'
    New-ParamCompleter -ShortName w -LongName word-regexp -Description 'Only whole matching words'
    New-ParamCompleter -ShortName x -LongName line-regexp -Description 'Only whole matching lines'
    New-ParamCompleter -ShortName z -LongName null-data -Description 'Treat input as a set of zero-terminated lines'
    New-ParamCompleter -ShortName Z -LongName null -Description 'Output a zero byte after filename'
    New-ParamCompleter -LongName group-separator -Description 'Set a group separator' -Type Required
    New-ParamCompleter -LongName no-group-separator -Description 'Use empty string as a group separator'
) -ArgumentCompleter {
    param([string] $wordToComplete, [int] $position, [int] $argIndex, [MT.Comp.CompletionContext] $context)
    if ($argIndex -eq 0 -and -not $context.BoundParameters.ContainsKey("regexp"))
    {
        if ([string]::IsNullOrEmpty($wordToComplete))
        {
            "pattern`tSpecify a pattern"
        }
        else
        {
            $null
        }
    }
}
