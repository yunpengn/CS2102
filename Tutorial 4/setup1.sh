#!/usr/bin/env bash

# check whether PATH contains cs2102/bin
echo $PATH | grep -q "/home/course/cs2102/bin"
if [ $? -ne 0 ]; then
cat >> ~/.bash_profile <<EOF
PATH=/home/course/cs2102/bin:$PATH
export PATH
EOF
fi

# check whether PATH contains directory for PostgreSQL commands
echo $PATH | grep -q "/usr/local/postgres/10-pgdg/bin/64"
if [ $? -ne 0 ]; then
cat >> ~/.bash_profile <<EOF
PATH=/usr/local/postgres/10-pgdg/bin/64:$PATH
export PATH
EOF
fi


# check whether PostgreSQL environment variables need to be configured
if [ -z $PGUSER ]; then
cat >> ~/.bash_profile <<EOF
export PGUSER=${LOGNAME/-/}
export PGHOST=psql1
export PGDATABASE=cs2102
#export PSQL_EDITOR=/usr/local/bin/nano
#export PSQL_EDITOR=/usr/local/bin/emacs
#export PSQL_EDITOR=/usr/local/bin/vim
EOF
fi


# check whether  ~/.pgpass has been configured
if [ ! -s ~/.pgpass ]; then
	echo "To avoid being prompted for your PostgreSQL password when psql is executed,"
	echo "execute the following command (replace \"alice\" with your PostgreSQL account name, and \"wonderland\" with your PostgreSQL account password):"
	touch ~/.pgpass
	chmod 600 ~/.pgpass
	echo
	echo "echo \"psql1:*:cs2102:alice:wonderland\" >| ~/.pgpass"
	echo
fi


