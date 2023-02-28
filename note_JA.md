## Installing qemu-user-static

```sudo apt-get install qemu-user-static```

## make executable .sh

```
cd pi-gen_RTKbase
sudo find ./ -type f -iname "*.sh" -exec chmod +x {} \;
```

## make lite img

cmd:

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

## debug & delete stage

```docker run -it --privileged --volumes-from=pigen_work pi-gen /bin/bash```


## Lancer la fabrication en tâche de fond sur un serveur:

* sudo apt-get install screen
* lancer ```screen``` 
* lancer le build ```sudo PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh```
* Pendant la fabrication appuyez simplement sur ```Ctrl + a``` immédiatement suivi de ```d``` pour se deconnecter de la console
* connectez-vous de nouveau au terminal distant et tapez ```screen -r```

> https://fr.linux-console.net/?p=1143#gsc.tab=0

> http://kmdouglass.github.io/posts/create-a-custom-raspbian-image-with-pi-gen-part-1/
