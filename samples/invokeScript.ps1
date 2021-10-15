$jsonContentAsString = Get-Content -Path sample.json
$html = ..\GenerateCombinedReport.ps1 -JsonString $jsonContentAsString
Out-File -FilePath ".\output.html" -InputObject $html