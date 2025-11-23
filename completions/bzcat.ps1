<#
 # bzcat completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    small = Reduce memory usage
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name bzcat -Parameters @(
    New-ParamCompleter -ShortName s -LongName small -Description $msg.small
) -NoFileCompletions -ArgumentCompleter {
    [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
        $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Name -match '\.t?bz2?$'
    });
}
