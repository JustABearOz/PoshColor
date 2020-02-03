# PSColorizer
PSColorizer is a new take on [PSColor](https://github.com/Davlind/PSColor), allowing you to customise items in powershell based on your own color preferences. PSColorizer works in Powershell Core and works across both Windows and Linux.

PSColozier can use either standard console colors or 8 bit RGB allowing 16 million colours.

## Features
* Colors can be set to RGB or Named colors from .Net (System.Drawing.Color)
* Tested under Windows (powershell and powershell core) and Linux (Ubuntu/bash Ubuntu/powershell core)
* Background colors can be set
* Coloring of Files, Directories, Services, and MatchInfo (from select-string)
* Files & Directories can have rules for coloring including based the following:
  * File Names using regular expressions
  * File Attributes such as directory, hidden, system, encypted or compressed
* Theme support
* Can be unloaded/reloaded without causing issues in your current session

![Screenshot of get-childitem](images/lsresult.png)



## Themes
There are currently 3 themes that come with PSColorizer.

### Included themes
|Theme Name| Description|
|--|--|
|Default|The default theme using standard terminal colors|
|DefaultHighColor| Similar styling to Default, but uses 8 bit RGB colors|
|Cool| Uses RGB colors to provide a theme based on whites, blues and greens|

## Comands
|Command|Description|
|---|---|
|Get-ColorizerTheme|Gets the current theme being used by PSColorizer|
|Set-ColorizerTheme|Sets the current theme for colorizer to use|
|Get-ColorizerThemes|Gets a list of all installed colorizer themes|

## Installation
### Install from source
```powershell
git clone https://github.com/JustABearOz/PSColorizer.git

sl .\PSColorizer

.\Install.ps1
```

### Install from Zip
Download the latest [release](https://github.com/JustABearOz/PSColorizer/releases) and extract it into your powershell modules directory. 

### Add to Profile
The above installation methods will load the PSColorizer module for your current session. If you want the PSColorizer module loaded for all sessions, add the following line to your profile
```pwsh
Import-Module PSColorizer
```

### Themes
To view a list of installed themes
```powershell
Get-ColorizerThemes
```

To set the current theme (Setting theme too Cool)
```powershell
Set-ColorizerTheme Cool
```

To view the current theme
``` Powershell
Get-ColorizerTheme
```

## Questions
### Why not contribute to PSColor?
PS Color seems to be a dead repository. There have not been any updates to the repo in a few years, and there are a few PRs that have been contributed that have not been accepted. ALSO, I thought it would be fun to do :)
