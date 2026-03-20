<#
 #  Root Module
 #>

 if ([string]::IsNullOrEmpty($env:PS_COMPLETE_PATH))
 {
     # Set default environment variable: PS_COMPLETE_PATH
     #      1. <Profile Directory>/completions
     #      2. <Module Directory>/completions
     $dirs = (Join-Path -Path ([System.IO.Path]::GetDirectoryName($PROFILE)) -ChildPath completions),
             (Join-Path -Path $PSScriptRoot -ChildPath completions)
     $env:PS_COMPLETE_PATH = $dirs -join [System.IO.Path]::PathSeparator;
 }

 Register-ArgumentCompleter -NativeFallback -ScriptBlock {
     param($wordToComplete, $commandAst, $cursorPosition)
     $currentDirectory = Get-Location -PSProvider FileSystem
     [MT.Comp.NativeCompleter]::Complete($wordToComplete, $commandAst, $cursorPosition, $Host, $currentDirectory)
 }

