function New-NbxDCIMFrontPort {
    <#
    .SYNOPSIS
        Creates a new front port in NetBox.

    .DESCRIPTION
        Creates a new front port using the NetBox API endpoint 'dcim/front-ports' and returns the created front port.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or front port objects returned by Get-NbxDCIMFrontPort.

    .PARAMETER Device
        The device of the front port. Accepts an ID or an object from Get-NbxDCIMDevice.

    .PARAMETER Name
        The name of the front port.

    .PARAMETER Type
        The port type, e.g. '8p8c' or 'lc'. Common values are: 8p8c, 110-punch, bnc, lc, lc-apc, lc-upc, lsh, mpo, mtrj, sc, sc-apc, sc-upc, st, splice, other.

    .PARAMETER Module
        The module of the front port. Accepts an ID or a NetBox object.

    .PARAMETER Label
        A physical label.

    .PARAMETER Color
        The color as a hexadecimal RGB value, e.g. 'ff0000'.

    .PARAMETER Positions
        The number of positions of the port.

    .PARAMETER RearPort
        The rear port this front port maps to. Accepts an ID or an object from Get-NbxDCIMRearPort.

    .PARAMETER RearPortPosition
        The position on the rear port this front port maps to. Defaults to 1.

    .PARAMETER MarkConnected
        Treat the port as if a cable is connected.

    .PARAMETER Description
        A short description of the front port.

    .PARAMETER Tag
        The tags of the front port. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxDCIMFrontPort -Device 1 -Name 'FP1' -Type '8p8c'

        Creates a new front port.

    .EXAMPLE
        New-NbxDCIMFrontPort -Device 1 -Name 'FP1' -Type '8p8c' -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new front port with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\front-ports.csv | New-NbxDCIMFrontPort

        Creates a front port for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.DCIMFrontPort

    .LINK
        Get-NbxDCIMFrontPort

    .LINK
        Set-NbxDCIMFrontPort

    .LINK
        Remove-NbxDCIMFrontPort
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.DCIMFrontPort')]
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

        [Parameter()]
        [Alias('Rear_Port')]
        [NbxIdTransformation('dcim/rear-ports')]
        [uint64]$RearPort,

        [Parameter()]
        [Alias('Rear_Port_Position')]
        [ValidateRange(1, 1024)]
        [int]$RearPortPosition = 1,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -CommandLineParameters $CommandLineParameters -InputObject $_ -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'RearPort', 'RearPortPosition')
        try {
            if ($PSBoundParameters.ContainsKey('RearPort')) {
                $Body['rear_ports'] = @(@{ position = 1; rear_port = $RearPort; rear_port_position = $RearPortPosition })
            }
        }
        catch {
            $PSCmdlet.WriteError($_)
            return
        }

        if ($PSCmdlet.ShouldProcess(($Body['name'] ?? 'new front port'), 'Create front port')) {
            InvokeNbxRestMethod -Endpoint 'dcim/front-ports/' -Method POST -Body $Body -TypeName 'NetboxTools.DCIMFrontPort'
        }
    }
}
