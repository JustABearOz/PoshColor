function Get-PoshColorThemes {
    <#
        .SYNOPSIS
            Retrieves a list of all installed PoshColor themes

        .EXAMPLE
            Get-PoshColorThemes
    #>
    $themePath = Join-Path $PSScriptRoot "Themes"

    $themePath = Join-Path $themePath "*.ps1"

    get-childitem $themePath | foreach-object { Write-Output $_.Name.Replace(".ps1", "") }
}

function Get-PoshColorTheme {
    <#
        .SYNOPSIS
            Retrieves the name of the currently set theme

        .EXAMPLE
            Get-PoshColorTheme
    #>
    if ($IsWindows) {
        $themeName = [System.Environment]::GetEnvironmentVariable("PoshColorTheme", [System.EnvironmentVariableTarget]::User)
    }
    else {
        # Read from a user config file
        if (Test-Path "~/PoshColor.config") {
            $themeName = Get-Content ~/PoshColor.config
        }
    }

    return $themeName
}

function Set-PoshColorTheme {
    [CmdletBinding(SupportsShouldProcess)]
    <#
        .SYNOPSIS
            Sets the current PoshColor theme

        .EXAMPLE
            Set-PoshColorTheme Default
    #>
    param (
        # Name of the theme to set
        [Parameter(Position = 0)][string] $ThemeName,

        # Use to import the theme, making it the currently loaded theme
        [switch] $Import
    )

    if ($IsWindows) {
        [System.Environment]::SetEnvironmentVariable("PoshColorTheme", $ThemeName, [System.EnvironmentVariableTarget]::User)
    }
    else {
        Set-Content "~/PoshColor.config" $ThemeName
    }

    if ($Import) {
        Import-PoshColorTheme
    }
}

function Import-PoshColorTheme {
    $themeName = Get-PoshColorTheme

    if (!($themeName)) {
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

    if ((Test-Path function:\GLOBAL:$commandName) -and $originalCommand.CommandType -eq "Function" ) {
        # Remove the wrapper command
        Remove-Item function:\Out-Default

        #Rename the wrapped command back to Out-Default
        Rename-Item function:\GLOBAL:$commandName GLOBAL:Out-Default
    }

    # If the original command is no longer public, make it public
    if ($originalCommand.Command.Visibility -ne "public") {
        $originalCommand.Command.Visibility = "Public"
    }
}

# Needed in old powershell
Add-Type -Assembly System.Drawing

# Import helpers
$import = Join-Path $PSScriptRoot "New-CommandWrapper.ps1"
. $import

$import = Join-Path $PSScriptRoot "PoshColorFunctions.ps1"
. $import

#Import-Renderer -RendererFileName "ServiceControllerRenderer.ps1"
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

$import = Join-Path $PSScriptRoot "Renderers"
$import = Join-Path $import "PSDriveInfoRenderer.ps1"
. $import

$import = Join-Path $PSScriptRoot "Renderers"
$import = Join-Path $import "CommandInfoRenderer.ps1"
. $import

$import = Join-Path $PSScriptRoot "Renderers"
$import = Join-Path $import "MemberDefinitionRenderer.ps1"
. $import

# if no theme has been set, set the default
$theme = Get-PoshColorTheme

if (!$theme) {
    Set-PoshColorTheme 'Default'
}

Import-PoshColorTheme

## No starting directory, this is used to detect changes in directories during file listings
$script:currentDirectory = ""

## Set handler for cleanup
$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript

## Wrap the out-default current command/function
$originalCommand = New-CommandWrapper Out-Default -Process {

    try {

        $handled = $false

        if (($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo])) {
            $handled = Write-File $_
            $handled = $true
        }
        elseif ($_ -is [Microsoft.Powershell.Commands.MatchInfo]) {
            $handled = Write-Match $_
        }
        elseif ($_ -is [System.Management.Automation.PSModuleInfo]) {
            $handled = Write-Module $_
        }
        elseif ($_ -is [System.Management.Automation.PSDriveInfo]) {
            $handled = Write-PSDrive $_
        }
        elseif ($_ -is [System.Management.Automation.ApplicationInfo] -or
            $_ -is [System.Management.Automation.CmdletInfo] -or
            $_ -is [System.Management.Automation.ExternalScriptInfo] -or
            $_ -is [System.Management.Automation.FunctionInfo] -or
            $_ -is [System.Management.Automation.RemoteCommandInfo] -or
            $_ -is [System.Management.Automation.ScriptInfo] -or
            $_ -is [System.Management.Automation.AliasInfo]) {
            $handled = Write-CommandInfo $_
        }
        elseif($_ -is [Microsoft.PowerShell.Commands.MemberDefinition])
        {
            $handled = Write-MemberDefinition $_
        }

        ## Platform specific, Win32, not available in all version of powershell
        elseif ([System.Environment]::OSVersion.Platform -eq 'Win32NT') {
            try {

                if ($_ -is [System.Diagnostics.Eventing.Reader.EventLogRecord]) {
                    $handled = Write-EventLog $_
                }
                elseif ($_ -is [System.ServiceProcess.ServiceController]) {
                    $handled = Write_Service $_
                }
            }
            catch {
                $handled = $false
            }
        }
    }
    catch {
        Write-Error $_.Exception.Message
        $handled = $false
    }

    if ($handled -eq $true) {
        $_ = $null
    }
} -end {
    write-output ""
    $script:currentDirectory = ""
}