$script:NbxConfig = @{
	'Connected'     = $false
	'Choices'       = @{
	}
	'APIDefinition' = $null
	'ContentTypes'  = $null
	'NbxVersion'    = @{
		'Netbox-version' = '3.5.4'
	}
	'Timeout'       = 30
	'Credential'    = [System.Management.Automation.PSCredential]::Empty
	'InvokeParams'  = @{ SkipCertificateCheck = $false }
}
