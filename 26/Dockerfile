FROM ubuntu:bionic

ARG ANDROID_SDK_VERSION_ID=
ARG ANDROID_BUILDTOOLS_VERSION=
ARG DEBIAN_FRONTEND=noninteractive
ARG FASTLANE_VERSION=
ARG GRADLE_VERSION=
ARG JAVA_VERSION=
ARG KOTLIN_VERSION=
ARG RUBY_VERSION=
ARG SCREENGRAB_VERSION=
# Label schema related variables and metadata
ARG BUILD_DATE
ARG VCS_REF

ENV GRADLE_HOME=/opt/gradle
ENV KOTLIN_HOME=/opt/kotlinc
ENV ANDROID_SDK_DIR=/opt/android-sdk
ENV ANDROID_HOME="${ANDROID_SDK_DIR}/sdk-tools-linux-${ANDROID_SDK_VERSION_ID}"
ENV JAVA_HOME="/usr/lib/jvm/java-1.${JAVA_VERSION}.0-openjdk-amd64"
ENV ANDROID_PROJECT_DIR=/home/dev/android_project

# Distribution update and upgrade and dependencies installation
RUN apt-get update --quiet --yes \
    && apt-get upgrade --quiet --yes \
    && apt-get install --quiet --yes \
        build-essential \
        dh-autoreconf \
        git \
        lib32stdc++-6-dev \
        lib32z1 \
        locales \
        openjdk-${JAVA_VERSION}-jdk \
        ruby${RUBY_VERSION} \
        ruby${RUBY_VERSION}-dev \
        tar \
        unzip \
        wget \
    && apt-get autoremove --quiet --yes \
    && apt-get clean \
    && gem install \
        fastlane:${FASTLANE_VERSION} \
        screengrab:${SCREENGRAB_VERSION}

# Download and install Gradle
RUN wget --no-verbose https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    --directory-prefix=/opt/
RUN unzip -q /opt/gradle-${GRADLE_VERSION}-bin.zip \
    -d /opt/gradle

# Download and install Kotlin
RUN wget --no-verbose https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip \
    --directory-prefix=/opt/
RUN unzip -q /opt/kotlin-compiler-${KOTLIN_VERSION}.zip \
    -d /opt/kotlinc

# Download and install Android SDK
RUN mkdir -p ${ANDROID_SDK_DIR}/sdk-tools-linux-${ANDROID_SDK_VERSION_ID}
RUN wget --no-verbose https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION_ID}.zip \
    --directory-prefix=/opt/
RUN unzip -q /opt/sdk-tools-linux-${ANDROID_SDK_VERSION_ID}.zip \
    -d ${ANDROID_SDK_DIR}/sdk-tools-linux-${ANDROID_SDK_VERSION_ID}

# Cleanup download to take as little space as possible
RUN rm -rf /opt/*.zip

# Fix system permissions
RUN chmod a+rx $GRADLE_HOME $ANDROID_HOME

# Fix manager complaint about missing repositories.cfg file
RUN mkdir -p ~/.android
RUN touch ~/.android/repositories.cfg

# Accept licences
RUN yes 'y' | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses > /dev/null

# Install build-tools and platform-tools versions
RUN version=$(echo $ANDROID_BUILDTOOLS_VERSION | tr -d '\n') \
   && major=$(echo $ANDROID_BUILDTOOLS_VERSION | cut -d. -f1) \
   && ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "platforms;android-$major" > /dev/null \
   && ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "build-tools;$version" > /dev/null

RUN groupadd --gid 1000 dev \
    && useradd --uid 1000 \
        --gid dev \
        --shell /bin/bash \
        --create-home dev


RUN mkdir -p ${ANDROID_PROJECT_DIR} \
    && chown dev:dev ${ANDROID_PROJECT_DIR}

WORKDIR ${ANDROID_PROJECT_DIR}

LABEL maintainer="Julien M'Poy <julien.mpoy@gmail.com>" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.vcs-url="https://github.com/groovytron/android-container" \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.authors="Julien M'Poy <julien.mpoy@gmail.com>" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.description="Docker container allowing you to build and test your Android project." \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.source="https://github.com/groovytron/android-container" \
    org.opencontainers.image.title="Android Container" \
    org.opencontainers.image.url="https://github.com/groovytron/android-container" \
    org.opencontainers.image.vendor="Julien M'Poy <julien.mpoy@gmail.com>" \
    org.opencontainers.image.version=${ANDROID_BUILDTOOLS_VERSION}

# Set the locales
RUN locale-gen en_US
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
