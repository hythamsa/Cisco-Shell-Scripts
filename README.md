# Cisco Shell Scripts
Collection of shell scripts written during contract engagements to ease the day to day

# Backup Script
Pretty straightforward. Iterate through a file defining ssh version number or telnet (seriously... ) for each device on the network. With this information I could automatically write a unique expect script for each device defined. 

This was written for a customer that ran some incredibly ancient tech (they had a CatOS box running in their environment that had not been reboted in 11 years and you couldn't even use the serial console...). Anyway. Configured to run daily on the LINUX host I set-up for them to use, which would then email failures to network engineering staff.

# Password Change
Again. Very straight forward script written for a customer to manage password changes on the relics they have in their environment. 7 variables that require modification in order to be run correctly. At some point they intend on upgrading their infrastructure to 9Ks and all of that code can be summarized by an Ansible script in its simplest form that is 20 lines long (excluding the length of the hosts file).
