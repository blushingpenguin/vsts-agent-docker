#!/usr/bin/pwsh

function Get-Secret([string] $name)
{
    $result = Get-AzKeyVaultSecret -VaultName "vendeq-ssl" -Name $name
    if (!$result)
    {
        throw "Missing secret value for '$name'";
    }
    return $result.SecretValueText
}

$VSTS_TOKEN = Get-Secret -Name "VSTS-TOKEN"
$VSTS_ACCOUNT = Get-Secret -Name "VSTS-ACCOUNT"

# docker run --env VSTS_TOKEN=$VSTS_TOKEN --env VSTS_ACCOUNT=$VSTS_ACCOUNT --env VSTS_POOL="Azure Container Instance" --env VSTS_AGENT="ltest" -m 3.5G -it vsts-agent:latest bash
docker run --env VSTS_TOKEN=$VSTS_TOKEN --env VSTS_ACCOUNT=$VSTS_ACCOUNT --env VSTS_POOL="Azure Container Instance" --env VSTS_AGENT="ltest" -m 3.5G -d --rm vsts-agent
