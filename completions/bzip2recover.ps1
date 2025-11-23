<#
 # bzip2recover completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

Register-NativeCompleter -Name bzip2recover -NoFileCompletions -ArgumentCompleter {
    [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
        $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Name -match '\.t?bz2?$'
    });
}
