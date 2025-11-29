<#
 # apt-get completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    apt_get                     = APT package handling utility - command-line interface
    update                      = Retrieve new lists of packages
    upgrade                     = Perform an upgrade
    distUpgrade                 = Distribution upgrade
    dselectUpgrade              = Follow dselect selections
    install                     = Install new packages
    reinstall                   = Reinstall packages
    remove                      = Remove packages
    purge                       = Remove packages and config files
    source                      = Download source archives
    buildDep                    = Configure build-dependencies for source packages
    satisfy                     = Satisfy dependency strings
    check                       = Verify that there are no broken dependencies
    download                    = Download the binary package into the current directory
    clean                       = Erase downloaded archive files
    autoclean                   = Erase old downloaded archive files
    autoremove                  = Remove automatically all unused packages
    changelog                   = Download and display the changelog for the given package
    indextargets                = List index targets
    help                        = Display help
    version                     = Show version
    configFile                  = Specify a configuration file
    option                      = Set a configuration option
    assumeYes                   = Automatic yes to prompts
    assumeNo                    = Automatic no to prompts
    noInstallRecommends         = Do not install recommended packages
    installSuggests             = Install suggested packages
    downloadOnly                = Download only - do NOT install or unpack archives
    fixBroken                   = Fix broken dependencies
    fixMissing                  = Fix missing packages
    noDownload                  = Disable downloading of packages
    quiet                       = Produce output suitable for logging
    simulate                    = Perform a simulation of events
    showUpgraded                = Show upgraded packages
    verboseVersions             = Show full versions for upgraded packages
    hostArchitecture            = Set host architecture
    buildProfiles               = Specify build profiles
    compile                     = Compile source packages after downloading them
    ignoreHold                  = Ignore package holds
    withNewPkgs                 = Upgrade with new packages
    noUpgrade                   = Do not upgrade packages
    onlyUpgrade                 = Do not install new packages
    allowDowngrades             = Allow downgrades
    allowRemoveEssential        = Allow removing essential packages
    allowChangeHeldPackages     = Allow changing held packages
    forceYes                    = Force yes (deprecated)
    printUris                   = Print the URIs of files to install
    purgeRemove                 = Use purge instead of remove
    reinstallOption             = Reinstall packages that are already installed
    listCleanup                 = Erase obsolete files from /var/lib/apt/lists
    targetRelease               = Control default input for policy engine
    trivialOnly                 = Only perform operations that are trivial
    noRemove                    = Abort if any packages are to be removed
    opt_autoRemove              = Remove automatically unused packages
    onlySource                  = Only download source packages
    diffOnly                    = Download only the diff file
    dscOnly                     = Download only the dsc file
    tarOnly                     = Download only the tar file
    archOnly                    = Only process architecture-dependent build-dependencies
    indepOnly                   = Only process architecture-independent build-dependencies
    allowUnauthenticated        = Allow unauthenticated packages
    noAllowInsecureRepositories = Disallow insecure repositories
    allowReleaseinfoChange      = Allow repository changes
    showProgress                = Show progress information
    withSource                  = Include source URIs in print-uris output
    errorOn                     = Set error conditions
    markAuto                    = Mark automatically installed packages
    markManual                  = Mark manually installed packages
    solver                      = Use given dependency solver
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

Register-NativeCompleter -Name apt-get -Description $msg.apt_get -SubCommands @(
    New-CommandCompleter -Name update -Description $msg.update -NoFileCompletions
    New-CommandCompleter -Name upgrade -Description $msg.upgrade -NoFileCompletions
    New-CommandCompleter -Name dist-upgrade -Description $msg.distUpgrade -NoFileCompletions
    New-CommandCompleter -Name dselect-upgrade -Description $msg.dselectUpgrade
    New-CommandCompleter -Name install -Description $msg.install -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name reinstall -Description $msg.reinstall -ArgumentCompleter $installedPackageCompleter
    New-CommandCompleter -Name remove -Description $msg.remove -ArgumentCompleter $installedPackageCompleter
    New-CommandCompleter -Name purge -Description $msg.purge -ArgumentCompleter $installedPackageCompleter
    New-CommandCompleter -Name source -Description $msg.source -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name build-dep -Description $msg.buildDep -ArgumentCompleter $installedPackageCompleter
    New-CommandCompleter -Name satisfy -Description $msg.satisfy
    New-CommandCompleter -Name check -Description $msg.check
    New-CommandCompleter -Name download -Description $msg.download -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name clean -Description $msg.clean
    New-CommandCompleter -Name autoclean -Description $msg.autoclean
    New-CommandCompleter -Name autoremove -Description $msg.autoremove
    New-CommandCompleter -Name changelog -Description $msg.changelog -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name indextargets -Description $msg.indextargets
) -Parameters @(
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName v -LongName version -Description $msg.version
    New-ParamCompleter -ShortName c -LongName config-file -Description $msg.configFile -Type File
    New-ParamCompleter -ShortName o -LongName option -Description $msg.option -Type Required
    New-ParamCompleter -ShortName y -LongName yes, assume-yes -Description $msg.assumeYes
    New-ParamCompleter -LongName assume-no -Description $msg.assumeNo
    New-ParamCompleter -LongName no-install-recommends -Description $msg.noInstallRecommends
    New-ParamCompleter -LongName install-suggests -Description $msg.installSuggests
    New-ParamCompleter -ShortName d -LongName download-only -Description $msg.downloadOnly
    New-ParamCompleter -ShortName f -LongName fix-broken -Description $msg.fixBroken
    New-ParamCompleter -ShortName m -LongName fix-missing, ignore-missing -Description $msg.fixMissing
    New-ParamCompleter -LongName no-download -Description $msg.noDownload
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -ShortName s -LongName simulate,just-print,dry-run,recon,no-act -Description $msg.simulate
    New-ParamCompleter -LongName show-upgraded -Description $msg.showUpgraded
    New-ParamCompleter -ShortName V -LongName verbose-versions -Description $msg.verboseVersions
    New-ParamCompleter -ShortName a -LongName host-architecture -Description $msg.hostArchitecture -Type Required -VariableName 'architecture'
    New-ParamCompleter -ShortName P -LongName build-profiles -Description $msg.buildProfiles -Type Required -VariableName 'profiles'
    New-ParamCompleter -ShortName b -LongName compile,build -Description $msg.compile
    New-ParamCompleter -LongName ignore-hold -Description $msg.ignoreHold
    New-ParamCompleter -LongName with-new-pkgs -Description $msg.withNewPkgs
    New-ParamCompleter -LongName no-upgrade -Description $msg.noUpgrade
    New-ParamCompleter -LongName only-upgrade -Description $msg.onlyUpgrade
    New-ParamCompleter -LongName allow-downgrades -Description $msg.allowDowngrades
    New-ParamCompleter -LongName allow-remove-essential -Description $msg.allowRemoveEssential
    New-ParamCompleter -LongName allow-change-held-packages -Description $msg.allowChangeHeldPackages
    New-ParamCompleter -LongName force-yes -Description $msg.forceYes
    New-ParamCompleter -LongName print-uris -Description $msg.printUris
    New-ParamCompleter -LongName purge -Description $msg.purgeRemove
    New-ParamCompleter -LongName reinstall -Description $msg.reinstallOption
    New-ParamCompleter -LongName list-cleanup -Description $msg.listCleanup
    New-ParamCompleter -ShortName t -LongName target-release,default-release -Description $msg.targetRelease -Type Required -VariableName 'target-release'
    New-ParamCompleter -LongName trivial-only -Description $msg.trivialOnly
    New-ParamCompleter -LongName no-remove -Description $msg.noRemove
    New-ParamCompleter -LongName auto-remove,autoremove -Description $msg.opt_autoRemove
    New-ParamCompleter -LongName only-source -Description $msg.onlySource
    New-ParamCompleter -LongName diff-only -Description $msg.diffOnly
    New-ParamCompleter -LongName dsc-only -Description $msg.dscOnly
    New-ParamCompleter -LongName tar-only -Description $msg.tarOnly
    New-ParamCompleter -LongName arch-only -Description $msg.archOnly
    New-ParamCompleter -LongName indep-only -Description $msg.indepOnly
    New-ParamCompleter -LongName allow-unauthenticated -Description $msg.allowUnauthenticated
    New-ParamCompleter -LongName no-allow-insecure-repositories -Description $msg.noAllowInsecureRepositories
    New-ParamCompleter -LongName allow-releaseinfo-change -Description $msg.allowReleaseinfoChange
    New-ParamCompleter -LongName show-progress -Description $msg.showProgress
    New-ParamCompleter -LongName with-source -Description $msg.withSource -Type File -VariableName 'filename'
    New-ParamCompleter -ShortName e -LongName error-on -Description $msg.errorOn -Type FlagOrValue -VariableName 'any'
    New-ParamCompleter -LongName mark-auto -Description $msg.markAuto
    New-ParamCompleter -LongName mark-manual -Description $msg.markManual
    New-ParamCompleter -LongName solver -Description $msg.solver -Type Required -VariableName 'name'
) -NoFileCompletions
