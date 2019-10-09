$global:PSColorizer = @{
    UseConsoleColors = $false
    DirectoryForeground = '#00bb00'
    File = [ordered]@{
        HiddenDirectory = @{ Color = '#505050'; Hidden = $true; Directory = $true; BackgroundColor = '#dddddd' } 
        CompressedDirectory = @{ Color = '#00f1f1'; Compressed =  $true}
        Hidden     = @{ Color = '#505050'; Hidden = $true } 
        IgnoreFiles= @{ Color = '#909090'; Pattern = '^\.' }
        Code       = @{ Color = '#0011ff'; Pattern = '\.(java|c|cpp|cs|js|css|html)$' }
        Executable = @{ Color = '#11cc11'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|ps1|sh)$' }
        Text       = @{ Color = '#dddd00'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
        Compressed = @{ Color = '#00ffaa'; Pattern = '\.(zip|tar|gz|rar|jar|war)$' }
        Directory  = @{ Color = '#00aadd'; Directory = $true}
        System     = @{ Color = '#006600'; System = $true}
        Default    = @{ Color = '#dddddd' }
    }
    Service = @{
        Running = @{ Color = "#00bb00"}
        Stopped = @{ Color = "#00aadd"}
        Default = @{ Color = "#505050"}
        Properties = @{ Color = '#dddddd'}
    }
    Match = @{
        Default = @{Color = '#cccccc'}
        MatchText = @{ Color = '#00aadd'}
        Match = @{Color = '#dddddd'}
        LineNumber = @{Color = '#0055aa'}
        File = @{Color = '#00bb00'}
    }
}