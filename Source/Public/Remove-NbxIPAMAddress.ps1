function Remove-NbxIPAMAddress {

    <#
    .SYNOPSIS
        Remove an IP address from Netbox

    .DESCRIPTION
        Removes/deletes an IP address from Netbox by ID and optional other filters

    .PARAMETER Id
        Database ID of the IP address object.

    .PARAMETER Force
        Do not confirm.

    .EXAMPLE
        PS C:\> Remove-NbxIPAMAddress -Id $value1

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

    process {
        foreach ($IPId in $Id) {
            $CurrentIP = Get-NbxIPAMAddress -Id $IPId -ErrorAction Stop

            $Segments = [System.Collections.ArrayList]::new(@('ipam', 'ip-addresses', $IPId))

            if ($Force -or $pscmdlet.ShouldProcess($CurrentIP.Address, "Delete")) {
                $URI = BuildNewURI -Segments $Segments

                InvokeNbxRequest -URI $URI -Method DELETE
            }
        }
    }

}
