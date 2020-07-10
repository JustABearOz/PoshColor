function Write-ServiceHeader
{
    if (($script:currentDirectory -eq ""))
    {
        Write-Host ""
        Write-Host "Status   Name               DisplayName                            Startup"
        Write-Host "------   ----               -----------                            -------"

        $script:currentDirectory = "Services"
    }
}

function Write_Service
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    Write-ServiceHeader

    $foreground = $global:PoshColor.Service.Default.Color
    $background = $global:PoshColor.Service.Default.BackgroundColor

    $name = $item.Name

    $trimmedName = Trim $name 18

    $displayName = $item.DisplayName

    if (!$displayName -or $null -eq $displayName)
    {
        $displayName = ""
    }

    $trimmedDisplayName = Trim $displayName 38
        
    if ($null -eq $item.StartupType)
    {
        $startupType = "Unknown"
    }
    else {
        $startupType = $item.StartupType.ToString()

        if (!$startupType -or  $null -eq $startupType)
        {
            $startupType = "Unknown"
        }
    }
    
    $startup = Trim $startupType 20

    $status = $item.Status.ToString()

    if ($status -eq 'Running')
    {
        $foreground = $global:PoshColor.Service.Running.Color
        $background = $global:PoshColor.Service.Running.BackgroundColor
    }
    elseif ($status -eq 'Stopped')
    {
        $foreground = $global:PoshColor.Service.Stopped.Color
        $background = $global:PoshColor.Service.Stopped.BackgroundColor
    }

    if (!$status -or $status -eq "")
    {
        $status = "Unknown"
    }

    if (!$startup -or $startup -eq "")
    {
        $startup = "Unmknown";
    }

    $statusText = [String]::Format("{0, -8}", $status)
    $outputText = [String]::Format(" {0, -18} {1, -38} {2, -20}", $trimmedName, $trimmedDisplayName, $startup)

    Write-HostColor $statusText -Foreground $foreground -Background $background -noNewLine
    Write-HostColor $outputText -Foreground $global:PoshColor.Service.Properties.Color -Background $global:PoshColor.Service.Properties.BackgroundColor

    return $true
}
