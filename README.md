# NetboxTools

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/NetboxTools?label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/NetboxTools)

PowerShell module for the [NetBox](https://netboxlabs.com/) REST API, forked from [NetboxPS](https://github.com/benclaussen/NetboxPS) due to a stale project.

We will consider any issues/bugs reports as well as pull requests.

## Installation

The module is published on the [PowerShell Gallery](https://www.powershellgallery.com/packages/NetboxTools) and requires PowerShell 7.2 or later.

```powershell
Install-Module -Name NetboxTools -Scope CurrentUser
```

To try a preview version, when one is available:

```powershell
Install-Module -Name NetboxTools -Scope CurrentUser -AllowPrerelease
```

The cmdlets target the NetBox 4.x API and are verified against NetBox 4.7.

## Quick start

```powershell
# Connect with an API token (v1 tokens and v2 'nbt_' tokens are supported)
Connect-NbxAPI -Hostname 'netbox.example.com' -Token $Token

# Get objects: all, by ID, by name or with any filter supported by the API
Get-NbxDCIMDevice
Get-NbxDCIMDevice -Id 42
Get-NbxDCIMDevice -Name 'sw-core-01'
Get-NbxDCIMDevice -Query @{ site = 'stockholm'; status = 'active' } -Limit 10

# Create, update and remove objects
$Site = New-NbxDCIMSite -Name 'Stockholm DC 1' -Status active
$Device = New-NbxDCIMDevice -Name 'sw-core-01' -Site $Site -Role 1 -DeviceType 1
$Device | Set-NbxDCIMDevice -Serial 'ABC123' -Description 'Core switch'
$Device | Remove-NbxDCIMDevice
```

## Working with the cmdlets

All cmdlets follow the same conventions, so once you know one you know them all.

### One verb per operation

| Verb | Operation | NetBox API |
| --- | --- | --- |
| `Get-Nbx*` | Get objects. `-Id`, `-Name` (or the main field, such as `-Address`), `-Query` and `-Limit`. All pages are returned. | `GET` |
| `New-Nbx*` | Create an object and return it. | `POST` |
| `Set-Nbx*` | Update the specified properties only. Returns nothing unless `-PassThru` is specified. | `PATCH` |
| `Remove-Nbx*` | Remove objects. Asks for confirmation unless `-Force` or `-Confirm:$false` is specified. | `DELETE` |

`New-*`, `Set-*` and `Remove-*` support `-WhatIf` and `-Confirm`.

### NetBox objects as input

Objects are returned as the API returns them, so the property names are the NetBox field names you know from the API
documentation. Each object gets a type name such as `NetboxTools.DCIMDevice`.

Every parameter that references another object accepts an **ID or the object itself**, and objects are validated.
Passing an interface where a device is expected is an error, instead of silently using the interface ID as a device ID:

```powershell
$Site = Get-NbxDCIMSite -Name 'Stockholm DC 1'
$Role = Get-NbxDCIMDeviceRole -Name 'Switch'
New-NbxDCIMDevice -Name 'sw-access-01' -Site $Site -Role $Role -DeviceType 3

Get-NbxDCIMInterface -Id 7 | Remove-NbxDCIMDevice   # Error: the input object is not of the expected type
```

Choice fields (such as `status`) accept the value (`'active'`) or the object returned by NetBox, and custom fields accept
a hashtable or the object returned by NetBox.

### The pipeline

- `Get-*`, `Set-*` and `Remove-*` accept IDs and NetBox objects from the pipeline.
- `New-*` binds pipeline objects by property name, matching either the parameter name (`DeviceType`) or the NetBox
  field name (`device_type`). This makes it easy to create objects from a CSV file or to copy objects. Empty cells
  are not sent, and boolean columns accept `true`/`false`, `yes`/`no` or `1`/`0`. An object that fails writes an error
  and the pipeline continues with the next object:

```powershell
# sites.csv: name,status,description
Import-Csv .\sites.csv | New-NbxDCIMSite

# Allocate the next available IP address in a prefix to an interface
$Interface = Get-NbxDCIMInterface -Query @{ device = 'sw-core-01'; name = 'Vlan10' }
$Address = Get-NbxIPAMPrefix -Prefix '192.0.2.0/24' | Get-NbxIPAMAvailableIP -Limit 1
New-NbxIPAMAddress -Address $Address.address -AssignedObject $Interface

# Connect two interfaces with a cable
New-NbxDCIMCable -ATermination (Get-NbxDCIMInterface -Id 10) -BTermination (Get-NbxDCIMInterface -Id 20) -Status connected
```

### Fields without a parameter

Parameters exist for the commonly used fields. Any other NetBox field can be set with `-OptionalAttribute`, using the
NetBox field names. Named parameters take precedence.

```powershell
New-NbxDCIMDevice -Name 'sw-01' -Site 1 -Role 1 -DeviceType 1 -OptionalAttribute @{ local_context_data = @{ ntp = '192.0.2.1' } }
```

### Clearing values

Specify `$null` to clear a reference on `Set-*`, for example `Set-NbxDCIMDevice -Id 42 -Tenant $null`.

### Filtering

`-Query` takes any filter supported by the NetBox API. Filter names are sent in lower case, values are URL encoded and
arrays are sent as repeated parameters. NetBox ignores filters it does not recognize, so check the filter names in the
API documentation of your NetBox instance; a misspelled filter returns all objects.

```powershell
$Query = @{
    assigned_object_id = 373
    description        = 'demo'
    created__gt        = '2022-01-23'
    tag                = 'production', 'core'   # objects with any of the tags
}
Get-NbxIPAMAddress -Query $Query
```

Pagination is handled by the module: all matching objects are returned, requested 1000 at a time. Use `-Limit` to
return fewer objects, or set `limit` and `offset` in `-Query` to request a single page.

### Connection settings

| Cmdlet | Purpose |
| --- | --- |
| `Connect-NbxAPI -Hostname <host> -Token <token>` | Connect with a token. Also `-Credential` (token as password) or `-Anonymous`. |
| `Connect-NbxAPI ... -SkipCertificateCheck` | Accept self-signed certificates. |
| `Set-NbxTimeout -TimeoutSeconds 60` | Request timeout (default 30 seconds). |
| `Set-NbxInvokeParameter -InvokeParameter @{ Proxy = 'http://proxy:8080' }` | Extra parameters for `Invoke-RestMethod`. |
| `Disconnect-NbxAPI` | Remove the connection and token from the session. |

API errors are reported as non-terminating errors with the message returned by NetBox, so a pipeline continues with the
next object. Use `-ErrorAction Stop` to stop at the first error.

## Upgrading from earlier versions

This version makes all cmdlets consistent, which includes some breaking changes:

- `Add-NbxDCIMInterface`, `Add-NbxDCIMFrontPort`, `Add-NbxDCIMRearPort` and `Add-NbxVirtualMachineInterface` are renamed
  to `New-*`. `Set-NbxInvokeParams` is renamed to `Set-NbxInvokeParameter`. The old names remain as aliases.
- Parameter names are PascalCase without underscores, such as `-DeviceType` and `-AssetTag`. The previous names
  (`-Device_Type`, `-Asset_Tag`, `-Custom_Fields`, `-Rear_Port`, ...) still work as aliases.
- `*-NbxDCIMInterfaceConnection` are removed. The `interface-connections` endpoint does not exist in NetBox 4, use
  `New-NbxDCIMCable`, `Set-NbxDCIMCable`, `Remove-NbxDCIMCable` and `Get-NbxDCIMCable` instead.
- Removed parameters for fields that no longer exist in NetBox: `-Form_Factor` on the interface cmdlets (NetBox 2.x)
  and `-Site` on `Set-NbxIPAMPrefix` (NetBox 4.2, use `-Scope`). `-Raw` is removed from the cmdlets that had it.
- `Get-*` returns all objects by default, `-All` is no longer needed but still accepted. `-Query` can be combined with
  `-Name` and `-Limit`.
- `Set-*` only returns the updated object with `-PassThru`, and only sends the parameters you specify. Previously some
  `Set-*` cmdlets sent empty values for all unspecified fields.
- `New-NbxDCIMInterface` requires `-Type`, and `New-NbxIPAMPrefix` no longer sends `is_pool = true` by default. Both now
  follow the NetBox defaults.
- Query values are no longer converted to lower case. Filter names still are, as NetBox filter names are lower case.
- `Connect-NbxAPI` validates certificates unless `-SkipCertificateCheck` is specified for that connection; the setting is
  no longer carried over from a previous connection.
- `-MacAddress` on the interface cmdlets requires NetBox 4.7 or later.
- `Set-NbxCipherSSL` has no effect in PowerShell 7 and is deprecated. `Set-NbxUntrustedSSL` is deprecated, use
  `Connect-NbxAPI -SkipCertificateCheck`.

## Ambition

This project will conform to community standards of PowerShell module development.
This includes (but not limited to);
- ~Each function is broken into a PowerShell script file (Either private or public)~
- ~Each function has a corresponding pester test file~
- ~Each function has a corresponding markdown help file~
- ~New authentication method that includes Anonymous authentication.~
- ~Improved performance and reduce logic/unnesscary connections~
- ~Consistent cmdlets: pipeline support, NetBox objects as input, `-WhatIf`/`-Confirm` (see [Working with the cmdlets](#working-with-the-cmdlets))~
- ~Utilizing the correct endpoints (Verified against the NetBox 4.7 API)~
- Support Entra id authentication

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
