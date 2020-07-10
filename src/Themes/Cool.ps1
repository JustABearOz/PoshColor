$global:PoshColor = @{
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
    PSDriveInfo = @{
        Alias = @{Color = '#909090'}
        FileSystem = @{Color = '#11cc11'}
        Certificate = @{Color = '#909090'}
        Environment = @{Color = '#909090'}
        Function = @{Color = '#00aadd'}
        Registry = @{Color = '#0055aa'}
        Variable = @{Color = '#00bb00'}
        WSMan = @{Color = '#909090'}
        Default = @{Color = '#dddddd'}
        LowSpace = @{Color = '#00f1f1'}
        LowSpacePercent = @{Value = 20}
    }
    CommandInfo = @{
        Default = @{Color = '#dddddd'}
        Alias = @{Color = '#00aadd'}
        Script = @{Color = '#0055aa'}
        Function = @{Color = '#11cc11'}
        CommandLet = @{Color = '#00f1f1'}
        Application = @{Color = '#dddddd'}
        RemoteCommand = @{Color = '#909090'}
        ExternalScript = @{Color = '#00bb00'}
    }
    PSMemberType = @{
        Default = @{Color = '#dddddd'}

        Property = @{Color = '#55aa55'}
        PropertySet = @{Color = '#008800'}
        Properties = @{Color = '#00aa00'}
        AliasProperty = @{Color = '#00cc00'}
        CodeProperty = @{Color = '#00ee00'}
        ParameterizedProperty = @{Color = '#22ff22'}
        ScriptProperty = @{Color = '#66ff66'}
        InferredProperty = @{Color = '#88ff55'}
        Event = @{Color = '#dddddd'}
        MemberSet = @{Color = '#909090'}
        NoteProperty = @{Color = '#00f1f1'}
        Method = @{Color = '#0055ff'}
        Methods = @{Color = '#0000dd'}
        ScriptMethod = @{Color = '#0000ff'}
        CodeMethod = @{Color = '#0055aa'}
        Dynamic = @{Color = '#5555aa'}
    }
}