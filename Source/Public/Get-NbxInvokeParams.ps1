function Get-NbxInvokeParams {

    [CmdletBinding()]
    param ()

    Write-Verbose "Getting Nbx InvokeParams"
    if ($null -eq $script:NbxConfig.InvokeParams) {
        throw "Nbx Invoke Params is not set! You may set it with Set-NbxInvokeParams -InvokeParams ..."
    }

    $script:NbxConfig.InvokeParams

}
