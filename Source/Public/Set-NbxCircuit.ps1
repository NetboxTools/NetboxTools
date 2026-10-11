function Set-NbxCircuit {
    <#
    .SYNOPSIS
        Updates circuits in NetBox.

    .DESCRIPTION
        Updates one or more circuits using the NetBox API endpoint 'circuits/circuits'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the circuit to update. Accepts circuit objects from the pipeline.

    .PARAMETER CID
        The unique circuit ID.

    .PARAMETER Provider
        The provider of the circuit. Accepts an ID or an object from Get-NbxCircuitProvider.

    .PARAMETER Type
        The circuit type. Accepts an ID or an object from Get-NbxCircuitType.

    .PARAMETER ProviderAccount
        The provider account of the circuit. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Status
        The status of the circuit. Common values are: planned, provisioning, active, offline, deprovisioning, decommissioned. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the circuit. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER InstallDate
        The installation date in the format 'yyyy-MM-dd'. Specify $null to clear the value.

    .PARAMETER TerminationDate
        The termination date in the format 'yyyy-MM-dd'. Specify $null to clear the value.

    .PARAMETER CommitRate
        The committed rate in Kbps. Specify $null to clear the value.

    .PARAMETER Distance
        The distance of the circuit. Specify $null to clear the value.

    .PARAMETER DistanceUnit
        The distance unit of the circuit. Common values are: km, m, mi, ft. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the circuit. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the circuit. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the circuit. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated circuit. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxCircuit -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the circuit with ID 42.

    .EXAMPLE
        Get-NbxCircuit -Query @{ q = 'example' } | Set-NbxCircuit -Description 'Updated' -PassThru

        Updates the description of all circuits matching the search 'example' and returns the updated circuits.

    .INPUTS
        System.UInt64, NetboxTools.Circuit
        You can pipe circuit IDs or circuit objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.Circuit
        With -PassThru the updated circuit is returned.

    .LINK
        Get-NbxCircuit

    .LINK
        New-NbxCircuit

    .LINK
        Remove-NbxCircuit
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.Circuit')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('circuits/circuits')]
        [uint64[]]$Id,

        [Parameter()]
        [string]$CID,

        [Parameter()]
        [NbxIdTransformation('circuits/providers')]
        [Nullable[uint64]]$Provider,

        [Parameter()]
        [NbxIdTransformation('circuits/circuit-types')]
        [Nullable[uint64]]$Type,

        [Parameter()]
        [Alias('provider_account')]
        [NbxIdTransformation('circuits/provider-accounts')]
        [Nullable[uint64]]$ProviderAccount,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('planned', 'provisioning', 'active', 'offline', 'deprovisioning', 'decommissioned')]
        [string]$Status,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [Alias('install_date')]
        [string]$InstallDate,

        [Parameter()]
        [Alias('termination_date')]
        [string]$TerminationDate,

        [Parameter()]
        [Alias('commit_rate')]
        [Nullable[int]]$CommitRate,

        [Parameter()]
        [Nullable[decimal]]$Distance,

        [Parameter()]
        [Alias('distance_unit')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('km', 'm', 'mi', 'ft')]
        [string]$DistanceUnit,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("circuit $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "circuits/circuits/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.Circuit'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
