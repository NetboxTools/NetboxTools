function Remove-NbxDCIMDevice {

<#
    .SYNOPSIS
        Delete a device

    .DESCRIPTION
        Deletes a device from Netbox by ID

    .PARAMETER Id
        Database ID of the device

    .PARAMETER Force
        Force deletion without any prompts

    .EXAMPLE
        PS C:\> Remove-NbxDCIMDevice -Id $value1

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding(ConfirmImpact = 'High',
                   SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id,

        [switch]$Force
    )

    begin {

    }

    process {
        foreach ($DeviceID in $Id) {
            $CurrentDevice = Get-NbxDCIMDevice -Id $DeviceID -ErrorAction Stop

            if ($Force -or $pscmdlet.ShouldProcess("Name: $($CurrentDevice.Name) | ID: $($CurrentDevice.Id)", "Remove")) {
                $Segments = [System.Collections.ArrayList]::new(@('dcim', 'devices', $CurrentDevice.Id))

                $URI = BuildNewURI -Segments $Segments

                InvokeNbxRequest -URI $URI -Method DELETE
            }
        }
    }

    end {

    }

}
