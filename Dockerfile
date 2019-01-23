FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive
ARG GRADLE_VERSION=4.8.1
ARG KOTLIN_VERSION=1.2.50
ARG ANDROID_SDK_VERSION_ID=4333796
ARG ANDROID_BUILDTOOLS_VERSIONS=25.0.3,26.0.3,27.0.3,28.0.3
ARG RUBY_VERSION=2.5
ARG FASTLANE_VERSION=2.114.0
ARG SCREENGRAB_VERSION=1.0.0

ENV GRADLE_HOME=/opt/gradle
ENV KOTLIN_HOME=/opt/kotlinc
ENV ANDROID_SDK_DIR=/opt/android-sdk
ENV ANDROID_HOME="${ANDROID_SDK_DIR}/sdk-tools-linux-${ANDROID_SDK_VERSION_ID}"
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

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
        openjdk-8-jdk \
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
RUN for version in $(echo $ANDROID_BUILDTOOLS_VERSIONS | tr ',' " "); \
      do version=$(echo $version | tr -d '\n') \
         && major=$(echo $version | cut -d. -f1) \
         && ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "platforms;android-$major" > /dev/null \
         && ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "build-tools;$version" > /dev/null; \
    done

RUN groupadd --gid 1000 dev \
    && useradd --uid 1000 \
        --gid dev \
        --shell /bin/bash \
        --create-home dev

ENV ANDROID_PROJECT_DIR=/home/dev/android_project

RUN mkdir -p ${ANDROID_PROJECT_DIR} \
    && chown dev:dev ${ANDROID_PROJECT_DIR}

WORKDIR ${ANDROID_PROJECT_DIR}

# Label schema related variables and metadata
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Julien M'Poy <julien.mpoy@gmail.com>" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.vcs-url="https://github.com/groovytron/android-container" \
    org.label-schema.schema-version="1.0"

# Set the locales
RUN locale-gen en_US
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
#     locale-gen
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8
