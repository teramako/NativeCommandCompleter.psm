<#
 # dotnet completion
 #>
Import-Module NativeCommandCompleter.psm

$helpParam = New-ParamCompleter -OldStyleName 'h','?' -LongName help -Description 'Show command line help.'
$interactiveParam = New-ParamCompleter -LongName interactive -Description 'Allows the command to stop and wait for user input or action'
$nologoParam = New-ParamCompleter -LongName nologo -Description 'Do not display the startup banner or the copyright message.'
$verbosityParam = New-ParamCompleter -OldStyleName v -LongName verbosity -Description 'Set the MSBuild verbosity level.' -Arguments @(
    "q`tQuiet", "quiet`tQuiet",
    "m`tMinimal", "minimal`tMinimal",
    "n`tNormal", "normal`tNormal",
    "d`tDetailed", "detailed`tDetailed",
    "diag`tDiagnostic", "diagnostic`tDiagnostic"
)
$noBuildParam = New-ParamCompleter -LongName no-build -Description 'Do not build the project'
$outputDirParam = New-ParamCompleter -OldStyleName o -LongName output -Description 'The output directory' -Type File

$buildArtifactsPathParam = New-ParamCompleter -LongName artifacts-path -Description 'The artifacts path.' -Type File
$targetFrameworkParam = New-ParamCompleter -OldStyleName f -LongName framework -Description 'The target framework' -Type Required
$targetRuntimeParam = New-ParamCompleter -OldStyleName r -LongName runtime -Description 'The target runtime' -Type Required
$targetArchParam = New-ParamCompleter -OldStyleName a -LongName arch -Description "The target architecture." -Type Required
$targetOsParam = New-ParamCompleter -LongName os -Description "The target operating system." -Type Required
$norestoreParam = New-ParamCompleter -LongName no-restore -Description 'Do not restore'
$buildConfigurationParam = New-ParamCompleter -OldStyleName c -LongName configuration -Description "The configuration to use" -Arguments 'Debug','Release'
$buildVersionSuffixParam = New-ParamCompleter -LongName version-suffix -Description 'Set the value of the $(VersionSuffix) property to use when building the project.' -Type Required
$disableBuildServersParam = New-ParamCompleter -LongName disable-build-servers -Description "Force the command to ignore any persistent build servers."
$useCurrentRuntimeParam = New-ParamCompleter -LongName ucr, use-current-runtime -Description 'Use current runtime as the target runtime.'

$newAddSourceParam = New-ParamCompleter -LongName add-source, nuget-source -Description "Specifies a NuGet source to use." -Type Required
$newAuthorFilterParam = New-ParamCompleter -LongName author -Description "Filters the templates based on the template author." -Type Required
$newLanguageFilterParam = New-ParamCompleter -OldStyleName lang -LongName language -Description "Filters templates based on language." -Type Required
$newTypeFilterParam = New-ParamCompleter -LongName type -Description "Filters templates based on available types." -Arguments 'project', 'item'
$newTagFilterParam = New-ParamCompleter -LongName tag -Description "Filters the templates based on the tag." -Type Required
$newOutputColumnsAllParam = New-ParamCompleter -LongName columns-all -Description "Displays all columns in the output."
$newOutputColumnsParam = New-ParamCompleter -LongName columns -Description "Specifies the columns to display in the output." -Arguments 'author','language','tags','type'
$newDiagnosticsParam = New-ParamCompleter -OldStyleName d -LongName diagnostics -Description 'Enables diagnostic output.'

$publishSelfContainedParam = New-ParamCompleter -LongName sc, self-contained -Description "Publish the .NET runtime with your application so the runtime doesn't need to be installed on the target machine."
$publishNoSelfContainedParam = New-ParamCompleter -LongName no-self-contained -Description "Publish your application as a framework dependent application."

$noCacheParam = New-ParamCompleter -LongName no-cache -Description 'Do not cache packages and http requests.'
$nugetCertificatePasswordParam = New-ParamCompleter -LongName password -Description 'Password for the certificate, if needed.' -Type Required
$nugetConfigfileParam = New-ParamCompleter -LongName configfile -Description 'The NuGet configuration file.' -Type File
$nugetStorePassInClearTextParam = New-ParamCompleter -LongName store-password-in-clear-text -Description 'Enables storing password for the certificate by disabling password encryption.'
$nugetPackageSourceParam = New-ParamCompleter -OldStyleName s -LongName package-source -Description 'Package source name.' -Type Required
$nugetCertificatePathParam = New-ParamCompleter -LongName path -Description 'Path to certificate file.' -Type File
$nugetStoreLocationParam = New-ParamCompleter -LongName store-location -Description 'Certificate store location.' -Type Required
$nugetStoreNameParam = New-ParamCompleter -LongName store-name -Description 'Certificate store name.' -Type Required
$nugetFindByParam = New-ParamCompleter -LongName find-by -Description 'Search method to find certificate in certificate store.' -Type Required
$nugetFindValueParam = New-ParamCompleter -LongName find-value -Description 'Search the certificate store for the supplied value.' -Type Required
$nugetForceParam = New-ParamCompleter -OldStyleName f -LongName force -Description 'Skip certificate validation.'
$nugetUsernameParam = New-ParamCompleter -OldStyleName u -LongName username -Description 'Username to be used when connecting to an authenticated source.' -Type Required
$nugetPasswordParam = New-ParamCompleter -OldStyleName p -LongName password -Description 'Password to be used when connecting to an authenticated source.' -Type Required
$nugetValidAuthTypesParam = New-ParamCompleter -LongName valid-authentication-types -Description 'Comma-separated list of valid authentication types for this source.' -Type Required
$nugetProtocolVersionParam = New-ParamCompleter -LongName protocol-version -Description 'The NuGet server protocol version to be used.' -Arguments '2', '3'
$nugetForceEnglishOutputParam = New-ParamCompleter -LongName force-english-output -Description 'Forces the application to run using an invariant, English-based culture.'
$nugetSourceParam = New-ParamCompleter -OldStyleName s -LongName source -Description 'Package source (URL, UNC/folder path or package source name) to use.' -Type Required
$nugetApiKeyParam = New-ParamCompleter -OldStyleName k -LongName api-key -Description 'The API key for the server.' -Type Required

$disableParallelParam = New-ParamCompleter -LongName disable-parallel -Description 'Prevent restoring multiple projects in parallel.'

$toolPathParam = New-ParamCompleter -LongName tool-path -Description 'The tool directory' -Type File
$toolManifestParam = New-ParamCompleter -LongName tool-manifest -Description 'Path to the manifest file.' -Type File
$toolAddSourceParam = New-ParamCompleter -LongName add-source -Description 'Add an additional NuGet package source to use during installation.' -Type Required
$toolFrameworkParam = New-ParamCompleter -LongName framework -Description 'The target framework to install the tool for.' -Type Required
$toolVersionParam = New-ParamCompleter -LongName version -Description 'The version of the tool package to install.' -Type Required
$toolPrereleaseParam = New-ParamCompleter -LongName prerelease -Description 'Include pre-release packages.'
$ignoreFailedSourcesParam = New-ParamCompleter -LongName ignore-failed-sources -Description 'Treat package source failures as warnings.'

$nugetSourceParam = New-ParamCompleter -OldStyleName s -LongName source -Description 'The NuGet package source to use during the restore.' -Type Required
$workloadIncludePreviewsParam = New-ParamCompleter -LongName include-previews -Description 'Allow prerelease workload manifests.'
$workloadTempDirParam = New-ParamCompleter -LongName temp-dir -Description 'Specify a temporary directory' -Type File
$workloadSkipManifestUpdateParam = New-ParamCompleter -LongName skip-manifest-update -Description 'Skip updating the workload manifests.'

$dotnetCompleteScript = {
    param([string] $wordToComplete, [int] $position, [int] $argIndex, [MT.Comp.CompletionContext] $context)
    $cmdline = $context.CommandAst.ToString()
    dotnet complete "$cmdLine"
}
$projectCompleter = {
    param([string] $wordToComplete, [int] $position, [int] $argIndex, [MT.Comp.CompletionContext] $context)
    if ($argIndex -eq 0)
    {
        [MT.Comp.Helper]::CompleteFilename($context, $false, $false, { param([System.IO.FileInfo]$f)
            $f.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $f.Extension -match '\.\w+proj$'
        });
    }
}
$solutionCompleter = {
    param([string] $wordToComplete, [int] $position, [int] $argIndex, [MT.Comp.CompletionContext] $context)
    if ($argIndex -eq 0)
    {
        [MT.Comp.Helper]::CompleteFilename($context, $false, $false, { param([System.IO.FileInfo]$f)
            $f.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $f.Extension -match '\.slnx?$'
        });
    }
}
$solutionOrProjectCompleter = {
    param([string] $wordToComplete, [int] $position, [int] $argIndex, [MT.Comp.CompletionContext] $context)
    if ($argIndex -eq 0)
    {
        [MT.Comp.Helper]::CompleteFilename($context, $false, $false, { param([System.IO.FileInfo]$f)
            $f.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $f.Extension -match '\.(?:slnx?|\w+proj)$'
        });
    }
}

Register-NativeCompleter -Name dotnet -Parameters @(
    New-ParamCompleter -OldStyleName d -LongName diagnostics -Description 'Enable diagnostic output.'
    New-ParamCompleter -LongName info -Description 'Display .NET information.'
    New-ParamCompleter -LongName list-runtimes -Description 'Display the installed runtimes.'
    New-ParamCompleter -LongName list-sdks -Description 'Display the installed SDKs.'
    $helpParam
) -SubCommands @(
    New-CommandCompleter -Name add -Description 'Add a package or reference to a .NET project.' -Parameters @(
        $helpParam
    ) -SubCommands @(
        New-CommandCompleter -Name package -Description 'Add a NuGet package reference to the project.' -Parameters @(
            New-ParamCompleter -OldStyleName v -LongName version -Description 'The version of the package to add.' -Type Required
            $targetFrameworkParam
            New-ParamCompleter -OldStyleName n -LongName no-restore -Description 'Add the reference without performing restore preview and compatibility check.'
            $nugetSourceParam
            New-ParamCompleter -LongName package-directory -Description 'The directory to restore packages to.' -Type File
            $interactiveParam
            New-ParamCompleter -LongName prerelease -Description 'Allows prerelease packages to be installed.'
            $helpParam
        ) -ArgumentCompleter $dotnetCompleteScript
        New-CommandCompleter -Name reference -Description 'Add a project-to-project reference to the project.' -Parameters @(
            $targetFrameworkParam
            $interactiveParam
            $helpParam
        )
    ) -ArgumentCompleter $projectCompleter
    New-CommandCompleter -Name build -Description 'Build a .NET project.' -Parameters @(
        $useCurrentRuntimeParam
        $targetFrameworkParam
        $buildConfigurationParam
        $targetRuntimeParam
        $buildVersionSuffixParam
        $norestoreParam
        $interactiveParam
        $verbosityParam
        New-ParamCompleter -LongName debug
        $outputDirParam
        $buildArtifactsPathParam
        New-ParamCompleter -LongName no-incremental -Description 'Do not use incremental building.'
        New-ParamCompleter -LongName no-dependencies -Description 'Do not build project-to-project references and only build the specified project.'
        $nologoParam
        $publishSelfContainedParam
        $publishNoSelfContainedParam
        $targetArchParam
        $targetOsParam
        $disableBuildServersParam
        $helpParam
    ) -ArgumentCompleter $solutionOrProjectCompleter
    New-CommandCompleter -Name build-server -Description 'Interact with servers started by a build.' -Parameters @(
        $helpParam
    ) -SubCommands @(
        New-CommandCompleter -Name shutdown -Description 'Shuts down build servers that are started from dotnet. By default, all servers are shut down.' -Parameters @(
            New-ParamCompleter -LongName msbuild -Description 'Shut down the MSBuild build server.'
            New-ParamCompleter -LongName vbcscompiler -Description 'Shut down the VB/C# compiler build server.'
            New-ParamCompleter -LongName razor -Description 'Shut down the Razor build server.'
            $helpParam
        )
    )
    New-CommandCompleter -Name clean -Description 'Clean build outputs of a .NET project.' -Parameters @(
        $targetFrameworkParam
        $targetRuntimeParam
        $buildConfigurationParam
        $interactiveParam
        $verbosityParam
        New-ParamCompleter -OldStyleName o -LongName output -Description 'The directory containing the build artifacts to clean.' -Type File
        $buildArtifactsPathParam
        $nologoParam
        $disableBuildServersParam
        $helpParam
    ) -ArgumentCompleter $solutionOrProjectCompleter
    New-CommandCompleter -Name format -Description 'Apply style preferences to a project or solution.' -Parameters @(
        New-ParamCompleter -OldStyleName ?,h -LongName help -Description 'Show help and usage information'
        New-ParamCompleter -LongName version -Description 'Show version information'
        New-ParamCompleter -LongName diagnostics -Description 'A space separated list of diagnostic ids to use as a filter when fixing code style or 3rd party issues.' -Type Required
        New-ParamCompleter -LongName exclude-diagnostics -Description 'A space separated list of diagnostic ids to ignore when fixing code style or 3rd party issues.' -Type Required
        New-ParamCompleter -LongName severity -Description 'The severity of diagnostics to fix.' -Arguments 'info', 'warn', 'error'
        $norestoreParam
        New-ParamCompleter -LongName verify-no-changes -Description 'Verify no formatting changes would be performed.'
        New-ParamCompleter -LongName include -Description 'A list of relative file or folder paths to include in formatting.' -Type File
        New-ParamCompleter -LongName exclude -Description 'A list of relative file or folder paths to exclude from formatting.' -Type File
        New-ParamCompleter -LongName include-generated -Description 'Format files generated by the SDK.'
        $verbosityParam
        New-ParamCompleter -LongName binarylog -Description 'Log all project or solution load information to a binary log file.' -Type File
        New-ParamCompleter -LongName report -Description 'Accepts a file path which if provided will produce a json report in the given directory.' -Type File
    ) -SubCommands @(
        New-CommandCompleter -Name whitespace -Description 'Run whitespace formatting.' -Parameters @()
        New-CommandCompleter -Name style -Description 'Run code style analyzers and apply fixes.' -Parameters @()
        New-CommandCompleter -Name analyzers -Description 'Run 3rd party analyzers and apply fixes.' -Parameters @()
    ) -ArgumentCompleter $solutionOrProjectCompleter
    New-CommandCompleter -Name help -Description 'Show command line help.' -Parameters $helpParam
    New-CommandCompleter -Name list -Description 'List project references of a .NET project.' -Parameters @(
        $helpParam
    ) -SubCommands @(
        New-CommandCompleter -Name package -Description 'List all package references of the project or solution.' -Parameters @(
            $verbosityParam
            New-ParamCompleter -LongName outdated -Description "Lists packages that have newer versions. Cannot be combined with '--deprecated' or '--vulnerable' options."
            New-ParamCompleter -LongName deprecated -Description "Lists packages that have been deprecated. Cannot be combined with '--vulnerable' or '--outdated' options."
            New-ParamCompleter -LongName vulnerable -Description "Lists packages that have known vulnerabilities. Cannot be combined with '--deprecated' or '--outdated' options."
            New-ParamCompleter -LongName framework -Description "Chooses a framework to show its packages. Use the option multiple times for multiple frameworks." -Type Required
            New-ParamCompleter -LongName include-transitive -Description 'Lists transitive and top-level packages.'
            New-ParamCompleter -LongName include-prerelease -Description "Consider packages with prerelease versions when searching for newer packages. Requires the '--outdated' option"
            New-ParamCompleter -LongName highest-patch -Description "Consider only the packages with a matching major and minor version numbers when searching for newer packages. Requires the '--outdated' option."
            New-ParamCompleter -LongName highest-minor -Description "Consider only the packages with a matching major version number when searching for newer packages. Requires the '--outdated' option."
            New-ParamCompleter -LongName config, configfile -Description "The path to the NuGet config file to use. Requires the '--outdated', '--deprecated' or '--vulnerable' option." -Type File
            New-ParamCompleter -LongName source -Description "The NuGet sources to use when searching for newer packages. Requires the '--outdated', '--deprecated' or '--vulnerable' option." -Type Required
            $interactiveParam
            New-ParamCompleter -LongName format -Description "Specifies the output format type for the list packages command." -Arguments 'console','json'
            New-ParamCompleter -LongName output-version -Description "Specifies the version of machine-readable output. Requires the '--format json' option." -Type Required
            $helpParam
        )
        New-CommandCompleter -Name reference -Description 'List all project-to-project references of the project.' -Parameters $helpParam
    ) -ArgumentCompleter $solutionOrProjectCompleter
    New-CommandCompleter -Name msbuild -Description 'Run Microsoft Build Engine (MSBuild) commands.' -Parameters @(
        # TBD
        $helpParam
    ) -ArgumentCompleter $projectCompleter
    New-CommandCompleter -Name new -Description 'Create a new .NET project or file.' -Parameters @(
        $outputDirParam
        New-ParamCompleter -OldStyleName n -LongName name -Description 'The name for the output being created.' -Type Required
        New-ParamCompleter -LongName dry-run -Description 'Displays a summary of what would happen if the given command line were run if it would result in a template creation.'
        New-ParamCompleter -LongName force -Description 'Forces content to be generated even if it would change existing files.'
        New-ParamCompleter -LongName no-update-check -Description 'Disables checking for the template package updates when instantiating a template.'
        New-ParamCompleter -LongName project -Description 'The project that should be used for context evaluation.' -Type Required
        $verbosityParam
        $newDiagnosticsParam
        $helpParam
    ) -SubCommands @(
        New-CommandCompleter -Name create -Description "Instantiates a template with given short name. An alias of 'dotnet new <template name>'."
        New-CommandCompleter -Name install -Description "Installs a template package." -Parameters @(
            $interactiveParam
            $newAddSourceParam
            New-ParamCompleter -LongName force -Description 'Allows installing template packages from the specified sources even if they would override a template package from another source.'
            $verbosityParam
            $newDiagnosticsParam
            $helpParam
        ) -ArgumentCompleter $dotnetCompleteScript
        New-CommandCompleter -Name uninstall -Description "Uninstalls a template package." -Parameters @(
            $verbosityParam
            $newDiagnosticsParam
            $helpParam
        )
        New-CommandCompleter -Name update -Description "Checks the currently installed template packages for update, and install the updates." -Parameters @(
            $interactiveParam
            $newAddSourceParam
            New-ParamCompleter -LongName check-only, dry-run -Description "Only checks for updates and display the template packages to be updated without applying update."
            $verbosityParam
            $newDiagnosticsParam
            $helpParam
        )
        New-CommandCompleter -Name search -Description "Searches for the templates on NuGet.org." -Parameters @(
            $newAuthorFilterParam
            $newLanguageFilterParam
            $newTypeFilterParam
            $newTagFilterParam
            New-ParamCompleter -LongName package -Description "Filters the templates based on NuGet package ID." -Type Required
            $newOutputColumnsAllParam
            $newOutputColumnsParam
            $verbosityParam
            $newDiagnosticsParam
            $helpParam
        )
        New-CommandCompleter -Name list -Description "Lists templates containing the specified template name." -Parameters @(
            $newAuthorFilterParam
            $newLanguageFilterParam
            $newTagFilterParam
            New-ParamCompleter -LongName ignore-constraints -Description "Disables checking if the template meets the constraints to be run."
            $newOutputColumnsAllParam
            $newOutputColumnsParam
            $verbosityParam
            $newDiagnosticsParam
            $helpParam
        )
        New-CommandCompleter -Name details -Description "Provides the details for specified template package." -Parameters @(
            $interactiveParam
            $newAddSourceParam
            $verbosityParam
            $newDiagnosticsParam
            $helpParam
        )
    ) -ArgumentCompleter $dotnetCompleteScript
    New-CommandCompleter -Name nuget -Description 'Provides additional NuGet commands.' -Parameters @(
        $helpParam
        New-ParamCompleter -LongName version -Description 'Show version information'
    ) -SubCommands @(
        New-CommandCompleter -Name add -Description 'Add a NuGet source.' -Parameters $helpParam -SubCommands @(
            New-CommandCompleter -Name client-cert -Description 'Adds a client certificate configuration that matches the given package source name.' -Parameters @(
                $nugetPackageSourceParam
                $nugetCertificatePathParam
                $nugetCertificatePasswordParam
                $nugetStorePassInClearTextParam
                $nugetStoreLocationParam
                $nugetStoreNameParam
                $nugetFindByParam
                $nugetFindValueParam
                $nugetForceParam
                $nugetConfigfileParam
                $helpParam
            )
            New-CommandCompleter -Name source -Description 'Add a NuGet source.' -Parameters @(
                New-ParamCompleter -OldStyleName n -LongName name -Description 'Name of the source.' -Type Required
                $nugetUsernameParam
                $nugetPasswordParam
                $nugetStorePassInClearTextParam
                $nugetValidAuthTypesParam
                $nugetProtocolVersionParam
                $nugetConfigfileParam
                $helpParam
            )
        )
        New-CommandCompleter -Name delete -Description 'Deletes a package from the server.' -Parameters @(
            $helpParam
            $nugetForceEnglishOutputParam
            $nugetSourceParam
            New-ParamCompleter -LongName non-interactive -Description 'Do not prompt for user input or confirmations.'
            $nugetApiKeyParam
            New-ParamCompleter -LongName no-service-endpoint -Description 'Does not append "api/v2/package" to the source URL.'
            $interactiveParam
        )
        New-CommandCompleter -Name disable -Description 'Disable a NuGet source.' -Parameters $helpParam
        New-CommandCompleter -Name enable -Description 'Enable a NuGet source.' -Parameters $helpParam
        New-CommandCompleter -Name list -Description 'List configured NuGet sources.' -Parameters $helpParam -SubCommands @(
            New-CommandCompleter -Name client-cert -Description 'Lists all the client certificates in the configuration.' -Parameters $nugetConfigfileParam, $helpParam
            New-CommandCompleter -Name source -Description 'Lists all configured NuGet sources.' -Parameters @(
                New-ParamCompleter -LongName format -Description 'The format of the list command output' -Arguments "Short", "Detailed`t(Default)"
                $nugetConfigfileParam
                $helpParam
            )
        )
        New-CommandCompleter -Name locals -Description 'Clears or lists local NuGet resources.' -Parameters @(
            $helpParam
            $nugetForceEnglishOutputParam
            New-ParamCompleter -OldStyleName c -LongName clear -Description 'Clear the selected local resources or cache location(s).'
            New-ParamCompleter -OldStyleName l -LongName list -Description 'List the selected local resources or cache location(s).'
        ) -ArgumentCompleter {
            param([string] $wordToComplete, [int] $position, [int] $argIndex)
            switch -Wildcard ('all', 'http-cache', 'global-packages', 'temp')
            {
                "$wordToComplete*" { $_ }
                default { $null; break; }
            }
        }
        New-CommandCompleter -Name push -Description 'Pushes a package to the server and publishes it.' -Parameters @(
            $helpParam
            $nugetForceEnglishOutputParam
            $nugetSourceParam
            New-ParamCompleter -OldStyleName ss -LongName symbol-source -Description 'Symbol server URL to use.' -Type Required
            New-ParamCompleter -OldStyleName t -LongName timeout -Description 'Timeout for pushing to a server in seconds. Defaults to 300 seconds' -Type Required
            $nugetApiKeyParam
            New-ParamCompleter -OldStyleName sk -LongName symbol-api-key -Description 'The API key for the symbol server.' -Type Required
            New-ParamCompleter -OldStyleName d -LongName disable-buffering -Description 'Disable buffering when pushing to an HTTP(S) server to decrease memory usage.'
            New-ParamCompleter -OldStyleName n -LongName no-symbols -Description 'If a symbols package exists, it will not be pushed to a symbols server.'
            New-ParamCompleter -LongName no-service-endpoint -Description 'Does not append "api/v2/package" to the source URL.'
            $interactiveParam
            New-ParamCompleter -LongName skip-duplicate -Description 'If a package and version already exists, skip it and continue with the next package in the push, if any.'
        )
        New-CommandCompleter -Name remove -Description 'Remove a NuGet source.' -Parameters $helpParam -SubCommands @(
            New-CommandCompleter -Name client-cert -Description 'Removes the client certificate configuration that matches the given package source name.' -Parameters @(
                $nugetPackageSourceParam
                $nugetConfigfileParam
                $helpParam
            )
            New-CommandCompleter -Name source -Description 'Remove a NuGet source.' -Parameters $nugetConfigfileParam, $helpParam
        )
        New-CommandCompleter -Name sign -Description 'Signs NuGet package(s) at <package-paths> with the specified certificate.' -Parameters @(
            $outputDirParam
            New-ParamCompleter -LongName certificate-path -Description 'File path to the certificate to be used while signing the package.' -Type File
            New-ParamCompleter -LongName certificate-store-name -Description 'Name of the X.509 certificate store to use to search for the certificate.' -Arguments 'My'
            New-ParamCompleter -LongName certificate-store-location -Description 'Name of the X.509 certificate store use to search for the certificate.' -Arguments 'CurrentUser'
            New-ParamCompleter -LongName certificate-subject-name -Description 'Subject name of the certificate' -Type Required
            New-ParamCompleter -LongName certificate-fingerprint -Description 'SHA-1 fingerprint of the certificate' -Type Required
            New-ParamCompleter -LongName certificate-password -Description 'Password for the certificate, if needed.' -Type Required
            New-ParamCompleter -LongName hash-algorithm -Description 'Hash algorithm to be used to sign the package.' -Type Required
            New-ParamCompleter -LongName timestamper -Description 'URL to an RFC 3161 timestamping server.' -Type Required
            New-ParamCompleter -LongName timestamp-hash-algorithm -Description 'Hash algorithm to be used by the RFC 3161 timestamp server.' -Arguments 'SHA256','SHA384','SHA512'
            New-ParamCompleter -LongName overwrite -Description 'Switch to indicate if the current signature should be overwritten.'
            $verbosityParam
            $helpParam
        )
        New-CommandCompleter -Name trust -Description 'Manage the trusted signers.' -Parameters @(
            $nugetConfigfileParam
            $helpParam
            $verbosityParam
        ) -SubCommands @(
            New-CommandCompleter -Name author -Description 'Adds a trusted signer with the given name, based on the author signature of the package.' -Parameters @(
                New-ParamCompleter -LongName allow-untrusted-root
                $nugetConfigfileParam
                $verbosityParam
                $helpParam
            ) -ArgumentCompleter { return $null }
            New-CommandCompleter -Name certificate -Description 'Adds a trusted signer with the given name, based on the repository signature or countersignature of a signed package.' -Parameters @(
                New-ParamCompleter -LongName allow-untrusted-root
                New-ParamCompleter -LongName algorithm -Arguments 'SHA256','SHA384','SHA512'
                $nugetConfigfileParam
                $verbosityParam
                $helpParam
            )
            New-CommandCompleter -Name list -Description 'Lists all the trusted signers in the configuration.' -Parameters $nugetConfigfileParam, $verbosityParam, $helpParam
            New-CommandCompleter -Name remove -Description 'Removes any trusted signers that match the given name.' -Parameters $nugetConfigfileParam, $verbosityParam, $helpParam
            New-CommandCompleter -Name repository -Description 'Adds a trusted signer with the given name, based on the repository signature or countersignature of a signed package.' -Parameters @(
                New-ParamCompleter -LongName allow-untrusted-root
                New-ParamCompleter -LongName owners -Type Required
                $nugetConfigfileParam
                $verbosityParam
                $helpParam
            )
            New-CommandCompleter -Name source -Description 'Adds a trusted signer based on a given package source.' -Parameters @(
                New-ParamCompleter -LongName owners -Type Required
                New-ParamCompleter -LongName source-url -Type Required
                $nugetConfigfileParam
                $verbosityParam
                $helpParam
            )
            New-CommandCompleter -Name sync -Description 'Deletes the current list of certificates and replaces them with an up-to-date list from the repository.' `
                -Parameters $nugetConfigfileParam, $verbosityParam, $helpParam
        )
        New-CommandCompleter -Name update -Description 'Update a NuGet source.' -Parameters $helpParam -SubCommands @(
            New-CommandCompleter -Name client-cert -Description 'Updates the client certificate configuration.' -Parameters @(
                $nugetPackageSourceParam
                $nugetCertificatePathParam
                $nugetCertificatePasswordParam
                $nugetStoreLocationParam
                $nugetStoreNameParam
                $nugetFindByParam
                $nugetFindValueParam
                $nugetForceParam
                $nugetConfigfileParam
                $helpParam 
            )
            New-CommandCompleter -Name source -Description 'Update a NuGet source.' -Parameters @(
                New-ParamCompleter -OldStyleName s -LongName source -Description 'Path to the package source.' -Type File
                $nugetUsernameParam
                $nugetPasswordParam
                $nugetStorePassInClearTextParam
                $nugetValidAuthTypesParam
                $nugetProtocolVersionParam
                $nugetConfigfileParam
                $helpParam
            )
        )
        New-CommandCompleter -Name verify -Description 'Verifies a signed NuGet package.' -Parameters @(
            New-ParamCompleter -LongName all -Description 'Specifies that all verifications'
            New-ParamCompleter -LongName certificate-fingerprint -Description 'Verify that the signer certificate matches with one of the specified SHA256 fingerprints.'
            $nugetConfigfileParam
            $verbosityParam
            $helpParam
        )
    )
    New-CommandCompleter -Name pack -Description 'Create a NuGet package.' -Parameters @(
        $outputDirParam
        $buildArtifactsPathParam
        $noBuildParam
        New-ParamCompleter -LongName include-symbols -Description 'Include packages with symbols'
        New-ParamCompleter -LongName include-source -Description 'Include PDBs and source files.'
        New-ParamCompleter -OldStyleName s -LongName serviceable -Description 'Set the serviceable flag in the package.'
        $nologoParam
        $interactiveParam
        $norestoreParam
        $verbosityParam
        $buildVersionSuffixParam
        $buildConfigurationParam
        $disableBuildServersParam
        $useCurrentRuntimeParam
        $helpParam
    ) -ArgumentCompleter $solutionOrProjectCompleter
    New-CommandCompleter -Name publish -Description 'Publish a .NET project for deployment.' -Parameters @(
        $useCurrentRuntimeParam
        $outputDirParam
        $buildArtifactsPathParam
        New-ParamCompleter -LongName manifest -Description 'The path to a target manifest file' -Type File
        $noBuildParam
        $publishSelfContainedParam
        $publishNoSelfContainedParam
        $nologoParam
        $targetFrameworkParam
        $targetRuntimeParam
        $buildConfigurationParam
        $buildVersionSuffixParam
        $interactiveParam
        $norestoreParam
        $verbosityParam
        $targetArchParam
        $targetOsParam
        $disableBuildServersParam
        $helpParam
    ) -ArgumentCompleter $solutionOrProjectCompleter
    New-CommandCompleter -Name remove -Description 'Remove a package or reference from a .NET project.' -Parameters $helpParam -SubCommands @(
        New-CommandCompleter -Name package -Description 'Remove a NuGet package reference from the project.' -Parameters $interactiveParam, $helpParam
        New-CommandCompleter -Name reference -Description 'Remove a project-to-project reference from the project.' -Parameters $targetFrameworkParam, $helpParam
    ) -ArgumentCompleter $projectCompleter
    New-CommandCompleter -Name restore -Description 'Restore dependencies specified in a .NET project.' -Parameters @(
        $disableBuildServersParam
        New-ParamCompleter -OldStyleName s -LongName source -Description 'The NuGet package source to use for the restore.' -Type Required
        New-ParamCompleter -LongName packages -Description 'The directory to restore packages to.' -Type File
        $useCurrentRuntimeParam
        $disableParallelParam
        $nugetConfigfileParam
        $noCacheParam
        $ignoreFailedSourcesParam
        New-ParamCompleter -OldStyleName f -LongName force -Description 'Force all dependencies to be resolved even if the last restore was successful.'
        $targetRuntimeParam
        New-ParamCompleter -LongName no-dependencies -Description 'Do not restore project-to-project references'
        $verbosityParam
        $interactiveParam
        New-ParamCompleter -LongName use-lock-file -Description 'Enables project lock file to be generated and used with restore.'
        New-ParamCompleter -LongName locked-mode -Description "Don't allow updating project lock file."
        New-ParamCompleter -LongName lock-file-path -Description 'Output location where project lock file is written.' -Type File
        New-ParamCompleter -LongName force-evaluate -Description 'Forces restore to reevaluate all dependencies even if a lock file already exists.'
        $targetArchParam
        $helpParam
    ) -ArgumentCompleter $solutionOrProjectCompleter
    New-CommandCompleter -Name run -Description 'Build and run a .NET project output.' -Parameters @(
        $buildConfigurationParam
        $targetFrameworkParam
        $targetRuntimeParam
        New-ParamCompleter -LongName project -Description 'The path to the project file to run' -Type File -ArgumentCompleter {
            param([string] $value, [int] $position, [MT.Comp.CompletionContext] $context)
            [MT.Comp.Helper]::CompleteFilename($value, $context.CurrentDirectory, $false, $false, { param([System.IO.FileInfo]$f)
                $f.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -or $f.Extension -match '\.\w+proj$'
            });
        }
        New-ParamCompleter -OldStyleName p -LongName property -Description 'Properties to be passed to MSBuild.' -Type Required
        New-ParamCompleter -OldStyleName lp -LongName launch-profile -Description 'The name of the launch profile' -Type Required
        New-ParamCompleter -LongName no-launch-profile -Description 'Do not attempt to use launchSettings.json to configure the application.'
        $noBuildParam
        $interactiveParam
        $norestoreParam
        $publishSelfContainedParam
        $publishNoSelfContainedParam
        $verbosityParam
        $targetArchParam
        $targetOsParam
        $disableBuildServersParam
        $helpParam
    )
    New-CommandCompleter -Name sdk -Description 'Manage .NET SDK installation.' -Parameters $helpParam -SubCommands @(
        New-CommandCompleter -Name check -Description '.NET SDK Check Command' -Parameters $helpParam
    )
    New-CommandCompleter -Name sln -Description 'Modify Visual Studio solution files.' -Parameters $helpParam -SubCommands @(
        New-CommandCompleter -Name add -Description 'Add one or more projects to a solution file.' -Parameters @(
            New-ParamCompleter -LongName in-root -Description 'Place project in root of the solution, rather than creating a solution folder.'
            New-ParamCompleter -OldStyleName s -LongName solution-folder -Description 'The destination solution folder path to add the projects to.' -Type File
            $helpParam
        ) -ArgumentCompleter $projectCompleter
        New-CommandCompleter -Name list -Description 'List all projects in a solution file.' -Parameters @(
            New-ParamCompleter -LongName in-root -Description 'Display solution folder paths.'
            $helpParam
        )
        New-CommandCompleter -Name remove -Description 'Remove one or more projects from a solution file.' -Parameters $helpParam -ArgumentCompleter $projectCompleter
    ) -ArgumentCompleter $solutionCompleter
    New-CommandCompleter -Name store -Description 'Store the specified assemblies in the runtime package store.' -Parameters @(
        New-ParamCompleter -OldStyleName m -LongName manifest -Description 'The XML file that contains the list of packages to be stored.' -Type File
        New-ParamCompleter -LongName framework-version -Description 'The Microsoft.NETCore.App package version that will be used to run the assemblies.' -Type Required
        $outputDirParam
        New-ParamCompleter -OldStyleName w -LongName working-dir -Description 'The working directory used by the command to execute.' -Type File
        New-ParamCompleter -LongName skip-optimization -Description 'Skip the optimization phase.'
        New-ParamCompleter -LongName skip-symbols -Description 'Skip creating symbol files which can be used for profiling the optimized assemblies.'
        $targetFrameworkParam
        $targetRuntimeParam
        $verbosityParam
        $useCurrentRuntimeParam
        $disableBuildServersParam
        $helpParam
    )
    New-CommandCompleter -Name test -Description 'Run unit tests using the test runner specified in a .NET project.' -Parameters @(
        New-ParamCompleter -OldStyleName s -LongName settings -Description 'The settings file to use when running tests.' -Type File
        New-ParamCompleter -OldStyleName t -LongName list-tests -Description 'List the discovered tests instead of running the tests.'
        New-ParamCompleter -OldStyleName e -LongName environment -Description 'Sets the value of an environment variable.' -Type Required
        New-ParamCompleter -LongName filter -Description 'Run tests that match the given expression.' -Type Required
        New-ParamCompleter -LongName test-adapter-path -Description 'The path to the custom adapters to use for the test run.' -Type File
        New-ParamCompleter -OldStyleName l -LongName logger -Description 'The logger to use for test results.' -Type Required
        $outputDirParam
        $buildArtifactsPathParam
        New-ParamCompleter -OldStyleName d -LongName diag -Description 'Enable verbose logging to the specified file.' -Type File
        $noBuildParam
        New-ParamCompleter -LongName results-directory -Description 'The directory where the test results will be placed.' -Type File
        New-ParamCompleter -LongName collect -Description 'The friendly name of the data collector to use for the test run.' -Type Required
        New-ParamCompleter -LongName blame -Description 'Runs the tests in blame mode.'
        New-ParamCompleter -LongName blame-crash -Description 'Runs the tests in blame mode and collects a crash dump when the test host exits unexpectedly.'
        New-ParamCompleter -LongName blame-crash-dump-type -Description 'The type of crash dump to be collected.' -Arguments "mini","full`tDefault"
        New-ParamCompleter -LongName blame-crash-collect-always -Description 'Enables collecting crash dump on expected as well as unexpected testhost exit.'
        New-ParamCompleter -LongName blame-hang -Description 'Run the tests in blame mode and enables collecting hang dump when test exceeds the given timeout.'
        New-ParamCompleter -LongName blame-hang-dump-type -Description 'The type of crash dump to be collected.' -Arguments "mini","full`tDefault","none"
        New-ParamCompleter -LongName blame-hang-timeout -Description 'Per-test timeout, after which hang dump is triggered and the testhost process is terminated.' -Type Required
        $nologoParam
        $buildConfigurationParam
        $targetFrameworkParam
        $targetRuntimeParam
        $norestoreParam
        $interactiveParam
        $verbosityParam
        $targetArchParam
        $targetOsParam
        $disableBuildServersParam
        $helpParam
    )
    New-CommandCompleter -Name tool -Description 'Install or manage tools that extend the .NET experience.' -Parameters $helpParam -SubCommands @(
        New-CommandCompleter -Name install -Description 'Install global or local tool. Local tools are added to manifest and restored.' -Parameters @(
            New-ParamCompleter -OldStyleName g -LongName global -Description 'Install the tool for the current user.'
            New-ParamCompleter -LongName local -Description 'Install the tool and add to the local tool manifest (default).'
            $toolPathParam
            $toolVersionParam
            $nugetConfigfileParam
            $toolManifestParam
            $toolAddSourceParam
            $toolFrameworkParam
            $toolPrereleaseParam
            $disableParallelParam
            $ignoreFailedSourcesParam
            $noCacheParam
            $interactiveParam
            $verbosityParam
            $targetArchParam
            New-ParamCompleter -LongName create-manifest-if-needed -Description "Create a tool manifest if one isn't found during tool installation."
            $helpParam
        )
        New-CommandCompleter -Name uninstall -Description 'Uninstall a global tool or local tool.' -Parameters @(
            New-ParamCompleter -OldStyleName g -LongName global -Description "Uninstall the tool from the current user's tools directory."
            New-ParamCompleter -LongName local -Description 'Uninstall the tool and remove it from the local tool manifest.'
            $toolPathParam
            $toolManifestParam
            $helpParam
        )
        New-CommandCompleter -Name update -Description 'Update a global or local tool.' -Parameters @(
            New-ParamCompleter -OldStyleName g -LongName global -Description "Update the tool in the current user's tools directory."
            $toolPathParam
            New-ParamCompleter -LongName local -Description 'Update the tool and the local tool manifest.'
            $nugetConfigfileParam
            $toolAddSourceParam
            $toolFrameworkParam
            $toolVersionParam
            $toolManifestParam
            $toolPrereleaseParam
            $disableParallelParam
            $ignoreFailedSourcesParam
            $noCacheParam
            $interactiveParam
            $verbosityParam
            $helpParam
        )
        New-CommandCompleter -Name list -Description 'List tools installed globally or locally.' -Parameters @(
            New-ParamCompleter -OldStyleName g -LongName global -Description 'List tools installed for the current user.'
            New-ParamCompleter -LongName local -Description 'List the tools installed in the local tool manifest.'
            $toolPathParam
            $helpParam
        )
        New-CommandCompleter -Name run -Description 'Run local tool.' -Parameters $helpParam
        New-CommandCompleter -Name search -Description 'Search dotnet tools in nuget.org' -Parameters @(
            New-ParamCompleter -LongName detail -Description 'Show detail result of the query.'
            New-ParamCompleter -LongName skip -Description 'The number of results to skip, for pagination.' -Type Required
            New-ParamCompleter -LongName take -Description 'The number of results to return, for pagination.' -Type Required
            $toolPrereleaseParam
            $helpParam
        )
        New-CommandCompleter -Name restore -Description 'Restore tools defined in the local tool manifest.' -Parameters @(
            $nugetConfigfileParam
            $toolAddSourceParam
            $toolManifestParam
            $disableParallelParam
            $ignoreFailedSourcesParam
            $noCacheParam
            $interactiveParam
            $verbosityParam
            $helpParam
        )
    )
    New-CommandCompleter -Name vstest -Description 'Run Microsoft Test Engine (VSTest) commands.' -Parameters @(
        # TBD
        $helpParam
    )
    New-CommandCompleter -Name workload -Description 'Manage optional workloads.' -Parameters @(
        New-ParamCompleter -LongName info -Description 'Display information about installed workloads.'
        New-ParamCompleter -LongName version -Description 'Display the currently installed workload version.'
        $helpParam
    ) -SubCommands @(
        New-CommandCompleter -Name install -Description 'Install one or more workloads.' -Parameters @(
            $nugetConfigfileParam
            $nugetSourceParam
            $workloadIncludePreviewsParam
            $workloadSkipManifestUpdateParam
            $workloadTempDirParam
            $disableParallelParam
            $ignoreFailedSourcesParam
            $noCacheParam
            $interactiveParam
            $verbosityParam
            $helpParam
        )
        New-CommandCompleter -Name update -Description 'Update all installed workloads.' -Parameters @(
            $nugetConfigfileParam
            $nugetSourceParam
            $workloadIncludePreviewsParam
            $workloadTempDirParam
            New-ParamCompleter -LongName from-previous-sdk -Description 'Include workloads installed with earlier SDK versions in update.'
            New-ParamCompleter -LongName advertising-manifests-only -Description 'Only update advertising manifests.'
            $ignoreFailedSourcesParam
            $noCacheParam
            $interactiveParam
            $verbosityParam
            $helpParam
        )
        New-CommandCompleter -Name list -Description 'List workloads available.' -Parameters $helpParam
        New-CommandCompleter -Name search -Description 'Search for available workloads.' -Parameters $helpParam
        New-CommandCompleter -Name uninstall -Description 'Uninstall one or more workloads.' -Parameters $verbosityParam, $helpParam
        New-CommandCompleter -Name repair -Description 'Repair workload installations.' -Parameters @(
            $nugetConfigfileParam
            $nugetSourceParam
            $verbosityParam
            $disableParallelParam
            $ignoreFailedSourcesParam
            $noCacheParam
            $interactiveParam
            $helpParam
        )
        New-CommandCompleter -Name restore -Description 'Restore workloads required for a project.' -Parameters @(
            $nugetConfigfileParam
            $nugetSourceParam
            $workloadIncludePreviewsParam
            $workloadSkipManifestUpdateParam
            $workloadTempDirParam
            $disableParallelParam
            $ignoreFailedSourcesParam
            $noCacheParam
            $interactiveParam
            $verbosityParam
            $helpParam
        )
        New-CommandCompleter -Name clean -Description 'Removes workload components' -Parameters @(
            New-ParamCompleter -LongName all -Description 'Causes clean to remove and uninstall all workload components from all SDK versions.'
            $helpParam
        )
    )
)
