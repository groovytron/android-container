# CHANGELOG

## 1.0.0

- feature: new image embedding andoroid build tools for API `29`
- change: bump `fastlane` version to `2.137.0`
- change: bump `gradle` version to `6.0.1`
- change: bump `kotlin` version to `1.3.60`
- change: switch multiple builds architecture using `docker-compose` with a `build.yaml`
- feature: add OCI annotation to each image

**Please note that if you used `latest` image before this release you will need to switch to either `25`, `26`, `27` or `28` depending on the API level your project is using.**

## 0.0.1

- feature: build tools and SDK for API `25`, `26`, `27` and `28` are packaged into one single container image
