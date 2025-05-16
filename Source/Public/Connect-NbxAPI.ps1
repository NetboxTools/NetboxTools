function Connect-NbxAPI {

<#
    .SYNOPSIS
        Connects to the Netbox API and ensures Credential work properly

    .DESCRIPTION
        Connects to the Netbox API and ensures Credential work properly

    .PARAMETER Hostname
        The hostname for the resource such as netbox.domain.com

    .PARAMETER Credential
        Credential object containing the API key in the password. Username is not applicable

    .PARAMETER Scheme
        Scheme for the URI such as HTTP or HTTPS. Defaults to HTTPS

    .PARAMETER Port
        Port for the resource. Value between 1-65535

    .PARAMETER URI
        The full URI for the resource such as "https://netbox.domain.com:8443"

    .PARAMETER SkipCertificateCheck
        A description of the SkipCertificateCheck parameter.

    .PARAMETER TimeoutSeconds
        The number of seconds before the HTTP call times out. Defaults to 30 seconds

    .EXAMPLE
        PS C:\> Connect-NbxAPI -Hostname "netbox.domain.com"

        This will prompt for Credential, then proceed to attempt a connection to Netbox

    .NOTES
        Additional information about the function.
#>

    [CmdletBinding(DefaultParameterSetName = 'Manual')]
    param
    (
        [Parameter(ParameterSetName = 'Manual',
                   Mandatory = $true)]
        [string]$Hostname,

        [Parameter(Mandatory = $false)]
        [pscredential]$Credential,

        [Parameter(ParameterSetName = 'Manual')]
        [ValidateSet('https', 'http', IgnoreCase = $true)]
        [string]$Scheme = 'https',

        [Parameter(ParameterSetName = 'Manual')]
        [uint16]$Port = 443,

        [Parameter(ParameterSetName = 'URI',
                   Mandatory = $true)]
        [string]$URI,

        [Parameter(Mandatory = $false)]
        [switch]$SkipCertificateCheck = $false,

        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 65535)]
        [uint16]$TimeoutSeconds = 30
    )

    if (-not $Credential) {
        try {
            $Credential = Get-NbxCredential -ErrorAction Stop
        } catch {
            # Credentials are not set... Try to obtain from the user
            if (-not ($Credential = Get-Credential -UserName 'username-not-applicable' -Message "Enter token for Netbox")) {
                throw "Token is necessary to connect to a Netbox API."
            }
        }
    }

    $invokeParams = @{ SkipCertificateCheck = $SkipCertificateCheck; }

    if ("Desktop" -eq $PSVersionTable.PsEdition) {
        #Remove -SkipCertificateCheck from Invoke Parameter (not supported <= PS 5)
        $invokeParams.remove("SkipCertificateCheck")
    }

    #for PowerShell (<=) 5 (Desktop), Enable TLS 1.1, 1.2 and Disable SSL chain trust
    if ("Desktop" -eq $PSVersionTable.PsEdition) {
        #Add System.web (Need for ParseQueryString)
        Add-Type -AssemblyName System.Web
        #Enable TLS 1.1 and 1.2
        Set-NbxCipherSSL
        if ($SkipCertificateCheck) {
            #Disable SSL chain trust...
            Set-NbxuntrustedSSL
        }
    }

    switch ($PSCmdlet.ParameterSetName) {
        'Manual' {
            $uriBuilder = [System.UriBuilder]::new($Scheme, $Hostname, $Port)
        }

        'URI' {
            $uriBuilder = [System.UriBuilder]::new($URI)
            if ([string]::IsNullOrWhiteSpace($uriBuilder.Host)) {
                throw "URI appears to be invalid. Must be in format [host.name], [scheme://host.name], or [scheme://host.name:port]"
            }
        }
    }

    $null = Set-NbxHostName -Hostname $uriBuilder.Host
    $null = Set-NbxCredential -Credential $Credential
    $null = Set-NbxHostScheme -Scheme $uriBuilder.Scheme
    $null = Set-NbxHostPort -Port $uriBuilder.Port
    $null = Set-NbxInvokeParams -invokeParams $invokeParams
    $null = Set-NbxTimeout -TimeoutSeconds $TimeoutSeconds

    try {
        Write-Verbose "Verifying API connectivity..."
        $null = VerifyAPIConnectivity
    } catch {
        Write-Verbose "Failed to connect. Generating error"
        Write-Verbose $_.Exception.Message
        if (($_.Exception.Response) -and ($_.Exception.Response.StatusCode -eq 403)) {
            throw "Invalid token"
        } else {
            throw $_
        }
    }

#    Write-Verbose "Caching API definition"
#    $script:NbxConfig.APIDefinition = Get-NbxAPIDefinition
#
#    if ([version]$script:NbxConfig.APIDefinition.info.version -lt 2.8) {
#        $Script:NbxConfig.Connected = $false
#        throw "Netbox version is incompatible with this PS module. Requires >=2.8.*, found version $($script:NbxConfig.APIDefinition.info.version)"
    #    }

    Write-Verbose "Checking Nbx version compatibility"
    $script:NbxConfig.NbxVersion = Get-NbxVersion
    if ([version]$script:NbxConfig.NbxVersion.'Netbox-version'.split('-')[0] -lt 2.8) {
        $Script:NbxConfig.Connected = $false
        throw "Nbx version is incompatible with this PS module. Requires >=2.8.*, found version $($script:NbxConfig.NbxVersion.'Netbox-version')"
    } else {
        Write-Verbose "Found compatible version [$($script:NbxConfig.NbxVersion.'Netbox-version')]!"
    }

    $script:NbxConfig.Connected = $true
    Write-Verbose "Successfully connected!"

    $script:NbxConfig.ContentTypes = Get-NbxContentType -Limit 500

    Write-Verbose "Connection process completed"

}
