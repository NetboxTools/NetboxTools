function New-NbxIPAMAddressRange {
    <#
    .SYNOPSIS
        Creates a new IP range in NetBox.

    .DESCRIPTION
        Creates a new IP range using the NetBox API endpoint 'ipam/ip-ranges' and returns the created IP range.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or IP range objects returned by Get-NbxIPAMAddressRange.

    .PARAMETER StartAddress
        The first address of the range with mask, e.g. '192.0.2.10/24'.

    .PARAMETER EndAddress
        The last address of the range with mask, e.g. '192.0.2.20/24'.

    .PARAMETER Status
        The status of the IP range. Common values are: active, reserved, deprecated.

    .PARAMETER Vrf
        The vrf of the IP range. Accepts an ID or a NetBox object.

    .PARAMETER Tenant
        The tenant of the IP range. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER Role
        The IPAM role. Accepts an ID or an object from Get-NbxIPAMRole.

    .PARAMETER MarkPopulated
        Prevent the creation of IP addresses within the range.

    .PARAMETER MarkUtilized
        Treat the range as fully utilized.

    .PARAMETER Description
        A short description of the IP range.

    .PARAMETER Comments
        Comments about the IP range. Supports Markdown.

    .PARAMETER Tag
        The tags of the IP range. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxIPAMAddressRange -StartAddress '192.0.2.10/24' -EndAddress '192.0.2.20/24'

        Creates a new IP range.

    .EXAMPLE
        New-NbxIPAMAddressRange -StartAddress '192.0.2.10/24' -EndAddress '192.0.2.20/24' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new IP range with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\ip-ranges.csv | New-NbxIPAMAddressRange

        Creates an IP range for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.IPAMAddressRange

    .LINK
        Get-NbxIPAMAddressRange

    .LINK
        Set-NbxIPAMAddressRange

    .LINK
        Remove-NbxIPAMAddressRange
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.IPAMAddressRange')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('start_address')]
        [string]$StartAddress,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('end_address')]
        [string]$EndAddress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('active', 'reserved', 'deprecated')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/vrfs')]
        [Nullable[uint64]]$Vrf,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('ipam/roles')]
        [Nullable[uint64]]$Role,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mark_populated')]
        [NbxBoolTransformation()]
        [bool]$MarkPopulated,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mark_utilized')]
        [NbxBoolTransformation()]
        [bool]$MarkUtilized,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Comments,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('tags')]
        [NbxIdTransformation('extras/tags')]
        [uint64[]]$Tag,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('custom_fields')]
        [NbxDictionaryTransformation()]
        [hashtable]$CustomField,

        [Parameter()]
        [hashtable]$OptionalAttribute
    )

    begin {
        $CommandLineParameters = @($PSBoundParameters.Keys)
    }

    process {
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -CommandLineParameters $CommandLineParameters -InputObject $_

        if ($PSCmdlet.ShouldProcess(($Body['start_address'] ?? 'new IP range'), 'Create IP range')) {
            InvokeNbxRestMethod -Endpoint 'ipam/ip-ranges/' -Method POST -Body $Body -TypeName 'NetboxTools.IPAMAddressRange'
        }
    }
}
