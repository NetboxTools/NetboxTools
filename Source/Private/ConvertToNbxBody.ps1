function ConvertToNbxBody {
    <#
        Builds a NetBox request body from the parameters bound to a public cmdlet.

        The NetBox field name of a parameter is its first lower case alias (e.g. 'device_type'
        for -DeviceType), or the lower cased parameter name when it has no such alias.

        Parameters bound on the command line are always included, a $null value is sent to
        clear the field. When CommandLineParameters is specified, parameters bound from the
        pipeline are only included when the current input object has the property; this
        works around PowerShell keeping values from a previous pipeline object in
        $PSBoundParameters. $null and empty values from the pipeline are ignored.

        OptionalAttribute is added to the body as-is, named parameters take precedence.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.CommandInfo]$Command,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$BoundParameters,

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]]$CommandLineParameters,

        [Parameter()]
        [AllowNull()]
        [object]$InputObject,

        [Parameter()]
        [string[]]$Exclude = @('Id', 'Force', 'PassThru', 'OptionalAttribute')
    )

    $Ignored = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($Name in [System.Management.Automation.Cmdlet]::CommonParameters + [System.Management.Automation.Cmdlet]::OptionalCommonParameters + $Exclude) {
        $null = $Ignored.Add($Name)
    }

    $InputProperties = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if ($null -ne $InputObject -and $InputObject -isnot [ValueType] -and $InputObject -isnot [string]) {
        foreach ($Name in $InputObject.PSObject.Properties.Name) {
            $null = $InputProperties.Add($Name)
        }
    }

    $Body = @{}

    $OptionalAttribute = $BoundParameters['OptionalAttribute']
    if ($OptionalAttribute -is [System.Collections.IDictionary]) {
        foreach ($Key in $OptionalAttribute.Keys) {
            $Body[[string]$Key] = $OptionalAttribute[$Key]
        }
    }

    foreach ($Key in $BoundParameters.Keys) {
        if ($Ignored.Contains($Key)) {
            continue
        }

        $Parameter = $Command.Parameters[$Key]
        $Names = @($Key) + @($Parameter.Aliases)

        $FromCommandLine = -not $PSBoundParameters.ContainsKey('CommandLineParameters') -or $CommandLineParameters -contains $Key
        if (-not $FromCommandLine) {
            $InputName = $Names | Where-Object { $InputProperties.Contains($_) } | Select-Object -First 1
            if (-not $InputName) {
                continue
            }
            # Check the value on the input object, PowerShell converts empty text to 0 when binding numbers,
            # so empty cells from Import-Csv would otherwise be sent as 0
            $InputValue = $InputObject.PSObject.Properties[$InputName].Value
            if ($null -eq $InputValue -or ($InputValue -is [string] -and [string]::IsNullOrWhiteSpace($InputValue))) {
                continue
            }
        }

        $Value = $BoundParameters[$Key]
        if ($Value -is [System.Management.Automation.SwitchParameter]) {
            $Value = $Value.IsPresent
        }
        if ($null -eq $Value -and -not $FromCommandLine) {
            continue
        }

        $ApiName = $Parameter.Aliases | Where-Object { $_ -cmatch '^[a-z][a-z0-9_]*$' } | Select-Object -First 1
        if (-not $ApiName) {
            $ApiName = $Key.ToLowerInvariant()
        }

        $Body[$ApiName] = $Value
    }

    $Body
}
