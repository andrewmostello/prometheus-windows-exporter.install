$ErrorActionPreference = 'Stop';

$packageName= 'prometheus-windows-exporter.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/prometheus-community/windows_exporter/releases/download/v0.13.0/windows_exporter-0.13.0-386.msi'
$url64      = 'https://github.com/prometheus-community/windows_exporter/releases/download/v0.13.0/windows_exporter-0.13.0-amd64.msi'

$pp = Get-PackageParameters

$silentArgs = "/quiet /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""

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

  checksum      = '6F5BF52A3DB999F4B4C8B9E96FD2329F0CFAE0C547D39AD645E167145E0EA62C'
  checksumType  = 'sha256'
  checksum64    = '6E5C67A8648823A80931A915590731D33D435F8A10A9EB8A7DCE087AE473ED9A'
  checksumType64= 'sha256'

  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
