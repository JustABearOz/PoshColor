# PSColorizer
PSColorizer is a new take on [PSColor](https://github.com/Davlind/PSColor), allowing you to customise items in powershell based on your own color preferences.

PSColozier can use either standard console colors or RGB.

## Features
* Colors can be set to RGB
* Background colors can be set
* Files & Directories can have more complicated rules for coloring including based on Attributes
* Theme support
* Can be unloaded/reloaded without causing issues in your current session

## Themes
There are currently 2 themes that come with PSColorizer
* Default, a theme that uses named console colors
* DefaultHighColor, a theme that uses RGB values

## Comands
|Command|Description|
|---|---|
|Get-ColorizerTheme|Gets the current theme being used by PSColorizer|
|Set-ColorizerTheme|Sets the current theme for colorizer to use|
|Get-ColorizerThemes|Gets a list of all installed colorizer themes|
