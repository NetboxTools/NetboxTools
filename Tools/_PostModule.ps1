$script:NbxConfig = NewNbxConfig

# Aliases for renamed cmdlets, for backward compatibility
$NbxAliases = @{
    'Add-NbxDCIMInterface'           = 'New-NbxDCIMInterface'
    'Add-NbxDCIMFrontPort'           = 'New-NbxDCIMFrontPort'
    'Add-NbxDCIMRearPort'            = 'New-NbxDCIMRearPort'
    'Add-NbxVirtualMachineInterface' = 'New-NbxVirtualMachineInterface'
    # Renamed to use a singular noun
    'Set-NbxInvokeParams'            = 'Set-NbxInvokeParameter'
}
foreach ($Alias in $NbxAliases.GetEnumerator()) {
    Set-Alias -Name $Alias.Key -Value $Alias.Value
}
Export-ModuleMember -Function '*-Nbx*' -Alias @($NbxAliases.Keys)
