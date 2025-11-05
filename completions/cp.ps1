<#
 # cp completion
 #>
Import-Module NativeCommandCompleter.psm

if ($IsLinux)
{
    Register-NativeCompleter -Name cp -Parameters @(
        New-ParamCompleter -ShortName a -LongName archive -Description "Same as -dpR"
        New-ParamCompleter -LongName attributes-only -Description "Copy just the attributes"
        New-ParamCompleter -LongName backup -Description "Make backup of each existing destination file" -Arguments @(
            "none `tNever make backups"
            "off `tNever make backups"
            "numbered `tMake numbered backups"
            "t `tMake numbered backups"
            "existing `tNumbered backups if any exist, else simple"
            "nil `tNumbered backups if any exist, else simple"
            "simple `tMake simple backups"
            "never `tMake simple backups"
        )
        New-ParamCompleter -ShortName b -Description "Make backup of each existing destination file"
        New-ParamCompleter -LongName copy-contents -Description "Copy contents of special files when recursive"
        New-ParamCompleter -ShortName d -Description "Same as --no-dereference --preserve=link"
        New-ParamCompleter -ShortName f -LongName force -Description "Do not prompt before overwriting"
        New-ParamCompleter -ShortName i -LongName interactive -Description "Prompt before overwrite"
        New-ParamCompleter -ShortName H -Description "Follow command-line symbolic links"
        New-ParamCompleter -ShortName l -LongName link -Description "Link files instead of copying"
        New-ParamCompleter -LongName strip-trailing-ShortNamelashes -Description "Remove trailing slashes from source"
        New-ParamCompleter -ShortName S -LongName suffix -Description "Backup suffix" -Type Required
        New-ParamCompleter -ShortName t -LongName target-directory -Description "Target directory" -Type File
        New-ParamCompleter -ShortName u -LongName update -Description "Do not overwrite newer files"
        New-ParamCompleter -ShortName v -LongName verbose -Description "Verbose mode"
        New-ParamCompleter -LongName help -Description "Display help and exit"
        New-ParamCompleter -LongName version -Description "Display version and exit"
        New-ParamCompleter -ShortName L -LongName dereference -Description "Always follow symbolic links"
        New-ParamCompleter -ShortName n -LongName no-clobber -Description "Do not overwrite an existing file"
        New-ParamCompleter -ShortName P -LongName no-dereference -Description "Never follow symbolic links"
        New-ParamCompleter -ShortName p -Description "Same as --preserve=mode,ownership,timestamps"
        New-ParamCompleter -LongName preserve -Description "Preserve ATTRIBUTES if possible" -Arguments 'mode','ownership','timestamps','links','all'
        New-ParamCompleter -LongName no-preserve -Description "Don't preserve ATTRIBUTES" -Arguments 'mode','ownership','timestamps','links','all'
        New-ParamCompleter -LongName parents -Description "Use full source file name under DIRECTORY"
        New-ParamCompleter -ShortName r,R -LongName recursive -Description "Copy directories recursively"
        New-ParamCompleter -LongName reflink -Description "Control clone/CoW copies" -Type FlagOrValue -Arguments 'always','auto','never'
        New-ParamCompleter -LongName remove-destination -Description "First remove existing destination files"
        New-ParamCompleter -LongName sparse -Description "Control creation of sparse files" -Arguments 'always','auto','never'
        New-ParamCompleter -ShortName s -LongName symbolic-link -Description "Make symbolic links instead of copying"
        New-ParamCompleter -ShortName T -LongName no-target-directory -Description "Treat DEST as a normal file"
        New-ParamCompleter -ShortName x -LongName one-file-ShortNameystem -Description "Stay on this file system"
        New-ParamCompleter -ShortName Z -Description "Set SELinux context of copy to default type"
        New-ParamCompleter -ShortName X -LongName context -Description "Set SELinux context of copy to CONTEXT" -Type Required
    )
}
