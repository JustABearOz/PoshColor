$modulePath = $env:PSModulePath.Split([IO.Path]::PathSeparator)[0]

$modulePath = Join-Path $modulePath "PSColorizer"

if ((Test-Path $modulePath) -eq $false)
{
    New-Item $modulePath -Type Directory
}

$psColorizerModule = Join-Path . "src"
$psColorizerModule = Join-Path psColorizerModule "PSColorizer.psd1"

$module = (Get-Module $psColorizerModule -ListAvailable)

$major = $module.Version.Major.ToString()
$minor = $module.Version.Minor.ToString()
$build = $module.Version.Build.ToString()
$revision = $module.Version.Revision.ToString()

$version = $major + "." + $minor + "." + $build + "." + $revision

$modulePath = Join-Path $modulePath $version

if ((Test-Path $modulePath) -eq $false)
{
    New-Item $modulePath -Type Directory
}

copy-item .\src\* $modulePath -Recurse -Force

$moduleFile = Join-Path $modulePath "PSColorizer.psd1"

Import-Module $moduleFile