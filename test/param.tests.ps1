<#
.SYNOPSIS
completion tests for parameters
#>
BeforeAll {
    Register-NativeCompleter -Force -Name test-1 -Parameters @(
        New-ParamCompleter -ShortName a -LongName all
        New-ParamCompleter -ShortName v -LongName version
        New-ParamCompleter -Name name -Arguments {
            param([int] $position, [int] $argIndex) "{0}:{1}:{2}" -f $_, $position, $argIndex
        }
        New-ParamCompleter -Name list -Arguments @{
            Name = '1st'; Script = { param([int] $position, [int] $argIndex) "{0}_1st:{1}:{2}" -f $_, $position, $argIndex }
        }, @{
            Name = '2nd'; Script = { param([int] $position, [int] $argIndex) "{0}_2nd:{1}:{2}" -f $_, $position, $argIndex }
        }
        New-ParamCompleter -Name one-or-more -Arguments @{
            Name = 'values';
            Nargs = '1+';
            Script = { param([int] $position, [int] $argIndex) "{0}:{1}:{2}" -f $_, $position, $argIndex }
        }
        New-ParamCompleter -Name file -Arguments @{ name = "path"; type= 'File' }
    )
}

Describe 'parameters' {
    Context 'Single-Value Parameter (Nargs = 1)' {
        It 'Completes parameter name for single-value param (`test-1 -n`)' {
            $results = TabExpansion2 -inputScript "test-1 -n" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -BeGreaterThan 0
            $results[0].CompletionText | Should -Be "-name"
        }

        It 'Completes first argument for single-value param (`test-1 -name a`)' {
            $results = TabExpansion2 -inputScript "test-1 -name a" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "a:1:0"
        }
    }

    Context 'Fixed Arity Parameter (Nargs = 2)' {
        It 'Completes first argument (index 0) for fixed-arity param (`test-1 -list a`)' {
            $results = TabExpansion2 -inputScript "test-1 -list a" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "a_1st:1:0"
        }

        It 'Completes second argument when cursor is after space (`test-1 -list a `)' {
            $results = TabExpansion2 -inputScript "test-1 -list a " | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "_2nd:0:1"
        }

        It 'Completes second argument when partially typed (`test-1 -list a b`)' {
            $results = TabExpansion2 -inputScript "test-1 -list a b" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "b_2nd:1:1"
        }
    }

    Context 'Variable Arity Parameter (Nargs = 1+)' {
        It 'Completes first argument for variable-arity param (`test-1 -one-or-more -`)' {
            $results = TabExpansion2 -inputScript "test-1 -one-or-more -" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "-:1:0"
        }

        It 'Completes subsequent argument (index 1) for variable-arity param (`test-1 -one-or-more a -`)' {
            $results = TabExpansion2 -inputScript "test-1 -one-or-more a -" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -BeGreaterThan 1
            $results[0].CompletionText | Should -Be "-:1:1"
        }

        It 'Stops completing variable-arity param when next param begins (`test-1 -one-or-more a -name a`)' {
            $results = TabExpansion2 -inputScript "test-1 -one-or-more a -name a" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "a:1:0"
        }
    }

    Context 'Typed parameter' {
        It 'Completes file parameter (`test-1 -file ./`)' {
            $results = TabExpansion2 -inputScript 'test-1 -file ./' | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -BeGreaterThan 0
            $results[0].ResultType | Should -Be ([System.Management.Automation.CompletionResultType]::ProviderItem)
        }
    }
}
