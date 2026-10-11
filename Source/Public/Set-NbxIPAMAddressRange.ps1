function Set-NbxIPAMAddressRange {
    <#
    .SYNOPSIS
        Updates IP ranges in NetBox.

    .DESCRIPTION
        Updates one or more IP ranges using the NetBox API endpoint 'ipam/ip-ranges'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the IP range to update. Accepts IP range objects from the pipeline.

    .PARAMETER StartAddress
        The first address of the range with mask, e.g. '192.0.2.10/24'.

    .PARAMETER EndAddress
        The last address of the range with mask, e.g. '192.0.2.20/24'.

    .PARAMETER Status
        The status of the IP range. Common values are: active, reserved, deprecated. Specify $null to clear the value.

    .PARAMETER Vrf
        The vrf of the IP range. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the IP range. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER Role
        The IPAM role. Accepts an ID or an object from Get-NbxIPAMRole. Specify $null to clear the value.

    .PARAMETER MarkPopulated
        Prevent the creation of IP addresses within the range.

    .PARAMETER MarkUtilized
        Treat the range as fully utilized.

    .PARAMETER Description
        A short description of the IP range. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the IP range. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the IP range. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated IP range. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxIPAMAddressRange -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the IP range with ID 42.

    .EXAMPLE
        Get-NbxIPAMAddressRange -Query @{ q = 'example' } | Set-NbxIPAMAddressRange -Description 'Updated' -PassThru

        Updates the description of all IP ranges matching the search 'example' and returns the updated IP ranges.

    .INPUTS
        System.UInt64, NetboxTools.IPAMAddressRange
        You can pipe IP range IDs or IP range objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.IPAMAddressRange
        With -PassThru the updated IP range is returned.

    .LINK
        Get-NbxIPAMAddressRange

    .LINK
        New-NbxIPAMAddressRange

    .LINK
        Remove-NbxIPAMAddressRange
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.IPAMAddressRange')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('ipam/ip-ranges')]
        [uint64[]]$Id,

        [Parameter()]
        [Alias('start_address')]
        [string]$StartAddress,

        [Parameter()]
        [Alias('end_address')]
        [string]$EndAddress,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('active', 'reserved', 'deprecated')]
        [string]$Status,

        [Parameter()]
        [NbxIdTransformation('ipam/vrfs')]
        [Nullable[uint64]]$Vrf,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [NbxIdTransformation('ipam/roles')]
        [Nullable[uint64]]$Role,

        [Parameter()]
        [Alias('mark_populated')]
        [NbxBoolTransformation()]
        [bool]$MarkPopulated,

        [Parameter()]
        [Alias('mark_utilized')]
        [NbxBoolTransformation()]
        [bool]$MarkUtilized,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$Comments,

        [Parameter()]
        [Alias('tags')]
        [NbxIdTransformation('extras/tags')]
        [uint64[]]$Tag,

        [Parameter()]
        [Alias('custom_fields')]
        [NbxDictionaryTransformation()]
        [hashtable]$CustomField,

        [Parameter()]
        [hashtable]$OptionalAttribute,

        [Parameter()]
        [switch]$PassThru,

        [Parameter()]
        [switch]$Force
    )

    begin {
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters

        if ($Body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                    [System.ArgumentException]::new('Specify at least one property to update.'),
                    'NbxNothingToUpdate',
                    [System.Management.Automation.ErrorCategory]::InvalidArgument,
                    $null
                ))
        }
    }

    process {
        foreach ($ObjectId in $Id) {
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("IP range $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "ipam/ip-ranges/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.IPAMAddressRange'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
