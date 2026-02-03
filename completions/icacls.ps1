<#
 # icacls completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    icacls              = displays or modifies discretionary access control lists (DACLs) on specified files
    target              = Specifies the file or the directory for which to display or modify DACLs.
    grant               = grants specified user access rights
    remove              = removes all occurrences of specified user
    deny                = explicitly denies specified user access rights
    setintegritylevel   = adds an integrity ACE to all matching files
    findsid             = finds all matching files containing an ACE explicitly mentioning specified SID
    verify              = finds all files whose ACL is not in canonical form or whose lengths are inconsistent
    reset               = replaces ACLs with default inherited ACLs for all matching files
    inheritance         = enables/disables inheritance
    setowner            = changes owner of all matching files
    save                = stores ACLs for all matching files into ACL file
    restore             = applies stored ACLs to files in directory
    substitute          = replaces all ACEs for SID1 with ACEs for SID2
    perm_N              = none
    perm_F              = full access
    perm_M              = modify access
    perm_RX             = read and execute access
    perm_R              = read-only access
    perm_W              = write-only access
    perm_D              = delete access
    inheritance_e       = enable inheritance
    inheritance_d       = disable inheritance
    inheritance_r       = remove all inherited ACEs
    level_L             = low integrity
    level_M             = medium integrity
    level_H             = high integrity
    recurse             = perform operation on all files in specified directories and all subdirectories
    continue            = continue on file errors
    quiet               = suppress success messages
    tree                = display results in tree format
    lowmem              = disable caching to minimize memory use
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$inheritanceArguments = @(
    "e`t{0}" -f $msg.inheritance_e
    "d`t{0}" -f $msg.inheritance_d
    "r`t{0}" -f $msg.inheritance_r
)

$integrityArguments = @(
    "L`t{0}" -f $msg.level_L
    "M`t{0}" -f $msg.level_M
    "H`t{0}" -f $msg.level_H
)

$sidCompleter = {
    param([int]$position, [int] $argIndex)
    if ($wordToComplete -match '^*') {
        $w = $wordToComplete.Substring(1);
        Get-LocalUser | Where-Object { $_.SID -like "$w*" } | ForEach-Object {
            $desc = if ([string]::IsNullOrEmpty($_.Description)) { $_.Name } else { "{0} - {1}" -f $_.Name, $_.Description }
            "*{0}`t{1}" -f $_.SID, $desc
        }
    } else {
        Get-LocalUser -Name "$wordToComplete*" | ForEach-Object {
            "{0}`t{1}" -f $_.Name, $_.Description
        }
    }
}
$winStyle2 = New-ParamStyle -ShortOptionPrefix '/' -ValueStyle Separated

Register-NativeCompleter -Name icacls -Description $msg.icacls -Style Windows -SubCommands @(
    New-CommandCompleter -Name '*' -Description $msg.target -Style Windows  -Parameters @(
        New-ParamCompleter -Name save -Description $msg.save -Style $winStyle2 -Type File -VariableName 'ACLFILE'
        New-ParamCompleter -Name grant -Description $msg.grant -Style $winStyle2 -Type Required -VariableName 'USER:PERM'
        New-ParamCompleter -Name remove -Description $msg.remove -Style $winStyle2 -Type Required -VariableName 'USER'
        New-ParamCompleter -Name deny -Description $msg.deny -Style $winStyle2 -Type Required -VariableName 'USER:PERM'
        New-ParamCompleter -Name setintegritylevel -Description $msg.setintegritylevel -Style $winStyle2 -Type Required -Arguments $integrityArguments -VariableName 'LEVEL'
        New-ParamCompleter -Name findsid -Description $msg.findsid -Style $winStyle2 -Type Required -VariableName 'SID' -ArgumentCompleter $sidCompleter
        New-ParamCompleter -Name verify -Description $msg.verify
        New-ParamCompleter -Name reset -Description $msg.reset
        New-ParamCompleter -Name inheritance -Description $msg.inheritance -Type Required -Arguments $inheritanceArguments -VariableName 'e|d|r'
        New-ParamCompleter -Name setowner -Description $msg.setowner -Style $winStyle2 -Type Required -VariableName 'USER'
        New-ParamCompleter -Name restore -Description $msg.restore -Style $winStyle2 -Type File -VariableName 'ACLFILE'
        New-ParamCompleter -Name substitute -Description $msg.substitute -Style $winStyle2 -Type Required -ArgumentsCount 2 -VariableName 'SID1 SID2' -ArgumentCompleter $sidCompleter
        New-ParamCompleter -Name T -Description $msg.recurse
        New-ParamCompleter -Name C -Description $msg.continue
        New-ParamCompleter -Name L -Description $msg.tree
        New-ParamCompleter -Name Q -Description $msg.quiet
    )
)
