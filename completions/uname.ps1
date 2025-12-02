<#
 # uname completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    gnu_all                = Print all information
    gnu_kernel_name        = Print the kernel name
    gnu_nodename           = Print the network node hostname
    gnu_kernel_release     = Print the kernel release
    gnu_kernel_version     = Print the kernel version
    gnu_machine            = Print the machine hardware name
    gnu_processor          = Print the processor type
    gnu_hardware_platform  = Print the hardware platform
    gnu_operating_system   = Print the operating system
    gnu_help               = Display help and exit
    gnu_version            = Display version and exit
    bsd_all                = Behave as though all of the options mnrsv were specified.
    bsd_machine            = Print the machine hardware name.
    bsd_nodename           = Print the nodename
    bsd_processor          = Print the machine processor architecture name.
    bsd_kernel_release     = Print the operating system release.
    bsd_kernel_name        = Print the operating system name.
    bsd_kernel_version     = Print the operating system version.
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU uname
uname --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU uname
{
    Register-NativeCompleter -Name uname -Description 'print system information' -Parameters @(
        New-ParamCompleter -ShortName a -LongName all -Description $msg.gnu_all
        New-ParamCompleter -ShortName s -LongName kernel-name -Description $msg.gnu_kernel_name
        New-ParamCompleter -ShortName n -LongName nodename -Description $msg.gnu_nodename
        New-ParamCompleter -ShortName r -LongName kernel-release -Description $msg.gnu_kernel_release
        New-ParamCompleter -ShortName v -LongName kernel-version -Description $msg.gnu_kernel_version
        New-ParamCompleter -ShortName m -LongName machine -Description $msg.gnu_machine
        New-ParamCompleter -ShortName p -LongName processor -Description $msg.gnu_processor
        New-ParamCompleter -ShortName i -LongName hardware-platform -Description $msg.gnu_hardware_platform
        New-ParamCompleter -ShortName o -LongName operating-system -Description $msg.gnu_operating_system
        New-ParamCompleter -LongName help -Description $msg.gnu_help
        New-ParamCompleter -LongName version -Description $msg.gnu_version
    ) -NoFileCompletions
}
else
{
    Register-NativeCompleter -Name uname -Description 'print system information' -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.bsd_all
        New-ParamCompleter -ShortName m -Description $msg.bsd_machine
        New-ParamCompleter -ShortName n -Description $msg.bsd_nodename
        New-ParamCompleter -ShortName p -Description $msg.bsd_processor
        New-ParamCompleter -ShortName r -Description $msg.bsd_kernel_release
        New-ParamCompleter -ShortName s -Description $msg.bsd_kernel_name
        New-ParamCompleter -ShortName v -Description $msg.bsd_kernel_version
    ) -NoFileCompletions
}