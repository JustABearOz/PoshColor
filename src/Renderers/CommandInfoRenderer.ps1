function Write-CommandHeaderInfo{

    if ($script:currentDirectory -eq "")
    {
        Write-Host 'CommandType     Name                                               Version    Source'
        Write-Host '-----------     ----                                               -------    ------'

        $script:currentDirectory = "CommandInfo"
    }
}

function Write-CommandInfo
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    Write-CommandHeaderInfo

    $output = [System.String]::Format("{0, -16}{1, -51}{2,-11}{3}", $item.CommandType, $item.Name, $item.Version, $item.Module.Name)

    $foreground = $global:PoshColor.CommandInfo.Default.Color

    if ($item -is [System.Management.Automation.ApplicationInfo])
    {
        $foreground = $global:PoshColor.CommandInfo.Application.Color
    }
    elseif ($item -is [System.Management.Automation.CmdletInfo])
    {
        $foreground = $global:PoshColor.CommandInfo.CommandLet.Color
    }
    elseif ($item -is [System.Management.Automation.ExternalScriptInfo])
    {
        $foreground = $global:PoshColor.CommandInfo.ExternalScript.Color
    }
    elseif ($item -is [System.Management.Automation.FunctionInfo])
    {
        $foreground = $global:PoshColor.CommandInfo.Function.Color
    }
    elseif ($item -is [System.Management.Automation.RemoteCommandInfo])
    {
        $foreground = $global:PoshColor.CommandInfo.RemoteCommand.Color
    }
    elseif ($item -is [System.Management.Automation.ScriptInfo])
    {
        $foreground = $global:PoshColor.CommandInfo.ScriptInfo.Color
    }
    elseif ($item -is [System.Management.Automation.AliasInfo])
    {
        $foreground = $global:PoshColor.CommandInfo.Alias.Color
    }
    
    Write-HostColor $output -Foreground $foreground

    return $true
}
