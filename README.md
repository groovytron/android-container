# Docker container for Android build

Docker container allowing you to build and test your Android project.

## Tools embedded in the container

The following tools are embedded in the container:

- Java: *openjdk 8*
- Gradle: *4.8.1*
- Kotlin: *1.2.50*
- Android SDK version *4333796* with the following platform and build tools versions:

    - *28.0.3*
    - *27.0.3*
    - *26.0.3*
    - *25.0.3*

## Use the container

We recommend you use the `dev` user instead of `root` when running that container to avoid privileg escalation.

The container's working directory is `/home/dev/android_project` so we advise you to mount your project directory onto this place.

### Building the project interactively in the container

To run the container and open a bash in your android project run the following command:

`docker run -it --entrypoint /bin/bash --user=dev --volume=<path-to-your-android-project-directory>:/home/dev/android_project android-container:latest`

You can then the following commands in the container to check if everything works:

- `./gradlew` to install appropriate gradle version for your project
- `./gradlew tasks` to list the available tasks
- `./gradlew assembleDebug` to build a debug APK

## Improvements

- [ ] Add `Fastlane` to the container
- [ ] Automate build on DockerHub
