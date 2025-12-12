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
    New-ParamCompleter -OldStyleName daystart -Description $msg.daystart
    New-ParamCompleter -OldStyleName depth -Description $msg.depth
    New-ParamCompleter -OldStyleName follow -Description $msg.follow
    New-ParamCompleter -OldStyleName help -LongName help -Description $msg.help
    New-ParamCompleter -OldStyleName ignore_readdir_race -Description $msg.ignore_readdir_race
    New-ParamCompleter -OldStyleName maxdepth -Description $msg.maxdepth -Type Required -VariableName 'LEVELS'
    New-ParamCompleter -OldStyleName mindepth -Description $msg.mindepth -Type Required -VariableName 'LEVELS'
    New-ParamCompleter -OldStyleName mount -Description $msg.mount
    New-ParamCompleter -OldStyleName noleaf -Description $msg.noleaf
    New-ParamCompleter -OldStyleName version -LongName version -Description $msg.version
    New-ParamCompleter -OldStyleName xdev -Description $msg.xdev

    # Tests
    New-ParamCompleter -OldStyleName amin -Description $msg.amin -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName anewer -Description $msg.anewer -Type File -VariableName 'FILE'
    New-ParamCompleter -OldStyleName atime -Description $msg.atime -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName cmin -Description $msg.cmin -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName cnewer -Description $msg.cnewer -Type File -VariableName 'FILE'
    New-ParamCompleter -OldStyleName ctime -Description $msg.ctime -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName empty -Description $msg.empty
    New-ParamCompleter -OldStyleName executable -Description $msg.executable
    New-ParamCompleter -OldStyleName false -Description $msg.false
    New-ParamCompleter -OldStyleName fstype -Description $msg.fstype -Type Required -VariableName 'TYPE'
    New-ParamCompleter -OldStyleName gid -Description $msg.gid -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName group -Description $msg.group -Type Required -VariableName 'GNAME'
    New-ParamCompleter -OldStyleName ilname -Description $msg.ilname -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName iname -Description $msg.iname -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName inum -Description $msg.inum -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName ipath -Description $msg.ipath -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName iregex -Description $msg.iregex -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName iwholename -Description $msg.iwholename -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName links -Description $msg.links -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName lname -Description $msg.lname -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName mmin -Description $msg.mmin -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName mtime -Description $msg.mtime -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName name -Description $msg.name -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName newer -Description $msg.newer -Type File -VariableName 'FILE'
    New-ParamCompleter -OldStyleName newerXY -Description $msg.newerXY -Type Required -VariableName 'REFERENCE'
    New-ParamCompleter -OldStyleName nogroup -Description $msg.nogroup
    New-ParamCompleter -OldStyleName nouser -Description $msg.nouser
    New-ParamCompleter -OldStyleName path -Description $msg.path -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName perm -Description $msg.perm -Type Required -VariableName 'MODE'
    New-ParamCompleter -OldStyleName readable -Description $msg.readable
    New-ParamCompleter -OldStyleName regex -Description $msg.regex -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName regextype -Description $msg.regextype -Type Required -Arguments "emacs","posix-awk","posix-basic","posix-egrep","posix-extended" -VariableName 'TYPE'
    New-ParamCompleter -OldStyleName samefile -Description $msg.samefile -Type File -VariableName 'NAME'
    New-ParamCompleter -OldStyleName size -Description $msg.size -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName true -Description $msg.true
    New-ParamCompleter -OldStyleName type -Description $msg.type -Type Required -Arguments $typeArguments -VariableName 'C'
    New-ParamCompleter -OldStyleName uid -Description $msg.uid -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName used -Description $msg.used -Type Required -VariableName 'N'
    New-ParamCompleter -OldStyleName user -Description $msg.user -Type Required -VariableName 'UNAME'
    New-ParamCompleter -OldStyleName wholename -Description $msg.wholename -Type Required -VariableName 'PATTERN'
    New-ParamCompleter -OldStyleName writable -Description $msg.writable
    New-ParamCompleter -OldStyleName xtype -Description $msg.xtype -Type Required -Arguments $typeArguments -VariableName 'C'
    New-ParamCompleter -OldStyleName context -Description $msg.context -Type Required -VariableName 'PATTERN'

    # Actions
    New-ParamCompleter -OldStyleName delete -Description $msg.delete
    New-ParamCompleter -OldStyleName exec -Description $msg.exec -Type Required -VariableName 'COMMAND ;'
    New-ParamCompleter -OldStyleName execdir -Description $msg.execdir -Type Required -VariableName 'COMMAND ;'
    New-ParamCompleter -OldStyleName fls -Description $msg.fls -Type File -VariableName 'FILE'
    New-ParamCompleter -OldStyleName fprint -Description $msg.fprint -Type File -VariableName 'FILE'
    New-ParamCompleter -OldStyleName fprint0 -Description $msg.fprint0 -Type File -VariableName 'FILE'
    New-ParamCompleter -OldStyleName fprintf -Description $msg.fprintf -Type Required -VariableName 'FILE FORMAT'
    New-ParamCompleter -OldStyleName ls -Description $msg.ls
    New-ParamCompleter -OldStyleName ok -Description $msg.ok -Type Required -VariableName 'COMMAND ;'
    New-ParamCompleter -OldStyleName okdir -Description $msg.okdir -Type Required -VariableName 'COMMAND ;'
    New-ParamCompleter -OldStyleName print -Description $msg.print
    New-ParamCompleter -OldStyleName print0 -Description $msg.print0
    New-ParamCompleter -OldStyleName printf -Description $msg.printf -Type Required -VariableName 'FORMAT'
    New-ParamCompleter -OldStyleName prune -Description $msg.prune
    New-ParamCompleter -OldStyleName quit -Description $msg.quit
)
