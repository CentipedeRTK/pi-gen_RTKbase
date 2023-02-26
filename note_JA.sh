#http://kmdouglass.github.io/posts/create-a-custom-raspbian-image-with-pi-gen-part-1/

Installing qemu-user-static
sudo apt-get install qemu-user-static

#make executable .sh
cd pi-gen
sudo find ./ -type f -iname "*.sh" -exec chmod +x {} \;
#make lite img

touch ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES

docker rm -v pigen_work

#apt_proxy docker-compose up -d
docker-compose up -d

./build-docker.sh 
CONTINUE=1 ./build-docker.sh

PRESERVE_CONTAINER=1 ./build-docker.sh

PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh

PRESERVE_CONTAINER=1 CONTINUE=1 CLEAN=1 ./build-docker.sh


docker run -it --privileged --volumes-from=pigen_work pi-gen /bin/bash
