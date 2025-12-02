<#
 # jq completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    jq                      = Command-line JSON processor
    null_input              = Use null as single input value
    raw_input               = Each line of input is passed as a string
    slurp                   = Read entire input stream into array
    compact_output          = Compact output
    raw_output              = Output raw strings, not JSON texts
    raw_output0             = Print NULL instead of newline
    join_output             = No newlines after each output
    ascii_output            = Force ASCII output
    sort_keys               = Sort object keys in output
    color_output            = Colorize output even to non-terminal
    monochrome_output       = Disable colored output
    tab                     = Use tabs for indentation
    indent                  = Use N spaces for indentation
    unbuffered              = Flush output after each result
    stream                  = Parse input in streaming fashion
    seq                     = Use application/json-seq MIME type scheme
    from_file               = Read program from file
    arg                     = Pass value to jq program as predefined variable
    argjson                 = Pass JSON value to jq program as predefined variable
    slurpfile               = Read JSON objects from file into variable as array
    rawfile                 = Read raw strings from file into variable as string
    args                    = Consume remaining arguments as positional string arguments
    jsonargs                = Consume remaining arguments as positional JSON arguments
    exit_status             = Set exit status based on output
    binary                  = Open input/output streams in binary mode (Windows)
    version                 = Output jq version
    build_configuration     = Show build configuration
    help                    = Show help message
    run_tests               = Runs the tests in the given file or standard input
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name jq -Description $msg.jq -Parameters @(
    New-ParamCompleter -ShortName n -LongName null-input -Description $msg.null_input
    New-ParamCompleter -ShortName R -LongName raw-input -Description $msg.raw_input
    New-ParamCompleter -ShortName s -LongName slurp -Description $msg.slurp
    New-ParamCompleter -ShortName c -LongName compact-output -Description $msg.compact_output
    New-ParamCompleter -ShortName r -LongName raw-output -Description $msg.raw_output
    New-ParamCompleter -LongName raw-output0 -Description $msg.raw_output0
    New-ParamCompleter -ShortName j -LongName join-output -Description $msg.join_output
    New-ParamCompleter -ShortName a -LongName ascii-output -Description $msg.ascii_output
    New-ParamCompleter -ShortName S -LongName sort-keys -Description $msg.sort_keys
    New-ParamCompleter -ShortName C -LongName color-output -Description $msg.color_output
    New-ParamCompleter -ShortName M -LongName monochrome-output -Description $msg.monochrome_output
    New-ParamCompleter -LongName tab -Description $msg.tab
    New-ParamCompleter -LongName indent -Description $msg.indent -Type Required -VariableName 'N'
    New-ParamCompleter -LongName unbuffered -Description $msg.unbuffered
    New-ParamCompleter -LongName stream -Description $msg.stream
    New-ParamCompleter -LongName seq -Description $msg.seq
    New-ParamCompleter -ShortName f -LongName from-file -Description $msg.from_file -Type File -VariableName 'file'
    New-ParamCompleter -LongName arg -Description $msg.arg -Type Required -VariableName 'name value'
    New-ParamCompleter -LongName argjson -Description $msg.argjson -Type Required -VariableName 'name JSON'
    New-ParamCompleter -LongName slurpfile -Description $msg.slurpfile -Type File -VariableName 'name file'
    New-ParamCompleter -LongName rawfile -Description $msg.rawfile -Type File -VariableName 'name file'
    New-ParamCompleter -LongName args -Description $msg.args
    New-ParamCompleter -LongName jsonargs -Description $msg.jsonargs
    New-ParamCompleter -ShortName e -LongName exit-status -Description $msg.exit_status
    New-ParamCompleter -LongName binary -Description $msg.binary
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
    New-ParamCompleter -LongName build-configuration -Description $msg.build_configuration
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -LongName run-tests -Description $msg.run_tests
) -ArgumentCompleter {
    param([int] $position, [int] $argIndex)
    if ($argIndex -eq 0 -and -not $this.BoundParameters.ContainsKey('from-file'))
    {
        if ([string]::IsNullOrEmpty($_))
        {
            "filter`tJQ filter expression"
        }
        else
        {
            $null
        }
    }
}
