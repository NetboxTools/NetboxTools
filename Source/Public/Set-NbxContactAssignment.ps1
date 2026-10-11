function Set-NbxContactAssignment {
    <#
    .SYNOPSIS
        Updates contact assignments in NetBox.

    .DESCRIPTION
        Updates one or more contact assignments using the NetBox API endpoint 'tenancy/contact-assignments'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the contact assignment to update. Accepts contact assignment objects from the pipeline.

    .PARAMETER Object
        The object to assign the contact to, such as a site from Get-NbxDCIMSite. Sets ObjectType and ObjectId.

    .PARAMETER ObjectType
        The type of the object the contact is assigned to, e.g. 'dcim.site'. Common values are: circuits.circuit, circuits.provider, dcim.device, dcim.location, dcim.manufacturer, dcim.rack, dcim.region, dcim.site, dcim.sitegroup, tenancy.tenant, virtualization.cluster, virtualization.virtualmachine. Specify $null to clear the value.

    .PARAMETER ObjectId
        The ID of the object the contact is assigned to. Specify $null to clear the value.

    .PARAMETER Contact
        The contact of the contact assignment. Accepts an ID or an object from Get-NbxContact.

    .PARAMETER Role
        The contact role. Accepts an ID or an object from Get-NbxContactRole. Specify $null to clear the value.

    .PARAMETER Priority
        The priority of the contact assignment. Common values are: primary, secondary, tertiary, inactive. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the contact assignment. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated contact assignment. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxContactAssignment -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the contact assignment with ID 42.

    .EXAMPLE
        Get-NbxContactAssignment -Query @{ q = 'example' } | Set-NbxContactAssignment -Description 'Updated' -PassThru

        Updates the description of all contact assignments matching the search 'example' and returns the updated contact assignments.

    .INPUTS
        System.UInt64, NetboxTools.ContactAssignment
        You can pipe contact assignment IDs or contact assignment objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.ContactAssignment
        With -PassThru the updated contact assignment is returned.

    .LINK
        Get-NbxContactAssignment

    .LINK
        New-NbxContactAssignment

    .LINK
        Remove-NbxContactAssignment
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.ContactAssignment')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contact-assignments')]
        [uint64[]]$Id,

        [Parameter()]
        [object]$Object,

        [Parameter()]
        [Alias('object_type', 'Content_Type')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('circuits.circuit', 'circuits.provider', 'dcim.device', 'dcim.location', 'dcim.manufacturer', 'dcim.rack', 'dcim.region', 'dcim.site', 'dcim.sitegroup', 'tenancy.tenant', 'virtualization.cluster', 'virtualization.virtualmachine')]
        [string]$ObjectType,

        [Parameter()]
        [Alias('object_id')]
        [Nullable[int]]$ObjectId,

        [Parameter()]
        [NbxIdTransformation('tenancy/contacts')]
        [Nullable[uint64]]$Contact,

        [Parameter()]
        [NbxIdTransformation('tenancy/contact-roles')]
        [Nullable[uint64]]$Role,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('primary', 'secondary', 'tertiary', 'inactive')]
        [string]$Priority,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'Object')
        if ($PSBoundParameters.ContainsKey('Object')) {
            $Reference = ConvertToNbxObjectReference -InputObject $Object
            $Body['object_type'] = $Reference.object_type
            $Body['object_id'] = $Reference.object_id
        }

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("contact assignment $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "tenancy/contact-assignments/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.ContactAssignment'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
