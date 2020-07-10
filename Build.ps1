function ZipFiles( $zipfilename, $sourcedir )
{
   Add-Type -Assembly System.IO.Compression.FileSystem

   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal

   [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir, $zipfilename, $compressionLevel, $false)
}

$Error.Clear()

$source = Join-Path -Path $PSScriptRoot -ChildPath "src"
$target = Join-Path -Path $PSScriptRoot -ChildPath "release"

if (!(Test-Path $target))
{
    
    Write-Host "Creating Release Directory"

    New-Item $target -type Directory
}
else
{
    Write-Host "Cleaning Release directory"

    $removeItems = Join-Path $target "*"

    remove-item $removeItems -recurse -force
}

$targetfile = Join-Path -Path $target -ChildPath "PoshColor.zip"

Write-Host "Creating release package $targetfile" 

ZipFiles $targetfile $source

if ($Error.Count -eq 0)
{
    Write-Host "Build Succesful" -ForegroundColor Green
}
else
{
    Write-Host "One or more errors occured" -ForegroundColor Red
}

copy-item .\src\ .\release\PoshColor\ -recurse -container -force