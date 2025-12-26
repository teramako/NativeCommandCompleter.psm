<#
 # findstr completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    findstr                 = Searches for patterns of text in files
    basic_regex             = Use pattern as basic regular expression
    literal                 = Use search strings literally
    ignore_case             = Case-insensitive search
    regex                   = Use pattern as regular expression
    exact_line              = Print line if pattern matches exactly
    beginning_line          = Match pattern at beginning of line
    end_line                = Match pattern at end of line
    number_line             = Print line number before each matching line
    no_match_line           = Print lines that do not contain a match
    print_only_file         = Print only filename if file contains a match
    print_offset            = Print character offset before each matching line
    recursive               = Search all files in specified directory and subdirectories
    strings_file            = Get search strings from specified file
    file_list               = Get list of files to search from specified file
    skip_binary             = Skip files with non-printable characters
    offline                 = Do not skip files with offline attribute set
    color                   = Specify color attribute with two hex digits
    string                  = Use specified string as literal search string
    dir_list                = Search specified list of directories
    help                    = Display help information
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name findstr -Description $msg.findstr -Style Windows -Parameters @(
    New-ParamCompleter -OldStyleName B -Description $msg.beginning_line
    New-ParamCompleter -OldStyleName E -Description $msg.end_line
    New-ParamCompleter -OldStyleName L -Description $msg.literal
    New-ParamCompleter -OldStyleName R -Description $msg.regex
    New-ParamCompleter -OldStyleName S -Description $msg.recursive
    New-ParamCompleter -OldStyleName I -Description $msg.ignore_case
    New-ParamCompleter -OldStyleName X -Description $msg.exact_line
    New-ParamCompleter -OldStyleName V -Description $msg.no_match_line
    New-ParamCompleter -OldStyleName N -Description $msg.number_line
    New-ParamCompleter -OldStyleName M -Description $msg.print_only_file
    New-ParamCompleter -OldStyleName O -Description $msg.print_offset
    New-ParamCompleter -OldStyleName P -Description $msg.skip_binary
    New-ParamCompleter -OldStyleName OFF,OFFLINE -Description $msg.offline
    New-ParamCompleter -OldStyleName A -Description $msg.color -Type Required -VariableName 'color'
    New-ParamCompleter -OldStyleName F -Description $msg.file_list -Type File -VariableName 'file'
    New-ParamCompleter -OldStyleName C -Description $msg.string -Type Required -VariableName 'string'
    New-ParamCompleter -OldStyleName G -Description $msg.strings_file -Type File -VariableName 'file'
    New-ParamCompleter -OldStyleName D -Description $msg.dir_list -Type Required -VariableName 'dir_list'
    New-ParamCompleter -OldStyleName ? -Description $msg.help
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    if ($argIndex -eq 0 -and -not $this.BoundParameters.ContainsKey('C') -and
                             -not $this.BoundParameters.ContainsKey('G'))
    {
        return $null
    }
}
