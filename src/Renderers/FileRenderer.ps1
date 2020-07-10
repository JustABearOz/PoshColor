
function Write-FileHeader
{
    param ([Parameter(Mandatory=$True,Position=1)] $item)

    if($item -is [System.IO.DirectoryInfo])
    {
        $itemPath = $item.Parent.ToString()
        
        # GetRootedPath will cause an exception if $itemPath is a root directory
        try
        {
            # If running on .net framework, the above statement returns a relative path
            # remove the item name from the full name to get the full parent path
            if ([System.IO.Path]::GetPathRoot($itemPath) -eq "" )
            {
                $replaceName = $item.Name;
                $replaceName = "\" + $replaceName

                $itemPath = $item.FullName.Replace($replaceName, "" )
            }
        }   
        catch
        {
            $replaceName = $item.Name;

            $itemPath = $item.FullName.Replace($replaceName, "" )
        }
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
        if ($global:PoshColor.DirectoryForeground)
        {
            Write-Host "Directory: " -NoNewline

            # Use console colors?
            if ($global:PoshColor.UseConsoleColors)
            {
                Write-Host $script:currentDirectory -ForegroundColor $global:PoshColor.DirectoryForeground
            }
            else {
                Write-HostColor $script:currentDirectory $global:PoshColor.DirectoryForeground
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

    foreach($filterKey in $global:PoshColor.File.Keys)
    {
        $match = $true;

        $filter = $global:PoshColor.File.Item($filterKey)

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