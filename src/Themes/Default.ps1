$global:PSColorizer = @{
    UseConsoleColors = $true
    DirectoryForeground = 'Green'
    File = [ordered]@{
        HiddenDirectory = @{ Color = 'DarkGray'; Hidden = $true; Directory = $true; BackgroundColor = 'White' } 
        CompressedDirectory = @{ Color = 'DarkRed'; Compressed =  $true}
        Hidden     = @{ Color = 'DarkGray'; Hidden = $true } 
        IgnoreFiles= @{ Color = 'Gray'; Pattern = '^\.' }
        Code       = @{ Color = 'Magenta'; Pattern = '\.(java|c|cpp|cs|js|css|html)$' }
        Executable = @{ Color = 'Green'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|ps1|sh)$' }
        Text       = @{ Color = 'Yellow'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
        Compressed = @{ Color = 'Red'; Pattern = '\.(zip|tar|gz|rar|jar|war)$' }
        Directory  = @{ Color = 'Cyan'; Directory = $true}
        System     = @{ Color = 'DarkGreen'; System = $true}
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
        Certificate = @{Color = 'DarkGray'}
        Environment = @{Color = 'DarkGray'}
        Function = @{Color = 'Blue'}
        Registry = @{Color = 'DarkBlue'}
        Variable = @{Color = 'Cyan'}
        WSMan = @{Color = 'DarkGray'}
        Default = @{Color = 'Gray'}
        LowSpace = @{Color = 'Red'}
        LowSpacePercent = @{Value = 20}
    }
}