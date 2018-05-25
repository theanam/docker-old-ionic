FROM     ubuntu:16.04

# LABELS
LABEL Maintainer Anam Ahmed
LABEL Author-Email me@anam.co
LABEL Forked-From https://github.com/bmedy/ionic-android
#Env Values
ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk-linux \
    NODE_VERSION=6.14.0 \
    IONIC_VERSION=1 \
    CORDOVA_VERSION=5

# APT INSTALLATIONS
RUN apt-get update &&  \
    dpkg --add-architecture i386 && \
    apt-get install -y -q git wget curl unzip python-software-properties software-properties-common \
    expect ant wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod zipalign && \
    curl --retry 3 -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && \
    tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
    rm "node-v$NODE_VERSION-linux-x64.tar.gz" && \
    npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" gulp bower && \
    npm cache clear && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ADD PPA AND INSTALL JAVA 8
RUN add-apt-repository ppa:webupd8team/java -y && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get update && apt-get -y install oracle-java8-installer && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#ADD ANDROID HOME ENV VARIABLE
RUN echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment

# DOWNLOAD AND INSTALL ANDROID SDK
RUN cd /opt && \
    mkdir android-sdk-linux && \
    cd android-sdk-linux && \ 
    wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip sdk-tools-linux-3859397.zip && \
    rm -f sdk-tools-linux-3859397.zip && \
    chown -R root:root /opt && \
    cd tools && \
    mkdir templates 

# SETUP PATH
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/tools

# AUTMATIC ACCEPT LICENSE AND INSTALL SDK ELEMENTS
COPY tools /opt/tools
RUN ["/opt/tools/android-accept-licenses.sh", "android --use-sdk-wrapper update sdk --all --no-ui --filter tools,platform-tools,build-tools-25.0.0,android-25"]

# ADD MISSING GRADLE TEMPLATE FROM OLDER SDK
RUN wget https://dl.google.com/android/repository/tools_r25.2.5-linux.zip && \
    unzip tools_r25.2.5-linux.zip 'tools/templates/*' -d /opt/android-sdk-linux/ && \
    rm -f tools_r25.2.5-linux.zip

# CREATE A LAUNCH SCRIPT
RUN echo '#!/bin/bash \n cd /data && npm install && bower install --allow-root && ionic "$@"'>/usr/bin/ionicx && chmod +x /usr/bin/ionicx

#FINISHING UP
VOLUME [ "/data","/root/.gradle", "/root/.android"]
WORKDIR /data
EXPOSE 8100 35729
ENTRYPOINT ["ionicx"]
CMD ["serve"]