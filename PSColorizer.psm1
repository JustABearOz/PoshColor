function Get-ColorizerThemes
{
     <#
        .SYNOPSIS
            Retrieves a list of all installed colorizer themes

        .EXAMPLE
            Get-ColorizerThemes
    #>
    get-childitem "$PSScriptRoot\Themes\*.ps1" | foreach-object { Write-Host $_.Name.Replace(".ps1", "") }
}

function Get-ColorizerTheme
{
     <#
        .SYNOPSIS
            Retrieves the name of the currently set theme

        .EXAMPLE
            Get-ColorizerTheme
    #>
    return [System.Environment]::GetEnvironmentVariable("PSColorizerTheme", [System.EnvironmentVariableTarget]::User)
}

function Set-ColorizerTheme
{
     <#
        .SYNOPSIS
            Sets the current Colorizer theme

        .EXAMPLE
            Set-ColorizerTheme Default
    #>
    param (
        # Name of the theme to set
        [Parameter(Position=0)][string] $ThemeName, 

        # Use to import the theme, making it the currently loaded theme
        [switch] $Import
        )

    [System.Environment]::SetEnvironmentVariable("PSColorizerTheme", $ThemeName, [System.EnvironmentVariableTarget]::User)

    if ($Import)
    {
        Import-ColorizerTheme
    }
}

function Import-ColorizerTheme
{
    $themeName = [System.Environment]::GetEnvironmentVariable("PSColorizerTheme", [System.EnvironmentVariableTarget]::User)

    $theme = "$PSScriptRoot\Themes\$themeName.ps1"

    # Import the configured theme
    . "$theme"
}

## Script cleanup so it can be safely removed wihtout causing issues after its removal
$OnRemoveScript = {

    #Name of the command
    $commandName = $originalCommand.Command.Name

    if ((Test-Path function:\GLOBAL:$commandName) -and $originalCommand.CommandType -eq "Function" )
    {
        # Remove the wrapper command
        Remove-Item function:\Out-Default

        #Rename the wrapped command back to Out-Default
        Rename-Item function:\GLOBAL:$commandName GLOBAL:Out-Default
    }

    # If the original command is no longer public, make it public
    if ($originalCommand.Command.Visibility -ne "public")
    {
        $originalCommand.Command.Visibility = "Public"
    }   
}

# Import helpers
. "$PSScriptRoot\New-CommandWrapper.ps1"
. "$PSScriptRoot\PSColorizerFunctions.ps1"
. "$PSScriptRoot\Renderers\ServiceControllerRenderer.ps1"
. "$PSScriptRoot\Renderers\FileRenderer.ps1"
. "$PSScriptRoot\Renderers\MatchInfoRenderer.ps1"

# if no theme has been set, set the default
if ($null -eq [System.Environment]::GetEnvironmentVariable("PSColorizerTheme", [System.EnvironmentVariableTarget]::User))
{
    [System.Environment]::SetEnvironmentVariable("PSColorizerTheme", "Default", [System.EnvironmentVariableTarget]::User)
}

Import-ColorizerTheme

## No starting directory, this is used to detect changes in directories during file listings
$script:currentDirectory = ""

## Set handler for cleanup
$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript

## Wrap the out-default current command/function
$originalCommand = New-CommandWrapper Out-Default -Process {

    $handled = $false

    if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
    {
        $handled = Write-File $_
    }
    elseif($_ -is [System.ServiceProcess.ServiceController])
    {
        $handled = Write_Service $_
    }
    elseif($_ -is [Microsoft.Powershell.Commands.MatchInfo])
    {
        $handled = Write-Match $_
    }
    
    if ($handled)
    {
        $_ = $null
    }
} -end {
    write-host ""
    $script:currentDirectory = ""
}