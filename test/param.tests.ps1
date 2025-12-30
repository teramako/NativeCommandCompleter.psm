<#
.SYNOPSIS
completion tests for parameters
#>
BeforeAll {
    Register-NativeCompleter -Name test-1 -Parameters @(
        New-ParamCompleter -ShortName a -LongName all
        New-ParamCompleter -ShortName v -LongName version
        New-ParamCompleter -Name name -ArgumentCompleter {
            param([int] $position, [int] $argIndex, $tokens)
            "{0}:{1}:{2}:[{3}]" -f $_, $position, $argIndex, ($tokens -join ",")
        }
        New-ParamCompleter -Name list -Nargs 2 -ArgumentCompleter {
            param([int] $position, [int] $argIndex, $tokens)
            "{0}:{1}:{2}:[{3}]" -f $_, $position, $argIndex, ($tokens -join ",")
        }
        New-ParamCompleter -Name one-or-more -Nargs '1+' -ArgumentCompleter {
            param([int] $position, [int] $argIndex, $tokens)
            "{0}:{1}:{2}:[{3}]" -f $_, $position, $argIndex, ($tokens -join ",")
        }
    )
}

Describe 'parameters' {
    Context 'Single-Value Parameter (Nargs = 1)' {
        It 'Completes parameter name for single-value param' {
            $results = TabExpansion2 -inputScript "test-1 -n" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "-name"
        }

        It 'Completes first argument for single-value param' {
            $results = TabExpansion2 -inputScript "test-1 -name a" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "a:1:0:[]"
        }
    }

    Context 'Fixed Arity Parameter (Nargs = 2)' {
        It 'Completes first argument (index 0) for fixed-arity param' {
            $results = TabExpansion2 -inputScript "test-1 -list a" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "a:1:0:[]"
        }

        It 'Completes second argument when cursor is after space' {
            $results = TabExpansion2 -inputScript "test-1 -list a " | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be ":0:1:[a]"
        }

        It 'Completes second argument when partially typed' {
            $results = TabExpansion2 -inputScript "test-1 -list a b" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "b:1:1:[a]"
        }
    }

    Context 'Variable Arity Parameter (Nargs = 1+)' {
        It 'Completes first argument for variable-arity param' {
            $results = TabExpansion2 -inputScript "test-1 -one-or-more -" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "-:1:0:[]"
        }

        It 'Completes subsequent argument (index 1) for variable-arity param' {
            $results = TabExpansion2 -inputScript "test-1 -one-or-more a -" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -BeGreaterThan 1
            $results[0].CompletionText | Should -Be "-:1:1:[a]"
        }

        It 'Stops completing variable-arity param when next param begins' {
            $results = TabExpansion2 -inputScript "test-1 -one-or-more a -name a" | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -Be 1
            $results[0].CompletionText | Should -Be "a:1:0:[]"
        }
    }
}
