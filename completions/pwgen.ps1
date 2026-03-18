<#
 # pwgen completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    capitalize      = Include at least one capital letter in the password
    no_capitalize   = Don't include capital letters in the password
    numerals        = Include at least one number in the password
    no_numerals     = Don't include numbers in the password
    symbols         = Include at least one special symbol in the password
    secure          = Generate completely random, hard-to-memorize passwords
    ambiguous       = Don't use characters that could be confused (e.g. l/1, 0/O)
    no_vowels       = Generate passwords without vowels or vowel-like numbers
    sha1            = Use SHA1 hash of given file (and optional seed) to generate passwords
    remove_chars    = Remove specified characters from the password character set
    num_passwords   = Generate the specified number of passwords
    one_per_line    = Print generated passwords one per line
    columns         = Print generated passwords in columns
    alt_phonics     = Alternative phonics mode (backwards compatibility only)
    help            = Print a help message
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name pwgen -Parameters @(
    New-ParamCompleter -ShortName c -LongName capitalize    -Description $msg.capitalize
    New-ParamCompleter -ShortName A -LongName no-capitalize -Description $msg.no_capitalize
    New-ParamCompleter -ShortName n -LongName numerals      -Description $msg.numerals
    New-ParamCompleter -ShortName '0' -LongName no-numerals -Description $msg.no_numerals
    New-ParamCompleter -ShortName y -LongName symbols       -Description $msg.symbols
    New-ParamCompleter -ShortName s -LongName secure        -Description $msg.secure
    New-ParamCompleter -ShortName B -LongName ambiguous     -Description $msg.ambiguous
    New-ParamCompleter -ShortName v -LongName no-vowels     -Description $msg.no_vowels
    New-ParamCompleter -ShortName H -LongName sha1          -Description $msg.sha1 -Type File -VariableName 'path/to/file[#seed]'
    New-ParamCompleter -ShortName r -LongName remove-chars  -Description $msg.remove_chars -Type Required -VariableName 'chars'
    New-ParamCompleter -ShortName N -LongName num-passwords -Description $msg.num_passwords -Type Required -VariableName 'num'
    New-ParamCompleter -ShortName '1'                       -Description $msg.one_per_line
    New-ParamCompleter -ShortName C                         -Description $msg.columns
    New-ParamCompleter -ShortName a -LongName alt-phonics   -Description $msg.alt_phonics
    New-ParamCompleter -ShortName h -LongName help          -Description $msg.help
) -NoFileCompletions

