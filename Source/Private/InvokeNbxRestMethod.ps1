function InvokeNbxRestMethod {
    <#
        Sends a request to the NetBox REST API.

        - Builds the request URI from the configured connection and the relative endpoint.
        - Adds authentication (v1 'Token' or v2 'Bearer' tokens) and the configured timeout and invoke parameters.
        - Follows pagination for list requests, returning the objects in 'results' as individual objects.
        - Decorates returned objects with a PSTypeName when TypeName is specified.
        - Reports API errors as non-terminating errors with the error message returned by NetBox.
    #>
    [CmdletBinding()]
    param (
        # Path relative to the API root, such as 'dcim/devices/' or 'dcim/devices/42/'
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [Parameter()]
        [ValidateSet('GET', 'POST', 'PATCH', 'PUT', 'DELETE')]
        [string]$Method = 'GET',

        [Parameter()]
        [System.Collections.IDictionary]$Query,

        [Parameter()]
        [object]$Body,

        # Maximum number of objects to return from a list request. 0 returns all objects.
        [Parameter()]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Limit = 0,

        [Parameter()]
        [string]$TypeName,

        # Credential to authenticate with instead of the configured one, used when connecting
        [Parameter()]
        [pscredential]$Credential
    )

    if ([string]::IsNullOrEmpty($script:NbxConfig.URI)) {
        $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                [System.InvalidOperationException]::new('Not connected to NetBox. Run Connect-NbxAPI first.'),
                'NbxNotConnected',
                [System.Management.Automation.ErrorCategory]::ConnectionError,
                $null
            ))
    }

    $Headers = @{ 'Accept' = 'application/json' }

    if (-not $PSBoundParameters.ContainsKey('Credential')) {
        $Credential = $script:NbxConfig.Credential
    }
    if ($script:NbxConfig.AuthenticationType -eq 'Token' -or $PSBoundParameters.ContainsKey('Credential')) {
        if ($null -eq $Credential -or $Credential -eq [pscredential]::Empty) {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                    [System.InvalidOperationException]::new('No NetBox API token is configured. Run Connect-NbxAPI with a valid token.'),
                    'NbxNoToken',
                    [System.Management.Automation.ErrorCategory]::AuthenticationError,
                    $null
                ))
        }
        $Token = $Credential.GetNetworkCredential().Password
        # NetBox v2 tokens are prefixed 'nbt_' and use the Bearer keyword, v1 tokens use the Token keyword
        $Keyword = if ($Token.StartsWith('nbt_')) { 'Bearer' } else { 'Token' }
        $Headers['Authorization'] = "$Keyword $Token"
    }

    # Explicit limit or offset in the query disables automatic pagination
    $Paginate = -not ($Query -and ($Query.Contains('limit') -or $Query.Contains('offset')))
    $RequestQuery = [ordered]@{}
    if ($Query) {
        foreach ($Key in $Query.Keys) {
            $RequestQuery[[string]$Key] = $Query[$Key]
        }
    }
    if ($Method -eq 'GET' -and $Paginate -and $Endpoint -notmatch '/\d+/?$') {
        $RequestQuery['limit'] = if ($Limit -gt 0) { [Math]::Min($Limit, 1000) } else { 1000 }
    }

    $BaseUri = '{0}/{1}' -f $script:NbxConfig.URI, $Endpoint.TrimStart('/')
    $QueryString = ConvertToNbxQueryString -Query $RequestQuery

    $InvokeSplat = @{
        'Method'      = $Method
        'Headers'     = $Headers
        'ContentType' = 'application/json; charset=utf-8'
        'TimeoutSec'  = $script:NbxConfig.Timeout
        'ErrorAction' = 'Stop'
    }
    if ($script:NbxConfig.InvokeParams -is [System.Collections.IDictionary]) {
        foreach ($Key in $script:NbxConfig.InvokeParams.Keys) {
            if ($Key -eq 'Headers') {
                # Add custom headers, the Authorization and Accept headers of the module take precedence
                foreach ($Header in $script:NbxConfig.InvokeParams[$Key].GetEnumerator()) {
                    if (-not $Headers.ContainsKey($Header.Key)) {
                        $Headers[$Header.Key] = $Header.Value
                    }
                }
                continue
            }
            $InvokeSplat[$Key] = $script:NbxConfig.InvokeParams[$Key]
        }
    }
    if ($PSBoundParameters.ContainsKey('Body')) {
        $InvokeSplat['Body'] = if ($Body -is [string]) { $Body } else { ConvertTo-Json -InputObject $Body -Depth 10 -Compress }
        Write-Debug "Request body: $($InvokeSplat['Body'])"
    }

    $Returned = 0
    do {
        $InvokeSplat['Uri'] = if ($QueryString) { "$BaseUri`?$QueryString" } else { $BaseUri }
        Write-Verbose "$Method $($InvokeSplat['Uri'])"

        try {
            $Response = Invoke-RestMethod @InvokeSplat
        }
        catch {
            $PSCmdlet.WriteError((ConvertToNbxErrorRecord -ErrorRecord $_ -Method $Method -Uri $InvokeSplat['Uri']))
            return
        }

        $QueryString = $null

        if ($null -eq $Response -or ($Response -is [string] -and [string]::IsNullOrWhiteSpace($Response))) {
            return
        }

        $IsList = $Response -isnot [string] -and
            $Response.PSObject.Properties.Name -contains 'results' -and
            $Response.PSObject.Properties.Name -contains 'next'

        $Objects = if ($IsList) { $Response.results } else { $Response }

        foreach ($Object in $Objects) {
            if ($Limit -gt 0 -and $Returned -ge $Limit) {
                return
            }
            if ($TypeName -and $Object -is [psobject]) {
                $Object.PSObject.TypeNames.Insert(0, $TypeName)
            }
            $Object
            $Returned++
        }

        if ($IsList -and $Paginate -and $Response.next -and ($Limit -eq 0 -or $Returned -lt $Limit)) {
            # Reuse the query of the next page on the configured base URI, as the next link
            # returned by NetBox may use another scheme or host when behind a proxy.
            $QueryString = ([uri]$Response.next).Query.TrimStart('?')
        }
    } while ($QueryString)
}
