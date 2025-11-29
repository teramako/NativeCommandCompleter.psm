<#
 # lsblk completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    lsblk              = list block devices
    noempty            = Don’t print empty devices
    all                = Print all devices
    bytes              = Print sizes in bytes
    nodeps             = Don't print slaves or holders
    discard            = Print discard capabilities
    help               = Display help and exit
    output             = Define output columns
    output_all         = Use all available columns
    paths              = Print complete device paths
    pairs              = Produce output in key="value" format
    raw                = Use raw output format
    inverse            = Print dependencies in inverse order
    fs                 = Output filesystem information
    ascii              = Use ASCII characters for tree formatting
    include            = Include specified devices
    exclude            = Exclude specified devices
    scsi               = Output SCSI device information
    json               = Use JSON output format
    list               = Produce output in list format
    tree               = Use tree-like output format
    noheadings         = Don't print column headings
    sort               = Sort output by specified column
    sysroot            = Gather data for a Linux instance other than the instance from which the command is issued
    version            = Display version and exit
    topology           = Output topology information
    perms              = Output permission information
    dedup              = De-duplicate output by specified column
    merge              = Group parents of sub-trees to provide a more readable output
    zoned              = Print zone model
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name lsblk -Description $msg.lsblk -Parameters @(
    New-ParamCompleter -ShortName A -LongName noempty -Description $msg.noempty
    New-ParamCompleter -ShortName a -LongName all -Description $msg.all
    New-ParamCompleter -ShortName b -LongName bytes -Description $msg.bytes
    New-ParamCompleter -ShortName d -LongName nodeps -Description $msg.nodeps
    New-ParamCompleter -ShortName D -LongName discard -Description $msg.discard
    New-ParamCompleter -ShortName h -LongName help -Description $msg.help
    New-ParamCompleter -ShortName o -LongName output -Description $msg.output -Type Required -VariableName 'list'
    New-ParamCompleter -ShortName O -LongName output-all -Description $msg.output_all
    New-ParamCompleter -ShortName p -LongName paths -Description $msg.paths
    New-ParamCompleter -ShortName P -LongName pairs -Description $msg.pairs
    New-ParamCompleter -ShortName r -LongName raw -Description $msg.raw
    New-ParamCompleter -ShortName s -LongName inverse -Description $msg.inverse
    New-ParamCompleter -ShortName f -LongName fs -Description $msg.fs
    New-ParamCompleter -ShortName i -LongName ascii -Description $msg.ascii
    New-ParamCompleter -ShortName I -LongName include -Description $msg.include -Type Required -VariableName 'list'
    New-ParamCompleter -ShortName e -LongName exclude -Description $msg.exclude -Type Required -VariableName 'list'
    New-ParamCompleter -ShortName S -LongName scsi -Description $msg.scsi
    New-ParamCompleter -ShortName J -LongName json -Description $msg.json
    New-ParamCompleter -ShortName l -LongName list -Description $msg.list
    New-ParamCompleter -ShortName T -LongName tree -Description $msg.tree
    New-ParamCompleter -ShortName n -LongName noheadings -Description $msg.noheadings
    New-ParamCompleter -ShortName x -LongName sort -Description $msg.sort -Type Required -VariableName 'column'
    New-ParamCompleter -LongName sysroot -Description $msg.sysroot -Type Directory -VariableName 'directory'
    New-ParamCompleter -ShortName V -LongName version -Description $msg.version
    New-ParamCompleter -ShortName t -LongName topology -Description $msg.topology
    New-ParamCompleter -ShortName m -LongName perms -Description $msg.perms
    New-ParamCompleter -LongName dedup -Description $msg.dedup -Type Required -VariableName 'column'
    New-ParamCompleter -ShortName M -LongName merge -Description $msg.merge
    New-ParamCompleter -ShortName z -LongName zoned -Description $msg.zoned
) -ArgumentCompleter {
    if ([System.IO.Path]::IsPathRooted($wordToComplete))
    {
        [MT.Comp.Helper]::CompleteFilename($this, $false, $false, {
            $_.Attributes.HasFlag([System.IO.FileAttributes]::Normal) -and
            $_.Name -match '^(sd[a-z]+|nvme[0-9]+n[0-9]+|vd[a-z]+|hd[a-z]+|mmcblk[0-9]+|loop[0-9]+)'
        })
    }
    else
    {
        [MT.Comp.Helper]::CompleteFilename('/dev/', $this.CurrentDirectory.Path, $false, $false, {
            $_.Attributes.HasFlag([System.IO.FileAttributes]::Normal) -and
            $_.Name -match '^(sd[a-z]+|nvme[0-9]+n[0-9]+|vd[a-z]+|hd[a-z]+|mmcblk[0-9]+|loop[0-9]+)' -and
            $_.Name -like "$wordToComplete*"
        })
    }
}
