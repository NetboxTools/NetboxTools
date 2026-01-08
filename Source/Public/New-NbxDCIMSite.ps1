function New-NbxDCIMSite {

    <#
    .SYNOPSIS
        Create a new Site to Netbox

    .DESCRIPTION
        Create a new Site to Netbox

    .EXAMPLE
        New-NbxDCIMSite -name MySite

        Add new Site MySite on Netbox

    #>

    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory)]
        [string]$Name,

        [string]$Slug,

        [string]$Facility,

        [uint64]$ASN,

        [decimal]$Latitude,

        [decimal]$Longitude,

        [string]$Contact_Name,

        [string]$Contact_Phone,

        [string]$Contact_Email,

        [uint64]$Tenant_Group,

        [uint64]$Tenant,

        [string]$Status,

        [uint64]$Region,

        [string]$Description,

        [string]$Comments,

        [switch]$Raw
    )

    process {
        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'sites'))
        $Method = 'POST'

        if (-not $PSBoundParameters.ContainsKey('slug')) {
            $PSBoundParameters.Add('slug', $name)
        }

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

        $URI = BuildNewURI -Segments $URIComponents.Segments

        if ($PSCmdlet.ShouldProcess($name, 'Create new Site')) {
            InvokeNbxRequest -URI $URI -Method $Method -Body $URIComponents.Parameters -Raw:$Raw
        }
    }

}
