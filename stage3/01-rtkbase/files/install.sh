#!/bin/bash

### RTKBASE INSTALLATION SCRIPT ###

#declare -a detected_gnss

install_dependencies() {
    echo '################################'
    echo 'INSTALLING DEPENDENCIES'
    echo '################################'
    apt-get update 
    apt-get install -y git build-essential python3-pip python3-dev python3-setuptools python3-wheel libsystemd-dev bc dos2unix 
}

install_rtklib() {
    echo '################################'
    echo 'INSTALLING RTKLIB'
    echo '################################'
    if [ ! -d /RTKLIB ]; then
    #Get Rtklib 2.4.3 repository
     git clone -b rtklib_2.4.3 --single-branch https://github.com/tomojitakasu/RTKLIB
    #Install Rtklib app
    #TODO add correct CTARGET in makefile?
    make -j8 --directory=RTKLIB/app/str2str/gcc
    make -j8 --directory=RTKLIB/app/str2str/gcc install
    make -j8 --directory=RTKLIB/app/rtkrcv/gcc
    make -j8 --directory=RTKLIB/app/rtkrcv/gcc install
    make -j8 --directory=RTKLIB/app/convbin/gcc
    make -j8 --directory=RTKLIB/app/convbin/gcc install
    #deleting RTKLIB
    #rm -rf RTKLIB/
    fi
}

install_rtkbase() {
    echo '################################'
    echo 'INSTALLING RTKBASE'
    echo '################################'
   if [ ! -d /rtkbase ]; then
    if [ "$1" == "--from-repo" ]
    then
        #Get rtkbase repository
         git clone -b web_gui --single-branch https://github.com/stefal/rtkbase.git
    elif [ "$1" == "--release" ]
    then
        #Get rtkbase latest release
         wget https://github.com/stefal/rtkbase/releases/latest/download/rtkbase.tar.gz -O rtkbase.tar.gz
         tar -xvf rtkbase.tar.gz
    fi
   else
     git -C /rtkbase pull
   fi
    #as we need to run the web server as root, we need to install the requirements with
    #the same user
    python3 -m pip install --upgrade pip setuptools wheel  --extra-index-url https://www.piwheels.org/simple
    python3 -m pip install -r rtkbase/web_app/requirements.txt  --extra-index-url https://www.piwheels.org/simple
    #when we will be able to launch the web server without root, we will use
    # python3 -m pip install -r requirements.txt --user
    #Install unit files
#    rtkbase/copy_unit.sh
#    systemctl enable rtkbase_web.service
#    systemctl daemon-reload
#    systemctl start rtkbase_web.service
}

#add_crontab() {
#    echo '################################'
#    echo 'ADDING CRONTAB'
#    echo '################################'

    #script from https://stackoverflow.com/questions/610839/how-can-i-programmatically-create-a-new-cron-job
    #I've added '-r' to sort because SHELL=/bin/bash should stay before "0 4 * * ..."
#    (crontab -u $(logname) -l ; echo 'SHELL=/bin/bash') | sort -r | uniq - | crontab -u $(logname) -
#    (crontab -u $(logname) -l ; echo "0 4 * * * $(eval echo ~$(logname)/rtkbase/archive_and_clean.sh)") | sort -r | uniq - | crontab -u $(logname) -
#}

main() {
    if [ "$1" == "--release" ] || [ "$1" == "--from-repo" ]
    then
        install_dependencies
        install_rtklib
        install_rtkbase $1
#        add_crontab
        #if a gnss receiver is detected, write the com port in settings.conf
#        detect_usb_gnss
#        if [[ ${#detected_gnss[*]} -eq 2 ]]
#        then
#            echo 'GNSS RECEIVER DETECTED: /dev/'${detected_gnss[0]} ' - ' ${detected_gnss[1]}
#            if [[ -f "rtkbase/settings.conf" ]]  #check if settings.conf exists
#            then
#                #inject the com port inside settings.conf
#                 sed -i s/com_port=.*/com_port=\'${detected_gnss[0]}\'/ rtkbase/settings.conf
#            else
                #create settings.conf with the com_port setting and the format
#                 printf "[main]\ncom_port='"${detected_gnss[0]}"'\ncom_port_settings='115200:8:n:1'" > rtkbase/settings.conf
#            fi
#        fi
        #if the receiver is a U-Blox, launch the set_zed-f9p.sh. This script will reset the F9P and flash it with the corrects settings for rtkbase
#                if [[ ${detected_gnss[1]} =~ 'u-blox' ]]
#                then
#                    rtkbase/tools/set_zed-f9p.sh /dev/${detected_gnss[0]} 115200 rtkbase/receiver_cfg/U-Blox_ZED-F9P_rtkbase.txt
#                fi

    else
        echo "Wrong parameter: Please use --release or --from-repo"
        exit 1
    fi
}

main $1
exit 0
