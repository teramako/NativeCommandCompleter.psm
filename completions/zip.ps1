<#
 # zip completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    freshen          = Freshen: only changed files
    delete           = Delete entries in zipfile
    update           = Update: only changed or newer files
    move             = Move into zipfile (delete files)
    recursive        = Operate recursively
    junk_paths       = Do not store directory names
    no_compression   = Do not compress at all
    to_crlf          = Convert LF to CR LF
    from_crlf        = Convert CR LF to LF
    compress_level_1 = Compress faster
    compress_level_6 = Default compression level
    compress_level_9 = Compress better
    quiet            = Quiet mode
    verbose          = Verbose mode
    comments         = Add one-line comments
    archive_comment  = Add zipfile comments
    names_stdin      = Read names from stdin
    latest_time      = Make zipfile as old as the latest entry
    exclude          = Exclude the following names
    include          = Include only the following names
    fix              = Fix zipfile
    fixfix           = Fix zipfile (try harder)
    adjust_sfx       = Adjust offsets to suit self-extracting exe
    junk_sfx         = Strip prepended data
    test             = Test zipfile integrity
    no_extra         = Exclude extra file attributes
    symlinks         = Store symbolic links as links
    recurse_patterns = PKZIP recursion
    encrypt          = Encrypt
    suffixes         = Don't compress files with these suffixes
    help             = Display help and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name zip -Parameters @(
    New-ParamCompleter -ShortName f -Description $msg.freshen
    New-ParamCompleter -ShortName d -Description $msg.delete
    New-ParamCompleter -ShortName u -Description $msg.update
    New-ParamCompleter -ShortName m -Description $msg.move
    New-ParamCompleter -ShortName r -Description $msg.recursive
    New-ParamCompleter -ShortName j -Description $msg.junk_paths
    New-ParamCompleter -ShortName '0' -Description $msg.no_compression
    New-ParamCompleter -ShortName l -Description $msg.to_crlf
    New-ParamCompleter -Name ll -Description $msg.from_crlf
    New-ParamCompleter -ShortName '1' -Description $msg.compress_level_1
    New-ParamCompleter -ShortName '6' -Description $msg.compress_level_6
    New-ParamCompleter -ShortName '9' -Description $msg.compress_level_9
    New-ParamCompleter -ShortName q -Description $msg.quiet
    New-ParamCompleter -ShortName v -Description $msg.verbose
    New-ParamCompleter -ShortName c -Description $msg.comments
    New-ParamCompleter -ShortName z -Description $msg.archive_comment
    New-ParamCompleter -ShortName '@' -Description $msg.names_stdin
    New-ParamCompleter -ShortName o -Description $msg.latest_time
    New-ParamCompleter -ShortName x -Description $msg.exclude -Type Required
    New-ParamCompleter -ShortName i -Description $msg.include -Type Required
    New-ParamCompleter -ShortName F -Description $msg.fix
    New-ParamCompleter -Name FF -Description $msg.fixfix
    New-ParamCompleter -ShortName A -Description $msg.adjust_sfx
    New-ParamCompleter -ShortName J -Description $msg.junk_sfx
    New-ParamCompleter -ShortName T -Description $msg.test
    New-ParamCompleter -ShortName X -Description $msg.no_extra
    New-ParamCompleter -ShortName y -Description $msg.symlinks
    New-ParamCompleter -ShortName R -Description $msg.recurse_patterns
    New-ParamCompleter -ShortName e -Description $msg.encrypt
    New-ParamCompleter -ShortName n -Description $msg.suffixes -Type Required
    New-ParamCompleter -ShortName h -Description $msg.help
)
