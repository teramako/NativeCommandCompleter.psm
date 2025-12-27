<#
 # find completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

if ($IsWindows) {
    # TBD: Windows support
    return
}

$msg = data { ConvertFrom-StringData @'
    find                = search for files in a directory hierarchy
    daystart            = Measure times from the beginning of today
    depth               = Process each directory's contents before the directory itself
    follow              = Follow symbolic links
    help                = Display help and exit
    ignore_readdir_race = Don't emit an error message when find fails to stat a file
    maxdepth            = Descend at most levels
    mindepth            = Do not apply any tests or actions at levels less than levels
    mount               = Don't descend directories on other filesystems
    noleaf              = Do not optimize by assuming that directories contain 2 fewer subdirectories
    version             = Print the find version number
    xdev                = Don't descend directories on other filesystems
    amin                = File was last accessed n minutes ago
    anewer              = File was last accessed more recently than file was modified
    atime               = File was last accessed n*24 hours ago
    cmin                = File's status was last changed n minutes ago
    cnewer              = File's status was last changed more recently than file was modified
    ctime               = File's status was last changed n*24 hours ago
    empty               = File is empty and is either a regular file or a directory
    executable          = Matches files which are executable
    false               = Always false
    fstype              = File is on a filesystem of type
    gid                 = File's numeric group ID is n
    group               = File belongs to group
    ilname              = Like -lname but the match is case insensitive
    iname               = Like -name but the match is case insensitive
    inum                = File has inode number n
    ipath               = Like -path but the match is case insensitive
    iregex              = Like -regex but the match is case insensitive
    iwholename          = Like -wholename but the match is case insensitive
    links               = File has n links
    lname               = File is a symbolic link whose contents match shell pattern
    mmin                = File's data was last modified n minutes ago
    mtime               = File's data was last modified n*24 hours ago
    name                = Base of file name matches shell pattern
    newer               = File was modified more recently than file
    newerXY             = Compares the timestamp of the current file with reference
    nogroup             = No group corresponds to file's numeric group ID
    nouser              = No user corresponds to file's numeric user ID
    path                = File name matches shell pattern
    perm                = File's permission bits are exactly mode
    readable            = Matches files which are readable
    regex               = File name matches regular expression
    regextype           = Changes the regular expression syntax
    samefile            = File refers to the same inode as name
    size                = File uses n units of space
    true                = Always true
    type                = File is of type
    uid                 = File's numeric user ID is n
    used                = File was last accessed n days after its status was last changed
    user                = File is owned by user
    wholename           = File name matches shell pattern
    writable            = Matches files which are writable
    xtype               = Same as -type unless the file is a symbolic link
    context             = File's security context matches pattern
    delete              = Delete files
    exec                = Execute command
    execdir             = Like -exec but run the specified command from the subdirectory
    fls                 = True; like -ls but write to file like -fprint
    fprint              = True; print the full file name into file
    fprint0             = True; like -print0 but write to file like -fprint
    fprintf             = True; like -printf but write to file like -fprint
    ls                  = True; list current file in ls -dils format
    ok                  = Like -exec but ask the user first
    okdir               = Like -execdir but ask the user first
    print               = True; print the full file name on the standard output
    print0              = True; print the full file name on the standard output, followed by a null character
    printf              = True; print format on the standard output
    prune               = If the file is a directory, do not descend into it
    quit                = Exit immediately

    type_b             = block (buffered) special
    type_c             = character (unbuffered) special
    type_d             = directory
    type_p             = named pipe (FIFO)
    type_f             = regular file
    type_l             = symbolic link
    type_s             = socket
    type_Door          = door
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$typeArguments = @(
     "b `t{0}" -f $msg.type_b
     "c `t{0}" -f $msg.type_c
     "d `t{0}" -f $msg.type_d
     "p `t{0}" -f $msg.type_p
     "f `t{0}" -f $msg.type_f
     "l `t{0}" -f $msg.type_l
     "s `t{0}" -f $msg.type_s
     "D `t{0}" -f $msg.type_Door
)

Register-NativeCompleter -Name find -Description $msg.find -Style Unix -Parameters @(
    # Options
    New-ParamCompleter -ShortName P -Description "Never follow symbolic links"
    New-ParamCompleter -ShortName L -Description $msg.follow
    New-ParamCompleter -ShortName H -Description "Do not follow symbolic links, except while processing the command line arguments"
    New-ParamCompleter -ShortName D -Description "Print diagnostic information"
    New-ParamCompleter -ShortName O -Description "Enable query optimisation"

    # Global options
    New-ParamCompleter -Name daystart -Description $msg.daystart
    New-ParamCompleter -Name depth -Description $msg.depth
    New-ParamCompleter -Name follow -Description $msg.follow
    New-ParamCompleter -Name help -LongName help -Description $msg.help
    New-ParamCompleter -Name ignore_readdir_race -Description $msg.ignore_readdir_race
    New-ParamCompleter -Name maxdepth -Description $msg.maxdepth -Type Required -VariableName 'LEVELS'
    New-ParamCompleter -Name mindepth -Description $msg.mindepth -Type Required -VariableName 'LEVELS'
    New-ParamCompleter -Name mount -Description $msg.mount
    New-ParamCompleter -Name noleaf -Description $msg.noleaf
    New-ParamCompleter -Name version -LongName version -Description $msg.version
    New-ParamCompleter -Name xdev -Description $msg.xdev

    # Tests
    New-ParamCompleter -Name amin -Description $msg.amin -Type Required -VariableName 'N'
    New-ParamCompleter -Name anewer -Description $msg.anewer -Type File -VariableName 'FILE'
    New-ParamCompleter -Name atime -Description $msg.atime -Type Required -VariableName 'N'
    New-ParamCompleter -Name cmin -Description $msg.cmin -Type Required -VariableName 'N'
    New-ParamCompleter -Name cnewer -Description $msg.cnewer -Type File -VariableName 'FILE'
    New-ParamCompleter -Name ctime -Description $msg.ctime -Type Required -VariableName 'N'
    New-ParamCompleter -Name empty -Description $msg.empty
    New-ParamCompleter -Name executable -Description $msg.executable
    New-ParamCompleter -Name false -Description $msg.false
    New-ParamCompleter -Name fstype -Description $msg.fstype -Type Required -VariableName 'TYPE'
    New-ParamCompleter -Name gid -Description $msg.gid -Type Required -VariableName 'N'
    New-ParamCompleter -Name group -Description $msg.group -Type Required -VariableName 'GNAME'
    New-ParamCompleter -Name ilname -Description $msg.ilname -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name iname -Description $msg.iname -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name inum -Description $msg.inum -Type Required -VariableName 'N'
    New-ParamCompleter -Name ipath -Description $msg.ipath -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name iregex -Description $msg.iregex -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name iwholename -Description $msg.iwholename -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name links -Description $msg.links -Type Required -VariableName 'N'
    New-ParamCompleter -Name lname -Description $msg.lname -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name mmin -Description $msg.mmin -Type Required -VariableName 'N'
    New-ParamCompleter -Name mtime -Description $msg.mtime -Type Required -VariableName 'N'
    New-ParamCompleter -Name name -Description $msg.name -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name newer -Description $msg.newer -Type File -VariableName 'FILE'
    New-ParamCompleter -Name newerXY -Description $msg.newerXY -Type Required -VariableName 'REFERENCE'
    New-ParamCompleter -Name nogroup -Description $msg.nogroup
    New-ParamCompleter -Name nouser -Description $msg.nouser
    New-ParamCompleter -Name path -Description $msg.path -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name perm -Description $msg.perm -Type Required -VariableName 'MODE'
    New-ParamCompleter -Name readable -Description $msg.readable
    New-ParamCompleter -Name regex -Description $msg.regex -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name regextype -Description $msg.regextype -Type Required -Arguments "emacs","posix-awk","posix-basic","posix-egrep","posix-extended" -VariableName 'TYPE'
    New-ParamCompleter -Name samefile -Description $msg.samefile -Type File -VariableName 'NAME'
    New-ParamCompleter -Name size -Description $msg.size -Type Required -VariableName 'N'
    New-ParamCompleter -Name true -Description $msg.true
    New-ParamCompleter -Name type -Description $msg.type -Type Required -Arguments $typeArguments -VariableName 'C'
    New-ParamCompleter -Name uid -Description $msg.uid -Type Required -VariableName 'N'
    New-ParamCompleter -Name used -Description $msg.used -Type Required -VariableName 'N'
    New-ParamCompleter -Name user -Description $msg.user -Type Required -VariableName 'UNAME'
    New-ParamCompleter -Name wholename -Description $msg.wholename -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -Name writable -Description $msg.writable
    New-ParamCompleter -Name xtype -Description $msg.xtype -Type Required -Arguments $typeArguments -VariableName 'C'
    New-ParamCompleter -Name context -Description $msg.context -Type Required -VariableName 'PATTERN'

    # Actions
    New-ParamCompleter -Name delete -Description $msg.delete
    New-ParamCompleter -Name exec -Description $msg.exec -Type Required -VariableName 'COMMAND ;'
    New-ParamCompleter -Name execdir -Description $msg.execdir -Type Required -VariableName 'COMMAND ;'
    New-ParamCompleter -Name fls -Description $msg.fls -Type File -VariableName 'FILE'
    New-ParamCompleter -Name fprint -Description $msg.fprint -Type File -VariableName 'FILE'
    New-ParamCompleter -Name fprint0 -Description $msg.fprint0 -Type File -VariableName 'FILE'
    New-ParamCompleter -Name fprintf -Description $msg.fprintf -Type Required -VariableName 'FILE FORMAT'
    New-ParamCompleter -Name ls -Description $msg.ls
    New-ParamCompleter -Name ok -Description $msg.ok -Type Required -VariableName 'COMMAND ;'
    New-ParamCompleter -Name okdir -Description $msg.okdir -Type Required -VariableName 'COMMAND ;'
    New-ParamCompleter -Name print -Description $msg.print
    New-ParamCompleter -Name print0 -Description $msg.print0
    New-ParamCompleter -Name printf -Description $msg.printf -Type Required -VariableName 'FORMAT'
    New-ParamCompleter -Name prune -Description $msg.prune
    New-ParamCompleter -Name quit -Description $msg.quit
)
