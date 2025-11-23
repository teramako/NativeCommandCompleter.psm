<#
 # bunzip2 completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    stdout               = Decompress to stdout
    force                = Overwrite
    keep                 = Do not overwrite
    small                = Reduce memory usage
    verbose              = Print compression ratios
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name bunzip2 -Parameters @(
    New-ParamCompleter -ShortName c -LongName stdout -Description $msg.stdout
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -ShortName k -LongName keep -Description $msg.keep
    New-ParamCompleter -ShortName s -LongName small -Description $msg.small
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
) -NoFileCompletions -ArgumentCompleter {
    [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
        $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Name -match '\.t?bz2?$'
    });
}
