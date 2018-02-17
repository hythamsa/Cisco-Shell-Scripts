#!/bin/bash


#################################################################################
# Modify all CE router passwords#
#
#
# Add any new devices to the devices file.  Any device that doest require a
# password change must be preceded with a "#".
#
# To change the passwords, please modify the "newpass" and "newenpass" variables. 
# Once the password has been changed and the script executed, please remember
# to sanitize the file by replacing the variables with temporary placeholders.
#
#################################################################################



# Set user, current and new password variables

usr=<USERNAME>
pass=<CURRENT PASSWORD>
enpass=<CURRENT ENABLE PASSWORD>
newpass=<NEW PASSWORD>
newenpass=<NEW ENABLE PASSWORD>

ce=devices
expfile=/home/hytham/Scripts/PassChange/passchange.expect


# Check whether file exists, delete it and then recreate it

if [ -f $expfile ]
  then
    rm $expfile
fi

touch $expfile
chmod 700 $expfile
echo '#!/usr/bin/expect' >> $expfile
echo 'set timeout 3' >> $expfile
echo 'stty -echo' >> $expfile
echo "" >> $expfile


# Create the main expect file

for x in `egrep -v "^#" $ce | awk '{print $3}'`

        do
        c=`egrep -w $x $ce | awk '{print $1}'`
        i=`egrep -w $x $ce | awk '{print $2}'`

case `echo "$c" | tr "[:upper:]" "[:lower:]"` in

telnet)
        echo 'spawn telnet '$i >> $expfile
        echo 'expect  "sername:" { send "'$usr'\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
        echo 'expect "*>" { send "en\r" }' >> $expfile
        echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
        echo 'expect "*#" { send "conf t\r" }' >> $expfile
        echo 'expect "*#" { send "username vroot privilege 0 password '$newpass'\r" }' >> $expfile
        echo 'expect "*#" { send "enable secret '$newenpass'\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'expect "*#" { send "wr mem\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;

sshv1)
        echo 'spawn ssh -1 -l '$usr'' $i >> $expfile
        echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
        echo 'expect "*>" { send "en\r" }' >> $expfile
        echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
        echo 'expect "*#" { send "conf t\r" }' >> $expfile
        echo 'expect "*#" { send "username vroot privilege 0 password '$newpass'\r" }' >> $expfile
        echo 'expect "*#" { send "enable secret '$newenpass'\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'expect "*#" { send "wr mem\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;
sshv2)
        echo 'spawn ssh -l '$usr'' $i >> $expfile
        echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
        echo 'expect "*>" { send "en\r" }' >> $expfile
        echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
        echo 'expect "*#" { send "conf t\r" }' >> $expfile
        echo 'expect "*#" { send "username vroot privilege 0 password '$newpass'\r" }' >> $expfile
        echo 'expect "*#" { send "enable secret '$newenpass'\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'expect "*#" { send "wr mem\r" }' >> $expfile
        echo 'expect "*#" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;
catos-ssh)
	echo 'spawn ssh -l '$usr'' $i >> $expfile
        echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
        echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
	echo 'expect "*>" { send "en\r" }' >> $expfile
	echo 'expect "*password:" { send "'$enpass'\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "set localuser user vroot password '$newpass' privilege 0\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "set enablepass\r" }' >> $expfile
	echo 'expect "assword:" { send "'$enpass'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$newenpass'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$newenpass'\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "set password\r" }' >> $expfile
	echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$newpass'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$newpass'\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "exit\r" }' >> $expfile
        echo 'close' >> $expfile
        ;;
asa)
	echo 'spawn ssh -l '$usr'' $i >> $expfile
	echo 'expect "*(yes/no)?" { send "yes\r" }' >> $expfile
	echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
	echo 'expect "*>" { send "en\r" }' >> $expfile
	echo 'expect "*Password: " { send "'$enpass'\r" }' >> $expfile
	echo 'expect "*#" { send "conf t\r" }' >> $expfile
	echo 'expect "*#" { send "username vroot password '$newpass' priv 0\r" }' >> $expfile
	echo 'expect "*#" { send "enable password '$newenpass'\r" }' >> $expfile	echo 'expect "*#" { send "exit\r" }' >> $expfile
	echo 'expect "*#" { send "wr mem\r" }' >> $expfile
	echo 'expect "*#" { send "exit\r" }' >> $expfile
	;;
pix)
	echo 'spawn telnet ' $i >> $expfile
	echo 'expect "Password: " { send "'$pass'\r" }' >> $expfile
	echo 'expect "*>" { send "en\r" }' >> $expfile 
	echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
	echo 'expect "*#" { send "conf t\r" }' >> $expfile
	echo 'expect "*#" { send "passwd '$newpass'\r" }' >> $expfile
	echo 'expect "*#" { send "enable pass '$newenpass'\r" }' >> $expfile
	echo 'expect "*#" { send "exit\r" }' >> $expfile
	echo 'expect "*#" { send "wr mem\r" }' >> $expfile
	echo 'expect "*#" { send "exit\r" }' >> $expfile
	;;
catos-telnet)
	echo 'spawn telnet ' $i >> $expfile
	echo 'expect "Username: " { send "'$usr'\r" }' >> $expfile
	echo 'expect "Password: " { send "'$pass'\r" }' >> $expfile
	echo 'expect "*>" { send "en\r" }' >> $expfile
	echo 'expect "Password: " { send "'$enpass'\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "set localuser user vroot password '$newenpass' privilege 0\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "set enablepass\r" }' >> $expfile
	echo 'expect "assword:" { send "'$enpass'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$newenpass'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$newenpass'\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "set password\r" }' >> $expfile
	echo 'expect "assword:" { send "'$pass'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$newpass'\r" }' >> $expfile
	echo 'expect "assword:" { send "'$newpass'\r" }' >> $expfile
	echo 'expect "*\(enable\)" { send "exit\r" }' >> $expfile
	echo 'close' >> $expfile
	;;
esac
done
