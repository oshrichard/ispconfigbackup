#!/bin/bash


# Required Variables
aREQUIRED=( --run )

# Optional Variables
aOPTIONAL=( --verbose --dryrun)

# This will show when parameter --help is given
EXPLANATION="
*** REQUIRED ***
--run			- y/n	- 	a failsafe
*** OPTIONAL ***              
--verbose	- y/n		-	Show commands while executing
--dryrun	- y/n		-	Just show list of commands, do nothing
"

# Include
source ../loop-parameters/include.sh

# Required call
LOOPPARAMETERS $@


# Get list of domains from /var/www

# Loop domain list and create .tar.gz files for each

# Get list of databases from /var/lib/mysql

# Loop database list an create .sql.gz files for each

# Echo parameter 1
command="echo ${run}"
SHOWIFVERBOSE "${command}"	
DRYRUNOREXECUTE ${command}




