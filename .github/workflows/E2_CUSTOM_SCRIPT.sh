#!/bin/sh
echo $LINE
echo $LINE
echo "#########################################"
echo "#          ZETA E2 Setup Script         #"
echo "#########################################"
echo $LINE
echo $LINE
echo $LINE
echo "DO NOT INTERRUPT UNTIL COMPLETED..."
sleep 5
echo $LINE
echo $LINE
echo "======================================"
echo "I update the environment"
sleep 5
opkg update &> /dev/null 2>&1
opkg install python-image python-imaging python-argparse &> /dev/null 2>&1
echo $LINE
echo $LINE
echo "======================================"
echo "Config Downloading.."
sleep 5
rm -r /usr/lib/enigma2/python/Plugins/Extensions/IPTV_Updater &> /dev/null 2>&1
rm -rf /etc/enigma2/e2m3u2bouquet &> /dev/null 2>&1
mkdir /etc/enigma2/e2m3u2bouquet &> /dev/null 2>&1
cd /etc/enigma2/e2m3u2bouquet
echo $LINE
echo $LINE
echo "======================================"
echo "Installing plugins"
wget -O e2m3u2bouquet.py "https://raw.githubusercontent.com/Pad2k22/E2_CUSTOM_SCRIPT/main/e2m3u2bouquet.py" &> /dev/null 2>&1
chmod 755 e2m3u2bouquet.py
./e2m3u2bouquet.py -m "http://PROVIDER_URL/get.php?username=USERNAME&password=PASSWORD&type=m3u_plus&output=ts&PARAMS" -e "http://PROVIDER_URL/xmltv.php?username=USERNAME&password=PASSWORD" -M &> /dev/null 2>&1
echo $LINE
echo $LINE
echo "======================================"
echo "Download and configure EPG-IMPORT plugin"
sleep 5
opkg install enigma2-plugin-extensions-epgimport &> /dev/null 2>&1
opkg install enigma2-plugin-systemplugins-serviceapp &> /dev/null 2>&1
cd /etc/enigma2/
cd .
sleep 3 
sed -i '$i config.plugins.epgimport.wakeup=5:0' settings 
sed -i '$i config.plugins.epgsearch.numorbpos=0' settings 
sed -i '$i config.plugins.epgimport.longDescDays=5' settings
sed -i '$i config.plugins.e2m3u2b.mainmenu=true' settings
sed -i '$i config.plugins.e2m3u2b.do_epgimport=true' settings
sed -i '$i config.plugins.e2m3u2b.autobouquetupdateatboot=true' settings
sed -i '$i config.plugins.e2m3u2b.autobouquetupdate=true' settings
rm -f /tmp/E2_CUSTOM_SCRIPT.sh &> /dev/null 2>&1
echo $LINE
echo $LINE
echo "======================================"
echo "Download addon for automatic list update every day at 06:00 and 18:00"
sleep 5
opkg install busybox-cron &> /dev/null 2>&1
crontab -r 2>/dev/null
(crontab -l 2>/dev/null; echo '0 6,18 * * * /etc/enigma2/e2m3u2bouquet/e2m3u2bouquet.py -m "http://PROVIDER_URL/get.php?username=USERNAME&password=PASSWORD&type=m3u_plus&output=ts" -e "http://PROVIDER_URL/xmltv.php?username=USERNAME&password=PASSWORD" -M') | crontab -
echo $LINE
echo $LINE
echo "======================================"
echo "INSTALLATION COMPLETED WITH SUCCESS"
echo $LINE
echo "After restarting remember to select the Zeta source via the EPG-IMPORTER plugin to get the epgs"
echo "======================================"
echo $LINE
echo $LINE
echo "The system will restart in 5 seconds..."
sleep 5
reboot
