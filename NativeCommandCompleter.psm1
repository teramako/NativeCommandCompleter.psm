<#
 #  Root Module
 #>

 if ([string]::IsNullOrEmpty($env:PS_COMPLETE_PATH))
 {
     $env:PS_COMPLETE_PATH = Join-Path $PSScriptRoot completions
 }

 Register-ArgumentCompleter -NativeFallback -ScriptBlock {
     param($wordToComplete, $commandAst, $cursorPosition)
     [MT.Comp.NativeCompleter]::Complete($wordToComplete, $commandAst, $cursorPosition)
 }

