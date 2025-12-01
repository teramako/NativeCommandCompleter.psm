<#
 # winget completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    winget                      = Windows Package Manager CLI
    install                     = Installs the given package
    show                        = Shows information about a package
    source                      = Manage sources of packages
    search                      = Find and show basic info of packages
    list                        = Display installed packages
    upgrade                     = Shows and performs available upgrades
    uninstall                   = Uninstalls the given package
    hash                        = Helper to hash installer files
    validate                    = Validates a manifest file
    settings                    = Open settings or set administrator settings
    features                    = Shows the status of experimental features
    export                      = Exports a list of the installed packages
    import                      = Installs all the packages in a file
    pin                         = Manage package pins
    configure                   = Configures the system into a desired state
    download                    = Downloads the given package
    help                        = Display help

    _info                       = Show general info
    _exact                      = Find package using exact match
    _query                      = The query used to search for a package
    _manifest                   = The path to the manifest of the package
    _id                         = Filter results by id
    _name                       = Filter results by name
    _moniker                    = Filter results by moniker
    _version                    = Use the specified version
    _arch                       = Select the architecture
    _log                        = Log location
    _verbose_logs               = Used to override the logging setting and create a verbose log
    _source                     = Find package using the specified source
    _locale                     = Locale to use (BCP47 format)
    _wait                       = Prompts the user to press any key before exiting
    _disable_interactivity      = Disable interactive prompts
    _scope                      = Use the specified scope
    _scope_user                 = for current user
    _scope_machine              = for all users
    _header                     = Windows-Package-Manager REST source HTTP header
    _proxy                      = Set a proxy
    _no_proxy                   = Disable the use of proxy for this execution.
    _accept_package_agreements  = Accept all license agreements for packages
    _accept_source_agreements   = Accept all source agreements during source operations
    _interactive                = Request interactive
    _silent                     = Request silent
    _installer_type             = Installer type to use
    _override                   = Override arguments to be passed on to the installer
    _location                   = Location to install to
    _ignore_security_hash       = Ignore the installer hash check failure. Not recommended.
    _allow_reboot               = Allows a reboot if applicable.
    _skip_dependencies          = Skips processing package dependencies and Windows features.
    _ignore_local_archive_malware_scan = Ignore the malware scan performed as part of installing an archive-type package from a local manifest
    _authentication_mode        = Specify authentication window preference.
    _authentication_account     = Specify the account to be used for authentication.
    _force                      = Direct run the command and continue with non security related issues.
    _open_logs                  = Open the default logs location.
    _no_warn                    = Suppresses warning outputs.
    _uninstall_previous         = Uninstall the previous version of the package during upgrade
    _help                       = Show help about the selected command

    install_custom              = Arguments to be passed on to the installer in addition to the defaults
    install_dependency_source   = Find dependencies using the specified source
    install_no_upgrade          = Skips upgrade if an installed version already exists

    show_versions               = Show available versions of the package

    source_add                  = Add a new source
    source_list                 = List current sources
    source_update               = Update current sources
    source_remove               = Remove current sources
    source_reset                = Reset sources
    source_reset_force          = Forces the reset of the sources
    source_export               = Export current sources
    source_name                 = Name of the source
    source_arg                  = Argument to be given to the source
    source_type                 = Type of the source
    source_trust_level          = The trust level of the source
    source_explicit             = Treat arg as a single url

    search_tag                  = Filter results by tag
    search_command              = Filter results by command
    search_count                = Show specified number of results

    list_tag                    = Filter results by tag
    list_command                = Filter results by command
    list_count                  = Show specified number of results
    list_upgrade_available      = Filters the list of installed packages to only those with available upgrades

    upgrade_all                 = Upgrade all installed packages to the latest version if available.
    upgrade_include_unknown     = Upgrade packages even if their current version cannot be determined
    upgrade_include_pinned      = Upgrade packages even if they have a non-blocking pin

    uninstall_product_code      = Filter results by product code
    uninstall_purge             = Deletes all files and directories related to the package
    uninstall_preserve          = Retains a portable package at its current location

    hash_file                   = File to be hashed
    hash_msix                   = Generate hashes for all files inside MSIX/MSIXBUNDLE

    export_output               = File where the result is exported to
    export_include_versions     = Include the version of the package

    import_import_file          = File describing the packages to install
    import_ignore_unavailable   = Continue installing other packages even if one fails
    import_ignore_versions      = Ignores versions specified in the import file
    import_no_upgrade           = Skips upgrade if an installed version already exists

    pin_list                    = List all pinned packages
    pin_add                     = Add a pin to a package
    pin_remove                  = Remove a pin from a package
    pin_reset                   = Reset pins for a package or all packages
    pin_version                 = Pin the package to the specified version
    pin_blocking                = Block upgrades for the package
    pin_installed               = Pin the currently installed version

    configure_file              = Path to a configuration file
    configure_accept_configuration_agreements = Accept all configuration file agreements

    download_download_directory = Directory where the installer will be downloaded
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$exactParam = New-ParamCompleter -OldStyleName e -LongName exact -Description $msg._exact
$queryParam = New-ParamCompleter -OldStyleName q -LongName query -Description $msg._query -Type Required -VariableName 'query'
$manifestParam = New-ParamCompleter -OldStyleName m -LongName manifest -Description $msg._manifest -Type File -VariableName 'manifest'
$idParam = New-ParamCompleter -LongName id -Description $msg._id -Type Required -VariableName 'id'
$nameParam = New-ParamCompleter -LongName name -Description $msg._name -Type Required -VariableName 'name'
$monikerParam = New-ParamCompleter -LongName moniker -Description $msg._moniker -Type Required -VariableName 'moniker'
$versionParam = New-ParamCompleter -OldStyleName v -LongName version -Description $msg._version -Type Required -VariableName 'version'
$archParam = New-ParamCompleter -OldStyleName a -LongName architecture -Description $msg._arch -Arguments "x86","x64","arm","arm64" -VariableName 'architecture'
$logParam = New-ParamCompleter -OldStyleName o -LongName log -Description $msg._log -Type File -VariableName 'path'
$verboseLogsParam = New-ParamCompleter -LongName verbose,verbose-logs -Description $msg._verbose_logs
$sourceParam = New-ParamCompleter -OldStyleName s -LongName source -Description $msg._source -Type Required -VariableName 'source'
$localeParam = New-ParamCompleter -LongName locale -Description $msg._locale -Type Required -VariableName 'locale'
$customParam = New-ParamCompleter -LongName custom -Description $msg.install_custom -Type Required -VariableName 'arguments'
$waitParam = New-ParamCompleter -LongName wait -Description $msg.install_wait
$disableInteractivityParam = New-ParamCompleter -LongName disable-interactivity -Description $msg._disable_interactivity
$scopeParam = New-ParamCompleter -LongName scope -Description $msg._scope -Arguments @(
    "user`t{0}" -f $msg._scope_user
    "machine`t{0}" -f $msg._scope_machine
) -VariableName 'scope'
$headerParam = New-ParamCompleter -LongName header -Description $msg._header -Type Required -VariableName 'header'
$proxyParam = New-ParamCompleter -LongName proxy -Description $msg._proxy -Type Required -VariableName 'url'
$noProxyParam = New-ParamCompleter -LongName no-proxy -Description $msg._no_proxy
$acceptPackageAgreementsParam = New-ParamCompleter -LongName accept-package-agreements -Description $msg._accept_package_agreements
$acceptSourceAgreementsParam = New-ParamCompleter -LongName accept-source-agreements -Description $msg._accept_source_agreements
$interactiveParam = New-ParamCompleter -OldStyleName i -LongName interactive -Description $msg._interactive
$silentParam = New-ParamCompleter -OldStyleName h -LongName silent -Description $msg._silent
$installerTypeParam = New-ParamCompleter -LongName installer-type -Description $msg._installer_type -Arguments @(
    "msix","msi","appx","exe","zip","inno","nullsoft","wix","burn","pwa"
) -VariableName 'type'
$overrideParam = New-ParamCompleter -LongName override -Description $msg._override -Type Required -VariableName 'arguments'
$locationParam = New-ParamCompleter -OldStyleName l -LongName location -Description $msg._location -Type Directory -VariableName 'path'
$ignoreSecurityHashParam = New-ParamCompleter -LongName ignore-security-hash -Description $msg._ignore_security_hash
$forceParam = New-ParamCompleter -LongName force -Description $msg._force
$allowRebootParam = New-ParamCompleter -LongName allow-reboot -Description $msg._allow_reboot
$skipDependenciesParam = New-ParamCompleter -LongName skip-dependencies -Description $msg._skip_dependencies
$ignoreLocalArchiveMalwareScanParam = New-ParamCompleter -LongName ignore-local-archive-malware-scan -Description $msg._ignore_local_archive_malware_scan
$authenticationModeParam = New-ParamCompleter -LongName authentication-mode -Description $msg._authentication_mode -Arguments @(
    "default","silent","interactive"
) -VariableName 'mode'
$authenticationAccountParam = New-ParamCompleter -LongName authentication-account -Description $msg._authentication_account -Type Required -VariableName 'account'
$openLogsParam = New-ParamCompleter -LongName logs, open-logs -Description $msg._open_logs
$nowwarnParam = New-ParamCompleter -LongName nowarn, ignore-warnings -Description $msg._no_warn
$uninstallPreviousParam = New-ParamCompleter -LongName uninstall-previous -Description $msg._uninstall_previous
$helpParam = New-ParamCompleter -OldStyleName '?' -LongName help -Description $msg._help

$sourceNameParam = New-ParamCompleter -OldStyleName n -LongName name -Description $msg.source_name -Type Required -VariableName 'name'

Register-NativeCompleter -Name winget -Description $msg.winget -SubCommands @(
    # install
    New-CommandCompleter -Name install -Aliases add -Description $msg.install -Parameters @(
        $queryParam
        $manifestParam
        $idParam
        $nameParam
        $monikerParam
        $versionParam
        $sourceParam
        $scopeParam
        $archParam
        $installerTypeParam
        $exactParam
        $interactiveParam
        $silentParam
        $localeParam
        $logParam
        $customParam
        $overrideParam
        $locationParam
        $ignoreSecurityHashParam
        $allowRebootParam
        $skipDependenciesParam
        $ignoreLocalArchiveMalwareScanParam
        New-ParamCompleter -LongName dependency-source -Description $msg.install_dependency_source -Type Required -VariableName 'source'
        $acceptPackageAgreementsParam
        New-ParamCompleter -LongName no-upgrade -Description $msg.install_no_upgrade
        $headerParam
        $authenticationModeParam
        $authenticationAccountParam
        $acceptSourceAgreementsParam
        $uninstallPreviousParam
        $forceParam
        $helpParam
        $waitParam
        $verboseLogsParam
        $nowwarnParam
        $disableInteractivityParam
        $proxyParam
        $noProxyParam
    ) -NoFileCompletions

    # show
    New-CommandCompleter -Name show -Aliases view -Description $msg.show -Parameters @(
        $queryParam
        $manifestParam
        $idParam
        $nameParam
        $monikerParam
        $versionParam
        $sourceParam
        $exactParam
        $localeParam
        $acceptSourceAgreementsParam
        $headerParam
        New-ParamCompleter -LongName versions -Description $msg.show_versions
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    ) -NoFileCompletions

    # source
    New-CommandCompleter -Name source -Description $msg.source -SubCommands @(
        New-CommandCompleter -Name add -Description $msg.source_add -Parameters @(
            $sourceNameParam
            New-ParamCompleter -OldStyleName a -LongName arg -Description $msg.source_arg -Type Required -VariableName 'arg'
            New-ParamCompleter -OldStyleName t -LongName type -Description $msg.source_type -Type Required -VariableName 'type'
            New-ParamCompleter -LongName trust-level -Description $msg.source_trust_level -Arguments "none","trusted" -VariableName 'level'
            New-ParamCompleter -LongName explicit -Description $msg.source_explicit
            $acceptSourceAgreementsParam
            $headerParam
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
        New-CommandCompleter -Name list -Description $msg.source_list -Parameters @(
            $sourceNameParam
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
        New-CommandCompleter -Name update -Description $msg.source_update -Parameters @(
            $sourceNameParam
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
        New-CommandCompleter -Name remove -Description $msg.source_remove -Parameters @(
            $sourceNameParam
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
        New-CommandCompleter -Name reset -Description $msg.source_reset -Parameters @(
            $sourceNameParam
            New-ParamCompleter -LongName force -Description $msg.source_reset_force
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
        New-CommandCompleter -Name export -Description $msg.source_export -Parameters @(
            $sourceNameParam
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
    ) -NoFileCompletions

    # search
    New-CommandCompleter -Name search -Description $msg.search -Parameters @(
        $queryParam
        $idParam
        $nameParam
        $monikerParam
        New-ParamCompleter -LongName tag -Description $msg.search_tag -Type Required -VariableName 'tag'
        New-ParamCompleter -LongName command,cmd -Description $msg.search_command -Type Required -VariableName 'command'
        $sourceParam
        New-ParamCompleter -OldStyleName n -LongName count -Description $msg.search_count -Type Required -VariableName 'count'
        $exactParam
        $acceptSourceAgreementsParam
        $headerParam
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    ) -NoFileCompletions

    # list
    New-CommandCompleter -Name list -Description $msg.list -Parameters @(
        $queryParam
        $idParam
        $nameParam
        $monikerParam
        New-ParamCompleter -LongName tag -Description $msg.list_tag -Type Required -VariableName 'tag'
        New-ParamCompleter -LongName command,cmd -Description $msg.list_command -Type Required -VariableName 'command'
        $sourceParam
        New-ParamCompleter -OldStyleName n -LongName count -Description $msg.list_count -Type Required -VariableName 'count'
        $exactParam
        $acceptSourceAgreementsParam
        $headerParam
        New-ParamCompleter -LongName upgrade-available,u -Description $msg.list_upgrade_available
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    ) -NoFileCompletions

    # upgrade
    New-CommandCompleter -Name upgrade -Description $msg.upgrade -Parameters @(
        $queryParam
        $manifestParam
        $idParam
        $nameParam
        $monikerParam
        $versionParam
        $sourceParam
        $exactParam
        $interactiveParam
        $silentParam
        $logParam
        $customParam
        $overrideParam
        $locationParam
        $scopeParam
        $archParam
        $installerTypeParam
        $localeParam
        $ignoreSecurityHashParam
        $allowRebootParam
        $skipDependenciesParam
        $ignoreLocalArchiveMalwareScanParam
        $acceptPackageAgreementsParam
        $acceptSourceAgreementsParam
        $headerParam
        $authenticationModeParam
        $authenticationAccountParam
        New-ParamCompleter -OldStyleName r -LongName recurse, all -Description $msg.upgrade_all
        New-ParamCompleter -OldStyleName u -LongName unknown, include-unknown -Description $msg.upgrade_include_unknown
        New-ParamCompleter -LongName pinned, include-pinned -Description $msg.upgrade_include_pinned
        $uninstallPreviousParam
        $forceParam
        $helpParam
        $waitParam
        $verboseLogsParam
        $nowwarnParam
        $disableInteractivityParam
        $proxyParam
        $noProxyParam
    ) -NoFileCompletions

    # uninstall
    New-CommandCompleter -Name uninstall -Description $msg.uninstall -Parameters @(
        $queryParam
        $manifestParam
        $idParam
        $nameParam
        $monikerParam
        New-ParamCompleter -LongName product-code -Description $msg.uninstall_product_code -Type Required -VariableName 'code'
        $versionParam
        $sourceParam
        $scopeParam
        $archParam
        $exactParam
        $interactiveParam
        $silentParam
        $logParam
        New-ParamCompleter -LongName purge -Description $msg.uninstall_purge
        New-ParamCompleter -LongName preserve -Description $msg.uninstall_preserve
        $acceptSourceAgreementsParam
        $headerParam
        $authenticationModeParam
        $authenticationAccountParam
        $forceParam
        $helpParam
        $waitParam
        $verboseLogsParam
        $nowwarnParam
        $disableInteractivityParam
        $proxyParam
        $noProxyParam
    ) -NoFileCompletions

    # hash
    New-CommandCompleter -Name hash -Description $msg.hash -Parameters @(
        New-ParamCompleter -OldStyleName f -LongName file -Description $msg.hash_file -Type File -VariableName 'file'
        New-ParamCompleter -LongName msix -Description $msg.hash_msix
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    )

    # validate
    New-CommandCompleter -Name validate -Description $msg.validate -Parameters @(
        $manifestParam
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    )

    # settings
    New-CommandCompleter -Name settings -Description $msg.settings -Parameters @(
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    ) -NoFileCompletions

    # features
    New-CommandCompleter -Name features -Description $msg.features -Parameters @(
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    ) -NoFileCompletions

    # export
    New-CommandCompleter -Name export -Description $msg.export -Parameters @(
        New-ParamCompleter -OldStyleName o -LongName output -Description $msg.export_output -Type File -VariableName 'file'
        $sourceParam
        New-ParamCompleter -LongName include-versions -Description $msg.export_include_versions
        $acceptSourceAgreementsParam
        $headerParam
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    )

    # import
    New-CommandCompleter -Name import -Description $msg.import -Parameters @(
        New-ParamCompleter -OldStyleName i -LongName import-file -Description $msg.import_import_file -Type File -VariableName 'file'
        New-ParamCompleter -LongName ignore-unavailable -Description $msg.import_ignore_unavailable
        New-ParamCompleter -LongName ignore-versions -Description $msg.import_ignore_versions
        $acceptPackageAgreementsParam
        $acceptSourceAgreementsParam
        $headerParam
        New-ParamCompleter -LongName no-upgrade -Description $msg.import_no_upgrade
        $proxyParam
        $noProxyParam
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    )

    # pin
    New-CommandCompleter -Name pin -Description $msg.pin -SubCommands @(
        New-CommandCompleter -Name list -Description $msg.pin_list -Parameters @(
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
        New-CommandCompleter -Name add -Description $msg.pin_add -Parameters @(
            $queryParam
            $idParam
            $nameParam
            $monikerParam
            $sourceParam
            $exactParam
            New-ParamCompleter -OldStyleName v -LongName version -Description $msg.pin_version -Type Required -VariableName 'version'
            New-ParamCompleter -OldStyleName b -LongName blocking -Description $msg.pin_blocking
            New-ParamCompleter -LongName installed -Description $msg.pin_installed
            $forceParam
            $acceptSourceAgreementsParam
            $headerParam
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
        New-CommandCompleter -Name remove -Description $msg.pin_remove -Parameters @(
            $queryParam
            $idParam
            $nameParam
            $monikerParam
            $sourceParam
            $exactParam
            $acceptSourceAgreementsParam
            $headerParam
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
        New-CommandCompleter -Name reset -Description $msg.pin_reset -Parameters @(
            $queryParam
            $idParam
            $nameParam
            $monikerParam
            $sourceParam
            $exactParam
            $forceParam
            $acceptSourceAgreementsParam
            $headerParam
            $disableInteractivityParam
            $waitParam
            $verboseLogsParam
            $helpParam
        ) -NoFileCompletions
    ) -NoFileCompletions

    # configure
    New-CommandCompleter -Name configure -Description $msg.configure -Parameters @(
        New-ParamCompleter -OldStyleName f -LongName file -Description $msg.configure_file -Type File -VariableName 'file'
        New-ParamCompleter -LongName accept-configuration-agreements -Description $msg.configure_accept_configuration_agreements
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    )

    # download
    New-CommandCompleter -Name download -Description $msg.download -Parameters @(
        $queryParam
        New-ParamCompleter -OldStyleName d -LongName download-directory -Description $msg.download_download_directory -Type Directory -VariableName 'path'
        $manifestParam
        $idParam
        $nameParam
        $monikerParam
        $versionParam
        $sourceParam
        $scopeParam
        $archParam
        $installerTypeParam
        $exactParam
        $localeParam
        $ignoreSecurityHashParam
        $skipDependenciesParam
        $acceptPackageAgreementsParam
        $acceptSourceAgreementsParam
        $headerParam
        $authenticationModeParam
        $authenticationAccountParam
        $proxyParam
        $noProxyParam
        $disableInteractivityParam
        $waitParam
        $verboseLogsParam
        $helpParam
    )

    # help
    New-CommandCompleter -Name help -Description $msg.help -NoFileCompletions -ArgumentCompleter {
        "install","show","source","search","list","upgrade","uninstall","hash","validate","settings","features","export","import","pin","configure","download" |
            Where-Object { $_ -like "$wordToComplete*" }
    }

) -Parameters @(
    New-ParamCompleter -OldStyleName v -LongName version -Description $msg.version
    New-ParamCompleter -LongName info -Description $msg._info
    $helpParam
    $waitParam
    $openLogsParam
    $verboseLogsParam
    $nowwarnParam
    $disableInteractivityParam
    $proxyParam
    $noProxyParam
) -NoFileCompletions
