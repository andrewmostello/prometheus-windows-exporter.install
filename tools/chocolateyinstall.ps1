$ErrorActionPreference = 'Stop';

$packageName= 'prometheus-windows-exporter.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version    = "0.31.9"

# Select the MSI for the native OS architecture. The process environment can report an
# emulated architecture (e.g. AMD64 under x64 emulation on ARM64), so prefer the system value.
$osArchitecture = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name 'PROCESSOR_ARCHITECTURE' -ErrorAction SilentlyContinue).PROCESSOR_ARCHITECTURE
if (-not $osArchitecture) { $osArchitecture = $env:PROCESSOR_ARCHITEW6432 }
if (-not $osArchitecture) { $osArchitecture = $env:PROCESSOR_ARCHITECTURE }

switch ($osArchitecture) {
  'AMD64' {
    $url      = "https://github.com/prometheus-community/windows_exporter/releases/download/v$version/windows_exporter-$version-amd64.msi"
    $checksum = '1E8A3898E8FEBAA475E008FFD2E729E1BEF84ECBCB6875910546EE0798E96126'
  }
  'ARM64' {
    $url      = "https://github.com/prometheus-community/windows_exporter/releases/download/v$version/windows_exporter-$version-arm64.msi"
    $checksum = 'ED3F9A5F55764C1FEC5086F70310209C860519F74F12F57E55574C8E46B58D34'
  }
  default {
    throw "windows_exporter $version is only available for AMD64 and ARM64 Windows. Detected OS architecture: '$osArchitecture'."
  }
}

# There is no 32-bit build. Fail on --x86 as before instead of installing the 64-bit MSI.
if ($env:chocolateyForceX86) {
  throw "windows_exporter $version is not available for 32-bit (x86). Install it without --x86."
}

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
  # Not url64bit: Chocolatey treats ARM64 as 32-bit and would not use url64bit there.
  url           = $url

  softwareName  = 'windows_exporter*'

  checksum      = $checksum
  checksumType  = 'sha256'

  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
