function New-NbxContactAssignment {
    <#
    .SYNOPSIS
        Creates a new contact assignment in NetBox.

    .DESCRIPTION
        Creates a new contact assignment using the NetBox API endpoint 'tenancy/contact-assignments' and returns the created contact assignment.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or contact assignment objects returned by Get-NbxContactAssignment.

    .PARAMETER Object
        The object to assign the contact to, such as a site from Get-NbxDCIMSite. Sets ObjectType and ObjectId.

    .PARAMETER ObjectType
        The type of the object the contact is assigned to, e.g. 'dcim.site'. Common values are: circuits.circuit, circuits.provider, dcim.device, dcim.location, dcim.manufacturer, dcim.rack, dcim.region, dcim.site, dcim.sitegroup, tenancy.tenant, virtualization.cluster, virtualization.virtualmachine.

    .PARAMETER ObjectId
        The ID of the object the contact is assigned to.

    .PARAMETER Contact
        The contact of the contact assignment. Accepts an ID or an object from Get-NbxContact.

    .PARAMETER Role
        The contact role. Accepts an ID or an object from Get-NbxContactRole.

    .PARAMETER Priority
        The priority of the contact assignment. Common values are: primary, secondary, tertiary, inactive.

    .PARAMETER Tag
        The tags of the contact assignment. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxContactAssignment -Contact 1

        Creates a new contact assignment.

    .EXAMPLE
        Import-Csv -Path .\contact-assignments.csv | New-NbxContactAssignment

        Creates a contact assignment for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.ContactAssignment

    .LINK
        Get-NbxContactAssignment

    .LINK
        Set-NbxContactAssignment

    .LINK
        Remove-NbxContactAssignment
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.ContactAssignment')]
    param (
        [Parameter()]
        [object]$Object,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('object_type', 'Content_Type')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('circuits.circuit', 'circuits.provider', 'dcim.device', 'dcim.location', 'dcim.manufacturer', 'dcim.rack', 'dcim.region', 'dcim.site', 'dcim.sitegroup', 'tenancy.tenant', 'virtualization.cluster', 'virtualization.virtualmachine')]
        [string]$ObjectType,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('object_id')]
        [Nullable[int]]$ObjectId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/contacts')]
        [Nullable[uint64]]$Contact,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/contact-roles')]
        [Nullable[uint64]]$Role,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('primary', 'secondary', 'tertiary', 'inactive')]
        [string]$Priority,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -CommandLineParameters $CommandLineParameters -InputObject $_ -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'Object')
        try {
            if ($PSBoundParameters.ContainsKey('Object')) {
                $Reference = ConvertToNbxObjectReference -InputObject $Object
                $Body['object_type'] = $Reference.object_type
                $Body['object_id'] = $Reference.object_id
            }
        }
        catch {
            $PSCmdlet.WriteError($_)
            return
        }
        if (-not $Body['object_type'] -or -not $Body['object_id']) {
            $PSCmdlet.WriteError([System.Management.Automation.ErrorRecord]::new(
                    [System.ArgumentException]::new('Specify the object to assign the contact to with -Object, or with -ObjectType and -ObjectId.'),
                    'NbxMissingParameter',
                    [System.Management.Automation.ErrorCategory]::InvalidArgument,
                    $_
                ))
            return
        }

        if ($PSCmdlet.ShouldProcess(($Body['object_id'] ?? 'new contact assignment'), 'Create contact assignment')) {
            InvokeNbxRestMethod -Endpoint 'tenancy/contact-assignments/' -Method POST -Body $Body -TypeName 'NetboxTools.ContactAssignment'
        }
    }
}
