function Remove-NbxDCIMRearPort {


    [CmdletBinding(ConfirmImpact = 'High',
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName = $true)]
        [uint64[]]$Id,

        [switch]$Force
    )

    begin {

    }

    process {
        foreach ($RearPortID in $Id) {
            $CurrentPort = Get-NbxDCIMRearPort -Id $RearPortID -ErrorAction Stop

            if ($Force -or $pscmdlet.ShouldProcess("Name: $($CurrentPort.Name) | ID: $($CurrentPort.Id)", "Remove")) {
                $Segments = [System.Collections.ArrayList]::new(@('dcim', 'rear-ports', $CurrentPort.Id))

                $URI = BuildNewURI -Segments $Segments

                InvokeNbxRequest -URI $URI -Method DELETE
            }
        }
    }

    end {

    }

}
