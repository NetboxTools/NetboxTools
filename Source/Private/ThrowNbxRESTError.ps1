function ThrowNbxRESTError {

    $uriSegments = [System.Collections.ArrayList]::new(@('fake', 'url'))

    $URIParameters = @{
    }

    $uri = BuildNewURI -Segments $uriSegments -Parameters $URIParameters

    InvokeNbxRequest -URI $uri -Raw

}
