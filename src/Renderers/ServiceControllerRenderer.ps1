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

    $trimmedName = Trim $item.Name 18
    $trimmedDisplayName = Trim $item.DisplayName 38
    $status = $item.Status
    $startup = Trim $item.StartupType 20

    $foreground = $global:PSColorizer.Service.Default.Color
    $background = $global:PSColorizer.Service.Default.BackgroundColor

    if ($item.Status -eq 'Running')
    {
        $foreground = $global:PSColorizer.Service.Running.Color
        $background = $global:PSColorizer.Service.Running.BackgroundColor
    }
    elseif ($item.Status -eq 'Stopped')
    {
        $foreground = $global:PSColorizer.Service.Stopped.Color
        $background = $global:PSColorizer.Service.Stopped.BackgroundColor
    }

    $statusText = [String]::Format("{0, -8}", $status)
    $outputText = [String]::Format(" {0, -18} {1, -38} {2, -20}", $trimmedName, $trimmedDisplayName, $startup)

    Write-HostColor $statusText -Foreground $foreground -Background $background -noNewLine
    Write-HostColor $outputText -Foreground $global:PSColorizer.Service.Properties.Color -Background $global:PSColorizer.Service.Properties.BackgroundColor

    return $true
}
