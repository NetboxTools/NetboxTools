function Set-NbxDCIMRearPort {

    [CmdletBinding(ConfirmImpact = 'Medium',
                   SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id,

        [uint64]$Device,

        [uint64]$Module,

        [string]$Name,

        [string]$Label,

        [string]$Type,

        [ValidatePattern('^[0-9a-f]{6}$')]
        [string]$Color,

        [uint16]$Positions,

        [string]$Description,

        [bool]$Mark_Connected,

        [uint16[]]$Tags,

        [switch]$Force
    )

    begin {

    }

    process {
        foreach ($RearPortID in $Id) {
            $CurrentPort = Get-NbxDCIMRearPort -Id $RearPortID -ErrorAction Stop

            $Segments = [System.Collections.ArrayList]::new(@('dcim', 'rear-ports', $CurrentPort.Id))

            $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Id'

            $URI = BuildNewURI -Segments $Segments

            if ($Force -or $pscmdlet.ShouldProcess("Rear Port ID $($CurrentPort.Id)", "Set")) {
                InvokeNbxRequest -URI $URI -Body $URIComponents.Parameters -Method PATCH
            }
        }
    }

    end {

    }

}
