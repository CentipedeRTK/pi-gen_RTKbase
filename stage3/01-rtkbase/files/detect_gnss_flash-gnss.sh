#!/bin/bash

### RTKBASE INSTALLATION SCRIPT ###

declare -a detected_gnss

detect_usb_gnss() {
    echo '################################'
    echo 'GNSS RECEIVER DETECTION'
    echo '################################'
    #This function put the (USB) detected gnss receiver informations in detected_gnss
    #If there are several receiver, only the last one will be present in the variable
    for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do

        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        if [[ "$devname" == "bus/"* ]]; then continue; fi
        eval "$(udevadm info -q property --export -p $syspath)"
        if [[ -z "$ID_SERIAL" ]]; then continue; fi
        if [[ "$ID_SERIAL" =~ ^(U-blox|skytraq)$ ]]; then continue; fi
        detected_gnss[0]=$devname
        detected_gnss[1]=$ID_SERIAL
    done

}

install_rtkbase() {
    echo '################################'
    echo 'finish INSTALLING RTKBASE'
    echo '################################'
#   if [ ! -d /rtkbase ]; then
#    if [ "$1" == "--from-repo" ]
#    then
        #Get rtkbase repository
#         git clone -b web_gui --single-branch https://github.com/stefal/rtkbase.git
#    elif [ "$1" == "--release" ]
#    then
        #Get rtkbase latest release
#         wget https://github.com/stefal/rtkbase/releases/latest/download/rtkbase.tar.gz -O rtkbase.tar.gz
#         tar -xvf rtkbase.tar.gz
#    fi
#   fi
    #as we need to run the web server as root, we need to install the requirements with
    #the same user
#    python3 -m pip install --upgrade pip setuptools wheel  --extra-index-url https://www.piwheels.org/simple
#    python3 -m pip install -r rtkbase/web_app/requirements.txt  --extra-index-url https://www.piwheels.org/simple
    #when we will be able to launch the web server without root, we will use
    # python3 -m pip install -r requirements.txt --user
    #Install unit files
    rtkbase/copy_unit.sh
    systemctl enable rtkbase_web.service
    systemctl daemon-reload
    systemctl start rtkbase_web.service
}

add_crontab() {
    echo '################################'
    echo 'ADDING CRONTAB'
    echo '################################'

    #script from https://stackoverflow.com/questions/610839/how-can-i-programmatically-create-a-new-cron-job
    #I've added '-r' to sort because SHELL=/bin/bash should stay before "0 4 * * ..."
    (crontab -u $(logname) -l ; echo 'SHELL=/bin/bash') | sort -r | uniq - | crontab -u $(logname) -
    (crontab -u $(logname) -l ; echo "0 4 * * * $(eval echo ~$(logname)/rtkbase/archive_and_clean.sh)") | sort -r | uniq - | crontab -u $(logname) -
}


main() {
        install_rtkbase
        add_crontab
        detect_usb_gnss
        if [[ ${#detected_gnss[*]} -eq 2 ]]
        then
            echo 'GNSS RECEIVER DETECTED: /dev/'${detected_gnss[0]} ' - ' ${detected_gnss[1]}
            if [[ -f "rtkbase/settings.conf" ]]  #check if settings.conf exists
            then
                #inject the com port inside settings.conf
                 sed -i s/com_port=.*/com_port=\'${detected_gnss[0]}\'/ rtkbase/settings.conf
            else
                #create settings.conf with the com_port setting and the format
                 printf "[main]\ncom_port='"${detected_gnss[0]}"'\ncom_port_settings='115200:8:n:1'" > rtkbase/settings.conf
            fi
        fi
        #if the receiver is a U-Blox, launch the set_zed-f9p.sh. This script will reset the F9P and flash it with the corrects settings for rtkbase
                if [[ ${detected_gnss[1]} =~ 'u-blox' ]]
                then
                    rtkbase/tools/set_zed-f9p.sh /dev/${detected_gnss[0]} 115200 rtkbase/receiver_cfg/U-Blox_ZED-F9P_rtkbase.txt
                fi
}

main $1
exit 0
