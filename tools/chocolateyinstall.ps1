$ErrorActionPreference = 'Stop';

$packageName= 'prometheus-windows-exporter.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version    = "0.30.1"
$url64      = "https://github.com/prometheus-community/windows_exporter/releases/download/v$version/windows_exporter-$version-amd64.msi"

$pp = Get-PackageParameters

$silentArgs = "/quiet /norestart /l*v `"$($env:TEMP)\$($packageName).$($version).MsiInstall.log`""

if ($pp["EnabledCollectors"] -ne $null -and $pp["EnabledCollectors"] -ne '') {
  $silentArgs += " ENABLED_COLLECTORS=$($pp["EnabledCollectors"])"
  Write-Host "Collectors: `'$($pp["EnabledCollectors"])`'"
}

if ($pp["ConfigFile"] -ne $null -and $pp["ConfigFile"] -ne '') {
  $silentArgs += " CONFIG_FILE=$($pp["ConfigFile"])"
  Write-Host "Config File: `'$($pp["ConfigFile"])`'"
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

if ($pp["TextFileDirs"] -ne $null -and $pp["TextFileDirs"] -ne '') {
  $silentArgs += " TEXTFILE_DIRS=$($pp["TextFileDirs"])"
  Write-Host "Textfile Directories: `'$($pp["TextFileDirs"])`'"

} elseif ($pp["TextFileDir"] -ne $null -and $pp["TextFileDir"] -ne '') {
  $silentArgs += " TEXTFILE_DIRS=$($pp["TextFileDir"])"
  Write-Host "Textfile Directories: `'$($pp["TextFileDir"])`'"
}

if ($pp["RemoteAddresses"] -ne $null -and $pp["RemoteAddresses"] -ne '') {
  $silentArgs += " REMOTE_ADDR=$($pp["RemoteAddresses"])"
  Write-Host "Remote Addresses: `'$($pp["RemoteAddresses"])`'"
}

if ($pp["ExtraFlags"] -ne $null -and $pp["ExtraFlags"] -ne '') {
  $silentArgs += " EXTRA_FLAGS=`"$($pp["ExtraFlags"])`""
  Write-Host "Extra Flags: `'$($pp["ExtraFlags"])`'"
}

if ($pp["AddLocal"] -ne $null -and $pp["AddLocal"] -ne '') {
  $silentArgs += " ADDLOCAL=`"$($pp["AddLocal"])`""
  Write-Host "Add Local: `'$($pp["AddLocal"])`'"
}

if ($pp["Remove"] -ne $null -and $pp["Remove"] -ne '') {
  $silentArgs += " REMOVE=`"$($pp["Remove"])`""
  Write-Host "Remove: `'$($pp["Remove"])`'"
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url64bit      = $url64

  softwareName  = 'windows_exporter*'

  checksum64    = 'FB43DB2B2168DCBBF3F689697C0EF139EA08888A0C873F93B28CA33D76EB3BF2'
  checksumType64= 'sha256'

  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
