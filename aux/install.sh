#!/bin/sh
resize -s 38 114 > /dev/nul
#
# variable declarations _________________________________
#                                                        |
OS=`uname`                                               # grab OS
ver="3.11.3"                                             # toolkit version
DiStRo=`awk '{print $1}' /etc/issue`                     # grab distribution -  Ubuntu or Kali
IPATH=`pwd`                                              # grab install.sh install path
user=`who | awk {'print $1'}`                            # grab username
# _______________________________________________________|


# -----------------------------------
# Colorise shell Script output leters
# -----------------------------------
Colors() {
Escape="\033";
  white="${Escape}[0m";
  RedF="${Escape}[31m";
  GreenF="${Escape}[32m";
  YellowF="${Escape}[33m";
  BlueF="${Escape}[34m";
  CyanF="${Escape}[36m";
Reset="${Escape}[0m";
}




## Arguments menu
Colors;
time=$(date | awk {'print $4'})
while getopts ":h,:u," opt; do
    case $opt in
        u)
        ## downloading and comparing versions
        echo "${BlueF}[${YellowF}$time${BlueF}]${white} Checking for mosquito updates .."${Reset};
        echo ""
        sleep 1 && cd .. && cd bin
        local=$(cat version | grep "=" | cut -d '=' -f2)
        core_local=$(cat version | grep "=" | cut -d '.' -f2)
        msf_local=$(cat version | grep "=" | cut -d '.' -f3)
        main_local=$(cat version | grep "=" | cut -d '.' -f1 | cut -d '=' -f2)
        mv version backup > /dev/nul 2>&1
        wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/bin/version > /dev/nul 2>&1
        remote=$(cat version | grep "=" | cut -d '=' -f2)
        core_remote=$(cat version | grep "=" | cut -d '.' -f2)
        msf_remote=$(cat version | grep "=" | cut -d '.' -f3)
        main_remote=$(cat version | grep "=" | cut -d '.' -f1 | cut -d '=' -f2)
        cd .. && cd aux

           if [ "$local" "<" "$remote" ]; then
              echo "    Local version   Remote version   Status"
              echo "    -------------   --------------   ------"
              echo "    $local          $remote            ${GreenF}Updates Available"
              echo "" && echo ""
              sleep 3
                 if [ "$msf_local" "<" "$msf_remote" ]; then
                    echo "[i] Updating post-exploitation modules"
                    echo "[i] ----------------------------------"
                    sleep 2
                    cd .. && cd logs
                    time=$(date | awk {'print $3,$4,$5,$6'})
                    echo "[$time] Updating post-exploitation modules" >> mosquito.log
                    cd .. && cd aux
                    echo "[$time] Updating post-exploitation modules" >> install.log

                    ## Updating msf modules
                    rm -f enum_protections.rb > /dev/nul 2>&1
                    echo "[i] Downloading enum_protections.rb"
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/enum_protections.rb > /dev/nul 2>&1
                    echo "[i] Locate metasploit absoluct path"
                    aV_path=$(locate modules/post/windows/recon | grep -v '\doc' | grep -v '\documentation' | head -n 1) > /dev/nul 2>&1
                    echo "[i] Copy Module to metasploit database"
                    sudo cp $IPATH/enum_protections.rb $aV_path/enum_protections.rb > /dev/nul 2>&1
                    if [ "$?" -eq "1" ]; then
                       echo "[x] [ERROR] enum_protections.rb Fail to copy to: $aV_path"
                    fi

                    rm -f SCRNSAVE_T1180_persistence.rb > /dev/nul 2>&1
                    echo "[i] Downloading SCRNSAVE_T1180_persistence.rb"
                  wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/SCRNSAVE_T1180_persistence.rb > /dev/nul 2>&1
                    echo "[i] Locate metasploit absoluct path"
                  t1180_path=$(locate modules/post/windows/escalate | grep -v '\doc' | grep -v '\documentation' | head -n 1) > /dev/nul 2>&1
                    echo "[i] Copy Module to metasploit database"
                    sudo cp $IPATH/SCRNSAVE_T1180_persistence.rb $t1180_path/SCRNSAVE_T1180_persistence.rb > /dev/nul 2>&1
                    if [ "$?" -eq "1" ]; then
                       echo "[x] [ERROR] SCRNSAVE_T1180_persistence.rb Fail to copy to: $t1180_path"
                    fi

                    rm -f linux_hostrecon.rb > /dev/nul 2>&1
                    echo "[i] Downloading linux_hostrecon.rb"
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/linux_hostrecon.rb > /dev/nul 2>&1
                    echo "[i] Locate metasploit absoluct path"
                    Linux_path=$(locate modules/post/linux/gather | grep -v '\doc' | grep -v '\documentation' | head -n 1) > /dev/nul 2>&1
                    echo "[i] Copy Module to metasploit database"
                    sudo cp $IPATH/linux_hostrecon.rb $Linux_path/linux_hostrecon.rb > /dev/nul 2>&1
                    if [ "$?" -eq "1" ]; then
                       echo "[x] [ERROR] linux_hostrecon.rb Fail to copy to: $Linux_path"
                    fi

                    ## reload msfdb
                    echo "[i] ----------------------------------"
                    echo "[i] Reloading msfdb (reload_all)"
                    sudo service postgresql start > /dev/nul 2>&1
                    sudo msfconsole -q -x 'db_status;reload_all;exit -y'
                    echo ""

                    cd .. && cd bin/wordlists
                    rm -f multi_services_wordlist.txt > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/bin/wordlists/multi_services_wordlist.txt > /dev/nul 2>&1
                    cd ..
                    rm -f backup > /dev/nul 2>&1
                    cd .. && cd aux
                    rm -f recon.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/recon.rc > /dev/nul 2>&1
                    rm -f recon_linux.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/recon_linux.rc > /dev/nul 2>&1
                    echo "[i] Directory: /aux Updated."
                    sleep 1
                    cd $IPATH
                 fi

                 if [ "$core_local" "<" "$core_remote" ]; then
                    echo "[i] Updating Resource files"
                    echo "[i] -----------------------"
                    sleep 2
                    cd .. && cd logs
                    time=$(date | awk {'print $3,$4,$5,$6'})
                    echo "[$time] Updating Resource files" >> mosquito.log
                    cd .. && cd aux
                    echo "[$time] Updating Resource files" >> install.log

                    rm -f *.rc > /dev/nul 2>&1
                    ## Install geo-location plugin
                    imp=`which geoiplookup`
                    if ! [ "$?" -eq "0" ]; then
                       sudo apt-get update && apt-get install geoiplookup > /dev/nul 2>&1
                    fi
                    echo "[i] Updating handler.rc"
                    rm -f handler.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/handler.rc > /dev/nul 2>&1
                    echo "[i] Updating http_CVE.rc"
                    rm -f http_CVE.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/http_CVE.rc > /dev/nul 2>&1
                    echo "[i] Updating manage_db.rc"
                    rm -f manage_db.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/manage_db.rc > /dev/nul 2>&1
                    echo "[i] Updating brute_force.rc"
                    rm -f brute_force.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/brute_force.rc > /dev/nul 2>&1
                    echo "[i] Updating mssql_brute.rc"
                    rm -f mssql_brute.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/mssql_brute.rc > /dev/nul 2>&1
                    echo "[i] Updating mysql_brute.rc"
                    rm -f mysql_brute.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/mysql_brute.rc > /dev/nul 2>&1
                    echo "[i] Updating geo_location.rc"
                    rm -f geo_location.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/geo_location.rc > /dev/nul 2>&1
                    echo "[i] Updating snmp_exploiter.rc"
                    rm -f snmp_exploiter.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/snmp_exploiter.rc > /dev/nul 2>&1
                    echo "[i] Updating post_exploitation.rc"
                    rm -f post_exploitation.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/post_exploitation.rc > /dev/nul 2>&1
                    echo "[i] Updating ms17_010.rc"
                    rm -f ms17_010.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/ms17_010.rc > /dev/nul 2>&1
                    echo "[i] Updating winrm_brute.rc"
                    rm -f winrm_brute.rc > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/winrm_brute.rc > /dev/nul 2>&1
                    cd bin && rm -f backup > /dev/nul 2>&1
                    cd .. && cd aux
                    echo "[i] -----------------------"
                    echo "[i] Directory: /resource_files Updated."
                    sleep 1
                    cd $IPATH
                 fi

                 if [ "$main_local" "<" "$main_remote" ]; then
                    echo "[i] Updating Project core files"
                    echo "[i] ---------------------------"
                    sleep 2
                    cd .. && cd logs
                    time=$(date | awk {'print $3,$4,$5,$6'})
                    echo "[$time] Updating Project core files" >> mosquito.log
                    cd .. && cd aux
                    echo "[$time] Updating Project core files" >> install.log


                    echo "[i] Updating recon.rc"
                    rm -f recon.rc > /dev/nul 2>&1
                    wget -qq https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/recon.rc > /dev/nul 2>&1
                    echo "[i] Updating recon_linux.rc"
                    rm -f recon_linux.rc > /dev/nul 2>&1
                    wget -qq https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/recon_linux.rc > /dev/nul 2>&1

                    ## NMAP NSE SCRIPTS
                    echo ${BlueF}[*]${white} "Downloading nmap nse script(s) from github"${Reset};
                    sleep 2
                    sudo rm -f http-winrm.nse > /dev/nul 2>&1
                    sudo wget -qq https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/http-winrm.nse
                    echo ${BlueF}[*]${white} "Copy module to: /usr/share/nmap/scripts/http-winrm.nse"${Reset};
                    sleep 2
                    sudo cp $IPATH/http-winrm.nse /usr/share/nmap/scripts/http-winrm.nse
                    echo ${YellowF}[i]${white} "Please wait, Updating nse database .."${Reset};

                    echo ${BlueF}[*]${white} "Downloading nmap nse script from github"${Reset};
                    sleep 2
                    sudo rm -f freevulnsearch.nse > /dev/nul 2>&1
                    sudo wget -qq https://raw.githubusercontent.com/OCSAF/freevulnsearch/master/freevulnsearch.nse
                    echo ${BlueF}[*]${white} "Copy module to: /usr/share/nmap/scripts/freevulnsearch.nse"${Reset};
                    sleep 2
                    sudo cp $IPATH/freevulnsearch.nse /usr/share/nmap/scripts/freevulnsearch.nse
                    echo ${YellowF}[i]${white} "Please wait, Updating nse database .."${Reset};
                    sudo nmap --script-updatedb

                    echo ${BlueF}[*]${white} "Downloading nmap nse script from github"${Reset};
                    sleep 2
                    sudo rm -f vulners.nse > /dev/nul 2>&1
                    sudo wget -qq https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/vulners.nse
                    echo ${BlueF}[*]${white} "Copy module to: /usr/share/nmap/scripts/vulners.nse"${Reset};
                    sleep 2
                    sudo cp $IPATH/vulners.nse /usr/share/nmap/scripts/vulners.nse
                    echo ${YellowF}[i]${white} "Please wait, Updating nse database .."${Reset};


                    cd .. && cd bin
                    echo "[i] Updating remote_hosts.txt"
                    rm -f remote_hosts.txt > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/bin/remote_hosts.txt > /dev/nul 2>&1
                    echo "[i] Updating database_Exercise.xml"
                    rm -f database_Exercise.xml > /dev/nul 2>&1
                    wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/bin/database_Exercise.xml > /dev/nul 2>&1
                    cd wordlists
                    echo "[i] Updating multi_services_wordlist.txt"
                    rm -f multi_services_wordlist.txt > /dev/nul 2>&1
                    wget -qq https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/bin/wordlists/multi_services_wordlist.txt > /dev/nul 2>&1
                    cd ..
                    rm -f backup > /dev/nul 2>&1
                    cd .. cd aux
                    echo "[i] ------------------------------------"
                    echo "[i] Directory: /aux and /bin Updated."
                    sleep 1
                 fi
                 fin_time=$(date | awk {'print $4'})
                 echo "[i] Database updated at: $fin_time"



           else
              echo "    Local version   Remote version   Status"
              echo "    -------------   --------------   ------"
              echo "    $local          $remote            ${RedF}None Updates Available"
              echo ""
              cd .. && cd bin
              rm -f version > /dev/nul 2>&1
              mv backup version > /dev/nul 2>&1
              cd .. && cd aux
           fi
        exit
        ;;
        h)
echo "---"
echo ${BlueF}
cat << !
                                                🦟__________       
              _______🦟________________________  ___(_) _  /______ 🦟
           __  __  __ \  __ \_  ___/  __  /  / / /_  /_  __/  __ \\
         🦟_  / / / / / /_/ /(__  )/ /_/ // /_/ /_  / / /_ / /_/ /
           /_/ /_/ /_/\____//____/ \__, / \__,_/ /_/  \__/ \____/v:$ver
                                     /_/ 🦟                             🦟

       Author: r00t-3xp10it
       Suspicious Shell Activity🦟redteam @2019🦟
!
echo ""${Reset};
cat << !
    Script Description:
       This script was written to help users install msf auxiliarys and nmap nse scripts
       that are required by some of the resource scripts of this project, OR check/update
       this project local directory for updates available of my oficial repository (github).
      

       Syntax              Description
       ------------        -----------
       ./install.sh        Install msf_auxiliary|nmap_nse
       ./install.sh -u     Check/Install Project Updates (GitHub)
       ./install.sh -h     This help menu


!
echo "---"
        exit
        ;;
        \?)
        echo "Invalid option: -$OPTARG"; >&2
        exit
        ;;
    esac
done



# ############################################################
#              MAIN FUNCTION BANNER DISPLAY                  #
# ############################################################
Colors;
clear
echo ${BlueF}
cat << !
                                    🦟            __________ 🦟
              _______🦟________________________  ___(_) _  /______ 🦟
       🦟  __  __  __ \  __ \_  ___/  __  /  / / /_  /_  __/  __ \\
           _  / / / / / /_/ /(__  )/ /_/ // /_/ /_  / / /_ / /_/ /
           /_/ /_/ /_/\____//____/ \__, / \__,_/ /_/  \__/ \____/ 🦟
         🦟               🦟         /_/            🦟
            🦟                          🦟

!
sleep 1
## INSTALLING MOSQUITO DEPENDENCIES
echo ${BlueF}[*] "Installing🦟mosquito dependencies .."${Reset};
echo ${BlueF}[${YellowF}i${BlueF}]${white} "Updating packet manager (apt-get) .."${Reset};
sudo apt-get update > /dev/null 2>&1
msf=`which msfconsole`
if [ "$?" -eq "0" ]; then
   echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Metasploit dependencie found => ${GreenF}(no need to install)"${Reset};
   sleep 2
else
   echo ${RedF}[x] "METASPLOIT (msfconsole) dependencie NOT found."${Reset};
   sleep 2
   echo ${BlueF}[${YellowF}i${BlueF}]${white} "PLEASE DOWNLOAD INSTALL METASPLOIT BEFORE USING MOSQUITO."${Reset};
   exit
fi
nap=`which nmap`
if [ "$?" -eq "0" ]; then
   echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Nmap dependencie found => ${GreenF}(no need to install)"${Reset};
   sleep 2
else
   echo ${RedF}[x] "NMAP (framework) dependencie NOT found."${Reset};
   sleep 2
   echo ${BlueF}[${YellowF}i${BlueF}]${white} "Downloading nmap package from network."${Reset};
   sleep 1
   time=$(date | awk {'print $3,$4,$5,$6'})
   echo "[$time] Installing nmap dependencie" >> install.log
   echo "------------------------------------------"
   sudo apt-get install nmap
   echo "------------------------------------------"
fi
zen=`which zenity`
if [ "$?" -eq "0" ]; then
   echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Zenity dependencie found => ${GreenF}(no need to install)"${Reset};
   sleep 2
else
   echo ${RedF}[x] "ZENITY dependencie NOT found."${Reset};
   sleep 2
   echo ${BlueF}[${YellowF}i${BlueF}]${white} "Downloading zenity package from network."${Reset};
   sleep 1
   time=$(date | awk {'print $3,$4,$5,$6'})
   echo "[$time] Installing zenity dependencie" >> install.log
   echo "------------------------------------------"
   sudo apt-get install zenity
   echo "------------------------------------------"
fi
## geo-location plugin
geo=`which geoiplookup`
if [ "$?" -eq "0" ]; then
   echo ${BlueF}[${GreenF}✔${BlueF}]${white} "geoiplookup dependencie found => ${GreenF}(no need to install)"${Reset};
   sleep 2
else
   echo ${RedF}[x] "GEOIPLOOKUP dependencie NOT found."${Reset};
   sleep 2
   echo ${BlueF}[${YellowF}i${BlueF}]${white} "Downloading geoip-bin package from network."${Reset};
   sleep 1
   time=$(date | awk {'print $3,$4,$5,$6'})
   echo "[$time] Installing geoip-bin dependencie" >> install.log
   echo "------------------------------------------"
   sudo apt-get install geoip-bin
   echo "------------------------------------------"
fi
imp=`which dig`
if [ "$?" -eq "0" ]; then
   echo ${BlueF}[${GreenF}✔${BlueF}]${white} "dig dependencie found => ${GreenF}(no need to install)"${Reset};
   sleep 2
else
   echo ${RedF}[x] "DIG dependencie NOT found."${Reset};
   sleep 2
   echo ${BlueF}[${YellowF}i${BlueF}]${white} "Downloading dnsutils package from network."${Reset};
   sleep 1
   time=$(date | awk {'print $3,$4,$5,$6'})
   echo "[$time] Installing dnsutils dependencie" >> install.log
   echo "------------------------------------------"
   sudo apt-get install dnsutils
   echo "------------------------------------------"
fi
cur=`which curl`
if [ "$?" -eq "0" ]; then
   echo ${BlueF}[${GreenF}✔${BlueF}]${white} "curl dependencie found => ${GreenF}(no need to install)"${Reset};
   sleep 2
else
   echo ${RedF}[x] "CURL dependencie NOT found."${Reset};
   sleep 2
   echo ${BlueF}[${YellowF}i${BlueF}]${white} "Downloading curl package from network."${Reset};
   sleep 1
   time=$(date | awk {'print $3,$4,$5,$6'})
   echo "[$time] Installing curl dependencie" >> install.log
   echo "------------------------------------------"
   sudo apt-get install curl
   echo "------------------------------------------"
fi



## INSTALLING METASPLOIT/NMAP DEPENDENCIES
echo -n "${BlueF}[${YellowF}?${BlueF}] Do you wish to install msf/nse modules (y/n): "${Reset}; read op
if [ "$op" = "y" ] || [ "$op" = "Y" ]; then

    Colors;
    echo ${BlueF}[*]${white} "Query msfdb for enum_protections.rb installation .."${Reset};
    aV_path=$(locate modules/post/windows/recon | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${BlueF}[*]${white} "Path: $aV_path/enum_protections.rb"${Reset};
    sleep 2

       if [ -e "$aV_path/enum_protections.rb" ]; then
          echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Metasploit Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${RedF}[x] "Metasploit Post-module NOT found in msfdb."${Reset};
          sleep 2
          echo ${YellowF}[i]${white} "Downloading Metasploit post-module from github"${Reset};
          sleep 1
          sudo rm -f enum_protections.rb
          echo "--------------------------------------------------" && echo ""
          sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/enum_protections.rb
          echo "--------------------------------------------------"
          echo ${BlueF}[*]${white} "Copy module to: $aV_path/enum_protections.rb"${Reset};
          sleep 2
          sudo cp $IPATH/enum_protections.rb $aV_path/enum_protections.rb
          ## module settings (install.log)
          time=$(date | awk {'print $3,$4,$5,$6'})
          echo "[$time] Installing enum_protections dependencie" >> install.log
          fresh="yes"
       fi

    echo ${BlueF}[*]${white} "Query msfdb for SCRNSAVE_T1180_persistence.rb installation .."${Reset};
    t1180_path=$(locate modules/post/windows/escalate | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${BlueF}[*]${white} "Path: $t1180_path/SCRNSAVE_T1180_persistence.rb"${Reset};
    sleep 2

       if [ -e "$t1180_path/SCRNSAVE_T1180_persistence.rb" ]; then
          echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Metasploit Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${RedF}[x] "Metasploit Post-module NOT found in msfdb."${Reset};
          sleep 2
          echo ${YellowF}[i]${white} "Downloading Metasploit post-module from github"${Reset};
          sleep 2
          sudo rm -f SCRNSAVE_T1180_persistence.rb
          echo "--------------------------------------------------" && echo ""
          sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/SCRNSAVE_T1180_persistence.rb
          echo "--------------------------------------------------"
          echo ${BlueF}[*]${white} "Copy module to: $t1180_path/SCRNSAVE_T1180_persistence.rb"${Reset};
          sleep 2
          sudo cp $IPATH/SCRNSAVE_T1180_persistence.rb $t1180_path/SCRNSAVE_T1180_persistence.rb
          ## module settings (install.log)
          time=$(date | awk {'print $3,$4,$5,$6'})
          echo "[$time] Installing SCRNSAVE_T1180 dependencie" >> install.log
          fresh="yes"
       fi

    echo ${BlueF}[*]${white} "Query msfdb for linux_hostrecon.rb installation .."${Reset};
    Linux_path=$(locate modules/post/linux/gather | grep -v '\doc' | grep -v '\documentation' | head -n 1)
    echo ${BlueF}[*]${white} "Path: $Linux_path/linux_hostrecon.rb"${Reset};
    sleep 2

       if [ -e "$Linux_path/linux_hostrecon.rb" ]; then
          echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Metasploit Post-module found in msfdb => ${GreenF}(no need to install)"${Reset};
          sleep 2
       else
          echo ${RedF}[x] "Metasploit Post-module NOT found in msfdb."${Reset};
          sleep 2
          echo ${YellowF}[i]${white} "Downloading Metasploit post-module from github"${Reset};
          sleep 2
          sudo rm -f linux_hostrecon.rb
          echo "--------------------------------------------------" && echo ""
          sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/linux_hostrecon.rb
          echo "--------------------------------------------------"
          echo ${BlueF}[*]${white} "Copy module to: $Linux_path/linux_hostrecon.rb"${Reset};
          sleep 2
          sudo cp $IPATH/linux_hostrecon.rb $Linux_path/linux_hostrecon.rb
          ## module settings (install.log)
          time=$(date | awk {'print $3,$4,$5,$6'})
          echo "[$time] Installing linux_hostrecon dependencie" >> install.log
          fresh="yes"
       fi


    ## Updating msfdb
    if [ "$fresh" = "yes" ]; then
       echo "---"
       echo ${BlueF}[${YellowF}i${BlueF}]${white} "Please wait, Updating msf database .."${Reset};
       sudo service postgresql start
       #sudo msfdb reinit
       sudo msfconsole -q -x 'db_status;reload_all;exit -y'
       echo ""
    fi



    ## NMAP NSE
    echo ${BlueF}[*]${white} "query nmap nse freevulnsearch.nse installation .."${Reset};
    sleep 2
    echo ${BlueF}[*]${white} "Path: /usr/share/nmap/scripts/freevulnsearch.nse"${Reset};
    sleep 1
    if [ -e "/usr/share/nmap/scripts/freevulnsearch.nse" ]; then
       echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Nmap nse script found in database => ${GreenF}(no need to install)"${Reset};
       sleep 2
    else
       echo ${RedF}[x] "Nmap nse script NOT found in database."${Reset};
       sleep 2
       echo ${BlueF}[*]${white} "Downloading nmap nse script from github"${Reset};
       sleep 2
       sudo rm -f freevulnsearch.nse
       echo "------------------------------------------"
       sudo wget https://raw.githubusercontent.com/OCSAF/freevulnsearch/master/freevulnsearch.nse
       echo "------------------------------------------"
       echo ${BlueF}[*]${white} "Copy module to: /usr/share/nmap/scripts/freevulnsearch.nse"${Reset};
       sleep 2
       sudo cp $IPATH/freevulnsearch.nse /usr/share/nmap/scripts/freevulnsearch.nse
       echo ${YellowF}[i]${white} "Please wait, Updating nse database .."${Reset};
       sudo nmap --script-updatedb
       ## module settings (install.log)
       time=$(date | awk {'print $3,$4,$5,$6'})
       echo "[$time] Installing freevulnsearch dependencie" >> install.log
    fi


    echo ${BlueF}[*]${white} "query nmap nse http-winrm.nse installation .."${Reset};
    sleep 2
    echo ${BlueF}[*]${white} "Path: /usr/share/nmap/scripts/http-winrm.nse"${Reset};
    sleep 1
    if [ -e "/usr/share/nmap/scripts/http-winrm.nse" ]; then
       echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Nmap nse script found in database => ${GreenF}(no need to install)"${Reset};
       sleep 2
    else
       echo ${RedF}[x] "Nmap nse script NOT found in database."${Reset};
       sleep 2
       echo ${BlueF}[*]${white} "Downloading nmap nse script from github"${Reset};
       sleep 2
       sudo rm -f http-winrm.nse
       echo "------------------------------------------"
       sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/http-winrm.nse
       echo "------------------------------------------"
       echo ${BlueF}[*]${white} "Copy module to: /usr/share/nmap/scripts/http-winrm.nse"${Reset};
       sleep 2
       sudo cp $IPATH/http-winrm.nse /usr/share/nmap/scripts/http-winrm.nse
       echo ${YellowF}[i]${white} "Please wait, Updating nse database .."${Reset};
       sudo nmap --script-updatedb
       ## module settings (install.log)
       time=$(date | awk {'print $3,$4,$5,$6'})
       echo "[$time] Installing http-winrm dependencie" >> install.log
    fi


    echo ${BlueF}[*]${white} "query nmap nse vulners.nse installation .."${Reset};
    sleep 2
    echo ${BlueF}[*]${white} "Path: /usr/share/nmap/scripts/vulners.nse"${Reset};
    sleep 1
    if [ -e "/usr/share/nmap/scripts/vulners.nse" ]; then
       echo ${BlueF}[${GreenF}✔${BlueF}]${white} "Nmap nse script found in database => ${GreenF}(no need to install)"${Reset};
       sleep 2
    else
       echo ${RedF}[x] "Nmap nse script NOT found in database."${Reset};
       sleep 2
       echo ${BlueF}[*]${white} "Downloading nmap nse script from github"${Reset};
       sleep 2
       sudo rm -f vulners.nse
       echo "------------------------------------------"
       sudo wget https://raw.githubusercontent.com/r00t-3xp10it/resource_files/master/aux/vulners.nse
       echo "------------------------------------------"
       echo ${BlueF}[*]${white} "Copy module to: /usr/share/nmap/scripts/vulners.nse"${Reset};
       sleep 2
       sudo cp $IPATH/vulners.nse /usr/share/nmap/scripts/vulners.nse
       echo ${YellowF}[i]${white} "Please wait, Updating nse database .."${Reset};
       sudo nmap --script-updatedb
       ## module settings (install.log)
       time=$(date | awk {'print $3,$4,$5,$6'})
       echo "[$time] Installing vulners dependencie" >> install.log
    fi

    ## FINAL DISPLAYS
    fds=$(date | awk {'print $4'})
    echo "${BlueF}[${YellowF}$fds${BlueF}] This🦟mosquito its🦟ready to fly🦟"${Reset};
    ## module settings (install.log)
    time=$(date | awk {'print $3,$4,$5,$6'})
    echo "[$time] mosquito core and msf/nmap updated" >> install.log

else

    Colors;
    ## module settings (install.log)
    time=$(date | awk {'print $3,$4,$5,$6'})
    echo "[$time] mosquito core (only) updated" >> install.log
    echo ${RedF}[x] "Aborting installations jobs 🦟Bzzzz.."${Reset};

fi

    if [ "$fresh" = "yes" ]; then
       sudo service postgresql stop
    fi

exit


