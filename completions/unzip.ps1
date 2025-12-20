<#
 # unzip completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    pipe     = extract files to pipe, no messages
    freshen  = freshen existing files, create none
    update   = update files, create if necessary
    verbose_or_version  = list verbosely/show version info
    exclude             = exclude files that follow (in xlist)
    list                = list files (short format)
    test                = test compressed archive datamodifiers:
    archive_comment     = display archive comment only
    timestamp           = timestamp archive to latest
    extract_to_dir      = extract files into dir
    never_overwrite     = never overwrite existing files
    overwrite           = overwrite files WITHOUT prompting
    quiet               = quiet mode
    quieter             = quieter mode
    ascii               = auto-convert any text files
    unicode             = use escapes for all non-ASCII Unicode
    ignore_unicode      = ignore any Unicode fields
    junk_paths          = junk paths (do not make directories)
    all_ascii           = treat ALL files as text
    case_insensitive    = match filenames case-insensitively
    to_lower_case       = make (some) names lowercase
    restore_owner_info  = restore UID/GID info
    retain_VMS_version  = retain VMS version numbers
    keep_permissions    = keep setuid/setgid/tacky permissions
    pipe_to_pager       = pipe through `more` pager
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name unzip -Parameters @(
    New-ParamCompleter -ShortName p -Description $msg.pipe
    New-ParamCompleter -ShortName f -Description $msg.freshen
    New-ParamCompleter -ShortName u -Description $msg.update
    New-ParamCompleter -ShortName v -Description $msg.verbose_or_version
    New-ParamCompleter -ShortName x -Description $msg.exclude -Type Required
    New-ParamCompleter -ShortName l -Description $msg.list
    New-ParamCompleter -ShortName t -Description $msg.test
    New-ParamCompleter -ShortName z -Description $msg.archive_comment
    New-ParamCompleter -ShortName T -Description $msg.timestamp
    New-ParamCompleter -ShortName d -Description $msg.extract_to_dir -Type Directory
    New-ParamCompleter -ShortName n -Description $msg.never_overwrite
    New-ParamCompleter -ShortName o -Description $msg.overwrite
    New-ParamCompleter -ShortName q -Description $msg.quiet
    New-ParamCompleter -OldStyleName qq -Description $msg.quieter
    New-ParamCompleter -ShortName a -Description $msg.ascii
    New-ParamCompleter -ShortName U -Description $msg.unicode
    New-ParamCompleter -OldStyleName UU -Description $msg.ignore_unicode
    New-ParamCompleter -ShortName j -Description $msg.junk_paths
    New-ParamCompleter -OldStyleName aa -Description $msg.all_ascii
    New-ParamCompleter -ShortName C -Description $msg.case_insensitive
    New-ParamCompleter -ShortName L -Description $msg.to_lower_case
    New-ParamCompleter -ShortName X -Description $msg.restore_owner_info
    New-ParamCompleter -ShortName V -Description $msg.retain_VMS_version
    New-ParamCompleter -ShortName K -Description $msg.keep_permissions
    New-ParamCompleter -ShortName M -Description $msg.pipe_to_pager
)
