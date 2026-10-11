function UpdateNbxUri {
    <#
        Rebuilds the API base URI from the configured hostname, scheme and port.
    #>
    [CmdletBinding()]
    param ()

    if ([string]::IsNullOrWhiteSpace($script:NbxConfig.Hostname)) {
        $script:NbxConfig.URI = $null
        return
    }

    $script:NbxConfig.URI = [System.UriBuilder]::new(
        $script:NbxConfig.Scheme,
        $script:NbxConfig.Hostname,
        $script:NbxConfig.Port,
        'api'
    ).Uri.AbsoluteUri.TrimEnd('/')
}
