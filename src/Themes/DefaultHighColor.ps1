$global:PSColorizer = @{
    UseConsoleColors = $false
    DirectoryForeground = '#00bb00'
    File = [ordered]@{
        HiddenDirectory = @{ Color = '#505050'; Hidden = $true; Directory = $true; BackgroundColor = '#dddddd' } 
        CompressedDirectory = @{ Color = '#881010'; Compressed =  $true}
        Hidden     = @{ Color = '#505050'; Hidden = $true } 
        IgnoreFiles= @{ Color = '#909090'; Pattern = '^\.' }
        Code       = @{ Color = '#aa11aa'; Pattern = '\.(java|c|cpp|cs|js|css|html)$' }
        Executable = @{ Color = '#11cc11'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|ps1|sh)$' }
        Text       = @{ Color = '#dddd00'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
        Compressed = @{ Color = '#bb00bb'; Pattern = '\.(zip|tar|gz|rar|jar|war)$' }
        Directory  = @{ Color = '#00aadd'; Directory = $true}
        System     = @{ Color = '#006600'; System = $true}
        Default    = @{ Color = '#dddddd' }
    }
    Service = @{
        Running = @{ Color = "#00bb00"}
        Stopped = @{ Color = "#dd0000"}
        Default = @{ Color = "#505050"}
        Properties = @{ Color = '#dddddd'}
    }
    Match = @{
        Default = @{Color = '#cccccc'}
        MatchText = @{ Color = '#00aadd'}
        Match = @{Color = '#dddddd'}
        LineNumber = @{Color = '#ff0000'}
        File = @{Color = '#00bb00'}
    }
    Module = @{
        Binary = @{Color = '#dddddd'}
        Cim = @{Color = '#00aadd'}
        Manifest = @{Color = '#11cc11'}
        Script = @{Color = '#dddd00'}
        Workflow = @{Color = '#bb00bb'}
    }
    EventLog = @{
        Critical = @{Color = '#aa11aa'}
        Error  = @{Color = '#dd0000'}
        Warning = @{Color = '#dddd00'}
        Information = @{Color = '#cccccc'}
        Default = @{Color = '#dddddd'}
    }
}