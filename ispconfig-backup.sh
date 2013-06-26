#!/bin/bash


# Required Variables
aREQUIRED=( --run )

# Optional Variables
aOPTIONAL=( --domainfiles --databases --dbrootpasswd --retention --directory --verbose --dryrun )

# This will show when parameter --help is given
EXPLANATION="
*** REQUIRED ***
--run			- y/n		- 	a failsafe
*** OPTIONAL ***              
--domainfiles	- y/n		-	Backup files for all domains
--databases		- y/n		-	Backup all databases
--dbrootpasswd	- string	-	MySQL root password
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

if [ ${domainfiles} ]
then
	if [ ${domainfiles} = "y" ]
	then
		ECHORED "domainfiles"
		# Get list of domains from /var/www
		domainlist=`find /var/www/ -maxdepth 1 -type l`

		# Loop domain list and create .tar.gz files for each
		for domain in ${domainlist[*]}
		do
			command="tar cfz ${backuplocation}/${domain:9}-${timestamp}.tar.gz ${domain}/. > /dev/null 2>&1"
			SHOWIFVERBOSE "${command}"
			DRYRUNOREXECUTE ${command}
		done
	fi
fi

if [ ${databases} ]
then
	if [ ${databases} = "y" ]
	then
		ECHORED "databases"
		# Get list of databases from /var/lib/mysql
		databaselist=`find /var/lib/mysql/ -maxdepth 1 -type d`

		# Loop database list an create .sql.gz files for each
		for database in ${databaselist[*]}
		do
			command="mysqldump -uroot -p${dbrootpasswd} ${database:15} | gzip > ${backuplocation}/${database:15}-${timestamp}.sql.gz"
			SHOWIFVERBOSE "${command}"
			DRYRUNOREXECUTE ${command}
		done
	fi
fi

# Delete older backups
command="find ${backuplocation}/* -mtime +${useretention} -exec rm {} \;"
SHOWIFVERBOSE "${command}"
DRYRUNOREXECUTE ${command}
