function Add-NbxDCIMRearPort {

    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [uint64]$Device,

        [uint64]$Module,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Label,

        [Parameter(Mandatory = $true)]
        [string]$Type,

        [ValidatePattern('^[0-9a-f]{6}$')]
        [string]$Color,

        [uint16]$Positions = 1,

        [string]$Description,

        [bool]$Mark_Connected,

        [uint16[]]$Tags
    )

    begin {

    }

    process {
        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'rear-ports'))

        $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters

        $URI = BuildNewURI -Segments $URIComponents.Segments

        InvokeNbxRequest -URI $URI -Body $URIComponents.Parameters -Method POST
    }

    end {

    }

}
