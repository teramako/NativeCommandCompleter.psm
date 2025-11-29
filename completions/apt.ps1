<#
 # apt completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    apt                 = command-line interface for package management
    # Main commands
    list                = List packages based on package names
    search              = Search in package descriptions
    show                = Show package details
    showsrc             = Show source package information
    source              = Download source package
    install             = Install packages
    reinstall           = Reinstall packages
    remove              = Remove packages
    editSources         = Edit the source information file
    update              = Update list of available packages
    upgrade             = Upgrade the system by installing/upgrading packages
    fullUpgrade         = Upgrade the system by removing/installing/upgrading packages
    purge               = Remove packages and config files
    changelog           = Download and display package changelog
    autoremove          = Remove automatically all unused packages
    distclean           = Removes all files under /var/lib/apt/lists except Release
    clean               = Remove downloaded packages from cache
    autoclean           = Remove obsolete packages from cache
    policy              = Display source or package priorities
    depends             = List package dependencies
    rdepends            = List package reverse dependencies
    download            = Download packages
    buildDep            = Install packages needed to build the given package
    satisfy             = Satisfy dependency strings
    
    # Options
    help                = Show help
    version             = Show version
    configFile          = Configuration file
    option              = Set a Configuration Option
    assumeYes           = Automatic yes to prompts
    assumeNo            = Automatic no to prompts
    noShowUpgraded      = Do not show list of upgraded packages
    verbose             = Verbose output
    quiet               = Produce output suitable for logging
    fixBroken           = Fix broken dependencies
    fixMissing          = Ignore missing packages
    noDownload          = Do not download packages
    downloadOnly        = Only download packages
    simulate            = Perform a simulation of events
    dry-run             = No action; perform a simulation
    ignore-hold         = Ignore package Holds
    noUpgrade           = Do not upgrade packages
    onlyUpgrade         = Only upgrade packages
    allow-unauthenticated = Allow installing packages that cannot be authenticated
    noAllowInsecureRepositories = Disallow updates from repositories which cannot be authenticated
    allowDowngrades     = Allow downgrading packages
    allowRemoveEssential = Allow removing essential packages
    allowChangeHeldPackages = Allow changing held packages
    installed           = Installed packages
    manualInstalled     = Manually installed packages
    upgradable          = Upgradable packages
    allVersions         = Show all versions of a package
    targetRelease       = Set target release to install from
    trivial-only        = Only perform operations that are trivial
    noRemove            = Abort if any packages are to be removed
    _autoRemove         = Remove automatically all unused packages
    noInstallRecommends = Do not install recommended packages
    installSuggests     = Install suggested packages
    showProgress        = Show progress information
    withSource          = Show source package records
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$installedPackageCompleter = {
    if ([string]::IsNullOrWhiteSpace($wordToComplete) -or $wordToComplete.Length -lt 2) { return $null }
    if (-not (Test-Path -LiteralPath '/var/lib/dpkg/status')) { return $null }
    $q = "*${wordToComplete}*"
    $table = @{};
    $pkg = "";
    $installed = $false;
    Get-Content -LiteralPath '/var/lib/dpkg/status' | ForEach-Object {
        switch -Regex ($_) {
            '^Package: (.*)$' { $pkg = $Matches[1] }
            '^Status: ' { $installed = $_ -match '\binstalled\b' }
            '^Description-?[a-zA-Z_]*: (.*)$' {
                if ($installed -and -not [string]::IsNullOrEmpty($pkg) -and $pkg -like $q ) {
                    $table.Add($pkg, $Matches[1]);
                }
            }
        }
    }
    foreach ($k in $table.Keys) {
        "{0}`t{1}" -f $k, $table[$k]
    }
}

$packageCompleter = {
    if ([string]::IsNullOrWhiteSpace($wordToComplete) -or $wordToComplete.Length -lt 2) { return }
    $q = ".*${wordToComplete}.*"
    try {
        $table = @{}
        $pkg = ""
        apt-cache --no-generate show $q |
            ForEach-Object -Process {
                switch -Regex ($_) {
                    '^Package: (.*)$' {
                        $pkg = $Matches[1]
                    }
                    '^Description-?[a-zA-Z_]*: (.*)$' {
                        if (-not [string]::IsNullOrEmpty($pkg) -and -not $table.ContainsKey($pkg)) {
                            $table.Add($pkg, $Matches[1]);
                        }
                    }
                }
                # Limit to 200 items
                if ($table.Count -gt 200) { break; }
            }
        foreach ($k in $table.Keys) {
            "{0}`t{1}" -f $k, $table[$k]
        }
    } catch {}
}

Register-NativeCompleter -Name apt -Description $msg.apt -SubCommands @(
    # apt-get(8)
    New-CommandCompleter -Name update -Description $msg.update -NoFileCompletions
    New-CommandCompleter -Name upgrade -Description $msg.upgrade -Parameters @(
        New-ParamCompleter -LongName with-new-pkgs
        New-ParamCompleter -LongName ignore-hold -Description $msg.ignoreHold
    ) -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name full-upgrade -Description $msg.fullUpgrade -Parameters @(
        New-ParamCompleter -LongName allow-downgrades -Description $msg.allowDowngrades
        New-ParamCompleter -LongName allow-remove-essential -Description $msg.allowRemoveEssential
        New-ParamCompleter -LongName allow-change-held-packages -Description $msg.allowChangeHeldPackages
        New-ParamCompleter -LongName ignore-hold -Description $msg.ignoreHold
    ) -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name install -Description $msg.install -Parameters @(
        New-ParamCompleter -LongName no-install-recommends -Description $msg.noInstallRecommends
        New-ParamCompleter -LongName install-suggests -Description $msg.installSuggests
        New-ParamCompleter -ShortName d -LongName download-only -Description $msg.downloadOnly
        New-ParamCompleter -ShortName f -LongName fix-broken -Description $msg.fixBroken
        New-ParamCompleter -ShortName m -LongName ignore-missing, fix-missing -Description $msg.fixMissing
        New-ParamCompleter -LongName no-download -Description $msg.noDownload
        New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
        New-ParamCompleter -ShortName s -LongName simulate, just-print, dry-run, recon, no-act -Description $msg.simulate
        New-ParamCompleter -ShortName y -LongName yes, assume-yes -Description $msg.assumeYes
        New-ParamCompleter -ShortName t -LongName target-release -Description $msg.targetRelease -Type Required -VariableName 'RELEASE'
        New-ParamCompleter -LongName assume-no -Description $msg.assumeNo
        New-ParamCompleter -LongName reinstall -Description $msg.reinstall
        New-ParamCompleter -LongName no-upgrade -Description $msg.noUpgrade
        New-ParamCompleter -LongName only-upgrade -Description $msg.onlyUpgrade
        New-ParamCompleter -LongName allow-downgrades -Description $msg.allowDowngrades
        New-ParamCompleter -LongName allow-remove-essential -Description $msg.allowRemoveEssential
        New-ParamCompleter -LongName allow-change-held-packages -Description $msg.allowChangeHeldPackages
        New-ParamCompleter -LongName no-show-upgraded -Description $msg.noShowUpgraded
        New-ParamCompleter -LongName no-allow-insecure-repositories -Description $msg.noAllowInsecureRepositories
        New-ParamCompleter -LongName show-progress -Description $msg.showProgress
        New-ParamCompleter -LongName with-source -Description $msg.withSource -Type Required -VariableName 'FILE'
        New-ParamCompleter -LongName no-remove -Description $msg.noRemove
        New-ParamCompleter -LongName ignore-hold -Description $msg.ignoreHold
    ) -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name reinstall -Description $msg.reinstall -NoFileCompletions -ArgumentCompleter $installedPackageCompleter
    New-CommandCompleter -Name remove -Description $msg.remove -Parameters @(
        New-ParamCompleter -LongName purge -Description $msg.purge
    ) -NoFileCompletions -ArgumentCompleter $installedPackageCompleter
    New-CommandCompleter -Name purge -Description $msg.purge -Parameters @(
        New-ParamCompleter -LongName auto-remove -Description $msg._autoRemove
    ) -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name autoremove -Description $msg.autoremove -NoFileCompletions -ArgumentCompleter $installedPackageCompleter
    New-CommandCompleter -Name satisfy -Description $msg.satisfy -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name source -Description $msg.source -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name build-dep -Description $msg.buildDep -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name download -Description $msg.download -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name changelog -Description $msg.changelog -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name clean -Description $msg.clean -NoFileCompletions
    New-CommandCompleter -Name distclean -Description $msg.distclean -NoFileCompletions
    New-CommandCompleter -Name autoclean -Description $msg.autoclean -NoFileCompletions

    # apt-cache(8)
    New-CommandCompleter -Name search -Description $msg.search -NoFileCompletions
    New-CommandCompleter -Name show -Description $msg.show -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name showsrc -Description $msg.showsrc -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name depends -Description $msg.depends -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name rdepends -Description $msg.rdepends -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name policy -Description $msg.policy -NoFileCompletions -ArgumentCompleter $packageCompleter

    New-CommandCompleter -Name list -Description $msg.list -Parameters @(
        New-ParamCompleter -ShortName a -LongName all-versions -Description $msg.allVersions
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.verbose
        New-ParamCompleter -LongName installed -Description $msg.installed
        New-ParamCompleter -LongName manual-installed -Description $msg.manualInstalled
        New-ParamCompleter -LongName upgradable -Description $msg.upgradable
    ) -NoFileCompletions
    New-CommandCompleter -Name edit-sources -Description $msg.editSources -NoFileCompletions
) -Parameters @(
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName v -LongName version -Description $msg.version
    New-ParamCompleter -ShortName c -LongName config-file -Description $msg.configFile -Type File -VariableName 'FILE'
    New-ParamCompleter -ShortName o -LongName option -Description $msg.option -Type Required
) -NoFileCompletions
