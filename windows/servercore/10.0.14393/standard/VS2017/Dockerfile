FROM microsoft/vsts-agent:latest

ENV chocolateyUseWindowsCompression=false
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

RUN choco config set cachelocation C:\chococache

RUN choco install \
    git  \
    nodejs \
    curl \
    docker \
    mongodb \
    yarn \
    --confirm \
    --limit-output \
    --timeout 216000 \
    && rmdir /S /Q C:\chococache
   # choco install visualstudio2015community --confirm --timeout 216000 \

RUN choco install \
    dotnet4.6.2 \
    --confirm \
    --limit-output \
    && rmdir /S /Q C:\chococache

RUN choco install \
    chocolatey-visualstudio.extension \
    KB3033929 \
    KB2919355 \
    KB2999226 \
    visualstudio2017-installer \
    --confirm \
    --limit-output \
    && rmdir /S /Q C:\chococache

RUN choco install \
    visualstudio2017buildtools \
    --package-parameters "--wait --quiet --installPath=c:\vs --locale en-US --includeOptional --noUpdateInstaller" \
    --confirm \
    --limit-output \
    --timeout 216000 \
    && rmdir /S /Q C:\chococache

RUN choco install \
    visualstudio2017-workload-azure \
    --confirm \
    --limit-output \
    --timeout 21600 \
    --package-parameters "--includeOptional" \
    && rmdir /S /Q C:\chococache

RUN choco install \
    visualstudio2017-workload-netcoretools \
    visualstudio2017-workload-netweb \
    --confirm \
    --limit-output \
    --timeout 21600 \
    --package-parameters "--includeOptional" \
    && rmdir /S /Q C:\chococache

RUN choco install \
    visualstudio2017-workload-netweb \
    --confirm \
    --limit-output \
    --timeout 21600 \
    --package-parameters "--includeOptional" \
    && rmdir /S /Q C:\chococache

# common node tools
# RUN npm install gulp -g && npm install grunt -g && npm install -g less && npm install phantomjs-prebuilt -g

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# # Install .NET Core
# ENV DOTNET_VERSION 1.1.1
# ENV DOTNET_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/release/1.1.0/Binaries/$DOTNET_VERSION/dotnet-win-x64.$DOTNET_VERSION.zip
#
# RUN Invoke-WebRequest $Env:DOTNET_DOWNLOAD_URL -OutFile dotnet.zip; \
#     Expand-Archive dotnet.zip -DestinationPath $Env:ProgramFiles\dotnet -Force; \
#     Remove-Item -Force dotnet.zip
#
# # Install .NET Core
# ENV DOTNET_VERSION 1.0.4
# ENV DOTNET_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/preview/Binaries/$DOTNET_VERSION/dotnet-win-x64.$DOTNET_VERSION.zip
#
# RUN Invoke-WebRequest $Env:DOTNET_DOWNLOAD_URL -OutFile dotnet.zip; \
#     Expand-Archive dotnet.zip -DestinationPath $Env:ProgramFiles\dotnet -Force; \
#     Remove-Item -Force dotnet.zip
#
# # Install .NET Core SDK
# ENV DOTNET_SDK_VERSION 1.0.1
# ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-win-x64.$DOTNET_SDK_VERSION.zip
#
# RUN Invoke-WebRequest $Env:DOTNET_SDK_DOWNLOAD_URL -OutFile dotnet.zip; \
#     Expand-Archive dotnet.zip -DestinationPath $Env:ProgramFiles\dotnet -Force; \
#     Remove-Item -Force dotnet.zip

# # Install .NET Core SDK
ENV DOTNET_SDK_VERSION 2.2.103
ENV DOTNET_SDK_DOWNLOAD_URL https://download.visualstudio.microsoft.com/download/pr/c332d70f-6582-4471-96af-4b0c17a616ad/5f3043d4bc506bf91cb89fa90462bb58/dotnet-sdk-2.2.103-win-x64.zip

RUN Invoke-WebRequest $Env:DOTNET_SDK_DOWNLOAD_URL -OutFile dotnet.zip; \
    Expand-Archive dotnet.zip -DestinationPath $Env:ProgramFiles\dotnet -Force; \
    Remove-Item -Force dotnet.zip

SHELL ["cmd", "/S", "/C"]

RUN setx /M PATH "%PATH%;%ProgramFiles%\dotnet"

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip

RUN mkdir C:\warmup \
    && cd C:\warmup \
    && dotnet new \
    && cd .. \
    && rmdir /S /Q C:\warmup
