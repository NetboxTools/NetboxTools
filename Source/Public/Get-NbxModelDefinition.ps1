function Get-NbxModelDefinition {

    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param
    (
        [Parameter(ParameterSetName = 'ByName',
                   Mandatory)]
        [string]$ModelName,

        [Parameter(ParameterSetName = 'ByPath',
                   Mandatory)]
        [string]$URIPath,

        [Parameter(ParameterSetName = 'ByPath')]
        [string]$Method = "post"
    )

    switch ($PsCmdlet.ParameterSetName) {
        'ByName' {
            $script:NbxConfig.APIDefinition.definitions.$ModelName
            break
        }

        'ByPath' {
            switch ($Method) {
                "get" {

                    break
                }

                "post" {
                    if (-not $URIPath.StartsWith('/')) {
                        $URIPath = "/$URIPath"
                    }

                    if (-not $URIPath.EndsWith('/')) {
                        $URIPath = "$URIPath/"
                    }

                    $ModelName = $script:NbxConfig.APIDefinition.paths.$URIPath.post.parameters.schema.'$ref'.split('/')[-1]
                    $script:NbxConfig.APIDefinition.definitions.$ModelName
                    break
                }
            }

            break
        }
    }


}
