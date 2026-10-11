class NbxChoiceTransformation : System.Management.Automation.ArgumentTransformationAttribute {
    <#
        Converts NetBox choice fields into their value.

        NetBox returns choice fields (such as status) as objects: @{ value = 'active'; label = 'Active' }.
        This allows such objects to be passed as-is, for example when piping an object from a Get cmdlet.
    #>

    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object]$InputData) {
        if ($null -eq $InputData) {
            return $null
        }

        $Item = $InputData
        if ($Item -is [psobject] -and $Item.PSObject.BaseObject -isnot [System.Management.Automation.PSCustomObject]) {
            $Item = $Item.PSObject.BaseObject
        }

        if ($Item -is [System.Collections.IDictionary] -and $Item.Contains('value')) {
            return $Item['value']
        }

        if ($Item -isnot [string] -and $Item -isnot [ValueType] -and $Item.PSObject.Properties.Name -contains 'value') {
            return $Item.value
        }

        return $InputData
    }
}
