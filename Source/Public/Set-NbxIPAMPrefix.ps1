function Set-NbxIPAMPrefix {

    [CmdletBinding(ConfirmImpact = 'Medium',
                   SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id,

        [string]$Prefix,

        [string]$Status,

        [uint64]$Tenant,

        [uint64]$Site,

        [uint64]$VRF,

        [uint64]$VLAN,

        [object]$Role,

        [hashtable]$Custom_Fields,

        [string]$Description,

        [switch]$Is_Pool,

        [switch]$Force
    )

    begin {
        #        Write-Verbose "Validating enum properties"
        #        $Segments = [System.Collections.ArrayList]::new(@('ipam', 'ip-addresses', 0))
        $Method = 'PATCH'
        #
        #        # Value validation
        #        $ModelDefinition = GetModelDefinitionFromURIPath -Segments $Segments -Method $Method
        #        $EnumProperties = GetModelEnumProperties -ModelDefinition $ModelDefinition
        #
        #        foreach ($Property in $EnumProperties.Keys) {
        #            if ($PSBoundParameters.ContainsKey($Property)) {
        #                Write-Verbose "Validating property [$Property] with value [$($PSBoundParameters.$Property)]"
        #                $PSBoundParameters.$Property = ValidateValue -ModelDefinition $ModelDefinition -Property $Property -ProvidedValue $PSBoundParameters.$Property
        #            } else {
        #                Write-Verbose "User did not provide a value for [$Property]"
        #            }
        #        }
        #
        #        Write-Verbose "Finished enum validation"
    }

    process {
        foreach ($PrefixId in $Id) {
            $Segments = [System.Collections.ArrayList]::new(@('ipam', 'prefixes', $PrefixId))

            Write-Verbose "Obtaining Prefix from ID $PrefixId"
            $CurrentPrefix = Get-NbxIPAMPrefix -Id $PrefixId -ErrorAction Stop

            if ($Force -or $PSCmdlet.ShouldProcess($CurrentPrefix.Prefix, 'Set')) {
                $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Id', 'Force'

                $URI = BuildNewURI -Segments $URIComponents.Segments

                InvokeNbxRequest -URI $URI -Body $URIComponents.Parameters -Method $Method
            }
        }
    }

}
