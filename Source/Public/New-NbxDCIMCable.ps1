function New-NbxDCIMCable {
    <#
    .SYNOPSIS
        Creates a new cable in NetBox.

    .DESCRIPTION
        Creates a new cable using the NetBox API endpoint 'dcim/cables' and returns the created cable.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or cable objects returned by Get-NbxDCIMCable.

    .PARAMETER ATermination
        The A side termination(s) of the cable. Accepts interface, front port, rear port or circuit termination objects, or IDs of the type given by -TerminationType.

    .PARAMETER BTermination
        The B side termination(s) of the cable. Accepts interface, front port, rear port or circuit termination objects, or IDs of the type given by -TerminationType.

    .PARAMETER TerminationType
        The object type of terminations given as IDs. Defaults to 'dcim.interface'.

    .PARAMETER Type
        The cable type. Common values are: cat5e, cat6, cat6a, cat7, cat8, dac-active, dac-passive, coaxial, mmf, mmf-om3, mmf-om4, smf, smf-os2, aoc, power.

    .PARAMETER Status
        The status of the cable. Common values are: connected, planned, decommissioning.

    .PARAMETER Tenant
        The tenant of the cable. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER Label
        The cable label.

    .PARAMETER Color
        The color as a hexadecimal RGB value, e.g. 'ff0000'.

    .PARAMETER Length
        The length of the cable.

    .PARAMETER LengthUnit
        The length unit of the cable. Common values are: km, m, cm, mi, ft, in.

    .PARAMETER Description
        A short description of the cable.

    .PARAMETER Comments
        Comments about the cable. Supports Markdown.

    .PARAMETER Tag
        The tags of the cable. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxDCIMCable -ATermination 1 -BTermination 2

        Creates a new cable.

    .EXAMPLE
        New-NbxDCIMCable -ATermination 1 -BTermination 2 -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new cable with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\cables.csv | New-NbxDCIMCable

        Creates a cable for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMCable

    .LINK
        Get-NbxDCIMCable

    .LINK
        Set-NbxDCIMCable

    .LINK
        Remove-NbxDCIMCable
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.DCIMCable')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('a_terminations')]
        [object[]]$ATermination,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('b_terminations')]
        [object[]]$BTermination,

        [Parameter()]
        [ArgumentCompletions('dcim.interface', 'dcim.frontport', 'dcim.rearport', 'dcim.consoleport', 'dcim.consoleserverport', 'dcim.powerport', 'dcim.poweroutlet', 'dcim.powerfeed', 'circuits.circuittermination')]
        [string]$TerminationType = 'dcim.interface',

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('cat5e', 'cat6', 'cat6a', 'cat7', 'cat8', 'dac-active', 'dac-passive', 'coaxial', 'mmf', 'mmf-om3', 'mmf-om4', 'smf', 'smf-os2', 'aoc', 'power')]
        [string]$Type,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('connected', 'planned', 'decommissioning')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Label,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Color,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[decimal]]$Length,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('length_unit')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('km', 'm', 'cm', 'mi', 'ft', 'in')]
        [string]$LengthUnit,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -CommandLineParameters $CommandLineParameters -InputObject $_ -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'TerminationType')
        try {
            foreach ($Side in 'a_terminations', 'b_terminations') {
                if ($Body.ContainsKey($Side)) {
                    $Body[$Side] = @(ConvertToNbxObjectReference -InputObject $Body[$Side] -DefaultType $TerminationType)
                }
            }
        }
        catch {
            $PSCmdlet.WriteError($_)
            return
        }

        if ($PSCmdlet.ShouldProcess(($Body['label'] ?? 'new cable'), 'Create cable')) {
            InvokeNbxRestMethod -Endpoint 'dcim/cables/' -Method POST -Body $Body -TypeName 'NetboxTools.DCIMCable'
        }
    }
}
