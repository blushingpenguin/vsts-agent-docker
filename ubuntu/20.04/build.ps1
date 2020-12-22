#!/usr/bin/env pwsh

$ErrorActionPreference = "Stop"
Import-Module Az
Set-StrictMode -Version Latest

function AzureLogin
{
    $needLogin = $true
    try
    {
        $content = Get-AzContext
        if ($content)
        {
            $needLogin = ([string]::IsNullOrEmpty($content.Account))
        }
    }
    catch
    {
        if ($_ -like "*Login-AzAccount to login*")
        {
            $needLogin = $true
        }
        else
        {
            throw
        }
    }

    if ($needLogin)
    {
        Login-AzAccount
    }
}

function Get-Secret([string] $name)
{
    $result = Get-AzKeyVaultSecret -VaultName "vendeq-ssl" -Name $name
    if (!$result)
    {
        throw "Missing secret value for '$name'";
    }


    # well fuck me, this is an improvement over "SecretValueText" and no mistake
    $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($result.SecretValue)
    try
    {
       return [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
    }
    finally
    {
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
    }
}

AzureLogin
$vstsToken = Get-Secret -Name "VSTS-TOKEN"
$vstsAccount = Get-Secret -Name "VSTS-ACCOUNT"

# Looks like it might be possible to get this information from elsewhere, i.e. without
# having to be bothered with logging into azure and fetching a token/account
$useragent = 'vsts-windowscontainer'
$creds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("user:$vstsToken"))
$encodedAuthValue = "Basic $creds"
$acceptHeaderValue = "application/json;api-version=3.0-preview"
$headers = @{Authorization = $encodedAuthValue;Accept = $acceptHeaderValue }
$vstsUrl = "https://$vstsAccount.visualstudio.com/_apis/distributedtask/packages/agent?platform=linux-x64"
$response = Invoke-WebRequest -UseBasicParsing -Headers $headers -Uri $vstsUrl -UserAgent $useragent

# write-host $response.content
$response = (ConvertFrom-Json $response.Content).value[0]
$fn = $response.filename
if (Test-Path $fn)
{
    Write-Host "using existing agent file '$fn'"
}
else
{
    Write-Host "downloading agent file '$fn'"
    Invoke-WebRequest -Uri $response.downloadUrl -OutFile $fn
    Write-Host "downloaded agent to '$fn'"
}

# docker build --no-cache -t vsts-agent -t vendeq.azurecr.io/vsts-agent --build-arg AGENT_FILENAME=$fn .
docker build -t vsts-agent -t vendeq.azurecr.io/vsts-agent --build-arg AGENT_FILENAME=$fn .
