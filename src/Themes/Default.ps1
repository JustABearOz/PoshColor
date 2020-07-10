$global:PoshColor = @{
    UseConsoleColors = $true
    DirectoryForeground = 'Green'
    File = [ordered]@{
        HiddenDirectory = @{ Color = 'DarkBlue'; Hidden = $true; Directory = $true; BackgroundColor = 'White' } 
        CompressedDirectory = @{ Color = 'Blue'; Compressed =  $true}
        Hidden     = @{ Color = 'DarkGray'; Hidden = $true } 
        IgnoreFiles= @{ Color = 'Gray'; Pattern = '^\.' }
        Code       = @{ Color = 'DarkYellow'; Pattern = '\.(java|c|cpp|cs|js|css|html|vb)$' }
        Executable = @{ Color = 'Red'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|ps1|sh)$' }
        Text       = @{ Color = 'Yellow'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
        Compressed = @{ Color = 'Green'; Pattern = '\.(zip|tar|gz|rar|jar|war)$' }
        Directory  = @{ Color = 'Cyan'; Directory = $true}
        System     = @{ Color = 'Magenta'; System = $true}
        Default    = @{ Color = 'White' }
    }
    Service = @{
        Running = @{ Color = 'DarkGreen'}
        Stopped = @{ Color = 'DarkRed'}
        Default = @{ Color = 'DarkGray'}
        Properties = @{ Color = 'White'}
    }
    Match = @{
        Default = @{Color = 'White'}
        MatchText = @{ Color = 'Cyan'}
        Match = @{Color = 'White'}
        LineNumber = @{Color = 'Red'}
        File = @{Color = 'Green'}
    }
    Module = @{
        Binary = @{Color = 'White'}
        Cim = @{Color = 'Cyan'}
        Manifest = @{Color = 'Green'}
        Script = @{Color = 'Yellow'}
        Workflow = @{Color = 'Magenta'}
    }
    EventLog = @{
        Critical = @{Color = 'Magenta'}
        Error  = @{Color = 'Red'}
        Warning = @{Color = 'Yellow'}
        Information = @{Color = 'White'}
        Default = @{Color = 'Gray'}
    }
    PSDriveInfo = @{
        Alias = @{Color = 'DarkGray'}
        FileSystem = @{Color = 'Green'}
        Certificate = @{Color = 'DarkCyan'}
        Environment = @{Color = 'Gray'}
        Function = @{Color = 'DarkYellow'}
        Registry = @{Color = 'DarkBlue'}
        Variable = @{Color = 'Cyan'}
        WSMan = @{Color = 'Blue'}
        Default = @{Color = 'White'}
        LowSpace = @{Color = 'Red'}
        LowSpacePercent = @{Value = 20}
    }
    CommandInfo = @{
        Default = @{Color = 'White'}
        Alias = @{Color = 'Green'}
        Script = @{Color = 'DarkBlue'}
        Function = @{Color = 'Yellow'}
        CommandLet = @{Color = 'Cyan'}
        Application = @{Color = 'Gray'}
        RemoteCommand = @{Color = 'DarkGray'}
        ExternalScript = @{Color = 'DarkGreen'}
    }
}