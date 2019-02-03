$ErrorActionPreference = "Stop"

If ($env:VSTS_ACCOUNT -eq $null) {
    Write-Error "Missing VSTS_ACCOUNT environment variable"
    exit 1
}

if ($env:VSTS_TOKEN -eq $null) {
    Write-Error "Missing VSTS_TOKEN environment variable"
    exit 1
} else {
    if (Test-Path -Path $env:VSTS_TOKEN -PathType Leaf) {
        $env:VSTS_TOKEN = Get-Content -Path $env:VSTS_TOKEN -ErrorAction Stop | Where-Object {$_} | Select-Object -First 1

        if ([string]::IsNullOrEmpty($env:VSTS_TOKEN)) {
            Write-Error "Missing VSTS_TOKEN file content"
            exit 1
        }
    }
}

if ($env:VSTS_AGENT -ne $null) {
    $env:VSTS_AGENT = $($env:VSTS_AGENT)
}
else {
    $env:VSTS_AGENT = $env:COMPUTERNAME
}

if ($env:VSTS_WORK -ne $null)
{
    New-Item -Path $env:VSTS_WORK -ItemType Directory -Force
}
else
{
    $env:VSTS_WORK = "_work"
}

if($env:VSTS_POOL -eq $null)
{
    $env:VSTS_POOL = "Default"
}

$env:VSO_AGENT_IGNORE="VSTS_AGENT_URL,VSO_AGENT_IGNORE,VSTS_AGENT,VSTS_ACCOUNT,VSTS_TOKEN,VSTS_POOL,VSTS_WORK"
if ($env:VSTS_AGENT_IGNORE -ne $null)
{
    $env:VSO_AGENT_IGNORE="$env:VSO_AGENT_IGNORE,$env:VSTS_AGENT_IGNORE,VSTS_AGENT_IGNORE"
}

Set-Location -Path "C:\BuildAgent"

& .\bin\Agent.Listener.exe configure --unattended `
    --agent "$env:VSTS_AGENT" `
    --url "https://$env:VSTS_ACCOUNT.visualstudio.com" `
    --auth PAT `
    --token "$env:VSTS_TOKEN" `
    --pool "$env:VSTS_POOL" `
    --work "$env:VSTS_WORK" `
    --replace

& .\bin\Agent.Listener.exe run
