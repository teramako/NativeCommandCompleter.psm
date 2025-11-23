<#
 # bzip2 completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    stdout              = Compress or decompress to stdout
    decompress          = Decompress file
    compress            = Compress file
    test                = Check integrity
    force               = Overwrite
    keep                = Do not overwrite
    small               = Reduce memory usage
    quiet               = Suppress errors
    verbose             = Print compression ratios
    version_and_license = Display version and license
    fast                = Small block size
    best                = Large block size
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name bzip2 -Parameters @(
    New-ParamCompleter -ShortName c -LongName stdout -Description $msg.stdout
    New-ParamCompleter -ShortName d -LongName decompress -Description $msg.decompress
    New-ParamCompleter -ShortName z -LongName compress -Description $msg.compress
    New-ParamCompleter -ShortName t -LongName test -Description $msg.test
    New-ParamCompleter -ShortName f -LongName force -Description $msg.force
    New-ParamCompleter -ShortName k -LongName keep -Description $msg.keep
    New-ParamCompleter -ShortName s -LongName small -Description $msg.small
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
    New-ParamCompleter -ShortName L,V -LongName license,version -Description $msg.version_and_license
    New-ParamCompleter -ShortName '1' -LongName fast -Description $msg.fast
    New-ParamCompleter -ShortName '9' -LongName best -Description $msg.best
) -NoFileCompletions -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    if ($this.BoundParameters.ContainsKey('decompress'))
    {
        [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
            $_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $_.Name -match '\.t?bz2?$'
        });
    }
    else
    {
        [MT.Comp.Helper]::CompleteFilename($this, $false, $false);
    }
}
