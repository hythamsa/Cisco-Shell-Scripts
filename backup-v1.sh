#!/bin/bash

# HA - added transcript session recording "log_file" 30/05/10
# HA - added a simple move of backups into corresponding date 30/05/10
# HA - extract failed backups and email out to team 1/06/10

## To do:  Correct extraction of failed backups.

. /root/.bashrc

# Set user, current and new password variables

usr=<Enter username here>
pass=<Enter password here>
enpass=<Enter enable password here>
srv=<Enter backup server here>
ftpusr=<Enter FTP username here>
ftppass=<Enter FTP password here>
tdate=`date +%Y_%m_%d`

ce=/opt/apps/Scripts/devices
expfile=/opt/apps/Scripts/backup.expect


# Check whether file exists, delete it and then recreate it

if [ -f $expfile ]
  then
    rm $expfile
fi

if [ -f /root/ssh/known_hosts ]
  then
	rm /root/ssh/known_hosts
fi

touch $expfile
chmod 700 $expfile
echo '#!/usr/bin/expect' >> $expfile
echo 'set timeout 7' >> $expfile
echo 'stty -echo' >> $expfile
echo 'log_file -noappend backup.log' >> $expfile
echo "" >> $expfile


# Create the main expect file

for x in `egrep -v "^#" $ce | awk '{print $3}'` 

        do
        c=`egrep -w $x $ce | awk '{print $1}'`
        i=`egrep -w $x $ce | awk '{print $2}'`

case `echo "$c" | tr "[:upper:]" "[:lower:]"` in

telnet-rem)
        echo 'spawn telnet '$i >> $expfile
        echo 'expect  "sername:" { send "'$usr'\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
        echo 'expect "*>" { send "en\r" }' >> $expfile
        echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
		echo 'expect "*#" { send "copy running-config ftp://'$ftpusr':'$ftppass'@'$srv'\r" }' >> $expfile
		echo 'expect "*? " { send "137.66.253.109\r" }' >> $expfile
		echo 'expect "*? " { send "'$x'_'$tdate'\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;

telnet-ios)
	echo 'spawn telnet '$i >> $expfile
	echo 'expect  "sername:" { send "'$usr'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
	echo 'expect "*>" { send "en\r" }' >> $expfile
 	echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
	echo 'expect "*#" { send "copy running-config ftp://'$ftpusr':'$ftppass'@10.1.0.109\r" }' >> $expfile
	echo 'expect "*?" { send "10.1.0.109\r" }' >> $expfile
	echo 'expect "*?" { send "'$x'_'$tdate'\r" }' >> $expfile
	echo 'expect "*#" { send "exit\r" }' >> $expfile
	;;

telnet-sw)
        echo 'spawn telnet '$i >> $expfile
        echo 'expect  "sername:" { send "'$usr'\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
        echo 'expect "*>" { send "en\r" }' >> $expfile
        echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
		echo 'expect "*#" { send "copy running-config ftp://'$ftpusr':'$ftppass'@10.1.0.109\r" }' >>$expfile
		echo 'expect "*?" { send "10.1.0.109\r" }' >> $expfile
		echo 'expect "*?" { send "'$x'_'$tdate'\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;

sshv1-rem)
        echo 'spawn ssh -1 -l '$usr'' $i >> $expfile
        echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
        echo 'expect "*>" { send "en\r" }' >> $expfile
        echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
		echo 'expect "*#" { send "copy running-config ftp://'$ftpusr':'$ftppass'@'$srv'\r" }' >> $expfile
		echo 'expect "*?" { send "137.66.253.109\r" }' >> $expfile
		echo 'expect "*?" { send "'$x'_'$tdate'\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;

sshv2-rem)
        echo 'spawn ssh -l '$usr'' $i >> $expfile
        echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
        echo 'expect "*>" { send "en\r" }' >> $expfile
        echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
		echo 'expect "*#" { send "copy running-config ftp://'$ftpusr':'$ftppass'@'$srv'\r" }' >> $expfile
        echo 'expect "*?" { send "137.66.253.109\r" }' >> $expfile
		echo 'expect "*?" { send '$x'_'$tdate'\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;

sshv2-int)
		echo 'spawn ssh -l '$usr'' $i >> $expfile
        echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
        echo 'expect "*>" { send "en\r" }' >> $expfile
        echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
		echo 'expect "*#" { send "copy running-config ftp://'$ftpusr':'$ftppass'@10.1.0.109\r" }' >> $expfile
		echo 'expect "*?" { send "10.1.0.109\r" }' >> $expfile
		echo 'expect "*?" { send "'$x'_'$tdate'\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;

catos-ssh-int)
	echo 'spawn ssh -l '$usr'' $i >> $expfile
    echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
    echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
	echo 'expect "*>" { send "en\r" }' >> $expfile
	echo 'expect "*password:" { send "'$enpass'\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "copy config ftp all\r" }' >> $expfile
	echo 'expect "*? " { send "10.1.0.109\r" }' >> $expfile
	echo 'expect "*? " { send "'$ftpusr'\r" }' >> $expfile
	echo 'expect "*:" { send "'$ftppass'\r" }' >> $expfile
	echo 'expect "*?" { send "'$x'_'$tdate'\r" }' >> $expfile
	echo 'expect "*?" { send "y\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "exit\r" }' >> $expfile
    echo 'close' >> $expfile
    ;;

catos-telnet)
	echo 'spawn telnet '$i >> $expfile
	echo 'expect "Username:" { send "'$usr'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
	echo 'expect "*>" { send "en\r" }' >> $expfile
	echo 'expect "assword:" { send "'$enpass'\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "copy config ftp all\r" }' >> $expfile
	echo 'expect "*?" { send "10.1.0.109\r" }' >> $expfile
	echo 'expect "*? " { send "'$ftpusr'\r" }' >> $expfile
	echo 'expect "*:" { send "'$ftppass'\r" }' >> $expfile
	echo 'expect "*?" { send "'$x'_'$tdate'\r" }' >> $expfile
	echo 'expect "*?" { send "y\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "exit\r" }' >> $expfile
	echo 'close' >> $expfile
	;;

pix-asa)
	echo 'spawn ssh -l '$usr'' $i >> $expfile
	echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
	echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
	echo 'expect "*>" { send "en\r" }' >> $expfile
	echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
	echo 'expect "*#" { send "copy run ftp://'$ftpusr':'$ftppass'@10.1.0.109\r" }' >> $expfile
	echo 'expect "*?" { send "\r" }' >> $expfile
	echo 'expect "*?" { send "10.1.0.109\r" }' >> $expfile
	echo 'expect "*?" { send "'$ftpusr'\r" } ' >> $expfile
	echo 'expect "*?" { send "'$ftppass'\r" }' >> $expfile
	echo 'expect "*?" { send "'$x'_'$tdate'\r" }' >> $expfile
	echo 'expect "*#" { send "exit\r" }' >> $expfile
	echo 'close' >> $expfile
	;;

esac
done

# Disable logging
echo 'log_file ' >> $expfile

# Create today's directory
mkdir /srv/ftp/backup/`date +%Y_%m_%d`

# Launch script
/usr/bin/expect -f /opt/apps/Scripts/backup.expect

# Move all backups into corresponding date's folder
mv /srv/ftp/backup/*_$tdate /srv/ftp/backup/`date +%Y_%m_%d`

# Extract failed backups
egrep ^Writing backup.log | awk '{print $2}' > backup

# Mail out to network team
cat /opt/apps/Scripts/backup | mail -s "Failed Backups" <network team email address>

# Clean up after yourself
rm backup ; rm backup.log ; rm $expfile 
