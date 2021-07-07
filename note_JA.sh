#http://kmdouglass.github.io/posts/create-a-custom-raspbian-image-with-pi-gen-part-1/

#make executable .sh
cd pi-gen
sudo find ./ -type f -iname "*.sh" -exec chmod +x {} \;
#make lite img

touch ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES


docker rm -v pigen_work

#apt_proxy docker-compose up -d
docker-compose up -d

sudo ./build-docker.sh 
sudo CONTINUE=1 ./build-docker.sh

sudo PRESERVE_CONTAINER=1 ./build-docker.sh

sudo PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh

sudo PRESERVE_CONTAINER=1 CONTINUE=1 CLEAN=1 ./build-docker.sh


sudo docker run -it --privileged --volumes-from=pigen_work pi-gen /bin/bash

rm -r pi-gen/work/2021-04-16-RTKBaseGNSS/stage3/
