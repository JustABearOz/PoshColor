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

function Trim
{
    param ([Parameter(Mandatory=$True,Position=1)][string] $text, [Parameter(Mandatory=$True,Position=2)][int] $length)

    if ($text.Length -gt $length)
    {
        $text = $text.Substring(0, $length - 3) + "..."
    }

    return $text;
}


# return test return test return