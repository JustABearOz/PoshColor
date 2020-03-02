function Get-ColorizerThemes
{
     <#
        .SYNOPSIS
            Retrieves a list of all installed colorizer themes

        .EXAMPLE
            Get-ColorizerThemes
    #>
    $themePath = Join-Path $PSScriptRoot "Themes"

    $themePath = Join-Path $themePath "*.ps1"
    
    get-childitem $themePath | foreach-object { Write-Host $_.Name.Replace(".ps1", "") }
}

function Get-ColorizerTheme
{
     <#
        .SYNOPSIS
            Retrieves the name of the currently set theme

        .EXAMPLE
            Get-ColorizerTheme
    #>
    if ($IsWindows)
    {
        $themeName = [System.Environment]::GetEnvironmentVariable("PSColorizerTheme", [System.EnvironmentVariableTarget]::User)
    }
    else {
        # Read from a user config file
        if (Test-Path "~/PSColorizer.config")
        {
            $themeName = Get-Content ~/PSColorizer.config
        }
    }

    return $themeName
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

        if ($IsWindows)
    {
        [System.Environment]::SetEnvironmentVariable("PSColorizerTheme", $ThemeName, [System.EnvironmentVariableTarget]::User)
    }
    else
    {
        Set-Content "~/PSColorizer.config" $ThemeName
    }

    if ($Import)
    {
        Import-ColorizerTheme
    }
}

function Import-ColorizerTheme
{
    $themeName = Get-ColorizerTheme

    if (!($themeName))
    {
        $themeName = "Default"
    }

    $theme = Join-Path $PSScriptRoot "Themes"
    $theme = Join-Path $theme "$themeName.ps1"

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
$import = Join-Path $PSScriptRoot "New-CommandWrapper.ps1"
. $import

$import = Join-Path $PSScriptRoot "PSColorizerFunctions.ps1"
. $import

$import = Join-Path $PSScriptRoot "Renderers"
$import = Join-Path $import "ServiceControllerRenderer.ps1"
. $import

$import = Join-Path $PSScriptRoot "Renderers"
$import = Join-Path $import "FileRenderer.ps1"
. $import

$import = Join-Path $PSScriptRoot "Renderers"
$import = Join-Path $import "MatchInfoRenderer.ps1"
. $import

$import = Join-Path $PSScriptRoot "Renderers"
$import = Join-Path $import "PSModuleInfoRenderer.ps1"
. $import

$import = Join-Path $PSScriptRoot "Renderers"
$import = Join-Path $import "EventLogRecordRenderer.ps1"
. $import


# if no theme has been set, set the default
$theme = Get-ColorizerTheme

if (!$theme)
{
    Set-ColorizerTheme 'Default'
}

Import-ColorizerTheme

## No starting directory, this is used to detect changes in directories during file listings
$script:currentDirectory = ""

## Set handler for cleanup
$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript

## Wrap the out-default current command/function
$originalCommand = New-CommandWrapper Out-Default -Process {

    $handled = $false

    try {
        
        if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
        {
            $handled = Write-File $_
        }
        elseif($_ -is [Microsoft.Powershell.Commands.MatchInfo])
        {
            $handled = Write-Match $_
        }
        elseif($_ -is [System.Management.Automation.PSModuleInfo])
        {
            $handled = Write-Module $_
        }

        ## Platform specific, Win32
        if ([System.Environment]::OSVersion.Platform -eq 'Win32NT')
        {
            if($_ -is [System.Diagnostics.Eventing.Reader.EventLogRecord])
            {
                $handled = Write-EventLog $_
            }
            elseif($_ -is [System.ServiceProcess.ServiceController])
            {
                $handled = Write_Service $_
            }
        }
    }
    catch {
        Write-Host $_.Exception.Message + ' ' + $_.InvocationInfo.ScriptLineNumber
    }
    
    if ($handled)
    {
        $_ = $null
    }
} -end {
    write-host ""
    $script:currentDirectory = ""
}