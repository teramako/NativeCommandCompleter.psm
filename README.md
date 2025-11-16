# NativeCommandCompleter.psm
PowerShell module for complete native command parameters and arguments

## 🎥 Demo

![](./docs/demo/demo_0_dotnet_menucomplete.gif)

## 🚨 Requirements

 - PowerShell >= 7.6.0-preview.5

## 🚀 Build & Install

### 1. Clone this repository

```powershell
cd path/to/dir
git clone https://github.com/teramako/NativeCommandCompleter.psm.git
```

### 2. Build

```powershell
cd NativeCommandCompleter.psm
dotnet build ./src
```

### 3. Put the module into `$env:PSModulePath`

```powershell
cd ($env:PSModulePath -split [System.IO.Path]::PathSeparator)[0]
ln -s path/to/dir/NativeCommandCompleter.psm
```

### 4. Edit profile

Edit the profile loaded at PowerShell startup

```powershell
& $env:EDITOR $PROFILE
```

Add the following code:

```powershell
Import-Module -Name NativeCommandCompleter.psm
```

> [!TIP]
> I recommend changing the style of the selection.
> ```powershell
> Set-PSReadLineOption -Colors @{
>     Selection = $PSStyle.Reverse;
> }
> ```

## ⚙️ Settings

### Environement Variable: `PS_COMPLETE_PATH`

Path(s) of the directory where the completion scripts for each command are located.
(The path separator is `;` on Windows and `:` on Unix-like OS)
The target file (`{command-name}.ps1`) is searched and read during completion dymanically.
Once loaded and registered, the completion code is cached and will not be reloaded until it is unregistered.

If not specified, the `{module directory}/completions` directory is set automatically.

## 📚 Write completion scripts

### Cmdlets

| Cmdlet                       | Description                                    |
|:-----------------------------|:-----------------------------------------------|
| [New-CommandCompleter]       | Create a CommandCompleter object.              |
| [New-ParamCompleter]         | Create a parameter's completer.                |
| [Register-NativeCompleter]   | Create and register a CommandCompleter object. |
| [Unregister-NativeCompleter] | Unregister the command completer.              |

[New-CommandCompleter]: docs/NativeCommandCompleter.psm/New-CommandCompleter.md "Cmdlet - New-CommandCompleter"
[New-ParamCompleter]: docs/NativeCommandCompleter.psm/New-ParamCompleter.md "Cmdlet - New-ParamCompleter"
[Register-NativeCompleter]: docs/NativeCommandCompleter.psm/Register-NativeCompleter.md "Cmdlet - Register-NativeCompleter"
[Unregister-NativeCompleter]: docs/NativeCommandCompleter.psm/Unregister-NativeCompleter.md "Cmdlet - Unregister-NativeCompleter"

Write the definition of command completion using the Cmdlets above.
