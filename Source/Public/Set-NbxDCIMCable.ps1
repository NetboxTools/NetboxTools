function Set-NbxDCIMCable {
    <#
    .SYNOPSIS
        Updates cables in NetBox.

    .DESCRIPTION
        Updates one or more cables using the NetBox API endpoint 'dcim/cables'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the cable to update. Accepts cable objects from the pipeline.

    .PARAMETER ATermination
        The A side termination(s) of the cable. Accepts interface, front port, rear port or circuit termination objects, or IDs of the type given by -TerminationType.

    .PARAMETER BTermination
        The B side termination(s) of the cable. Accepts interface, front port, rear port or circuit termination objects, or IDs of the type given by -TerminationType.

    .PARAMETER TerminationType
        The object type of terminations given as IDs. Defaults to 'dcim.interface'.

    .PARAMETER Type
        The cable type. Common values are: cat5e, cat6, cat6a, cat7, cat8, dac-active, dac-passive, coaxial, mmf, mmf-om3, mmf-om4, smf, smf-os2, aoc, power. Specify $null to clear the value.

    .PARAMETER Status
        The status of the cable. Common values are: connected, planned, decommissioning. Specify $null to clear the value.

    .PARAMETER Tenant
        The tenant of the cable. Accepts an ID or an object from Get-NbxTenant. Specify $null to clear the value.

    .PARAMETER Label
        The cable label. Specify $null to clear the value.

    .PARAMETER Color
        The color as a hexadecimal RGB value, e.g. 'ff0000'. Specify $null to clear the value.

    .PARAMETER Length
        The length of the cable. Specify $null to clear the value.

    .PARAMETER LengthUnit
        The length unit of the cable. Common values are: km, m, cm, mi, ft, in. Specify $null to clear the value.

    .PARAMETER Description
        A short description of the cable. Specify $null to clear the value.

    .PARAMETER Comments
        Comments about the cable. Supports Markdown. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the cable. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated cable. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxDCIMCable -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the cable with ID 42.

    .EXAMPLE
        Get-NbxDCIMCable -Query @{ q = 'example' } | Set-NbxDCIMCable -Description 'Updated' -PassThru

        Updates the description of all cables matching the search 'example' and returns the updated cables.

    .INPUTS
        System.UInt64, NetboxTools.DCIMCable
        You can pipe cable IDs or cable objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.DCIMCable
        With -PassThru the updated cable is returned.

    .LINK
        Get-NbxDCIMCable

    .LINK
        New-NbxDCIMCable

    .LINK
        Remove-NbxDCIMCable
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.DCIMCable')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/cables')]
        [uint64[]]$Id,

        [Parameter()]
        [Alias('a_terminations')]
        [object[]]$ATermination,

        [Parameter()]
        [Alias('b_terminations')]
        [object[]]$BTermination,

        [Parameter()]
        [ArgumentCompletions('dcim.interface', 'dcim.frontport', 'dcim.rearport', 'dcim.consoleport', 'dcim.consoleserverport', 'dcim.powerport', 'dcim.poweroutlet', 'dcim.powerfeed', 'circuits.circuittermination')]
        [string]$TerminationType = 'dcim.interface',

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('cat5e', 'cat6', 'cat6a', 'cat7', 'cat8', 'dac-active', 'dac-passive', 'coaxial', 'mmf', 'mmf-om3', 'mmf-om4', 'smf', 'smf-os2', 'aoc', 'power')]
        [string]$Type,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('connected', 'planned', 'decommissioning')]
        [string]$Status,

        [Parameter()]
        [NbxIdTransformation('tenancy/tenants')]
        [Nullable[uint64]]$Tenant,

        [Parameter()]
        [string]$Label,

        [Parameter()]
        [string]$Color,

        [Parameter()]
        [Nullable[decimal]]$Length,

        [Parameter()]
        [Alias('length_unit')]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('km', 'm', 'cm', 'mi', 'ft', 'in')]
        [string]$LengthUnit,

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
        $Body = ConvertToNbxBody -Command $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -Exclude @('Id', 'Force', 'PassThru', 'OptionalAttribute', 'TerminationType')
        foreach ($Side in 'a_terminations', 'b_terminations') {
            if ($Body.ContainsKey($Side)) {
                $Body[$Side] = @(ConvertToNbxObjectReference -InputObject $Body[$Side] -DefaultType $TerminationType)
            }
        }

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("cable $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "dcim/cables/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.DCIMCable'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
