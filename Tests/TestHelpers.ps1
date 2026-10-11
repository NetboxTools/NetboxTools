<#
    Shared helpers for the Pester tests.

    Tests mock Invoke-RestMethod, the boundary to the NetBox API, so that the module's own
    request handling (URIs, query strings, request bodies, pagination and errors) is tested.
#>

function global:Initialize-NbxTestConnection {
    InModuleScope NetboxTools {
        $script:NbxConfig = NewNbxConfig
        $script:NbxConfig.Hostname = 'netbox.example.com'
        $script:NbxConfig.AuthenticationType = 'Token'
        $script:NbxConfig.Credential = [pscredential]::new('token', (ConvertTo-SecureString -String '0123456789abcdef' -AsPlainText -Force))
        UpdateNbxUri
    }
}

function global:New-NbxTestResponse {
    <#
        Returns a response like the NetBox API does for the request.
    #>
    param (
        [string]$Uri,
        [string]$Method,
        [string]$Body
    )

    if ($Method -eq 'DELETE') {
        return
    }

    $Path = ([uri]$Uri).AbsolutePath
    $Endpoint = $Path -replace '^/api/', '' -replace '\d+/$', '' -replace '/$', ''

    $Object = [ordered]@{
        id      = 1
        url     = "https://netbox.example.com/api/$Endpoint/1/"
        display = 'Test object'
    }
    if ($Path -match '/(?<id>\d+)/$') {
        $Object.id = [int]$Matches.id
        $Object.url = "https://netbox.example.com$Path"
    }
    if ($Body) {
        foreach ($Property in ($Body | ConvertFrom-Json).PSObject.Properties) {
            $Object[$Property.Name] = $Property.Value
        }
    }

    if ($Method -eq 'GET' -and $Path -notmatch '/\d+/$') {
        return [pscustomobject]@{
            count    = 1
            next     = $null
            previous = $null
            results  = @([pscustomobject]$Object)
        }
    }

    [pscustomobject]$Object
}
