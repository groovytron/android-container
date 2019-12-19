# Docker container for Android build

[![Build Status](https://travis-ci.org/groovytron/android-container.svg?branch=master)](https://travis-ci.org/groovytron/android-container)

Docker container allowing you to build and test your Android project.

## Supported tags and respective `Dockerfile` links

- `29`, `latest` ([29/Dockerfile](https://github.com/groovytron/android-container/blob/master/29/Dockerfile))
- `28` ([28/Dockerfile](https://github.com/groovytron/android-container/blob/master/28/Dockerfile))
- `27` ([27/Dockerfile](https://github.com/groovytron/android-container/blob/master/27/Dockerfile))
- `26` ([26/Dockerfile](https://github.com/groovytron/android-container/blob/master/26/Dockerfile))
- `25` ([25/Dockerfile](https://github.com/groovytron/android-container/blob/master/25/Dockerfile))

Each of these images embeds the following softwares:

- Android SDK and build tools (command line tools)
- [`gradle`](https://gradle.org)
- [`kotlin`](https://kotlinlang.org)
- [`fastlane`](https://fastlane.tools)
- Java (*openjdk 8*)

Check the `build.yaml` to see which version is embedded of each software is installed in the image you are using. We try to keep them up to date when a new version is available.

## Use the container

We recommend you use the `dev` user instead of `root` when running that container to avoid privilege escalation.

The container's working directory is `/home/dev/android_project` so we advise you to mount your project directory onto this place.

### Building the project interactively in the container

To run the container and open a bash in your android project run the following command:

`docker run -it --entrypoint /bin/bash --user=dev --volume=<path-to-your-android-project-directory>:/home/dev/android_project groovytron/android:latest`

You can then the following commands in the container to check if everything works:

- `./gradlew` to install appropriate gradle version for your project
- `./gradlew tasks` to list the available tasks
- `./gradlew assembleDebug` to build a debug APK

## Contribute to the project

### Upgrading an image or create a new up-to-date

- If you are struggling to find the last VERSION ID of the command line SDK tools, they are listed here: <https://developer.android.com/studio#command-tools>.
