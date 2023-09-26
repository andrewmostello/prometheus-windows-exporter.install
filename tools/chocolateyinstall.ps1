$ErrorActionPreference = 'Stop';

$packageName= 'prometheus-windows-exporter.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version    = "$($env:chocolateyPackageVersion)"
$url        = "https://github.com/prometheus-community/windows_exporter/releases/download/v$version/windows_exporter-$version-386.msi"
$url64      = "https://github.com/prometheus-community/windows_exporter/releases/download/v$version/windows_exporter-$version-amd64.msi"

$pp = Get-PackageParameters

$silentArgs = "/quiet /norestart /l*v `"$($env:TEMP)\$($packageName).$($version).MsiInstall.log`""

if ($pp["EnabledCollectors"] -ne $null -and $pp["EnabledCollectors"] -ne '') {
  $silentArgs += " ENABLED_COLLECTORS=$($pp["EnabledCollectors"])"
  Write-Host "Collectors: `'$($pp["EnabledCollectors"])`'"
}

if ($pp["ListenAddress"] -ne $null -and $pp["ListenAddress"] -ne '') {
  $silentArgs += " LISTEN_ADDR=$($pp["ListenAddress"])"
  Write-Host "Listen Address: `'$($pp["ListenAddress"])`'"
}

if ($pp["ListenPort"] -ne $null -and $pp["ListenPort"] -ne '') {
  $silentArgs += " LISTEN_PORT=$($pp["ListenPort"])"
  Write-Host "Listen Port: `'$($pp["ListenPort"])`'"
}

if ($pp["MetricsPath"] -ne $null -and $pp["MetricsPath"] -ne '') {
  $silentArgs += " METRICS_PATH=$($pp["MetricsPath"])"
  Write-Host "Metrics Path: `'$($pp["MetricsPath"])`'"
}

if ($pp["TextFileDir"] -ne $null -and $pp["TextFileDir"] -ne '') {
  $silentArgs += " TEXTFILE_DIR=$($pp["TextFileDir"])"
  Write-Host "Textfile Directory: `'$($pp["TextFileDir"])`'"
}

if ($pp["RemoteAddresses"] -ne $null -and $pp["RemoteAddresses"] -ne '') {
  $silentArgs += " REMOTE_ADDR=$($pp["RemoteAddresses"])"
  Write-Host "Remote Addresses: `'$($pp["RemoteAddresses"])`'"
}

if ($pp["ExtraFlags"] -ne $null -and $pp["ExtraFlags"] -ne '') {
  $silentArgs += " EXTRA_FLAGS=$($pp["ExtraFlags"])"
  Write-Host "Extra flags: `'$($pp["ExtraFlags"])`'"
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  softwareName  = 'windows_exporter*'

  checksum      = '40800a32e607ab0e82c7f9b75bfa4c2950e0d14d11b48b4bd58d3d1d2efd6b25'
  checksumType  = 'sha256'
  checksum64    = 'd448329ac9c89e7e71d4f6a3ad111c1c61b58a17683852deb6292813b58ed62c'
  checksumType64= 'sha256'

  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
