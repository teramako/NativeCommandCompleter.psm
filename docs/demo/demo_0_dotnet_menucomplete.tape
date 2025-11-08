Output demo_0_dotnet_menucomplete.gif

Set FontSize 12
Set Width 800
Set Height 600

Type "pwsh-preview"
Enter
Sleep 1s

Type "Set-PSReadLineKeyHandler -Chord 'Ctrl+o' MenuComplete"
Enter

Type "Import-Module -Name NativeCommandCompleter.psm"
Enter
Sleep 1s

Type "dotnet "
Sleep 200ms

Ctrl+o
Sleep 1s

Down@500ms 3
Right@500ms 1
Left@500ms 1
Up@500ms 3
Sleep 1s
Enter

Space

Ctrl+o
Sleep 2s
Type "s"
Sleep 1s
Enter

Space

Ctrl+o
Sleep 2s

Type "p"
Sleep 1s
Enter

Space
Type "System.Management."
Ctrl+o
Sleep 5s

