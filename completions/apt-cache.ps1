<#
 # apt-cache completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    apt_cache        = query the APT cache
    gencaches        = Build the source and package caches
    showpkg          = Show some general information for a single package
    showsrc          = Display source records
    stats            = Show some basic statistics
    dump             = Show the entire file in a terse form
    dumpavail        = Print an available list to stdout
    unmet            = Show unmet dependencies
    search           = Search the package list for a regex pattern
    show             = Show a readable record for the package
    depends          = Show raw dependency information for a package
    rdepends         = Show reverse dependency information for a package
    pkgnames         = List the names of all packages in the system
    dotty            = Generate package graphs for GraphViz
    xvcg             = Generate package graphs for xvcg
    policy           = Show policy settings
    madison          = Display available versions of a package
    help             = Display help and exit
    version          = Display version and exit
    pkg_cache        = Select the file to store the package cache
    src_cache        = Select the file to store the source cache
    quiet            = Quiet; produces output suitable for logging
    important        = Print only important dependencies
    no_pre_depends   = Do not print pre-depends
    no_depends       = Do not print depends
    no_recommends    = Do not print recommends
    no_suggests      = Do not print suggests
    no_conflicts     = Do not print conflicts
    no_breaks        = Do not print breaks
    no_replaces      = Do not print replaces
    no_enhances      = Do not print enhances
    implicit         = Print implicit dependencies
    full             = Print full records when searching
    all_versions     = Print full records for all available versions
    names_only       = Only search on the package names
    all_names        = Make pkgnames print all names
    recurse          = Make depends and rdepends recursive
    installed        = Limit the output of depends and rdepends to packages currently installed
    config_file      = Configuration File
    option           = Set a Configuration Option
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

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

Register-NativeCompleter -Name apt-cache -Description $msg.apt_cache -SubCommands @(
    New-CommandCompleter -Name gencaches -Description $msg.gencaches -NoFileCompletions
    New-CommandCompleter -Name showpkg -Description $msg.showpkg -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name showsrc -Description $msg.showsrc -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name stats -Description $msg.stats -NoFileCompletions
    New-CommandCompleter -Name dump -Description $msg.dump -NoFileCompletions
    New-CommandCompleter -Name dumpavail -Description $msg.dumpavail -NoFileCompletions
    New-CommandCompleter -Name unmet -Description $msg.unmet -NoFileCompletions
    New-CommandCompleter -Name search -Description $msg.search -NoFileCompletions
    New-CommandCompleter -Name show -Description $msg.show -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name depends -Description $msg.depends -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name rdepends -Description $msg.rdepends -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name pkgnames -Description $msg.pkgnames -NoFileCompletions
    New-CommandCompleter -Name dotty -Description $msg.dotty -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name xvcg -Description $msg.xvcg -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name policy -Description $msg.policy -NoFileCompletions -ArgumentCompleter $packageCompleter
    New-CommandCompleter -Name madison -Description $msg.madison -NoFileCompletions -ArgumentCompleter $packageCompleter
) -Parameters @(
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName v -LongName version -Description $msg.version
    New-ParamCompleter -ShortName p -LongName pkg-cache -Description $msg.pkg_cache -Type File -VariableName 'FILE'
    New-ParamCompleter -ShortName s -LongName src-cache -Description $msg.src_cache -Type File -VariableName 'FILE'
    New-ParamCompleter -ShortName q -LongName quiet -Description $msg.quiet
    New-ParamCompleter -ShortName i -LongName important -Description $msg.important
    New-ParamCompleter -LongName no-pre-depends -Description $msg.no_pre_depends
    New-ParamCompleter -LongName no-depends -Description $msg.no_depends
    New-ParamCompleter -LongName no-recommends -Description $msg.no_recommends
    New-ParamCompleter -LongName no-suggests -Description $msg.no_suggests
    New-ParamCompleter -LongName no-conflicts -Description $msg.no_conflicts
    New-ParamCompleter -LongName no-breaks -Description $msg.no_breaks
    New-ParamCompleter -LongName no-replaces -Description $msg.no_replaces
    New-ParamCompleter -LongName no-enhances -Description $msg.no_enhances
    New-ParamCompleter -LongName implicit -Description $msg.implicit
    New-ParamCompleter -ShortName f -LongName full -Description $msg.full
    New-ParamCompleter -ShortName a -LongName all-versions -Description $msg.all_versions
    New-ParamCompleter -ShortName n -LongName names-only -Description $msg.names_only
    New-ParamCompleter -LongName all-names -Description $msg.all_names
    New-ParamCompleter -LongName recurse -Description $msg.recurse
    New-ParamCompleter -LongName installed -Description $msg.installed
    New-ParamCompleter -ShortName c -LongName config-file -Description $msg.config_file -Type File -VariableName 'FILE'
    New-ParamCompleter -ShortName o -LongName option -Description $msg.option -Type Required -VariableName 'OPT=VAL'
) -NoFileCompletions
