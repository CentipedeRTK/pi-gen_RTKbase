# Build a RTKbase image for Raspberry Pi

## Installing qemu-user-static

```sudo apt-get install qemu-user-static```

## clone and choose branch

### Last release

```
git clone https://github.com/CentipedeRTK/pi-gen_RTKbase.git
git checkout last-release
```

### Dev Branch

```
git clone https://github.com/CentipedeRTK/pi-gen_RTKbase.git
git checkout dev
```

## make executable .sh

```
cd pi-gen_RTKbase
sudo find ./ -type f -iname "*.sh" -exec chmod +x {} \;
```

## make a raspbery pi RTKbase img

```
docker rm -v pigen_work

sudo PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh

```

## debug & delete stage before rebuild

```
docker run -it --privileged --volumes-from=pigen_work pi-gen /bin/bash
rm -r /pi-gen/work/RTKBaseGNSS/stage_rtkbase
```


## Lancer la fabrication en tâche de fond sur un serveur:

* sudo apt-get install screen
* lancer ```screen```
* lancer le build ```sudo PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh```
* Pendant la fabrication appuyez simplement sur ```Ctrl + a``` immédiatement suivi de ```d``` pour se deconnecter de la console
* connectez-vous de nouveau au terminal distant et tapez ```screen -r```

> https://fr.linux-console.net/?p=1143#gsc.tab=0

> http://kmdouglass.github.io/posts/create-a-custom-raspbian-image-with-pi-gen-part-1/


--------------------------------

other cmd:

```
touch ./stage5/SKIP ./stage6/SKIP /stage7/SKIP
touch ./stage5/SKIP_IMAGES ./stage6/SKIP_IMAGES ./stage7/SKIP_IMAGES

docker rm -v pigen_work

.sudo ./build-docker.sh

sudo CONTINUE=1 ./build-docker.sh

sudo PRESERVE_CONTAINER=1 ./build-docker.sh

sudo PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh

sudo PRESERVE_CONTAINER=1 CONTINUE=1 CLEAN=1 ./build-docker.sh
```
