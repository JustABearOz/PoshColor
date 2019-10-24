$modulePath = $env:PSModulePath.Split(";")[0]

$modulePath = Join-Path $modulePath "PSColorizer"

if ((Test-Path $modulePath) -eq $false)
{
    New-Item $modulePath -Type Directory
}

$module = (Get-Module .\src\PSColorizer.psd1 -ListAvailable)

$major = $module.Version.Major.ToString()
$minor = $module.Version.Minor.ToString()
$build = $module.Version.Build.ToString()
$revision = $module.Version.Revision.ToString()

$version = $major + "." + $minor + "." + $build + "." + $revision

$modulePath = [System.IO.Path]::Join($modulePath, $version)

if ((Test-Path $modulePath) -eq $false)
{
    New-Item $modulePath -Type Directory
}

copy-item .\src\* $modulePath -Recurse -Force

$moduleFile = Join-Path $modulePath "PSColorizer.psd1"

Import-Module $moduleFile