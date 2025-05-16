function Set-NbxDCIMFrontPort {

    [CmdletBinding(ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id,

        [uint16]$Device,

        [uint16]$Module,

        [string]$Name,

        [string]$Label,

        [string]$Type,

        [ValidatePattern('^[0-9a-f]{6}$')]
        [string]$Color,

        [uint64]$Rear_Port,

        [uint16]$Rear_Port_Position,

        [string]$Description,

        [bool]$Mark_Connected,

        [uint64[]]$Tags,

        [switch]$Force
    )

    begin {

    }

    process {
        foreach ($FrontPortID in $Id) {
            $CurrentPort = Get-NbxDCIMFrontPort -Id $FrontPortID -ErrorAction Stop

            $Segments = [System.Collections.ArrayList]::new(@('dcim', 'front-ports', $CurrentPort.Id))

            $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Id'

            $URI = BuildNewURI -Segments $Segments

            if ($Force -or $pscmdlet.ShouldProcess("Front Port ID $($CurrentPort.Id)", "Set")) {
                InvokeNbxRequest -URI $URI -Body $URIComponents.Parameters -Method PATCH
            }
        }
    }

    end {

    }

}
