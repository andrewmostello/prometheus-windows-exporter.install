# Prometheus Windows Exporter Chocolatey Package

## Contents

Chocolatey scripts to install the Prometheus exporter for Windows machines

## Description

The scripts in this package are used by Chocolatey, the package manager for Windows. This repository _only_ contains said
Chocolatey scripts. The exporter itself is maintained at the project page here:
[https://github.com/prometheus-community/windows_exporter/](https://github.com/prometheus-community/windows_exporter/)

The current package version installs windows_exporter
[v0.31.9](https://github.com/prometheus-community/windows_exporter/releases/tag/v0.31.9). It downloads the official MSI
for the native OS architecture, AMD64 (x64) or ARM64, verifies its SHA256 checksum and installs the `windows_exporter`
Windows service. Other architectures, such as 32-bit Windows, are not supported.

See [https://chocolatey.org/packages/prometheus-windows-exporter.install](https://chocolatey.org/packages/prometheus-windows-exporter.install) for details on Chocolatey and usage.

## Tl;dr Usage

To install the exporter with chocolatey, run:

`choco install prometheus-windows-exporter.install`

To upgrade or uninstall it, run:

`choco upgrade prometheus-windows-exporter.install`

`choco uninstall prometheus-windows-exporter.install`

## Package Parameters

| Parameter           | Description |
|---------------------|-------------|
| `EnabledCollectors` | Comma-separated list of enabled collectors, as the `--collectors.enabled` flag. |
| `ConfigFile`        | Config file for the `--config.file` flag. If empty or set to the special value `config.yaml`, the `config.yaml` in the install directory is used. Any other config file must exist before the installation is started. |
| `ListenAddress`     | IP address to bind to. Defaults to an empty string (any local address). |
| `ListenPort`        | Port to bind to. Defaults to `9182`. |
| `MetricsPath`       | Path at which to serve metrics. Defaults to `/metrics`. |
| `TextFileDirs`      | Comma-separated directories from which the textfile collector reads metrics, as the `--collector.textfile.directories` flag. |
| `TextFileDir`       | Alternative to `TextFileDirs`, provided for backwards compatibility. |
| `RemoteAddresses`   | Comma-separated remote IP addresses allowed by the Windows Firewall exception. Defaults to an empty string (any remote address). |
| `ExtraFlags`        | Additional exporter CLI flags. For `--collectors.enabled` and `--config.file`, use `EnabledCollectors` and `ConfigFile` instead. |
| `AddLocal`          | Enables installer features. Supported values: `FirewallException`. |
| `Remove`            | Disables installer features. Supported values: `FirewallException`. |

Parameters are passed with `--params`. For example, to enable the CPU, logical disk and memory collectors:

`choco install prometheus-windows-exporter.install --params '"/EnabledCollectors:cpu,logical_disk,memory /ListenPort:9182"'`

`choco upgrade` only reuses the parameters of the original installation when Chocolatey's
`useRememberedArgumentsForUpgrades` feature is enabled. Otherwise, pass them again when upgrading.

## Upgrading from 0.30.x

windows_exporter 0.31.0 removed the `cs` and `logon` collectors and support for remote (HTTP/HTTPS) config files, and
config files are now validated strictly. The service will not start if removed options are still in use, so check your
package parameters and config file against the
[v0.31.0 release notes](https://github.com/prometheus-community/windows_exporter/releases/tag/v0.31.0) before upgrading.

## More Information

- [Collectors](https://github.com/prometheus-community/windows_exporter/blob/v0.31.9/README.md#collectors), including those enabled by default
- [windows_exporter documentation](https://github.com/prometheus-community/windows_exporter/blob/v0.31.9/README.md)
- [windows_exporter v0.31.9 release notes](https://github.com/prometheus-community/windows_exporter/releases/tag/v0.31.9)
