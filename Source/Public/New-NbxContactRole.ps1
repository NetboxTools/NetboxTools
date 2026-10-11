function New-NbxContactRole {
    <#
    .SYNOPSIS
        Creates a new contact role in NetBox.

    .DESCRIPTION
        Creates a new contact role using the NetBox API endpoint 'tenancy/contact-roles' and returns the created contact role.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or contact role objects returned by Get-NbxContactRole.

    .PARAMETER Name
        The name of the contact role.

    .PARAMETER Slug
        The URL-friendly unique name of the contact role. Generated from the name when not specified.

    .PARAMETER Description
        A short description of the contact role.

    .PARAMETER Comments
        Comments about the contact role. Supports Markdown.

    .PARAMETER Tag
        The tags of the contact role. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxContactRole -Name 'Administrative'

        Creates a new contact role.

    .EXAMPLE
        New-NbxContactRole -Name 'Administrative' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new contact role with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\contact-roles.csv | New-NbxContactRole

        Creates a contact role for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.ContactRole

    .LINK
        Get-NbxContactRole

    .LINK
        Set-NbxContactRole

    .LINK
        Remove-NbxContactRole
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.ContactRole')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Slug,

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
        if (-not $Body.ContainsKey('slug') -and $Body['name']) {
            $Body['slug'] = ConvertToNbxSlug -Name $Body['name']
        }

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new contact role'), 'Create contact role')) {
            InvokeNbxRestMethod -Endpoint 'tenancy/contact-roles/' -Method POST -Body $Body -TypeName 'NetboxTools.ContactRole'
        }
    }
}
