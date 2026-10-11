class NbxDictionaryTransformation : System.Management.Automation.ArgumentTransformationAttribute {
    <#
        Converts PSCustomObjects into hashtables.

        NetBox returns dictionaries (such as custom_fields) as PSCustomObjects. This allows such
        objects to be passed to hashtable parameters, for example when piping an object from a Get cmdlet.
    #>

    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object]$InputData) {
        if ($null -eq $InputData) {
            return $null
        }

        $Item = $InputData
        if ($Item -is [psobject]) {
            $Item = $Item.PSObject.BaseObject
        }

        if ($Item -is [System.Collections.IDictionary]) {
            return $Item
        }

        if ($Item -is [System.Management.Automation.PSCustomObject]) {
            $Hashtable = @{}
            foreach ($Property in $InputData.PSObject.Properties) {
                $Hashtable[$Property.Name] = $Property.Value
            }
            return $Hashtable
        }

        return $InputData
    }
}
