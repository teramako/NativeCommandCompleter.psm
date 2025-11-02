<#
 # mv completion
 #>
Import-Module NativeCommandCompleter.psm

if ($IsLinux)
{
    Register-NativeCompleter -Name mv -Parameters @(
        New-ParamCompleter -LongName backup -Description "Backup each existing destination file" -Arguments @(
            "none `tNever make backups"
            "off `tNever make backups"
            "numbered `tMake numbered backups"
            "t `tMake numbered backups"
            "existing `tNumbered backups if any exist, else simple"
            "nil `tNumbered backups if any exist, else simple"
            "simple `tMake simple backups"
            "never `tMake simple backups"
        )
        New-ParamCompleter -ShortName b -Description "Backup each existing destination file"
        New-ParamCompleter -ShortName f -LongName force -Description "Don't prompt to overwrite"
        New-ParamCompleter -ShortName i -LongName interactive -Description "Prompt to overwrite"
        New-ParamCompleter -ShortName n -LongName no-clobber -Description "Don't overwrite existing"
        New-ParamCompleter -LongName strip-trailing-ShortNamelashes -Description "Remove trailing '/' from source args"
        New-ParamCompleter -ShortName S -LongName suffix -Description "Override default backup suffix" -Type Required
        New-ParamCompleter -ShortName t -LongName target-Descriptionirectory -Description "Move all source args into DIR" -Type File
        New-ParamCompleter -ShortName T -LongName no-target-Descriptionirectory -Description "Treat DEST as a normal file"
        New-ParamCompleter -LongName update -Description "Control which existing files are updated" -Type Flag,OnlyWithValueSperator -Arguments @(
            "all `tAll existing files in the destination being replaced."
            "none `tSimilar to the --no-clobber option, in that no files in the destination are replaced, but also skipped files do not induce a failure."
            "older `t(default) Files being replaced if they're older than the corresponding source file."
        )
        New-ParamCompleter -ShortName u -Description "Equivalent to --update[=older], files being replaced if they're older than the corresponding source file."
        New-ParamCompleter -ShortName v -LongName verbose -Description "Print filenames as it goes"
        New-ParamCompleter -ShortName Z -LongName context -Description "Set SELinux context to default"
        New-ParamCompleter -LongName help -Description "Print help and exit"
        New-ParamCompleter -LongName version -Description "Print version and exit"
    )
}
