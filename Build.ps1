function ZipFiles( $zipfilename, $sourcedir )
{
   Add-Type -Assembly System.IO.Compression.FileSystem

   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal

   [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir, $zipfilename, $compressionLevel, $false)
}

$Error.Clear()

$source = "$PSScriptRoot\src"
$target = "$PSScriptRoot\release"

if (!(Test-Path $target))
{
    
    Write-Host "Creating Release Directory"

    New-Item $target -type Directory
}
else
{
    Write-Host "Cleaning Release directory"

    remove-item $target\* -recurse -force
}

$targetfile = "$target\PSColorizer.zip"

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