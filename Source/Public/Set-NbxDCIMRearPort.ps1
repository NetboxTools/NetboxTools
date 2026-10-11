function Set-NbxDCIMRearPort {
    <#
    .SYNOPSIS
        Updates rear ports in NetBox.

    .DESCRIPTION
        Updates one or more rear ports using the NetBox API endpoint 'dcim/rear-ports'.
        Only the specified properties are changed, all other properties keep their current values.

        References to other objects, such as a site or a tenant, accept IDs or the objects returned by the Get cmdlets.

    .PARAMETER Id
        The ID of the rear port to update. Accepts rear port objects from the pipeline.

    .PARAMETER Device
        The device of the rear port. Accepts an ID or an object from Get-NbxDCIMDevice.

    .PARAMETER Name
        The name of the rear port.

    .PARAMETER Type
        The port type, e.g. '8p8c' or 'lc'. Common values are: 8p8c, 110-punch, bnc, lc, lc-apc, lc-upc, lsh, mpo, mtrj, sc, sc-apc, sc-upc, st, splice, other.

    .PARAMETER Module
        The module of the rear port. Accepts an ID or a NetBox object. Specify $null to clear the value.

    .PARAMETER Label
        A physical label. Specify $null to clear the value.

    .PARAMETER Color
        The color as a hexadecimal RGB value, e.g. 'ff0000'. Specify $null to clear the value.

    .PARAMETER Positions
        The number of front ports that can be mapped to the rear port. Specify $null to clear the value.

    .PARAMETER MarkConnected
        Treat the port as if a cable is connected.

    .PARAMETER Description
        A short description of the rear port. Specify $null to clear the value.

    .PARAMETER Tag
        The tags of the rear port. Accepts tag IDs or objects from Get-NbxTag. Replaces the current tags.

    .PARAMETER CustomField
        Custom field values as a hashtable, e.g. @{ cost_center = '1234' }.

    .PARAMETER OptionalAttribute
        Additional NetBox fields as a hashtable with the API field names as keys, for fields that do not have a parameter. Named parameters take precedence over values in the hashtable.

    .PARAMETER PassThru
        Returns the updated rear port. By default, this cmdlet does not generate any output.

    .PARAMETER Force
        Updates the object without asking for confirmation.

    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.

    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.

    .EXAMPLE
        Set-NbxDCIMRearPort -Id 42 -Description 'Updated with NetboxTools'

        Updates the description of the rear port with ID 42.

    .EXAMPLE
        Get-NbxDCIMRearPort -Query @{ q = 'example' } | Set-NbxDCIMRearPort -Description 'Updated' -PassThru

        Updates the description of all rear ports matching the search 'example' and returns the updated rear ports.

    .INPUTS
        System.UInt64, NetboxTools.DCIMRearPort
        You can pipe rear port IDs or rear port objects to this cmdlet.

    .OUTPUTS
        None, NetboxTools.DCIMRearPort
        With -PassThru the updated rear port is returned.

    .LINK
        Get-NbxDCIMRearPort

    .LINK
        New-NbxDCIMRearPort

    .LINK
        Remove-NbxDCIMRearPort
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType('NetboxTools.DCIMRearPort')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NbxIdTransformation('dcim/rear-ports')]
        [uint64[]]$Id,

        [Parameter()]
        [NbxIdTransformation('dcim/devices')]
        [Nullable[uint64]]$Device,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [NbxChoiceTransformation()]
        [ArgumentCompletions('8p8c', '110-punch', 'bnc', 'lc', 'lc-apc', 'lc-upc', 'lsh', 'mpo', 'mtrj', 'sc', 'sc-apc', 'sc-upc', 'st', 'splice', 'other')]
        [string]$Type,

        [Parameter()]
        [NbxIdTransformation('dcim/modules')]
        [Nullable[uint64]]$Module,

        [Parameter()]
        [string]$Label,

        [Parameter()]
        [string]$Color,

        [Parameter()]
        [Nullable[int]]$Positions,

        [Parameter()]
        [Alias('mark_connected')]
        [NbxBoolTransformation()]
        [bool]$MarkConnected,

        [Parameter()]
        [string]$Description,

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
            if (($Force -and -not $WhatIfPreference) -or $PSCmdlet.ShouldProcess("rear port $ObjectId", 'Update')) {
                $Result = InvokeNbxRestMethod -Endpoint "dcim/rear-ports/$ObjectId/" -Method PATCH -Body $Body -TypeName 'NetboxTools.DCIMRearPort'
                if ($PassThru) {
                    $Result
                }
            }
        }
    }
}
