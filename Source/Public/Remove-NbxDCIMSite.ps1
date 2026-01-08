function Remove-NbxDCIMSite {

    <#
        .SYNOPSIS
            Remove a Site

        .DESCRIPTION
            Remove a DCIM Site from Netbox

        .EXAMPLE
            Remove-NbxDCIMSite -Id 1

            Remove DCM Site with id 1

        .EXAMPLE
            Get-NbxDCIMSite -name My Site | Remove-NbxDCIMSite -confirm:$false

            Remove DCM Site with name My Site without confirmation

    #>

    [CmdletBinding(ConfirmImpact = 'High',
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName = $true)]
        [uint]$Id

    )

    begin {

    }

    process {
        $CurrentSite = Get-NbxDCIMSite -Id $Id -ErrorAction Stop

        if ($pscmdlet.ShouldProcess("$($CurrentSite.Name)/$($CurrentSite.Id)", "Remove Site")) {
            $Segments = [System.Collections.ArrayList]::new(@('dcim', 'sites', $CurrentSite.Id))

            $URI = BuildNewURI -Segments $Segments

            InvokeNbxRequest -URI $URI -Method DELETE
        }
    }

    end {

    }

}
