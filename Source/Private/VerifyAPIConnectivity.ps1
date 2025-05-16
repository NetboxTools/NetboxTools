function VerifyAPIConnectivity {

    [CmdletBinding()]
    param ()

    $uriSegments = [System.Collections.ArrayList]::new(@('extras','bookmarks'))

    $uri = BuildNewURI -Segments $uriSegments -Parameters @{'format' = 'json' } -SkipConnectedCheck

    InvokeNbxRequest -URI $uri

}
