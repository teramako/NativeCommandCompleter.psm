<#
 # tee completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    append                 = Append to the given files, do not overwrite
    ignoreInterrupts       = Ignore interrupt signals
    pipe                   = operate in a more appropriate MODE with pipes.
    outputError            = Set behavior on write error
    outputError_warn       = Diagnose errors writing to non-pipes
    outputError_warnNopipe = Diagnose errors writing to any output
    outputError_exit       = Exit on error writing to any output
    outputError_exitNopipe = Exit on error writing to any non-pipe
    help                   = Display help and exit
    version                = Display version and exit
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU tee
tee --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU tee
{
    Register-NativeCompleter -Name tee -Parameters @(
        New-ParamCompleter -ShortName a -LongName append -Description $msg.append
        New-ParamCompleter -ShortName i -LongName ignore-interrupts -Description $msg.ignoreInterrupts
        New-ParamCompleter -ShortName p -Description $msg.pipe
        New-ParamCompleter -LongName output-error -Description $msg.outputError -Type FlagOrValue -Arguments @(
            "warn`t{0}" -f $msg.outputError_warn
            "warn-nopipe`t{0}" -f $msg.outputError_warnNopipe
            "exit`t{0}" -f $msg.outputError_exit
            "exit-nopipe`t{0}" -f $msg.outputError_exitNopipe
        ) -VariableName 'MODE'
        New-ParamCompleter -LongName help -Description $msg.help
        New-ParamCompleter -LongName version -Description $msg.version
    )
}
else # BSD tee
{
    Register-NativeCompleter -Name tee -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.append
        New-ParamCompleter -ShortName i -Description $msg.ignoreInterrupts
    )
}
