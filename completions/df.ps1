<#
 # df completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    df                  = report file system disk space usage
    gnu_all             = Include pseudo, duplicate, inaccessible file systems
    gnu_blockSize       = Scale sizes by SIZE before printing
    gnu_humanReadable   = Print sizes in human readable format
    gnu_si              = Like -h, but use powers of 1000 not 1024
    gnu_inodes          = List inode information instead of block usage
    gnu_kibibytes       = Like --block-size=1K
    gnu_local           = Limit listing to local file systems
    gnu_noSync          = Do not invoke sync before getting usage info (default)
    gnu_output          = Use output format defined by FIELD(s)
    gnu_portability     = Use POSIX output format
    gnu_sync            = Invoke sync before getting usage info
    gnu_total           = Produce a grand total
    gnu_type            = Limit listing to file systems of type TYPE
    gnu_printType       = Print file system type
    gnu_excludeType     = Limit listing to file systems not of type TYPE
    gnu_help            = Display help and exit
    gnu_version         = Display version and exit
    bsd_blockSize       = Use SIZE-byte blocks
    bsd_humanReadable   = Use unit suffixes
    bsd_si              = Like -h, but use powers of 1000
    bsd_inodes          = Show inode usage instead of block usage
    bsd_kibibytes       = Use 1024-byte blocks
    bsd_local           = Show only local file systems
    bsd_printType       = Print file system type
    bsd_commaSeparated  = Print sizes grouped and separated by thousands
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

# check whether GNU df
df --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) # GNU df
{
    $fieldList = "source","fstype","itotal","iused","iavail","ipcent","size","used","avail","pcent","file","target" 
    $typeCompleter = {
        df --output=fstype | Sort-Object -Unique | Where-Object { $_ -like "$wordToComplete*" }
    }

    Register-NativeCompleter -Name df -Description $msg.df -Parameters @(
        New-ParamCompleter -ShortName a -LongName all -Description $msg.gnu_all
        New-ParamCompleter -ShortName B -LongName block-size -Description $msg.gnu_blockSize -Type Required -VariableName 'SIZE'
        New-ParamCompleter -ShortName h -LongName human-readable -Description $msg.gnu_humanReadable
        New-ParamCompleter -ShortName H -LongName si -Description $msg.gnu_si
        New-ParamCompleter -ShortName i -LongName inodes -Description $msg.gnu_inodes
        New-ParamCompleter -ShortName k -Description $msg.gnu_kibibytes
        New-ParamCompleter -ShortName l -LongName local -Description $msg.gnu_local
        New-ParamCompleter -LongName no-sync -Description $msg.gnu_noSync
        New-ParamCompleter -LongName output -Description $msg.gnu_output -Type FlagOrValue,List -Arguments $fieldList -VariableName 'FIELD'
        New-ParamCompleter -ShortName P -LongName portability -Description $msg.gnu_portability
        New-ParamCompleter -LongName sync -Description $msg.gnu_sync
        New-ParamCompleter -LongName total -Description $msg.gnu_total
        New-ParamCompleter -ShortName t -LongName type -Description $msg.gnu_type -VariableName 'TYPE' -ArgumentCompleter $typeCompleter
        New-ParamCompleter -ShortName T -LongName print-type -Description $msg.gnu_printType
        New-ParamCompleter -ShortName x -LongName exclude-type -Description $msg.gnu_excludeType -VariableName 'TYPE' -ArgumentCompleter $typeCompleter
        New-ParamCompleter -LongName help -Description $msg.gnu_help
        New-ParamCompleter -LongName version -Description $msg.gnu_version
    )
}
else # BSD df
{
    Register-NativeCompleter -Name df -Description $msg.df -Parameters @(
        New-ParamCompleter -ShortName b -Description $msg.bsd_blockSize -Type Required -VariableName 'SIZE'
        New-ParamCompleter -ShortName g -Description $msg.bsd_humanReadable
        New-ParamCompleter -ShortName H -Description $msg.bsd_si
        New-ParamCompleter -ShortName i -Description $msg.bsd_inodes
        New-ParamCompleter -ShortName k -Description $msg.bsd_kibibytes
        New-ParamCompleter -ShortName l -Description $msg.bsd_local
        New-ParamCompleter -ShortName T -Description $msg.bsd_printType
        New-ParamCompleter -ShortName ',' -Description $msg.bsd_commaSeparated
    )
}
