function Remove-NbxDCIMInterface {

    <#
    .SYNOPSIS
        Removes an interface

    .DESCRIPTION
        Removes an interface by ID from a device

    .PARAMETER Id
        A description of the Id parameter.

    .PARAMETER Force
        A description of the Force parameter.

    .EXAMPLE
        		PS C:\> Remove-NbxDCIMInterface -Id $value1

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
        foreach ($InterfaceId in $Id) {
            $CurrentInterface = Get-NbxDCIMInterface -Id $InterfaceId -ErrorAction Stop

            if ($Force -or $pscmdlet.ShouldProcess("Name: $($CurrentInterface.Name) | ID: $($CurrentInterface.Id)", "Remove")) {
                $Segments = [System.Collections.ArrayList]::new(@('dcim', 'interfaces', $CurrentInterface.Id))

                $URI = BuildNewURI -Segments $Segments

                InvokeNbxRequest -URI $URI -Method DELETE
            }
        }
    }

    end {

    }

}
