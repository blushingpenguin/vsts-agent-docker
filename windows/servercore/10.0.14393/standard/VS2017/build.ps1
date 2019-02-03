#!/usr/bin/env pwsh

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

docker build `
    -m 2G `
    -t microsoft/vsts-agent/standard/vs2017:latest `
    -t vendeq.azurecr.io/vsts-agent/standard/vs2017:latest .
