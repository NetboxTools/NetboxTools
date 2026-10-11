function NewNbxConfig {
    <#
        Returns the default (disconnected) module configuration.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param ()

    @{
        'Hostname'           = $null
        'Scheme'             = 'https'
        'Port'               = 443
        'URI'                = $null
        'AuthenticationType' = $null
        'Credential'         = [System.Management.Automation.PSCredential]::Empty
        'Timeout'            = 30
        'InvokeParams'       = @{ SkipCertificateCheck = $false }
    }
}
