function New-NbxDCIMRearPort {
    <#
    .SYNOPSIS
        Creates a new rear port in NetBox.

    .DESCRIPTION
        Creates a new rear port using the NetBox API endpoint 'dcim/rear-ports' and returns the created rear port.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or rear port objects returned by Get-NbxDCIMRearPort.

    .PARAMETER Device
        The device of the rear port. Accepts an ID or an object from Get-NbxDCIMDevice.

    .PARAMETER Name
        The name of the rear port.

    .PARAMETER Type
        The port type, e.g. '8p8c' or 'lc'. Common values are: 8p8c, 110-punch, bnc, lc, lc-apc, lc-upc, lsh, mpo, mtrj, sc, sc-apc, sc-upc, st, splice, other.

    .PARAMETER Module
        The module of the rear port. Accepts an ID or a NetBox object.

    .PARAMETER Label
        A physical label.

    .PARAMETER Color
        The color as a hexadecimal RGB value, e.g. 'ff0000'.

    .PARAMETER Positions
        The number of front ports that can be mapped to the rear port.

    .PARAMETER MarkConnected
        Treat the port as if a cable is connected.

    .PARAMETER Description
        A short description of the rear port.

    .PARAMETER Tag
        The tags of the rear port. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxDCIMRearPort -Device 1 -Name 'RP1' -Type '8p8c'

        Creates a new rear port.

    .EXAMPLE
        New-NbxDCIMRearPort -Device 1 -Name 'RP1' -Type '8p8c' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new rear port with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\rear-ports.csv | New-NbxDCIMRearPort

        Creates a rear port for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMRearPort

    .LINK
        Get-NbxDCIMRearPort

    .LINK
        Set-NbxDCIMRearPort

    .LINK
        Remove-NbxDCIMRearPort
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.DCIMRearPort')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/devices')]
        [Nullable[uint64]]$Device,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('8p8c', '110-punch', 'bnc', 'lc', 'lc-apc', 'lc-upc', 'lsh', 'mpo', 'mtrj', 'sc', 'sc-apc', 'sc-upc', 'st', 'splice', 'other')]
        [string]$Type,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('dcim/modules')]
        [Nullable[uint64]]$Module,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Label,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Color,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[int]]$Positions,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mark_connected')]
        [NbxBoolTransformation()]
        [bool]$MarkConnected,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description,

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

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new rear port'), 'Create rear port')) {
            InvokeNbxRestMethod -Endpoint 'dcim/rear-ports/' -Method POST -Body $Body -TypeName 'NetboxTools.DCIMRearPort'
        }
    }
}
