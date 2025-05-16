function SetupNbxConfigVariable {

    [CmdletBinding()]
    param
    (
        [switch]$Overwrite
    )

    Write-Verbose "Checking for NbxConfig hashtable"
    if ((-not ($script:NbxConfig)) -or $Overwrite) {
        Write-Verbose "Creating NbxConfig hashtable"
        $script:NbxConfig = @{
            'Connected'     = $false
            'Choices'       = @{
            }
            'APIDefinition' = $null
            'ContentTypes' = $null
        }
    }

    Write-Verbose "NbxConfig hashtable already exists"

}
