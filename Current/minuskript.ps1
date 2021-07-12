<#
.Synopsis
   korjame sündmusi
.DESCRIPTION
   See skript korjab sündmusi mitmest masinast ja teeb nendega ...
.Parameter ComputerName
    ütle siia arvuti nimi
.Parameter syndmus
    Sündmuse Event ID, mida tahad saada
.EXAMPLE
   minuskript -cn .

   See vaatab ainult lokaalset masinat
.EXAMPLE
   minuskript -computername -syndmus 1000 -kokku 1
#>

# küsime sündmusi

Param(
        [Parameter(Mandatory=$true,
                   Position=1,
#               ValueFromPipeLineByPropertyName=$true,
                   ValueFromPipeLine=$true
        )]
        [Alias("cn")]
        [Alias("DNSHostname")]
        [string]
    $ComputerName = "." ,
        [Parameter(Position=2)]
        [int]
    $syndmus = 8233 ,
        [int]
    $kokku = 10 ,
    $jargmine = ""

)
Begin{ Write-Verbose "Tere" }
Process {
Write-Information "Alustame"
Write-Verbose "Arvutinimi on: $ComputerName"

get-winevent -LogName Application <#-ComputerName $ComputerName#> |
    Where-Object ID -eq $syndmus |
    select -First $kokku
}

End{ Write-Verbose "Head Aega" }
