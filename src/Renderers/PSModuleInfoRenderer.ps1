function Write-ModuleHeader
{
    ## Do we need to write headers?
    if (($script:currentDirectory -eq ""))
    {
        Write-Host
        Write-Host "ModuleType Version    Name                                ExportedCommands"
        Write-Host "---------- -------    ----                                ----------------"

        $script:currentDirectory = "Modules"
    }
}

function Write-Module
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    Write-ModuleHeader


    $foreground = $global:PoshColor.Module.Default.Color    

    if ($item.ModuleType.ToString() -eq 'Binary') {
        $foreground = $global:PoshColor.Module.Binary.Color
    }
    elseif($item.ModuleType.ToString() -eq 'Cim') {
        $foreground =  $global:PoshColor.Module.Cim.Color
    }
    elseif($item.ModuleType.ToString() -eq 'Manifest') {
        $foreground =  $global:PoshColor.Module.Manifest.Color
    }
    elseif($item.ModuleType.ToString() -eq 'Script') {
        $foreground =  $global:PoshColor.Module.Script.Color
    }
    elseif($item.ModuleType.ToString() -eq 'Workflow') {
        $foreground =  $global:PoshColor.Module.Workflow.Colorz
    }

    $info = [String]::Format("{0,-10} {1, -10} {2, -36}", $item.ModuleType, $item.Version, $item.Name)

    $commands = [String]::Join(",", $item.ExportedCommands.Keys)

    $width = $Host.UI.RawUI.WindowSize.Width - $info.Length - 6;

    if ($width -lt 30)
    {
        $width = 30
    }

    if ($commands.Length -ge $width)
    {
        $commands = $commands.Substring(0, $width) + ".."
    }

    $info = $info + "{$commands}"

    Write-HostColor $info -Foreground $foreground

    return $true;
}