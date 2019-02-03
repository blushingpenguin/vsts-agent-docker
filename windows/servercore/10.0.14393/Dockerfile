FROM mcr.microsoft.com/windows/servercore:latest
ENV WINDOWS_IMAGE_VERSION=latest

RUN mkdir C:\BuildAgent
WORKDIR C:/BuildAgent
COPY ./StartPreloadedAgent.* ./
ARG AGENT_FILENAME
COPY ./$AGENT_FILENAME ./agent.zip

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Expand-Archive -Path 'C:\BuildAgent\agent.zip' -DestinationPath C:\BuildAgent; Remove-Item -Path 'C:\BuildAgent\agent.zip'

SHELL ["cmd", "/S", "/C"]
CMD ["StartPreloadedAgent.cmd"]
