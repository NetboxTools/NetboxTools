function ConvertToNbxSlug {
    <#
        Creates a NetBox compatible slug from a name, e.g. 'Stockholm DC 1' -> 'stockholm-dc-1'.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

    $Slug = $Name.Trim().ToLowerInvariant() -replace '[^a-z0-9_-]+', '-'
    $Slug = $Slug.Trim('-')
    if ($Slug.Length -gt 100) {
        $Slug = $Slug.Substring(0, 100).TrimEnd('-')
    }
    $Slug
}
