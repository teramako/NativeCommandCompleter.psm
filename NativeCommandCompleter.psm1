<#
 #  Root Module
 #>

 if ([string]::IsNullOrEmpty($env:PS_COMPLETE_PATH))
 {
     $env:PS_COMPLETE_PATH = Join-Path $PSScriptRoot completions
 }

 Register-ArgumentCompleter -NativeFallback -ScriptBlock {
     param($wordToComplete, $commandAst, $cursorPosition)
     $currentDirectory = Get-Location -PSProvider FileSystem
     [MT.Comp.NativeCompleter]::Complete($wordToComplete, $commandAst, $cursorPosition, $Host, $currentDirectory)
 }

