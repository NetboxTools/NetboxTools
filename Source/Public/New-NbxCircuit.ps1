function New-NbxCircuit {
    <#
    .SYNOPSIS
        Creates a new circuit in NetBox.

    .DESCRIPTION
        Creates a new circuit using the NetBox API endpoint 'circuits/circuits' and returns the created circuit.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.
        Objects with properties matching the parameter names or the NetBox field names can be piped to the cmdlet,
        for example rows from Import-Csv or circuit objects returned by Get-NbxCircuit.

    .PARAMETER CID
        The unique circuit ID.

    .PARAMETER Provider
        The provider of the circuit. Accepts an ID or an object from Get-NbxCircuitProvider.

    .PARAMETER Type
        The circuit type. Accepts an ID or an object from Get-NbxCircuitType.

    .PARAMETER ProviderAccount
        The provider account of the circuit. Accepts an ID or a NetBox object.

    .PARAMETER Status
        The status of the circuit. Common values are: planned, provisioning, active, offline, deprovisioning, decommissioned.

    .PARAMETER Tenant
        The tenant of the circuit. Accepts an ID or an object from Get-NbxTenant.

    .PARAMETER InstallDate
        The installation date in the format 'yyyy-MM-dd'.

    .PARAMETER TerminationDate
        The termination date in the format 'yyyy-MM-dd'.

    .PARAMETER CommitRate
        The committed rate in Kbps.

    .PARAMETER Distance
        The distance of the circuit.

    .PARAMETER DistanceUnit
        The distance unit of the circuit. Common values are: km, m, mi, ft.

    .PARAMETER Description
        A short description of the circuit.

    .PARAMETER Comments
        Comments about the circuit. Supports Markdown.

    .PARAMETER Tag
        The tags of the circuit. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        New-NbxCircuit -CID 'CID-1001' -Provider 1 -Type 1

        Creates a new circuit.

    .EXAMPLE
        New-NbxCircuit -CID 'CID-1001' -Provider 1 -Type 1 -Description 'Created with NetboxTools' -OptionalAttribute @{ custom_fields = @{ owner = 'IT' } }

        Creates a new circuit with a description and a custom field value.

    .EXAMPLE
        Import-Csv -Path .\circuits.csv | New-NbxCircuit

        Creates a circuit for each row in a CSV file. Columns are matched to parameters by name or NetBox field name.

    .INPUTS
        System.Management.Automation.PSObject
        You can pipe objects with properties matching the parameter names or NetBox field names to this cmdlet.

    .OUTPUTS
        NetboxTools.Circuit

    .LINK
        Get-NbxCircuit

    .LINK
        Set-NbxCircuit

    .LINK
        Remove-NbxCircuit
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType('NetboxTools.Circuit')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$CID,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('circuits/providers')]
        [Nullable[uint64]]$Provider,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('circuits/circuit-types')]
        [Nullable[uint64]]$Type,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('provider_account')]
        [NbxIdTransformation('circuits/provider-accounts')]
        [Nullable[uint64]]$ProviderAccount,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('planned', 'provisioning', 'active', 'offline', 'deprovisioning', 'decommissioned')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('install_date')]
        [string]$InstallDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('termination_date')]
        [string]$TerminationDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('commit_rate')]
        [Nullable[int]]$CommitRate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Nullable[decimal]]$Distance,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('distance_unit')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('km', 'm', 'mi', 'ft')]
        [string]$DistanceUnit,

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

        if ($PSCmdlet.ShouldProcess(($Body['cid'] ?? 'new circuit'), 'Create circuit')) {
            InvokeNbxRestMethod -Endpoint 'circuits/circuits/' -Method POST -Body $Body -TypeName 'NetboxTools.Circuit'
        }
    }
}
