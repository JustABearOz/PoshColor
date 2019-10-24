$modulePath = $env:PSModulePath.Split([IO.Path]::PathSeparator)[0]

$modulePath = Join-Path $modulePath "PSColorizer"

if ((Test-Path $modulePath) -eq $false)
{
    New-Item $modulePath -Type Directory
}

$psColorizerModule = Join-Path . "src"
$psColorizerModule = Join-Path $psColorizerModule "PSColorizer.psd1"

$module = (Get-Module $psColorizerModule -ListAvailable)

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

Import-Module PSColorizer