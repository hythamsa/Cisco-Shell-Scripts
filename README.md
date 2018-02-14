# Cisco Shell Scripts
Collection of shell scripts written during contract engagements to ease the day to day

# backup-v1.sh
Pretty straightforward. Iterate through a file defining ssh version number or telnet (seriously... ) for each device on the network. With this information I could automatically write a unique expect script for each device defined. 

This was written for a customer that ran some incredibly ancient tech (they had a CatOS box running in their environment that had not been reboted in 11 years and you couldn't even use the serial console...). Anyway. Configured to run daily on the LINUX host I set-up for them to use, which would then email failures to network engineering staff.
