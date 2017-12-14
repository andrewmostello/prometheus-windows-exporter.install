$ErrorActionPreference = 'Stop';

$packageName= 'prometheus-wmi-exporter.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/martinlindhe/wmi_exporter/releases/download/v0.2.8/wmi_exporter-0.2.8-386.msi'
$url64      = 'https://github.com/martinlindhe/wmi_exporter/releases/download/v0.2.8/wmi_exporter-0.2.8-amd64.msi'

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

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  softwareName  = 'WMI Exporter*'

  checksum      = '2051954E416E2EDCA144CC4BC4E545B941A2EF1E84A008544AABB3C757FC9C1B'
  checksumType  = 'sha256'
  checksum64    = '918B860CCBD21DC31543733512F289E2C7B67F4AE9EBF4C11CE0E93F65677DF8'
  checksumType64= 'sha256'

  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
