$global:PSColorizer = @{
    UseConsoleColors = $false
    DirectoryForeground = '#00bb00'
    File = [ordered]@{
        HiddenDirectory = @{ Color = '#707070'; Hidden = $true; Directory = $true } 
        CompressedDirectory = @{ Color = '#00f1f1'; Compressed =  $true; Directory = $true }
        Hidden     = @{ Color = '#505050'; Hidden = $true } 
        IgnoreFiles= @{ Color = '#909090'; Pattern = '^\.' }
        Code       = @{ Color = '#0077cc'; Pattern = '\.(java|c|cpp|cs|js|css|html)$' }
        Executable = @{ Color = '#22ee22'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|ps1|sh)$' }
        Text       = @{ Color = '#119911'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
        Compressed = @{ Color = '#006699'; Pattern = '\.(zip|tar|gz|rar|jar|war)$' }
        Directory  = @{ Color = '#00aadd'; Directory = $true}
        System     = @{ Color = '#00ffaa'; System = $true}
        Default    = @{ Color = '#dddddd' }
    }
    Service = @{
        Running = @{ Color = '#00bb00'}
        Stopped = @{ Color = '#00aadd'}
        Default = @{ Color = '#505050'}
        Properties = @{ Color = '#dddddd'}
    }
    Match = @{
        Default = @{Color = '#cccccc'}
        MatchText = @{ Color = '#00aadd'}
        Match = @{Color = '#dddddd'}
        LineNumber = @{Color = '#0055aa'}
        File = @{Color = '#00bb00'}
    }
    Module = @{
        Default = @{Color = '#dddddd'}
        Binary = @{Color = '#cccccc'}
        Cim = @{Color = '#505050'}
        Manifest = @{Color = '#11cc11'}
        Script = @{Color = '#00aadd'}
        Workflow = @{Color = '#00ffaa'}
    }
    EventLog = @{
        Critical = @{Color = '#006699'}
        Error  = @{Color = '#00aadd'}
        Warning = @{Color = '#00ffaa'}
        Information = @{Color = '#cccccc'}
        Default = @{Color = '#909090'}
    }
}