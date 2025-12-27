<#
 # wsl completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    wsl                     = Windows Subsystem for Linux
    install                 = Install a Linux distribution
    install_enableWsl1      = Enable WSL1 support.
    install_fixedVhd        = Create a fixed-size disk to store the distribution.
    install_fromFile        = Install a distribution from a local file.
    install_legacy          = Use the legacy distribution manifest.
    install_location        = Set the install path for the distribution.
    install_name            = Set the name of the distribution.
    install_noDistribution  = Only install the required optional components, does not install a distribution.
    install_noLaunch        = Do not launch the distribution after install.
    install_version         = Specifies the version to use for the new distribution.
    install_vhdSize         = Specifies the size of the disk to store the distribution.
    install_webDownload     = Download the distribution from the internet instead of the Microsoft Store.
    manage                  = Changes distro specific options.
    manage_move             = Move distribution to new location
    manage_setSparse        = Set the VHD of distro to be sparse
    manage_setDefaultUser   = Set the default user of the distribution.
    manage_resize           = Resize the disk of the distribution to the specified size.
    mount                   = Mount a disk
    mount_vhd               = Mount VHD
    mount_bare              = Attach without mounting
    mount_name              = Name for mount point
    mount_type              = Filesystem type
    mount_options           = Mount options
    mount_partition         = Partition index
    setDefaultVersion       = Changes the default install version
    shutdown                = Terminate all running distributions
    shutdown_force          = Terminate the WSL 2 VM even if an operation is in progress.
    status                  = Show WSL status
    unmount                 = Unmount a disk
    uninstall               = Uninstalls the WSL package
    update                  = Update WSL components
    update_prerelease       = Download a pre-release version if available.
    version                 = Display version information
    export                  = Export distribution to a tar file
    export_format           = Specifies the export format
    import                  = Import a distribution from a tar file
    import_version          = Version of WSL to use
    import_vhd              = Import from VHD file
    importInPlace           = Import a distribution from VHD file
    list                    = List distributions
    list_all                = List all distributions
    list_running            = List only running distributions
    list_quiet              = Show only distribution names
    list_verbose            = Show detailed information
    list_online             = List available distributions online
    setDefault              = Set the default distribution
    setVersion              = Changes the version of the specified distribution.
    unregister              = Unregisters the distribution and deletes the root filesystem.
    terminate               = Terminate a distribution
    help                    = Display help information

    exec                    = Execute a command
    cd                      = Set working directory
    distribution            = Specify distribution
    user                    = Run as specified user
    systemDistribution      = Use system distribution
    shellType              = Shell type to use
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$distributionCompleter = {
    $enc = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-16")
    try {
        wsl --list --quiet | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
            $name = $_.Trim()
            if ($name -like "$wordToComplete*") {
                $name
            }
        }
    }
    finally { [Console]::OutputEncoding = $enc; }
}

$runningDistributionCompleter = {
    $enc = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-16")
    try {
        wsl --list --running --quiet | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
            $name = $_.Trim()
            if ($name -like "$wordToComplete*") {
                $name
            }
        }
    }
    finally { [Console]::OutputEncoding = $enc; }
}

$onlineDistributionCompleter = {
    $enc = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-16")
    try {
        wsl --list --online | Select-Object -Skip 2 |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and $_ -notlike 'NAME*' } |
            ForEach-Object {
                if ($_ -match '^(\S+)\s+(.+)$') {
                    $name = $Matches[1]
                    $desc = $Matches[2].Trim()
                    if ($name -like "$wordToComplete*") {
                        "{0}`t{1}" -f $name, $desc
                    }
                }
            }
    }
    finally { [Console]::OutputEncoding = $enc; }
}

Register-NativeCompleter -Name wsl -Description $msg.wsl -Parameters @(
    New-ParamCompleter -LongName cd -Description $msg.cd -Type Directory
    New-ParamCompleter -Name d -LongName distribution -Description $msg.distribution -VariableName 'distro' -ArgumentCompleter $distributionCompleter
    New-ParamCompleter -Name u -LongName user -Description $msg.user -Type Required -VariableName 'username'
    New-ParamCompleter -Name e -LongName exec -Description $msg.exec -Type Required -VariableName 'command'
    New-ParamCompleter -LongName system -Description $msg.systemDistribution
    New-ParamCompleter -LongName shell-type -Description $msg.shellType -Arguments "standard","login","none" -VariableName 'type'
) -SubCommands @(
    New-CommandCompleter -Name '--help' -Description $msg.help -NoFileCompletions

    New-CommandCompleter -Name '--install' -Description $msg.install -Parameters @(
        New-ParamCompleter -LongName enable-wsl1 -Description $msg.install_enableWsl1
        New-ParamCompleter -LongName fixed-vhd -Description $msg.install_fixedVhd
        New-ParamCompleter -LongName from-file -Description $msg.install_fromFile -Type File -VariableName 'path'
        New-ParamCompleter -LongName legacy -Description $msg.install_legacy
        New-ParamCompleter -LongName location -Description $msg.install_location -Type Directory
        New-ParamCompleter -LongName name -Description $msg.install_name -Type Required -VariableName 'name'
        New-ParamCompleter -LongName no-distribution -Description $msg.install_noDistribution
        New-ParamCompleter -Name n -LongName no-launch -Description $msg.install_noLaunch
        New-ParamCompleter -LongName version -Description $msg.install_version -Type Required -VariableName 'version'
        New-ParamCompleter -LongName vhd-size -Description $msg.install_vhdSize -Type Required -VariableName 'size'
        New-ParamCompleter -LongName web-download -Description $msg.install_webDownload
    ) -NoFileCompletions -ArgumentCompleter $onlineDistributionCompleter

    New-CommandCompleter -Name '--manage' -Description $msg.manage -Parameters @(
        New-ParamCompleter -LongName move -Description $msg.manage_move -Type Directory -VariableName 'location'
        New-ParamCompleter -Name s -LongName set-sparse -Description $msg.manage_setSparse -Arguments "true", "false"
        New-ParamCompleter -LongName set-default-user -Description $msg.manage_setDefaultUser -Type Required -VariableName 'username'
        New-ParamCompleter -LongName resize -Description $msg.manage_resize -Type Required -VariableName 'size'
    ) -NoFileCompletions -ArgumentCompleter $distributionCompleter
    
    New-CommandCompleter -Name '--mount' -Description $msg.mount -Parameters @(
        New-ParamCompleter -LongName vhd -Description $msg.mount_vhd
        New-ParamCompleter -LongName bare -Description $msg.mount_bare
        New-ParamCompleter -LongName name -Description $msg.mount_name -Type Required -VariableName 'name'
        New-ParamCompleter -LongName type -Description $msg.mount_type -Type Required -VariableName 'filesystem'
        New-ParamCompleter -LongName options -Description $msg.mount_options -Type Required -VariableName 'options'
        New-ParamCompleter -LongName partition -Description $msg.mount_partition -Type Required -VariableName 'index'
    ) -NoFileCompletions

    New-CommandCompleter -Name '--set-default-version' -Description $msg.setDefaultVersion -NoFileCompletions

    New-CommandCompleter -Name '--shutdown' -Description $msg.shutdown -Parameters @(
        New-ParamCompleter -LongName force -Description $msg.shutdown_force
    ) -NoFileCompletions

    New-CommandCompleter -Name '--status' -Description $msg.status -NoFileCompletions
    
    New-CommandCompleter -Name '--unmount' -Description $msg.unmount -NoFileCompletions

    New-CommandCompleter -Name '--uninstall' -Description $msg.uninstall -NoFileCompletions
    
    New-CommandCompleter -Name '--update' -Description $msg.update -Parameters @(
        New-ParamCompleter -LongName pre-release -Description $msg.update_prerelease
    ) -NoFileCompletions

    New-CommandCompleter -Name '--version' -Aliases '-v' -Description $msg.version -NoFileCompletions
    
    New-CommandCompleter -Name '--export' -Description $msg.export -Parameters @(
        New-ParamCompleter -LongName format -Description $msg.export_format -Arguments "tar", "tar.gz", "tar.xz", "vhd" -VariableName 'format'
    ) -ArgumentCompleter {
        param([int] $position, [int] $argIndex)
        if ($argIndex -eq 0) {
            wsl --list --quiet | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
                $name = $_.Trim()
                if ($name -like "$wordToComplete*") {
                    "{0}`tDistribution" -f $name
                }
            }
        }
    }

    New-CommandCompleter -Name '--import' -Description $msg.import -Parameters @(
        New-ParamCompleter -LongName version -Description $msg.import_version -Arguments "1","2" -VariableName 'version'
        New-ParamCompleter -LongName vhd -Description $msg.import_vhd
    ) -NoFileCompletions -ArgumentCompleter {
        param([int] $position, [int] $argIndex)
        switch ($argIndex) {
            1 {
                # Import location
                [MT.Comp.Helper]::CompleteFilename($this, $false, $true);
            }
            2 {
                # File
                [MT.Comp.Helper]::CompleteFilename($this, $false, $false);
            }
            default { $null }
        }
    }

    New-CommandCompleter -Name '--import-in-place' -Description $msg.importInPlace -NoFileCompletions -ArgumentCompleter {
        param([int] $position, [int] $argIndex)
        if ($argIndex -eq 1) {
            # File
            [MT.Comp.Helper]::CompleteFilename($this, $false, $false);
        }
    }

    New-CommandCompleter -Name '--list' -Aliases '-l' -Description $msg.list -Parameters @(
        New-ParamCompleter -LongName all -Description $msg.list_all
        New-ParamCompleter -LongName running -Description $msg.list_running
        New-ParamCompleter -Name q -LongName quiet -Description $msg.list_quiet
        New-ParamCompleter -Name v -LongName verbose -Description $msg.list_verbose
        New-ParamCompleter -Name o -LongName online -Description $msg.list_online
    ) -NoFileCompletions

    New-CommandCompleter -Name '--set-default' -Aliases '-s' -Description $msg.setDefault -NoFileCompletions -ArgumentCompleter $distributionCompleter

    New-CommandCompleter -Name '--set-version' -Description $msg.setVersion -NoFileCompletions -ArgumentCompleter $distributionCompleter

    New-CommandCompleter -Name '--terminate' -Aliases '-t' -Description $msg.terminate -NoFileCompletions -ArgumentCompleter $runningDistributionCompleter

    New-CommandCompleter -Name '--unregister' -Description $msg.unregister -NoFileCompletions -ArgumentCompleter $distributionCompleter
)
