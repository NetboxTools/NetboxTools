function Set-NbxDCIMInterfaceConnection {

<#
    .SYNOPSIS
        Update an interface connection

    .DESCRIPTION
        Update an interface connection

    .PARAMETER Id
        A description of the Id parameter.

    .PARAMETER Connection_Status
        A description of the Connection_Status parameter.

    .PARAMETER Interface_A
        A description of the Interface_A parameter.

    .PARAMETER Interface_B
        A description of the Interface_B parameter.

    .PARAMETER Force
        A description of the Force parameter.

    .EXAMPLE
        PS C:\> Set-NbxDCIMInterfaceConnection -Id $value1

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding(ConfirmImpact = 'Medium',
                   SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id,

        [object]$Connection_Status,

        [uint64]$Interface_A,

        [uint64]$Interface_B,

        [switch]$Force
    )

    begin {
        if ((@($ID).Count -gt 1) -and ($Interface_A -or $Interface_B)) {
            throw "Cannot set multiple connections to the same interface"
        }
    }

    process {
        foreach ($ConnectionID in $Id) {
            $CurrentConnection = Get-NbxDCIMInterfaceConnection -Id $ConnectionID -ErrorAction Stop

            $Segments = [System.Collections.ArrayList]::new(@('dcim', 'interface-connections', $CurrentConnection.Id))

            if ($Force -or $pscmdlet.ShouldProcess("Connection ID $($CurrentConnection.Id)", "Set")) {

                $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Id', 'Force'

                $URI = BuildNewURI -Segments $URIComponents.Segments

                InvokeNbxRequest -URI $URI -Body $URIComponents.Parameters -Method PATCH
            }
        }
    }

    end {

    }

}
