#!/bin/bash -e

#################################################################
#Central DBACESSS > Modify Before first boot: 
#ex: DBACCESS="'CapitaineCrochet','127.0.0.1',5432,'user','blablabla','oio'"

DBACCESS="'RPIuser','DBIP',5432,'DBuser','DBpassw','DBname'"
#################################################################

su - postgres -c "createuser docker --superuser"
# Modifying passwords
su - postgres -c "psql -c \"ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres';\""
su - postgres -c "psql -c \"ALTER USER docker WITH ENCRYPTED PASSWORD 'docker';\""

# create template_postgis
su - postgres -c "createdb template_postgis -E UTF8 -T template0;"
su - postgres -c "psql template_postgis -c \"CREATE EXTENSION postgis;\""
su - postgres -c "psql template_postgis -c \"CREATE EXTENSION hstore;\""
su - postgres -c "psql template_postgis -c \"CREATE EXTENSION postgis_topology;\""

# create Database OIO
su - postgres -c "createdb -O docker -T template_postgis oio;"
su - postgres -c "psql -d oio -f /home/pi/OceanIsOpen/sql/oio.sql;"

#create syncData2Central
su - postgres -c "psql -d oio -f /home/pi/OceanIsOpen/sql/sync/sync_client.sql;"
su - postgres -c "psql oio -c \"insert into sync.login (nom,ip,port,utilisateur,mdp,dbname) VALUES ($DBACCESS);\""

#create auto_synchro
cp -n /home/pi/OceanIsOpen/sql/sync/auto_replay.sh       /home/pi/auto_replay.sh
cp -n /home/pi/OceanIsOpen/sql/sync/auto_replay.service  /etc/systemd/system/auto_replay.service
cp -n /home/pi/OceanIsOpen/sql/sync/auto_replay.timer    /etc/systemd/system/auto_replay.timer
chmod +x /home/pi/auto_replay.sh
systemctl enable auto_replay.service
systemctl enable auto_replay.timer
systemctl start auto_replay.service


