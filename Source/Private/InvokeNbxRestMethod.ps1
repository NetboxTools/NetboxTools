function InvokeNbxRestMethod {
    param (
        [Parameter(Mandatory)]
        [URI]$Uri,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,

        [Parameter()]
        [string]$Body,

        [Parameter()]
        [string]$ContentType = 'application/json',

        [Parameter()]
        [switch]$FullResponse,

        [Parameter()]
        [string]$OutFile,

        [Parameter()]
        [string]$Token
    )
    
    if ($script:NbxConfig.AuthenticationType -eq 'Anonymous') {

        Write-Verbose "Requests will be sent anonymously."

        $InvokeSplat = @{
            'Uri'         = $Uri
            'Method'      = $Method
            'ContentType' = $ContentType
        }
    }
    elseif ($script:NbxConfig.AuthenticationType -eq 'Token') {

        Write-Verbose "Requests will be sent with Token authentication."

        if (-not $PSBoundParameters.ContainsKey('Token')) {
            if (-not $script:NbxConfig.Token) {
                throw 'Please login with Connect-NbxAPI first and provide a valid token.'
            }
            $InvokeSplat = @{
                'Uri'     = $Uri
                'Method'  = $Method
                'Headers' = @{
                    'Authorization' = "Token $($script:NbxConfig.Token)"
                    "Accept"        = 'application/json; indent=4'
                    'ContentType'   = $ContentType
                }
            }
        }
        else {
            $InvokeSplat = @{
                'Uri'     = $Uri
                'Method'  = $Method
                'Headers' = @{
                    'Authorization' = "Token $Token"
                    "Accept"        = 'application/json; indent=4'
                    'ContentType'   = $ContentType
                }
            }
        }

    }
    else {
        throw 'Please login with Connect-NbxAPI first'
    }

    if (-not [string]::IsNullOrEmpty($Body)) {
        $InvokeSplat.Add('Body', $Body)
    }

    if ($FullResponse) {
        $InvokeSplat.Add('ResponseHeadersVariable', 'ResponseHeaders')
        $InvokeSplat.Add('StatusCodeVariable', 'ResponseStatusCode')
    }

    if ($OutFile) {
        Write-Debug "$Method $Uri"
        Invoke-RestMethod @InvokeSplat -OutFile $OutFile
    }
    else {
        Write-Debug "$Method $Uri"
        $Result = Invoke-RestMethod @InvokeSplat
        if ($FullResponse) {
            @{ Content = $Result; Headers = $ResponseHeaders; StatusCode = $ResponseStatusCode }
        }
        else {
            $Result
        }
    }
}