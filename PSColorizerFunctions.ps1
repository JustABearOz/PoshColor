function Pad
{
    param([System.String] $value, [System.Int32] $length)

    return $value.PadRight($length)
}
function New-ColorVTSequence
{
    param([System.String] $value)

    $color = [System.Drawing.ColorTranslator]::FromHtml($value)

    $r = $color.R;
    $g = $color.G;
    $b = $color.B;

    return "$r;$g;$b";
}

function New-ForegroundVTSequence
{
    param([System.String] $hexColor)

    $rgbSequence = New-ColorVTSequence -value $hexColor

    return "38;2;$rgbSequence"
}

function New-BackgroundVTSequence
{
    param([System.String] $hexColor)

    $rgbSequence = New-ColorVTSequence -value $hexColor

    return "48;2;$rgbSequence"
}

function New-TextColorVTSequence{
    param([System.String] $foregroundHexColor, [System.String] $backgroundHexColor)

    $result = New-ColorVTSequence -value $foregroundHexColor

    if ($backgroundHexColor)
    {
        $backgroundSequence = New-ColorVTSequence -value $backgroundHexColor

        $result = "$result;$backgroundSequence";
    }

    return "$result" + "m"
}

function Write-HostColor
{
    param ([Parameter(Position=0)] [System.String] $text, [Parameter(Position=1)][System.String] $foreground,  [System.String] $background, [switch] $noNewLine = $false)

    if ($global:PSColorizer.UseConsoleColors)
    {
        if ($background)
        {
            if ($noNewLine)
            {
                Write-Host $text -ForegroundColor $foreground -BackgroundColor $background -NoNewline
            }
            else {
                Write-Host $text -ForegroundColor $foreground -BackgroundColor $background
            }
        }
        else {
            if ($noNewLine)
            {
                Write-Host $text -ForegroundColor $foreground -NoNewline
            }
            else {
                Write-Host $text -ForegroundColor $foreground
            }
        }
    }
    else {
        $foregroundSequence = New-ForegroundVTSequence -hexColor $foreground

        if ($background)
        {
            $backgroundSequence = New-BackgroundVTSequence -hexColor $background
        }

        $vtSequence = "$foregroundSequence"

        if ($backgroundSequence)
        {
            $vtSequence = "$vtSequence;$backgroundSequence";
        }

        $vtSequence = "`e[$vtSequence" + "m"

        if ($noNewLine)
        {
            Write-Host "$vtSequence$text" -NoNewLine
        }
        else {
            Write-Host "$vtSequence$text"
        }
    }
}

function Write-FileHeader
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    if($item -is [System.IO.DirectoryInfo])
    {
        $itemPath = $item.Parent.ToString()
    }
    else
    {
        $itemPath = $item.Directory.ToString()
    }

    if (($script:currentDirectory -eq "") -or ($script:currentDirectory -ne $itemPath))
    {
        Write-Host
        $script:currentDirectory = $itemPath

        # Do we have a foregorund color configured?
        if ($global:PSColorizer.DirectoryForeground)
        {
            Write-Host "Directory: " -NoNewline

            # Use console colors?
            if ($global:PSColorizer.UseConsoleColors)
            {
                Write-Host $script:currentDirectory -ForegroundColor $global:PSColorizer.DirectoryForeground
            }
            else {
                Write-HostColor $script:currentDirectory $global:PSColorizer.DirectoryForeground
            }
        }
        else {
            Write-Host "Directory: $script:currentDirectory"
        }
        Write-Host
        Write-Host "Mode                LastWriteTime     Length Name"
        Write-Host "----                -------------     ------ ----"
    }
}

function Write-ServiceHeader
{
    if (($script:currentDirectory -eq ""))
    {
        Write-Host "Status   Name               DisplayName                            Startup"
        Write-Host "------   ----               -----------                            -------"

        $script:currentDirectory = "Services"
    }
}

function Trim
{
    param ([Parameter(Mandatory=$True,Position=1)][string] $text, [Parameter(Mandatory=$True,Position=2)][int] $length)

    if ($text.Length -gt $length)
    {
        $text = $text.Substring(0, $length - 3) + "..."
    }

    return $text;
}

function Write_Service
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    Write-ServiceHeader

    $trimmedName = Trim $item.Name 18
    $trimmedDisplayName = Trim $item.DisplayName 38
    $status = $item.Status
    $startup = Trim $item.StartupType 20

    $foreground = $global:PSColorizer.Service.Default.Color
    $background = $global:PSColorizer.Service.Default.BackgroundColor

    if ($item.Status -eq 'Running')
    {
        $foreground = $global:PSColorizer.Service.Running.Color
        $background = $global:PSColorizer.Service.Running.BackgroundColor
    }
    elseif ($item.Status -eq 'Stopped')
    {
        $foreground = $global:PSColorizer.Service.Stopped.Color
        $background = $global:PSColorizer.Service.Stopped.BackgroundColor
    }

    $statusText = [String]::Format("{0, -8}", $status)
    $outputText = [String]::Format(" {0, -18} {1, -38} {2, -20}", $trimmedName, $trimmedDisplayName, $startup)

    Write-HostColor $statusText -Foreground $foreground -Background $background -noNewLine
    Write-HostColor $outputText -Foreground $global:PSColorizer.Service.Properties.Color -Background $global:PSColorizer.Service.Properties.BackgroundColor

    return $true
}

function Write-File
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    Write-FileHeader $item

    $isDirectory = $item.GetType() -eq [System.IO.DirectoryInfo]

    $isHidden = $item.Attributes.HasFlag([System.IO.FileAttributes]::Hidden)
    $isSystem = $item.Attributes.HasFlag([System.IO.FileAttributes]::System)
    $isEncrypted = $item.Attributes.HasFlag([System.IO.FileAttributes]::Encrypted)
    $isCompressed = $item.Attributes.HasFlag([System.IO.FileAttributes]::Compressed)

    $outputColor = "White"

    $length = ""

    if ($isDirectory -eq $false)
    {
        $length = $item.Length
    }

    foreach($filterKey in $global:PSColorizer.File.Keys)
    {
        $match = $true;

        $filter = $global:PSColorizer.File.Item($filterKey)

        if (($filter.Directory -eq $true) -and $isDirectory -eq $false)
        {
            $match = $false
        }

        if (($filter.Hidden -eq $true) -and $isHidden -eq $false)
        {
            $match = $false
        }

        if ($filter.Compressed -eq $true -and $isCompressed -eq $false)
        {
            $match = $false
        }

        if ($filter.Encrypted -eq $true -and $isEncrypted -eq $false)
        {
            $match = $false
        }

        if ($filter.System -eq $true -and $isSystem -eq $false)
        {
            $match = $false
        }

        if ($match -and $filter.Pattern)
        {
            $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

            $regex = New-Object System.Text.RegularExpressions.Regex($filter.Pattern, $regex_opts)

            if ($regex.IsMatch($item.Name) -eq $false)
            {
                $match = $false
            }
        }

        if ($match -eq $true)
        {
            $outputColor = $filter.Color

            $backgroundColor = $filter.BackgroundColor

            break
        }
    }

    $lastWriteDate = $item.LastWriteTime.ToString("d")
    $lastWriteTime = $item.LastWriteTime.ToString("t")
    $lastWrite = [String]::Format("{0,10}  {1,8}", $lastWriteDate, $lastWriteTime)

    $outputText = [System.String]::Format("{0,-7} {1,25} {2,10} {3}", $item.mode, $lastWrite, $length, $item.name)

    Write-HostColor $outputText $outputColor -Background $backgroundColor

    return $true
}

function Write-MatchContext
{
    param ([Parameter(Position=1,Mandatory=$true)]$context,[Parameter(Position=2,Mandatory=$true)]$relativePath, [Parameter(Position=3,Mandatory=$true)]$lineNumber,
        [Switch]$printFile)

    if ($printFile)
    {
        Write-HostColor " $relativePath" $global:PSColorizer.Match.File.Color -Background $global:PSColorizer.Match.File.BackgroundColor
    }

    $currentLineNumber = $lineNumber

    $context | ForEach-Object {
        Write-HostColor "   Line: " -Foreground $global:PSColorizer.Match.Default.Color -Background $global:PSColorizer.Match.Default.BackgroundColor -NoNewline
        Write-HostColor (Pad $currentLineNumber 6) -Foreground $global:PSColorizer.Match.LineNumber.Color -Background $global:PSColorizer.Match.LineNumber.BackgroundColor -NoNewline
        Write-HostColor "$_" -Foreground $global:PSColorizer.Match.Match.Color -Background $global:PSColorizer.Match.Match.BackgroundColor
        $currentLineNumber = $currentLineNumber + 1
    }
}

function Write-MatchItem
{
    [CmdletBinding()]
    param (
        [Parameter(Position=1,Mandatory=$true)] [string] $line,
        [Parameter(Position=2,Mandatory=$true)] $matches
    )

    $itemText = $line

    $items = New-Object "System.Collections.Generic.List[object]"      

    # Reverse the array and work backwards to avoid causing issues with the index of the matches
    [array]::Reverse($matches)

    $matches | foreach-object {   
        $nonMatchIndex = $_.Index + $_.Length

        # Append whatever text is after the match
        if ($nonMatchIndex -lt $itemText.Length)
        {
            $newTextPart = $itemText.Substring($nonMatchIndex)

            $items.Insert(0, @{
                Text = $newTextPart
                Foreground=$global:PSColorizer.Match.Match.Color
                Background=$global:PSColorizer.Match.Match.BackgroundColor
            })
        }

        $items.Insert(0, @{
            Text = $_.Value
            Foreground=$global:PSColorizer.Match.MatchText.Color
            Background=$global:PSColorizer.Match.MatchText.BackgroundColor
        })
        
        $itemText = $itemText.Substring(0, $_.Index)
    }


    if ($itemText.Length -gt 0)
    {
        $items.Insert(0, @{
            Text = $itemText
            Foreground=$global:PSColorizer.Match.Match.Color
            Background=$global:PSColorizer.Match.Match.BackgroundColor
        })
    }

    $items | ForEach-Object{
        Write-HostColor $_.Text $_.Foreground -Background $_.Background -noNewLine
    }
    
    # newline
    Write-Host
}

function Write-Match
{
    param ([Parameter(Position=1, Mandatory=$true)][Microsoft.Powershell.Commands.MatchInfo]$item)

    if ($item.Context)
    {
        Write-MatchContext $item.Context.DisplayPreContext  $item.RelativePath($pwd) ($item.LineNumber - $item.Context.DisplayPreContext.Count) -PrintFile

        Write-HostColor '>> Line: ' -Foreground $global:PSColorizer.Match.Default.Color -Background $global:PSColorizer.Match.Default.BackgroundColor -noNewLine
        Write-HostColor (Pad $item.LineNumber 6) -Foreground $global:PSColorizer.Match.LineNumber.Color -Background $global:PSColorizer.Match.LineNumber.BackgroundColor -noNewLine
        Write-MatchItem $item.Line $item.Matches

        Write-MatchContext $item.Context.DisplayPostContext  $item.RelativePath($pwd) ($item.LineNumber + 1)
    }
    else {
        Write-HostColor '>> Line: ' -Foreground $global:PSColorizer.Match.Default.Color -Background $global:PSColorizer.Match.Default.BackgroundColor -NoNewline
        Write-HostColor (Pad $item.LineNumber 6) -Foreground $global:PSColorizer.Match.LineNumber.Color -Background $global:PSColorizer.Match.LineNumber.BackgroundColor -noNewLine
        Write-HostColor $item.RelativePath($pwd) -Foreground $global:PSColorizer.Match.File.Color -Background $global:PSColorizer.Match.File.BackgroundColor -noNewLine
        Write-HostColor ':' -Foreground  $global:PSColorizer.Match.Default.Color -Background $global:PSColorizer.Match.Default.BackgroundColor -noNewLine
        Write-MatchItem $item.Line $item.Matches
    }
    return $true;
}
# return test return test return