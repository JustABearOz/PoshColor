function Write-EventLogHeader
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

    Write-EventLogHeader

    $foreground = $global:PoshColor.EventLog.Default.Color    

    if ($item.Level -eq 1)
    {
        # Critical
        $foreground = $global:PoshColor.EventLog.Critical.Color
    }
    elseif ($item.Level -eq 2)
    {
        $foreground = $global:PoshColor.EventLog.Error.Color
    }
    elseif ($item.Level -eq 3)
    {
        $foreground = $global:PoshColor.EventLog.Warning.Color
    }
    elseif ($item.Level -eq 4)
    {
        $foreground = $global:PoshColor.EventLog.Information.Color
    }

    $providerName = $item.ProviderName.ToString()

    if ($providerName.Length -gt 20)
    {
        $providerName = $providerName.Substring(20)
    }

    $info = [String]::Format("{0,-22} {1, -7} {2, -12} {3, -20} {4}", $item.TimeCreated.ToString("G"), $item.Id, $item.LevelDisplayName, $providerName, $item.Message)

    Write-HostColor $info -Foreground $foreground

    return $true;
}