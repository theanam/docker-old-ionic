# ionic-build-android

## docker-compose
```yaml
version: '2'
services:
    app:
        container_name: build_ionic
        image: bmedy/ionic-android
        volumes:
            - .:/myApp
            - ~/.gradle:/root/.gradle
```

### run
```
docker-compose run app ionic build android --release
```
## manual usage

```
docker build -t bmedy/ionic-android .
```

```
docker run -ti --rm -p 8100:8100 -p 35729:35729 bmedy/ionic-android
```
If you have your own ionic sources, you can launch it with:

```
docker run -ti --rm -p 8100:8100 -p 35729:35729 -v /path/to/your/ionic-project/:/myApp:rw bmedy/ionic-android:1.4.5
```

### Automation
With this alias:

```
alias ionic="docker run -ti --rm -p 8100:8100 -p 35729:35729 --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/.gradle:/root/.gradle -v \$PWD:/myApp:rw bmedy/ionic-android:1.4.5 ionic"
```

> Due to a bug in ionic, if you want to use ionic serve, you have to use --net host option :

```
alias ionic="docker run -ti --rm --net host --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/.gradle:/root/.gradle -v \$PWD:/myApp:rw bmedy/ionic-android:1.4.5 ionic"
```


## Bitbucket CI Configuration

Here is a sample bitbucket.pipelines.yml file for setting up the project and compiling it:

```yaml
image: bmedy/ionic-android:latest

pipelines:
  default:
    - step:
        script: # Modify the commands below to build your repository.
          - yarn install
          - ionic config build
          - ionic platform add android
          - ionic build android
```

It is important to manage your keystores correctly. For signing debug releases, the android build tools will automatically fall back to `~/.android/debug.keystore`, which should not be password protected.
