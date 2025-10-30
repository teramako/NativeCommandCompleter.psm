<#
.SYNOPSIS
completion tests for 'mkdir'
#>
Describe 'mkdir' {
    Context 'Long parameters' {
        It 'All parameters' {
            $commandLine = "mkdir --";
            $result = TabExpansion2 -inputScript $commandLine
            $result.CompletionMatches | Out-String | Write-Host
            $result.CompletionMatches.Count | Should -BeGreaterThan 0
        }

        It 'All Long parameters starts with "--v"' {
            $commandLine = "mkdir --v";
            $result = TabExpansion2 -inputScript $commandLine
            $result.CompletionMatches.Count | Should -BeExactly 2
        }
    }

    Context 'Short parameters' {
        It 'All parameters' {
            $commandLine = "mkdir -";
            $result = TabExpansion2 -inputScript $commandLine
            $result.CompletionMatches | Out-String | Write-Host
            $result.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }

    Context 'Arguments' {
        It 'Filename completions : "<_>"' -ForEach @(
            'mkdir ', 'mkdir -m 777 ', 'mkdir arg1 ', 'mkdir /e' 
        ) {
            $commandLine = $_;
            $results = TabExpansion2 -inputScript $commandLine | Select-Object -ExpandProperty CompletionMatches
            $results.Count | Should -BeGreaterThan 0
            $results.ResultType | Should -BeIn 'ProviderContainer', 'ProviderItem'

        }
    }
}
