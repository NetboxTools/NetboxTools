class NbxBoolTransformation : System.Management.Automation.ArgumentTransformationAttribute {
    <#
        Converts text into booleans for [bool] parameters.

        PowerShell only binds booleans and numbers to [bool] parameters, so values such as 'true'
        from Import-Csv could not be piped to the cmdlets. Accepts true/false, yes/no, 1/0 and
        empty text (false, empty pipeline values are not sent to NetBox).
    #>

    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object]$InputData) {
        $Item = $InputData
        if ($Item -is [psobject]) {
            $Item = $Item.PSObject.BaseObject
        }

        if ($Item -isnot [string]) {
            return $InputData
        }

        switch -Regex ($Item.Trim()) {
            '^(true|yes|1)$' { return $true }
            '^(false|no|0|)$' { return $false }
        }

        throw [System.ArgumentException]::new("'$Item' is not a boolean value. Use true or false.")
    }
}
