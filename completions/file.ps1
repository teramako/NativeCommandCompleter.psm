<#
 # file completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    brief            = Do not prepend filenames to output lines
    checkingPrintout = Print the parsed form of the magic file
    compile          = Write an output file containing a pre-parsed version of file
    noDereference    = Do not follow symlinks
    mime             = Output mime type strings instead human readable strings
    keepGoing        = Don't stop at the first match
    dereference      = Follow symlinks
    noBuffer         = Flush stdout after checking each file
    noPad            = Don't pad filenames so that they align in the output
    preserveDate     = Attempt to preserve the access time of files analyzed
    raw              = Don't translate unprintable characters to octal
    specialFiles     = Read block and character device files too
    version          = Print the version of the program and exit
    uncompress       = Try to look inside compressed files
    help             = Print a help message and exit
    filesFrom        = Read the names of the files to be examined from a file
    separator        = Use other string as result field separator instead of :
    magicFile        = Alternate list of files containing magic numbers
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name file -Parameters @(
    New-ParamCompleter -ShortName b -LongName brief -Description $msg.brief
    New-ParamCompleter -ShortName c -LongName checking-printout -Description $msg.checkingPrintout
    New-ParamCompleter -ShortName C -LongName compile -Description $msg.compile
    New-ParamCompleter -ShortName h -LongName no-dereference -Description $msg.noDereference
    New-ParamCompleter -ShortName i -LongName mime -Description $msg.mime
    New-ParamCompleter -ShortName k -LongName keep-going -Description $msg.keepGoing
    New-ParamCompleter -ShortName L -LongName dereference -Description $msg.dereference
    New-ParamCompleter -ShortName n -LongName no-buffer -Description $msg.noBuffer
    New-ParamCompleter -ShortName N -LongName no-pad -Description $msg.noPad
    New-ParamCompleter -ShortName p -LongName preserve-date -Description $msg.preserveDate
    New-ParamCompleter -ShortName r -LongName raw -Description $msg.raw
    New-ParamCompleter -ShortName s -LongName special-files -Description $msg.specialFiles
    New-ParamCompleter -ShortName v -LongName version -Description $msg.version
    New-ParamCompleter -ShortName z -LongName uncompress -Description $msg.uncompress
    New-ParamCompleter -LongName help -Description $msg.help
    New-ParamCompleter -ShortName f -LongName files-from -Description $msg.filesFrom -Type Required -VariableName 'namefile'
    New-ParamCompleter -ShortName F -LongName separator -Description $msg.separator -Type Required -VariableName 'separator'
    New-ParamCompleter -ShortName m -LongName magic-file -Description $msg.magicFile -Type Required -VariableName 'magicfiles'
)
