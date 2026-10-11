function ConvertToNbxErrorRecord {
    <#
        Creates an error record with the error returned by the NetBox API.
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param (
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        [string]$Method,
        [string]$Uri
    )

    $StatusCode = $ErrorRecord.Exception.Response.StatusCode
    $Detail = $ErrorRecord.ErrorDetails.Message
    if ($Detail) {
        try {
            $Parsed = $Detail | ConvertFrom-Json -ErrorAction Stop
            $Detail = if ($Parsed.detail) { $Parsed.detail } else { $Parsed | ConvertTo-Json -Depth 5 -Compress }
        }
        catch {
            # Not JSON, keep the message as it is
            $null = $_
        }
    }
    else {
        $Detail = $ErrorRecord.Exception.Message
    }

    $Category = switch ([int]$StatusCode) {
        400 { [System.Management.Automation.ErrorCategory]::InvalidArgument }
        401 { [System.Management.Automation.ErrorCategory]::AuthenticationError }
        403 { [System.Management.Automation.ErrorCategory]::PermissionDenied }
        404 { [System.Management.Automation.ErrorCategory]::ObjectNotFound }
        409 { [System.Management.Automation.ErrorCategory]::ResourceExists }
        default { [System.Management.Automation.ErrorCategory]::InvalidOperation }
    }

    $Status = if ($StatusCode) { " ($([int]$StatusCode) $StatusCode)" } else { '' }
    $Message = "NetBox API request $Method $Uri failed$Status`: $Detail"

    [System.Management.Automation.ErrorRecord]::new(
        [System.Exception]::new($Message, $ErrorRecord.Exception),
        "NbxApiError$([int]$StatusCode)",
        $Category,
        $Uri
    )
}
