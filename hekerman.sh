#!/bin/bash

curent_dir=$(pwd)
file_path=$curent_dir/$1-open-ports.txt

if [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Performing nmap --open, then saving to file..."

    nmap --open "$1" 2>/dev/null | awk '/Nmap scan report for/ {ip=$NF} /^[0-9]+\/tcp/ {split($1, a, "/"); print ip ":" a[1]}' > $file_path
    echo -e "File saved to \033[92m$file_path\033[0m"

    if [[ -s "$file_path" ]]; then
        echo -e "\033[92m$(cat $file_path | wc -l)\033[0m ports are open, httpx checking.."
        httpx -l $file_path -silent -sc -title -fhr -fc 501,502,503 -o $file_path.httpx
        cat $file_path.httpx | awk '{print $1}' > $file_path.live
        rm $file_path.httpx
        echo -e "\nLive web are saved to \033[92m$file_path.live\033[0m\n"
        echo -e "Do you want to perform dirsearch ? \033[92m(y/n)\033[0m: \c"
        read dsch
        if [[ "$dsch" =~ ^[Yy]$ ]]; then
                echo -e "\n"
                dirsearch -l $file_path.live --full-url -x 404,501-599 -F -a
        fi
    else
        echo -e "\033[93mNo ports are open, cleaning up..\033[0m"
        rm $file_path*
    fi

else
    echo -e "\033[91mInvalid IP address\033[0m"
fi
