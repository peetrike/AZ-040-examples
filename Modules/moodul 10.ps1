
    # masin domeeni
help Add-Computer -ShowWindow

    # masina nimi
help Rename-Computer -ShowWindow

    #DHCP
get-module *dhcp* -ListAvailable
Get-Command -Module DhcpServer

Get-Command -noun *dhcp*scope*
help Get-DhcpServerv4Scope -Online

Get-Command -noun *dhcp*lease*
Get-Command -noun dhcpserverv4lease
help Get-DhcpServerv4Lease -Online

Get-Command -Noun *reservation*
help Add-DhcpServerv4Reservation -Online


    # TrustedHosts list

#Requires -RunAsAdministrator
#Requires -Version 2
 
$NewList = "uusmasin, 192.168.2.3"
 
# salvestame praeguse listi
$OldHosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value
 
# salvestame listi
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $NewList -Concatenate

    #add role to server
Get-WindowsFeature -ComputerName
Install-WindowsFeature -ComputerName


    # käivita midagi skriptis adminni õigustes

#requires -version 2
function Start-AsAdmin {
    param (
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [String]
        $Command
			, [ValidateSet("Normal", "Hidden")]
			[string]
		$WindowStyle = "Hidden"
    )

	$commandBytes = [System.Text.Encoding]::Unicode.GetBytes($command)
	$encodedCommand = [Convert]::ToBase64String($commandBytes)

	Start-Process -Verb RunAs -FilePath powershell.exe -ArgumentList "-ExecutionPolicy RemoteSigned -encodedcommand $encodedCommand" -Wait -WindowStyle $WindowStyle
}


Start-AsAdmin @"
  Get-Command
"@


    # parameetrile vaikeväärtuse ilusti küsimine 
function test-parameter {
    param(
        [pscredential]
        $Credential = (Get-Credential -Message "ütle kasutaja nimi ja parool")
    )
    
    "Sa ütlesid: {0}" -f $Credential.UserName
}

test-parameter
test-parameter -Credential (Get-Credential domain\user)


    # Powershell Desired State Configuration (DSC)

Configuration minukonf {

    Node Minumasin {
            # see on mälu järgi kirjutatud
        xDomainJoin domeeni {
            DomainName = "Adatum.com"
            ComputerName = "minuserver"
            Ensure = "Present"
            DomainCredential = "Adatum\Administrator"
        }

        WindowsFeature komponent {
            Name = "Telnet Client"
            Ensure = "Present"
        }
    }
}

minukonf -outputpath  .\

Start-DscConfiguration -Path .\ -Credential

help about_DesiredStateConfiguration -ShowWindow
