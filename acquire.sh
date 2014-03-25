#! /bin/sh
# Acquire records from 'giec' database for export in TSV format
#
# USAGE:
# acquire.sh [user] [host] [password]
# with
#   user - optional, string, database user name, defaults to 'root'
#   host - optional, string, database host name, defaults to 'localhost'
#   password - optional, string, database user password,
#              defaults to 'no password' which provides no password;
#              an empty string results in a prompt for password.
user=${1:-'root'}
host=${2:-'localhost'}
password=${3:-'no password'}

if [ "$password" = "no password" ]
then
  passwordParam=''
else
  passwordParam="--password $password"
fi

query="mysql --host $host --user $user $passwordParam"

# change to the script's directory
cd $(dirname $0)

echo "Acquire Author Records"
$query \
  < sql/acquire-author-records.sql \
  > output/authors.tsv

echo "Acquire Working Group Categories"
$query \
  < sql/acquire-working-group-categories.sql \
  > output/working-group-categories.tsv

echo "Acquire Working Group in Assessment Report Categories"
$query \
  < sql/acquire-working-group-in-assessment-report-categories.sql \
  > output/working-group-in-assessment-report-categories.tsv

ls -l -h output
echo "Export Complete"
