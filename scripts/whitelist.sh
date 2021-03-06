#!/bin/bash
# Whitelist Updater for Pi-hole (https://pi-hole.net/)
# Based on the original script created by Anudeep (Slight change by cminion) - https://github.com/anudeepND/whitelist
# GSolone - 2020
# Home: https://pihole.noads.it | Blog: https://gioxx.org
#================================================================================

TICK="[\e[32m ✔ \e[0m]"
COL_NC="\e[0m" # No Color
COL_LIGHT_GREEN="\e[1;32m"
COL_LIGHT_RED="\e[1;31m"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -w -q"

if [ "$(id -u)" != "0" ] ; then
	echo "This script requires root permissions. Please run this as root!"
	exit 2
fi

case "$1" in
	safe)
		echo "Download and add safe sites to whitelist (official: anudeepND) ..."
		curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		echo -e " ${TICK} \e[32m Adding to whitelist... \e[0m"
		sleep 0.1
		echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
		mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt

		echo "Download and add safe sites to whitelist (integration: gioxx) ..."
		curl -sS https://raw.githubusercontent.com/gioxx/ph-whitelist/master/domains/whitelist_integrations.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		echo -e " ${TICK} \e[32m Adding to whitelist... \e[0m"
		sleep 0.1
		echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
		mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt

		echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
		${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
		echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
		echo -e " ${TICK} \e[32m Done! \e[0m"
		;;
	referral)
		echo "Download and add referral sites to whitelist ..."
		curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/referral-sites.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		echo -e " ${TICK} \e[32m Adding to whitelist... \e[0m"
		sleep 0.5
		echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
		mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt
		wait
		echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
		${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
		wait
		echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
		echo -e " ${TICK} \e[32m Done! \e[0m"
		;;
	stats)
		echo "Download and add statistics sites to whitelist ..."
		curl -sS https://raw.githubusercontent.com/gioxx/ph-whitelist/master/domains/stats.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		echo -e " ${TICK} \e[32m Adding to whitelist... \e[0m"
		sleep 0.5
		echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
		mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt
		wait
		echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
		${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
		wait
		echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
		echo -e " ${TICK} \e[32m Done! \e[0m"
		;;
	facebook)
		echo "Download and add Facebook sites to whitelist ..."
		curl -sS https://raw.githubusercontent.com/gioxx/ph-whitelist/master/domains/whitelist_facebook.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		echo -e " ${TICK} \e[32m Adding to whitelist... \e[0m"
		sleep 0.5
		echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
		mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt
		wait
		echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
		${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
		wait
		echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
		echo -e " ${TICK} \e[32m Done! \e[0m"
		;;
	trusted)
		echo "Download and add safe, referral and stats lists, exclude Facebook ..."
		curl -sS https://raw.githubusercontent.com/gioxx/ph-whitelist/master/domains/whitelist_integrations.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/referral-sites.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		curl -sS https://raw.githubusercontent.com/gioxx/ph-whitelist/master/domains/stats.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		echo -e " ${TICK} \e[32m Adding to whitelist... \e[0m"
		sleep 0.5
		echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
		mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt
		wait
		echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
		${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
		wait
		echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
		echo -e " ${TICK} \e[32m Done! \e[0m"
		;;
	demo)
		echo "Download and add Demo sites to whitelist ..."
		curl -sS https://raw.githubusercontent.com/gioxx/ph-whitelist/master/domains/HelloWorld.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
		echo -e " ${TICK} \e[32m Adding to whitelist... \e[0m"
		sleep 0.5
		echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
		mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt
		wait
		echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
		${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
		wait
		echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
		echo -e " ${TICK} \e[32m Done! \e[0m"
		;;
	upgrade)
		echo "Upgrade shell script ..."
		wget -N https://pihole.noads.it/whitelist.sh
		chmod +x whitelist.sh
		echo -e " ${TICK} \e[32m Done! \e[0m"
		;;
	clear)
		echo "Clean whitelist ..."
		: > "${PIHOLE_LOCATION}"/whitelist.txt
		echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
		pihole -g
		wait
		echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
		echo -e " ${TICK} \e[32m Done! \e[0m"
		;;
	*)
		echo
		echo -e "
        ${COL_LIGHT_GREEN} .;;,.
        .ccccc:,.
         :cccclll:.      ..,,
          :ccccclll.   ;ooodc
           'ccll:;ll .oooodc
             .;cll.;;looo:.
                 ${COL_LIGHT_RED} .. ','.
                .',,,,,,'.
              .',,,,,,,,,,.
            .',,,,,,,,,,,,....
          ....''',,,,,,,'.......
        .........  ....  .........
        ..........      .......... ph-whitelist for Pi-hole 5.0 (20200511-03)
        ..........      ..........  GSolone - 2020
        .........  ....  .........   https://pihole.noads.it
          ........,,,,,,,'......
            ....',,,,,,,,,,,,.
               .',,,,,,,,,'.
                .',,,,,,'.
                  ..'''.${COL_NC}
		"
		echo "- How to use ph-whitelist -"
		echo "  https://pihole.noads.it/#download"
		echo "  Download and apply whitelists: sudo ./whitelist.sh safe|referral|stats|facebook"
		echo
		echo "- Tools -"
		echo "  sudo ./whitelist.sh trusted (add only trusted lists: safe|referral|stats)"
		echo "  sudo ./whitelist.sh demo (add a demo whitelist for debug)"
		echo "  sudo ./whitelist.sh clear (delete Pi-hole's whitelist content)"
		echo "  sudo ./whitelist.sh upgrade (download latest whitelist.sh from GitHub)"
		echo
		exit 1
		;;
esac
