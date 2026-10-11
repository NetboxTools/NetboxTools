function Set-NbxContactRole {
    <#
    .SYNOPSIS
        Updates contact roles in NetBox.

    .DESCRIPTION
        Updates one or more contact roles using the NetBox API endpoint 'tenancy/contact-roles'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the contact role to update. Accepts contact role objects from the pipeline.

    .PARAMETER Name
        The name of the contact role.

    .PARAMETER Slug
        The URL-friendly unique name of the contact role. Generated from the name when not specified. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the contact role. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the contact role. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the contact role. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated contact role. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxContactRole -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the contact role with ID 42.

    .EXAMPLE
        Get-NbxContactRole -Query @{ q = 'example' } | Set-NbxContactRole -Description 'Updated' -PassThru

        Updates the description of all contact roles matching the search 'example' and returns the updated contact roles.

    .INPUTS
        System.UInt64, NetboxTools.ContactRole
        You can pipe contact role IDs or contact role objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.ContactRole
        With -PassThru the updated contact role is returned.

    .LINK
        Get-NbxContactRole

    .LINK
        New-NbxContactRole

    .LINK
        Remove-NbxContactRole
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.ContactRole')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contact-roles')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Slug,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("contact role $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "tenancy/contact-roles/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.ContactRole'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
