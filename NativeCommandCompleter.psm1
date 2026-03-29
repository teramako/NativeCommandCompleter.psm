<#
.SYNOPSIS
    Root module of NativeCommandCompleter.psm
.DESCRIPTION
    1. Setup `PS_COMPLETE_PATH` environment variable, if not defined
    2. Register completer as `NativeFallback`
#>

if ([string]::IsNullOrEmpty($env:PS_COMPLETE_PATH))
{
    # Set default environment variable: PS_COMPLETE_PATH
    #      1. <Profile Directory>/completions
    #      2. <Module Directory>/completions (if exists)
    $dirs = [string[]](Join-Path -Path ([System.IO.Path]::GetDirectoryName($PROFILE)) -ChildPath completions)
    $moduleCompletionsDir = Join-Path -Path $PSScriptRoot -ChildPath completions
    if (Test-Path -LiteralPath $moduleCompletionsDir) {
        $dirs += $moduleCompletionsDir
    }
    $env:PS_COMPLETE_PATH = $dirs -join [System.IO.Path]::PathSeparator;
}

Register-ArgumentCompleter -NativeFallback -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $currentDirectory = Get-Location -PSProvider FileSystem
    [MT.Comp.NativeCompleter]::Complete($wordToComplete, $commandAst, $cursorPosition, $Host, $currentDirectory)
}

