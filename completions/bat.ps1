<#
 # bat completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$cmdName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$msg = data { ConvertFrom-StringData @'
    bat                    = a cat(1) clone with syntax highlighting and Git integration.
    language               = Set the language for syntax highlighting.
    highlight_line         = Highlight lines N through M.
    file_name              = Specify the name to display for a file.
    diff_context           = Include N lines of context when using '--diff'
    tabs                   = Set the tab width to T spaces
    wrap                   = Specify the text-wrapping mode
    chop_long_lines        = Truncate all lines longer than screen width. Alias for '--wrap=never'
    terminal_width         = Explicitly set the width of the terminal
    color                  = When to use colors
    italic_text            = Use italics in output
    decorations            = When to show the decorations
    force_colorization     = Alias for --decorations=always --color=always
    paging                 = Specify when to use the pager
    pager                  = Determine which pager to use
    map_syntax             = Use the specified syntax for files matching the glob pattern ('*.cpp:C++').
    theme                  = Set the color theme for syntax highlighting.
    theme_dark             = Set the color theme for syntax highlighting for dark backgrounds.
    theme_light            = Set the color theme for syntax highlighting for light backgrounds.
    style                  = Comma-separated list of style elements to display
    line_range             = Only print the lines from N to M.
    show_all               = Show non-printable characters (space, tab, newline, ..).
    nonprintable_notation  = Set notation for non-printable characters.
    binary                 = How to treat binary content.
    ignore_suffix          = Ignore extension.
    squeeze_blank          = Squeeze consecutive empty lines into a single empty line.
    squeeze_limit          = Set the maximum number of consecutive empty lines to be printed.
    strip_ansi             = Specify when to strip ANSI escape sequences from the input.
    plain                  = Show plain style (alias for '--style=plain').
    diff                   = Only show lines that have been added/removed/modified.
    number                 = Show line numbers (alias for '--style=numbers').
    no_paging              = Alias for '--paging=never'
    list_themes            = Display all supported highlighting themes.
    list_languages         = Display all supported languages.
    completion             = Show shell completion for a certain shell.
    no_config              = Do not use the configuration file
    no_custom_assets       = Do not load custom assets
    lessopen               = Enable the $LESSOPEN preprocessor
    no_lessopen            = Disable the $LESSOPEN preprocessor
    config_file            = Show path to the configuration file.
    generate_config_file   = Generates a default configuration file.
    config_dir             = Show bat's configuration directory.
    cache_dir              = Show bat's cache directory.
    acknowledgements       = Show acknowledgements.
    set_terminal_title     = Sets terminal title to filenames when using a pager.
    diagnostic             = Show diagnostic information for bug reports.
    help                   = Print this help message.
    version                = Show version information.

    cache                  = Modify the syntax-definition and theme cache.
    cache_source           = Use a different directory to load syntaxes and themes from.
    cache_target           = Use a different directory to store the cached syntax and theme set.
    cache_build            = Initialize (or update) the syntax/theme cache.
    cache_clear            = Remove the cached syntax definitions and themes.
    cache_blank            = Create completely new syntax and theme sets (instead of appending to the default sets).
    cache_help             = Prints help information
    cache_acknowledgements = Build acknowledgements.bin. 
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$themeCompleter = {
    bat --list-themes | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { "'{0}'" -f $_ }
}
$languageCompleter = {
    bat --list-languages | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { "'{0}'`t{1}" -f ($_ -split ':') }
}

$whenArguments = "auto", "never", "always"
$stylesArguments = "default", "auto", "full", "plain", "changes", "header", "header-filename", "header-filesize", "grid", "rule", "numbers", "snip"

Register-NativeCompleter -Name $cmdName -Description $msg.bat -Parameters @(
    New-ParamCompleter -ShortName A -LongName show-all -Description $msg.show_all
    New-ParamCompleter              -LongName nonprintable-notation -Description $msg.nonprintable_notation -VariableName 'notation' -Arguments "caret", "unicode"
    New-ParamCompleter              -LongName binary                -Description $msg.binary -VariableName 'behavior' -Arguments "no-printing", "as-text"
    New-ParamCompleter              -LongName completion            -Description $msg.completion -VariableName 'SHELL' -Arguments "bash", "fish", "zsh", "ps1"
    New-ParamCompleter -ShortName p -LongName plain                 -Description $msg.plain
    New-ParamCompleter -ShortName l -LongName language              -Description $msg.language -VariableName 'language' -ArgumentCompleter $languageCompleter
    New-ParamCompleter -ShortName H -LongName highlight-line        -Description $msg.highlight_line -Type Required -VariableName 'N:M'
    New-ParamCompleter              -LongName file-name             -Description $msg.file_name -Type File -VariableName 'name'
    New-ParamCompleter -ShortName d -LongName diff                  -Description $msg.diff
    New-ParamCompleter              -LongName diff-context          -Description $msg.diff_context -Type Required -VariableName 'N'
    New-ParamCompleter              -LongName tabs                  -Description $msg.tabs -Type Required -VariableName 'T'
    New-ParamCompleter              -LongName wrap                  -Description $msg.wrap -VariableName 'mode' -Arguments "auto", "never", "character"
    New-ParamCompleter -ShortName S -LongName chop-long-lines       -Description $msg.chop_long_lines
    New-ParamCompleter              -LongName terminal-width        -Description $msg.terminal_width -Type Required -VariableName 'width'
    New-ParamCompleter -ShortName n -LongName number                -Description $msg.number
    New-ParamCompleter              -LongName color                 -Description $msg.color -VariableName 'when' -Arguments $whenArguments
    New-ParamCompleter              -LongName italic-text           -Description $msg.italic_text -VariableName 'when' -Arguments 'always', 'never'
    New-ParamCompleter              -LongName decorations           -Description $msg.decorations -VariableName 'when' -Arguments $whenArguments
    New-ParamCompleter -ShortName f -LongName force-colorization    -Description $msg.force_colorization
    New-ParamCompleter              -LongName paging                -Description $msg.paging -VariableName 'when' -Arguments $whenArguments
    New-ParamCompleter -ShortName P -LongName no-paging             -Description $msg.no_paging
    New-ParamCompleter              -LongName pager                 -Description $msg.pager -VariableName 'command'
    New-ParamCompleter -ShortName m -LongName map-syntax            -Description $msg.map_syntax -Type Required -VariableName 'glob-pattern:syntax-name'
    New-ParamCompleter              -LongName ignored-suffix        -Description $msg.ignore_suffix -Type Required -VariableName 'suffix'
    New-ParamCompleter              -LongName theme                 -Description $msg.theme -VariableName 'theme' -ArgumentCompleter $themeCompleter
    New-ParamCompleter              -LongName theme-dark            -Description $msg.theme_dark
    New-ParamCompleter              -LongName theme-light           -Description $msg.theme_light
    New-ParamCompleter              -LongName list-themes           -Description $msg.list_themes
    New-ParamCompleter -ShortName s -LongName squeeze-blank         -Description $msg.squeeze_blank
    New-ParamCompleter              -LongName squeeze-limit         -Description $msg.squeeze_limit -Type Required -VariableName 'limit'
    New-ParamCompleter              -LongName strip-ansi            -Description $msg.strip_ansi -VariableName 'when' -Arguments "auto", "always", "never"
    New-ParamCompleter              -LongName style                 -Description $msg.style -Type List -Arguments $stylesArguments
    New-ParamCompleter -ShortName r -LongName line-range            -Description $msg.line_range -Type Required -VariableName 'N:M'
    New-ParamCompleter -ShortName L -LongName list-languages        -Description $msg.list_languages
    New-ParamCompleter              -LongName no-custom-assets      -Description $msg.no_custom_assets
    New-ParamCompleter              -LongName config-dir            -Description $msg.config_dir
    New-ParamCompleter              -LongName cache-dir             -Description $msg.cache_dir
    New-ParamCompleter              -LongName diagnostic            -Description $msg.diagnostic
    New-ParamCompleter              -LongName acknowledgements      -Description $msg.acknowledgements
    New-ParamCompleter              -LongName set-terminal-title    -Description $msg.set_terminal_title
    New-ParamCompleter -ShortName h -LongName help                  -Description $msg.help
    New-ParamCompleter -ShortName V -LongName version               -Description $msg.version

    New-ParamCompleter              -LongName lessopen              -Description $msg.lessopen
    New-ParamCompleter              -LongName no-lessopen           -Description $msg.no_lessopen
    New-ParamCompleter              -LongName config-file           -Description $msg.config_file
    New-ParamCompleter              -LongName generate-config-file  -Description $msg.generate_config_file
    New-ParamCompleter              -LongName no-config             -Description $msg.no_config
) -SubCommands @(
    New-CommandCompleter -Name cache -Description $msg.cache -Parameters @(
        New-ParamCompleter              -LongName source           -Description $msg.cache_source -Type Directory -VariableName 'dir'
        New-ParamCompleter              -LongName target           -Description $msg.cache_target -Type Directory -VariableName 'dir'
        New-ParamCompleter -ShortName b -LongName build            -Description $msg.cache_build
        New-ParamCompleter -ShortName c -LongName clear            -Description $msg.cache_clear
        New-ParamCompleter              -LongName blank            -Description $msg.cache_blank
        New-ParamCompleter              -LongName acknowledgements -Description $msg.cache_acknowledgements
        New-ParamCompleter -ShortName h -LongName help             -Description $msg.help
    ) -NoFileCompletions
)
