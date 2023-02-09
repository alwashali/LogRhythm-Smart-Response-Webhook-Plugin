# N8N Webhook

param(
    [Parameter(Mandatory=$true)][string]$n8nwebhook,
    [Parameter(Mandatory=$true)][string]$ignoressl,
    [Parameter(Mandatory=$true)][string]$alarmid

)
trap [Exception] {
write-error $("TRAPPED: " + $_)
exit 1
}

# Get the token from CyOPs
$uri = $n8nwebhook
$data = @{alarmid=$alarmid}


$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
if ($ignoressl-eq "TRUE")
{ 
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
}

$outpu = Invoke-RestMethod -uri $uri -Method POST -Body (ConvertTo-Json $data) -ContentType application/json 

Write-Output ($outpu)
