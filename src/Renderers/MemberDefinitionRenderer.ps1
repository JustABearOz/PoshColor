function Write-MemberDefinitionHeader{
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.String]
        $TypeName
    )

    if ($script:currentDirectory -eq "" -or $script:currentDirectory -ne $TypeName)
    {
        Write-Host
        Write-Host $TypeName -ForegroundColor Green
        Write-Host

        Write-Host 'Name                       MemberType      Definition'
        Write-Host '----                       ----------      ----------'

        $script:currentDirectory = "$TypeName"
    }
}

function Write-MemberDefinition
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    Write-MemberDefinitionHeader $item.TypeName

    $width = $Host.UI.RawUI.WindowSize.Width - 45

    if ($width -lt 30)
    {
        $width = 30
    }

    $definition = $item.Definition;

    if ($definition.Length -ge $width)
    {
        $definition = $definition.Substring(0, $width) + ".."
    }

    $output = [System.String]::Format("{0, -27}{1, -16}{2}", $item.Name, $item.MemberType, $definition)

    $foreground = $global:PoshColor.CommandInfo.Default.Color

    if ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::CodeMethod)
    {
        $foreground = $global:PoshColor.PSMemberType.CodeMethod.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::AliasProperty)
    {
        $foreground = $global:PoshColor.PSMemberType.AliasProperty.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::CodeProperty)
    {
        $foreground = $global:PoshColor.PSMemberType.CodeProperty.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::Method)
    {
        $foreground = $global:PoshColor.PSMemberType.Method.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::Methods)
    {
        $foreground = $global:PoshColor.PSMemberType.Methods.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::NoteProperty)
    {
        $foreground = $global:PoshColor.PSMemberType.NoteProperty.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::ParameterizedProperty)
    {
        $foreground = $global:PoshColor.PSMemberType.ParameterizedProperty.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::Properties)
    {
        $foreground = $global:PoshColor.PSMemberType.Properties.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::Property)
    {
        $foreground = $global:PoshColor.PSMemberType.Property.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::PropertySet)
    {
        $foreground = $global:PoshColor.PSMemberType.PropertySet.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::ScriptMethod)
    {
        $foreground = $global:PoshColor.PSMemberType.ScriptMethod.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::ScriptProperty)
    {
        $foreground = $global:PoshColor.PSMemberType.ScriptProperty.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::Dynamic)
    {
        $foreground = $global:PoshColor.PSMemberType.Dynamic.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::Event)
    {
        $foreground = $global:PoshColor.PSMemberType.Event.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::InferredProperty)
    {
        $foreground = $global:PoshColor.PSMemberType.InferredProperty.Color
    }
    elseif ($item.MemberType -eq [System.Management.Automation.PSMemberTypes]::MemberSet)
    {
        $foreground = $global:PoshColor.PSMemberType.MemberSet.Color
    }
    
    Write-HostColor $output -Foreground $foreground

    return $true
}
