function Set-NbxIPAMAddress {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id,

        [string]$Address,

        [string]$Status,

        [uint64]$Tenant,

        [uint64]$VRF,

        [object]$Role,

        [uint64]$NAT_Inside,

        [hashtable]$Custom_Fields,

        [ValidateSet('dcim.interface', 'virtualization.vminterface', IgnoreCase = $true)]
        [string]$Assigned_Object_Type,

        [uint64]$Assigned_Object_Id,

        [string]$Description,

        [string]$Dns_name
    )
    
    $Id | ForEach-Object {
        if ($PSBoundParameters.ContainsKey('Assigned_Object_Type') -or $PSBoundParameters.ContainsKey('Assigned_Object_Id')) {
            if ((-not [string]::IsNullOrWhiteSpace($Assigned_Object_Id)) -and [string]::IsNullOrWhiteSpace($Assigned_Object_Type)) {
                throw "Assigned_Object_Type is required when specifying Assigned_Object_Id"
            }
            elseif ((-not [string]::IsNullOrWhiteSpace($Assigned_Object_Type)) -and [string]::IsNullOrWhiteSpace($Assigned_Object_Id)) {
                throw "Assigned_Object_Id is required when specifying Assigned_Object_Type"
            }
        }
        $Body = @{
            Address              = $Address
            Status               = $Status
            Tenant               = $Tenant
            VRF                  = $VRF
            Role                 = $Role
            NAT_Inside           = $NAT_Inside
            Custom_Fields        = $Custom_Fields
            Assigned_Object_Type = $Assigned_Object_Type
            Assigned_Object_Id   = $Assigned_Object_Id
            Description          = $Description
            Dns_name             = $Dns_name
        }

        $Json = $Body | ConvertTo-Json -Depth 100

        InvokeNbxRestMethod -URI "$($script:NbxConfig.URI)/ipam/ip-addresses/$($_)" -Method PATCH -Body $Json
    }

}
