$ErrorActionPreference = 'Stop';

$packageName= 'prometheus-wmi-exporter.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/martinlindhe/wmi_exporter/releases/download/v0.5.0/wmi_exporter-0.5.0-386.msi'
$url64      = 'https://github.com/martinlindhe/wmi_exporter/releases/download/v0.5.0/wmi_exporter-0.5.0-amd64.msi'

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

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  softwareName  = 'WMI Exporter*'

  checksum      = '99284695B25D15DC27FDB3F41414553ADE153A599844BBA57F8FE6648FF44699'
  checksumType  = 'sha256'
  checksum64    = '7A63BF58CB249DE933D3C38C9CA3E22E3B0FA31BE22C12DB3A1AEEBE561DBBC8'
  checksumType64= 'sha256'

  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
