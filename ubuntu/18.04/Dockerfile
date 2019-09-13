FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

#        jq \
#        libcurl3 \
#        libicu$(LIBICU_VERSION) \
#        libunwind8 \

# Add an 'app' user for apps to run as
RUN groupadd -g 999 app && \
    useradd -g app -u 999 app

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        software-properties-common \
 && apt-add-repository ppa:git-core/ppa \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        apt-utils \
        curl \
        git \
        netcat \
 && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
 && apt-get install -y --no-install-recommends git-lfs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Accept the TEE EULA
RUN mkdir -p "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && cd "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && echo '<ProductIdData><eula-14.0 value="true"/></ProductIdData>' > "com.microsoft.tfs.client.productid.xml"

# Install Azure CLI (instructions taken from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
RUN apt-get update \
 && apt-get install -y --no-install-recommends gpg-agent \
 && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
  | tee /etc/apt/sources.list.d/azure-cli.list \
 && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    azure-cli \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/* \
 && az --version

# Install .NET Core SDK and initialize package cache
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb > packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && rm packages-microsoft-prod.deb \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    libgdiplus \
    libc6-dev \
    dotnet-sdk-2.2 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*
RUN dotnet help
ENV dotnet=/usr/bin/dotnet

# && npm install -g bower \
# && npm install -g grunt \
# && npm install -g gulp \
# && npm install -g n \
# && npm install -g webpack webpack-cli --save-dev \
# && npm install -g parcel-bundler \
# ENV bower=/usr/local/bin/bower \
#     grunt=/usr/local/bin/grunt

# Install latest Node.js and related tools (change latest->lts when 12 is lts)
RUN apt-get update \
 && apt-get install -y --no-install-recommends make \
 && curl -sL https://git.io/n-install | bash -s -- -ny - \
 && ~/n/bin/n latest \
 && npm i -g npm \
 && rm -rf ~/n \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Install Powershell Core
RUN apt-get update \
 && apt-get install -y --no-install-recommends gpg-agent \
 && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends powershell \
 && pwsh -Command 'Install-Module Az -Force' \
 && pwsh -Command 'Install-Module Az.Search -Force' \
 && pwsh -Command 'Install-Module Az.Maps -Force' \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends yarn zip unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Install mongodb
RUN curl https://www.mongodb.org/static/pgp/server-4.0.asc | apt-key add - \
 && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends mongodb-org \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
 && apt-get update \
 && apt-get install -y --no-install-recommends docker-ce docker-ce-cli \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Install ktmpl
RUN apt-get update \
  && apt-get install -y --no-install-recommends rustc cargo \
  && cargo install ktmpl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list.d/*

# Install kubectl
RUN apt-get update \
 && apt-get install -y apt-transport-https \
 && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && add-apt-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main" \
 && apt-get update \
 && apt-get install -y kubectl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

# Clean system
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

WORKDIR /vsts
ARG AGENT_FILENAME
COPY ./$AGENT_FILENAME ./agent.tar.gz

COPY ./mongod.conf /etc/mongod.conf
COPY ./initMongo.js .
COPY ./start.sh .
COPY ./containerStart.sh .
RUN mkdir agent && tar --no-same-owner -xzf agent.tar.gz -C agent && chmod +x start.sh && rm ./agent.tar.gz && chmod +x ./containerStart.sh && chown -R app:app /vsts

# Squash - saves ~50Mb at present so doesn't seem  worth the build/push time
# FROM ubuntu:18.04
# COPY --from=0 / /
ENV PATH="/root/.cargo/bin:${PATH}"
CMD ["./containerStart.sh"]
