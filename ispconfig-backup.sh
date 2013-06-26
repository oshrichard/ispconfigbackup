#!/bin/bash


# Required Variables
aREQUIRED=( --run )

# Optional Variables
aOPTIONAL=( --retention --directory --verbose --dryrun )

# This will show when parameter --help is given
EXPLANATION="
*** REQUIRED ***
--run			- y/n		- 	a failsafe
*** OPTIONAL ***              
--retention		- integer	-	how many days retention of backups to keep, default = 1
--directory		- path		-	If omitted /var/backup (not backups) will be used
--verbose		- y/n		-	Show commands while executing
--dryrun		- y/n		-	Just show list of commands, do nothing
"

# Include
source ../loop-parameters/include.sh

# Required call
LOOPPARAMETERS $@

# Check if retention is given, else default = 1
if [ ${retention} ]
then
	useretention=${retention}
else
	useretention=1
fi

# Check if retention is given, else default = 1
if [ ${directory} ]
then
	backuplocation=${directory}
else
	backuplocation="/var/backup"
fi

# Get list of domains from /var/www
domainlist=`find /var/www/ -maxdepth 1 -type l`

# Loop domain list and create .tar.gz files for each
for domain in ${domainlist[*]}
do
	command="tar cfz ${backuplocation}/${domain:9}-${timestamp}.tar.gz ${domain}/."
	SHOWIFVERBOSE "${command}"
	DRYRUNOREXECUTE ${command}
done

# Get list of databases from /var/lib/mysql

# Loop database list an create .sql.gz files for each

# Delete older backups