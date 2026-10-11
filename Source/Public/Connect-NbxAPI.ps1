function Connect-NbxAPI {
    <#
    .SYNOPSIS
        Connects to the NetBox API.

    .DESCRIPTION
        Connects to the NetBox API of a NetBox instance. The connection is used by all other cmdlets in the module
        until Disconnect-NbxAPI is run or the module is removed.

        Authenticate with an API token, either as a string with -Token or as the password of a credential with
        -Credential. Both NetBox v1 tokens and v2 tokens (prefixed 'nbt_') are supported. Use -Anonymous to connect
        without authentication to NetBox instances that allow anonymous read access.

        The connection is verified with a request to the API, unless -SkipVerification is specified.

    .PARAMETER Hostname
        The hostname of the NetBox instance, such as 'netbox.example.com'. A URL such as
        'https://netbox.example.com:8443' is also accepted, the scheme and port are then taken from the URL.

    .PARAMETER Token
        The API token to authenticate with.

    .PARAMETER Credential
        A credential with the API token as password. The user name is not used.

    .PARAMETER Anonymous
        Connects without authentication.

    .PARAMETER Scheme
        The scheme of the API, https (default) or http.

    .PARAMETER Port
        The port of the API. Defaults to 443 for https and 80 for http.

    .PARAMETER SkipCertificateCheck
        Skips validation of the certificate of the NetBox instance, for example when it uses a self-signed certificate.
        Applies to this connection only, each Connect-NbxAPI validates certificates unless this is specified.

    .PARAMETER SkipVerification
        Does not verify the connection with a request to the API.

    .EXAMPLE
        Connect-NbxAPI -Hostname 'netbox.example.com' -Token $Token

        Connects to https://netbox.example.com/api with an API token.

    .EXAMPLE
        Connect-NbxAPI -Hostname 'netbox.example.com' -Credential (Get-Credential -UserName 'token' -Message 'NetBox API token')

        Connects with an API token entered as the password of a credential.

    .EXAMPLE
        Connect-NbxAPI -Hostname 'http://netbox.lab:8000' -Anonymous

        Connects anonymously to a NetBox instance on http port 8000.

    .INPUTS
        None

    .OUTPUTS
        None

    .LINK
        Disconnect-NbxAPI
    #>
    [CmdletBinding(DefaultParameterSetName = 'Token')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Hostname,

        [Parameter(Mandatory, ParameterSetName = 'Token')]
        [ValidateNotNullOrEmpty()]
        [string]$Token,

        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [pscredential]$Credential,

        [Parameter(Mandatory, ParameterSetName = 'Anonymous')]
        [switch]$Anonymous,

        [Parameter()]
        [ValidateSet('https', 'http')]
        [string]$Scheme = 'https',

        [Parameter()]
        [ValidateRange(1, 65535)]
        [int]$Port,

        [Parameter()]
        [switch]$SkipCertificateCheck,

        [Parameter()]
        [switch]$SkipVerification
    )

    if ($Hostname -match '^https?://') {
        $Url = [uri]$Hostname
        $Hostname = $Url.Host
        $Scheme = $Url.Scheme
        if (-not $PSBoundParameters.ContainsKey('Port') -and -not $Url.IsDefaultPort) {
            $Port = $Url.Port
        }
    }
    if (-not $Port) {
        $Port = if ($Scheme -eq 'http') { 80 } else { 443 }
    }
    if ($Scheme -eq 'http') {
        Write-Warning 'Connecting to NetBox over http, the API token is sent unencrypted.'
    }

    $PreviousConfig = $script:NbxConfig
    $Config = NewNbxConfig
    $Config.Timeout = $PreviousConfig.Timeout
    $Config.InvokeParams = @{} + $PreviousConfig.InvokeParams
    # Certificate validation is decided for each connection, so it is never skipped for another host by accident
    $Config.InvokeParams['SkipCertificateCheck'] = $SkipCertificateCheck.IsPresent
    $Config.Hostname = $Hostname
    $Config.Scheme = $Scheme
    $Config.Port = $Port

    switch ($PSCmdlet.ParameterSetName) {
        'Token' {
            $Config.AuthenticationType = 'Token'
            $Config.Credential = [pscredential]::new('token', [System.Net.NetworkCredential]::new('', $Token).SecurePassword)
        }
        'Credential' {
            $Config.AuthenticationType = 'Token'
            $Config.Credential = $Credential
        }
        'Anonymous' {
            $Config.AuthenticationType = 'Anonymous'
        }
    }

    $script:NbxConfig = $Config
    UpdateNbxUri
    Write-Verbose "Connecting to NetBox at $($script:NbxConfig.URI) ($($Config.AuthenticationType))."

    if ($SkipVerification) {
        Write-Verbose 'Skipping verification of the connection.'
        return
    }

    # users/config requires authentication, the status endpoint is used for anonymous connections
    $Endpoint = if ($Config.AuthenticationType -eq 'Token') { 'users/config/' } else { 'status/' }
    try {
        $null = InvokeNbxRestMethod -Endpoint $Endpoint -ErrorAction Stop
    }
    catch {
        $script:NbxConfig = $PreviousConfig
        $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                [System.InvalidOperationException]::new("Failed to connect to NetBox at $($Config.Hostname). $($_.Exception.Message)", $_.Exception),
                'NbxConnectFailed',
                [System.Management.Automation.ErrorCategory]::ConnectionError,
                $Config.Hostname
            ))
    }
    Write-Verbose "Connected to NetBox at $($script:NbxConfig.URI)."
}
