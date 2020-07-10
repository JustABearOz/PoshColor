
function Write-MatchContext
{
    param ([Parameter(Position=1,Mandatory=$true)]$context,[Parameter(Position=2,Mandatory=$true)]$relativePath, [Parameter(Position=3,Mandatory=$true)]$lineNumber,
        [Switch]$printFile)

    if ($printFile)
    {
        Write-HostColor " $relativePath" $global:PoshColor.Match.File.Color -Background $global:PoshColor.Match.File.BackgroundColor
    }

    $currentLineNumber = $lineNumber

    $context | ForEach-Object {
        Write-HostColor "   Line: " -Foreground $global:PoshColor.Match.Default.Color -Background $global:PoshColor.Match.Default.BackgroundColor -NoNewline
        Write-HostColor (Pad $currentLineNumber 6) -Foreground $global:PoshColor.Match.LineNumber.Color -Background $global:PoshColor.Match.LineNumber.BackgroundColor -NoNewline
        Write-HostColor "$_" -Foreground $global:PoshColor.Match.Match.Color -Background $global:PoshColor.Match.Match.BackgroundColor
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
                Foreground=$global:PoshColor.Match.Match.Color
                Background=$global:PoshColor.Match.Match.BackgroundColor
            })
        }

        $items.Insert(0, @{
            Text = $_.Value
            Foreground=$global:PoshColor.Match.MatchText.Color
            Background=$global:PoshColor.Match.MatchText.BackgroundColor
        })
        
        $itemText = $itemText.Substring(0, $_.Index)
    }


    if ($itemText.Length -gt 0)
    {
        $items.Insert(0, @{
            Text = $itemText
            Foreground=$global:PoshColor.Match.Match.Color
            Background=$global:PoshColor.Match.Match.BackgroundColor
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

        Write-HostColor '-> Line: ' -Foreground $global:PoshColor.Match.Default.Color -Background $global:PoshColor.Match.Default.BackgroundColor -noNewLine
        Write-HostColor (Pad $item.LineNumber 6) -Foreground $global:PoshColor.Match.LineNumber.Color -Background $global:PoshColor.Match.LineNumber.BackgroundColor -noNewLine
        Write-MatchItem $item.Line $item.Matches

        Write-MatchContext $item.Context.DisplayPostContext  $item.RelativePath($pwd) ($item.LineNumber + 1)
    }
    else {
        Write-HostColor '-> Line: ' -Foreground $global:PoshColor.Match.Default.Color -Background $global:PoshColor.Match.Default.BackgroundColor -NoNewline
        Write-HostColor (Pad $item.LineNumber 6) -Foreground $global:PoshColor.Match.LineNumber.Color -Background $global:PoshColor.Match.LineNumber.BackgroundColor -noNewLine
        Write-HostColor $item.RelativePath($pwd) -Foreground $global:PoshColor.Match.File.Color -Background $global:PoshColor.Match.File.BackgroundColor -noNewLine
        Write-HostColor ': ' -Foreground  $global:PoshColor.Match.Default.Color -Background $global:PoshColor.Match.Default.BackgroundColor -noNewLine
        Write-MatchItem $item.Line $item.Matches
    }
    return $true;
}