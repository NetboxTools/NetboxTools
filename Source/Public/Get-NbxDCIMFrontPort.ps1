function Get-NbxDCIMFrontPort {

    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [uint16]$Limit,

        [uint16]$Offset,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [uint64]$Id,

        [string]$Name,

        [string]$Device,

        [uint64]$Device_Id,

        [string]$Type,

        [switch]$Raw
    )

    process {

        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'front-ports'))

        $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters

        $URI = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

        InvokeNbxRequest -URI $URI -Raw:$Raw
    }

}
