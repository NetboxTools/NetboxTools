class NbxIdTransformation : System.Management.Automation.ArgumentTransformationAttribute {
    <#
        Converts parameter input into NetBox object IDs.

        Accepts plain IDs (numbers or numeric strings), NetBox objects as returned by the API
        (full or nested/brief), PSCustomObjects and hashtables that have an 'id' property.

        When the input object has a 'url' property, it is validated against the endpoint(s) given
        to the attribute so that, for example, an interface object can not be passed to a cmdlet
        that expects a device.
    #>

    [string[]]$Endpoint

    NbxIdTransformation() {
        $this.Endpoint = @()
    }

    NbxIdTransformation([string]$Endpoint) {
        $this.Endpoint = @($Endpoint)
    }

    NbxIdTransformation([string]$Endpoint1, [string]$Endpoint2) {
        $this.Endpoint = @($Endpoint1, $Endpoint2)
    }

    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object]$InputData) {
        if ($null -eq $InputData) {
            return $null
        }

        $Result = [System.Collections.Generic.List[object]]::new()
        foreach ($Item in @($InputData)) {
            $Result.Add($this.ConvertItem($Item))
        }

        if ($InputData -is [array] -or $InputData -is [System.Collections.IList]) {
            return $Result.ToArray()
        }
        return $Result[0]
    }

    hidden [object] ConvertItem([object]$Item) {
        if ($Item -is [psobject] -and $Item.PSObject.BaseObject -isnot [System.Management.Automation.PSCustomObject]) {
            $Item = $Item.PSObject.BaseObject
        }

        if ($Item -is [string] -or $Item -is [ValueType]) {
            # Leave conversion and its error message to the parameter type
            return $Item
        }

        if ($Item -is [System.Collections.IDictionary]) {
            $Item = [pscustomobject]$Item
        }

        $Properties = $Item.PSObject.Properties.Name
        if ($Properties -notcontains 'id') {
            throw [System.ArgumentException]::new("The input object does not have an 'id' property and can not be used as a NetBox object.")
        }

        if ($this.Endpoint.Count -gt 0 -and $Properties -contains 'url' -and -not [string]::IsNullOrEmpty($Item.url)) {
            $Path = ([uri]$Item.url).AbsolutePath
            $Match = $false
            foreach ($Ep in $this.Endpoint) {
                if ($Path -match "/api/$([regex]::Escape($Ep.Trim('/')))/\d+/?$") {
                    $Match = $true
                }
            }
            if (-not $Match) {
                throw [System.ArgumentException]::new(
                    "The input object '$($Item.url)' is not of the expected type. Expected an object from: $($this.Endpoint -join ', ')."
                )
            }
        }

        return $Item.id
    }
}
