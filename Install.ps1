if ((get-module PoshColor) -ne $null)
{
    ## Uninstall the existing Version
    Remove-Module PoshColor
}

$modulePath = $env:PSModulePath.Split([IO.Path]::PathSeparator)[0]

$modulePath = Join-Path $modulePath "PoshColor"

if ((Test-Path $modulePath) -eq $false)
{
    New-Item $modulePath -Type Directory    
}

$poshColorModule = Join-Path . "src"
$poshColorModule = Join-Path $poshColorModule "PoshColor.psd1"

$module = (Get-Module $poshColorModule -ListAvailable)

Write-Host $module.Version

$major = $module.Version.Major.ToString()
$minor = $module.Version.Minor.ToString()
$build = $module.Version.Build.ToString()
$revision = $module.Version.Revision.ToString()

$version = $major + "." + $minor + "." + $build + "." + $revision

$modulePath = Join-Path $modulePath $version

if ((Test-Path $modulePath) -eq $false)
{
    Write-Host "Creating Module Path $modulePath"

    New-Item $modulePath -Type Directory
}

$moduleSource = Join-Path "." "src"
$moduleSource = Join-Path $moduleSource "*"

copy-item $moduleSource $modulePath -Recurse -Force

Import-Module PoshColor