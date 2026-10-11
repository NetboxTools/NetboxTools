function Get-NbxCredential {
    <#
    .SYNOPSIS
        Gets the credential of the NetBox connection.

    .DESCRIPTION
        Gets the credential holding the API token used to authenticate to the NetBox API.
        The API token is the password of the credential.

    .EXAMPLE
        (Get-NbxCredential).GetNetworkCredential().Password

        Gets the API token of the current connection as plain text.

    .INPUTS
        None

    .OUTPUTS
        System.Management.Automation.PSCredential

    .LINK
        Connect-NbxAPI
    #>
    [CmdletBinding()]
    [OutputType([pscredential])]
    param ()

    if ($null -eq $script:NbxConfig.Credential -or $script:NbxConfig.Credential -eq [pscredential]::Empty) {
        $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                [System.InvalidOperationException]::new('No NetBox API token is configured. Run Connect-NbxAPI with a token.'),
                'NbxNoToken',
                [System.Management.Automation.ErrorCategory]::AuthenticationError,
                $null
            ))
    }

    $script:NbxConfig.Credential
}
