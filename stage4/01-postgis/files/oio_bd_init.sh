#!/bin/bash -e
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
su - postgres -c "psql -d oio -f /home/pi/oio.sql;"
