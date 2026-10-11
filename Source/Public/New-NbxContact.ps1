function New-NbxContact {
    <#
    .SYNOPSIS
        Creates a new contact in NetBox.

    .DESCRIPTION
        Creates a new contact using the NetBox API endpoint 'tenancy/contacts' and returns the created contact.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or contact objects returned by Get-NbxContact.

    .PARAMETER Name
        The name of the contact.

    .PARAMETER Group
        The contact groups. Accepts IDs or objects.

    .PARAMETER Title
        The title of the contact.

    .PARAMETER Phone
        The phone of the contact.

    .PARAMETER Email
        The email of the contact.

    .PARAMETER Address
        The postal address of the contact.

    .PARAMETER Link
        A URL related to the contact.

    .PARAMETER Description
        A short description of the contact.

    .PARAMETER Comments
        Comments about the contact. Supports Markdown.

    .PARAMETER Tag
        The tags of the contact. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxContact -Name 'Jane Doe'

        Creates a new contact.

    .EXAMPLE
        New-NbxContact -Name 'Jane Doe' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new contact with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\contacts.csv | New-NbxContact

        Creates a contact for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.Contact

    .LINK
        Get-NbxContact

    .LINK
        Set-NbxContact

    .LINK
        Remove-NbxContact
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.Contact')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('groups')]
        [NbxIdTransformation('tenancy/contact-groups')]
        [uint64[]]$Group,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Title,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Phone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Email,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Address,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Link,

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

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new contact'), 'Create contact')) {
            InvokeNbxRestMethod -Endpoint 'tenancy/contacts/' -Method POST -Body $Body -TypeName 'NetboxTools.Contact'
        }
    }
}
