function Write-ServiceHeader
{
    ## Do we need to write headers?
    if (($script:currentDirectory -eq ""))
    {
        Write-Host
        Write-Host "Time Created           Id      Level        Provider             Message"
        Write-Host "------------           ------  --------     --------             ----------------"

        $script:currentDirectory = "EventLog"
    }
}

function Write-EventLog
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    Write-ServiceHeader


    $foreground = $global:PSColorizer.EventLog.Default.Color    

    if ($item.Level -eq 1)
    {
        # Critical
        $foreground = $global:PSColorizer.EventLog.Critical.Color
    }
    elseif ($item.Level -eq 2)
    {
        $foreground = $global:PSColorizer.EventLog.Error.Color
    }
    elseif ($item.Level -eq 3)
    {
        $foreground = $global:PSColorizer.EventLog.Warning.Color
    }
    elseif ($item.Level -eq 4)
    {
        $foreground = $global:PSColorizer.EventLog.Information.Color
    }

    # if ($item.ModuleType.ToString() -eq 'Binary') {
    #     $foreground = $global:PSColorizer.Module.Binary.Color
    # }
    # elseif($item.ModuleType.ToString() -eq 'Cim') {
    #     $foreground =  $global:PSColorizer.Module.Cim.Color
    # }
    # elseif($item.ModuleType.ToString() -eq 'Manifest') {
    #     $foreground =  $global:PSColorizer.Module.Manifest.Color
    # }
    # elseif($item.ModuleType.ToString() -eq 'Script') {
    #     $foreground =  $global:PSColorizer.Module.Script.Color
    # }
    # elseif($item.ModuleType.ToString() -eq 'Workflow') {
    #     $foreground =  $global:PSColorizer.Module.Workflow.Colorz
    # }
    $providerName = $item.ProviderName.ToString()

    if ($providerName.Length -gt 20)
    {
        $providerName = $providerName.Substring(20)
    }

    $info = [String]::Format("{0,-22} {1, -7} {2, -12} {3, -20} {4}", $item.TimeCreated.ToString("G"), $item.Id, $item.LevelDisplayName, $providerName, $item.Message)

    # $commands = [String]::Join(",", $item.ExportedCommands.Keys)

    # $width = $Host.UI.RawUI.WindowSize.Width - $info.Length - 6;

    # if ($width -lt 30)
    # {
    #     $width = 30
    # }

    # if ($commands.Length -ge $width)
    # {
    #     $commands = $commands.Substring(0, $width) + ".."
    # }


    Write-HostColor $info -Foreground $foreground

    return $true;
}