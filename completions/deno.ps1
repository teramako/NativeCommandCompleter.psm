<#
 # deno completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    deno                    = A modern JavaScript and TypeScript runtime
    cmd_run                 = Run a JavaScript or TypeScript program
    cmd_serve               = Run a server
    cmd_add                 = Add dependencies
    cmd_bench               = Run benchmarks
    cmd_bundle              = Bundle module and dependencies into single file
    cmd_cache               = Cache dependencies
    cmd_check               = Type-check the dependencies
    cmd_clean               = Remove the cache directory
    cmd_compile             = Compile the script into a self contained executable
    cmd_completions         = Generate shell completions
    cmd_coverage            = Print coverage reports
    cmd_doc                 = Show documentation for a module
    cmd_eval                = Eval script
    cmd_fmt                 = Format source files
    cmd_info                = Show info about cache or info related to source file
    cmd_init                = Initialize a new project
    cmd_install             = Install script as an executable
    cmd_jupyter             = Deno kernel for Jupyter notebooks
    cmd_lint                = Lint source files
    cmd_lsp                 = Start the language server
    cmd_publish             = Publish the current working directory's package or workspace
    cmd_repl                = Read Eval Print Loop
    cmd_remove              = Remove dependencies from the configuration file
    cmd_task                = Run a task defined in the configuration file
    cmd_test                = Run tests
    cmd_types               = Print runtime TypeScript declarations
    cmd_uninstall           = Uninstall a script previously installed with deno install
    cmd_upgrade             = Upgrade deno executable to given version
    cmd_vendor              = Vendor remote modules into a local directory
    cmd_help                = Print this message or the help of the given subcommand(s)

    allow_all               = Allow all permissions
    allow_env               = Allow environment access
    allow_ffi               = Allow loading dynamic libraries
    allow_hrtime            = Allow high-resolution time measurement
    allow_net               = Allow network access
    allow_read              = Allow file system read access
    allow_run               = Allow running subprocesses
    allow_sys               = Allow access to system information
    allow_write             = Allow file system write access
    cached_only             = Require that remote dependencies are already cached
    cert                    = Load certificate authority from PEM encoded file
    check                   = Type-check modules
    config                  = Specify the configuration file
    deny_env                = Deny environment access
    deny_ffi                = Deny loading dynamic libraries
    deny_hrtime             = Deny high-resolution time measurement
    deny_net                = Deny network access
    deny_read               = Deny file system read access
    deny_run                = Deny running subprocesses
    deny_sys                = Deny access to system information
    deny_write              = Deny file system write access
    enable_testing_features = Enable testing features
    env_file                = Load environment variables from local file
    ext                     = Set content type of the supplied file
    frozen                  = Error out if lockfile is out of date
    help                    = Print help information
    import_map              = Load import map file
    inspect                 = Activate inspector on host:port
    inspect_brk             = Activate inspector and break at start
    inspect_wait            = Activate inspector and wait for debugger to connect
    location                = Value of globalThis.location
    lock                    = Check the specified lock file
    lock_write              = Force overwriting the lock file
    log_level               = Set log level
    no_check                = Skip type-checking modules
    no_config               = Disable automatic loading of configuration file
    no_lock                 = Disable auto discovery of the lock file
    no_npm                  = Do not resolve npm modules
    no_prompt               = Always throw if required permission wasn't passed
    no_remote               = Do not resolve remote modules
    node_modules_dir        = Enables or disables the use of a local node_modules folder
    prompt                  = Fallback to prompt if required permission wasn't passed
    quiet                   = Suppress diagnostic output
    reload                  = Reload source code cache
    seed                    = Set the random number generator seed
    unstable                = Enable unstable features and APIs
    unstable_bare_node_builtins = Enable unstable bare node builtins feature
    unstable_byonm          = Enable unstable 'bring your own node_modules' feature
    unstable_sloppy_imports = Enable unstable resolving of specifiers by extension probing
    unsafely_ignore_certificate_errors = Disable verification of TLS certificates
    v8_flags                = Set V8 command line options
    version                 = Print version
    watch                   = Watch for file changes and restart process automatically
    watch_exclude           = Exclude provided files/patterns from watch mode

    run_no_clear_screen     = Do not clear terminal screen when under watch mode
    run_watch_hmr           = Watch for file changes and hot replace modules

    serve_port              = Set port
    serve_host              = Set host

    check_all               = Type-check all code
    check_remote            = Type-check remote modules

    compile_output          = Output file
    compile_target          = Target OS architecture
    compile_no_terminal     = Hide terminal on Windows
    compile_icon            = Set executable icon
    compile_include         = Additional files to include in the executable

    completions_shell       = Shell type

    coverage_exclude        = Exclude files from coverage
    coverage_html           = Output coverage report in HTML
    coverage_include        = Include files in coverage
    coverage_lcov           = Output coverage report in lcov format
    coverage_output         = Output file

    doc_filter              = Dot separated path to symbol
    doc_html                = Output documentation in HTML
    doc_json                = Output documentation in JSON
    doc_lint                = Output documentation diagnostics to STDERR
    doc_name                = The name that will be displayed in the docs
    doc_output              = Directory for HTML output
    doc_private             = Output private documentation

    eval_typescript         = Treat eval input as TypeScript
    eval_print              = Print result to stdout

    fmt_check               = Check if the source files are formatted
    fmt_ext                 = Set content type of the supplied file
    fmt_ignore              = Ignore formatting particular source files
    fmt_line_width          = Define maximum line width
    fmt_no_semicolons       = Don't use semicolons except where necessary
    fmt_prose_wrap          = Define how prose should be wrapped
    fmt_single_quote        = Use single quotes
    fmt_use_tabs            = Use tabs instead of spaces for indentation

    info_json               = Output the information in JSON format

    init_lib                = Generate an example library project
    init_serve              = Generate an example project for deno serve

    install_force           = Forcefully overwrite existing installation
    install_global          = Install a package or script as a globally available executable
    install_name            = Executable file name
    install_root            = Installation root

    lint_ignore             = Ignore linting particular source files
    lint_json               = Output lint result in JSON format
    lint_rules              = List available rules
    lint_rules_exclude      = Exclude lint rules
    lint_rules_include      = Include lint rules
    lint_rules_tags         = Use set of rules with a tag

    publish_allow_dirty     = Allow publishing if the repository has uncommitted changed
    publish_allow_slow_types = Allow publishing with slow types
    publish_dry_run         = Prepare the package for publishing performing all checks and validations
    publish_no_provenance   = Disable provenance attestation
    publish_provenance      = Enable provenance attestation
    publish_token           = The API token to use when publishing

    repl_eval_file          = Evaluates the provided file(s) as scripts
    repl_eval               = Evaluates the provided code

    task_cwd                = Specify the working directory

    test_allow_none         = Don't return error code if no test files are found
    test_coverage           = Collect coverage profile data into DIR
    test_doc                = Type-check code blocks in JSDoc and Markdown
    test_fail_fast          = Stop after N errors
    test_filter             = Run tests with this string or pattern in the test name
    test_ignore             = Ignore files
    test_jobs               = Number of parallel workers
    test_junit_path         = Write a JUnit XML test report to PATH
    test_no_run             = Cache test modules, but don't run tests
    test_parallel           = Run test modules in parallel
    test_permit_no_files    = Don't error out if no test files are found
    test_reporter           = Select reporter to use
    test_shuffle            = Shuffle the order in which the tests are run
    test_trace_leaks        = Enable tracing of leaks

    uninstall_global        = Remove globally installed package or module
    uninstall_name          = Name of the executable to be removed
    uninstall_root          = Installation root

    upgrade_canary          = Upgrade to canary builds
    upgrade_dry_run         = Perform all checks without replacing old exe
    upgrade_force           = Replace current exe even if not out-of-date
    upgrade_output          = The path to output the updated version to
    upgrade_version         = The version to upgrade to

    vendor_force            = Forcefully overwrite conflicting files in existing output directory
    vendor_output           = The directory to output the vendored modules to
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# Common permission parameters
$allowAllParam = New-ParamCompleter -ShortName A -LongName allow-all -Description $msg.allow_all
$allowEnvParam = New-ParamCompleter -LongName allow-env -Description $msg.allow_env -Type FlagOrValue -VariableName 'VARIABLE_NAME'
$allowFfiParam = New-ParamCompleter -LongName allow-ffi -Description $msg.allow_ffi -Type FlagOrValue -VariableName 'PATH'
$allowHrtimeParam = New-ParamCompleter -LongName allow-hrtime -Description $msg.allow_hrtime
$allowNetParam = New-ParamCompleter -LongName allow-net -Description $msg.allow_net -Type FlagOrValue -VariableName 'IP_OR_HOSTNAME'
$allowReadParam = New-ParamCompleter -LongName allow-read -Description $msg.allow_read -Type FlagOrValue -VariableName 'PATH'
$allowRunParam = New-ParamCompleter -LongName allow-run -Description $msg.allow_run -Type FlagOrValue -VariableName 'PROGRAM_NAME'
$allowSysParam = New-ParamCompleter -LongName allow-sys -Description $msg.allow_sys -Type FlagOrValue -VariableName 'API_NAME'
$allowWriteParam = New-ParamCompleter -LongName allow-write -Description $msg.allow_write -Type FlagOrValue -VariableName 'PATH'

$denyEnvParam = New-ParamCompleter -LongName deny-env -Description $msg.deny_env -Type FlagOrValue -VariableName 'VARIABLE_NAME'
$denyFfiParam = New-ParamCompleter -LongName deny-ffi -Description $msg.deny_ffi -Type FlagOrValue -VariableName 'PATH'
$denyHrtimeParam = New-ParamCompleter -LongName deny-hrtime -Description $msg.deny_hrtime
$denyNetParam = New-ParamCompleter -LongName deny-net -Description $msg.deny_net -Type FlagOrValue -VariableName 'IP_OR_HOSTNAME'
$denyReadParam = New-ParamCompleter -LongName deny-read -Description $msg.deny_read -Type FlagOrValue -VariableName 'PATH'
$denyRunParam = New-ParamCompleter -LongName deny-run -Description $msg.deny_run -Type FlagOrValue -VariableName 'PROGRAM_NAME'
$denySysParam = New-ParamCompleter -LongName deny-sys -Description $msg.deny_sys -Type FlagOrValue -VariableName 'API_NAME'
$denyWriteParam = New-ParamCompleter -LongName deny-write -Description $msg.deny_write -Type FlagOrValue -VariableName 'PATH'

# Common configuration parameters
$cachedOnlyParam = New-ParamCompleter -LongName cached-only -Description $msg.cached_only
$certParam = New-ParamCompleter -LongName cert -Description $msg.cert -Type File -VariableName 'FILE'
$checkParam = New-ParamCompleter -LongName check -Description $msg.check -Type FlagOrValue -VariableName 'CHECK_TYPE'
$configParam = New-ParamCompleter -ShortName c -LongName config -Description $msg.config -Type File -VariableName 'FILE'
$envFileParam = New-ParamCompleter -LongName env-file -Description $msg.env_file -Type File -VariableName 'FILE'
$extParam = New-ParamCompleter -LongName ext -Description $msg.ext -Type Required -VariableName 'EXT'
$frozenParam = New-ParamCompleter -LongName frozen -Description $msg.frozen
$importMapParam = New-ParamCompleter -LongName import-map -Description $msg.import_map -Type File -VariableName 'FILE'
$inspectParam = New-ParamCompleter -LongName inspect -Description $msg.inspect -Type FlagOrValue -VariableName 'HOST_AND_PORT'
$inspectBrkParam = New-ParamCompleter -LongName inspect-brk -Description $msg.inspect_brk -Type FlagOrValue -VariableName 'HOST_AND_PORT'
$inspectWaitParam = New-ParamCompleter -LongName inspect-wait -Description $msg.inspect_wait -Type FlagOrValue -VariableName 'HOST_AND_PORT'
$locationParam = New-ParamCompleter -LongName location -Description $msg.location -Type Required -VariableName 'HREF'
$lockParam = New-ParamCompleter -LongName lock -Description $msg.lock -Type FlagOrValue -VariableName 'FILE'
$lockWriteParam = New-ParamCompleter -LongName lock-write -Description $msg.lock_write
$logLevelParam = New-ParamCompleter -ShortName L -LongName log-level -Description $msg.log_level -Arguments "trace","debug","info" -VariableName 'LEVEL'
$versionParam = New-ParamCompleter -ShortName V -LongName version -Description $msg.version
$noCheckParam = New-ParamCompleter -LongName no-check -Description $msg.no_check -Type FlagOrValue -VariableName 'NO_CHECK_TYPE'
$noConfigParam = New-ParamCompleter -LongName no-config -Description $msg.no_config
$noLockParam = New-ParamCompleter -LongName no-lock -Description $msg.no_lock
$noNpmParam = New-ParamCompleter -LongName no-npm -Description $msg.no_npm
$noPromptParam = New-ParamCompleter -LongName no-prompt -Description $msg.no_prompt
$noRemoteParam = New-ParamCompleter -LongName no-remote -Description $msg.no_remote
$nodeModulesDirParam = New-ParamCompleter -LongName node-modules-dir -Description $msg.node_modules_dir -Type FlagOrValue -VariableName 'BOOL'
$quietParam = New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
$reloadParam = New-ParamCompleter -ShortName r -LongName reload -Description $msg.reload -Type FlagOrValue -VariableName 'CACHE_BLOCKLIST'
$seedParam = New-ParamCompleter -LongName seed -Description $msg.seed -Type Required -VariableName 'NUMBER'
$unsafeCertsParam = New-ParamCompleter -LongName unsafely-ignore-certificate-errors -Description $msg.unsafely_ignore_certificate_errors -Type FlagOrValue -VariableName 'HOSTNAMES'
$v8FlagsParam = New-ParamCompleter -LongName v8-flags -Description $msg.v8_flags -Type List -VariableName 'V8_FLAGS'
$watchParam = New-ParamCompleter -LongName watch -Description $msg.watch -Type FlagOrValue -VariableName 'FILES'
$watchExcludeParam = New-ParamCompleter -LongName watch-exclude -Description $msg.watch_exclude -Type FlagOrValue -VariableName 'FILES'

# Unstable feature parameters
$unstableParam = New-ParamCompleter -LongName unstable -Description $msg.unstable -Type FlagOrValue -VariableName 'FEATURES'
$unstableBareNodeBuiltinsParam = New-ParamCompleter -LongName unstable-bare-node-builtins -Description $msg.unstable_bare_node_builtins
$unstableByonmParam = New-ParamCompleter -LongName unstable-byonm -Description $msg.unstable_byonm
$unstableSloppyImportsParam = New-ParamCompleter -LongName unstable-sloppy-imports -Description $msg.unstable_sloppy_imports

$helpParam = New-ParamCompleter -ShortName h -LongName help -Description $msg.help

Register-NativeCompleter -Name deno -Description $msg.deno -Parameters @(
    $helpParam, $versionParam, $logLevelParam, $quietParam
) -SubCommands @(
    # run
    New-CommandCompleter -Name run -Description $msg.cmd_run -Parameters @(
        $allowAllParam
        $allowEnvParam
        $allowFfiParam
        $allowHrtimeParam
        $allowNetParam
        $allowReadParam
        $allowRunParam
        $allowSysParam
        $allowWriteParam
        $denyEnvParam
        $denyFfiParam
        $denyHrtimeParam
        $denyNetParam
        $denyReadParam
        $denyRunParam
        $denySysParam
        $denyWriteParam
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $envFileParam
        $frozenParam
        $importMapParam
        $inspectParam
        $inspectBrkParam
        $inspectWaitParam
        $locationParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noPromptParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $seedParam
        $unsafeCertsParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $v8FlagsParam
        $watchParam
        $watchExcludeParam
        New-ParamCompleter -LongName no-clear-screen -Description $msg.run_no_clear_screen
        New-ParamCompleter -LongName watch-hmr -Description $msg.run_watch_hmr
        $extParam
        New-ParamCompleter -LongName enable-testing-features-do-not-use -Description $msg.enable_testing_features
        $helpParam
    )

    # serve
    New-CommandCompleter -Name serve -Description $msg.cmd_serve -Parameters @(
        $allowAllParam
        $allowEnvParam
        $allowFfiParam
        $allowHrtimeParam
        $allowNetParam
        $allowReadParam
        $allowRunParam
        $allowSysParam
        $allowWriteParam
        $denyEnvParam
        $denyFfiParam
        $denyHrtimeParam
        $denyNetParam
        $denyReadParam
        $denyRunParam
        $denySysParam
        $denyWriteParam
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $envFileParam
        $frozenParam
        $importMapParam
        $inspectParam
        $inspectBrkParam
        $inspectWaitParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noPromptParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $seedParam
        $unsafeCertsParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $v8FlagsParam
        $watchParam
        $watchExcludeParam
        New-ParamCompleter -LongName port -Description $msg.serve_port -Type Required -VariableName 'PORT'
        New-ParamCompleter -LongName host -Description $msg.serve_host -Type Required -VariableName 'HOST'
        $helpParam
    )

    # add
    New-CommandCompleter -Name add -Description $msg.cmd_add -Parameters @(
        $configParam
        $quietParam
        $helpParam
    ) -NoFileCompletions

    # bench
    New-CommandCompleter -Name bench -Description $msg.cmd_bench -Parameters @(
        $allowAllParam
        $allowEnvParam
        $allowFfiParam
        $allowHrtimeParam
        $allowNetParam
        $allowReadParam
        $allowRunParam
        $allowSysParam
        $allowWriteParam
        $denyEnvParam
        $denyFfiParam
        $denyHrtimeParam
        $denyNetParam
        $denyReadParam
        $denyRunParam
        $denySysParam
        $denyWriteParam
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $envFileParam
        $frozenParam
        $importMapParam
        $inspectParam
        $inspectBrkParam
        $inspectWaitParam
        $locationParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noPromptParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $seedParam
        $unsafeCertsParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $v8FlagsParam
        $watchParam
        $watchExcludeParam
        New-ParamCompleter -LongName filter -Description $msg.test_filter -Type Required -VariableName 'PATTERN'
        New-ParamCompleter -LongName ignore -Description $msg.test_ignore -Type List -VariableName 'PATHS'
        New-ParamCompleter -LongName json -Description $msg.info_json
        New-ParamCompleter -LongName no-run -Description $msg.test_no_run
        $helpParam
    )

    # cache
    New-CommandCompleter -Name cache -Description $msg.cmd_cache -Parameters @(
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $frozenParam
        $importMapParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $helpParam
    )

    # check
    New-CommandCompleter -Name check -Description $msg.cmd_check -Parameters @(
        $certParam
        $configParam
        $importMapParam
        $lockParam
        $lockWriteParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        New-ParamCompleter -LongName all -Description $msg.check_all
        New-ParamCompleter -LongName remote -Description $msg.check_remote
        $helpParam
    )

    # clean
    New-CommandCompleter -Name clean -Description $msg.cmd_clean -Parameters @(
        $helpParam
    ) -NoFileCompletions

    # compile
    New-CommandCompleter -Name compile -Description $msg.cmd_compile -Parameters @(
        $allowAllParam
        $allowEnvParam
        $allowFfiParam
        $allowHrtimeParam
        $allowNetParam
        $allowReadParam
        $allowRunParam
        $allowSysParam
        $allowWriteParam
        $denyEnvParam
        $denyFfiParam
        $denyHrtimeParam
        $denyNetParam
        $denyReadParam
        $denyRunParam
        $denySysParam
        $denyWriteParam
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $envFileParam
        $frozenParam
        $importMapParam
        $locationParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noPromptParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $seedParam
        $unsafeCertsParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $v8FlagsParam
        New-ParamCompleter -ShortName o -LongName output -Description $msg.compile_output -Type File -VariableName 'OUTPUT'
        New-ParamCompleter -LongName target -Description $msg.compile_target -Type Required -VariableName 'TARGET'
        New-ParamCompleter -LongName no-terminal -Description $msg.compile_no_terminal
        New-ParamCompleter -LongName icon -Description $msg.compile_icon -Type File -VariableName 'FILE'
        New-ParamCompleter -LongName include -Description $msg.compile_include -Type File -VariableName 'FILE'
        $extParam
        $helpParam
    )

    # completions
    New-CommandCompleter -Name completions -Description $msg.cmd_completions -Parameters @(
        $helpParam
    ) -NoFileCompletions -ArgumentCompleter {
        "bash","fish","powershell","zsh","fig" | Where-Object { $_ -like "$wordToComplete*" }
    }

    # coverage
    New-CommandCompleter -Name coverage -Description $msg.cmd_coverage -Parameters @(
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        New-ParamCompleter -LongName exclude -Description $msg.coverage_exclude -Type List -VariableName 'REGEX'
        New-ParamCompleter -LongName html -Description $msg.coverage_html
        New-ParamCompleter -LongName include -Description $msg.coverage_include -Type List -VariableName 'REGEX'
        New-ParamCompleter -LongName lcov -Description $msg.coverage_lcov
        New-ParamCompleter -LongName output -Description $msg.coverage_output -Type File -VariableName 'FILE'
        $helpParam
    )

    # doc
    New-CommandCompleter -Name doc -Description $msg.cmd_doc -Parameters @(
        $certParam
        $configParam
        $importMapParam
        $lockParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $reloadParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        New-ParamCompleter -LongName filter -Description $msg.doc_filter -Type Required -VariableName 'FILTER'
        New-ParamCompleter -LongName html -Description $msg.doc_html
        New-ParamCompleter -LongName json -Description $msg.doc_json
        New-ParamCompleter -LongName lint -Description $msg.doc_lint
        New-ParamCompleter -LongName name -Description $msg.doc_name -Type Required -VariableName 'NAME'
        New-ParamCompleter -LongName output -Description $msg.doc_output -Type Directory -VariableName 'DIR'
        New-ParamCompleter -LongName private -Description $msg.doc_private
        $helpParam
    )

    # eval
    New-CommandCompleter -Name eval -Description $msg.cmd_eval -Parameters @(
        $allowAllParam
        $allowEnvParam
        $allowFfiParam
        $allowHrtimeParam
        $allowNetParam
        $allowReadParam
        $allowRunParam
        $allowSysParam
        $allowWriteParam
        $denyEnvParam
        $denyFfiParam
        $denyHrtimeParam
        $denyNetParam
        $denyReadParam
        $denyRunParam
        $denySysParam
        $denyWriteParam
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $envFileParam
        $frozenParam
        $importMapParam
        $inspectParam
        $inspectBrkParam
        $inspectWaitParam
        $locationParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noPromptParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $seedParam
        $unsafeCertsParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $v8FlagsParam
        New-ParamCompleter -ShortName T -LongName ts -Description $msg.eval_typescript
        New-ParamCompleter -ShortName p -LongName print -Description $msg.eval_print
        $extParam
        $helpParam
    ) -NoFileCompletions

    # fmt
    New-CommandCompleter -Name fmt -Description $msg.cmd_fmt -Parameters @(
        $configParam
        $noConfigParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $watchParam
        $watchExcludeParam
        New-ParamCompleter -LongName check -Description $msg.fmt_check
        New-ParamCompleter -LongName ext -Description $msg.fmt_ext -Type Required -VariableName 'EXT'
        New-ParamCompleter -LongName ignore -Description $msg.fmt_ignore -Type List -VariableName 'PATHS'
        New-ParamCompleter -LongName line-width -Description $msg.fmt_line_width -Type Required -VariableName 'WIDTH'
        New-ParamCompleter -LongName no-semicolons -Description $msg.fmt_no_semicolons -Type FlagOrValue -VariableName 'BOOL'
        New-ParamCompleter -LongName prose-wrap -Description $msg.fmt_prose_wrap -Arguments "always","never","preserve" -VariableName 'MODE'
        New-ParamCompleter -LongName single-quote -Description $msg.fmt_single_quote -Type FlagOrValue -VariableName 'BOOL'
        New-ParamCompleter -LongName use-tabs -Description $msg.fmt_use_tabs -Type FlagOrValue -VariableName 'BOOL'
        $helpParam
    )

    # info
    New-CommandCompleter -Name info -Description $msg.cmd_info -Parameters @(
        $certParam
        $configParam
        $importMapParam
        $locationParam
        $lockParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $reloadParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        New-ParamCompleter -LongName json -Description $msg.info_json
        $helpParam
    )

    # init
    New-CommandCompleter -Name init -Description $msg.cmd_init -Parameters @(
        $quietParam
        New-ParamCompleter -LongName lib -Description $msg.init_lib
        New-ParamCompleter -LongName serve -Description $msg.init_serve
        $helpParam
    ) -NoFileCompletions

    # install
    New-CommandCompleter -Name install -Description $msg.cmd_install -Parameters @(
        $allowAllParam
        $allowEnvParam
        $allowFfiParam
        $allowHrtimeParam
        $allowNetParam
        $allowReadParam
        $allowRunParam
        $allowSysParam
        $allowWriteParam
        $denyEnvParam
        $denyFfiParam
        $denyHrtimeParam
        $denyNetParam
        $denyReadParam
        $denyRunParam
        $denySysParam
        $denyWriteParam
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $envFileParam
        $frozenParam
        $importMapParam
        $inspectParam
        $inspectBrkParam
        $inspectWaitParam
        $locationParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noPromptParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $seedParam
        $unsafeCertsParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $v8FlagsParam
        New-ParamCompleter -ShortName f -LongName force -Description $msg.install_force
        New-ParamCompleter -ShortName g -LongName global -Description $msg.install_global
        New-ParamCompleter -ShortName n -LongName name -Description $msg.install_name -Type Required -VariableName 'NAME'
        New-ParamCompleter -LongName root -Description $msg.install_root -Type Directory -VariableName 'PATH'
        $helpParam
    )

    # jupyter
    New-CommandCompleter -Name jupyter -Description $msg.cmd_jupyter -Parameters @(
        $helpParam
    ) -NoFileCompletions

    # lint
    New-CommandCompleter -Name lint -Description $msg.cmd_lint -Parameters @(
        $configParam
        $noConfigParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $watchParam
        $watchExcludeParam
        New-ParamCompleter -LongName ignore -Description $msg.lint_ignore -Type List -VariableName 'PATHS'
        New-ParamCompleter -LongName json -Description $msg.lint_json
        New-ParamCompleter -LongName rules -Description $msg.lint_rules
        New-ParamCompleter -LongName rules-exclude -Description $msg.lint_rules_exclude -Type List -VariableName 'RULES'
        New-ParamCompleter -LongName rules-include -Description $msg.lint_rules_include -Type List -VariableName 'RULES'
        New-ParamCompleter -LongName rules-tags -Description $msg.lint_rules_tags -Type List -VariableName 'TAGS'
        $helpParam
    )

    # lsp
    New-CommandCompleter -Name lsp -Description $msg.cmd_lsp -Parameters @(
        $quietParam
        $helpParam
    ) -NoFileCompletions

    # publish
    New-CommandCompleter -Name publish -Description $msg.cmd_publish -Parameters @(
        $certParam
        $checkParam
        $configParam
        $noCheckParam
        $noConfigParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        New-ParamCompleter -LongName allow-dirty -Description $msg.publish_allow_dirty
        New-ParamCompleter -LongName allow-slow-types -Description $msg.publish_allow_slow_types
        New-ParamCompleter -LongName dry-run -Description $msg.publish_dry_run
        New-ParamCompleter -LongName no-provenance -Description $msg.publish_no_provenance
        New-ParamCompleter -LongName provenance -Description $msg.publish_provenance
        New-ParamCompleter -LongName token -Description $msg.publish_token -Type Required -VariableName 'TOKEN'
        $helpParam
    ) -NoFileCompletions

    # repl
    New-CommandCompleter -Name repl -Description $msg.cmd_repl -Parameters @(
        $allowAllParam
        $allowEnvParam
        $allowFfiParam
        $allowHrtimeParam
        $allowNetParam
        $allowReadParam
        $allowRunParam
        $allowSysParam
        $allowWriteParam
        $denyEnvParam
        $denyFfiParam
        $denyHrtimeParam
        $denyNetParam
        $denyReadParam
        $denyRunParam
        $denySysParam
        $denyWriteParam
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $envFileParam
        $frozenParam
        $importMapParam
        $inspectParam
        $inspectBrkParam
        $inspectWaitParam
        $locationParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noPromptParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $seedParam
        $unsafeCertsParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $v8FlagsParam
        New-ParamCompleter -LongName eval-file -Description $msg.repl_eval_file -Type File -VariableName 'FILES'
        New-ParamCompleter -LongName eval -Description $msg.repl_eval -Type Required -VariableName 'CODE'
        $helpParam
    ) -NoFileCompletions

    # remove
    New-CommandCompleter -Name remove -Aliases rm -Description $msg.cmd_remove -Parameters @(
        $configParam
        $quietParam
        $helpParam
    ) -NoFileCompletions

    # task
    New-CommandCompleter -Name task -Description $msg.cmd_task -Parameters @(
        $configParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        New-ParamCompleter -LongName cwd -Description $msg.task_cwd -Type Directory -VariableName 'DIR'
        $helpParam
    ) -NoFileCompletions

    # test
    New-CommandCompleter -Name test -Description $msg.cmd_test -Parameters @(
        $allowAllParam
        $allowEnvParam
        $allowFfiParam
        $allowHrtimeParam
        $allowNetParam
        $allowReadParam
        $allowRunParam
        $allowSysParam
        $allowWriteParam
        $denyEnvParam
        $denyFfiParam
        $denyHrtimeParam
        $denyNetParam
        $denyReadParam
        $denyRunParam
        $denySysParam
        $denyWriteParam
        $cachedOnlyParam
        $certParam
        $checkParam
        $configParam
        $envFileParam
        $frozenParam
        $importMapParam
        $inspectParam
        $inspectBrkParam
        $inspectWaitParam
        $locationParam
        $lockParam
        $lockWriteParam
        $noCheckParam
        $noConfigParam
        $noLockParam
        $noNpmParam
        $noPromptParam
        $noRemoteParam
        $nodeModulesDirParam
        $reloadParam
        $seedParam
        $unsafeCertsParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        $v8FlagsParam
        $watchParam
        $watchExcludeParam
        New-ParamCompleter -LongName allow-none -Description $msg.test_allow_none
        New-ParamCompleter -LongName coverage -Description $msg.test_coverage -Type Directory -VariableName 'DIR'
        New-ParamCompleter -LongName doc -Description $msg.test_doc
        New-ParamCompleter -LongName fail-fast -Description $msg.test_fail_fast -Type FlagOrValue -VariableName 'N'
        New-ParamCompleter -LongName filter -Description $msg.test_filter -Type Required -VariableName 'PATTERN'
        New-ParamCompleter -LongName ignore -Description $msg.test_ignore -Type List -VariableName 'PATHS'
        New-ParamCompleter -ShortName j -LongName jobs -Description $msg.test_jobs -Type FlagOrValue -VariableName 'N'
        New-ParamCompleter -LongName junit-path -Description $msg.test_junit_path -Type File -VariableName 'PATH'
        New-ParamCompleter -LongName no-run -Description $msg.test_no_run
        New-ParamCompleter -LongName parallel -Description $msg.test_parallel
        New-ParamCompleter -LongName permit-no-files -Description $msg.test_permit_no_files
        New-ParamCompleter -LongName reporter -Description $msg.test_reporter -Arguments "pretty","dot","junit","tap" -VariableName 'REPORTER'
        New-ParamCompleter -LongName shuffle -Description $msg.test_shuffle -Type FlagOrValue -VariableName 'SEED'
        New-ParamCompleter -LongName trace-leaks -Description $msg.test_trace_leaks
        $helpParam
    )

    # types
    New-CommandCompleter -Name types -Description $msg.cmd_types -Parameters @(
        $helpParam
    ) -NoFileCompletions

    # uninstall
    New-CommandCompleter -Name uninstall -Description $msg.cmd_uninstall -Parameters @(
        New-ParamCompleter -ShortName g -LongName global -Description $msg.uninstall_global
        New-ParamCompleter -ShortName n -LongName name -Description $msg.uninstall_name -Type Required -VariableName 'NAME'
        New-ParamCompleter -LongName root -Description $msg.uninstall_root -Type Directory -VariableName 'PATH'
        $helpParam
    ) -NoFileCompletions

    # upgrade
    New-CommandCompleter -Name upgrade -Description $msg.cmd_upgrade -Parameters @(
        $quietParam
        New-ParamCompleter -LongName canary -Description $msg.upgrade_canary
        New-ParamCompleter -LongName dry-run -Description $msg.upgrade_dry_run
        New-ParamCompleter -ShortName f -LongName force -Description $msg.upgrade_force
        New-ParamCompleter -LongName output -Description $msg.upgrade_output -Type File -VariableName 'PATH'
        New-ParamCompleter -LongName version -Description $msg.upgrade_version -Type Required -VariableName 'VERSION'
        $helpParam
    ) -NoFileCompletions

    # vendor
    New-CommandCompleter -Name vendor -Description $msg.cmd_vendor -Parameters @(
        $certParam
        $configParam
        $frozenParam
        $importMapParam
        $lockParam
        $noConfigParam
        $reloadParam
        $unstableParam
        $unstableBareNodeBuiltinsParam
        $unstableByonmParam
        $unstableSloppyImportsParam
        New-ParamCompleter -ShortName f -LongName force -Description $msg.vendor_force
        New-ParamCompleter -LongName output -Description $msg.vendor_output -Type Directory -VariableName 'DIR'
        $helpParam
    )

    # help
    New-CommandCompleter -Name help -Description $msg.cmd_help -NoFileCompletions -ArgumentCompleter {
        "run","serve","add","bench","cache","check","clean","compile","completions","coverage","doc",
        "eval","fmt","info","init","install","jupyter","lint","lsp","publish","repl","remove","task",
        "test","types","uninstall","upgrade","vendor","help" |
            Where-Object { $_ -like "$wordToComplete*" }
    }
) -NoFileCompletions
