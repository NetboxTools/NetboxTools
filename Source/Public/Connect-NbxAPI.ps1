function Connect-NbxAPI {
    <#
    .SYNOPSIS
        Connect to the Netbox API using an API Token

    .DESCRIPTION
        Connect to the Netbox API using an API Token. This function sets up the global configuration
        for subsequent API calls.

    .PARAMETER Hostname
        The hostname for the resource such as netbox.domain.com

    .PARAMETER Scheme
        Scheme for the URI such as HTTP or HTTPS. Defaults to HTTPS

    .PARAMETER Port
        Port for the resource. Value between 1-65535

    .PARAMETER Token
        The API Token for authentication

    .PARAMETER SkipVerification
        Skip verification of organization access
#>
    [CmdletBinding(DefaultParameterSetName = 'Authorized')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Authorized')]
        [Parameter(Mandatory, ParameterSetName = 'Anonymous')]
        [string]$Hostname,
        
        [Parameter(ParameterSetName = 'Authorized')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [ValidateSet('https', 'http', IgnoreCase = $true)]
        [string]$Scheme = 'https',

        [Parameter(ParameterSetName = 'Authorized')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [uint16]$Port = 443,

        [Parameter(Mandatory, ParameterSetName = 'Authorized')]
        [string]$Token,
        
        [Parameter(ParameterSetName = 'Authorized')]
        [switch]$SkipVerification
    )

    switch ($PSCmdlet.ParameterSetName) {
        'Anonymous' {
            $script:NbxConfig = @{
                'Hostname'           = $Hostname
                'Scheme'             = $Scheme
                'Port'               = $Port
                'URI'                = [System.UriBuilder]::new($Scheme, $Hostname, $Port, 'api').ToString().TrimEnd('/')
                'AuthenticationType' = 'Anonymous'
            }
            Write-Verbose "Connected to Netbox at $($script:NbxConfig.URI) in anonymous mode."
        }
        'Authorized' {
            $script:NbxConfig = @{
                'Hostname'           = $Hostname
                'Scheme'             = $Scheme
                'Port'               = $Port
                'URI'                = [System.UriBuilder]::new($Scheme, $Hostname, $Port, 'api').ToString().TrimEnd('/')
                'Token'              = $Token
                'AuthenticationType' = 'Token'
            }
            
            Write-Verbose "Connecting to Netbox at $($script:NbxConfig.URI) with provided token."

            if (-not $PSBoundParameters.ContainsKey('SkipVerification')) {
                # Get User context
                $Me = InvokeNbxRestMethod -Method GET -Token $script:NbxConfig.Token -Uri "$($script:NbxConfig.URI)/users/config/"

                if ($Me) {
                    Write-Verbose "Connected to Netbox"
                    Write-verbose $($Me | ConvertTo-json -Depth 100)
                }
                else {
                    throw "Failed to connect to Netbox at $($script:NbxConfig.URI) using provided token."
                }

            }
            else {
                Write-Verbose 'Skipping netbox access verification.'
            }
        }
    }
}