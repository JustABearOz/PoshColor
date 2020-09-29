function Write-DriveInfoHeader
{
    if (($script:currentDirectory -eq ""))
    {
        Write-Host ""
        Write-Host "Name           Used (GB)     Free (GB) Provider      Root"
        Write-Host "----           ---------     --------- --------      ----"

        $script:currentDirectory = "PSDriveInfo"
    }
}

function Write-PSDrive
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    Write-DriveInfoHeader

    $foreground = $global:PoshColor.PSDriveInfo.Default.Color

    if ($item.Provider.Name -eq 'Alias')
    {
        $foreground = $global:PoshColor.PSDriveInfo.Alias.Color
    }
    elseif ($item.Provider.Name -eq 'FileSystem')
    {
        $foreground = $global:PoshColor.PSDriveInfo.FileSystem.Color
    }
    elseif ($item.Provider.Name -eq 'Certificate')
    {
        $foreground = $global:PoshColor.PSDriveInfo.Certificate.Color
    }
    elseif ($item.Provider.Name -eq 'Environment')
    {
        $foreground = $global:PoshColor.PSDriveInfo.Environment.Color
    }
    elseif ($item.Provider.Name -eq 'Function')
    {
        $foreground = $global:PoshColor.PSDriveInfo.Function.Color
    }
    elseif ($item.Provider.Name -eq 'Registry')
    {
        $foreground = $global:PoshColor.PSDriveInfo.Registry.Color
    }
    elseif ($item.Provider.Name -eq 'Variable')
    {
        $foreground = $global:PoshColor.PSDriveInfo.Variable.Color
    }
    elseif ($item.Provider.Name -eq 'WSMan')
    {
        $foreground = $global:PoshColor.PSDriveInfo.WSMan.Color
    }

    $used = (($item.Used / 1024) / 1024) / 1024
    $free = (($item.Free / 1024) / 1024) / 1024

    $usedText = [System.Math]::Round($used, 2).ToString("#.##")
    $freeText = [System.Math]::Round($free, 2).ToString("#.##")
    
    $output = [System.String]::Format("{0,-14} {1,9} ", $item.Name, $usedText)
    $freeOutput = [System.String]::Format("{0, 13}", $freeText)
    $providerOutput = [System.String]::Format(" {0, -13} {1}", $item.Provider.Name, $item.Root)

    Write-HostColor $output -Foreground $foreground -noNewLine

    $freeForeground = $foreground

    $totalSize = $item.Used + $item.Free

    if (!($null -eq $totalSize) -and $totalSize -ne 0)
    {
        $freePercent = (100 / $totalSize) * $item.Free

        $percentage = $global:PoshColor.PSDriveInfo.LowSpacePercent.Value

        if ($freePercent -lt $percentage)
        {
            $freeForeground = $global:PoshColor.PSDriveInfo.LowSpace.Color
        }
    }

    Write-HostColor $freeOutput -Foreground $freeForeground -noNewLine

    Write-HostColor $providerOutput -Foreground $foreground

    return $true
}