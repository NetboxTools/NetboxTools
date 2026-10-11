function ConvertToNbxQueryString {
    <#
        Converts a dictionary into an URL encoded query string. Array values are repeated for each value.

        Keys are lower cased: NetBox filter names (including custom field filters) are lower case,
        and NetBox ignores filters it does not recognize, so @{ Site = 'lab' } would otherwise
        return all objects instead of the objects of the site.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [System.Collections.IDictionary]$Query
    )

    if (-not $Query -or $Query.Count -eq 0) {
        return ''
    }

    $Pairs = foreach ($Key in $Query.Keys) {
        foreach ($Value in @($Query[$Key])) {
            $StringValue = if ($Value -is [bool]) { $Value.ToString().ToLowerInvariant() } else { [string]$Value }
            '{0}={1}' -f [uri]::EscapeDataString(([string]$Key).ToLowerInvariant()), [uri]::EscapeDataString($StringValue)
        }
    }
    $Pairs -join '&'
}
