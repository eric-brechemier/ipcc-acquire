#! /bin/sh
# Acquire records from 'giec' database for export in TSV format
# acquire2: a set of longer / less frequent exports
#
# USAGE:
# acquire2.sh [user] [host] [password]
# with
#   user - optional, string, database user name, defaults to 'root'
#   host - optional, string, database host name, defaults to 'localhost'
#   password - optional, string, database user password,
#              defaults to 'no password' which provides no password;
#              an empty string results in a prompt for password.
user=${1:-'root'}
host=${2:-'localhost'}
password=${3:-'no password'}

if [ "$password" = 'no password' ]
then
  passwordParam=''
else
  passwordParam="--password $password"
fi

database=ipcc
query="mysql --host $host --user $user $passwordParam"

# change to the script's directory
cd $(dirname $0)

# create output directory
mkdir -p output

acquire()
{
  $query $database \
    < "sql/acquire-$1.sql" \
    > "output/$1.tsv"
}

echo 'Acquire Full Table'
acquire full-table

ls -l -h output
echo 'Export Complete'
