function Write-Header
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

    Write-Header

    $foreground = $global:PSColorizer.PSDriveInfo.Default.Color

    if ($item.Provider.Name -eq 'Alias')
    {
        $foreground = $global:PSColorizer.PSDriveInfo.Alias.Color
    }
    elseif ($item.Provider.Name -eq 'FileSystem')
    {
        $foreground = $global:PSColorizer.PSDriveInfo.FileSystem.Color
    }
    elseif ($item.Provider.Name -eq 'Certificate')
    {
        $foreground = $global:PSColorizer.PSDriveInfo.Certificate.Color
    }
    elseif ($item.Provider.Name -eq 'Environment')
    {
        $foreground = $global:PSColorizer.PSDriveInfo.Environment.Color
    }
    elseif ($item.Provider.Name -eq 'Function')
    {
        $foreground = $global:PSColorizer.PSDriveInfo.Function.Color
    }
    elseif ($item.Provider.Name -eq 'Registry')
    {
        $foreground = $global:PSColorizer.PSDriveInfo.Registry.Color
    }
    elseif ($item.Provider.Name -eq 'Variable')
    {
        $foreground = $global:PSColorizer.PSDriveInfo.Variable.Color
    }
    elseif ($item.Provider.Name -eq 'WSMan')
    {
        $foreground = $global:PSColorizer.PSDriveInfo.WSMan.Color
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

        $percentage = $global:PSColorizer.PSDriveInfo.LowSpacePercent.Value

        if ($freePercent -lt $percentage)
        {
            $freeForeground = $global:PSColorizer.PSDriveInfo.LowSpace.Color
        }
    }

    Write-HostColor $freeOutput -Foreground $freeForeground -noNewLine

    Write-HostColor $providerOutput -Foreground $foreground

    return $true
}