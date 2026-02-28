#!/bin/bash
#################### függvények ##############################
install() {			

if [ -f /usr/bin/$app ]; then 

$xterm $app && exit 0 
else

notify-send -i $icon "$app telepítő" "Telepítés folyamatban.\nKérlek,légy türelemmel..."

apt update && apt install $app $app2 $app3 $app4 $app5 $app6 -y && apt update -t testing && apt reinstall -t testing $app $app2 $app3 $app4 $app5 $app6 -y || ( notify-send -i "$app telepítő" "Függőségi problémák\nStabil verzió telepítése..." && apt update && apt reinstall $app $app2 -y)
fi
[ -e /mnt/dm-0 ] && exit 0

notify-send -i $icon "SFS Hordozható verzió készítő" "Ideiglenes fájlok másolása.\nKérlek,légy türelemmel..."

mkdir -p /live/image/live/tmp/sfs/ 
cp -r /mnt/saved/upperdir/usr /live/image/live/tmp/sfs

rsync -aHAX /mnt/saved/upperdir/usr /tmp/sfs/
rsync -aHAX /usr/lib/x86_64-linux-gnu/blas/libblas* /live/image/live/tmp/sfs/usr/lib/x86_64-linux-gnu/		
rsync -aHAX /usr/lib/x86_64-linux-gnu/lapack/liblapack* /live/image/live/tmp/sfs/usr/lib/x86_64-linux-gnu/
rsync -aHAX /usr/lib/x86_64-linux-gnu/librabbitmq* /live/image/live/tmp/sfs/lib/x86_64-linux-gnu/

rm -r /live/image/live/tmp/sfs/usr/bin/udhcpc

if [ -f /live/image/live/tmp/sfs/usr/bin/$app ]; then

mksquashfs /live/image/live/tmp/sfs /live/image/live/$sfs-latest.squashfs -comp lz4 || xterm -hold -e xterm -e mksquashfs /live/image/live/tmp/sfs /live/image/live/$sfs-latest.squashfs -comp lz4

rm -r /mnt/sda1/live/tmp/

notify-send -i $icon "SFS Hordozható verzió készítő" "Hordozható verzió kész.\nA rendszer újraindul 5s múlva!" && sleep 5 && wmreboot
else 
notify-send -i $icon "SFS Hordozható verzió készítő" "Hiba!" && exit 0
fi

}
###################################################################################
curl -s https://www.debian.org/releases/index.en.html \
| sed 's/<[^>]*>/\n/g' \
| sed 's/&mdash;/-/g' \
| sed '/^[[:space:]]*$/d' \
| awk '
/Index of releases/ {flag=1; next}
/Current oldoldstable release/ {print; exit}
flag
' \
| awk '
/^[0-9]+$/ {
    v=$0; getline c; getline r; getline e; getline l; getline el; getline s;
    printf "%-7s %-12s %-12s %-12s %-12s %-12s %s\n", v,c,r,e,l,el,s
}
' \
| (echo "Version CodeName     ReleaseDate  EOL          LTS          ELTS         Status";
   echo "------- ------------ ------------ ------------ ------------ ------------ -------------------------------";
   cat) \
> debian_releases.txt
nano debian_releases.txt

###################################################################################
case "$1" in
mesa_driverek)
		################# mesa_driverek_ellenőrzése #############
		[ -e /mnt/dm-0 ] && exit 0
		[ -f /usr/bin/vainfo ] || notify-send -i /home/1NSN/ikonok/linux.png "Mesa" "Hiányzó driverek..."
;;
brave_verzio)
		###########################  Brave_verzio_ellenorzo   #############################
		[ -e /mnt/dm-0 ] && exit 0
		which "brave-browser-stable" || exit 0
		notify-send -i /opt/brave.com/brave/product_logo_48.png "Brave" "Verzió ellenőrzése folyamatban..."
		apt update
		current_version=$(cat /opt/brave.com/brave/version.txt)
		compare_version=$(apt search brave-browser | sed -n '3p' | awk '{print $2}')

		# Ha nincs új verzió
		if [[ "$current_version" == "$compare_version" ]]; then
		exit 0
		else
		# Ha van új verzió
		notify-send -i /opt/brave.com/brave/product_logo_48.png "Brave" "Újabb verzió érhető el $current_version >> $compare_version"
		fi
;;
firmware_install)
		#########################  Firmware_install  ####################################
		[ -f /tmp/firmware-linux_verzio ] && exit 0
		[ -e /mnt/dm-0 ] && exit 0
		[ -e /live/image/live/99-firmware-linux.squashfs ] && exit 0 ||
		notify-send -i /home/1NSN/ikonok/linux.png "Firmware" "Hiányzó firmware!		Csomagok automatikus telepítése majd a rendszer újraindítása folyamatban..."
		xterm -e apt update
		xterm -e apt install firmware-linux firmware-linux-free firmware-linux-nonfree firmware-realtek -y
		
		mkdir -p /tmp/c/usr/lib/
		mkdir -p /tmp/c/tmp
		
		apt policy firmware-linux | awk 'NR==2 { print $2 }' > /tmp/c/tmp/firmware-linux_verzio
		
		cp -r /mnt/live/memory/changes/upperdir/usr/lib/firmware /tmp/c/usr/lib/

		xterm -e mksquashfs /tmp/c/ /live/image/live/99-firmware-linux.squashfs 
		
		Xdialog --title "Firmware telepítő" --yesno "A rendszer újraindul,zárj be mindent!" 6 65 && wmreboot
;;
firmware_verzio)
		#########################  Firmware  ####################################
		[ -e /live/image/live/99-firmware-linux.squashfs ] || Xdialog --title "Firmware-linux" --msgbox "Hiányzó firmware! \nA letöltése elkezdődik,\nmajd a rendszer újraindul!" 9 60 && /usr/local/sbin/verzio firmware_install
		[ -e /mnt/dm-0 ] && exit 0
		notify-send -i /home/1NSN/ikonok/limbo.png "Teszt Firmware" "Verzió ellenőrzése..."
		apt update
		elozo_verzio=$(cat /tmp/firmware-linux_verzio)
		kovetkezo_verzio=$(apt policy firmware-linux | awk 'NR==5 { print $1 }')
		if [[ "$elozo_verzio" == "$kovetkezo_verzio" ]]; then
		echo "$elozo_verzio"
		echo "$kovetkezo_verzio"
		else
		echo ""
		echo "$elozo_verzio"
		echo "$kovetkezo_verzio"
		echo ""
		notify-send -i /home/1NSN/ikonok/limbo.png "Firmware-linux" "Újabb verzió érhető el $elozo_verzio >> $kovetkezo_verzio"
		fi
;;
brave)	
		########################## brave_installer ###############
		which "brave-browser-stable" && eval run-as-user brave-browser-stable && exit 0 ||
		
		xterm -T "Brave telepítő" -e 
		apt update
		killall brave
		notify-send -i /opt/brave.com/brave/product_logo_48.png "Brave telepítő" "Telepítés folyamatban..."
		xterm -e apt reinstall brave-browser -y  || xterm -hold -e apt reinstall brave-browser -y
		run-as-user brave-browser-stable 
######################## Hordozható_verzió #########################
		[ -e /mnt/dm-0 ] && exit 0
		notify-send -i /opt/brave.com/brave/product_logo_48.png "Brave telepítő" "Hordozható verzió készítés folyamatban..."
		
		mkdir -p /tmp/a/usr/
		mkdir -p /tmp/a/opt/brave.com/
		mkdir -p /tmp/a/root/scriptek/

		cp -r /opt/brave.com/brave/ /tmp/a/opt/brave.com/
		cp -r /mnt/live/memory/changes/upperdir/usr/ /tmp/a/ 

		apt policy brave-browser | sed -n '2p' | awk '{print $2}' > /tmp/a/opt/brave.com/brave/version.txt
		rm -r /live/image/live/13-brave-browser-latest.squashfs

		xterm -e mksquashfs /tmp/a/ /live/image/live/13-brave-browser-latest.squashfs -comp lz4

		Xdialog --title "Brave telepítő" --yesno "A rendszer újraindul,zárj be mindent!" 6 65 && wmreboot
;;
brave_updater)
		########################## Brave_updater ##########################
		xterm -T "Brave frissítő" -e apt update
		killall brave
		apt reinstall brave-browser -y  || xterm -hold -e apt reinstall brave-browser -y
		run-as-user brave-browser-stable 
######################## Hordozható_verzió #########################
		[ -e /mnt/dm-0 ] && exit 0
		
		notify-send -i /opt/brave.com/brave/product_logo_48.png "Brave frissítő" "Hordozható verzió készítése folyamatban..."
		
		mkdir -p /tmp/a/usr/
		mkdir -p /tmp/a/opt/brave.com/
		mkdir -p /tmp/a/root/scriptek/

		cp -r /opt/brave.com/brave/ /tmp/a/opt/brave.com/
		cp -r /mnt/live/memory/changes/upperdir/usr/ /tmp/a/ 

		apt policy brave-browser | sed -n '2p' | awk '{print $2}' > /tmp/a/opt/brave.com/brave/version.txt
		rm -r /live/image/live/13-brave-browser-latest.squashfs

		xterm -e mksquashfs /tmp/a/ /live/image/live/13-brave-browser-latest.squashfs -comp lz4 || xterm -hold -e mksquashfs /tmp/a/ /live/image/live/13-brave-browser-latest.squashfs -comp lz4

		Xdialog --title "Brave frissítő" --yesno "A rendszer újraindul,zárj be mindent!" 6 65 && wmreboot
;;
brave_key)######################## Brave kulcs ###############################
		if curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg; then
		mkdir -p /tmp/brave_key/usr/share/keyrings/
		cp -r /usr/share/keyrings/brave-browser-archive-keyring.gpg /tmp/brave_key/usr/share/keyrings/
		mksquashfs /tmp/brave_key/ /live/image/live/98-brave-keyrings.squashfs
		Xdialog --title "Brave kulcs" --msg "Kész az új kulcs,a rendszer újraindul!" 6 60 && wmreboot
		else
		Xdialog --title "Brave kulcs" --msg "Nem sikerült a kulcs letöltése!" 6 60
		fi
;;
brave_key_delete)####################### Brave kucsl törlése ########################
		rm -r /live/image/live/98-brave-keyrings.squashfs && Xdialog --title "Brave kulcs" --msg "A kulcs törölve,a rendszer újraindul!" 6 60 && wmreboot || xterm -hold -e rm -r /live/image/live/98-brave-keyrings.squashfs
;;
kernel)	
		########################## Kernel #################################
		[ -e /mnt/dm-0 ] && exit 0
		notify-send -i /home/1NSN/ikonok/linux.png "Teszt Linux-image" "Verzió ellenőrzése..."
		apt update -t testing

		# Lekéri a linux-image csomagokat, kiszűri az -rt és -cloud változatokat
		kernels=$(apt-cache search --names-only '^linux-image-[0-9].*-amd64$'| awk '{print $1}' | grep -v -- '-rt' | grep -v -- '-cloud')

		if [ -z "$kernels" ]; then
		notify-send -i /usr/share/icons/hicolor/48x48/apps/kodi.png "Kernel telepítő" "Hordozható verzió készítése..."
		echo "Nem található megfelelő kernel csomag."
		exit 1
		fi

		# Verzió szerint sorba, majd a legfrissebb
		latest=$(echo "$kernels" | sort -V | tail -n 1)
		echo ""
		echo "A legfrissebb kernel csomag: $latest"
		echo ""

		# Kiírja a pontos verziót
		apt-cache policy "$latest" | grep Candidate

		# Jelenlegi futó kernel
		current=$(uname -r)

		echo
		echo "Jelenleg futó kernel: $current"

		# Legfrissebb kernel verziószám kinyerése (pl. linux-image-6.12.38-amd64 → 6.12.38)
		latest_version=$(echo "$latest" | sed 's/linux-image-//; s/-amd64//')

		# Összehasonlítás
		if [[ "$current" == *"$latest_version"* ]]; then  
		exit 0 
		else
		notify-send -i /home/1NSN/ikonok/linux.png "Teszt Linux-image" "Újabb verzió érhető el $current > $latest_version" 
		fi
;;		
mpv)#########################  Mpv  ####################################
sources /usr/bin/vezer.sh
app3="kodi"
app4="mesa-va-drivers"
app5="mesa-vulkan-drivers"
app="vainfo"
sfs="15-kodi-mesa"
xterm="xterm -hold -e"
icon=/home/1NSN/ikonok/mpv.png		
install
;;
qbittorrent)####################### Qbittorrent ############################
sources /usr/bin/vezer.sh
app="qbittorrent"
sfs="16-qbittorrent"
icon=/home/1NSN/ikonok/qbittorrent.png		
install
 ;;
qbittorrent_backup)############ qbittorrent_backup #######################
		mkdir -p /tmp/qbittorrent_backup/root/.local/share/ 
		
		rsync -aHAX /root/.local/share/qBittorrent /tmp/qbittorrent_backup/root/.local/share/
		
		xterm -T "Qbittorrent_backup" -e mksquashfs /tmp/qbittorrent_backup /live/image/live/90-qbittorrent_backup.squashfs -comp lz4 || xterm -hold -e mksquashfs /tmp/qbittorrent_backup /live/image/live/90-qbittorrent_backup.squashfs -comp lz4
		
		Xdialog --title "Qbittorrent_backup" --msg "A rendszer újraindul,zárj be mindent!" 6 60 && wmreboot
;;
kodi)##################################    Kodi    #################################
sources /usr/bin/vezer.sh
app="kodi"
sfs="15-kodi"
icon=/home/1NSN/ikonok/kodi.png		
install
;;
mesa)####################### mesa + vulkan ########################
app="mesa-va-drivers mesa-vulkan-drivers vainfo"
install	
;;
avidemux)
		################ avidemux #################
		[ -f /usr/bin/avidemux3_qt5 ] && avidemux3_qt5 && exit 0 ||
		cd /tmp
		xterm -T "Avidemux" -e wget https://deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb
		xterm -T "Avidemux" -e sudo dpkg -i deb-multimedia-keyring_2024.9.1_all.deb
		echo "deb https://www.deb-multimedia.org bookworm main non-free" | sudo tee /etc/apt/sources.list.d/deb-multimedia.list
		xterm -T "Avidemux" -e apt update
		xterm -T "Avidemux telepítő" -e apt install avidemux -y
		############## hordozható verzio ############
		mkdir -p /tmp/sfs/ 
		rsync -aHAX /mnt/saved/upperdir/usr /tmp/sfs/
		rm -r /tmp/sfs/bin/udhcpc
		
		xterm -T "Avidemux" -e mksquashfs /tmp/sfs /live/image/live/20-avidemux.squashfs -comp lz4 || xterm -hold -e mksquashfs /tmp/sfs /live/image/live/20-avidemux.squashfs -comp lz4
		avidemux
		Xdialog --title "Rendszer újraindítás" --infobox "A rendszer újraindul,zárj be mindent!" 6 60 && exit 0
;;

esac

