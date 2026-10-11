function Set-NbxContact {
    <#
    .SYNOPSIS
        Updates contacts in NetBox.

    .DESCRIPTION
        Updates one or more contacts using the NetBox API endpoint 'tenancy/contacts'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the contact to update. Accepts contact objects from the pipeline.

    .PARAMETER Name
        The name of the contact.

    .PARAMETER Group
        The contact groups. Accepts IDs or objects.

    .PARAMETER Title
        The title of the contact. Specify $null to clear the value.

    .PARAMETER Phone
        The phone of the contact. Specify $null to clear the value.

    .PARAMETER Email
        The email of the contact. Specify $null to clear the value.

    .PARAMETER Address
        The postal address of the contact. Specify $null to clear the value.

    .PARAMETER Link
        A URL related to the contact. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the contact. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the contact. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the contact. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated contact. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxContact -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the contact with ID 42.

    .EXAMPLE
        Get-NbxContact -Query @{ q = 'example' } | Set-NbxContact -Description 'Updated' -PassThru

        Updates the description of all contacts matching the search 'example' and returns the updated contacts.

    .INPUTS
        System.UInt64, NetboxTools.Contact
        You can pipe contact IDs or contact objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.Contact
        With -PassThru the updated contact is returned.

    .LINK
        Get-NbxContact

    .LINK
        New-NbxContact

    .LINK
        Remove-NbxContact
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.Contact')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('tenancy/contacts')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [Alias('groups')]
        [NbxIdTransformation('tenancy/contact-groups')]
        [uint64[]]$Group,

        [Parameter()]
        [string]$Title,

        [Parameter()]
        [string]$Phone,

        [Parameter()]
        [string]$Email,

        [Parameter()]
        [string]$Address,

        [Parameter()]
        [string]$Link,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("contact $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "tenancy/contacts/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.Contact'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
