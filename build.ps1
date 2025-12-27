<#
.SYNOPSIS
Build PowerShell Module Package

.PARAMETER CreateZip
Create Zip archived the PowerShell module files

.PARAMETER Publish
Upload the PowerShell module to PowerShell Gallery (https://www.powershellgallery.com/)

#>
[CmdletBinding()]
param(
    [Parameter(ParameterSetName = "Zip", Mandatory)]
    [switch] $CreateZip
    ,
    [Parameter(ParameterSetName = "Publish", Mandatory)]
    [switch] $Publish
    ,
    [Parameter()]
    [switch] $IncludeCompletions
)
$ErrorActionPreference = 'Stop'

$psmDir = "$PSScriptRoot"

$commonParam = if ($PSCmdlet.MyInvocation.BoundParameters['Verbose'])
{
    @{ Verbose = $true }
} else {
    @{ Verbose = $false }
}

$psdFile = Join-Path -Path $psmDir -ChildPath NativeCommandCompleter.psm.psd1
$ModuleManifest = Test-ModuleManifest -Path $psdFile
$tmpDir = Join-Path -Path $PSScriptRoot -ChildPath out, $ModuleManifest.Name
$compltionsDir = Join-Path -Path $PSScriptRoot -ChildPath completions

function CreateDest
{
    param(
        [Parameter()]
        [string[]] $HelpFile = @()
        ,
        [Parameter()]
        [string[]] $AddtionalDirectory = @()
    )
    if (Test-Path -Path $tmpDir -PathType Container)
    {
        Remove-Item -Recurse $tmpDir @commonParam
    }
    $null = New-Item -Path $tmpDir -ItemType Directory
    $ModuleManifest.FileList + $HelpFile | ForEach-Object {
        $filePath = Resolve-Path -Path $_ -Relative -RelativeBasePath $psmDir
        $destFile = [System.IO.FileInfo]::new((Join-Path -Path $tmpDir -ChildPath $filePath));
        $destDir = $destFile.Directory
        if (-not $destDir.Exists)
        {
            $null = New-Item -ItemType Directory -Path $destDir @commonParam
        }
        Copy-Item -Path $filePath -Destination $destDir @commonParam
    }
    if ($AddtionalDirectory.Count -gt 0)
    {
        $AddtionalDirectory | ForEach-Object {
            Copy-Item -Destination $destDir -LiteralPath $_ -Recurse @commonParam
        }
    }
    return $tmpDir
}

function BuildMamlHelp
{
    [OutputType([System.IO.FileInfo])]
    param()

    $docsDir = Join-Path -Path $psmDir -ChildPath docs
    if (-not (Test-Path -Path $docsDir))
    {
        return
    }
    $cmdHelpFiles = Get-ChildItem -Recurse -Path $docsDir -Include "*-*.md"
    if ($cmdHelpFiles.Count -eq 0)
    {
        return
    }
    $cmdHelpFiles |
        Import-MarkdownCommandHelp |
        Group-Object { $_.Metadata['Locale'] } |
        ForEach-Object {
            $name = $_.Name;
            $modules = $_.Group.ModuleName | Sort-Object -Unique
            $dir = switch ($name) {
                'en-US' { $psmDir }
                default { Join-Path -Path $psmDir -ChildPath $name }
            }
            $_.Group | Export-MamlCommandHelp -OutputFolder $dir @commonParam | ForEach-Object {
                Move-Item -Path $_ -Destination $dir -Force @commonParam -PassThru
            }
            $modules | ForEach-Object {
                $moduleDir = Join-Path -Path $dir -ChildPath $_
                if (Test-Path -Path $moduleDir)
                {
                    Remove-Item -Recurse -Path $moduleDir @commonParam
                }
            }
        }
}

if ($CreateZip)
{
    $helpFiles = BuildMamlHelp
    $additionalDir = if ($IncludeCompletions) { $compltionsDir } else { @() }
    $dir = CreateDest -HelpFile $helpFiles -AddtionalDirectory $additionalDir
    $zipFileName = "{0}-{1}.zip" -f $ModuleManifest.Name, $ModuleManifest.Version.ToString()
    $zipFile = Join-Path -Path $PSScriptRoot -ChildPath out, $zipFileName
    Compress-Archive -Path $dir -DestinationPath $zipFile -PassThru -Force @commonParam
}

if ($Publish)
{
    $userName = if ($IsWindows) { $env:USERNAME } else { $env:USER }
    $nugetCredential = Get-Credential -Title "Nuget ApiKey" -UserName $userName

    $helpFiles = BuildMamlHelp
    $additionalDir = if ($IncludeCompletions) { $compltionsDir } else { @() }
    $dir = CreateDest -HelpFile $helpFiles -AddtionalDirectory $additionalDir

    Publish-Module `
        -Path $dir `
        -NuGetApiKey ($nugetCredential.Password | ConvertFrom-SecureString -AsPlainText) `
        @commonParam
}

