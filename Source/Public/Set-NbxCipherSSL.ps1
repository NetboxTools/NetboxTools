function Set-NbxCipherSSL {
    <#
    .SYNOPSIS
        Enables TLS 1.1 and 1.2 for the NetBox connection. Deprecated.

    .DESCRIPTION
        This cmdlet is deprecated, has no effect and will be removed in a future version.

        It configured System.Net.ServicePointManager, which is not used by Invoke-RestMethod in PowerShell 7.
        PowerShell 7 uses the TLS versions supported by the operating system, including TLS 1.2 and 1.3.
        To select TLS versions, use Set-NbxInvokeParameter -InvokeParameter @{ SslProtocol = 'Tls12' }.

    .EXAMPLE
        Set-NbxInvokeParameter -InvokeParameter @{ SslProtocol = 'Tls12' }

        Use this instead of Set-NbxCipherSSL to restrict the TLS version.

    .INPUTS
        None

    .OUTPUTS
        None

    .LINK
        Set-NbxInvokeParameter
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Deprecated, does not change state.')]
    [CmdletBinding()]
    [OutputType([void])]
    param ()

    Write-Warning "Set-NbxCipherSSL is deprecated and has no effect in PowerShell 7. Use Set-NbxInvokeParameter -InvokeParameter @{ SslProtocol = 'Tls12' } to select TLS versions."
}
