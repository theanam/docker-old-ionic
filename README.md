## Docker Image for testing and building Ionic 1 Projects 

******
 Ionic 1 isn't the default version of ionic anymore and getting ionic 1 projects working on ionic CLI 2/3 is tough. The old CLI also requires older version of nodejs. This docker image can help you out. This image contains *nodejs 6.14* , ionic 1 and cordova 5. 

Originally forked from : <https://github.com/bmedy/ionic-android>

You can use it in two ways depending on your knowledge on docker. 

### If you don't know / Don't want to know about docker : 

Download and install docker from <http://docker.io>

Open up the command line and navigate to the project folder and then you can run these commands:

    # To start the development server:
    docker run --rm -it -v "$PWD:/data" -p 8100:8100 theanam/old-ionic-build
    # To build APK 
    docker run --rm -it -v "$PWD:/data" -p 8100:8100 theanam/old-ionic-build build android
    # To enter the shell of the build machine and manually run commands run this command :
    docker run --rm -it -v "$PWD:/data" -p 8100:8100 --entrypoint /bin/bash theanam/old-ionic-build

The command will take a long time for the first time you run it, because it will download the docker image, But after the first time, it will work really fast in every project on that computer.


To ease up things more, you can add this as alias in your **.bashrc** file 

    alias old-ionic=docker run --rm -it -v "$PWD:/data" -p 8100:8100 theanam/old-ionic-build

Then you can access the command like ionic cli:

    # For the dev server
    old-ionic serve
    # For building 
    old-ionic build android
    # For release  build
    old-ionic build --release android

    #...and so on

### If you know docker :

You can build the image manually from the docker file with this command :

    docker build -t theanam/old-ionic-build .

make sure to run it in the folder with the `Dockerfile` and `tools` folder. 

You can also add a volume for gradle to make builds faster. 

use the run command as following: 

    docker run --rm -it -v "$PWD:/data" -v ".gradle:/root/.gradle" -p 8100:8100 theanam/old-ionic-build

### If you want to know more about the image: 

Please visit the work of [medy belmokhtar](https://github.com/bmedy/ionic-android). This image was the original version it was forked from. This repository contains more information about development.


