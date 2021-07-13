[CmdletBinding()]
Param()

write-host "see läheb ekraanile" -ForegroundColor red -BackgroundColor Blue
Write-Output " see läheb tavalist rada pidi"
Write-Information "see läheb infokanalisse"
Write-Verbose "see on verbaalne kõhulahtisus"
Write-Debug "see on silumiskanalisse"
Write-Warning "see on hoiatus"
Write-Error "see on viga"