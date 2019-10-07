$modulePath = $env:psmodulePath.Split(";")[0]

$modulePath = [System.IO.Path]::Join($modulePath, "PSColorizer")

if ((Test-Path $modulePath) -eq $false)
{
    New-Item $modulePath -Type Directory
}

$module = (Get-Module .\PSColorizer.psd1 -ListAvailable)

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

copy-item * $modulePath -Recurse -Exclude @("Install.ps1", "README.md", "LICENCE") -Force

Import-Module "$modulePath\PSColorizer.psd1"