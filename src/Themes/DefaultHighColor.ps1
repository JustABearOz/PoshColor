$global:PoshColor = @{
    UseConsoleColors = $false
    DirectoryForeground = '#00FF00'
    File = [ordered]@{
        HiddenDirectory = @{ Color = '#000080'; Hidden = $true; Directory = $true; BackgroundColor = '#FFFFFF' } 
        CompressedDirectory = @{ Color = '#0000FF'; Compressed =  $true}
        Hidden     = @{ Color = '#808080'; Hidden = $true } 
        IgnoreFiles= @{ Color = '#C0C0C0'; Pattern = '^\.' }
        Code       = @{ Color = '#808000'; Pattern = '\.(java|c|cpp|cs|js|css|html|vb)$' }
        Executable = @{ Color = '#FF0000'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|ps1|sh)$' }
        Text       = @{ Color = '#FFFF00'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
        Compressed = @{ Color = '#00FF00'; Pattern = '\.(zip|tar|gz|rar|jar|war)$' }
        Directory  = @{ Color = '#00FFFF'; Directory = $true}
        System     = @{ Color = '#FF00FF'; System = $true}
        Default    = @{ Color = '#FFFFFF' }
    }
    Service = @{
        Running = @{ Color = "#00FF00"}
        Stopped = @{ Color = "#FF0000"}
        Default = @{ Color = "#C0C0C0"}
        Properties = @{ Color = '#FFFFFF'}
    }
    Match = @{
        Default = @{Color = '#C0C0C0'}
        MatchText = @{ Color = '#00FFFF'}
        Match = @{Color = '#FFFFFF'}
        LineNumber = @{Color = '#FF0000'}
        File = @{Color = '#00FF00'}
    }
    Module = @{
        Binary = @{Color = '#dddddd'}
        Cim = @{Color = '#00FFFF'}
        Manifest = @{Color = '#00FF00'}
        Script = @{Color = '#FFFF00'}
        Workflow = @{Color = '#FF00FF'}
    }
    EventLog = @{
        Critical = @{Color = '#FF00FF'}
        Error  = @{Color = '#FF0000'}
        Warning = @{Color = '#FFFF00'}
        Information = @{Color = '#C0C0C0'}
        Default = @{Color = '#FFFFFF'}
    }
    PSDriveInfo = @{
        Alias = @{Color = '#808080'}
        FileSystem = @{Color = '#00FF00'}
        Certificate = @{Color = '#00C0C0'}
        Environment = @{Color = '#C0C0C0'}
        Function = @{Color = '#FFFF00'}
        Registry = @{Color = '#808000'}
        Variable = @{Color = '#FF00FF'}
        WSMan = @{Color = '#0000FF'}
        Default = @{Color = '#FFFFFF'}
        LowSpace = @{Color = '#FF0000'}
        LowSpacePercent = @{Value = 20}
    }
    CommandInfo = @{
        Default = @{Color = '#FFFFFF'}
        Alias = @{Color = '#00FF00'}
        Script = @{Color = '#00FFFF'}
        Function = @{Color = '#FFFF00'}
        CommandLet = @{Color = '#FF00FF'}
        Application = @{Color = '#C0C0C0'}
        RemoteCommand = @{Color = '#808080'}
        ExternalScript = @{Color = '#008000'}
    }
}