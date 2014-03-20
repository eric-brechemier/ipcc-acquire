#! /bin/sh
# Acquire records from 'giec' database for export in TSV format
#
# USAGE:
# acquire.sh [user] [host] [password]
# with
#   user - optional, string, database user name, defaults to 'root'
#   host - optional, string, database host name, defaults to 'localhost'
#   password - optional, string, database user password, defaults to '';
#              an empty string results in a prompt for password.
user=${1:-root}
host=${2:-localhost}
password=${3:-}

# change to the script's directory
cd $(dirname $0)

echo "Acquire Author Records"
mysql --host "$host" --user "$user" --password "$password" \
  < sql/acquire-author-records.sql \
  > output/authors.tsv

ls -l -h output
echo "Export Complete"
